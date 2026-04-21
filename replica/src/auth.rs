//! Polymarket CLOB auth (L1 bootstrap + L2 HMAC-SHA256).
//!
//! Recovered from static analysis of bot/bin/arbitrage_bot:
//! - L1: one-time EIP-712 signed POST to /auth/api-key
//!   attaches POLY_ADDRESS, POLY_SIGNATURE, POLY_TIMESTAMP,
//!   POLY_NONCE. Server returns (apiKey, secret, passphrase).
//! - L2: every subsequent request attaches POLY_ADDRESS,
//!   POLY_API_KEY, POLY_PASSPHRASE, POLY_TIMESTAMP, POLY_NONCE=0,
//!   POLY_SIGNATURE = base64url(HMAC-SHA256(secret,
//!   "{timestamp}{METHOD}{path}{body}")).
//!
//! The secret returned by /auth/api-key is a base64url string.
//! It is decoded before being used as the HMAC key.

use alloy_primitives::Address;
use alloy_signer::SignerSync;
use alloy_signer_local::PrivateKeySigner;
use alloy_sol_types::{eip712_domain, sol, SolStruct};
use base64::engine::general_purpose::URL_SAFE;
use base64::Engine;
use hmac::{Hmac, Mac};
use serde::Deserialize;
use serde::Serialize;
use sha2::Sha256;

pub const CLOB_API_HOST: &str = "https://clob.polymarket.com";

/// Credentials obtained from the L1 bootstrap.
#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ApiCredentials {
    #[serde(alias = "apiKey", rename(serialize = "api_key"))]
    pub api_key: String,
    pub secret: String,
    pub passphrase: String,
}

sol! {
    /// Struct signed during L1 bootstrap. Domain below.
    struct ClobAuth {
        address address;
        string  timestamp;
        uint256 nonce;
        string  message;
    }
}

fn clob_auth_domain() -> alloy_sol_types::Eip712Domain {
    eip712_domain! {
        name: "ClobAuthDomain",
        version: "1",
        chain_id: 137,
    }
}

/// Build the L1 headers required to call /auth/api-key.
pub fn l1_headers(
    signer: &PrivateKeySigner,
    timestamp_secs: i64,
    nonce: u64,
) -> anyhow::Result<Vec<(&'static str, String)>> {
    let address = signer.address();
    let msg = ClobAuth {
        address,
        timestamp: timestamp_secs.to_string(),
        nonce: alloy_primitives::U256::from(nonce),
        message: "This message attests that I control the given wallet".into(),
    };
    let domain = clob_auth_domain();
    let hash = msg.eip712_signing_hash(&domain);
    let sig = signer.sign_hash_sync(&hash)?;
    let sig_hex = format!("0x{}", alloy_primitives::hex::encode(sig.as_bytes()));
    Ok(vec![
        ("POLY_ADDRESS", format!("{:#x}", address)),
        ("POLY_SIGNATURE", sig_hex),
        ("POLY_TIMESTAMP", timestamp_secs.to_string()),
        ("POLY_NONCE", nonce.to_string()),
    ])
}

/// Compute the L2 HMAC signature over the canonical string.
///
/// canonical = "{timestamp}{METHOD}{path}{body}"
/// secret    = base64url(...) — decoded before use as HMAC key
/// output    = base64url(HMAC-SHA256(secret, canonical))
pub fn l2_signature(
    secret_b64url: &str,
    timestamp_secs: i64,
    method: &str,
    path: &str,
    body: &str,
) -> anyhow::Result<String> {
    let key = URL_SAFE
        .decode(secret_b64url)
        .map_err(|e| anyhow::anyhow!("secret base64url decode: {e}"))?;
    let canonical = format!("{timestamp_secs}{method}{path}{body}");
    let mut mac = Hmac::<Sha256>::new_from_slice(&key)
        .map_err(|e| anyhow::anyhow!("hmac key: {e}"))?;
    mac.update(canonical.as_bytes());
    let out = mac.finalize().into_bytes();
    Ok(URL_SAFE.encode(out))
}

/// Build the full L2 header set for a CLOB request.
pub fn l2_headers(
    maker: Address,
    creds: &ApiCredentials,
    timestamp_secs: i64,
    method: &str,
    path: &str,
    body: &str,
) -> anyhow::Result<Vec<(&'static str, String)>> {
    let sig = l2_signature(&creds.secret, timestamp_secs, method, path, body)?;
    Ok(vec![
        ("POLY_ADDRESS", format!("{:#x}", maker)),
        ("POLY_API_KEY", creds.api_key.clone()),
        ("POLY_PASSPHRASE", creds.passphrase.clone()),
        ("POLY_TIMESTAMP", timestamp_secs.to_string()),
        ("POLY_NONCE", "0".into()),
        ("POLY_SIGNATURE", sig),
    ])
}

#[derive(Clone, Debug, Serialize)]
struct ApiKeyRequest<'a> {
    message: &'a str,
}

/// L1 bootstrap: derive API credentials by signing the
/// ClobAuth struct and POSTing to /auth/api-key.
pub async fn bootstrap_credentials(
    http: &reqwest::Client,
    signer: &PrivateKeySigner,
) -> anyhow::Result<ApiCredentials> {
    let ts = chrono::Utc::now().timestamp();
    let headers = l1_headers(signer, ts, 0)?;
    let url = format!("{CLOB_API_HOST}/auth/api-key");
    let mut req = http.post(&url).json(&ApiKeyRequest {
        message: "This message attests that I control the given wallet",
    });
    for (k, v) in headers {
        req = req.header(k, v);
    }
    let resp = req.send().await?;
    let status = resp.status();
    let body = resp.text().await?;
    if !status.is_success() {
        return Err(anyhow::anyhow!("/auth/api-key {status}: {body}"));
    }
    let creds: ApiCredentials = serde_json::from_str(&body)
        .map_err(|e| anyhow::anyhow!("parse credentials: {e}; body={body}"))?;
    Ok(creds)
}

/// GET /auth/derive-api-key — returns the credentials already
/// registered for this EOA. Same L1 signature as bootstrap; the
/// server looks up existing keys instead of minting new ones.
/// Use this when /auth/api-key returns 400 "Could not create api
/// key" because the wallet has been bootstrapped previously.
pub async fn derive_credentials(
    http: &reqwest::Client,
    signer: &PrivateKeySigner,
) -> anyhow::Result<ApiCredentials> {
    let ts = chrono::Utc::now().timestamp();
    let headers = l1_headers(signer, ts, 0)?;
    let url = format!("{CLOB_API_HOST}/auth/derive-api-key");
    let mut req = http.get(&url);
    for (k, v) in headers {
        req = req.header(k, v);
    }
    let resp = req.send().await?;
    let status = resp.status();
    let body = resp.text().await?;
    if !status.is_success() {
        return Err(anyhow::anyhow!("/auth/derive-api-key {status}: {body}"));
    }
    let creds: ApiCredentials = serde_json::from_str(&body)
        .map_err(|e| anyhow::anyhow!("parse credentials: {e}; body={body}"))?;
    Ok(creds)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn l2_signature_is_deterministic() {
        let secret = URL_SAFE.encode(b"this-is-a-test-secret-32-bytes-ab");
        let s1 = l2_signature(&secret, 1_700_000_000, "POST",
                              "/data/orders", r#"{"a":1}"#).unwrap();
        let s2 = l2_signature(&secret, 1_700_000_000, "POST",
                              "/data/orders", r#"{"a":1}"#).unwrap();
        assert_eq!(s1, s2);
    }

    #[test]
    fn l2_signature_depends_on_every_input() {
        let secret = URL_SAFE.encode(b"this-is-a-test-secret-32-bytes-ab");
        let base = l2_signature(&secret, 1_700_000_000, "POST",
                                "/data/orders", r#"{"a":1}"#).unwrap();
        assert_ne!(base,
            l2_signature(&secret, 1_700_000_001, "POST",
                         "/data/orders", r#"{"a":1}"#).unwrap());
        assert_ne!(base,
            l2_signature(&secret, 1_700_000_000, "GET",
                         "/data/orders", r#"{"a":1}"#).unwrap());
        assert_ne!(base,
            l2_signature(&secret, 1_700_000_000, "POST",
                         "/data/cancels", r#"{"a":1}"#).unwrap());
        assert_ne!(base,
            l2_signature(&secret, 1_700_000_000, "POST",
                         "/data/orders", r#"{"a":2}"#).unwrap());
    }

    #[test]
    fn l1_headers_include_required_fields() {
        let signer: PrivateKeySigner =
            "0000000000000000000000000000000000000000000000000000000000000001"
                .parse().unwrap();
        let h = l1_headers(&signer, 1_700_000_000, 0).unwrap();
        let names: Vec<_> = h.iter().map(|(k, _)| *k).collect();
        assert!(names.contains(&"POLY_ADDRESS"));
        assert!(names.contains(&"POLY_SIGNATURE"));
        assert!(names.contains(&"POLY_TIMESTAMP"));
        assert!(names.contains(&"POLY_NONCE"));
    }
}
