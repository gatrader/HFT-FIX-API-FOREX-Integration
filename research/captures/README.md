# Captures

Dynamic captures from the MITM harness (`../mitm/`). Private keys used for
these captures are the throwaway Hardhat test key `0xac0974bec39a…ff80`,
wallet `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266` — **not a funded wallet**.

## Files

- `signed_orders.jsonl` — full batch-order POSTs captured from `POST
  https://clob.polymarket.com/orders`. One JSON object per line, each containing
  `timestamp`, `headers`, and `body` (a JSON array of signed Orders).
- `signed_order_capture.jsonl` — earlier capture before the response-shape fix
  (orders still signed and sent, but the bot treated the responses as errors).

## Endpoint note

The bot uses the **batch** endpoint, not the single-order one:

- `POST https://clob.polymarket.com/orders`
  body: JSON **array** of `{order, orderType, owner, postOnly}`
  response: JSON array of `{orderID, success, errorMsg, …}` per leg
- The singular `POST /order` path exists in the SDK but is not used by this
  binary on the dutch_book / spread_capture paths.

## Request shape

Each element of the batch body:

```jsonc
{
  "order": {
    "salt":          1096563795,        // integer, not string
    "maker":         "0x...",           // EOA address
    "signer":        "0x...",           // same as maker for SIG_TYPE=0
    "taker":         "0x0000...0000",   // zero for public book orders
    "tokenId":       "10000...0001",    // u256 as decimal string
    "makerAmount":   "2100000",         // u256 as decimal string (6 decimals = USDC)
    "takerAmount":   "5000000",         // u256 as decimal string
    "expiration":    "0",               // "0" = GTC never expires
    "nonce":         "0",
    "feeRateBps":    "0",
    "side":          "BUY",             // string "BUY"/"SELL"
    "signatureType": 0,                 // 0=EOA, 1=POLY_PROXY, 2=POLY_GNOSIS_SAFE
    "signature":     "0x...65bytes..."  // EIP-712 signature
  },
  "orderType": "GTC",                   // GTC | FOK | GTD | FAK
  "owner":     "<apiKey-uuid>",         // the API key UUID, NOT the funder
  "postOnly":  false
}
```

### Headers (L2 auth)

```
poly_address:    0x<EOA address, lowercase>
poly_api_key:    <uuid>
poly_passphrase: <passphrase from /auth/api-key>
poly_signature:  <base64url-encoded HMAC-SHA256>
poly_timestamp:  <unix seconds as string>
Content-Type:    application/json
User-Agent:      rs_clob_client
```

### HMAC signature recipe (empirically inferred)

The L2 signature is HMAC-SHA256 using the `secret` from `/auth/api-key`,
over the canonical string:

```
<poly_timestamp> + <method> + <path> + <body>
```

base64url-encoded, without padding. This is the standard Polymarket CLOB L2
auth format.

## Full capture walk-through

A single trading loop iteration produces this exact call sequence (all over
TLS with the MITM CA trusted):

| # | Method | Host | Path | Purpose |
|---|---|---|---|---|
| 1 | GET | gamma-api.polymarket.com | /events?slug=stub | Market lookup |
| 2 | POST | clob.polymarket.com | /auth/api-key | L1 signed EIP-712 auth |
| 3 | **POST** | **gabagool22.com** | **/api/verify-balancing-conf** | **Phone-home (env-var exfil)** |
| 4 | GET | clob.polymarket.com | /auth/derive-api-key | Derive existing API key |
| 5 | WS  | ws-subscriptions-clob.polymarket.com | /ws/market | Subscribe to book |
| 6 | WS  | ws-subscriptions-clob.polymarket.com | /ws/user | Subscribe to user events |
| 7 | GET | clob.polymarket.com | /fee-rate | Per-leg before building |
| 8 | GET | clob.polymarket.com | /neg-risk | Per-leg before building |
| 9 | GET | clob.polymarket.com | /tick-size | Per-leg before building |
|10 | **POST** | **clob.polymarket.com** | **/orders** | **Signed batch order** |
|11 | POST | clob.polymarket.com | /order/\<id\>/cancel | Cancel after cooldown |

Steps 7–9 repeat on every tick, once per leg (UP + DOWN); the bot aggressively
re-fetches fee/tick-size rather than caching.

## What this confirms

- The **EIP-712 Order type** in `REVERSE_NOTE.md` § 5 is exact.
- The **POST body wrapper shape** (`{order, orderType, owner, postOnly}`) is
  confirmed from live signing output.
- The **batch endpoint** is `/orders` (plural) on `clob.polymarket.com`.
- The **`owner` field is the API-key UUID**, not the funder address as one
  might guess from the field name.
- `signatureType: 0` is the EOA path; the SDK also has `1` (Poly Proxy) and
  `2` (Gnosis Safe) code paths, selected by the `WALLET_TYPE` env var.
- **Phone-home happens before any trading activity** — step 3 fires
  unconditionally on `TradingClient::new`, so every bot start leaks env.
