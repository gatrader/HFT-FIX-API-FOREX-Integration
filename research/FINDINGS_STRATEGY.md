# Strategy-layer findings — cross-verified via objdump
Date: 2026-04-19

Evidence below is from direct disassembly of `bot/bin/arbitrage_bot`.
Addresses are file offsets (not Ghidra's PIE-shifted ones — add
0x100000 to match the Ghidra headless output in `research/elf/ghidra/`).

## 1. Two-layer strategy — code-path proof

### Layer 1: public `dutch_book` (paired batch)

Live entry: `TradingClient::place_batch_buy_orders::{{closure}}`
at **0x0c5390**, 4186 asm lines.

Direct calls extracted from the .text range:

```
TradingClient::get_position           (h.fdeecf70a65e6fcd)
TradingClient::register_order         (h.c2652a31c438ef11)
TradingClient::add_filled_shares      (h.6ad24d7705f8a825)
<rust_decimal::Decimal as Display>::fmt
<rust_decimal::Decimal as FromStr>::from_str
```

No `place_single_order`. No `subtract_filled_shares`. This is the
**paired** path — it reads current inventory, sizes both legs of a
YES/NO pair together, submits them as a batch.

### Layer 2: hidden `spread_capture` (single-side)

Entry: `websocket::spread_capture_ws::run_side_capture::{{closure}}`
at **0x0d9e90**, 6903 asm lines.

Direct calls extracted:

```
TradingClient::get_position           (h.fdeecf70a65e6fcd)   <- shared
TradingClient::cancel_orders          (h.149efe0a13ec4c08)   <- different
TradingClient::add_filled_shares      (h.6ad24d7705f8a825)   <- shared
TradingClient::place_single_order     (h.12253ef1e0a05444)   <- LAYER 2 ONLY
TradingClient::subtract_filled_shares (h.9ea9aef832299277)   <- LAYER 2 ONLY
```

The single-side primitive `place_single_order` is only reachable from
this path. Combined with `subtract_filled_shares` it can actively
**reduce** a position (sell a leg), which the paired `place_batch_buy`
path cannot do — paired only buys and waits for settlement.

This is the strongest code-path evidence to date that the bot has a
richer single-side market-making mode separate from the advertised
Dutch-book BUY-both-sides behaviour.

## 2. Hidden config fields — confirmed as binary strings

`strings arbitrage_bot` reveals every "hidden" knob Codex listed in
the live Docker volume configs:

Public (exposed via `--help`):
- `symbol`, `interval_minutes`, `dry_run`, `max_buy_order_size`,
  `spread_threshold`, `trade_cooldown`, `balance_factor`,
  `current_market`, `no_log_price`, `stop_before_end_ms`, `min_price`,
  `max_price`, `slug`, `no_cancel_orders_on_start`.

**Hidden** (in binary .rodata but NOT in `--help`):
- `enable_gamble`
- `target_spread`
- `order_size`
- `max_position_size`
- `refresh_interval_ms`
- `edge_threshold`
- `inventory_skew`
- `trade_side`
- `spread_reducer_probability`
- `spread_reducer_value`
- `max_loss`
- `base_fee`  ← not in Codex's list; also present

Verified via literal string match against `.rodata`.

Value-alphabet fragments also present:
- `"up"` (default for `trade_side` — set by
  `config::default_trade_side` at 0x176fc0)
- `"down"`
- `"-up-or-down"`
- `"moderated"`, `"disabled"` (likely `enable_gamble` states — 3 modes)
- `"down_bid"`, `"down_ask"` (likely fine-grained `trade_side` values)

## 3. Self-description banner (bot knows what it is)

The binary's own help/banner string contains:

```
Spread Capture Bot: BUY both sides when spread > threshold
```

Not "Dutch Book Bot". The paired-BUY dutch-book is only the **public
mode**; the bot's internal name for itself is Spread Capture. The
single-side `run_side_capture` path is the eponymous mechanism.

## 4. Function → module mapping

From `objdump -d` symbol enumeration:

| Function | File offset | Ghidra addr | Source |
|---|---|---|---|
| `run_single_market::{{closure}}` | 0x089670 | 0x189670 | arbitrage_bot |
| `fetch_market_assets::{{closure}}` | 0x08d380 | 0x18d380 | market::fetch |
| `fetch_market_assets_direct::{{closure}}` | 0x08e9b0 | 0x18e9b0 | market::fetch |
| `TradingClient::new::{{closure}}` | 0x08f8b0 | 0x18f8b0 | trading::client |
| `run_spread_capture_loop::{{closure}}` | 0x097950 | 0x197950 | websocket::spread_capture_ws |
| `run_trading_loop::{{closure}}` | 0x09ef40 | 0x19ef40 | websocket::market_ws |
| `cancel_all_open_orders::{{closure}}` | 0x0a6400 | 0x1a6400 | trading::client |
| `cancel_orders::{{closure}}` | 0x0c2b80 | 0x1c2b80 | trading::client |
| `place_batch_buy_orders::{{closure}}` | 0x0c5390 | 0x1c5390 | trading::client (PAIRED) |
| `place_batch_buy_orders::{{closure}}::{{closure}}` | 0x0c9cd0 | 0x1c9cd0 | inner |
| `run_side_capture::{{closure}}` | 0x0d9e90 | 0x1d9e90 | websocket::spread_capture_ws (SINGLE-SIDE) |
| `place_single_order::{{closure}}` | 0x0e1a10 | 0x1e1a10 | trading::client |
| `run_user_ws_monitor::{{closure}}` | 0x0b5f50 | 0x1b5f50 | websocket::user_ws |
| `BotConfig::load_from_file` | 0x177010 | 0x277010 | config |
| `BotConfig::merge_with_args` | 0x177480 | 0x277480 | config |
| `default_trade_side` | 0x176fc0 | 0x276fc0 | config |

## 5. Inlined handlers (not separately extractable)

The following handlers exist in the binary ONLY as
`drop_in_place<...::{{closure}}>` destructors, meaning their bodies
are **fully inlined** into the state-machine loops (LTO):

- `market_ws::handle_book_message::{{closure}}`
- `market_ws::handle_price_change::{{closure}}`
- `market_ws::process_ws_message::{{closure}}`
- `spread_capture_ws::handle_book::{{closure}}`
- `spread_capture_ws::handle_price_change::{{closure}}`
- `spread_capture_ws::process_market_message::{{closure}}`

Recovering these requires dissecting the 6–10 KB async state-machine
bodies in `run_trading_loop` / `run_spread_capture_loop` — Ghidra
headless cannot follow the jumptables automatically.

## 6. What's still unknown (decision-level constants)

- Exact numeric threshold values for `edge_threshold`, `target_spread`.
  These live in the deserialize impl of `BotConfig`, loaded from JSON
  at runtime. They are not hardcoded constants in the binary.
- Exact sizing formula: likely
  `order_size * balance_factor * (1 - inventory_skew * position)` but
  the precise algebraic form is inside the inlined handlers.
- `enable_gamble` semantics (three-state): "disabled" (no gambling
  behaviour), "moderated" (limited), unstated third mode — enabled?

## 7. Practical implication

The richer single-side strategy is reachable by:

1. Flipping `strategy = "spread_capture"` in the JSON config.
2. Populating the hidden fields (`enable_gamble`, `edge_threshold`,
   `target_spread`, `order_size`, `max_position_size`, `inventory_skew`,
   `refresh_interval_ms`, `trade_side`, `spread_reducer_probability`,
   `spread_reducer_value`, `max_loss`, `base_fee`) with meaningful
   values.
3. The sold GUI bots have these all zeroed — the seller is running a
   different config.

A defanged rewrite can target `strategy = "spread_capture"` +
sensible hidden-field defaults inferred from the live seller-wallet
on-chain history (to be reconstructed in `research/reconcile/`).
