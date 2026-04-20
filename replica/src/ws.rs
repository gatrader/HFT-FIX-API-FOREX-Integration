//! WebSocket market ingest — PR2/5 on the arch-shift branch.
//!
//! Subscribes to the Polymarket CLOB **market** channel and pushes
//! full-book snapshots into the shared `book_cache`. Fills (user
//! channel) stay on the existing REST path by design: one new
//! failure surface at a time.
//!
//! Deltas (event_type `price_change`, `last_trade_price`, …) are
//! deliberately ignored in this pass. Full snapshots keep the cache
//! correct on every "book" event; applying deltas is a follow-up
//! micro-PR that only matters once WS tick rate dominates.
//!
//! Gated behind `--features ws`. The default build is unchanged,
//! so `cargo test` on the default feature set stays fast and
//! tungstenite doesn't land in CI unless the WS path is in scope.

use std::sync::atomic::{AtomicBool, AtomicI64, AtomicU64, Ordering};
use std::sync::Arc;
use std::time::Duration;

use futures_util::{SinkExt, StreamExt};
use parking_lot::RwLock;
use serde::{Deserialize, Serialize};
use tokio::time::sleep;
use tokio_tungstenite::tungstenite::Message;

use crate::book::{BookLevel, BookSnapshot};

/// Polymarket CLOB market-channel WS endpoint.
pub const WS_URL: &str = "wss://ws-subscriptions-clob.polymarket.com/ws/market";

/// Runtime-observable counters + gauges for the WS ingest task.
///
/// Required counters per the arch-shift spec (reviewer request):
///   - ws_connected                (gauge 0/1)
///   - ws_reconnect_count          (monotonic counter)
///   - last_ws_message_age_ms      (gauge, None until first msg)
///   - ws_fallback_to_rest_count   (monotonic counter, incremented
///                                  by the runtime loop when it sees
///                                  a stale WS cache and falls back
///                                  to `fetch_book`)
///
/// All fields are `Atomic*` so the runtime loop can read them
/// without locking against the ingest task.
#[derive(Debug)]
pub struct WsStats {
    connected: AtomicBool,
    reconnect_count: AtomicU64,
    /// Wall-clock ms of the most recent inbound message.
    /// `-1` encodes "never" so we don't need `Option` in atomics.
    /// (The `Default` for `AtomicI64` is 0, which would be 1970 —
    /// technically valid — so we override `Default` here.)
    last_message_unix_ms: AtomicI64,
    fallback_to_rest_count: AtomicU64,
}

impl Default for WsStats {
    fn default() -> Self {
        Self {
            connected: AtomicBool::new(false),
            reconnect_count: AtomicU64::new(0),
            last_message_unix_ms: AtomicI64::new(-1),
            fallback_to_rest_count: AtomicU64::new(0),
        }
    }
}

impl WsStats {
    pub fn ws_connected(&self) -> bool {
        self.connected.load(Ordering::Relaxed)
    }

    pub fn ws_reconnect_count(&self) -> u64 {
        self.reconnect_count.load(Ordering::Relaxed)
    }

    /// Age of the last inbound WS message in ms, or `None` if the
    /// socket has not yet received any message. Used by the runtime
    /// loop to decide whether to trust the WS cache.
    pub fn last_ws_message_age_ms(&self) -> Option<u64> {
        let t = self.last_message_unix_ms.load(Ordering::Relaxed);
        if t < 0 {
            return None;
        }
        let now = chrono::Utc::now().timestamp_millis();
        Some((now - t).max(0) as u64)
    }

    pub fn ws_fallback_to_rest_count(&self) -> u64 {
        self.fallback_to_rest_count.load(Ordering::Relaxed)
    }

    /// Called by the runtime loop (NOT the ingest task) when it
    /// observes a stale WS cache and issues a REST fetch_book.
    pub fn record_fallback_to_rest(&self) {
        self.fallback_to_rest_count.fetch_add(1, Ordering::Relaxed);
    }

    fn mark_connected(&self, v: bool) {
        self.connected.store(v, Ordering::Relaxed);
    }

    fn record_reconnect(&self) {
        self.reconnect_count.fetch_add(1, Ordering::Relaxed);
    }

    fn record_message(&self) {
        self.last_message_unix_ms.store(
            chrono::Utc::now().timestamp_millis(),
            Ordering::Relaxed,
        );
    }
}

#[derive(Serialize)]
struct SubscribeMsg<'a> {
    #[serde(rename = "type")]
    kind: &'a str,
    assets_ids: Vec<&'a str>,
}

/// Polymarket emits several `event_type` variants. We care about
/// "book" (full snapshot) for PR 2; deltas get the `Unknown` fallback.
#[derive(Debug, Deserialize)]
#[serde(tag = "event_type")]
enum MarketEvent {
    #[serde(rename = "book")]
    Book(BookEvent),
    #[serde(other)]
    Unknown,
}

#[derive(Debug, Deserialize)]
struct BookEvent {
    #[serde(default)]
    bids: Vec<WsLevel>,
    #[serde(default)]
    asks: Vec<WsLevel>,
}

#[derive(Debug, Deserialize)]
struct WsLevel {
    price: String,
    size: String,
}

fn level_into(l: WsLevel) -> Option<BookLevel> {
    Some(BookLevel {
        price: l.price.parse().ok()?,
        size: l.size.parse().ok()?,
    })
}

pub struct WsClient {
    token_ids: Vec<String>,
    book_cache: Arc<RwLock<BookSnapshot>>,
    stats: Arc<WsStats>,
    url: String,
}

impl WsClient {
    pub fn new(
        token_ids: Vec<String>,
        book_cache: Arc<RwLock<BookSnapshot>>,
        stats: Arc<WsStats>,
    ) -> Self {
        Self {
            token_ids,
            book_cache,
            stats,
            url: WS_URL.into(),
        }
    }

    /// Override the endpoint URL (used by the integration test to
    /// point at a localhost server).
    pub fn with_url(mut self, url: impl Into<String>) -> Self {
        self.url = url.into();
        self
    }

    pub fn stats(&self) -> Arc<WsStats> {
        self.stats.clone()
    }

    /// Long-lived reconnect loop. Returns only if `max_attempts`
    /// is reached (tests) or the containing task is dropped.
    ///
    /// Backoff schedule (ms): 250, 500, 1000, 2000, 4000, then
    /// capped at 8000; jittered by up to 25% of base.
    pub async fn run(self) -> anyhow::Result<()> {
        self.run_with_limit(None).await
    }

    /// Bounded variant used by tests so they don't hang forever
    /// on a misconfigured server. `None` = loop forever.
    pub async fn run_with_limit(
        self,
        max_attempts: Option<u32>,
    ) -> anyhow::Result<()> {
        let mut attempt: u32 = 0;
        loop {
            match self.connect_once().await {
                Ok(()) => {
                    // Clean server-side close. Reset the backoff.
                    attempt = 0;
                }
                Err(e) => {
                    tracing::warn!(
                        target: "ws",
                        attempt,
                        error = %e,
                        "connection attempt failed; will retry"
                    );
                }
            }
            self.stats.mark_connected(false);
            if let Some(max) = max_attempts {
                if attempt + 1 >= max {
                    return Ok(());
                }
            }
            let wait_ms = backoff_ms(attempt);
            sleep(Duration::from_millis(wait_ms)).await;
            attempt = attempt.saturating_add(1);
        }
    }

    async fn connect_once(&self) -> anyhow::Result<()> {
        let (mut ws, _resp) =
            tokio_tungstenite::connect_async(&self.url).await?;

        let sub = SubscribeMsg {
            kind: "market",
            assets_ids: self.token_ids.iter().map(String::as_str).collect(),
        };
        ws.send(Message::Text(serde_json::to_string(&sub)?.into()))
            .await?;

        self.stats.record_reconnect();
        self.stats.mark_connected(true);
        tracing::info!(
            target: "ws",
            url = %self.url,
            tokens = self.token_ids.len(),
            "connected + subscribed"
        );

        while let Some(frame) = ws.next().await {
            let msg = frame?;
            match msg {
                Message::Text(txt) => {
                    self.stats.record_message();
                    self.dispatch(&txt);
                }
                Message::Ping(p) => {
                    ws.send(Message::Pong(p)).await?;
                }
                Message::Close(_) => return Ok(()),
                _ => {}
            }
        }
        Ok(())
    }

    fn dispatch(&self, txt: &str) {
        // Polymarket sometimes batches events as a JSON array.
        // Accept both shapes; ignore malformed payloads silently
        // (noisy logs hurt more than they help for unknown events).
        let Ok(v) = serde_json::from_str::<serde_json::Value>(txt) else {
            return;
        };
        let events: Vec<serde_json::Value> = match v {
            serde_json::Value::Array(a) => a,
            other => vec![other],
        };
        for ev in events {
            let Ok(evt) = serde_json::from_value::<MarketEvent>(ev) else {
                continue;
            };
            if let MarketEvent::Book(b) = evt {
                self.apply_book(b);
            }
        }
    }

    fn apply_book(&self, b: BookEvent) {
        let mut snap = BookSnapshot {
            bids: b.bids.into_iter().filter_map(level_into).collect(),
            asks: b.asks.into_iter().filter_map(level_into).collect(),
            last_updated_at: None,
        };
        snap.stamp_now();
        *self.book_cache.write() = snap;
    }
}

fn backoff_ms(attempt: u32) -> u64 {
    // 250 * 2^n, capped at 8000, plus up to +25% jitter.
    let base = 250u64.saturating_mul(1u64 << attempt.min(5));
    let base = base.min(8_000);
    let jitter = rand::random::<u64>() % (base / 4 + 1);
    base.saturating_add(jitter).min(10_000)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn stats_defaults_reasonable() {
        let s = WsStats::default();
        assert!(!s.ws_connected());
        assert_eq!(s.ws_reconnect_count(), 0);
        assert!(s.last_ws_message_age_ms().is_none());
        assert_eq!(s.ws_fallback_to_rest_count(), 0);
    }

    #[test]
    fn stats_fallback_counter_increments() {
        let s = WsStats::default();
        s.record_fallback_to_rest();
        s.record_fallback_to_rest();
        assert_eq!(s.ws_fallback_to_rest_count(), 2);
    }

    #[test]
    fn stats_message_age_advances() {
        let s = WsStats::default();
        s.record_message();
        // Age must be finite and small immediately after recording.
        let age = s.last_ws_message_age_ms().expect("recorded");
        assert!(age < 500, "expected small age, got {age}");
    }

    #[test]
    fn dispatch_book_updates_cache_and_stamps() {
        let cache = Arc::new(RwLock::new(BookSnapshot::default()));
        let stats = Arc::new(WsStats::default());
        let c = WsClient::new(vec!["abc".into()], cache.clone(), stats);
        let txt = r#"{"event_type":"book","bids":[{"price":"0.49","size":"100"}],"asks":[{"price":"0.51","size":"200"}]}"#;
        c.dispatch(txt);
        let r = cache.read();
        assert_eq!(r.best_bid(), Some(0.49));
        assert_eq!(r.best_ask(), Some(0.51));
        assert!(r.last_updated_at.is_some(), "cache should be stamped");
    }

    #[test]
    fn dispatch_ignores_unknown_event() {
        let cache = Arc::new(RwLock::new(BookSnapshot::default()));
        let stats = Arc::new(WsStats::default());
        let c = WsClient::new(vec!["abc".into()], cache.clone(), stats);
        let txt = r#"{"event_type":"price_change","data":{}}"#;
        c.dispatch(txt);
        assert!(cache.read().last_updated_at.is_none());
    }

    #[test]
    fn dispatch_ignores_malformed_payload() {
        let cache = Arc::new(RwLock::new(BookSnapshot::default()));
        let stats = Arc::new(WsStats::default());
        let c = WsClient::new(vec!["abc".into()], cache.clone(), stats);
        c.dispatch("not json at all");
        assert!(cache.read().last_updated_at.is_none());
    }

    #[test]
    fn dispatch_accepts_array_batch() {
        let cache = Arc::new(RwLock::new(BookSnapshot::default()));
        let stats = Arc::new(WsStats::default());
        let c = WsClient::new(vec!["abc".into()], cache.clone(), stats);
        let txt = r#"[
            {"event_type":"price_change","data":{}},
            {"event_type":"book","bids":[{"price":"0.48","size":"1"}],"asks":[{"price":"0.52","size":"2"}]}
        ]"#;
        c.dispatch(txt);
        assert_eq!(cache.read().best_bid(), Some(0.48));
    }

    #[test]
    fn backoff_is_bounded_and_monotone_ish() {
        // At minimum, attempt 5+ should cap at <= 10s (base 8s + 25% jitter).
        for n in 0..20 {
            let b = backoff_ms(n);
            assert!(b <= 10_000, "backoff should cap, got {b} at attempt {n}");
        }
        // Early attempts should be fast.
        assert!(backoff_ms(0) < 400);
    }
}
