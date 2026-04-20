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

    /// Drives one step of the state machine using the provided
    /// tick and issuing a side effect through `client` when the
    /// current state is an EMIT or CANCEL state. Returns the
    /// next state.
    pub async fn tick(
        &mut self,
        tick: &Tick,
        client: &TradingClient,
    ) -> anyhow::Result<State> {
        self.state = match self.state {
            State::Init => State::AwaitBook,

            State::AwaitBook => {
                // Gate (0xde541) — SKIP if observed spread not
                // wide enough given current urgency.
                let Some(spread) = tick.book.spread() else {
                    return Ok(self.advance(State::Backoff));
                };
                if !self.spread_cfg.gate(spread) {
                    return Ok(self.advance(State::CancelSecondary));
                }

                // Pivot (0xdc931) — decides BUY vs SELL.
                let Some((side, surplus)) = pick_side(
                    tick.net_position,
                    self.max_position,
                    self.spread_cfg.trade_side,
                ) else {
                    return Ok(self.advance(State::CancelPrimary));
                };

                // Urgency decay.
                self.spread_cfg.decay(surplus);

                match side {
                    Side::Buy => State::EmitBuy,
                    Side::Sell => State::EmitSell,
                }
            }

            State::EmitBuy => {
                let price = self.min_price.max(
                    tick.book.best_bid().unwrap_or(self.min_price),
                );
                let size = self.spread_cfg.order_size;
                let (maker_amount, taker_amount) =
                    encode_amounts(Side::Buy, price, size);
                client
                    .place_single_order(
                        tick.token_id,
                        maker_amount,
                        taker_amount,
                        Side::Buy,
                    )
                    .await?;
                State::AwaitBook
            }

            State::EmitSell => {
                let price = self.max_price.min(
                    tick.book.best_ask().unwrap_or(self.max_price),
                );
                let size = self.spread_cfg.order_size;
                let (maker_amount, taker_amount) =
                    encode_amounts(Side::Sell, price, size);
                client
                    .place_single_order(
                        tick.token_id,
                        maker_amount,
                        taker_amount,
                        Side::Sell,
                    )
                    .await?;
                State::AwaitBook
            }

            State::CancelPrimary | State::CancelSecondary => {
                // The original issues a CANCEL batch here. The
                // replica's cancel path is delegated to the
                // caller via a hook (not wired in this minimal
                // build). Proceeding directly.
                State::AwaitBook
            }

            State::Backoff => {
                tokio::time::sleep(Duration::from_millis(250)).await;
                State::AwaitBook
            }

            State::Stop => State::Stop,
        };
        Ok(self.state)
    }

    fn advance(&mut self, s: State) -> State {
        self.state = s;
        s
    }
}

/// Convert (price, size) into (makerAmount, takerAmount) in the
/// Polymarket 6-decimal integer convention.
///
/// BUY:  taker_amount = shares, maker_amount = price * shares
/// SELL: maker_amount = shares, taker_amount = price * shares
pub fn encode_amounts(side: Side, price: f64, size: f64) -> (U256, U256) {
    let scale = 1_000_000.0;
    let shares = (size * scale) as u128;
    let notional = (price * size * scale) as u128;
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
}
