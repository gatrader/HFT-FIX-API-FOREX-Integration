//! Minimal faithful model of the 23-state run_side_capture loop.
//!
//! Source: FINAL_AUDIT §7. The original binary is an async
//! tokio closure dispatching on a state byte at rbx+0x259. A
//! replica does not need to mirror the await-graph shape; a
//! straight-line loop reproduces behavior for spec validation.
//!
//! States modeled:
//!   0  INIT
//!   3  AWAIT BOOK
//!   8  EMIT BUY
//!   15 EMIT SELL
//!   19 CANCEL (primary)
//!   22 CANCEL (secondary)
//!
//! Error-recovery and backoff branches from the original are
//! represented as a generic BACKOFF state.

use std::time::Duration;

use alloy_primitives::U256;

use crate::book::BookSnapshot;
use crate::client::TradingClient;
use crate::config::SpreadConfig;
use crate::order::{pick_side, Side};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum State {
    Init,
    AwaitBook,
    EmitBuy,
    EmitSell,
    CancelPrimary,
    CancelSecondary,
    Backoff,
    Stop,
}

/// Polymarket quote tick. Live quoting off-tick (e.g. `0.5819998`)
/// is rejected by the venue with `Invalid price`, silently drops
/// maker orders, and wastes a tick. We snap each computed quote to
/// this grid before emitting. Buy orders quantize **down** so we
/// never accidentally cross the spread into a taker buy; sell
/// orders quantize **up** so we never cross into a taker sell.
pub const PRICE_TICK: f64 = 0.001;

/// Snap `price` to the nearest tick at or below it.
pub fn quantize_price_down(price: f64, tick: f64) -> f64 {
    (price / tick).floor() * tick
}

/// Snap `price` to the nearest tick at or above it.
pub fn quantize_price_up(price: f64, tick: f64) -> f64 {
    (price / tick).ceil() * tick
}

/// Market-level inputs injected each tick. In the artifact,
/// `net_position` is tracked internally via fill callbacks; for
/// the replica it's provided by the caller of `tick`.
#[derive(Debug, Clone)]
pub struct Tick {
    pub token_id: U256,
    pub net_position: f64,
    pub book: BookSnapshot,
}

pub struct SpreadCapture {
    state: State,
    spread_cfg: SpreadConfig,
    max_position: f64,
    min_price: f64,
    max_price: f64,
}

impl SpreadCapture {
    pub fn new(
        spread_cfg: SpreadConfig,
        max_position: f64,
        min_price: f64,
        max_price: f64,
    ) -> Self {
        Self {
            state: State::Init,
            spread_cfg,
            max_position,
            min_price,
            max_price,
        }
    }

    pub fn state(&self) -> State {
        self.state
    }

    pub fn spread_cfg(&self) -> &SpreadConfig {
        &self.spread_cfg
    }

    /// Pure decision step — no I/O. Returns what the machine
    /// has chosen to do this iteration and mutates internal
    /// state (`target_spread` decay, next state) accordingly.
    ///
    /// Split out from `tick` so tests can drive the state
    /// machine with synthetic data and assert invariants
    /// without a live `TradingClient`.
    ///
    /// Each call conceptually re-enters AwaitBook: any side
    /// effect from the previous decision (emit / cancel) is
    /// assumed resolved by the caller before the next tick.
    pub fn decide(&mut self, tick: &Tick) -> Decision {
        if self.state == State::Stop {
            return Decision::Skip;
        }
        self.state = State::AwaitBook;

        // Gate (0xde541) — SKIP if observed spread not wide
        // enough given current urgency.
        let Some(spread) = tick.book.spread() else {
            self.state = State::Backoff;
            return Decision::Skip;
        };
        if !self.spread_cfg.gate(spread) {
            self.state = State::CancelSecondary;
            return Decision::CancelSecondary;
        }

        // Pivot (0xdc931) — decides BUY vs SELL or SKIP.
        let Some((side, surplus)) = pick_side(
            tick.net_position,
            self.max_position,
            self.spread_cfg.trade_side,
        ) else {
            self.state = State::CancelPrimary;
            return Decision::CancelPrimary;
        };

        // Urgency decay only applied when the pivot actually
        // identifies surplus (§33 / FINAL_AUDIT §8).
        self.spread_cfg.decay(surplus);

        let raw_price = match side {
            Side::Buy => self
                .min_price
                .max(tick.book.best_bid().unwrap_or(self.min_price)),
            Side::Sell => self
                .max_price
                .min(tick.book.best_ask().unwrap_or(self.max_price)),
        };
        // Snap to the venue tick before encoding. Without this, a
        // best-bid that arrives as `0.5819998` (rest-path JSON
        // rounding) produces an off-tick quote the CLOB rejects.
        let price = match side {
            Side::Buy => quantize_price_down(raw_price, PRICE_TICK),
            Side::Sell => quantize_price_up(raw_price, PRICE_TICK),
        };
        let size = self.spread_cfg.order_size;
        let (maker_amount, taker_amount) = encode_amounts(side, price, size);

        self.state = match side {
            Side::Buy => State::EmitBuy,
            Side::Sell => State::EmitSell,
        };

        Decision::Emit {
            side,
            price,
            size,
            maker_amount,
            taker_amount,
            surplus,
        }
    }

    /// Drives one step of the state machine and dispatches to
    /// the client when the decision is an EMIT. Returns the
    /// next state.
    pub async fn tick(
        &mut self,
        tick: &Tick,
        client: &TradingClient,
    ) -> anyhow::Result<State> {
        match self.decide(tick) {
            Decision::Emit {
                side,
                maker_amount,
                taker_amount,
                ..
            } => {
                client
                    .place_single_order(
                        tick.token_id,
                        maker_amount,
                        taker_amount,
                        side,
                    )
                    .await?;
                self.state = State::AwaitBook;
            }
            Decision::CancelPrimary | Decision::CancelSecondary => {
                // The original issues a CANCEL batch. Replica's
                // cancel path is delegated (not wired in this
                // minimal build). Proceed.
                self.state = State::AwaitBook;
            }
            Decision::Skip => {
                if self.state == State::Backoff {
                    tokio::time::sleep(Duration::from_millis(250)).await;
                    self.state = State::AwaitBook;
                }
            }
        }
        Ok(self.state)
    }
}

/// What the state machine decided to do this iteration.
#[derive(Debug, Clone, PartialEq)]
pub enum Decision {
    /// Emit an order for `side` at `price` with `size` shares.
    Emit {
        side: Side,
        price: f64,
        size: f64,
        maker_amount: U256,
        taker_amount: U256,
        surplus: f64,
    },
    /// Cancel active orders — pivot said no rebalance needed.
    CancelPrimary,
    /// Cancel active orders — gate said spread too tight.
    CancelSecondary,
    /// No decision this iteration (init, backoff, etc.).
    Skip,
}

/// Convert (price, size) into (makerAmount, takerAmount) in the
/// Polymarket 6-decimal integer convention.
///
/// BUY:  taker_amount = shares, maker_amount = price * shares
/// SELL: maker_amount = shares, taker_amount = price * shares
///
/// `.round()` rather than truncation: f64 can't encode every
/// 6-decimal value exactly, so `0.581 * 10.0 * 1e6` evaluates to
/// `5_809_999.999…`. Truncating via `as u128` drops that to
/// `5_809_999`, which signs as the wrong integer and either gets
/// rejected by the CLOB or posts an off-by-one-micro order. Round
/// to the nearest micro instead.
pub fn encode_amounts(side: Side, price: f64, size: f64) -> (U256, U256) {
    let scale = 1_000_000.0;
    let shares = (size * scale).round() as u128;
    let notional = (price * size * scale).round() as u128;
    match side {
        Side::Buy => (U256::from(notional), U256::from(shares)),
        Side::Sell => (U256::from(shares), U256::from(notional)),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn encode_amounts_buy_uses_notional_on_maker() {
        let (m, t) = encode_amounts(Side::Buy, 0.50, 100.0);
        assert_eq!(m, U256::from(50_000_000u128));
        assert_eq!(t, U256::from(100_000_000u128));
    }

    #[test]
    fn encode_amounts_sell_swaps() {
        let (m, t) = encode_amounts(Side::Sell, 0.50, 100.0);
        assert_eq!(m, U256::from(100_000_000u128));
        assert_eq!(t, U256::from(50_000_000u128));
    }

    #[test]
    fn quantize_down_snaps_off_tick_to_nearest_lower_tick() {
        // 0.5819998 — classic f64 round-trip on a REST tick reply.
        // BUY must go to 0.581, never 0.582 (would cross the spread).
        assert!((quantize_price_down(0.5819998, PRICE_TICK) - 0.581).abs() < 1e-9);
        // On-tick input is a no-op.
        assert!((quantize_price_down(0.581, PRICE_TICK) - 0.581).abs() < 1e-9);
    }

    #[test]
    fn quantize_up_snaps_off_tick_to_nearest_higher_tick() {
        // SELL side: 0.5800002 must go to 0.581, never 0.580.
        assert!((quantize_price_up(0.5800002, PRICE_TICK) - 0.581).abs() < 1e-9);
        // On-tick input is a no-op.
        assert!((quantize_price_up(0.581, PRICE_TICK) - 0.581).abs() < 1e-9);
    }

    #[test]
    fn encode_amounts_rounds_rather_than_truncates() {
        // 0.581 * 10 * 1e6 evaluates to 5_809_999.999…; truncating
        // drops it to 5_809_999, which is the regression live
        // validation exposed. Rounding gives 5_810_000.
        let (m, _) = encode_amounts(Side::Buy, 0.581, 10.0);
        assert_eq!(m, U256::from(5_810_000u128));
    }

    #[test]
    fn encode_amounts_rounds_size_exactly() {
        // 0.1 * 1e6 evaluates to 99_999.999…; truncation gives
        // 99_999 (silently loses a micro-share). Round trip must
        // give exactly 100_000.
        let (_, t) = encode_amounts(Side::Buy, 0.50, 0.1);
        assert_eq!(t, U256::from(100_000u128));
    }
}
