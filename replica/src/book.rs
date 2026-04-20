//! Order book snapshot + spread calc.
//!
//! Source: FINAL_AUDIT §7 (async suspend at state 3 on
//! RwLock::read of the book).

use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct BookLevel {
    pub price: f64,
    pub size: f64,
}

#[derive(Debug, Clone, Default, Deserialize)]
pub struct BookSnapshot {
    #[serde(default)]
    pub bids: Vec<BookLevel>,
    #[serde(default)]
    pub asks: Vec<BookLevel>,
}

impl BookSnapshot {
    pub fn best_bid(&self) -> Option<f64> {
        self.bids.first().map(|l| l.price)
    }

    pub fn best_ask(&self) -> Option<f64> {
        self.asks.first().map(|l| l.price)
    }

    pub fn spread(&self) -> Option<f64> {
        Some(self.best_ask()? - self.best_bid()?)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn spread_requires_both_sides() {
        let empty = BookSnapshot::default();
        assert!(empty.spread().is_none());
    }

    #[test]
    fn spread_is_ask_minus_bid() {
        let b = BookSnapshot {
            bids: vec![BookLevel { price: 0.51, size: 100.0 }],
            asks: vec![BookLevel { price: 0.53, size: 100.0 }],
        };
        assert!((b.spread().unwrap() - 0.02).abs() < 1e-9);
    }
}
