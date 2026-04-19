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

## 3. Sizing formula (place_batch_buy_orders, 0xc5498..0xc5550)

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

## 9. Open items (not blocking the rewrite)

- Pin which struct offsets each inferred default field lives at,
  so the bool-flag tracing for `enable_gamble` and `current_market`
  can be finished deterministically.
- Decode individual run_trading_loop state handlers (28 async
  states). Most are "await future"; the interesting arithmetic
  states are a small subset. Not needed to replicate the strategy
  — we already have the sizing/reducer math.
- Confirm `current_market` semantics. Its default (0 → false) and
  the `trade_side` down/up overlap suggest it flips the
  spread_capture side-assignment.
