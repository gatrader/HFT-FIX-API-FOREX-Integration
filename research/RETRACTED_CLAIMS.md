# Retracted Claims Ledger

Standing log of assertions we previously made about Arbigab and
later withdrew, with the correction. The purpose of this file is
to prevent drift: without a public ledger, retracted claims tend
to re-assert themselves in later passes under new prose.

**Rule**: if an entry below contradicts anything in a newer
document, the newer document is wrong, not this one. Update in
place; do not delete entries.

Scope: artifact (`bot/bin/arbitrage_bot`) only. NON Stingo wallet
analysis is a separate track with its own retraction ledger if
one is maintained there.

---

## R-01 — `enable_gamble` is at BotConfig+0xa0

- **Asserted**: earlier passes placed `enable_gamble` at
  `BotConfig+0xa0`.
- **Withdrawn**: §31 proved the offset is `BotConfig+0xe5`.
  `+0xa0` is `max_position_size` (f64), not a boolean.
- **Withdrawn in**: `STRATEGY_SEMANTICS.md` §31.
- **Status**: final.

## R-02 — `target_spread` is a dead/unused field

- **Asserted**: earlier passes marked `target_spread` as
  decorative because no obvious consumer was found at the
  expected offset.
- **Withdrawn**: §31 proved the field is at `BotConfig+0xc0`
  (not where it was first searched), and that it is **live**:
  it seeds a runtime urgency-decay state used by the entry
  gate at `0xde541`.
- **Withdrawn in**: §31.
- **Status**: final.

## R-03 — The reducer gate depends on `enable_gamble`

- **Asserted**: a reducer/throttle branch at `0xc1a1f` was
  thought to gate on `enable_gamble`.
- **Withdrawn**: §31 proved the gate actually reads the
  `Option::Some` discriminant byte of
  `spread_reducer_probability` at `BotConfig+0xd0`, not
  `enable_gamble`.
- **Withdrawn in**: §31.
- **Status**: final.

## R-04 — `spread_capture` is a buy-only strategy

- **Asserted**: earlier passes modeled `run_side_capture` as a
  one-sided BUY quoter.
- **Withdrawn**: §31 proved the 23-state machine handles BOTH
  BUY (state 8) and SELL (state 15) inside the same closure.
  The Side byte is written at the state entry for each.
- **Withdrawn in**: §31.
- **Status**: final.

## R-05 — Side byte is at parent+0x2eb

- **Asserted**: earlier passes placed the Side byte at
  `parent+0x2eb`.
- **Withdrawn**: §31 proved it is at `parent+0x2ec`, the high
  byte of the `movw $0x0000, 0x2eb(%rbx)` /
  `movw $0x0100, 0x2eb(%rbx)` writes at `0xde731` / `0xdf7da`.
  `+0x2eb` is the async_state byte, not Side.
- **Withdrawn in**: §31.
- **Status**: final.

## R-06 — BotConfig is 0xe0 bytes

- **Asserted**: earlier passes gave BotConfig a total size of
  0xe0 bytes.
- **Withdrawn**: §31 proved BotConfig extends to at least
  `+0xe8` and is ~0xf0 bytes total.
- **Withdrawn in**: §31.
- **Status**: final.

## R-07 — The jumptables are at 0x7cb*

- **Asserted**: jumptable addresses were listed in the `0x7cb*`
  range.
- **Withdrawn**: §31 proved the actual addresses are
  `0x6cb914`, `0x6cb9a0`, and `0x6cbe38`. The earlier numbers
  were a transcription error from a different binary variant.
- **Withdrawn in**: §31.
- **Status**: final.

## R-08 — `max_position_size` is read directly from `BotConfig+0xa0` by `run_side_capture`

- **Asserted**: §31/§32 expected the BUY↔SELL pivot to read
  `max_position_size` directly off `BotConfig+0xa0` inside
  `run_side_capture`.
- **Withdrawn**: §33.1 proved the comparator at `0xdc931` reads
  `max_position_size` from `rsp+0x1a8` — a stack temp spilled
  from an earlier load. The value still originates from
  `BotConfig+0xa0` (that offset is not retracted), but the
  read site used by the pivot is not there.
- **Withdrawn in**: §33.4.
- **Status**: final.

## R-09 — `trade_side` (SpreadConfig+0x38) is the dynamic BUY↔SELL pivot gate

- **Asserted**: the SpreadConfig-mapping agent in §33.2 flagged
  `trade_side` at `SpreadConfig+0x38` as the primary pivot
  comparator for BUY/SELL.
- **Withdrawn**: §33.2 narrative clarifies this is a **static
  mode selector** (does the bot run one side or both), not the
  per-tick pivot. The dynamic pivot is §33.1's `ucomisd` at
  `0xdc931` on `net_position` vs `max_position_size`. Both
  coexist: `trade_side` decides whether both legs are
  authorized; `0xdc931` decides when each fires.
- **Withdrawn in**: §33.2.
- **Status**: final.

---

## Retractions from adjacent analysis (for awareness only)

These are not Arbigab-artifact retractions. They are flagged here
so nobody accidentally re-imports them into the artifact audit.

## R-X1 — NON Stingo is a BTC-only engine

- **Asserted elsewhere**: that the NON Stingo wallet trades
  exclusively BTC.
- **Withdrawn elsewhere**: the wallet profile shows positions
  in BTC, ETH, SOL, XRP, BNB, and DOGE. Engine inference
  remained BTC-derived, but the universe is multi-asset.
- **Status**: **out of scope for Arbigab**. Listed here purely
  to stop it from contaminating the artifact audit by
  accident. NON Stingo is a different strategy family (taker
  paired-arb hedger) and does not share code, data, or
  operators with Arbigab (maker urgency quoter).

---

## How to add an entry

When retracting a claim:

1. Assign the next R-NN id.
2. Record what was asserted (quote or paraphrase).
3. Record the proof that withdraws it (section + address).
4. Record where the retraction was first made.
5. Set status to `final` when the correction has landed in the
   primary spec; `provisional` if the correction itself is
   still being verified.

Do not delete entries even when everyone has internalized them.
Drift is the only enemy this file exists to fight.
