//! Replay harness (IMPLEMENTATION_SPEC §13, step 2).
//!
//! Drives the SpreadCapture state machine through a curated
//! sequence of synthetic ticks and asserts the observable
//! behavioral invariants from FINAL_AUDIT.md:
//!
//! 1. Pivot fires only when `|net_pos| > max_pos`.
//! 2. `target_spread` decays monotonically while surplus is
//!    present; floors at 0.
//! 3. BUY↔SELL direction matches the sign of `net_pos`.
//! 4. Gate blocks emission when observed spread is too tight.
//! 5. Mode suppression: `BuyOnly`/`SellOnly` never emits the
//!    disallowed side.
//!
//! No network, no signer. Pure state-machine validation.

use alloy_primitives::U256;

use arbigab_replica::book::{BookLevel, BookSnapshot};
use arbigab_replica::config::{SpreadConfig, TradeSideMode};
use arbigab_replica::order::Side;
use arbigab_replica::state_machine::{Decision, SpreadCapture, Tick};

fn book(bid: f64, ask: f64) -> BookSnapshot {
    BookSnapshot {
        bids: vec![BookLevel { price: bid, size: 1000.0 }],
        asks: vec![BookLevel { price: ask, size: 1000.0 }],
    }
}

fn mk(cfg: SpreadConfig, max_position: f64) -> SpreadCapture {
    SpreadCapture::new(cfg, max_position, 0.01, 0.99)
}

fn base_cfg() -> SpreadConfig {
    SpreadConfig {
        order_size: 100.0,
        edge_threshold: 0.02,
        target_spread: 0.03,
        trade_side: TradeSideMode::Both,
    }
}

fn tick_of(net_position: f64, book: BookSnapshot) -> Tick {
    Tick {
        token_id: U256::from(1u64),
        net_position,
        book,
    }
}

// ─────────────────────────── Invariant 1 ───────────────────────────
// Pivot fires only when |net_pos| > max_pos.

#[test]
fn within_bounds_cancels_primary_not_emits() {
    let mut sm = mk(base_cfg(), 10.0);
    // Warm up out of Init.
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    let d = sm.decide(&tick_of(5.0, book(0.40, 0.50)));
    assert_eq!(d, Decision::CancelPrimary,
        "in-bounds net_position must not emit");
}

#[test]
fn at_boundary_still_cancels() {
    let mut sm = mk(base_cfg(), 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    // |net_pos| == max_pos → ucomisd jbe skips (§33.1).
    let d = sm.decide(&tick_of(10.0, book(0.40, 0.50)));
    assert_eq!(d, Decision::CancelPrimary,
        "equality case must NOT emit (matches jbe at 0xdc935)");
}

#[test]
fn exceeding_bounds_emits() {
    let mut sm = mk(base_cfg(), 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    let d = sm.decide(&tick_of(15.0, book(0.40, 0.50)));
    match d {
        Decision::Emit { .. } => {}
        other => panic!("expected Emit, got {other:?}"),
    }
}

// ─────────────────────────── Invariant 2 ───────────────────────────
// target_spread decays monotonically; floors at zero.

#[test]
fn target_spread_decays_each_emit() {
    let mut sm = mk(base_cfg(), 10.0);
    let initial = sm.spread_cfg().target_spread;
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50))); // warm-up
    // Three surplus-producing ticks.
    for (step, pos) in [12.0, 14.0, 16.0].iter().enumerate() {
        let d = sm.decide(&tick_of(*pos, book(0.40, 0.50)));
        assert!(matches!(d, Decision::Emit { .. }),
            "step {step} should emit");
    }
    let after = sm.spread_cfg().target_spread;
    assert!(after < initial,
        "target_spread should have decayed: before={initial} after={after}");
}

#[test]
fn target_spread_floors_at_zero() {
    let mut cfg = base_cfg();
    cfg.target_spread = 0.01;
    let mut sm = mk(cfg, 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    // Big surplus should overshoot.
    let _ = sm.decide(&tick_of(1000.0, book(0.40, 0.50)));
    assert_eq!(sm.spread_cfg().target_spread, 0.0,
        "target_spread must never go negative");
    // Subsequent decay on zero should remain zero.
    let _ = sm.decide(&tick_of(1000.0, book(0.40, 0.50)));
    assert_eq!(sm.spread_cfg().target_spread, 0.0);
}

#[test]
fn no_decay_when_no_surplus() {
    let mut sm = mk(base_cfg(), 10.0);
    let before = sm.spread_cfg().target_spread;
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50))); // warm-up
    for _ in 0..5 {
        let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    }
    assert_eq!(sm.spread_cfg().target_spread, before,
        "no surplus → no decay");
}

// ─────────────────────────── Invariant 3 ───────────────────────────
// BUY↔SELL direction matches sign of net_pos.

#[test]
fn long_excess_emits_sell() {
    let mut sm = mk(base_cfg(), 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    let d = sm.decide(&tick_of(25.0, book(0.40, 0.50)));
    match d {
        Decision::Emit { side, .. } => assert_eq!(side, Side::Sell),
        other => panic!("expected Emit SELL, got {other:?}"),
    }
}

#[test]
fn short_excess_emits_buy() {
    let mut sm = mk(base_cfg(), 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.40, 0.50)));
    let d = sm.decide(&tick_of(-25.0, book(0.40, 0.50)));
    match d {
        Decision::Emit { side, .. } => assert_eq!(side, Side::Buy),
        other => panic!("expected Emit BUY, got {other:?}"),
    }
}

// ─────────────────────────── Invariant 4 ───────────────────────────
// Gate blocks emission when observed spread is too tight.

#[test]
fn tight_spread_cancels_secondary() {
    let mut cfg = base_cfg();
    cfg.edge_threshold = 0.02;
    cfg.target_spread = 0.03; // total threshold = 0.05
    let mut sm = mk(cfg, 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.48, 0.50))); // spread 0.02 < 0.05
    let d = sm.decide(&tick_of(25.0, book(0.48, 0.50)));
    assert_eq!(d, Decision::CancelSecondary,
        "tight spread must block even when pivot would fire");
}

#[test]
fn wide_spread_permits_emission() {
    let mut cfg = base_cfg();
    cfg.edge_threshold = 0.02;
    cfg.target_spread = 0.03;
    let mut sm = mk(cfg, 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.30, 0.70))); // spread 0.40 >> 0.05
    let d = sm.decide(&tick_of(25.0, book(0.30, 0.70)));
    assert!(matches!(d, Decision::Emit { .. }),
        "wide spread + surplus → emit");
}

// ─────────────────────────── Invariant 5 ───────────────────────────
// Mode suppression.

#[test]
fn buy_only_mode_suppresses_sell_emission() {
    let mut cfg = base_cfg();
    cfg.trade_side = TradeSideMode::BuyOnly;
    let mut sm = mk(cfg, 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.30, 0.70)));
    // Long excess would normally emit SELL — but BuyOnly kills it.
    let d = sm.decide(&tick_of(25.0, book(0.30, 0.70)));
    assert_eq!(d, Decision::CancelPrimary,
        "BuyOnly mode must suppress SELL emissions");
}

#[test]
fn sell_only_mode_suppresses_buy_emission() {
    let mut cfg = base_cfg();
    cfg.trade_side = TradeSideMode::SellOnly;
    let mut sm = mk(cfg, 10.0);
    let _ = sm.decide(&tick_of(0.0, book(0.30, 0.70)));
    let d = sm.decide(&tick_of(-25.0, book(0.30, 0.70)));
    assert_eq!(d, Decision::CancelPrimary,
        "SellOnly mode must suppress BUY emissions");
}

// ─────────────────── Sequential regression ───────────────────
// A realistic 10-tick replay. Starts flat, accumulates long
// inventory, observes target_spread decay, flips to SELL, then
// reaches steady state under tight spread.

#[test]
fn replay_scenario_long_inventory_accumulation() {
    let mut sm = mk(base_cfg(), 10.0);
    let events = [
        // (net_pos, bid, ask, expected_kind)
        (0.0,  0.30, 0.70, "CancelPrimary"), // within bounds
        (12.0, 0.30, 0.70, "Emit Sell"),     // long excess
        (14.0, 0.30, 0.70, "Emit Sell"),     // still long, decay fires
        (16.0, 0.30, 0.70, "Emit Sell"),
        (15.0, 0.495, 0.500, "CancelSecondary"), // gate closes (spread 0.005 < 0.02)
        (5.0,  0.30, 0.70, "CancelPrimary"),   // back in bounds
        (-20.0, 0.30, 0.70, "Emit Buy"),       // short excess
        (-18.0, 0.30, 0.70, "Emit Buy"),
        (0.0,   0.30, 0.70, "CancelPrimary"),  // flat again
    ];

    let initial_ts = sm.spread_cfg().target_spread;
    let mut last_ts = initial_ts;
    let mut emits = 0;

    for (i, (net, bid, ask, kind)) in events.iter().enumerate() {
        let d = sm.decide(&tick_of(*net, book(*bid, *ask)));
        let actual = match &d {
            Decision::Emit { side: Side::Buy, .. } => "Emit Buy",
            Decision::Emit { side: Side::Sell, .. } => "Emit Sell",
            Decision::CancelPrimary => "CancelPrimary",
            Decision::CancelSecondary => "CancelSecondary",
            Decision::Skip => "Skip",
        };
        assert_eq!(
            actual, *kind,
            "step {i} (net={net}) expected {kind}, got {actual}"
        );

        // target_spread must be monotonically non-increasing.
        let ts = sm.spread_cfg().target_spread;
        assert!(
            ts <= last_ts + 1e-12,
            "step {i}: target_spread rose from {last_ts} to {ts}"
        );
        last_ts = ts;

        if matches!(d, Decision::Emit { .. }) {
            emits += 1;
        }
    }

    assert!(emits >= 5, "expected at least 5 emits, saw {emits}");
    assert!(last_ts < initial_ts, "target_spread should have decayed");
    assert!(last_ts >= 0.0, "target_spread must never go negative");
}
