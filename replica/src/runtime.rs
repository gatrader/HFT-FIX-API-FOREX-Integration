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

use tokio::sync::mpsc;

use crate::book::BookSnapshot;
use crate::client::{PreparedSubmit, TradingClient};
use crate::order::Side;
use crate::position::Position;
use crate::state_machine::{Decision, SpreadCapture, Tick, PRICE_TICK};

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

    /// Minimum gap between cancel enqueues (ms). The state machine
    /// says Cancel* every tick the pivot isn't firing, so at 150 ms
    /// cadence this gate stops us from spraying ~6 cancels/s.
    /// 500 ms = matches the submit-dedup window; safe default.
    pub cancel_dedup_ms: u64,
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
            cancel_dedup_ms: 500,
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

    // ── PR 4 / submit-decoupling observables ──────────────────────
    /// Approximate in-flight queue depth. Incremented on successful
    /// `try_send`, decremented after the worker finishes HTTP.
    /// Not load-bearing — this is a gauge, not a reservation
    /// counter. Drift on the order of one in-flight job is fine.
    queue_depth: AtomicI64,
    /// Submits rejected because the bounded mpsc was full at
    /// try_send time. Monotonic.
    queue_full_drops: AtomicU64,
    /// Last observed queue wait: µs from `Instant::now()` at enqueue
    /// to the worker's `recv()`. Dominant term when the queue is
    /// non-empty; near zero when HTTP keeps up.
    last_queue_wait_us: AtomicU64,
    /// Last observed HTTP round-trip in the worker, in µs. Mirrors
    /// `submit_ms + body_ms` from the `hotpath` trace event.
    last_http_submit_us: AtomicU64,

    // ── Cancel path observables ───────────────────────────────────
    /// Cancel requests enqueued by the runtime tick — a proxy for
    /// how often the state machine is saying "cancel what's open".
    /// Monotonic.
    cancel_count: AtomicU64,
    /// Cancel requests that came back from the server as an error.
    /// Separate counter so a cancel latency issue is distinguishable
    /// from a pure rate problem.
    cancel_error_count: AtomicU64,
    /// Cancel requests dropped because the cancel queue was full
    /// at try_send time. Same shape as `queue_full_drops`.
    cancel_queue_full_drops: AtomicU64,
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
            queue_depth: AtomicI64::new(0),
            queue_full_drops: AtomicU64::new(0),
            last_queue_wait_us: AtomicU64::new(0),
            last_http_submit_us: AtomicU64::new(0),
            cancel_count: AtomicU64::new(0),
            cancel_error_count: AtomicU64::new(0),
            cancel_queue_full_drops: AtomicU64::new(0),
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
    pub fn queue_depth(&self) -> i64 {
        self.queue_depth.load(Ordering::Relaxed)
    }
    pub fn queue_full_drops(&self) -> u64 {
        self.queue_full_drops.load(Ordering::Relaxed)
    }
    pub fn last_queue_wait_us(&self) -> u64 {
        self.last_queue_wait_us.load(Ordering::Relaxed)
    }
    pub fn last_http_submit_us(&self) -> u64 {
        self.last_http_submit_us.load(Ordering::Relaxed)
    }
    pub fn cancel_count(&self) -> u64 {
        self.cancel_count.load(Ordering::Relaxed)
    }
    pub fn cancel_error_count(&self) -> u64 {
        self.cancel_error_count.load(Ordering::Relaxed)
    }
    pub fn cancel_queue_full_drops(&self) -> u64 {
        self.cancel_queue_full_drops.load(Ordering::Relaxed)
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

/// One job on the submit queue. Carries the pre-signed order +
/// a tracing correlator + the enqueue timestamp (so the worker
/// can attribute queue wait vs HTTP time independently).
#[derive(Debug)]
pub struct SubmitJob {
    pub prepared: PreparedSubmit,
    pub enqueued_at: Instant,
}

/// A cancel trigger. The runtime signals "cancel whatever is
/// currently open"; the worker snapshots `client.open_order_ids()`
/// at send-time and batch-cancels. Carrying the list would be a
/// race (new orders could land between decision and send).
#[derive(Debug, Clone, Copy)]
pub enum CancelJob {
    /// Cancel every open order belonging to this account.
    All,
    /// Cancel the CURRENTLY-OPEN set snapshotted at worker send-
    /// time. Used by the state-machine Cancel* paths.
    Open,
}

/// Worker that drains `CancelJob`s and issues the matching HTTP
/// cancel against `TradingClient`. Mirrors SubmitWorker: the
/// runtime tick hands off; the worker owns the network cost.
///
/// Error policy: cancel failures are logged but not re-queued.
/// A failed cancel is usually because the order already filled
/// or was cancelled server-side; retrying blindly risks a stale
/// 4xx storm.
pub struct CancelWorker {
    client: Arc<TradingClient>,
    rx: mpsc::Receiver<CancelJob>,
    stats: Arc<RuntimeStats>,
}

impl CancelWorker {
    pub fn new(
        client: Arc<TradingClient>,
        rx: mpsc::Receiver<CancelJob>,
        stats: Arc<RuntimeStats>,
    ) -> Self {
        Self { client, rx, stats }
    }

    pub async fn run(mut self) {
        while let Some(job) = self.rx.recv().await {
            let t = Instant::now();
            let result = match job {
                CancelJob::All => self.client.cancel_all().await,
                CancelJob::Open => {
                    let ids = self.client.open_order_ids();
                    if ids.is_empty() {
                        continue;
                    }
                    self.client.cancel_orders(&ids).await
                }
            };
            let elapsed_us = t.elapsed().as_micros() as u64;
            self.stats.cancel_count.fetch_add(1, Ordering::Relaxed);
            if let Err(e) = result {
                self.stats.cancel_error_count.fetch_add(1, Ordering::Relaxed);
                tracing::warn!(
                    target: "cancel_worker",
                    error = %e, elapsed_us,
                    "cancel failed; continuing"
                );
            } else {
                tracing::debug!(
                    target: "cancel_worker",
                    elapsed_us, ?job,
                    "cancel ok"
                );
            }
        }
        tracing::info!(target: "cancel_worker", "queue closed; worker exiting");
    }
}

/// Single-consumer worker that drains `SubmitJob`s off an mpsc
/// receiver and hands each to `TradingClient::submit_signed`.
///
/// Ordering: tokio mpsc is FIFO per-sender, and the runtime loop
/// is the sole sender, so submits are issued in strict tick order.
///
/// Error policy: HTTP errors are logged + swallowed so one bad
/// submit does not tear down the worker. The runtime loop keeps
/// ticking regardless.
pub struct SubmitWorker {
    client: Arc<TradingClient>,
    rx: mpsc::Receiver<SubmitJob>,
    stats: Arc<RuntimeStats>,
}

impl SubmitWorker {
    pub fn new(
        client: Arc<TradingClient>,
        rx: mpsc::Receiver<SubmitJob>,
        stats: Arc<RuntimeStats>,
    ) -> Self {
        Self { client, rx, stats }
    }

    /// Runs until the sender half is dropped (Runtime exits) and
    /// the receiver returns `None`. Under normal operation this
    /// task is spawned with `tokio::spawn` and lives as long as
    /// the Runtime task.
    pub async fn run(mut self) {
        while let Some(job) = self.rx.recv().await {
            let wait_us = job.enqueued_at.elapsed().as_micros() as u64;
            self.stats.last_queue_wait_us.store(wait_us, Ordering::Relaxed);

            let t_http = Instant::now();
            let result = self
                .client
                .submit_signed(
                    &job.prepared.signed,
                    job.prepared.request_id,
                    job.prepared.sign_us,
                )
                .await;
            let http_us = t_http.elapsed().as_micros() as u64;
            self.stats
                .last_http_submit_us
                .store(http_us, Ordering::Relaxed);
            self.stats.queue_depth.fetch_sub(1, Ordering::Relaxed);

            if let Err(e) = result {
                tracing::warn!(
                    target: "submit_worker",
                    request_id = job.prepared.request_id,
                    error = %e,
                    wait_us,
                    http_us,
                    "submit_signed failed; continuing"
                );
            }
        }
        tracing::info!(target: "submit_worker", "queue closed; worker exiting");
    }
}

pub struct Runtime {
    cfg: RuntimeConfig,
    sm: SpreadCapture,
    book: Arc<RwLock<BookSnapshot>>,
    stats: Arc<RuntimeStats>,
    #[cfg(feature = "ws")]
    ws_stats: Option<Arc<WsStats>>,
    /// Authoritative net_position for the runtime tick. Shared
    /// with the user-channel fill task (which writes) and any
    /// future reconcile path. Read-only from this module's POV.
    position: Position,
    /// Most recent successful submit fingerprint, for dedup.
    last_submit: RwLock<Option<SubmitRecord>>,
    /// Rolling window of submit timestamps for the budget gate.
    /// Bounded by `submit_budget_per_sec` + pruning each tick.
    submit_window: RwLock<VecDeque<Instant>>,
    /// Bounded mpsc sender to the submit worker. When `Some`, the
    /// runtime loop signs on-tick and hands the result to the
    /// worker via `try_send` — decision ticks no longer inherit
    /// HTTP round-trip latency.
    ///
    /// When `None`, the loop falls back to the inline REST path
    /// via `client.place_single_order`. This is the rollback
    /// surface: if the queue wiring turns out wrong in production,
    /// omit `with_submit_queue(..)` and the binary reverts to
    /// byte-identical PR 3 behavior.
    submit_tx: Option<mpsc::Sender<SubmitJob>>,
    /// Bounded mpsc to a `CancelWorker`. When `Some`, Cancel*
    /// state-machine decisions enqueue a `CancelJob::Open` after
    /// the dedup gate. Missing the worker entirely leaves the
    /// replica's cancel path as a no-op — matching the pre-B
    /// behaviour — so a build that forgets to wire the worker
    /// still runs, just never cancels.
    cancel_tx: Option<mpsc::Sender<CancelJob>>,
    /// Last time we enqueued a cancel. The state machine will
    /// say Cancel* on every pivot-skip tick; we don't need to
    /// hammer the server at 6 Hz. 500ms is plenty for the unwinder
    /// live-fire.
    last_cancel_at: RwLock<Option<Instant>>,
    /// Minimum time between cancel enqueues. Wired to
    /// `RuntimeConfig::cancel_dedup_ms`.
    cancel_dedup: Duration,
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
        let cancel_dedup = Duration::from_millis(cfg.cancel_dedup_ms);
        Self {
            cfg,
            sm,
            book,
            stats,
            #[cfg(feature = "ws")]
            ws_stats: None,
            position: Position::new(),
            last_submit: RwLock::new(None),
            submit_window: RwLock::new(VecDeque::new()),
            submit_tx: None,
            cancel_tx: None,
            last_cancel_at: RwLock::new(None),
            cancel_dedup,
        }
    }

    #[cfg(feature = "ws")]
    pub fn with_ws_stats(mut self, stats: Arc<WsStats>) -> Self {
        self.ws_stats = Some(stats);
        self
    }

    /// Route submits through a bounded mpsc to a `SubmitWorker`
    /// task. Without this, submits go inline (PR 3 behavior).
    pub fn with_submit_queue(mut self, tx: mpsc::Sender<SubmitJob>) -> Self {
        self.submit_tx = Some(tx);
        self
    }

    /// Route cancels through a bounded mpsc to a `CancelWorker`.
    /// Without this, state-machine Cancel decisions are silent —
    /// the replica stays compatible with its pre-B behaviour.
    pub fn with_cancel_queue(mut self, tx: mpsc::Sender<CancelJob>) -> Self {
        self.cancel_tx = Some(tx);
        self
    }

    /// Overwrite the current net_position. Used by the CLI
    /// `--seed-position` path and by startup REST reconcile.
    /// Fills from the user channel should go through
    /// `position().apply_fill()` instead.
    pub fn set_net_position(&self, v: f64) {
        self.position.seed_shares(v);
    }

    /// Clone the Position handle so the user-channel fill task
    /// can `apply_fill` on it. Cheap — just bumps an Arc.
    pub fn position(&self) -> Position {
        self.position.clone()
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

    /// Send a CancelJob::Open to the worker if the dedup window
    /// has elapsed AND the registry has at least one open order.
    /// No-op when the cancel queue isn't wired (pre-B behaviour),
    /// when the window is still hot, or when there's nothing to
    /// cancel.
    ///
    /// The empty-registry short-circuit matters because the state
    /// machine emits Cancel* decisions even on a flat book during
    /// the unwinder's post-flat pause. Without it, every such tick
    /// would consume a channel slot and advance the dedup window
    /// for a no-op, making the `cancel_count` metric noisy and
    /// inflating the observed cancel rate.
    fn enqueue_cancel_if_needed(&self, client: &TradingClient) {
        let Some(tx) = &self.cancel_tx else { return };
        if client.open_order_count() == 0 {
            return;
        }
        let now = Instant::now();
        {
            let last = self.last_cancel_at.read();
            if let Some(t) = *last {
                if now.duration_since(t) < self.cancel_dedup {
                    return;
                }
            }
        }
        match tx.try_send(CancelJob::Open) {
            Ok(()) => {
                *self.last_cancel_at.write() = Some(now);
            }
            Err(mpsc::error::TrySendError::Full(_))
            | Err(mpsc::error::TrySendError::Closed(_)) => {
                self.stats
                    .cancel_queue_full_drops
                    .fetch_add(1, Ordering::Relaxed);
            }
        }
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
            net_position: self.position.shares(),
            book: book_snap,
        };

        let decision = self.sm.decide(&tick);
        let (side, price, size, maker_amount, taker_amount) = match decision {
            Decision::Emit { side, price, size, maker_amount, taker_amount, .. } => {
                (side, price, size, maker_amount, taker_amount)
            }
            Decision::CancelPrimary | Decision::CancelSecondary => {
                self.enqueue_cancel_if_needed(client);
                return Ok(());
            }
            Decision::Skip => return Ok(()),
        };

        // Stacking guard: consult the local open-order registry
        // before emitting. Prices are already venue-tick quantized
        // in the state machine, so half-tick eps is tight enough
        // to match "same level" without over-matching on f64 jitter.
        //
        //   matching on (side, price) → skip: same quote is already
        //     resting; a second submit would stack inventory at the
        //     same level and blow the maker budget.
        //   stale on same side at a different price → cancel: the
        //     state machine has moved; layering a new order on top
        //     of the old one accumulates dead quotes.
        //   otherwise → emit normally.
        let tick_eps = PRICE_TICK / 2.0;
        if client.has_matching_open_order(side, price, tick_eps) {
            tracing::debug!(
                target: "runtime",
                side = ?side,
                price,
                "matching open order already live; skipping emit"
            );
            return Ok(());
        }
        if client.has_stale_open_order_on_side(side, price, tick_eps) {
            tracing::info!(
                target: "runtime",
                side = ?side,
                price,
                open_count = client.open_order_count(),
                "stale on-side open order; cancelling before new emit"
            );
            self.enqueue_cancel_if_needed(client);
            return Ok(());
        }

        let now = Instant::now();
        match self.decide_emit(side, price, size, now) {
            EmitDecision::Suppressed(_) => return Ok(()),
            EmitDecision::Allowed => {}
        }

        // Record the submit *before* we try to enqueue: the budget
        // and dedup gates have already approved this slot, and we
        // don't want a transient queue-full to free that slot back.
        self.record_submit(side, price, size, now);

        // ── Hot path branch: queued vs inline ─────────────────────
        if let Some(tx) = &self.submit_tx {
            // Sign on the runtime tick (CPU-bound, ~µs). The HTTP
            // round trip happens in the worker so the next decision
            // tick does not inherit it.
            let prepared = match client
                .sign_for_submit(token_id, maker_amount, taker_amount, side)
            {
                Ok(p) => p,
                Err(e) => {
                    tracing::warn!(
                        target: "runtime",
                        error = %e,
                        "sign_for_submit failed; skipping tick"
                    );
                    return Ok(());
                }
            };
            let job = SubmitJob { prepared, enqueued_at: Instant::now() };
            match tx.try_send(job) {
                Ok(()) => {
                    self.stats.queue_depth.fetch_add(1, Ordering::Relaxed);
                }
                Err(mpsc::error::TrySendError::Full(_)) => {
                    self.stats
                        .queue_full_drops
                        .fetch_add(1, Ordering::Relaxed);
                    tracing::warn!(
                        target: "submit_queue",
                        depth = self.stats.queue_depth(),
                        capacity = tx.max_capacity(),
                        "queue full; dropping submit (back-pressure)"
                    );
                }
                Err(mpsc::error::TrySendError::Closed(_)) => {
                    // Worker died. Counted as a drop so the dashboard
                    // sees something is wrong; the runtime keeps
                    // ticking so an operator can intervene.
                    self.stats
                        .queue_full_drops
                        .fetch_add(1, Ordering::Relaxed);
                    tracing::error!(
                        target: "submit_queue",
                        "worker channel closed; submit dropped"
                    );
                }
            }
        } else {
            // Inline (REST rollback) path — byte-identical to PR 3.
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

    // ── PR 4: submit-decoupling tests ─────────────────────────────

    /// When a queue is wired in and capacity is plenty, run_tick
    /// should sign + try_send (queue_depth advances by 1), without
    /// blocking on HTTP. The inline submit path must NOT have run.
    #[tokio::test]
    async fn run_tick_enqueues_when_queue_present() {
        use crate::book::BookLevel;
        use crate::client::TradingClient;
        use tempfile::TempDir;

        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = TradingClient::new(key, dir.path().join("nonce"), true, 0)
            .unwrap();
        let book = client.book_cache();
        {
            let mut b = book.write();
            b.bids = vec![BookLevel { price: 0.49, size: 100.0 }];
            b.asks = vec![BookLevel { price: 0.51, size: 100.0 }];
            b.stamp_now();
        }

        use crate::config::{SpreadConfig, TradeSideMode};
        let sc = SpreadConfig {
            order_size: 1.0,
            edge_threshold: 0.005,
            target_spread: 0.005,
            trade_side: TradeSideMode::Both,
        };
        let sm = SpreadCapture::new(sc, 5.0, 0.01, 0.99);
        let cfg = RuntimeConfig {
            tick_interval_ms: 150,
            book_max_age_ms: 60_000,
            ..RuntimeConfig::default()
        };
        let stats = Arc::new(RuntimeStats::default());
        let (tx, mut rx) = mpsc::channel::<SubmitJob>(8);
        let mut rt = Runtime::new(cfg, sm, book.clone(), stats.clone())
            .with_submit_queue(tx);
        rt.set_net_position(10.0); // force pivot → emit

        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();

        assert_eq!(stats.queue_depth(), 1, "queue_depth should advance");
        assert_eq!(stats.queue_full_drops(), 0);
        // Drain to confirm a real SubmitJob landed.
        let job = rx.try_recv().expect("expected one queued job");
        assert!(job.prepared.sign_us > 0);
        assert!(!job.prepared.signed.signature.is_empty());
    }

    /// When the queue is full, try_send should fail Fast → drop the
    /// submit + bump queue_full_drops + warn-log. Critically, the
    /// runtime tick must still return Ok in bounded time (no block).
    #[tokio::test]
    async fn run_tick_drops_when_queue_full() {
        use crate::book::BookLevel;
        use crate::client::TradingClient;
        use tempfile::TempDir;

        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = TradingClient::new(key, dir.path().join("nonce"), true, 0)
            .unwrap();
        let book = client.book_cache();
        {
            let mut b = book.write();
            b.bids = vec![BookLevel { price: 0.49, size: 100.0 }];
            b.asks = vec![BookLevel { price: 0.51, size: 100.0 }];
            b.stamp_now();
        }

        use crate::config::{SpreadConfig, TradeSideMode};
        let sc = SpreadConfig {
            order_size: 1.0,
            edge_threshold: 0.005,
            target_spread: 0.005,
            trade_side: TradeSideMode::Both,
        };
        let sm = SpreadCapture::new(sc, 5.0, 0.01, 0.99);
        let cfg = RuntimeConfig {
            tick_interval_ms: 150,
            book_max_age_ms: 60_000,
            // Big budget so dedup/throttle don't suppress before
            // we get a chance to overflow the queue.
            submit_budget_per_sec: 1_000,
            dedup_window_ms: 0,
            ..RuntimeConfig::default()
        };
        let stats = Arc::new(RuntimeStats::default());
        // Capacity 1 → first tick fills it, second tick must drop.
        let (tx, _rx_held) = mpsc::channel::<SubmitJob>(1);
        let mut rt = Runtime::new(cfg, sm, book.clone(), stats.clone())
            .with_submit_queue(tx);
        rt.set_net_position(10.0);

        // First tick lands in the queue.
        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();
        assert_eq!(stats.queue_depth(), 1);
        assert_eq!(stats.queue_full_drops(), 0);

        // Second tick: queue full → drop. Tick still returns
        // promptly (no HTTP, no await).
        let t0 = Instant::now();
        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();
        let elapsed = t0.elapsed();
        assert!(
            elapsed < Duration::from_millis(50),
            "full-queue tick should not block: took {elapsed:?}"
        );
        assert_eq!(stats.queue_full_drops(), 1);
        assert_eq!(stats.queue_depth(), 1, "depth unchanged on drop");
    }

    /// SubmitWorker drains the queue and decrements queue_depth.
    /// Uses dry_run=true so submit_signed short-circuits without
    /// touching the network.
    #[tokio::test]
    async fn submit_worker_drains_and_decrements_depth() {
        use crate::client::TradingClient;
        use tempfile::TempDir;

        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = Arc::new(
            TradingClient::new(key, dir.path().join("nonce"), true, 0).unwrap(),
        );
        let stats = Arc::new(RuntimeStats::default());
        let (tx, rx) = mpsc::channel::<SubmitJob>(4);

        // Pre-stage three jobs as if the runtime had enqueued them.
        for _ in 0..3 {
            let prepared = client
                .sign_for_submit(
                    U256::from(7u64),
                    U256::from(1_000u64),
                    U256::from(500u64),
                    Side::Sell,
                )
                .unwrap();
            tx.try_send(SubmitJob {
                prepared,
                enqueued_at: Instant::now(),
            })
            .unwrap();
            stats.queue_depth.fetch_add(1, Ordering::Relaxed);
        }
        assert_eq!(stats.queue_depth(), 3);

        // Spawn worker, drop the sender so it exits cleanly when drained.
        let worker = SubmitWorker::new(client.clone(), rx, stats.clone());
        let handle = tokio::spawn(worker.run());
        drop(tx);
        handle.await.expect("worker exits cleanly");

        assert_eq!(stats.queue_depth(), 0, "worker decremented depth to 0");
        // last_http_submit_us should be set (dry_run path is fast
        // but still measurable as elapsed > 0).
        // Note: dry_run can complete in <1µs on fast machines,
        // so we only assert the side effect ran (queue drained).
    }

    /// `enqueue_cancel_if_needed` should be a no-op when the
    /// registry is empty. Otherwise every Cancel* decision on a
    /// flat book consumes a channel slot and advances the dedup
    /// window for no reason — polluting `cancel_count` and
    /// masking the real cancel rate in operator dashboards.
    #[tokio::test]
    async fn enqueue_cancel_skips_on_empty_registry() {
        use crate::client::TradingClient;
        use tempfile::TempDir;
        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = TradingClient::new(key, dir.path().join("nonce"), true, 0)
            .unwrap();
        // Capacity 1: if we ever enqueued, a second call would
        // count as a full-queue drop.
        let (tx, mut rx) = mpsc::channel::<CancelJob>(1);
        let cfg = RuntimeConfig {
            cancel_dedup_ms: 0, // disable dedup gate for this test
            ..RuntimeConfig::default()
        };
        let rt = stub_runtime(cfg).with_cancel_queue(tx);

        // Registry is empty (TradingClient::new() starts flat).
        for _ in 0..3 {
            rt.enqueue_cancel_if_needed(&client);
        }
        assert_eq!(rt.stats.cancel_queue_full_drops(), 0);
        assert!(
            rx.try_recv().is_err(),
            "nothing should have been enqueued on an empty registry"
        );
    }

    /// With at least one open order, `enqueue_cancel_if_needed`
    /// must actually send. Guards against a regression where the
    /// empty-registry short-circuit also blocks the non-empty case.
    #[tokio::test]
    async fn enqueue_cancel_sends_when_registry_nonempty() {
        use crate::client::{OpenOrder, TradingClient};
        use tempfile::TempDir;
        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = TradingClient::new(key, dir.path().join("nonce"), true, 0)
            .unwrap();
        client.record_open_order(OpenOrder {
            order_id: "oid".into(),
            token_id: "tkn".into(),
            side: Side::Buy,
            price: 0.5,
            size: 10.0,
            placed_at: Instant::now(),
        });
        let (tx, mut rx) = mpsc::channel::<CancelJob>(4);
        let cfg = RuntimeConfig {
            cancel_dedup_ms: 0,
            ..RuntimeConfig::default()
        };
        let rt = stub_runtime(cfg).with_cancel_queue(tx);
        rt.enqueue_cancel_if_needed(&client);
        assert!(
            matches!(rx.try_recv(), Ok(CancelJob::Open)),
            "expected one CancelJob::Open enqueued"
        );
    }

    // ── Stacking-guard tests ──────────────────────────────────────
    //
    // Live validation against the CLOB on 2026-04 showed that the
    // state machine, unconstrained, would re-submit an identical
    // quote every tick even while the previous one was still resting
    // on the book. The three tests below pin the three cases:
    //   * matching open order → skip emit, nothing enqueued
    //   * stale on-side order → cancel enqueued, no submit
    //   * clean registry     → submit enqueued as normal

    /// Seeds the runtime + client with a book that forces a Sell
    /// emit at 0.51. Shared setup so the three tests below only
    /// differ in what's pre-loaded into the open-order registry.
    fn seed_emit_ready_runtime(
    ) -> (Runtime, Arc<crate::client::TradingClient>, tempfile::TempDir) {
        use crate::book::BookLevel;
        use crate::client::TradingClient;
        use crate::config::{SpreadConfig, TradeSideMode};
        use tempfile::TempDir;

        let dir = TempDir::new().unwrap();
        let key = "0000000000000000000000000000000000000000000000000000000000000001";
        let client = Arc::new(
            TradingClient::new(key, dir.path().join("nonce"), true, 0).unwrap(),
        );
        let book = client.book_cache();
        {
            let mut b = book.write();
            b.bids = vec![BookLevel { price: 0.49, size: 100.0 }];
            b.asks = vec![BookLevel { price: 0.51, size: 100.0 }];
            b.stamp_now();
        }
        let sc = SpreadConfig {
            order_size: 1.0,
            edge_threshold: 0.005,
            target_spread: 0.005,
            trade_side: TradeSideMode::Both,
        };
        let sm = SpreadCapture::new(sc, 5.0, 0.01, 0.99);
        let cfg = RuntimeConfig {
            tick_interval_ms: 150,
            book_max_age_ms: 60_000,
            dedup_window_ms: 0,
            submit_budget_per_sec: 100,
            cancel_dedup_ms: 0,
            ..RuntimeConfig::default()
        };
        let stats = Arc::new(RuntimeStats::default());
        let rt = Runtime::new(cfg, sm, book.clone(), stats);
        (rt, client, dir)
    }

    #[tokio::test]
    async fn run_tick_skips_emit_when_matching_open_order_present() {
        use crate::client::OpenOrder;
        let (mut rt, client, _d) = seed_emit_ready_runtime();
        // Runtime would emit Sell @ 0.51; a matching resting order
        // at the same level should short-circuit the submit.
        client.record_open_order(OpenOrder {
            order_id: "resting".into(),
            token_id: "tkn".into(),
            side: Side::Sell,
            price: 0.51,
            size: 1.0,
            placed_at: Instant::now(),
        });
        let (submit_tx, mut submit_rx) = mpsc::channel::<SubmitJob>(4);
        let (cancel_tx, mut cancel_rx) = mpsc::channel::<CancelJob>(4);
        rt.submit_tx = Some(submit_tx);
        rt.cancel_tx = Some(cancel_tx);
        rt.set_net_position(10.0);

        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();

        assert_eq!(rt.stats.queue_depth(), 0, "no submit should have been queued");
        assert!(submit_rx.try_recv().is_err(), "submit queue should be empty");
        assert!(cancel_rx.try_recv().is_err(), "no cancel should fire on match");
    }

    #[tokio::test]
    async fn run_tick_enqueues_cancel_when_stale_on_side_order_present() {
        use crate::client::OpenOrder;
        let (mut rt, client, _d) = seed_emit_ready_runtime();
        // Runtime wants Sell @ 0.51; a resting Sell at 0.60 is stale
        // (state machine has moved). The guard should cancel before
        // layering a replacement.
        client.record_open_order(OpenOrder {
            order_id: "stale".into(),
            token_id: "tkn".into(),
            side: Side::Sell,
            price: 0.60,
            size: 1.0,
            placed_at: Instant::now(),
        });
        let (submit_tx, mut submit_rx) = mpsc::channel::<SubmitJob>(4);
        let (cancel_tx, mut cancel_rx) = mpsc::channel::<CancelJob>(4);
        rt.submit_tx = Some(submit_tx);
        rt.cancel_tx = Some(cancel_tx);
        rt.set_net_position(10.0);

        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();

        assert!(submit_rx.try_recv().is_err(), "submit must not fire on stale");
        assert!(
            matches!(cancel_rx.try_recv(), Ok(CancelJob::Open)),
            "expected a CancelJob::Open to have been enqueued"
        );
        assert_eq!(rt.stats.queue_depth(), 0);
    }

    #[tokio::test]
    async fn run_tick_emits_when_registry_clean() {
        // Pins the contract of the guard: with no open order on the
        // target side, the tick must submit. Otherwise the guard
        // would silently mute the strategy in the normal case.
        let (mut rt, client, _d) = seed_emit_ready_runtime();
        let (submit_tx, mut submit_rx) = mpsc::channel::<SubmitJob>(4);
        let (cancel_tx, mut cancel_rx) = mpsc::channel::<CancelJob>(4);
        rt.submit_tx = Some(submit_tx);
        rt.cancel_tx = Some(cancel_tx);
        rt.set_net_position(10.0);

        rt.run_tick(U256::from(1u64), "1", &client).await.unwrap();

        assert_eq!(rt.stats.queue_depth(), 1, "clean registry → submit enqueued");
        assert!(submit_rx.try_recv().is_ok());
        assert!(cancel_rx.try_recv().is_err());
    }
}
