# Arbigab Replica Canary Plan

This document tells you how to actually take the replica live on
Polymarket in the minimum number of risky steps.

Three validation levels, in order of cost:

| Level | What it proves | Risk  | Handled by |
|-------|----------------|-------|------------|
| 1. Offline tests   | Replica decision logic + signature bytes + wire shape | None | `cargo test` (35 tests, green) |
| 2. Auth bootstrap  | Polymarket accepts your key + issues API creds | Trivial — no order placed | `canary.sh bootstrap` |
| 3. Live canary     | CLOB accepts an order at minimum size | Small — one order, min size, dry-run first | `canary.sh canary` |

## Level 1 — offline validation (already passing)

```
cd replica && cargo test
```

What's covered:
- Pivot semantics (`|net_pos| > max_pos`), gate strict inequality,
  decay floor, mode suppression.
- Full 13-step sequential replay driving inventory buildup → decay
  → gate close → flip → flat.
- Signature recovers to signer address, domain constants match
  artifact rodata, JSON field shape matches CLOB schema, side and
  nonce both covered by the signing hash.
- L2 HMAC determinism and per-input sensitivity.

If any test fails, **do not proceed**. Offline is free; use it.

## Level 2 — auth bootstrap (near-zero risk)

Goal: prove your private key can successfully call
`POST /auth/api-key` and receive `(apiKey, secret, passphrase)`.

This places **no order** and costs no MATIC. It only signs a
message — Polymarket's server validates the signature and mints
API credentials bound to your EOA.

### Steps

1. Generate a fresh key on your own machine. Never paste it in a
   chat window.

   ```bash
   # If you have foundry:
   cast wallet new

   # Or plain openssl:
   openssl rand -hex 32
   ```

2. Export it in the shell where you'll run the canary:

   ```bash
   export POLYMARKET_PRIVATE_KEY=0x<your_hex_key>
   ```

3. Run:

   ```bash
   cd replica
   ./scripts/canary.sh bootstrap
   ```

   The script will print the EOA address derived from your key,
   call `/auth/api-key`, and save the returned credentials to
   `.replica/creds.json` (gitignored).

4. **What success looks like:** HTTP 200 from `/auth/api-key`,
   credentials JSON parsed and saved. No order placed.

5. **What failure looks like:** HTTP 4xx from `/auth/api-key`
   means the signature was rejected — usually a mismatch in the
   ClobAuth struct/domain, not a funding issue. The script
   prints the response body so you can see the exact error.

## Level 3 — live canary (minimum real risk)

Goal: prove the full POST path works end-to-end by placing **one
real order at minimum size on a non-critical market**, watching
it appear in the book (or get rejected with a diagnostic).

### Prerequisites

- Level 2 completed, credentials cached.
- The EOA funded on Polygon with:
  - A few MATIC for gas (~$0.01 worth).
  - Enough USDC.e to cover the order's notional at minimum size
    (Polymarket's minimum is tiny; a single USDC is plenty).
- A **throwaway market** chosen. Criteria:
  - Cheap share price (something at ~$0.01 on one side).
  - Still open (not resolved).
  - Not a market you care about.
- The token_id of that market (YES or NO side). Get it from the
  Polymarket UI or their public markets API.

### Steps

1. Prepare a BotConfig JSON with:
   ```json
   {
     "symbol": "canary-test",
     "current_market": "<canary market slug>",
     "max_buy_order_size": 1.0,
     "spread_threshold": 0.0,
     "trade_cooldown": 1000,
     "balance_factor": 1.0,
     "stop_before_end_ms": 60000,
     "min_price": 0.01,
     "max_price": 0.99,
     "max_position_size": 0.0,
     "trade_side": "buy_only",
     "target_spread": 0.0,
     "interval_minutes": 60,
     "dry_run": true,
     "enable_gamble": false,
     "log_price": true,
     "cancel_orders_on_start": false
   }
   ```

   Save as `config.json`.

2. **Dry run first.**

   ```bash
   ./scripts/canary.sh dryrun --config config.json --token-id <id>
   ```

   This runs the full pipeline **including auth headers** but
   short-circuits at the POST. You'll see the signed payload
   and the computed L2 signature logged. Read them.

3. **Single live order.**

   Flip `dry_run` to `false` in config.json, set `max_position_size`
   high enough that the pivot will fire once (e.g., 1000 if your
   `net_position` input is 2000), and run:

   ```bash
   ./scripts/canary.sh canary --config config.json --token-id <id>
   ```

   The script invokes the replica once, places one order, then
   exits. Watch the script output for:
   - HTTP 200 + order acknowledgment JSON → success.
   - HTTP 4xx → read body; common issues:
     - 401: auth headers bad (timestamp drift, secret decode,
       HMAC canonical string). Check clock.
     - 400: order rejected (price out of range, size too small,
       tokenId mismatch, nonce conflict).
     - 403: account restriction (not onboarded, geo-blocked).

4. **Verify in the Polymarket UI.** Go to the market, check
   Orders → Open. Your order should appear with the matching
   size and price.

5. **Cancel and withdraw.**
   - Cancel the order via the Polymarket UI (or extend the
     replica with a cancel endpoint).
   - Move USDC.e and MATIC out of the canary EOA.
   - Archive `.replica/creds.json` or rotate the key.

### Rollback

At any step you can stop by `Ctrl-C`; the replica does not hold
open sockets or persistent schedulers. The only durable state is
`.replica/nonce` (one integer) and `.replica/creds.json`.

## What the canary does NOT prove

- **Profitability.** It only proves the replica can place one
  order. Whether that strategy makes money is unrelated and
  depends on parameter choice + market selection (neither of
  which was sold with the artifact — see FINAL_AUDIT §19).
- **Large-size market impact.** Minimum size is minimum size.
  If you scale the replica up, slippage and partial fills
  change its PnL shape.
- **Long-running stability.** The canary places one order and
  exits. Extended runs may surface issues like nonce drift if
  the persistence cadence is too loose (see IMPLEMENTATION_SPEC
  §10).

## Decision tree

```
cargo test green?
├── No  → fix before touching a wallet
└── Yes
    ├── canary.sh bootstrap succeeds?
    │   ├── No  → debug signature/domain; do NOT fund wallet
    │   └── Yes
    │       ├── dry-run prints expected signed payload?
    │       │   ├── No  → debug wire shape
    │       │   └── Yes
    │       │       └── Send ≤$1 of MATIC + USDC.e to the EOA
    │       │           └── Run canary.sh canary once
    │       │               ├── HTTP 200 → replica validated
    │       │               └── HTTP 4xx → debug per response body
```
