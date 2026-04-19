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
      │     cfg.trade_side.to_lowercase() ∈ {"no","down"} → is_bearish=true
      │     run_spread_capture_loop(cfg, is_bearish)       [0x097950]
      │
      └── else  (default — covers "" and "dutch_book")
            run_trading_loop(cfg)                         [0x09ef40]
```

Both loop functions are Rust async state machines, lowered with LTO
into opaque jumptables (28-ish states each). The dispatch byte lives
at `self+0x71b` for run_trading_loop, indexed through the jumptable
at `.rodata:0x6cb324`.

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
  `trade_side`. Acts more like a traditional market-maker
  quoting both sides, with per-side logic that depends on
  `is_bearish` (directional lean).

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
