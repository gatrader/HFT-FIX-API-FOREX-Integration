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

// REST /book sends `timestamp` as a ms-unix string ("1776727735110");
// WS messages tend to send it as a number. Accept either, optional.
fn de_opt_u64_str_or_num<'de, D>(d: D) -> Result<Option<u64>, D::Error>
where
    D: serde::Deserializer<'de>,
{
    use serde::de::Error;
    #[derive(Deserialize)]
    #[serde(untagged)]
    enum StrOrNum {
        Num(u64),
        Str(String),
    }
    match Option::<StrOrNum>::deserialize(d)? {
        None => Ok(None),
        Some(StrOrNum::Num(n)) => Ok(Some(n)),
        Some(StrOrNum::Str(s)) => s
            .parse::<u64>()
            .map(Some)
            .map_err(D::Error::custom),
    }
}

#[derive(Debug, Clone, Default, Deserialize)]
pub struct BookSnapshot {
    #[serde(default)]
    pub bids: Vec<BookLevel>,
    #[serde(default)]
    pub asks: Vec<BookLevel>,
    /// Server-stamped ms-unix timestamp from the /book payload, if
    /// present. Polymarket sends this as a JSON string; WS variants
    /// may send it as a number. Optional — we still rely on the
    /// monotonic client stamp below for the hot-path freshness gate.
    #[serde(
        default,
        rename = "timestamp",
        deserialize_with = "de_opt_u64_str_or_num"
    )]
    pub server_timestamp_ms: Option<u64>,
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
    /// Best (highest) bid across the book, regardless of wire order.
    ///
    /// Polymarket's REST /book emits bids ascending (worst→best), so
    /// `.first()` would return the WORST bid. We scan the whole
    /// vector; it's bounded (single-market depth) and the hot path
    /// already iterates bids/asks once per decision.
    pub fn best_bid(&self) -> Option<f64> {
        self.bids
            .iter()
            .map(|l| l.price)
            .filter(|p| p.is_finite())
            .reduce(f64::max)
    }

    /// Best (lowest) ask across the book, regardless of wire order.
    /// See `best_bid` — REST /book emits asks descending (worst→best).
    pub fn best_ask(&self) -> Option<f64> {
        self.asks
            .iter()
            .map(|l| l.price)
            .filter(|p| p.is_finite())
            .reduce(f64::min)
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
            ..BookSnapshot::default()
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

    // Captured verbatim from clob.polymarket.com/book for the
    // Hormuz YES token (2026-04-20). Bids are low→high (0.01 → 0.25)
    // and asks are high→low (0.99 → 0.26), which is the exact
    // ordering that broke the replica's top-of-book in the first
    // EC2 A/B smoke run.
    const LIVE_BOOK_PAYLOAD: &str = r#"{
        "market":"0x924a2942747dd75703321a7c8d809c68f6a514c3b0f2a2e64274e02310634669",
        "asset_id":"77893140510362582253172593084218413010407941075415081594586195705930819989216",
        "timestamp":"1776727735110",
        "hash":"855d14500db34b81d4dfe2e9b24572210a8a6806",
        "bids":[
            {"price":"0.01","size":"1184696.81"},
            {"price":"0.10","size":"23988.10"},
            {"price":"0.24","size":"849170.25"},
            {"price":"0.25","size":"143009.02"}
        ],
        "asks":[
            {"price":"0.99","size":"37328.92"},
            {"price":"0.80","size":"5194.58"},
            {"price":"0.30","size":"12348.85"},
            {"price":"0.26","size":"59223.73"}
        ],
        "min_order_size":"5",
        "tick_size":"0.01",
        "neg_risk":false,
        "last_trade_price":"0.750"
    }"#;

    #[test]
    fn deserialize_live_polymarket_payload_shape() {
        // Must decode despite: string-encoded prices/sizes, string
        // timestamp, extra unknown fields (market, asset_id, hash,
        // min_order_size, tick_size, neg_risk, last_trade_price).
        let b: BookSnapshot = serde_json::from_str(LIVE_BOOK_PAYLOAD).unwrap();
        assert_eq!(b.bids.len(), 4);
        assert_eq!(b.asks.len(), 4);
        assert_eq!(b.server_timestamp_ms, Some(1_776_727_735_110));
    }

    #[test]
    fn best_prices_ignore_wire_ordering() {
        // The live payload is intentionally NOT best-first. The replica
        // must compute best_bid = max(bids), best_ask = min(asks) so
        // top-of-book is correct no matter how the server orders levels.
        let b: BookSnapshot = serde_json::from_str(LIVE_BOOK_PAYLOAD).unwrap();
        assert!(
            (b.best_bid().unwrap() - 0.25).abs() < 1e-9,
            "best_bid should be max(bids) = 0.25, got {:?}",
            b.best_bid()
        );
        assert!(
            (b.best_ask().unwrap() - 0.26).abs() < 1e-9,
            "best_ask should be min(asks) = 0.26, got {:?}",
            b.best_ask()
        );
        // Spread across the inside is 0.26 - 0.25 = 0.01 — sane.
        assert!((b.spread().unwrap() - 0.01).abs() < 1e-9);
    }

    #[test]
    fn best_prices_handle_scrambled_ordering() {
        // Defense in depth: even with random ordering, the math holds.
        let b = BookSnapshot {
            bids: vec![
                BookLevel { price: 0.10, size: 1.0 },
                BookLevel { price: 0.25, size: 1.0 },
                BookLevel { price: 0.15, size: 1.0 },
                BookLevel { price: 0.01, size: 1.0 },
            ],
            asks: vec![
                BookLevel { price: 0.50, size: 1.0 },
                BookLevel { price: 0.26, size: 1.0 },
                BookLevel { price: 0.99, size: 1.0 },
                BookLevel { price: 0.40, size: 1.0 },
            ],
            ..BookSnapshot::default()
        };
        assert_eq!(b.best_bid(), Some(0.25));
        assert_eq!(b.best_ask(), Some(0.26));
    }

    #[test]
    fn deserialize_numeric_timestamp_also_works() {
        // WS-flavored payload with a numeric timestamp.
        let json = r#"{
            "bids":[{"price":"0.49","size":"1"}],
            "asks":[{"price":"0.51","size":"1"}],
            "timestamp": 1776727735110
        }"#;
        let b: BookSnapshot = serde_json::from_str(json).unwrap();
        assert_eq!(b.server_timestamp_ms, Some(1_776_727_735_110));
    }

    #[test]
    fn missing_timestamp_is_none_not_error() {
        let json = r#"{ "bids": [], "asks": [] }"#;
        let b: BookSnapshot = serde_json::from_str(json).unwrap();
        assert!(b.server_timestamp_ms.is_none());
    }
}
