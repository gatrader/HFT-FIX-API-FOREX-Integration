//! Runtime decision loop — PR3/5 on the arch-shift branch.
//!
//! Replaces the one-shot `SpreadCapture::tick` dispatch path. A
//! single task ticks on a configurable cadence (100–250 ms), reads
//! the shared book_cache, runs the pure `decide()` function from
//! state_machine, and then either emits an order (subject to
//! throttle/dedup) or skips.
//!
//! Scope constraints (reviewer-imposed):
//!  1. REST path remains the rollback default; WS ingest is gated
//!     behind `--realtime` (which itself requires `--features ws`).
//!  2. No fills / user-channel expansion. net_position is held as
//!     a runtime field with a setter; future PRs can feed fills.
//!  3. No strategy-logic rewrite. `decide()` is unchanged; this
//!     module only changes *when* and *how often* it is called,
//!     plus adds a post-decision throttle.
//!  4. Runtime-only observability: tick cadence, dedup count,
//!     throttle drops, last decision age, last submit age. WS
//!     stats live in `src/ws.rs`; freshness fallbacks increment
//!     `WsStats::record_fallback_to_rest`.
//!
//! The whole module is REST-safe: if `ws_stats` is `None` the loop
//! falls through to REST on every stale tick exactly as the legacy
//! path did, just on a faster cadence.

use std::collections::VecDeque;
use std::sync::atomic::{AtomicI64, AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant};

use alloy_primitives::U256;
use parking_lot::RwLock;
use tokio::time::{interval, MissedTickBehavior};

use crate::book::BookSnapshot;
use crate::client::TradingClient;
use crate::order::Side;
use crate::state_machine::{Decision, SpreadCapture, Tick};

#[cfg(feature = "ws")]
use crate::ws::WsStats;

/// Tuning knobs. Defaults chosen for a first realistic pass; all
/// values are CLI-overridable on the `runtime` subcommand.
#[derive(Debug, Clone)]
pub struct RuntimeConfig {
    /// Decision cadence. User spec: 100–250 ms. Default 150 ms
    /// sits inside that band.
    pub tick_interval_ms: u64,

    /// Beyond this book age, the loop considers the cache stale
    /// and falls back to a REST fetch_book (which stamps the
    /// snapshot fresh). Default 1000 ms — tight enough to catch
    /// a WS stall, loose enough to tolerate one missed delta.
    pub book_max_age_ms: u64,

    /// Dedup window: a second decision with the same
    /// (side, price_bucket, size_bucket) within this many ms of
    /// the last successful submit is suppressed.
    pub dedup_window_ms: u64,

    /// Maximum submits allowed in any 1-second rolling window.
    /// Hard cap — submits above this are dropped and counted in
    /// `throttle_drops`.
    pub submit_budget_per_sec: u32,

    /// Price granularity for dedup bucketing (in price units).
    /// 0.001 ≈ 10bps — two orders at 0.500 and 0.5004 collide.
    pub price_bucket: f64,

    /// Size granularity for dedup bucketing (in shares).
    pub size_bucket: f64,
}

impl Default for RuntimeConfig {
    fn default() -> Self {
        Self {
            tick_interval_ms: 150,
            book_max_age_ms: 1_000,
            dedup_window_ms: 500,
            submit_budget_per_sec: 5,
            price_bucket: 0.001,
            size_bucket: 1.0,
        }
    }
}

/// Runtime-observable counters. All five fields the reviewer
/// explicitly called out:
///  - tick cadence  (`observed_tick_us`, updated each loop)
///  - dedup count   (`dedup_count`)
///  - throttle drops (`throttle_drops`)
///  - last decision age (`last_decision_unix_ms` → age via `now - x`)
///  - last submit age   (`last_submit_unix_ms` → same)
#[derive(Debug)]
pub struct RuntimeStats {
    tick_count: AtomicU64,
    /// Most recent observed gap between ticks in µs. One-shot
    /// rolling sample (not a histogram) to keep hot-path cost
    /// to a single atomic store.
    observed_tick_us: AtomicU64,
    dedup_count: AtomicU64,
    throttle_drops: AtomicU64,
    /// Unix ms of the most recent completed `decide()`. `-1` = never.
    last_decision_unix_ms: AtomicI64,
    /// Unix ms of the most recent *attempted* submit (regardless of
    /// success). `-1` = never.
    last_submit_unix_ms: AtomicI64,
}

impl Default for RuntimeStats {
    fn default() -> Self {
        Self {
            tick_count: AtomicU64::new(0),
            observed_tick_us: AtomicU64::new(0),
            dedup_count: AtomicU64::new(0),
            throttle_drops: AtomicU64::new(0),
            last_decision_unix_ms: AtomicI64::new(-1),
            last_submit_unix_ms: AtomicI64::new(-1),
        }
    }
}

impl RuntimeStats {
    pub fn tick_count(&self) -> u64 {
        self.tick_count.load(Ordering::Relaxed)
    }
    pub fn observed_tick_us(&self) -> u64 {
        self.observed_tick_us.load(Ordering::Relaxed)
    }
    pub fn dedup_count(&self) -> u64 {
        self.dedup_count.load(Ordering::Relaxed)
    }
    pub fn throttle_drops(&self) -> u64 {
        self.throttle_drops.load(Ordering::Relaxed)
    }
    pub fn last_decision_age_ms(&self) -> Option<u64> {
        age_from_unix_ms(self.last_decision_unix_ms.load(Ordering::Relaxed))
    }
    pub fn last_submit_age_ms(&self) -> Option<u64> {
        age_from_unix_ms(self.last_submit_unix_ms.load(Ordering::Relaxed))
    }
}

fn age_from_unix_ms(t: i64) -> Option<u64> {
    if t < 0 {
        return None;
    }
    let now = chrono::Utc::now().timestamp_millis();
    Some((now - t).max(0) as u64)
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EmitDecision {
    Allowed,
    Suppressed(SuppressReason),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SuppressReason {
    /// Same (side, price_bucket, size_bucket) within `dedup_window_ms`.
    Duplicate,
    /// Submit budget exhausted for the current rolling second.
    Budget,
}

/// Bucket a price into a u64 key for dedup. Scales by `1/step`
/// and rounds, so prices within one step collide.
pub fn price_bucket(price: f64, step: f64) -> i64 {
    (price / step).round() as i64
}

pub fn size_bucket(size: f64, step: f64) -> i64 {
    (size / step).round() as i64
}

pub struct Runtime {
    cfg: RuntimeConfig,
    sm: SpreadCapture,
    book: Arc<RwLock<BookSnapshot>>,
    stats: Arc<RuntimeStats>,
    #[cfg(feature = "ws")]
    ws_stats: Option<Arc<WsStats>>,
    /// Authoritative net_position for the runtime tick. Updated
    /// externally via `set_net_position`; fills plumbing is a
    /// future PR per scope constraint (3).
    net_position: RwLock<f64>,
    /// Most recent successful submit fingerprint, for dedup.
    last_submit: RwLock<Option<SubmitRecord>>,
    /// Rolling window of submit timestamps for the budget gate.
    /// Bounded by `submit_budget_per_sec` + pruning each tick.
    submit_window: RwLock<VecDeque<Instant>>,
}

#[derive(Debug, Clone, Copy)]
struct SubmitRecord {
    side: Side,
    price_bucket: i64,
    size_bucket: i64,
    at: Instant,
}

impl Runtime {
    pub fn new(
        cfg: RuntimeConfig,
        sm: SpreadCapture,
        book: Arc<RwLock<BookSnapshot>>,
        stats: Arc<RuntimeStats>,
    ) -> Self {
        Self {
            cfg,
            sm,
            book,
            stats,
            #[cfg(feature = "ws")]
            ws_stats: None,
            net_position: RwLock::new(0.0),
            last_submit: RwLock::new(None),
            submit_window: RwLock::new(VecDeque::new()),
        }
    }

    #[cfg(feature = "ws")]
    pub fn with_ws_stats(mut self, stats: Arc<WsStats>) -> Self {
        self.ws_stats = Some(stats);
        self
    }

    pub fn set_net_position(&self, v: f64) {
        *self.net_position.write() = v;
    }

    pub fn stats(&self) -> Arc<RuntimeStats> {
        self.stats.clone()
    }

    pub fn cfg(&self) -> &RuntimeConfig {
        &self.cfg
    }

    /// Returns whether the cache is fresh enough to decide on.
    /// `None` (never populated) and `Some(age) > max` both stale.
    pub fn book_is_fresh(&self) -> bool {
        match self.book.read().book_age_ms() {
            Some(age) => age <= self.cfg.book_max_age_ms,
            None => false,
        }
    }

    /// Pure decision: should this emit be allowed right now?
    /// Split out from `run_tick` so tests can drive it without a
    /// live TradingClient.
    pub fn decide_emit(
        &self,
        side: Side,
        price: f64,
        size: f64,
        now: Instant,
    ) -> EmitDecision {
        let pb = price_bucket(price, self.cfg.price_bucket);
        let sb = size_bucket(size, self.cfg.size_bucket);

        // ── Dedup ──────────────────────────────────────────────
        if let Some(prev) = *self.last_submit.read() {
            let elapsed_ms = now.saturating_duration_since(prev.at).as_millis() as u64;
            if prev.side == side
                && prev.price_bucket == pb
                && prev.size_bucket == sb
                && elapsed_ms < self.cfg.dedup_window_ms
            {
                self.stats.dedup_count.fetch_add(1, Ordering::Relaxed);
                tracing::debug!(
                    target: "throttle",
                    reason = "dedup",
                    side = ?side,
                    price_bucket = pb,
                    size_bucket = sb,
                    elapsed_ms,
                    window_ms = self.cfg.dedup_window_ms,
                    "suppressed duplicate"
                );
                return EmitDecision::Suppressed(SuppressReason::Duplicate);
            }
        }

        // ── Budget ─────────────────────────────────────────────
        {
            let mut w = self.submit_window.write();
            let one_sec_ago = now - Duration::from_secs(1);
            while w.front().is_some_and(|t| *t <= one_sec_ago) {
                w.pop_front();
            }
            if (w.len() as u32) >= self.cfg.submit_budget_per_sec {
                self.stats.throttle_drops.fetch_add(1, Ordering::Relaxed);
                tracing::debug!(
                    target: "throttle",
                    reason = "budget",
                    side = ?side,
                    price_bucket = pb,
                    size_bucket = sb,
                    submits_in_last_sec = w.len(),
                    budget = self.cfg.submit_budget_per_sec,
                    "suppressed for budget"
                );
                return EmitDecision::Suppressed(SuppressReason::Budget);
            }
        }

        EmitDecision::Allowed
    }

    /// Call AFTER a submit was actually dispatched (success or
    /// attempt), so the dedup + budget windows are advanced.
    fn record_submit(
        &self,
        side: Side,
        price: f64,
        size: f64,
        at: Instant,
    ) {
        let pb = price_bucket(price, self.cfg.price_bucket);
        let sb = size_bucket(size, self.cfg.size_bucket);
        *self.last_submit.write() = Some(SubmitRecord {
            side, price_bucket: pb, size_bucket: sb, at,
        });
        self.submit_window.write().push_back(at);
        self.stats.last_submit_unix_ms.store(
            chrono::Utc::now().timestamp_millis(), Ordering::Relaxed,
        );
    }

    /// Drive exactly one tick. Public for test visibility. Takes
    /// `&mut self` for `sm.decide()` access.
    pub async fn run_tick(
        &mut self,
        token_id: U256,
        token_id_str: &str,
        client: &TradingClient,
    ) -> anyhow::Result<()> {
        self.stats.tick_count.fetch_add(1, Ordering::Relaxed);
        let now_ms = chrono::Utc::now().timestamp_millis();
        let prev = self
            .stats
            .last_decision_unix_ms
            .swap(now_ms, Ordering::Relaxed);
        if prev > 0 {
            let observed_us = ((now_ms - prev) * 1000).max(0) as u64;
            self.stats.observed_tick_us.store(observed_us, Ordering::Relaxed);
        }

        // Freshness gate. Stale → try REST fetch_book. If WS mode
        // is on and the stats handle is available, bump the
        // fallback counter before the fetch.
        if !self.book_is_fresh() {
            #[cfg(feature = "ws")]
            if let Some(ws) = &self.ws_stats {
                ws.record_fallback_to_rest();
            }
            if let Err(e) = client.fetch_book(token_id_str).await {
                tracing::warn!(
                    target: "runtime",
                    error = %e,
                    "REST fallback fetch_book failed; skipping tick"
                );
                return Ok(());
            }
        }

        let book_snap = self.book.read().clone();
        let tick = Tick {
            token_id,
            net_position: *self.net_position.read(),
            book: book_snap,
        };

        let decision = self.sm.decide(&tick);
        let Decision::Emit { side, price, size, maker_amount, taker_amount, .. } = decision else {
            return Ok(());
        };

        let now = Instant::now();
        match self.decide_emit(side, price, size, now) {
            EmitDecision::Suppressed(_) => return Ok(()),
            EmitDecision::Allowed => {}
        }

        // Attempt the submit. We record the submit timestamp
        // regardless of the server's answer — from the perspective
        // of the budget, we already paid the outbound send.
        self.record_submit(side, price, size, now);
        if let Err(e) = client
            .place_single_order(token_id, maker_amount, taker_amount, side)
            .await
        {
            tracing::warn!(
                target: "runtime",
                error = %e,
                "submit failed; budget/dedup advanced anyway"
            );
        }
        Ok(())
    }

    /// Long-lived tick loop. Returns only if `run_tick` returns
    /// Err (it currently does not — submit errors are logged and
    /// swallowed) or the enclosing task is dropped.
    pub async fn run_forever(
        &mut self,
        token_id: U256,
        token_id_str: String,
        client: &TradingClient,
    ) -> anyhow::Result<()> {
        let mut ticker = interval(Duration::from_millis(self.cfg.tick_interval_ms));
        ticker.set_missed_tick_behavior(MissedTickBehavior::Delay);
        loop {
            ticker.tick().await;
            self.run_tick(token_id, &token_id_str, client).await?;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn stub_runtime(cfg: RuntimeConfig) -> Runtime {
        use crate::config::{SpreadConfig, TradeSideMode};
        let sc = SpreadConfig {
            order_size: 10.0,
            edge_threshold: 0.02,
            target_spread: 0.03,
            trade_side: TradeSideMode::Both,
        };
        let sm = SpreadCapture::new(sc, 10.0, 0.01, 0.99);
        let book = Arc::new(RwLock::new(BookSnapshot::default()));
        let stats = Arc::new(RuntimeStats::default());
        Runtime::new(cfg, sm, book, stats)
    }

    #[test]
    fn bucket_collides_within_step() {
        assert_eq!(price_bucket(0.500, 0.001), price_bucket(0.5004, 0.001));
        assert_ne!(price_bucket(0.500, 0.001), price_bucket(0.502, 0.001));
    }

    #[test]
    fn dedup_suppresses_identical_side_bucket_within_window() {
        let rt = stub_runtime(RuntimeConfig {
            dedup_window_ms: 500,
            ..RuntimeConfig::default()
        });
        let t0 = Instant::now();
        // First emit: allowed.
        assert_eq!(
            rt.decide_emit(Side::Buy, 0.50, 10.0, t0),
            EmitDecision::Allowed
        );
        rt.record_submit(Side::Buy, 0.50, 10.0, t0);
        // Same bucket 100ms later: suppressed.
        let t1 = t0 + Duration::from_millis(100);
        assert_eq!(
            rt.decide_emit(Side::Buy, 0.5004, 10.0, t1),
            EmitDecision::Suppressed(SuppressReason::Duplicate)
        );
        assert_eq!(rt.stats.dedup_count(), 1);
    }

    #[test]
    fn dedup_releases_after_window() {
        let rt = stub_runtime(RuntimeConfig {
            dedup_window_ms: 500,
            submit_budget_per_sec: 100,
            ..RuntimeConfig::default()
        });
        let t0 = Instant::now();
        rt.record_submit(Side::Buy, 0.50, 10.0, t0);
        let t1 = t0 + Duration::from_millis(600);
        assert_eq!(
            rt.decide_emit(Side::Buy, 0.50, 10.0, t1),
            EmitDecision::Allowed,
            "past the window, identical emit should be allowed"
        );
    }

    #[test]
    fn dedup_does_not_cross_sides() {
        let rt = stub_runtime(RuntimeConfig {
            dedup_window_ms: 500,
            submit_budget_per_sec: 100,
            ..RuntimeConfig::default()
        });
        let t0 = Instant::now();
        rt.record_submit(Side::Buy, 0.50, 10.0, t0);
        let t1 = t0 + Duration::from_millis(50);
        assert_eq!(
            rt.decide_emit(Side::Sell, 0.50, 10.0, t1),
            EmitDecision::Allowed,
            "different side should not dedup-match"
        );
    }

    #[test]
    fn budget_suppresses_after_cap() {
        let rt = stub_runtime(RuntimeConfig {
            dedup_window_ms: 0,
            submit_budget_per_sec: 3,
            ..RuntimeConfig::default()
        });
        let t0 = Instant::now();
        for i in 0..3 {
            let t = t0 + Duration::from_millis(100 * i);
            assert_eq!(
                rt.decide_emit(Side::Buy, 0.50 + i as f64 * 0.01, 10.0, t),
                EmitDecision::Allowed
            );
            rt.record_submit(Side::Buy, 0.50 + i as f64 * 0.01, 10.0, t);
        }
        // 4th within same second should exhaust budget.
        let t4 = t0 + Duration::from_millis(400);
        assert_eq!(
            rt.decide_emit(Side::Buy, 0.60, 10.0, t4),
            EmitDecision::Suppressed(SuppressReason::Budget)
        );
        assert_eq!(rt.stats.throttle_drops(), 1);
    }

    #[test]
    fn budget_refreshes_after_rolling_second() {
        let rt = stub_runtime(RuntimeConfig {
            dedup_window_ms: 0,
            submit_budget_per_sec: 2,
            ..RuntimeConfig::default()
        });
        let t0 = Instant::now();
        rt.record_submit(Side::Buy, 0.50, 10.0, t0);
        rt.record_submit(Side::Buy, 0.51, 10.0, t0 + Duration::from_millis(100));
        // >1s later the window is empty.
        let t2 = t0 + Duration::from_millis(1_200);
        assert_eq!(
            rt.decide_emit(Side::Buy, 0.52, 10.0, t2),
            EmitDecision::Allowed
        );
    }

    #[test]
    fn book_freshness_respects_max_age() {
        let rt = stub_runtime(RuntimeConfig {
            book_max_age_ms: 100,
            ..RuntimeConfig::default()
        });
        assert!(!rt.book_is_fresh(), "default book is never-stamped → stale");
        rt.book.write().stamp_now();
        assert!(rt.book_is_fresh(), "just-stamped book → fresh");
        std::thread::sleep(Duration::from_millis(150));
        assert!(!rt.book_is_fresh(), "older than max_age → stale");
    }

    #[test]
    fn stats_ages_track_wallclock() {
        let rt = stub_runtime(RuntimeConfig::default());
        assert!(rt.stats.last_decision_age_ms().is_none());
        assert!(rt.stats.last_submit_age_ms().is_none());
        rt.record_submit(Side::Buy, 0.50, 10.0, Instant::now());
        let age = rt.stats.last_submit_age_ms().expect("recorded");
        assert!(age < 500, "just-recorded should be near-zero, got {age}");
    }

    /// End-to-end `run_tick`: uses a live TradingClient (dry_run,
    /// so no network) but with a pre-stamped book + in-bounds
    /// net_position so the pivot doesn't fire and `fetch_book` is
    /// never called. Proves the tick increments counters, records
    /// cadence, and does NOT submit when decide() returns non-Emit.
    #[tokio::test]
    async fn run_tick_updates_counters_when_pivot_skips() {
        use crate::book::BookLevel;
        use crate::client::TradingClient;
        use tempfile::TempDir;

        let dir = TempDir::new().unwrap();
        let nonce = dir.path().join("nonce");
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = TradingClient::new(key, nonce, true, 0).unwrap();
        let book = client.book_cache();
        {
            let mut b = book.write();
            b.bids = vec![BookLevel { price: 0.49, size: 100.0 }];
            b.asks = vec![BookLevel { price: 0.51, size: 100.0 }];
            b.stamp_now();
        }

        use crate::config::{SpreadConfig, TradeSideMode};
        let sc = SpreadConfig {
            order_size: 10.0,
            edge_threshold: 0.02,
            target_spread: 0.03,
            trade_side: TradeSideMode::Both,
        };
        let sm = SpreadCapture::new(sc, 10.0, 0.01, 0.99);
        let cfg = RuntimeConfig {
            tick_interval_ms: 150,
            book_max_age_ms: 60_000, // plenty of headroom
            ..RuntimeConfig::default()
        };
        let stats = Arc::new(RuntimeStats::default());
        let mut rt = Runtime::new(cfg, sm, book.clone(), stats.clone());
        rt.set_net_position(0.0); // in bounds → no emit

        // Two ticks, with a small gap so cadence is measurable.
        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();
        tokio::time::sleep(Duration::from_millis(15)).await;
        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();

        assert_eq!(stats.tick_count(), 2);
        assert!(
            stats.observed_tick_us() >= 10_000,
            "observed gap should be >= 10ms, got {}us",
            stats.observed_tick_us()
        );
        assert_eq!(stats.dedup_count(), 0);
        assert_eq!(stats.throttle_drops(), 0);
        // No submit → last_submit age stays None.
        assert!(stats.last_submit_age_ms().is_none());
        // Decision age WAS recorded.
        assert!(stats.last_decision_age_ms().is_some());
    }
}
