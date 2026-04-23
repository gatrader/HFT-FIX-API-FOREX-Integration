# BTC5 Paired Arb Test

This repo now has two deliberately different BTC5 workflows:

- `scripts/run_replica_btc5_canary.sh`
  - single-token, single-order canary
  - useful for wallet wiring and minimum-size validation
  - intentionally **not** an arbitrage test
- "paired arb" (design in this document)
  - same-market `Up` + `Down` coordination
  - only path that should be treated as a true BTC5 edge test

## Why The Old Canary Lost Money

The current replica runtime is inventory-driven and operates on one token at a
time. When we pointed it at BTC5 `Down`, it behaved like a short-horizon
directional buyer, not a Dutch-book arbitrage engine.

That means:

- if only `Down` fills, we are directional
- if the BTC5 window resolves `Up`, the `Down` leg goes near zero
- mark-to-market can look fine during the window and still end in a realized
  loss at resolution

The patched canary script now uses the binary's one-shot `canary` subcommand so
one invocation cannot keep stacking repeated one-sided exposure.

## Goal

Build a burner-wallet BTC5 test that only enters a trade when both outcomes of
the **same** 5-minute market produce a positive edge after fees and slippage.

Practical target:

- buy `Up` and `Down` in the same market
- size both legs equally
- cap residual one-leg exposure tightly if one leg fails

## Market Preconditions

- use the exact same BTC5 event slug for both legs
- resolve token ids from the same Gamma event payload
- require the market's minimum size to be satisfied
  - recent live evidence showed a minimum of `5` shares
- use the current maker/taker fee from Gamma or CLOB metadata

## Entry Rule

For a same-market paired buy:

- `gross_cost = ask_up + ask_down`
- `all_in_cost = gross_cost + fee_buffer + slippage_buffer`
- trade only if `all_in_cost < 1.0 - edge_buffer`

Suggested conservative defaults:

- `fee_buffer = 0.02`
- `slippage_buffer = 0.01`
- `edge_buffer = 0.01`

So a first live rule can be:

- fire only if `ask_up + ask_down <= 0.96`

That is intentionally strict. The point is to test the workflow before
optimizing frequency.

## Size Rule

Use the minimum executable size across both legs:

- `pair_size = min(size_at_ask_up, size_at_ask_down, max_pair_shares)`

Then floor to the market minimum:

- if `pair_size < 5`, do not trade

Suggested first live value:

- `max_pair_shares = 5`

## Submission Rule

The pair test must never behave like the old one-leg canary.

Required sequence:

1. snapshot both books
2. verify edge still exists
3. sign both orders
4. submit both legs back-to-back with no extra decision loop
5. observe acceptance / rejection for each leg

Preferred implementation:

- one coordinator process handles both token ids
- one market cycle only per invocation
- no long-lived runtime loop during the paired test

## Residual Exposure Rule

This is the most important safety rule.

If only one leg is accepted or filled:

1. cancel the unfilled mate immediately
2. start a hedge timer
3. flatten the live leg aggressively using the opposite book side if the hedge
   does not complete quickly

Suggested hard limits:

- `hedge_timeout_ms = 250`
- `max_unhedged_shares = 5`
- `max_unhedged_loss = $2`

If those limits are breached, abort the test cycle and flatten.

## Hold Vs Exit

There are two valid paired modes:

- hold both legs to resolution
  - payout is deterministic if both legs are established
- opportunistic exit before resolution
  - only if both legs can be sold together at a profit

For the first true live paired test, use:

- hold-to-resolution once both legs are established

That removes mid-window unwind complexity from the first validation.

## Acceptance Criteria

A BTC5 paired arb test only counts as successful if all of these are true:

1. both orders belong to the same BTC5 market slug
2. both legs are sized equally
3. entry edge was positive after buffers
4. no residual open orders remain after cleanup
5. if only one leg filled, the leftover leg was flattened within the hedge
   timeout
6. final logs show:
   - market slug
   - both token ids
   - both prices
   - both order ids
   - both transaction hashes
   - final exposure state

## First Live Test Recipe

Burner-wallet version:

1. resolve the next BTC5 market
2. fetch `Up` and `Down` books once the market opens
3. if `ask_up + ask_down <= 0.96`, submit a `5` share pair
4. if one leg fails, flatten the other leg within `250 ms`
5. if both fill, hold to resolution
6. run post-market autoredeem / position check

## Repo Impact

Until a paired coordinator exists, treat the current canary as:

- wallet test
- execution-path test
- minimum-size validation

Do **not** treat it as an arbitrage engine.
