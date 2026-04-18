// Reconstruction of
// `ClientInner<Unauthenticated>::create_headers::{{closure}}` at
// 0xabb70..0xad240.
//
// Runs once per process during `TradingClient::new`, for the single
// POST /auth/api-key call that bootstraps L2 credentials. The body is
// empty; authentication is by EIP-712 signature of the `ClobAuth`
// typed-data struct with domain separator `ClobAuthDomain` v1.
//
// Key asm landmarks:
//
//   0xac0f3  call chrono::offset::utc::Utc::now          // timestamp
//   0xac3d9  call alloy_sol_types::SolStruct::eip712_signing_hash
//                                                         // ClobAuth digest
//   0xac4c3  call *%rax                                  // Signer::sign_hash
//                                                         // (vtable call into
//                                                         //  alloy_signer_local)
//   0xac5fe  call const_hex::encode_inner                // 0x-hex signature
//   0xac79f  call http::HeaderMap::insert                // POLY_ADDRESS
//   0xac822  call core::fmt::num::u32::_fmt              // nonce formatter
//   0xac95c  call http::HeaderMap::insert                // POLY_SIGNATURE
//
// The fixed message literal "This message attests that I control the
// given wallet" lives at .rodata 0x6da838 (53 bytes). The domain name
// "ClobAuthDomain" and version "1" are elsewhere in .rodata.
//
// EIP-712 type string (from REVERSE_NOTE.md §5, confirmed in .rodata):
//
//   ClobAuth(address address,string timestamp,uint256 nonce,string message)
//
// Equivalent Rust:

use alloy_primitives::{Address, U256};
use alloy_signer::Signer;
use alloy_sol_types::{sol, SolStruct};
use chrono::Utc;

sol! {
    #[derive(Clone)]
    struct ClobAuth {
        address address;
        string  timestamp;
        uint256 nonce;
        string  message;
    }
}

const CLOB_AUTH_DOMAIN: &str = "ClobAuthDomain";
const CLOB_AUTH_VERSION: &str = "1";
const AUTH_MESSAGE: &str = "This message attests that I control the given wallet";

impl ClientInner<Unauthenticated> {
    pub(crate) async fn create_headers<S: Signer>(
        &self,
        signer: &S,
    ) -> Result<http::HeaderMap, Error> {
        // 0xac0f3..0xac260: timestamp as decimal seconds since epoch
        let timestamp = Utc::now().timestamp();

        // nonce starts at 0 for api-key creation and is incremented by the
        // server on subsequent auth attempts (not relevant here; the value
        // 0 is loaded as a constant in this code path).
        let nonce: u64 = 0;

        // Domain separator: name="ClobAuthDomain", version="1", no chainId,
        //                    no verifyingContract. Matches the Polymarket
        //                    py-clob-client `get_clob_auth_domain()` helper.
        let domain = alloy_sol_types::eip712_domain! {
            name:    CLOB_AUTH_DOMAIN,
            version: CLOB_AUTH_VERSION,
        };

        let payload = ClobAuth {
            address:   signer.address(),
            timestamp: timestamp.to_string(),
            nonce:     U256::from(nonce),
            message:   AUTH_MESSAGE.to_string(),
        };

        // 0xac3d9: compute the EIP-712 signing hash =
        //   keccak256( 0x19 0x01 ‖ domainSep ‖ structHash(ClobAuth, payload) )
        let digest = payload.eip712_signing_hash(&domain);

        // 0xac4c3: sign the 32-byte digest. For LocalSigner this is raw
        //          k256 secp256k1 ECDSA; the resulting Signature is
        //          65-byte R‖S‖V.
        let sig = signer.sign_hash(&digest).await?;

        // 0xac5fe..0xac9c8: serialise the signature as a 0x-prefixed
        //                   lowercase hex string (132 chars total).
        let poly_signature = format!("0x{}", hex::encode(sig.as_bytes()));

        let mut headers = http::HeaderMap::new();
        headers.insert("POLY_ADDRESS",   signer.address().to_string().parse().unwrap());
        headers.insert("POLY_SIGNATURE", poly_signature.parse().unwrap());
        headers.insert("POLY_TIMESTAMP", timestamp.to_string().parse().unwrap());
        headers.insert("POLY_NONCE",     nonce.to_string().parse().unwrap());
        Ok(headers)
    }
}

// The resulting request:
//
//   POST https://clob.polymarket.com/auth/api-key
//   POLY_ADDRESS:   0xf39f...2266
//   POLY_SIGNATURE: 0x<130-hex> (65 bytes)
//   POLY_TIMESTAMP: 1729...
//   POLY_NONCE:     0
//   (body empty)
//
// Server response (observed in captures):
//   { "apiKey":"...", "secret":"<base64url>", "passphrase":"..." }
//
// These creds then flow into `Client<Authenticated<Normal>>` and from
// there into every subsequent L2-authed request.
