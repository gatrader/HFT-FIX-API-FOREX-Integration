// Reconstruction of `polymarket_client_sdk::auth::hmac` at 0x29b5c0..0x29cd60.
//
// This is the L2 signature computation. Inputs are the base64url-encoded
// api-secret and the canonical message from `auth::to_message`. Output is
// the base64url-encoded HMAC-SHA256 string that goes into the
// `poly_signature` header.
//
// Key asm landmarks:
//
//   0x29b637  call calloc(decoded_secret_len)           // base64 decode buf
//   0x29b6f5..0x29b7c8  vectorised base64 decode loop using TOKEN_MAP at
//                        0x7366c8 (4-byte groups -> 3 bytes, looking up
//                        each char; 0x3d = padding '=', 0xff = invalid)
//   0x29c23d  call sha2::sha256::compress256             // repeated per 64B
//                                                        // block for both
//                                                        // inner and outer
//                                                        // hash
//   0x29c870/29c8d2 call digest::FixedOutputCore::finalize_fixed_core
//   0x29c90a  call calloc(b64_len(32))                   // output buf
//   0x29c93d  call base64::engine::GeneralPurpose::internal_encode
//   0x29c99b  call core::str::from_utf8                  // wrap as &str
//
// The fact that `base64::engine::general_purpose::internal_encode` is the
// encoder — coupled with the decode table at TOKEN_MAP+0x1009 that accepts
// '-' and '_' as well as '+' and '/' — confirms this is the URL-SAFE
// variant (base64url, no-pad in practice because the 32-byte SHA256 output
// always base64-encodes to 44 chars with a single '=' that some servers
// strip).
//
// Equivalent Rust:

use hmac::{Hmac, Mac};
use sha2::Sha256;
use base64::{engine::general_purpose::URL_SAFE, Engine};

type HmacSha256 = Hmac<Sha256>;

pub fn hmac(
    secret_b64url: &str,   // the `secret` returned from /auth/api-key
    message: &str,         // output of auth::to_message
) -> Result<String, AuthError> {
    // 0x29b5db..0x29b7c8: Decode the secret. Polymarket returns it as
    //                    base64url without padding; this decoder accepts
    //                    both '+/' and '-_' alphabets.
    let key = URL_SAFE.decode(secret_b64url)
        .map_err(|_| AuthError::InvalidSecret)?;

    // 0x29b??  ..0x29c611: HMAC-SHA256 init + update. The compiler inlines
    //                      hmac::Hmac::new + update + finalize; sha2's
    //                      compress256 is called once for the ipad, once
    //                      per 64-byte block of message, and once each for
    //                      the inner+outer pad finalisations.
    let mut mac = HmacSha256::new_from_slice(&key)
        .map_err(|_| AuthError::InvalidKeyLength)?;
    mac.update(message.as_bytes());
    let digest = mac.finalize().into_bytes();   // 32 bytes

    // 0x29c90a..0x29c99b: base64url encode the 32-byte digest.
    // Empirically the bot uses the URL_SAFE (with padding) variant of the
    // base64 crate — the '=' padding on the output is visible in live
    // captures (signed_orders.jsonl).
    Ok(URL_SAFE.encode(digest))
}

// Confirmed by live capture in research/captures/signed_orders.jsonl:
//
//   poly_signature: "Rf9QWXdb...=" (44 chars incl. trailing '=')
//
// Wire verification on the Polymarket side:
//
//   server recomputes HMAC-SHA256( secret, timestamp || method || path || body )
//   and compares to the base64url-decoded header. Identical to the Python
//   `py-clob-client.signing.hmac.build_hmac_signature` helper.
