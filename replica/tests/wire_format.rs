//! Wire-format signature test (IMPLEMENTATION_SPEC §13, canary prerequisite).
//!
//! Proves, without any network or external key material, that the
//! replica's EIP-712 signing path produces a signature that:
//!
//! 1. Recovers back to the maker address that signed it.
//! 2. Signs the exact Polymarket CTF Exchange domain (name, version,
//!    chainId, verifyingContract) observed in the artifact's .rodata.
//! 3. Serializes into a JSON object whose field names match the
//!    Polymarket CLOB `/data/orders` schema.
//!
//! A clean green on this test is the strongest offline guarantee
//! that a live canary won't fail because of malformed bytes — it
//! can still fail on auth, market state, or funding, but those are
//! orthogonal concerns.

use alloy_primitives::{address, Address, FixedBytes, U256};
use alloy_signer::Signature;
use alloy_signer_local::PrivateKeySigner;
use alloy_sol_types::SolStruct;

use arbigab_replica::order::{polymarket_domain, ClobOrder, Order, Side};
use arbigab_replica::signer::Eip712Signer;

/// Deterministic throwaway key. Value chosen to be obviously
/// test-only; never fund this address.
const TEST_KEY: &str =
    "0000000000000000000000000000000000000000000000000000000000000001";

fn sample_order(maker: Address) -> ClobOrder {
    ClobOrder::new(
        U256::from(42u64),                // salt
        maker,
        U256::from(1_000_000u64),         // tokenId
        U256::from(50_000_000u64),        // makerAmount (0.5 * 100 shares * 1e6)
        U256::from(100_000_000u64),       // takerAmount (100 shares * 1e6)
        U256::from(1_700_000_000u64),     // expiration
        U256::from(7u64),                 // nonce
        U256::from(0u64),                 // feeRateBps
        Side::Buy,
    )
}

#[test]
fn domain_matches_polymarket_ctf_exchange() {
    let d = polymarket_domain();
    assert_eq!(d.name.as_deref(), Some("Polymarket CTF Exchange"));
    assert_eq!(d.version.as_deref(), Some("1"));
    assert_eq!(d.chain_id, Some(U256::from(137u64)));
    assert_eq!(
        d.verifying_contract,
        Some(address!("4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E"))
    );
}

#[test]
fn signed_hash_is_deterministic_for_fixed_inputs() {
    let signer = Eip712Signer::from_hex(TEST_KEY).unwrap();
    let order = sample_order(signer.maker()).to_eip712();
    let domain = polymarket_domain();
    let h1: FixedBytes<32> = order.eip712_signing_hash(&domain);
    let h2: FixedBytes<32> = order.eip712_signing_hash(&domain);
    assert_eq!(h1, h2, "signing hash must be deterministic");
}

#[test]
fn signature_recovers_to_signer_address() {
    let signer = Eip712Signer::from_hex(TEST_KEY).unwrap();
    let maker = signer.maker();
    let order = sample_order(maker);
    let sig_hex = signer.sign_order(&order.to_eip712()).unwrap();

    // Strip 0x and parse as alloy Signature.
    let bytes = alloy_primitives::hex::decode(sig_hex.trim_start_matches("0x"))
        .expect("hex decodes");
    assert_eq!(bytes.len(), 65, "EIP-712 sig is 65 bytes (r||s||v)");
    let sig = Signature::try_from(bytes.as_slice()).expect("sig parses");

    let domain = polymarket_domain();
    let hash = order.to_eip712().eip712_signing_hash(&domain);
    let recovered = sig
        .recover_address_from_prehash(&hash)
        .expect("recovers");
    assert_eq!(
        recovered, maker,
        "signature must recover to the signer's address"
    );
}

#[test]
fn json_wire_shape_matches_polymarket_schema() {
    let signer = Eip712Signer::from_hex(TEST_KEY).unwrap();
    let order = sample_order(signer.maker());
    let json = serde_json::to_value(&order).unwrap();

    // Field presence check — Polymarket CLOB POST /order schema.
    for f in [
        "salt",
        "maker",
        "signer",
        "taker",
        "tokenId",
        "makerAmount",
        "takerAmount",
        "expiration",
        "nonce",
        "feeRateBps",
        "side",
        "signatureType",
    ] {
        assert!(
            json.get(f).is_some(),
            "wire payload missing field: {f}"
        );
    }

    // Large numerics must be strings (U256 range); sigtype numeric.
    for f in [
        "salt",
        "tokenId",
        "makerAmount",
        "takerAmount",
        "expiration",
        "nonce",
        "feeRateBps",
    ] {
        assert!(
            json[f].is_string(),
            "field {f} must serialize as string (avoids JSON precision loss)"
        );
    }
    // Side is an uppercase string ("BUY"/"SELL") per the live CLOB schema.
    assert!(json["side"].is_string());
    assert_eq!(json["side"].as_str().unwrap(), "BUY");
    assert!(json["signatureType"].is_number());

    // Taker must be the zero address (open order, per artifact).
    assert_eq!(
        json["taker"].as_str().unwrap().to_lowercase(),
        "0x0000000000000000000000000000000000000000"
    );
}

#[test]
fn buy_and_sell_produce_distinct_signatures() {
    let signer = Eip712Signer::from_hex(TEST_KEY).unwrap();
    let maker = signer.maker();
    let mut buy = sample_order(maker);
    buy.side = "BUY".into();
    let mut sell = sample_order(maker);
    sell.side = "SELL".into();

    let s_buy = signer.sign_order(&buy.to_eip712()).unwrap();
    let s_sell = signer.sign_order(&sell.to_eip712()).unwrap();
    assert_ne!(
        s_buy, s_sell,
        "side byte must influence the signing hash (and thus signature)"
    );
}

#[test]
fn nonce_influences_signature() {
    let signer = Eip712Signer::from_hex(TEST_KEY).unwrap();
    let maker = signer.maker();
    let mut a = sample_order(maker);
    let mut b = sample_order(maker);
    a.nonce = "7".into();
    b.nonce = "8".into();
    assert_ne!(
        signer.sign_order(&a.to_eip712()).unwrap(),
        signer.sign_order(&b.to_eip712()).unwrap(),
        "nonce must be covered by the signing hash"
    );
}
