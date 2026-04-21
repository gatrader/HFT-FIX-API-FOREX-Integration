//! Authenticated user WebSocket channel — fills → `Position`.
//!
//! Polymarket publishes `trade` and `order` events over
//! `wss://ws-subscriptions-clob.polymarket.com/ws/user` once the
//! client subscribes with L2 credentials. This module:
//!
//!   1. connects + authenticates,
//!   2. subscribes to one or more condition_ids (markets),
//!   3. parses `trade` events and applies the maker-side fill
//!      delta to a shared [`Position`].
//!
//! The side convention in Polymarket's trade events is the
//! *taker*'s side. For a maker-quoter this is the opposite of
//! our fill direction:
//!
//!   taker SELL → our maker order BOUGHT  (position ++)
//!   taker BUY  → our maker order SOLD    (position --)
//!
//! Only `maker_orders` entries whose `owner` matches our api_key
//! (or whose `maker_address` matches our signer) are applied —
//! the same event stream carries other market participants' trades
//! on the same condition_id.

use std::sync::Arc;
use std::time::Duration;

use futures_util::{SinkExt, StreamExt};
use parking_lot::RwLock;
use serde::{Deserialize, Serialize};
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
    /// Taker side. Polymarket sends "BUY" or "SELL".
    #[serde(default)]
    side: Option<String>,
    /// Our api_key if we were on either side of the match.
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
/// `FillDelta`s for our position. Multiple maker legs on the same
/// trade (partial fills across several of our resting orders)
/// collapse into one aggregate delta.
///
/// Returns `None` when:
///   - the event contains no `maker_orders` for our api_key,
///   - the taker side is missing or unparseable,
///   - every matched_amount is zero / unparseable.
fn decode_trade_for_owner(
    ev: &TradeEvent,
    our_api_key: &str,
) -> Option<FillDelta> {
    // Our fill direction is the *opposite* of the taker side.
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
        // Either no legs matched ours, or all amounts unparseable.
        // Falling back to `trade_owner`-only would over-apply on
        // trades where we were the taker; we never are in this
        // strategy, so leaving that path off.
        let _ = ev.trade_owner.as_deref();
        return None;
    }

    Some(FillDelta { side: our_side, shares })
}

pub struct UserWsClient {
    creds: Arc<ApiCredentials>,
    markets: Vec<String>,
    position: Position,
    stats: Arc<WsStats>,
    url: String,
    /// Most recent `FillDelta` applied — exposed for tests and a
    /// future observability tick. `None` until the first fill.
    last_fill: Arc<RwLock<Option<FillDelta>>>,
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
        self.run_with_limit(None).await
    }

    pub async fn run_with_limit(
        self,
        max_attempts: Option<u32>,
    ) -> anyhow::Result<()> {
        let mut attempt: u32 = 0;
        loop {
            if let Err(e) = self.connect_once().await {
                tracing::warn!(
                    target: "user_ws",
                    attempt,
                    error = %e,
                    "user-channel connection failed; will retry"
                );
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

    async fn connect_once(&self) -> anyhow::Result<()> {
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

        while let Some(frame) = ws.next().await {
            let msg = frame?;
            match msg {
                Message::Text(txt) => {
                    self.stats.record_message_public();
                    self.dispatch(&txt);
                }
                Message::Ping(p) => ws.send(Message::Pong(p)).await?,
                Message::Close(_) => return Ok(()),
                _ => {}
            }
        }
        Ok(())
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
            self.position.apply_fill(delta.side, delta.shares);
            *self.last_fill.write() = Some(delta);
            tracing::info!(
                target: "user_ws",
                side = ?delta.side,
                shares = delta.shares,
                net_position = self.position.shares(),
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
        // Taker sold to us → we bought → position increases.
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
        // Partial fills across two of our resting orders in the
        // same trade — collapse into one delta.
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
        c.dispatch(r#"{"event_type":"trade"}"#); // missing side + legs
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
}
