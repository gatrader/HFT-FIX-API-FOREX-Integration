//! Order book snapshot + spread calc.
//!
//! Source: FINAL_AUDIT §7 (async suspend at state 3 on
//! RwLock::read of the book).

use std::time::Instant;

use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct BookLevel {
    #[serde(deserialize_with = "de_f64_str_or_num")]
    pub price: f64,
    #[serde(deserialize_with = "de_f64_str_or_num")]
    pub size: f64,
}

// Polymarket's REST /book emits price and size as JSON strings
// (e.g. "0.01"), while some other surfaces use bare numbers.
// Accept both so the REST fallback path actually decodes.
fn de_f64_str_or_num<'de, D>(d: D) -> Result<f64, D::Error>
where
    D: serde::Deserializer<'de>,
{
    use serde::de::Error;
    #[derive(Deserialize)]
    #[serde(untagged)]
    enum StrOrNum {
        Num(f64),
        Str(String),
    }
    match StrOrNum::deserialize(d)? {
        StrOrNum::Num(n) => Ok(n),
        StrOrNum::Str(s) => s.parse::<f64>().map_err(D::Error::custom),
    }
}

#[derive(Debug, Clone, Default, Deserialize)]
pub struct BookSnapshot {
    #[serde(default)]
    pub bids: Vec<BookLevel>,
    #[serde(default)]
    pub asks: Vec<BookLevel>,
    /// Monotonic timestamp of when this snapshot was written into
    /// the cache (by `TradingClient::fetch_book` or, later, by the
    /// WS ingest task). `None` until the first successful write.
    ///
    /// Not deserialized from the wire — the server doesn't carry
    /// a local timestamp. Stamped client-side only.
    #[serde(skip)]
    pub last_updated_at: Option<Instant>,
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

    /// Age of the cached snapshot in milliseconds, or `None` if the
    /// cache has never been populated. Used by the decision loop
    /// to gate on book freshness (phase 2 / WS ingest).
    pub fn book_age_ms(&self) -> Option<u64> {
        self.last_updated_at
            .map(|t| t.elapsed().as_millis() as u64)
    }

    /// Stamp this snapshot with the current monotonic clock.
    /// Call after a successful REST fetch or WS delta apply.
    pub fn stamp_now(&mut self) {
        self.last_updated_at = Some(Instant::now());
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::thread::sleep;
    use std::time::Duration;

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
            last_updated_at: None,
        };
        assert!((b.spread().unwrap() - 0.02).abs() < 1e-9);
    }

    #[test]
    fn book_age_none_until_stamped() {
        let b = BookSnapshot::default();
        assert!(b.book_age_ms().is_none());
    }

    #[test]
    fn book_age_advances_after_stamp() {
        let mut b = BookSnapshot::default();
        b.stamp_now();
        sleep(Duration::from_millis(10));
        let age = b.book_age_ms().expect("stamped");
        assert!(age >= 9, "expected age >= 9ms, got {age}");
        assert!(age < 500, "sanity: age should be small, got {age}");
    }

    #[test]
    fn deserialize_ignores_last_updated_at() {
        // Wire payload has no such field — must deserialize cleanly.
        let json = r#"{ "bids": [], "asks": [] }"#;
        let b: BookSnapshot = serde_json::from_str(json).unwrap();
        assert!(b.last_updated_at.is_none());
    }

    #[test]
    fn deserialize_polymarket_string_prices() {
        // Real format from clob.polymarket.com /book: price/size are
        // JSON strings, not numbers. Must still decode to f64.
        let json = r#"{
            "bids":[{"price":"0.24","size":"849170.25"}],
            "asks":[{"price":"0.26","size":"59223.73"}]
        }"#;
        let b: BookSnapshot = serde_json::from_str(json).unwrap();
        assert!((b.best_bid().unwrap() - 0.24).abs() < 1e-9);
        assert!((b.best_ask().unwrap() - 0.26).abs() < 1e-9);
        assert!((b.bids[0].size - 849170.25).abs() < 1e-3);
    }

    #[test]
    fn deserialize_numeric_prices_still_work() {
        let json = r#"{
            "bids":[{"price":0.24,"size":849170.25}],
            "asks":[{"price":0.26,"size":59223.73}]
        }"#;
        let b: BookSnapshot = serde_json::from_str(json).unwrap();
        assert!((b.best_bid().unwrap() - 0.24).abs() < 1e-9);
        assert!((b.best_ask().unwrap() - 0.26).abs() < 1e-9);
    }
}
