//! Config types.
//!
//! Offset map (from FINAL_AUDIT §5, §6) is preserved in comments
//! so that a reader of this file can cross-reference against the
//! binary without having to hop to the spec.

use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BotConfig {
    pub symbol: String,                          // +0x18
    #[serde(default)]
    pub current_market: Option<String>,          // +0x48
    pub max_buy_order_size: f64,                 // +0x60
    pub spread_threshold: f64,                   // +0x68
    pub trade_cooldown: i64,                     // +0x70
    pub balance_factor: f64,                     // +0x78
    pub stop_before_end_ms: i64,                 // +0x80
    pub min_price: f64,                          // +0x90
    pub max_price: f64,                          // +0x98
    pub max_position_size: f64,                  // +0xa0
    pub trade_side: TradeSideMode,               // +0xa8
    pub target_spread: f64,                      // +0xc0
    #[serde(default)]
    pub spread_reducer_probability: Option<f64>, // +0xd0
    pub interval_minutes: u32,                   // +0xe0
    pub dry_run: bool,                           // +0xe4
    // Accepted for backwards-compat with artifact configs.
    // Runtime effect is intentionally zero; see R-01 in
    // research/RETRACTED_CLAIMS.md.
    #[serde(default)]
    pub enable_gamble: bool,                     // +0xe5
    pub log_price: bool,                         // +0xe6
    pub cancel_orders_on_start: bool,            // +0xe8
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TradeSideMode {
    Both,
    BuyOnly,
    SellOnly,
}

/// Runtime state mirroring SpreadConfig (rbx+0x60 in the artifact).
/// Only live fields are modeled; decorative offsets are ignored.
#[derive(Debug, Clone)]
pub struct SpreadConfig {
    pub order_size: f64,     // +0x10
    pub edge_threshold: f64, // +0x20
    pub target_spread: f64,  // +0x28  (decays at runtime)
    pub trade_side: TradeSideMode, // +0x38
}

impl SpreadConfig {
    pub fn from_bot(cfg: &BotConfig) -> Self {
        Self {
            order_size: cfg.max_buy_order_size,
            edge_threshold: cfg.spread_threshold,
            target_spread: cfg.target_spread,
            trade_side: cfg.trade_side,
        }
    }

    /// Urgency decay per §33 / FINAL_AUDIT §8.
    /// Called each iteration where a non-zero surplus was
    /// observed at the pivot comparator.
    pub fn decay(&mut self, surplus: f64) {
        self.target_spread = (self.target_spread - surplus).max(0.0);
    }

    /// Entry gate at 0xde541. Returns true if the observed
    /// spread is wide enough that the quoter should emit.
    pub fn gate(&self, observed_spread: f64) -> bool {
        observed_spread > self.edge_threshold + self.target_spread
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn decay_floors_at_zero() {
        let mut s = SpreadConfig {
            order_size: 100.0,
            edge_threshold: 0.01,
            target_spread: 0.02,
            trade_side: TradeSideMode::Both,
        };
        s.decay(0.05);
        assert_eq!(s.target_spread, 0.0);
        s.decay(0.01);
        assert_eq!(s.target_spread, 0.0);
    }

    #[test]
    fn gate_requires_exceed_not_equal() {
        let s = SpreadConfig {
            order_size: 100.0,
            edge_threshold: 0.01,
            target_spread: 0.02,
            trade_side: TradeSideMode::Both,
        };
        assert!(!s.gate(0.03));  // equal → SKIP (jbe at 0xde541)
        assert!(s.gate(0.031));
    }
}
