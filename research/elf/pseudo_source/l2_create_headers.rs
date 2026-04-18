// Reconstruction of `Client<Authenticated<K>>::create_headers::{{closure}}`
// at 0x80430..0x81860 (primary monomorphization; 4 more exist at
// 0xd7130, 0x105a40, 0x12bb40 and 0x168...).
//
// Called before **every authenticated CLOB request** — including the
// /orders batch POST, cancel_all_open_orders, data/orders, fee-rate
// reads, everything that carries L2 auth. Builds the six PMO headers:
//
//   POLY_ADDRESS, POLY_API_KEY, POLY_PASSPHRASE,
//   POLY_TIMESTAMP, POLY_NONCE,   POLY_SIGNATURE
//
// Key asm landmarks:
//
//   0x80441..0x8045c  jump-table dispatch on self.state (Resume/Pending/Done)
//   0x8052b  lea &url::Url as core::fmt::Display::fmt    // formats URL
//   0x8057b  call alloc::fmt::format::format_inner       // builds full URL
//   0x805c9  call reqwest::Client::request(method, url, body)
//   0x806ee  call chrono::offset::utc::Utc::now          // timestamp source
//   0x8076f  imul $0x15180, %rcx, %r15                   // x * 86400 (secs/day)
//                                                         // -> unix seconds
//   0x807c4  call polymarket_client_sdk::request::{{closure}}
//                                                         // -> to_message + hmac
//   ...     PUT 6 headers (POLY_*) on the RequestBuilder
//
// Equivalent Rust:

use chrono::Utc;
use reqwest::{Client, Method, Request, Response};
use std::sync::Arc;

impl<K> Client<Authenticated<K>>
where
    K: auth::Kind,
{
    pub(crate) async fn create_headers(
        &self,
        method: Method,
        path: &str,          // e.g. "/orders"
        body: Option<&[u8]>, // canonical body bytes, signed as-is
    ) -> Result<Request, Error> {
        // 0x8052b..0x8057b: compose full URL: {base}{path}
        let url = format!("{}{}", self.inner.host, path);

        // 0x805c9: start a reqwest Request
        let mut req = self.inner.http.request(method.clone(), &url);

        // 0x806ee..0x80779: timestamp = Utc::now() in seconds since epoch.
        //                   The big imul chain is chrono's internal
        //                   year/month/day -> days-since-epoch -> seconds
        //                   conversion, inlined.
        let timestamp = Utc::now().timestamp();

        // Nonce in the default auth::Normal path is always 0. The field
        // exists for the L1 derivation path (see l1_create_headers) but
        // here it is loaded as the constant 0 (not shown in this slice).
        let nonce: i64 = 0;

        // 0x807c4: request::<Credentials>(..) is the tiny helper that
        //          1) builds a PreparedRequest carrying method/path/body/
        //             timestamp/nonce,
        //          2) calls auth::to_message(req) -> canonical string,
        //          3) calls auth::hmac(secret, message) -> signature.
        let canonical = auth::to_message(&PreparedRequest {
            method:    method.as_str().to_string(),
            url:       url.parse::<url::Url>().unwrap(),
            body:      body.map(|b| b.to_vec()),
            timestamp,
            nonce,
        });
        let signature = auth::hmac(&self.creds.secret, &canonical)?;

        // Attach the six PMO headers. The exact names (lowercase, no
        // underscores on the wire per the captures) are string literals
        // stored at 0x6ca... entries in rodata.
        req = req
            .header("POLY_ADDRESS",    &self.creds.address)
            .header("POLY_API_KEY",    &self.creds.api_key)
            .header("POLY_PASSPHRASE", &self.creds.passphrase)
            .header("POLY_TIMESTAMP",  timestamp.to_string())
            .header("POLY_NONCE",      nonce.to_string())
            .header("POLY_SIGNATURE",  signature)
            .header("Content-Type",    "application/json")
            .header("User-Agent",      "rs_clob_client");

        Ok(req.build()?)
    }
}

// Field-level confirmation (from live captures in
// research/captures/signed_orders.jsonl):
//
//   poly_address:    "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
//   poly_api_key:    "00000000-0000-0000-0000-000000000000"  (stub'd by MITM)
//   poly_passphrase: "stubpassphrase"                         (stub'd by MITM)
//   poly_nonce:      "0"
//   poly_timestamp:  "1729...
//   poly_signature:  "Rf9QWXdb...="
//   content-type:    "application/json"
//   user-agent:      "rs_clob_client"
