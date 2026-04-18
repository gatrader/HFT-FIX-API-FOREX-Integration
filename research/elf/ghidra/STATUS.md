# Ghidra decompilation — status and limits

## What Ghidra 12.0.4 headless produced

- `decompiled/` — 86 files, pseudo-C for arbitrage_bot + polymarket_client_sdk
  functions (first pass, filtered by symbol name).
- `decompiled_range/` — 84 files, pseudo-C for every non-drop function in
  the strategy address range `0x180000..0x230000` (second pass, keyed by
  entry address to avoid name collisions).
- `scripts/` — Java scripts driving both passes.

Total unique decompiled functions: **318** (many have identical short
names but distinct entry points — the address-suffixed pass is the
authoritative one).

## What decompiles cleanly

- Small synchronous helpers: `market::time::is_in_window`,
  `market::time::generate_slug`, `market::time::get_window_start_from_slug`,
  `market::time::get_window_end_from_slug`, `market::time::is_standard_slug`,
  `market::time::format_timestamp`, `utils::now_str`.
- Config: `BotConfig::load_from_file`, `BotConfig::merge_with_args`,
  `Args::detect_explicit_args`, `default_trade_side`.
- TradingClient getters/setters: `add_filled_shares`, `subtract_filled_shares`,
  `get_position`, `get_api_creds`, `register_order`, `set_fill_notifier`.
- Polymarket SDK: `Client::new`, `auth::to_message`, `auth::hmac`,
  `OrderBuilder::build`, `OrderBuilder::generate_seed`,
  `OrderBuilder::to_fixed_u128`, `derive_proxy_wallet`, `derive_safe_wallet`.

These are directly re-implementable in Rust.

## What Ghidra could NOT recover

The top-level **async state machines** that implement the trading
strategy:

- `arbitrage_bot::run_single_market::{{closure}}` (entries 0x189670,
  0x1e6150, 0x20c040)
- `arbitrage_bot::websocket::market_ws::run_trading_loop::{{closure}}`
  (entries 0x19ef40, 0x1f7330, 0x21d220)
- `arbitrage_bot::websocket::spread_capture_ws::run_spread_capture_loop::
  {{closure}}` (entries 0x197950, 0x1f08f0, 0x2167e0)
- `arbitrage_bot::websocket::spread_capture_ws::run_side_capture::
  {{closure}}` (entry 0x1d9e90)
- `arbitrage_bot::websocket::user_ws::run_user_ws_monitor::{{closure}}`

Each of these decompiles to a **17-line stub** that jumps into a
computed offset of `DAT_007cbd60`:

```c
(*(code *)(&DAT_007cbd60 + *(int *)(&DAT_007cbd60 + state * 4)))(self, cx, cx);
```

Ghidra logs the reason:

```
WARNING: Could not recover jumptable at 0x0020c071. Too many branches
WARNING: Treating indirect jump as call
```

These are **Rust async generator state machines** compiled with LTO.
The per-state handler bodies exist as separate functions in the binary,
but Ghidra can't reconnect them automatically because the jumptable
size is not statically inferable.

## Why pseudo-C from remaining functions is low-signal

Even for functions that do decompile, the output quality is poor
because of:

- **Heavy LTO inlining**: `place_batch_buy_orders` is spread across
  `.c` files with `local_88[0]`, `local_98`, `local_50`, etc. — no
  Rust type names survive.
- **Generic monomorphization**: every parameter is `undefined **`,
  requiring manual type recovery in the Ghidra GUI to turn into readable
  code.
- **Closure capture tuples**: closures capture heap-allocated tuples of
  state that Ghidra serialises as raw struct offsets.

Quantitative example: `TradingClient::place_batch_buy_orders::
{{closure}}::{{closure}}` at 0x1c9cd0 is 103 lines of Ghidra output
where the actual semantics (iterate orders, call sign, batch POST) are
buried under manual pointer arithmetic.

## Practical implications for the rewrite goal

Full byte-for-byte strategy reconstruction from this pseudo-C is
impractical without **manual Ghidra GUI type-recovery work** (~hours
per function, ~20 functions for the core strategy). That is not
achievable in the current sandbox (no GUI).

Two pragmatic paths exist:

### Path A — concept-level rewrite (recommended)

Use the extracted static evidence + symbol names + captured network
traffic to reconstruct the **strategy as a concept**, then re-implement
from scratch on top of `py-clob-client` or clean upstream
`rs-clob-client`:

- `dutch_book` strategy: we know from symbol names and from
  `market::fetch::fetch_market_assets` that the bot iterates tradeable
  markets (filtered by `is_in_window`), reads YES/NO prices via
  `market_ws`, and calls `place_batch_buy_orders` when the edge exceeds
  a threshold encoded in `BotConfig`. The exact threshold and sizing
  rule require reading `BotConfig::merge_with_args` + live MITM
  captures, not byte-for-byte decompilation.
- `spread_capture` strategy: similar structure but two-sided (separate
  side-capture loop at `run_side_capture::{{closure}}`). Symbol name +
  captured order flow in `research/captures/signed_orders.jsonl`
  suggests simple passive market-making on configured markets.

### Path B — manual Ghidra work in the GUI

Outside the sandbox, on a desktop with Ghidra 12.0.4 GUI, the state
machines can be recovered by:

1. Open the saved project at `/tmp/ghidra_proj/arbigab`.
2. For each stub function, right-click the indirect-jump byte,
   `Override Signature > Jumptable > Manual...`, supply the target
   table address and count.
3. Re-decompile. The state handlers become inline basic blocks.
4. Manually retype the `self` parameter of each closure to the
   captured-state struct Ghidra infers.

This is ~1 day/function for the 5 top-level loops + all their nested
closures — so ~2 weeks of focused GUI work for a clean strategy
recovery.

## Ghidra project artifact

The Ghidra project is at `/tmp/ghidra_proj/arbigab.gpr` inside the
sandbox and is **not committed** (binary artifact, ~60MB). If you
want to continue RE work on a desktop, re-run:

```
/opt/ghidra_12.0.4_PUBLIC/support/analyzeHeadless <workdir> arbigab \
  -import bot/bin/arbitrage_bot
```

~8 minutes. Same project state.
