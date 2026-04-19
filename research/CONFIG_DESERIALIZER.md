# BotConfig deserializer — complete field map

Date: 2026-04-18 (session freeze — resume tomorrow from Task 2)
Evidence: direct disassembly of `bot/bin/arbitrage_bot`. Entry:
`<&mut Deserializer as Deserializer>::deserialize_struct h d9147695d5040641`
at file offset `0x15ea80` (Ghidra addr `0x25ea80`), 3649 asm lines.

## 1. Length-dispatch jumptable

At `0x15ecc3..0x15ecdf` the parser computes `r15 - 4` (field-name
length minus 4), bounds-checks against 22, and dispatches through a
23-entry 4-byte signed-offset jumptable at `.rodata:0x6cc9b4`.

Decoded targets (file offset):

| len | target  | fields handled in that arm |
|-----|---------|---------------------------|
| 4   | 0x15ece1 | slug |
| 5   | err      | (none) |
| 6   | 0x15f0a8 | symbol |
| 7   | 0x15ef0c | dry_run |
| 8   | 0x15f340 | strategy, max_loss |
| 9   | 0x15f3bc | log_price, min_price, max_price |
| 10  | 0x15ef76 | order_size, trade_side |
| 11-12 | err    | (none) |
| 13  | 0x15f119 | enable_gamble, target_spread |
| 14  | 0x15f1bc | trade_cooldown, balance_factor, current_market, edge_threshold, inventory_skew |
| 15  | err      | (none) |
| 16  | 0x15f4e5 | interval_minutes, spread_threshold |
| 17  | 0x15f466 | max_position_size |
| 18  | 0x15edc0 | max_buy_order_size, stop_before_end_ms |
| 19  | 0x15f00d | refresh_interval_ms |
| 20  | 0x15ee90 | spread_reducer_value |
| 21  | err      | (none) |
| 22  | 0x15ed45 | cancel_orders_on_start |
| 23-25 | err    | (none) |
| 26  | 0x15f2c4 | spread_reducer_probability |

Error target is `0x15f520` — shared by all "no matching field"
paths; it rewinds to a generic `ignore_value()` call.

## 2. Comparison strategies used per length

### 4 chars: direct 32-bit `cmpl`
```
15ece1: cmpl $0x67756c73, 0(%r13)   ; little-endian "slug"
```

### 6 chars: 4+2 XOR fast-path
```
15f0a8: mov 0(%r13), %eax
        mov $0x626d7973, %ecx          ; "symb"
        xor %ecx, %eax
        movzwl 4(%r13), %ecx
        xor $0x6c6f, %ecx              ; "ol"
        or %eax, %ecx
        jne fail
```

### 7 chars: 4+4 overlapping XOR (offset 3)
```
15ef0c: mov 0(%r13), %eax
        mov $0x5f797264, %ecx          ; "dry_"
        xor
        mov 3(%r13), %ecx
        mov $0x6e75725f, %edx          ; "_run"
        xor; or; jne fail
```

### 8 chars: direct 64-bit movabs+cmp, bcmp fallback
```
15f340: movabs $0x7967657461727473, %rax  ; "strategy"
        cmp %rax, 0(%r13)
        je  strategy_handler
        ; fallthrough: bcmp against rodata "max_loss" @ 0x6cadc0
```

### 9 chars: 8+1 XOR, with `lea` constant-synthesis
Clever optimisation — three 9-char fields share suffix "_price" so the
compiler loads "log_pric" once and uses `lea` to produce the
"min_pric"/"max_pric" constants in-register:
```
15f3bc: mov 0(%r13), %rax
        movabs $0x636972705f676f6c, %rdx   ; rdx = "log_pric"
        xor %rdx, %rax
        movzbl 8(%r13), %ecx
        xor $0x65, %rcx                    ; 'e'
        or; je log_price_handler
15f3df: lea 0x6fa01(%rdx), %rax            ; rax = "min_pric" (= rdx + 0x6fa01)
        xor 0(%r13), %rax
        ...je min_price_handler
15f3fc: lea 0x10f201(%rdx), %rax           ; rax = "max_pric"
        ...je max_price_handler
```

### 10 chars: 8+2 XOR, bcmp fallback
"order_size" uses 8-byte movabs + 16-bit xor; on mismatch,
bcmp against rodata "trade_side" @ 0x6dca74.

### 13 chars: overlapping 8+8 XOR (offset 5, overlap 3)
```
15f119: mov 0(%r13), %rax
        movabs $0x675f656c62616e65, %rcx   ; "enable_g"
        xor
        mov 5(%r13), %rcx
        movabs $0x656c626d61675f65, %rdx   ; "e_gamble"
        xor; or; je enable_gamble_handler
```
Same pattern for target_spread.

### 14 chars: overlapping 8+8 XOR (offset 6, overlap 2), bcmp fallback
Fast-path XOR for trade_cooldown, balance_factor, current_market.
Fallback bcmp against rodata "edge_threshold" @ 0x6dca58 and
"inventory_skew" @ 0x6dca66.

### 16+ chars: SSE2 pcmpeqb + pmovmskb
```
15f4e5: movdqu 0(%r13), %xmm0
        pcmpeqb 0x6c8910(%rip), %xmm0   ; "interval_minutes" rodata
        pmovmskb %xmm1, %eax
        cmp $0xffff, %eax
        jne next_check
```
For fields > 16 chars, two pcmpeqb at appropriate offsets are
combined with `pand`. All long field constants live contiguously
in `.rodata:0x6c8830..0x6c8930`.

## 3. Complete field list (26 entries)

Packed in rodata at `0x6dc984..0x6dcaac` (contiguous byte blob):

**Public (14, exposed as CLI args via clap):**
symbol, interval_minutes, dry_run, max_buy_order_size,
spread_threshold, trade_cooldown, balance_factor, current_market,
log_price (CLI: --no-log-price inverts), stop_before_end_ms,
min_price, max_price, slug, cancel_orders_on_start (CLI:
--no-cancel-orders-on-start inverts).

**Hidden (12, JSON config only):**
order_size, trade_side, enable_gamble, target_spread, edge_threshold,
inventory_skew, max_position_size, refresh_interval_ms,
spread_reducer_value, spread_reducer_probability, strategy, max_loss.

`base_fee` does NOT appear in BotConfig — it exists in `.rodata` at
0x6cad38 but is part of a different struct (likely a WebSocket trade
event). Same for `errorMsg`, `tradeIds`, `down_bid`, `down_ask`.

## 4. Default values

Only one named `#[serde(default = "...")]` function exists:
`arbitrage_bot::config::default_trade_side` @ `0x176fc0`. Body:
```
malloc(2)
movw $0x7075, (%rax)         ; writes "up"
mov $2, len; ret              ; String len=2, cap=2
```
→ `default trade_side = "up"`.

All other fields use `Default::default()` for their type:
- bool (dry_run, log_price, current_market, cancel_orders_on_start,
  enable_gamble if bool): `false`
- u32/u64 (interval_minutes, trade_cooldown,
  refresh_interval_ms, stop_before_end_ms): `0`
- f64 (spread_threshold, balance_factor, min_price, max_price,
  order_size, max_buy_order_size, max_position_size,
  target_spread, edge_threshold, inventory_skew,
  spread_reducer_value, spread_reducer_probability, max_loss): `0.0`
- String (symbol, slug, strategy, trade_side, enable_gamble): `""`

Confirmed by the SeqAccess fallback path (~0x16245a..0x162579)
which uses `pxor xmm0,xmm0; movq xmm0, [rsp+field]` to zero each
field slot when the input sequence terminates early, except for
trade_side which calls `default_trade_side` explicitly.

## 5. Sizing-formula f64 constants (from place_batch_buy_orders)

| addr | value | role |
|------|-------|------|
| 0x6caba0 | 5.0 | max_buy_order_size clap default |
| 0x6caba8 | 0.5 | sizing inventory-skew multiplier |
| 0x6cabb0 | 2.5 | probably default cap somewhere |
| 0x6cabb8 | 1.0 | gen_range upper bound |

Arithmetic observed in `place_batch_buy_orders::{{closure}}` at
`0x0c54b0..0x0c5550`:

```
yes = A + (ask - bid) * position * 0.5
no  = A - (ask - bid) * position * 0.5
yes = clamp(yes, 0, 2*A)
no  = clamp(no,  0, 2*A)
```

Then `gen_range(0.0, 1.0)` is called TWICE (yes + no sides) and
the result multiplied by each side's target and rounded:

```
yes_actual = round( gen_range(0,1) * yes_target )
no_actual  = round( gen_range(0,1) * no_target  )
```

This is the **size-randomisation layer** — every batch places an
integer random fraction of the target on each side. Likely
implements `spread_reducer_probability` / `spread_reducer_value`
mechanics (further evidence needs the inlined handler body —
not recoverable without Ghidra GUI or gdb runtime trace).

## 6. strategy value dispatch

Length-8 arm has an 8-byte exact cmp against "strategy" at
`0x15f340`. On match, the VALUE parsing loads the string and
`bcmp` against:
- `0x6cadb8` = "strategy" (literal, for error message)
- `0x6cadc0` = "dutch_bo" — captured earlier at `0x160720`/`0x160c05`
  as `movabs $0x6f625f6863747564` which is "dutch_bo" (with 2 chars
  "ok" presumably appended via a bcmp tail to complete "dutch_book").

The only strategy string constants in `.rodata` are:
- "dutch_book" (compared)
- "spread_capture" (presumably, since the module is
  `spread_capture_ws` and the banner says "Spread Capture Bot")

## 7. What's still open (to resume tomorrow)

- Task 2 (inlined handler bodies): decode the state-machine loops at
  `run_trading_loop` (0x19ef40) and `run_spread_capture_loop`
  (0x197950) — these hold the actual decision logic for
  `dutch_book` vs `spread_capture`. Jumptables at `DAT_007cbd60`
  and `DAT_007cb914` have 64+ states each.
- Task 4 (enable_gamble semantics): "moderated"/"disabled" strings
  in rodata are referenced only from tokio/std library code, NOT
  from strategy code. enable_gamble is likely a **bool** post
  deserialisation, and its three-state semantics (if any) come from
  a separate field/logic. Need to trace usage in the inlined
  handlers.
- Task 5 (spread_reducer mechanics): size-randomisation is already
  decoded; probability-gated skip/apply still needs the handler.
- Task 6 (strategy switch flow): after BotConfig is built, `main`
  dispatches to either `run_trading_loop` or
  `run_spread_capture_loop`. Confirming this dispatch point is a
  ~30-minute trace task.
