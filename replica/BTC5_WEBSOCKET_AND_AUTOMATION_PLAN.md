# BTC5 WebSocket And Automation Plan

## Why this is next

The shadow/reference work gives us a stable way to measure:

- how many fills the reference wallet gets in each 5-minute BTC window
- how often our engine would have fired in shadow mode
- where our decision stream still diverges from the reference wallet

That should drive the next two upgrades:

1. move the engine away from poll/sleep/cancel churn
2. automate the measurement loop before we automate more live risk

## Current engine bottlenecks

Right now `scripts/run_replica_btc5_accumulator.py` still behaves roughly like:

1. fetch both books over REST
2. decide actions
3. place orders
4. sleep
5. cancel all
6. sleep again

That means we are still losing time to:

- repeated REST polling
- repeated cancel/repost cycles
- no persistent per-side ladder across cycles
- delayed fill awareness until the next polling/reconciliation pass

## WebSocket direction

The official Polymarket US docs show two useful real-time channels:

- market data / trades WebSocket
- private orders / positions / balance WebSocket

Useful references:

- [Markets WebSocket](https://docs.polymarket.us/api-reference/websocket/markets)
- [WebSocket SDK Overview](https://docs.polymarket.us/api-reference/sdks/typescript/websocket)

Important caveat:

- our current engine is built around the international CLOB flow and the local `arbigab-replica` binary, not the Polymarket US SDK
- so this is an architecture target, not a drop-in replacement

## Migration phases

### Phase 1

Use the new shadow/reference recorder for one-hour windows and keep refreshing the recent-wallet forensics report.

Goal:

- measure the gap before changing transport

### Phase 2

Add a market-data feed adapter that can accept:

- current REST book snapshots
- later, real-time best-bid/best-ask and trade updates from WebSocket

Goal:

- isolate quote/decision logic from transport

### Phase 3

Add a private execution state adapter for:

- live order updates
- positions
- balance / allowance updates

Goal:

- reduce blind spots after order submission

### Phase 4

Replace cancel-all-per-cycle with persistent ladder management:

- one controlled live ladder per side
- amend/reprice instead of tearing down the whole book
- session-level inventory skew remains in charge

Goal:

- get closer to the reference wallet’s “aggressive but controlled” shape

## Automation hook

Once the recorder is stable, the first automation should be:

- run the shadow/reference recorder for one hour
- refresh recent wallet forensics
- summarize:
  - reference trade rate
  - our shadow action rate
  - best pair quotes
  - residual/risk warnings

That automation should be measurement-first, not unconstrained live trading.
