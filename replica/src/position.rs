//! Shared net_position state — feeds the pivot at `0xdc931`.
//!
//! Scope: `Position` is the single source of truth for the
//! market-making unwinder's `net_position` input. The runtime
//! tick reads it each iteration; the user-channel fill task
//! writes to it as fills land; startup reconciliation seeds it
//! from REST `/data/positions`; the CLI `--seed-position` flag
//! overrides it for the unwinder live-fire test.
//!
//! Storage: `AtomicI64` scaled by `SCALE` (10^6) so fills can
//! be applied without a lock. Polymarket's on-wire convention
//! is six decimals of precision, so the scale matches exactly.
//! At ±i64::MAX / 1e6 the range is ~9.2e12 shares — far beyond
//! any realistic market.
//!
//! Observability: two additional atomics carry `last_fill_at_ms`
//! and `last_reconcile_at_ms` (millis-since-unix-epoch, 0 =
//! never). Accessed via `last_fill_age_ms_opt()` and
//! `last_reconcile_age_ms_opt()` for the periodic tick logger
//! and for any operator dashboard that wants "ms since last
//! fill" without rebuilding a local clock.

use std::sync::atomic::{AtomicI64, AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};

use crate::order::Side;

/// 10^6 — matches Polymarket's 6-decimal on-wire convention.
/// Keeping this identical to `encode_amounts`' scale means an
/// f64 share value round-trips without drift on the hot path.
pub const SCALE: i64 = 1_000_000;

/// Lock-free signed net position. `+1.0` share is represented as
/// `SCALE`. Cloneable handles share the underlying atomic.
#[derive(Debug, Clone)]
pub struct Position {
    scaled: Arc<AtomicI64>,
    /// Millis-since-unix-epoch at which the last fill was applied.
    /// `0` means no fill has ever landed on this handle. Wall
    /// clock (not monotonic) so the value survives into operator
    /// dashboards that don't share the process monotonic clock.
    last_fill_at_ms: Arc<AtomicU64>,
    /// Millis-since-unix-epoch of the last authoritative seed —
    /// startup REST reconcile or the `--seed-position` override.
    /// `0` means never seeded.
    last_reconcile_at_ms: Arc<AtomicU64>,
}

impl Position {
    pub fn new() -> Self {
        Self {
            scaled: Arc::new(AtomicI64::new(0)),
            last_fill_at_ms: Arc::new(AtomicU64::new(0)),
            last_reconcile_at_ms: Arc::new(AtomicU64::new(0)),
        }
    }

    /// Seed from a human-readable shares value. Overwrites any
    /// prior state — callers use this for startup REST reconcile
    /// and the `--seed-position` CLI override. Stamps
    /// `last_reconcile_at_ms` so the operator can tell at a glance
    /// how stale the seed is.
    pub fn seed_shares(&self, shares: f64) {
        self.scaled.store(scale_f64(shares), Ordering::Relaxed);
        self.last_reconcile_at_ms.store(now_ms(), Ordering::Relaxed);
    }

    /// Apply a fill. `side` is the taker-perspective side of the
    /// fill we received: a BUY fill adds shares, a SELL fill
    /// subtracts. (The original's `add_filled_shares` /
    /// `subtract_filled_shares` pair at 0x0b5f50 encodes the
    /// same sign convention.) Stamps `last_fill_at_ms`.
    pub fn apply_fill(&self, side: Side, shares: f64) {
        let delta = match side {
            Side::Buy => scale_f64(shares),
            Side::Sell => -scale_f64(shares),
        };
        self.scaled.fetch_add(delta, Ordering::Relaxed);
        self.last_fill_at_ms.store(now_ms(), Ordering::Relaxed);
    }

    /// Current signed position, in shares.
    pub fn shares(&self) -> f64 {
        unscale_i64(self.scaled.load(Ordering::Relaxed))
    }

    /// Raw scaled integer — exposed for tests and for any future
    /// metric emitter that wants to avoid the divide.
    pub fn scaled(&self) -> i64 {
        self.scaled.load(Ordering::Relaxed)
    }

    /// Raw last-fill wall-clock timestamp in ms since unix epoch.
    /// `0` means no fill has ever landed on this handle.
    pub fn last_fill_at_ms(&self) -> u64 {
        self.last_fill_at_ms.load(Ordering::Relaxed)
    }

    /// Raw last-reconcile wall-clock timestamp in ms since unix
    /// epoch. `0` means the handle has never been seeded.
    pub fn last_reconcile_at_ms(&self) -> u64 {
        self.last_reconcile_at_ms.load(Ordering::Relaxed)
    }

    /// Milliseconds since the last fill was applied, or `None` if
    /// no fill has ever landed. Operator-facing observability.
    pub fn last_fill_age_ms_opt(&self) -> Option<u64> {
        age_ms_opt(self.last_fill_at_ms.load(Ordering::Relaxed))
    }

    /// Milliseconds since the last reconcile / seed, or `None` if
    /// no seed has been applied.
    pub fn last_reconcile_age_ms_opt(&self) -> Option<u64> {
        age_ms_opt(self.last_reconcile_at_ms.load(Ordering::Relaxed))
    }
}

impl Default for Position {
    fn default() -> Self {
        Self::new()
    }
}

fn scale_f64(v: f64) -> i64 {
    // `.round()` guards against f64 representation error on
    // values like 0.1 that can't encode exactly — without it,
    // 0.1 * 1e6 is 99999.99999999999, which truncates to 99999.
    (v * SCALE as f64).round() as i64
}

fn unscale_i64(v: i64) -> f64 {
    v as f64 / SCALE as f64
}

fn now_ms() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_millis() as u64)
        .unwrap_or(0)
}

fn age_ms_opt(stamp_ms: u64) -> Option<u64> {
    if stamp_ms == 0 {
        return None;
    }
    let now = now_ms();
    Some(now.saturating_sub(stamp_ms))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn default_is_flat() {
        let p = Position::new();
        assert_eq!(p.shares(), 0.0);
        assert_eq!(p.scaled(), 0);
    }

    #[test]
    fn seed_round_trips_typical_values() {
        let p = Position::new();
        p.seed_shares(12.5);
        assert_eq!(p.shares(), 12.5);
        p.seed_shares(-7.25);
        assert_eq!(p.shares(), -7.25);
    }

    #[test]
    fn seed_round_trips_six_decimal_boundary() {
        let p = Position::new();
        p.seed_shares(0.000_001);
        assert_eq!(p.scaled(), 1);
        assert_eq!(p.shares(), 0.000_001);
    }

    #[test]
    fn buy_fill_adds() {
        let p = Position::new();
        p.seed_shares(10.0);
        p.apply_fill(Side::Buy, 3.5);
        assert_eq!(p.shares(), 13.5);
    }

    #[test]
    fn sell_fill_subtracts() {
        let p = Position::new();
        p.seed_shares(10.0);
        p.apply_fill(Side::Sell, 3.5);
        assert_eq!(p.shares(), 6.5);
    }

    #[test]
    fn fills_can_cross_zero() {
        let p = Position::new();
        p.seed_shares(1.0);
        p.apply_fill(Side::Sell, 3.0);
        assert_eq!(p.shares(), -2.0);
    }

    #[test]
    fn clone_shares_state() {
        let a = Position::new();
        let b = a.clone();
        a.seed_shares(5.0);
        assert_eq!(b.shares(), 5.0);
        b.apply_fill(Side::Buy, 1.0);
        assert_eq!(a.shares(), 6.0);
    }

    #[test]
    fn concurrent_fills_are_atomic() {
        use std::thread;
        let p = Position::new();
        let threads: Vec<_> = (0..8)
            .map(|_| {
                let p = p.clone();
                thread::spawn(move || {
                    for _ in 0..1000 {
                        p.apply_fill(Side::Buy, 0.001);
                    }
                })
            })
            .collect();
        for t in threads {
            t.join().unwrap();
        }
        // 8 threads × 1000 × 0.001 = 8.0 shares.
        assert_eq!(p.shares(), 8.0);
    }

    #[test]
    fn fractional_representation_lossless_at_scale() {
        // 0.1 can't be represented exactly in f64, but our
        // scale-and-round path should still give an exact integer.
        let p = Position::new();
        for _ in 0..10 {
            p.apply_fill(Side::Buy, 0.1);
        }
        assert_eq!(p.shares(), 1.0);
    }

    #[test]
    fn timestamps_default_to_none() {
        let p = Position::new();
        assert_eq!(p.last_fill_at_ms(), 0);
        assert_eq!(p.last_reconcile_at_ms(), 0);
        assert_eq!(p.last_fill_age_ms_opt(), None);
        assert_eq!(p.last_reconcile_age_ms_opt(), None);
    }

    #[test]
    fn seed_stamps_last_reconcile_but_not_last_fill() {
        let p = Position::new();
        p.seed_shares(3.0);
        assert!(p.last_reconcile_at_ms() > 0);
        assert_eq!(p.last_fill_at_ms(), 0);
        assert!(p.last_reconcile_age_ms_opt().is_some());
        assert_eq!(p.last_fill_age_ms_opt(), None);
    }

    #[test]
    fn apply_fill_stamps_last_fill_but_not_last_reconcile() {
        let p = Position::new();
        p.apply_fill(Side::Buy, 1.0);
        assert!(p.last_fill_at_ms() > 0);
        assert_eq!(p.last_reconcile_at_ms(), 0);
    }
}
