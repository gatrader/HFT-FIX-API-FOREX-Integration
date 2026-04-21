//! Authenticated user WebSocket channel — fills → `Position`.
//!
//! Polymarket publishes `trade` and `order` events over
//! `wss://ws-subscriptions-clob.polymarket.com/ws/user` once the
//! client subscribes with L2 credentials. This module:
//!
//!   1. connects + authenticates,
//!   2. subscribes to one or more condition_ids (markets),
//!   3. parses `trade` events and applies the fill delta to a
//!      shared [`Position`]. Two decode paths:
//!        * **maker**: our api_key appears in `maker_orders[].owner`.
//!          Our fill direction is the *opposite* of the taker side.
//!        * **taker**: `trader_side == "TAKER"` and the top-level
//!          `trade_owner` is our api_key. Our fill direction is the
//!          top-level `side` directly; size is the top-level `size`.
//!   4. dedups lifecycle updates of the same trade — Polymarket
//!      emits one event per trade per `status` (MATCHED → MINED →
//!      CONFIRMED). Applying all three to position is a bug; the
//!      first-seen `id` wins.
//!
//! Readiness: `run_with_limit` accepts an optional
//! `oneshot::Sender<()>` that `main`'s startup barrier awaits.
//! The sender is taken when either (a) the first inbound frame
//! arrives, or (b) a short grace window elapses with the socket
//! still open and silent. A Close frame or stream end before the
//! grace window is fail-closed — readiness does NOT fire. The
//! sender is held across reconnect attempts, so a failed first
//! connect does not drop the barrier.

use std::collections::{HashSet, VecDeque};
use std::sync::atomic::{AtomicU32, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant};

use futures_util::{SinkExt, StreamExt};
use parking_lot::{Mutex, RwLock};
use serde::{Deserialize, Serialize};
use tokio::sync::oneshot;
use tokio::time::sleep;
use tokio_tungstenite::tungstenite::Message;

use crate::auth::ApiCredentials;
use crate::order::Side;
use crate::position::Position;
use crate::ws::WsStats;

/// Polymarket user-channel WS endpoint.
pub const USER_WS_URL: &str =
    "wss://ws-subscriptions-clob.polymarket.com/ws/user";

/// Subscribe envelope for the user channel. Auth travels inside
/// the message body rather than as HTTP headers — the WS server
/// accepts the creds on the first frame.
#[derive(Serialize)]
struct UserSubscribeMsg<'a> {
    #[serde(rename = "type")]
    kind: &'a str,
    auth: UserAuth<'a>,
    markets: Vec<&'a str>,
}

#[derive(Serialize)]
struct UserAuth<'a> {
    #[serde(rename = "apiKey")]
    api_key: &'a str,
    secret: &'a str,
    passphrase: &'a str,
}

/// Wire-level trade event. We only decode the fields the fill
/// path needs; extra fields are ignored.
#[derive(Debug, Deserialize)]
struct TradeEvent {
    /// Trade identifier. Stable across the MATCHED → MINED →
    /// CONFIRMED lifecycle emitted by the user channel; used by
    /// dedup so a single fill isn't applied three times.
    #[serde(default)]
    id: Option<String>,
    /// Lifecycle stage: MATCHED, MINED, CONFIRMED. Logged for
    /// observability only — dedup is on `id`, not `status`.
    #[serde(default)]
    status: Option<String>,
    /// Our role in the trade: "TAKER" or "MAKER". Drives which
    /// decode branch is taken. Missing = fall back to the maker
    /// path (backwards compatible with the pre-taker tests).
    #[serde(default)]
    trader_side: Option<String>,
    /// Taker side of the match. Polymarket sends "BUY" or "SELL".
    /// For a maker fill this is the counterparty's side (flip it
    /// to get ours); for a taker fill this IS our side.
    #[serde(default)]
    side: Option<String>,
    /// Top-level fill size in shares, as a string. Only meaningful
    /// on the taker path; maker fills aggregate per-leg amounts.
    #[serde(default)]
    size: Option<String>,
    /// Our api_key if we were on either side of the match. Used
    /// together with `trader_side == "TAKER"` to identify fills
    /// where we were the taker.
    #[serde(default)]
    trade_owner: Option<String>,
    #[serde(default)]
    maker_orders: Vec<MakerEntry>,
}

#[derive(Debug, Deserialize)]
struct MakerEntry {
    /// api_key of the maker for this leg — the field that lets us
    /// filter to our own fills in a shared trade stream.
    #[serde(default)]
    owner: Option<String>,
    /// Shares matched on this leg. Polymarket sends as a string.
    #[serde(default)]
    matched_amount: Option<String>,
}

/// One decoded fill — how many of *our* shares changed hands and
/// in which direction (relative to our Position).
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct FillDelta {
    pub side: Side,
    pub shares: f64,
}

/// Decode a Polymarket user-channel trade event into zero or one
/// `FillDelta`s for our position. Takes the taker branch when the
/// event explicitly flags us as the taker (`trader_side == "TAKER"`
/// and `trade_owner == our_api_key`); otherwise falls back to the
/// maker branch. The maker branch collapses multiple legs against
/// the same owner (partial fills across several of our resting
/// orders in one trade) into a single aggregate delta.
fn decode_trade_for_owner(
    ev: &TradeEvent,
    our_api_key: &str,
) -> Option<FillDelta> {
    // Taker branch: event is our taker fill. Top-level `side` is
    // our side directly, `size` is our shares.
    if matches!(ev.trader_side.as_deref(), Some("TAKER"))
        && ev.trade_owner.as_deref() == Some(our_api_key)
    {
        let our_side = match ev.side.as_deref() {
            Some("BUY") => Side::Buy,
            Some("SELL") => Side::Sell,
            _ => return None,
        };
        let shares = ev.size.as_deref()?.parse::<f64>().ok()?;
        if shares <= 0.0 {
            return None;
        }
        return Some(FillDelta { side: our_side, shares });
    }

    // Maker branch: our fill direction is the *opposite* of the
    // taker-reported side; size is the sum over our maker legs.
    let our_side = match ev.side.as_deref() {
        Some("BUY") => Side::Sell,  // taker bought from us → we sold
        Some("SELL") => Side::Buy,  // taker sold to us   → we bought
        _ => return None,
    };
    let shares: f64 = ev
        .maker_orders
        .iter()
        .filter(|m| m.owner.as_deref() == Some(our_api_key))
        .filter_map(|m| m.matched_amount.as_deref()?.parse::<f64>().ok())
        .sum();
    if shares <= 0.0 {
        return None;
    }
    Some(FillDelta { side: our_side, shares })
}

/// Bounded FIFO dedup cache for trade IDs. Polymarket emits each
/// trade multiple times as its lifecycle progresses through
/// MATCHED → MINED → CONFIRMED; without dedup we'd apply the same
/// fill three times to `Position`. First-seen wins.
const DEDUP_CAP: usize = 256;

pub(crate) struct TradeDedup {
    order: VecDeque<String>,
    set: HashSet<String>,
    cap: usize,
}

impl TradeDedup {
    pub(crate) fn with_capacity(cap: usize) -> Self {
        Self {
            order: VecDeque::with_capacity(cap),
            set: HashSet::with_capacity(cap),
            cap,
        }
    }

    /// Records `id` if not already present. Returns `true` when
    /// freshly inserted (caller should apply), `false` when the
    /// id was already seen (caller should skip).
    pub(crate) fn mark_new(&mut self, id: &str) -> bool {
        if self.set.contains(id) {
            return false;
        }
        if self.order.len() >= self.cap {
            if let Some(old) = self.order.pop_front() {
                self.set.remove(&old);
            }
        }
        self.order.push_back(id.to_string());
        self.set.insert(id.to_string());
        true
    }
}

/// Live-fire schema debug: on the first several incoming messages,
/// dump the raw payload at INFO level so operators can eyeball the
/// actual event_type / side / maker_orders shape on a fresh wallet
/// before trusting the fill path.
const SCHEMA_DEBUG_FRAMES: u32 = 10;

/// Minimum session lifetime before a clean close resets the
/// reconnect-backoff counter. Permanent auth-reject loops close
/// the socket immediately after subscribe; those short-lived Oks
/// must walk the backoff schedule, not reset it.
const HEALTHY_SESSION_MIN: Duration = Duration::from_secs(30);

/// Grace window after `subscribe` send returns Ok, during which the
/// server is given a chance to reject the auth by closing the socket.
/// If no frame and no close arrives within this window, we consider
/// the channel ready — a live Polymarket user channel for a fresh
/// wallet with no resting orders legitimately emits nothing until
/// the first trade/order event.
const READY_GRACE: Duration = Duration::from_millis(1_500);

pub struct UserWsClient {
    creds: Arc<ApiCredentials>,
    markets: Vec<String>,
    position: Position,
    stats: Arc<WsStats>,
    url: String,
    /// Most recent `FillDelta` applied — exposed for tests and a
    /// future observability tick. `None` until the first fill.
    last_fill: Arc<RwLock<Option<FillDelta>>>,
    /// Process-wide raw frame counter so the schema-debug logger
    /// fires on the first few frames overall, not per reconnect.
    frames_seen: Arc<AtomicU32>,
    /// Dedup state for the trade-id lifecycle. Shared behind
    /// `Mutex` (not `RwLock`) because every dispatch both reads
    /// and writes the set atomically.
    trade_dedup: Arc<Mutex<TradeDedup>>,
}

impl UserWsClient {
    pub fn new(
        creds: Arc<ApiCredentials>,
        markets: Vec<String>,
        position: Position,
        stats: Arc<WsStats>,
    ) -> Self {
        Self {
            creds,
            markets,
            position,
            stats,
            url: USER_WS_URL.into(),
            last_fill: Arc::new(RwLock::new(None)),
            frames_seen: Arc::new(AtomicU32::new(0)),
            trade_dedup: Arc::new(Mutex::new(TradeDedup::with_capacity(DEDUP_CAP))),
        }
    }

    pub fn with_url(mut self, url: impl Into<String>) -> Self {
        self.url = url.into();
        self
    }

    pub fn last_fill(&self) -> Option<FillDelta> {
        *self.last_fill.read()
    }

    /// Long-lived reconnect loop. Mirrors `WsClient::run` — same
    /// backoff schedule, same reconnect counter.
    pub async fn run(self) -> anyhow::Result<()> {
        self.run_with_limit(None, None).await
    }

    /// Same as [`run`] but fires `ready` once the authenticated user
    /// channel has connected, sent the subscribe envelope, and
    /// survived a short grace period without a Close/error (or
    /// received its first inbound frame, whichever happens first).
    pub async fn run_with_ready(
        self,
        ready: oneshot::Sender<()>,
    ) -> anyhow::Result<()> {
        self.run_with_limit(None, Some(ready)).await
    }

    pub async fn run_with_limit(
        self,
        max_attempts: Option<u32>,
        ready: Option<oneshot::Sender<()>>,
    ) -> anyhow::Result<()> {
        let mut attempt: u32 = 0;
        // Held across reconnect attempts — `connect_once` borrows
        // it by &mut and only `take()`s when readiness actually
        // fires. A failed first attempt (Err or pre-grace close)
        // therefore leaves the sender in `ready` so the next
        // attempt can still trip the startup barrier.
        let mut ready = ready;
        loop {
            let started = Instant::now();
            match self.connect_once(&mut ready).await {
                Ok(()) => {
                    let lived = started.elapsed();
                    if lived >= HEALTHY_SESSION_MIN {
                        if attempt > 0 {
                            tracing::info!(
                                target: "user_ws",
                                lived_s = lived.as_secs(),
                                prior_attempt = attempt,
                                "user-channel session ended cleanly; resetting backoff"
                            );
                        }
                        attempt = 0;
                    } else {
                        tracing::warn!(
                            target: "user_ws",
                            attempt,
                            lived_ms = lived.as_millis() as u64,
                            "user-channel session closed before \
                             HEALTHY_SESSION_MIN; counting toward backoff"
                        );
                    }
                }
                Err(e) => {
                    tracing::warn!(
                        target: "user_ws",
                        attempt,
                        error = %e,
                        "user-channel connection failed; will retry"
                    );
                }
            }
            self.stats.mark_connected_public(false);
            if let Some(max) = max_attempts {
                if attempt + 1 >= max {
                    return Ok(());
                }
            }
            let wait_ms = 250u64.saturating_mul(1u64 << attempt.min(5)).min(8_000);
            sleep(Duration::from_millis(wait_ms)).await;
            attempt = attempt.saturating_add(1);
        }
    }

    async fn connect_once(
        &self,
        ready: &mut Option<oneshot::Sender<()>>,
    ) -> anyhow::Result<()> {
        let (mut ws, _resp) =
            tokio_tungstenite::connect_async(&self.url).await?;

        let sub = UserSubscribeMsg {
            kind: "user",
            auth: UserAuth {
                api_key: &self.creds.api_key,
                secret: &self.creds.secret,
                passphrase: &self.creds.passphrase,
            },
            markets: self.markets.iter().map(String::as_str).collect(),
        };
        ws.send(Message::Text(serde_json::to_string(&sub)?.into())).await?;

        self.stats.record_reconnect_public();
        self.stats.mark_connected_public(true);
        tracing::info!(
            target: "user_ws",
            url = %self.url,
            markets = self.markets.len(),
            "user channel connected + subscribed"
        );

        // Grace timer starts AFTER subscribe-send succeeds. If the
        // socket is still open and silent when it fires, we consider
        // the channel ready; a Close/error before then exits without
        // firing readiness (fail-closed auth-reject path).
        let grace_fuse = tokio::time::sleep(READY_GRACE);
        tokio::pin!(grace_fuse);
        let mut grace_pending = true;

        loop {
            tokio::select! {
                biased;
                frame_opt = ws.next() => {
                    let Some(frame) = frame_opt else {
                        // Stream ended without a Close frame —
                        // fail-closed.
                        return Ok(());
                    };
                    let msg = frame?;
                    match msg {
                        Message::Text(txt) => {
                            self.stats.record_message_public();
                            if let Some(tx) = ready.take() {
                                let _ = tx.send(());
                            }
                            grace_pending = false;
                            let seen = self.frames_seen.fetch_add(1, Ordering::Relaxed);
                            if seen < SCHEMA_DEBUG_FRAMES {
                                tracing::info!(
                                    target: "user_ws.schema_debug",
                                    frame = seen + 1,
                                    raw = %txt,
                                    "raw user-channel frame"
                                );
                            }
                            self.dispatch(&txt);
                        }
                        Message::Ping(p) => {
                            if let Some(tx) = ready.take() {
                                let _ = tx.send(());
                            }
                            grace_pending = false;
                            ws.send(Message::Pong(p)).await?;
                        }
                        Message::Close(frame) => {
                            let (code, reason) = match &frame {
                                Some(f) => (u16::from(f.code), f.reason.to_string()),
                                None => (0u16, String::new()),
                            };
                            tracing::info!(
                                target: "user_ws",
                                code,
                                reason = %reason,
                                "user-channel closed by peer"
                            );
                            // Fail-closed: do NOT fire readiness on
                            // a pre-grace close.
                            return Ok(());
                        }
                        _ => {}
                    }
                }
                _ = &mut grace_fuse, if grace_pending => {
                    if let Some(tx) = ready.take() {
                        let _ = tx.send(());
                        tracing::info!(
                            target: "user_ws",
                            grace_ms = READY_GRACE.as_millis() as u64,
                            "ready fired after grace (silent-but-open channel)"
                        );
                    }
                    grace_pending = false;
                }
            }
        }
    }

    /// Public for tests — runs the JSON parse + Position apply
    /// path without needing a live socket.
    pub fn dispatch(&self, txt: &str) {
        let Ok(v) = serde_json::from_str::<serde_json::Value>(txt) else {
            return;
        };
        let events: Vec<serde_json::Value> = match v {
            serde_json::Value::Array(a) => a,
            other => vec![other],
        };
        for ev in events {
            // Only trade events move position. Order events (place,
            // cancel) don't alter inventory on their own.
            let Some(ty) = ev.get("event_type").and_then(|x| x.as_str()) else {
                continue;
            };
            if ty != "trade" {
                continue;
            }
            let Ok(trade) = serde_json::from_value::<TradeEvent>(ev) else {
                continue;
            };
            let Some(delta) = decode_trade_for_owner(&trade, &self.creds.api_key)
            else {
                continue;
            };
            // Dedup on trade id: a single fill arrives multiple
            // times as MATCHED → MINED → CONFIRMED. Apply once per
            // id. Trades with no id field fall through (no dedup
            // possible; no observed duplication in that shape).
            if let Some(id) = trade.id.as_deref() {
                let fresh = self.trade_dedup.lock().mark_new(id);
                if !fresh {
                    tracing::debug!(
                        target: "user_ws",
                        trade_id = id,
                        status = trade.status.as_deref().unwrap_or(""),
                        "skipping duplicate trade lifecycle update"
                    );
                    continue;
                }
            }
            self.position.apply_fill(delta.side, delta.shares);
            *self.last_fill.write() = Some(delta);
            tracing::info!(
                target: "user_ws",
                side = ?delta.side,
                shares = delta.shares,
                net_position = self.position.shares(),
                trade_id = trade.id.as_deref().unwrap_or(""),
                status = trade.status.as_deref().unwrap_or(""),
                trader_side = trade.trader_side.as_deref().unwrap_or(""),
                last_fill_age_ms = ?self.position.last_fill_age_ms_opt(),
                "fill applied"
            );
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_creds() -> Arc<ApiCredentials> {
        Arc::new(ApiCredentials {
            api_key: "test-api-key".into(),
            secret: "c2VjcmV0".into(),
            passphrase: "pass".into(),
        })
    }

    fn mk(position: Position) -> UserWsClient {
        UserWsClient::new(
            test_creds(),
            vec!["0xmarket".into()],
            position,
            Arc::new(WsStats::default()),
        )
    }

    #[test]
    fn taker_buy_decrements_position() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        // Taker bought from us → we sold → position decreases.
        let trade = r#"{
            "event_type":"trade",
            "side":"BUY",
            "maker_orders":[
                {"owner":"test-api-key","matched_amount":"3"}
            ]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 7.0);
        assert_eq!(
            c.last_fill(),
            Some(FillDelta { side: Side::Sell, shares: 3.0 })
        );
    }

    #[test]
    fn taker_sell_increments_position() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "side":"SELL",
            "maker_orders":[
                {"owner":"test-api-key","matched_amount":"4.5"}
            ]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 14.5);
    }

    #[test]
    fn ignores_other_participants_on_same_market() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "side":"BUY",
            "maker_orders":[
                {"owner":"not-us","matched_amount":"100"}
            ]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 10.0, "other maker's fill must not move us");
        assert_eq!(c.last_fill(), None);
    }

    #[test]
    fn aggregates_multiple_maker_legs_for_same_owner() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "side":"SELL",
            "maker_orders":[
                {"owner":"test-api-key","matched_amount":"2"},
                {"owner":"test-api-key","matched_amount":"3"}
            ]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 5.0);
    }

    #[test]
    fn filters_out_legs_from_other_owners_in_mixed_trade() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "side":"SELL",
            "maker_orders":[
                {"owner":"test-api-key","matched_amount":"2"},
                {"owner":"someone-else","matched_amount":"50"}
            ]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 2.0);
    }

    #[test]
    fn non_trade_events_are_ignored() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        c.dispatch(r#"{"event_type":"order","status":"LIVE"}"#);
        c.dispatch(r#"{"event_type":"order","status":"CANCELED"}"#);
        assert_eq!(pos.shares(), 10.0);
    }

    #[test]
    fn malformed_payloads_are_silent() {
        let pos = Position::new();
        let c = mk(pos.clone());
        c.dispatch("not json");
        c.dispatch(r#"{"event_type":"trade"}"#);
        c.dispatch(r#"{"event_type":"trade","side":"SIDEWAYS"}"#);
        assert_eq!(pos.shares(), 0.0);
    }

    #[test]
    fn dispatch_accepts_array_batch() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let batch = r#"[
            {"event_type":"order","status":"LIVE"},
            {"event_type":"trade","side":"SELL",
             "maker_orders":[{"owner":"test-api-key","matched_amount":"7"}]}
        ]"#;
        c.dispatch(batch);
        assert_eq!(pos.shares(), 7.0);
    }

    #[test]
    fn zero_matched_amount_does_not_fire() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "side":"SELL",
            "maker_orders":[{"owner":"test-api-key","matched_amount":"0"}]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 0.0);
        assert_eq!(c.last_fill(), None);
    }

    /// Live schema shape captured 2026-04-21: our /order went through
    /// as a taker, `trader_side` == "TAKER", top-level `side` == "BUY",
    /// top-level `size` == our fill, same id replayed MATCHED / MINED /
    /// CONFIRMED. Without a taker branch the fill was silently dropped.
    #[test]
    fn taker_buy_from_live_schema_increments_position() {
        let pos = Position::new();
        pos.seed_shares(-5.0);
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "id":"trade-001",
            "status":"MATCHED",
            "trader_side":"TAKER",
            "side":"BUY",
            "size":"5",
            "trade_owner":"test-api-key",
            "maker_orders":[{"owner":"not-us","matched_amount":"5"}]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 0.0);
        assert_eq!(
            c.last_fill(),
            Some(FillDelta { side: Side::Buy, shares: 5.0 })
        );
    }

    #[test]
    fn taker_sell_from_live_schema_decrements_position() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "id":"trade-002",
            "status":"MATCHED",
            "trader_side":"TAKER",
            "side":"SELL",
            "size":"3",
            "trade_owner":"test-api-key"
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 7.0);
    }

    #[test]
    fn taker_from_other_participant_does_not_move_position() {
        let pos = Position::new();
        let c = mk(pos.clone());
        c.dispatch(r#"{
            "event_type":"trade",
            "id":"trade-003",
            "trader_side":"TAKER",
            "side":"BUY",
            "size":"50",
            "trade_owner":"not-us"
        }"#);
        assert_eq!(pos.shares(), 0.0);
        assert_eq!(c.last_fill(), None);
    }

    #[test]
    fn repeated_trade_id_lifecycle_applies_once() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let matched = r#"{
            "event_type":"trade",
            "id":"trade-abc",
            "status":"MATCHED",
            "trader_side":"TAKER",
            "side":"BUY",
            "size":"5",
            "trade_owner":"test-api-key"
        }"#;
        let mined = r#"{
            "event_type":"trade",
            "id":"trade-abc",
            "status":"MINED",
            "trader_side":"TAKER",
            "side":"BUY",
            "size":"5",
            "trade_owner":"test-api-key"
        }"#;
        let confirmed = r#"{
            "event_type":"trade",
            "id":"trade-abc",
            "status":"CONFIRMED",
            "trader_side":"TAKER",
            "side":"BUY",
            "size":"5",
            "trade_owner":"test-api-key"
        }"#;
        c.dispatch(matched);
        c.dispatch(mined);
        c.dispatch(confirmed);
        assert_eq!(pos.shares(), 5.0);
    }

    #[test]
    fn distinct_trade_ids_both_apply() {
        let pos = Position::new();
        let c = mk(pos.clone());
        let t = |id: &str| format!(
            r#"{{
                "event_type":"trade",
                "id":"{id}",
                "status":"MATCHED",
                "trader_side":"TAKER",
                "side":"BUY",
                "size":"2",
                "trade_owner":"test-api-key"
            }}"#,
        );
        c.dispatch(&t("trade-1"));
        c.dispatch(&t("trade-2"));
        assert_eq!(pos.shares(), 4.0);
    }

    #[test]
    fn maker_path_still_applies_after_refactor() {
        let pos = Position::new();
        pos.seed_shares(10.0);
        let c = mk(pos.clone());
        let trade = r#"{
            "event_type":"trade",
            "id":"maker-trade-1",
            "status":"MATCHED",
            "trader_side":"MAKER",
            "side":"BUY",
            "trade_owner":"test-api-key",
            "maker_orders":[{"owner":"test-api-key","matched_amount":"4"}]
        }"#;
        c.dispatch(trade);
        assert_eq!(pos.shares(), 6.0);
    }

    #[test]
    fn dedup_cache_respects_capacity_bound() {
        let mut d = TradeDedup::with_capacity(2);
        assert!(d.mark_new("a"));
        assert!(d.mark_new("b"));
        assert!(!d.mark_new("a"));
        assert!(d.mark_new("c"));
        assert!(d.mark_new("a"));
    }

    #[test]
    fn unknown_event_types_are_ignored_but_do_not_crash() {
        let pos = Position::new();
        let c = mk(pos.clone());
        c.dispatch(r#"{"event_type":"TRADE","side":"SELL"}"#);
        c.dispatch(r#"{"event_type":"fee_change","bps":200}"#);
        c.dispatch(r#"{"event_type":null}"#);
        assert_eq!(pos.shares(), 0.0);
    }
}
