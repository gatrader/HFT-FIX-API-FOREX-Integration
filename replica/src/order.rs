//! Polymarket CLOB order struct and EIP-712 type.
//!
//! Source: FINAL_AUDIT §9, §10 (via register_order @ 0xe2825).

use alloy_primitives::{address, Address, U256};
use alloy_sol_types::{eip712_domain, sol, Eip712Domain};
use serde::Serialize;

/// Side of an order. u8 encoding matches the artifact:
/// - 0 = BUY  (Side byte written at 0xde731)
/// - 1 = SELL (Side byte written at 0xdf7da)
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum Side {
    Buy = 0,
    Sell = 1,
}

impl Side {
    pub fn as_u8(self) -> u8 {
        self as u8
    }
}

sol! {
    /// EIP-712 typed order struct matching Polymarket CTF Exchange.
    struct Order {
        uint256 salt;
        address maker;
        address signer;
        address taker;
        uint256 tokenId;
        uint256 makerAmount;
        uint256 takerAmount;
        uint256 expiration;
        uint256 nonce;
        uint256 feeRateBps;
        uint8   side;
        uint8   signatureType;
    }
}

/// JSON-wire representation of the signed order.
///
/// Field casing + side encoding match Polymarket CLOB's POST /order
/// schema (camelCase, side as "BUY"/"SELL" string), verified against
/// the live server's error responses on 2026-04-20.
#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ClobOrder {
    /// u64 on the wire (JSON number). Polymarket's order-api
    /// unmarshals salt into a Go int64 — a 256-bit string is
    /// rejected as "Invalid order payload".
    pub salt: u64,
    pub maker: Address,
    pub signer: Address,
    pub taker: Address,
    pub token_id: String,
    pub maker_amount: String,
    pub taker_amount: String,
    pub expiration: String,
    pub nonce: String,
    pub fee_rate_bps: String,
    pub side: String,
    pub signature_type: u8,
}

impl ClobOrder {
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        salt: u64,
        maker: Address,
        signer: Address,
        token_id: U256,
        maker_amount: U256,
        taker_amount: U256,
        expiration: U256,
        nonce: U256,
        fee_rate_bps: U256,
        side: Side,
        signature_type: u8,
    ) -> Self {
        Self {
            salt,
            maker,
            signer,
            taker: Address::ZERO,
            token_id: token_id.to_string(),
            maker_amount: maker_amount.to_string(),
            taker_amount: taker_amount.to_string(),
            expiration: expiration.to_string(),
            nonce: nonce.to_string(),
            fee_rate_bps: fee_rate_bps.to_string(),
            side: match side {
                Side::Buy => "BUY".into(),
                Side::Sell => "SELL".into(),
            },
            signature_type,
        }
    }

    pub fn to_eip712(&self) -> Order {
        Order {
            salt: U256::from(self.salt),
            maker: self.maker,
            signer: self.signer,
            taker: self.taker,
            tokenId: self.token_id.parse().expect("token_id"),
            makerAmount: self.maker_amount.parse().expect("maker_amount"),
            takerAmount: self.taker_amount.parse().expect("taker_amount"),
            expiration: self.expiration.parse().expect("expiration"),
            nonce: self.nonce.parse().expect("nonce"),
            feeRateBps: self.fee_rate_bps.parse().expect("fee_rate_bps"),
            side: match self.side.as_str() {
                "BUY" => 0,
                "SELL" => 1,
                other => panic!("invalid side str: {other}"),
            },
            signatureType: self.signature_type,
        }
    }
}

pub fn polymarket_domain() -> Eip712Domain {
    eip712_domain! {
        name: "Polymarket CTF Exchange",
        version: "1",
        chain_id: 137,
        verifying_contract: address!("4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E"),
    }
}

/// Side selection per §33.1 / 0xdc931.
///
/// `net_position` is the bot's current signed position in this
/// market (positive = long, negative = short).
/// `max_position` is the magnitude beyond which rebalancing fires.
///
/// Returns `None` when no rebalance is required, or when the
/// mode suppresses the side that would otherwise fire.
pub fn pick_side(
    net_position: f64,
    max_position: f64,
    mode: crate::config::TradeSideMode,
) -> Option<(Side, f64)> {
    let abs = net_position.abs();
    if abs <= max_position {
        return None;
    }
    let surplus = abs - max_position;
    let side = if net_position > 0.0 { Side::Sell } else { Side::Buy };
    use crate::config::TradeSideMode::*;
    match (mode, side) {
        (BuyOnly, Side::Sell) => None,
        (SellOnly, Side::Buy) => None,
        _ => Some((side, surplus)),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::config::TradeSideMode;

    #[test]
    fn pivot_skip_when_within_bounds() {
        assert!(pick_side(5.0, 10.0, TradeSideMode::Both).is_none());
        assert!(pick_side(-10.0, 10.0, TradeSideMode::Both).is_none());
    }

    #[test]
    fn pivot_sell_on_long_excess() {
        let (side, surplus) =
            pick_side(15.0, 10.0, TradeSideMode::Both).unwrap();
        assert_eq!(side, Side::Sell);
        assert!((surplus - 5.0).abs() < 1e-9);
    }

    #[test]
    fn pivot_buy_on_short_excess() {
        let (side, surplus) =
            pick_side(-15.0, 10.0, TradeSideMode::Both).unwrap();
        assert_eq!(side, Side::Buy);
        assert!((surplus - 5.0).abs() < 1e-9);
    }

    #[test]
    fn mode_suppresses_disallowed_side() {
        assert!(pick_side(15.0, 10.0, TradeSideMode::BuyOnly).is_none());
        assert!(pick_side(-15.0, 10.0, TradeSideMode::SellOnly).is_none());
    }
}
