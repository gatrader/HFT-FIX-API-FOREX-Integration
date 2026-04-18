// Reconstruction of
// `Client<Authenticated<K>>::post_orders::{{closure}}.3905` at
// 0xd0ef0..0xd7080 (~24 KB of compiled code, ~4700 asm lines).
//
// This is the entry point for EVERY order submission the bot makes:
//   - TradingClient::place_single_order calls it with a 1-element batch
//   - TradingClient::place_batch_buy_orders calls it with a 2-element
//     batch (the UP and DOWN legs for a dutch_book iteration)
//
// By the time post_orders runs, the EIP-712 Order signing has already
// happened in Client::sign::{{closure}}.3902 (0xce810). post_orders just:
//   1. builds URL = "{base}/orders"
//   2. hand-serialises the batch as a JSON array
//   3. calls create_headers to attach L2 PMO* HMAC headers
//   4. POSTs the body and deserialises the response as
//      Vec<PostOrderResponse>
//
// Key asm landmarks:
//
//   0xd0fea  call fmt::format_inner                    // build "{base}/orders"
//   0xd1033  call reqwest::Client::request(POST, url)
//   0xd1070  malloc 0x80 bytes                         // JSON output buffer
//   0xd10aa  movb $0x5b  (= '[')                       // open batch array
//   0xd10c2  imul $0x198, %r15, %rax                   // 408 bytes per Order
//                                                       // entry (= sizeof<
//                                                       //   SignedOrderEnvelope>)
//   0xd1149  movb $0x7b  (= '{')                       // open order wrapper
//   0xd13d3..etc  serde_json::ser::format_escaped_str_contents
//   0xd14e5  call <u64 as itoa::Unsigned>::fmt         // salt as integer
//   0xd15d5/0xd1684/0xd1733 FixedBytes::serialize     // maker/signer/taker
//   0xd17df..etc Serializer::collect_str               // u256 decimal strings
//   0xd327b  call clob::types::ser_salt::{{closure}}   // custom salt ser
//   0xd33ea  call Client<Authenticated>::create_headers::{{closure}}.3909
//                                                       // L2 PMO* headers
//   0xd3954  call reqwest::Client::execute_request     // fire the request
//   0xd3b6f  call Response::json                       // parse response
//   0xd4652..d5351 PostOrderResponse::Deserialize::visit_map
//
// The 0x198 (408) stride is the in-memory size of the SignedOrderEnvelope:
// `{ order: Order, orderType: OrderType, owner: String, postOnly: bool }`
// with the Order itself containing a 65-byte signature, three U256s, three
// addresses, and a handful of enum tags.
//
// Equivalent Rust:

use alloy_primitives::{Address, U256};
use alloy_primitives::signature::Signature;
use reqwest::{Method, StatusCode};
use serde::{Serialize, Serializer};

#[derive(Debug, Clone)]
pub enum Side { Buy, Sell }

impl Serialize for Side {
    fn serialize<S: Serializer>(&self, ser: S) -> Result<S::Ok, S::Error> {
        ser.serialize_str(match self { Side::Buy => "BUY", Side::Sell => "SELL" })
    }
}

#[derive(Debug, Clone)]
pub enum OrderType { Gtc, Fok, Gtd, Fak }
impl Serialize for OrderType {
    fn serialize<S: Serializer>(&self, ser: S) -> Result<S::Ok, S::Error> {
        ser.serialize_str(match self {
            OrderType::Gtc => "GTC",
            OrderType::Fok => "FOK",
            OrderType::Gtd => "GTD",
            OrderType::Fak => "FAK",
        })
    }
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Order {
    #[serde(serialize_with = "ser_salt")]   // integer, not string
    pub salt: u64,

    pub maker:  Address,
    pub signer: Address,
    pub taker:  Address,

    // u256 values are serialised as decimal strings, *not* hex.
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub token_id:      U256,
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub maker_amount:  U256,
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub taker_amount:  U256,
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub expiration:    U256,
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub nonce:         U256,
    #[serde(serialize_with = "ser_u256_as_decimal_str")]
    pub fee_rate_bps:  U256,

    pub side: Side,

    /// 0 = EOA, 1 = POLY_PROXY, 2 = POLY_GNOSIS_SAFE
    pub signature_type: u8,

    /// 0x-prefixed, 130 hex chars = 65 bytes R‖S‖V
    #[serde(serialize_with = "ser_signature_as_hex")]
    pub signature: Signature,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SignedOrderEnvelope {
    pub order:      Order,
    pub order_type: OrderType,
    /// **API-key UUID, not the wallet address.** (Confirmed from live
    /// captures — see research/captures/README.md.)
    pub owner:      String,
    pub post_only:  bool,
}

fn ser_salt<S: Serializer>(salt: &u64, ser: S) -> Result<S::Ok, S::Error> {
    // 0xd327b: integer emission, NOT string. This diverges from the
    //          other u256-ish fields that get decimal-string-serialised.
    ser.serialize_u64(*salt)
}

fn ser_u256_as_decimal_str<S: Serializer>(v: &U256, ser: S) -> Result<S::Ok, S::Error> {
    // 0xd17df..0xd1957 etc: `Serializer::collect_str(&Display-of-U256)`
    //                       — outputs e.g. "2100000" (not "0x...").
    ser.collect_str(&v)
}

fn ser_signature_as_hex<S: Serializer>(sig: &Signature, ser: S) -> Result<S::Ok, S::Error> {
    // 0xd12b3: Signature's Display impl writes "0x<130-hex>". The
    //          serialized field is a string.
    ser.collect_str(&format_args!("0x{}", hex::encode(sig.as_bytes())))
}


impl<K> Client<Authenticated<K>>
where
    K: auth::Kind,
{
    /// Submit a batch of **already-signed** orders.
    ///
    /// The caller (TradingClient::place_*) has:
    ///   1. built an Order struct
    ///   2. computed the EIP-712 signing hash via alloy_sol_types
    ///   3. signed with the LocalSigner
    ///   4. assembled the SignedOrderEnvelope { order, orderType, owner, postOnly }
    ///
    /// This function just serialises + POSTs + deserialises.
    pub async fn post_orders(
        &self,
        orders: &[SignedOrderEnvelope],
    ) -> Result<Vec<PostOrderResponse>, Error> {
        // 0xd0fea: URL = "{base}/orders"  (plural — the SDK also has a
        //          singular /order path that is NOT used on the
        //          dutch_book / spread_capture code paths).
        let url = format!("{}/orders", self.inner.host);

        // 0xd10aa..0xd2e45: hand-rolled JSON array serialiser:
        //                    body = '[' + join(',', order_json) + ']'
        //                   We match the same output via serde_json.
        let body = serde_json::to_vec(orders)?;

        // 0xd33ea: sign this specific POST — creates the six PMO*
        //          headers via L2 HMAC-SHA256 over
        //          `timestamp || "POST" || "/orders" || body`.
        let request = self.create_headers(
            Method::POST,
            "/orders",
            Some(&body),
        ).await?
         .body(body)
         .build()?;

        // 0xd3954: fire the request. If the bot was started with
        //          dry_run=false this actually hits clob.polymarket.com;
        //          dry_run=true short-circuits BEFORE reaching here (the
        //          guard lives in place_single_order / place_batch_buy_orders,
        //          not in post_orders itself).
        let response = self.inner.http.execute(request).await?;
        let status = response.status();

        // 0xd3b6f..0xd5351: deserialise Vec<PostOrderResponse>. The
        //                   response is always a JSON array even if we
        //                   sent a 1-element batch.
        if status == StatusCode::OK {
            Ok(response.json::<Vec<PostOrderResponse>>().await?)
        } else {
            let text = response.text().await.unwrap_or_default();
            Err(Error::HttpStatus(status, text))
        }
    }
}

/// One entry per leg in the batch. Field names confirmed from asm
/// at 0xd4652..0xd5351 (`PostOrderResponse::deserialize::__FieldVisitor`).
#[derive(Debug, Clone, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct PostOrderResponse {
    /// BOTH field names are accepted by the deserialiser (seen in visit_str
    /// calls at 0xd48c0 and 0xd495b). The SDK renamed `orderId` ->
    /// `orderID` at some point; the fork accepts both.
    #[serde(alias = "orderID")]
    pub order_id: String,
    pub success:  bool,
    #[serde(default)]
    pub error_msg: String,
    #[serde(default)]
    pub status:   OrderStatusType,
    #[serde(default)]
    pub taking_amount: String,
    #[serde(default)]
    pub making_amount: String,
    #[serde(default)]
    pub order_hashes: Vec<String>,
    #[serde(default)]
    pub transactions_hashes: Vec<String>,
}

#[derive(Debug, Clone, Copy, Default, serde::Deserialize)]
pub enum OrderStatusType {
    #[default]
    #[serde(rename = "live")]     Live,
    #[serde(rename = "MATCHED")]  Matched,
    #[serde(rename = "DELAYED")]  Delayed,
    #[serde(rename = "UNMATCHED")] Unmatched,
}

// ---------------------------------------------------------------------
// Example captured body (one of the four in
// research/captures/signed_orders.jsonl), pretty-printed:
//
//   [
//     {
//       "order": {
//         "salt": 1096563795,
//         "maker":  "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
//         "signer": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
//         "taker":  "0x0000000000000000000000000000000000000000",
//         "tokenId":      "10000000...0001",
//         "makerAmount":  "2100000",
//         "takerAmount":  "5000000",
//         "expiration":   "0",
//         "nonce":        "0",
//         "feeRateBps":   "0",
//         "side":          "BUY",
//         "signatureType": 0,
//         "signature":     "0x<130 hex chars>"
//       },
//       "orderType": "GTC",
//       "owner":     "00000000-0000-0000-0000-000000000000",
//       "postOnly":  false
//     },
//     { /* DOWN leg — same shape */ }
//   ]
//
// Accompanying headers (from the same capture):
//
//   POST /orders HTTP/1.1
//   content-type: application/json
//   user-agent:   rs_clob_client
//   poly_address: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
//   poly_api_key: 00000000-0000-0000-0000-000000000000
//   poly_passphrase: stubpassphrase
//   poly_nonce: 0
//   poly_timestamp: 1729...
//   poly_signature: Rf9QWXdb...=   (HMAC-SHA256 of
//                                    timestamp+"POST"+"/orders"+body)
