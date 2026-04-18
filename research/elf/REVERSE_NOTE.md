# `arbitrage_bot` ELF reverse note

Companion analysis to `research/FINDINGS.md`. Everything here was derived
from the unstripped binary at `bot/bin/arbitrage_bot`; see the sibling
artefacts in this directory:

| File | What's in it |
|---|---|
| `elf_header.txt` | `readelf -h` — ELF type, ABI, entry point |
| `sections.txt` | `readelf -SW` — section table |
| `dynamic.txt` | `readelf -dW` — DT_NEEDED, soname, flags |
| `symbols_defined.txt` | all locally-defined symbols (demangled, sorted by addr) |
| `symbols_undefined.txt` | all imported symbols (libc, libpthread, dl) |
| `symbols_app.txt` | `arbitrage_bot::` + `polymarket_client_sdk::` only |
| `strings_urls.txt` | every `https://`/`wss://` literal in rodata |
| `tradingclient_new.asm` | full disassembly of the three `TradingClient::new` closures (0x8f8b0, 0xe96f0, 0x10f5e0; 29 184 bytes each) |

## 1. Binary metadata

- **Architecture**: ELF64 x86-64, PIE, DT_NEEDED = `libgcc_s.so.1`, `libpthread.so.0`, `libdl.so.2`, `libm.so.6`, `libc.so.6`.
- **Compiler**: rustc 1.88.0, commit `6b00bc38801986` (visible in rustc-generated path strings).
- **Crate**: `arbitrage_bot` v0.6.0.
- **Stripping**: none — function symbols are intact, enabling symbolic disassembly with `rustfilt`.
- **Size**: 10 118 560 bytes.
- **aws-lc-sys** is linked in, which means `rustls` is the TLS stack, using
  AWS-LC as the crypto provider (important for MITM — reqwest picks up
  `/usr/local/share/ca-certificates/` via `rustls-native-certs`).

## 2. Provenance of the CLOB SDK

The Polymarket CLOB SDK is a **fork** of `rs-clob-client`, not the upstream crate:

```
/usr/local/cargo/git/checkouts/rs-clob-client-971b3f32531b839b/0518317/src/lib.rs
/usr/local/cargo/git/checkouts/rs-clob-client-971b3f32531b839b/0518317/src/clob/client.rs
```

- Git checkout id: `971b3f32531b839b`
- Fork commit: `0518317`

The fork adds the `send_debug_data` function on
`polymarket_client_sdk::clob::client::AuthenticationBuilder` — this is the
phone-home entry point. Upstream `rs-clob-client` has no such function.

## 3. Application module map

```
arbitrage_bot
├── main                              (entry; clap → run_single_market)
├── run_single_market                 (per-market driver)
├── config                            (serde struct, snake_case keys)
├── utils::now_str
├── auth
│   └── derive_api_credentials
├── market
│   ├── fetch
│   │   ├── fetch_market_assets       (primary — gamma /events?slug=)
│   │   └── fetch_market_assets_direct(fallback — /markets/slug/)
│   ├── time                          (slug ↔ window timestamps)
│   └── types
├── trading
│   ├── client::TradingClient
│   │   ├── new                       (wallet → auth → send_debug_data → derive API key)
│   │   ├── get_api_creds
│   │   ├── get_position              (uses /data/positions)
│   │   ├── register_order
│   │   ├── add_filled_shares
│   │   ├── subtract_filled_shares
│   │   ├── set_fill_notifier
│   │   ├── place_single_order
│   │   ├── place_batch_buy_orders
│   │   ├── cancel_orders
│   │   └── cancel_all_open_orders
│   └── position
├── websocket
│   ├── market_ws
│   │   ├── run_trading_loop          (dutch_book entry)
│   │   ├── process_ws_message
│   │   ├── handle_book_message
│   │   └── handle_price_change
│   ├── spread_capture_ws
│   │   ├── run_spread_capture_loop   (spread_capture entry)
│   │   ├── run_side_capture
│   │   ├── process_market_message
│   │   ├── handle_book
│   │   └── handle_price_change
│   ├── user_ws::run_user_ws_monitor
│   └── types
└── event::events                     (stdout @@EVENT: emitter)
```

## 4. External endpoints (exhaustive list)

**Legitimate Polymarket:**

| URL | Used by |
|---|---|
| `https://clob.polymarket.com/auth/api-key` | `TradingClient::new` → `AuthenticationBuilder::authenticate` (L1 creation) |
| `https://clob.polymarket.com/auth/derive-api-key` | `TradingClient::new` (re-derive existing key) |
| `https://clob.polymarket.com/data/orders` | `cancel_all_open_orders` (list open orders) |
| `https://clob.polymarket.com/order` *(implied by `post_orders`)* | `place_single_order`, `place_batch_buy_orders` |
| `https://gamma-api.polymarket.com/events?slug=...` | `fetch_market_assets` |
| `https://gamma-api.polymarket.com/markets/slug/...` | `fetch_market_assets_direct` (fallback) |
| `wss://ws-subscriptions-clob.polymarket.com/ws/market` | `market_ws` + `spread_capture_ws` |
| `wss://ws-subscriptions-clob.polymarket.com/ws/user` | `user_ws` |

**Author-controlled (phone-home):**

| URL | Used by |
|---|---|
| `https://gabagool22.com/api/verify-balancing-conf` | `AuthenticationBuilder::send_debug_data`, inlined into `TradingClient::new` |

Referenced by three LEA instructions (one per monomorphization of
`TradingClient::new`): `0x92053`, `0xebe93`, `0x111d83`.

## 5. Exact EIP-712 type strings (from rodata)

Confirmed by literal bytes in `.rodata`:

**Order** (used for every buy/sell):
```
Order(uint256 salt,address maker,address signer,address taker,uint256 tokenId,
      uint256 makerAmount,uint256 takerAmount,uint256 expiration,uint256 nonce,
      uint256 feeRateBps,uint8 side,uint8 signatureType)
```

**ClobAuth** (used for L1 `/auth/api-key`):
```
ClobAuth(address address,string timestamp,uint256 nonce,string message)
```
Domain separator: `"ClobAuthDomain"` v1. Fixed message literal:
`"This message attests that I control the given wallet"`.

## 6. Order POST body shape

`post_orders` serialises the following wrapper JSON (field names confirmed in
.rodata at `0x6dddd9..0x6ddde7`):

```json
{
  "order": {
    "salt":           "<u256>",
    "maker":          "0x...",
    "signer":         "0x...",
    "taker":          "0x0000000000000000000000000000000000000000",
    "tokenId":        "<decimal u256>",
    "makerAmount":    "<decimal u256>",
    "takerAmount":    "<decimal u256>",
    "expiration":     "0",
    "nonce":          "0",
    "feeRateBps":     "0",
    "side":           0,
    "signatureType":  0,
    "signature":      "0x<65-byte ECDSA>"
  },
  "orderType": "GTC" | "FOK" | "GTD" | "FAK",
  "owner": "<funder address>"
}
```

Request headers (L2 auth, from `Client::create_headers` closure):

| Header | Value |
|---|---|
| `POLY_ADDRESS` | `0x`-prefixed EOA address |
| `POLY_API_KEY` | UUID from CLOB |
| `POLY_PASSPHRASE` | string from CLOB |
| `POLY_TIMESTAMP` | unix seconds |
| `POLY_NONCE` | integer nonce |
| `POLY_SIGNATURE` | base64url HMAC-SHA256 of `timestamp + method + path + body` using secret |

## 7. Config deserialisation (why camelCase is silently ignored)

`config` module deserialises via serde with `#[serde(rename_all = "snake_case")]`
(implied — the literal strings in `.rodata` are snake_case: `dry_run`,
`max_buy_order_size`, `current_market`, `stop_before_end_ms`, etc.).

Camel-case JSON keys are dropped by serde because `deny_unknown_fields` is
not set; the struct defaults apply. This is why a `dry_run:false` written as
`dryRun:false` silently stays true.

Full expected config key set (extracted from clap `the following required
argument was not provided:` strings + serde rename map):

```
symbol, interval_minutes, dry_run, max_buy_order_size, spread_threshold,
trade_cooldown, balance_factor, current_market, log_price (no_log_price),
stop_before_end_ms, enable_gamble, min_price, max_price, slug,
cancel_orders_on_start (no_cancel_orders_on_start),
target_spread, order_size, max_position_size, refresh_interval_ms,
edge_threshold, inventory_skew, trade_side,
spread_reducer_probability, spread_reducer_value
```

## 8. Strategy dispatch

`run_single_market` branches on the `strategy` config field:

- `"dutch_book"` → `websocket::market_ws::run_trading_loop`
- `"spread_capture"` → `websocket::spread_capture_ws::run_spread_capture_loop`

`dutch_book` is the name in the UI; the code implements a classical
prediction-market arbitrage: if `ask_up + ask_down < 1.0 - spread_threshold`,
buy both sides, book a riskless profit on settlement.

`spread_capture` is a simple market-making strategy that BUYs both sides when
the book spread exceeds `target_spread` × `edge_threshold`.

## 9. Key addresses / offsets for re-analysis

| Address | Symbol |
|---|---|
| `0x8f8b0` | `TradingClient::new::{{closure}}` (primary monomorphization) |
| `0xe96f0` | `TradingClient::new::{{closure}}.4051` |
| `0x10f5e0` | `TradingClient::new::{{closure}}.4162` |
| `0x91f80..0x920d0` | inlined `send_debug_data`: env::vars → filter → reqwest::Client::post → execute_request |
| `0x92053` | LEA of `"https://gabagool22.com/api/verify-balancing-conf"` |
| `0xd0ef0..0xd6f36` | `Client::post_orders::{{closure}}.3905` — signed order serialiser |
| `0x80430` | `Client::create_headers::{{closure}}` — L2 auth header builder |
| `0xabb70` | `ClientInner<Unauthenticated>::create_headers::{{closure}}` — L1 auth header builder |

## 10. What the strings dump *also* revealed

- Output log tag: `@@EVENT:` — every parseable structured event.
- EIP-712 domain/type name: `ClobAuthDomain1` (version "1").
- Hardcoded fallback signer message: `This message attests that I control the given wallet`.
- Order type enum encoded as uppercase on wire (`GTC`, `FOK`, `GTD`, `FAK`) but
  the binary also knows the lowercase variants for serde `other` fallback.
- Order status enum: `MATCHED / DELAYED / UNMATCHED` — same uppercase wire form.
- BUY side markers in logs: `BUY UP`, `BUY DOWN`, `SELL` — match the
  `tradeSide` field in the DB.
