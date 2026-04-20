# Arbigab Final Artifact Audit

Status: final, post §33. All claims cross-referenced to a specific
section in `STRATEGY_SEMANTICS.md` and, where applicable, a virtual
address in `bot/bin/arbitrage_bot`.

Classification legend:
- **Recovered** — proven from the binary with high confidence.
- **Inferred** — consistent with binary evidence but not directly
  proven; alternative explanations remain possible.
- **Rebuilt** — reconstructed by us as a spec/replica; not a direct
  artifact finding.
- **Unknown** — not determinable from the artifact alone.

Scope boundary: this audit covers **only** the Arbigab artifact
(`bot/bin/arbitrage_bot`) and its sibling assets. The NON Stingo
wallet analysis is a separate line of work, a different strategy
family (taker-side paired-arb hedger vs. maker-side urgency
quoter), and is **explicitly out of scope** for this document.

---

## 1. Binary identification

- **Path**: `bot/bin/arbitrage_bot`
- **Size**: 10,118,560 bytes
- **Format**: ELF x86-64, dynamic, **not stripped**
- **BuildID**: `0e348a5a11960611219d789b86331c82194f0dbb`
- **Toolchain**: Rust, detectable from symbol patterns and the
  `alloy_signer_local`, `tokio`, `reqwest`, `serde` crate
  signatures in the symbol table.
- Classification: **Recovered**.

## 2. Build environment

- Compiled on Linux glibc, release profile with debug symbols
  retained (hence "not stripped").
- No PIE hardening notes affect reversing.
- Classification: **Recovered** (from ELF headers).

## 3. Crate dependencies detected

- `tokio` (async runtime, `RwLock` suspend/resume present)
- `serde` + `serde_json` (XOR-jumptable field matchers observed)
- `reqwest` (HTTPS client used by `register_order`)
- `alloy_signer_local::PrivateKeySigner` (EIP-712 signing)
- `hmac` + `sha2` (for the exfil HMAC-SHA256 path)
- Classification: **Recovered**.

## 4. Async runtime / state machines

- Two primary async closures identified:
  - `run_trading_loop` — main orchestrator
  - `run_side_capture` — 23-state market-making loop
- Dispatch tables (jumptables) at:
  - `0x6cb914` (run_side_capture state byte at `rbx+0x259`)
  - `0x6cb9a0` and `0x6cbe38` (adjacent, sibling closures)
- Suspend points use tokio `RwLock::read`/`write`. State byte
  encodes position in the await graph.
- Classification: **Recovered**.

## 5. Configuration deserialization

- Serde deserializer path fully traced (§31).
- `BotConfig` total size ~0xf0 bytes, 17 declared fields.
- Proven offset map:
  - `+0x18` String `symbol`
  - `+0x48` Option<String> `current_market`
  - `+0x60` f64 `max_buy_order_size`
  - `+0x68` f64 `spread_threshold`
  - `+0x70` i64 `trade_cooldown`
  - `+0x78` f64 `balance_factor`
  - `+0x80` i64 `stop_before_end_ms`
  - `+0x90` f64 `min_price`
  - `+0x98` f64 `max_price`
  - `+0xa0` f64 `max_position_size` (inferred — see §33.4)
  - `+0xa8` String `trade_side` (inferred)
  - `+0xc0` f64 `target_spread`
  - `+0xd0` byte `spread_reducer_probability.Some` discriminant
  - `+0xe0` u32 `interval_minutes`
  - `+0xe4` bool `dry_run`
  - `+0xe5` bool `enable_gamble` (**decorative**, zero readers)
  - `+0xe6` bool `log_price`
  - `+0xe8` bool `cancel_orders_on_start`
- Classification: **Recovered** for proven offsets, **Inferred**
  for `max_position_size` and `trade_side`.

## 6. SpreadConfig (sub-struct at rbx+0x60, size 0x70)

- Live fields:
  - `+0x10` f64 `order_size`
  - `+0x20` f64 `edge_threshold`
  - `+0x28` f64 `target_spread` (runtime-decaying state)
  - `+0x38` u8  `trade_side` (static mode selector)
- ~8 remaining offsets initialized once, never read in the hot
  path — same decorative pattern as `enable_gamble`.
- Classification: **Recovered** for live fields, **Inferred** for
  decorative offsets.

## 7. Spread-capture state machine (run_side_capture)

- 23 states, jumptable at `0x6cb914`.
- Key states:
  - 0  INIT
  - 3  SUSPEND on `RwLock::read(rbx+0x268)` (order book read)
  - 8  EMIT BUY  (`place_single_order`, sets flag `rbx+0x25e`)
  - 15 EMIT SELL (`place_single_order`, sets flag `rbx+0x25f`)
  - 19 CANCEL (primary stack)
  - 22 CANCEL (secondary stack)
- BUY↔SELL pivot comparator at `0xdc931`:
  `ucomisd %xmm1, %xmm0` where xmm0=`net_position@rbx+0x130`,
  xmm1=`max_position_size@rsp+0x1a8`. Sign of `net_position`
  drives which side fires. Surplus stored at `rbx+0x268` feeds
  the `target_spread` decay.
- Classification: **Recovered**.

## 8. Target_spread urgency model

- Decay: `self[+0x28] = max(0, self[+0x28] − rbx[+0x268])` at
  `0xdcaa4`–`0xdcabb`.
- Gate at `0xde541`:
  `observed_spread ≤ edge_threshold + target_spread` → SKIP.
- Semantics: urgency ramp. Urgency grows with inventory surplus;
  when it's high, the bot accepts tighter spreads.
- Classification: **Recovered**.

## 9. Order construction (register_order)

- Entry at `0xe2825`, called from `place_single_order` with Side
  byte as arg 4 in `%cl`.
- 12-field Polymarket CLOB order populated as:

| Field          | Source                        |
|----------------|-------------------------------|
| salt           | fresh `getrandom()` per call  |
| maker          | `TradingClient+0x1b8` cached  |
| signer         | `TradingClient+0x1b8` (same)  |
| taker          | zero address                  |
| tokenId        | caller arg `%rdx`             |
| makerAmount    | caller arg `%rsi`             |
| takerAmount    | caller stack `[0x8]`          |
| expiration     | `SystemTime::now()` + window  |
| nonce          | `TradingClient+0x1a8` atomic  |
| feeRateBps     | `FeeRateResponse` cache       |
| side           | caller arg `%cl` (0/1)        |
| signatureType  | EIP-712 (alloy_signer_local)  |

- Classification: **Recovered**.

## 10. EIP-712 signing

- Domain constants observed in `.rodata`:
  - name = `"Polymarket CTF Exchange"`
  - version = `"1"`
  - chainId = 137
  - verifyingContract = `0x4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E`
- Signer is `alloy_signer_local::PrivateKeySigner`; the private
  key is loaded from configuration at init and held on
  `TradingClient`.
- Classification: **Recovered**.

## 11. Network endpoints

- Order POST: `https://clob.polymarket.com/data/orders`
- Market metadata / order book / fee rate: standard Polymarket
  CLOB REST endpoints under `clob.polymarket.com`.
- Exfil: `gabagool22.com` (HMAC-SHA256 credentialed).
- Classification: **Recovered**.

## 12. Credential exfiltration path

- HMAC-SHA256 used with a rotating key schedule derived in the
  init path (3 readers observed).
- Exact key derivation **Unknown**; structure is proven.
- Classification: **Inferred** for key schedule, **Recovered**
  for existence and transport.

## 13. Persistence / state on disk

- Config path is a CLI-driven JSON file (observed in serde
  entrypoint).
- **No evidence of nonce persistence.** The CLOB nonce atomic
  counter at `TradingClient+0x1a8` is in-memory only. This is a
  real operational defect in the seller's bot.
- Classification: **Recovered** (observation of absence).

## 14. Logging / telemetry

- `log_price` boolean observed at `BotConfig+0xe6` gates a
  human-readable price log.
- Structured logging via the standard `tracing`/`log` facade.
- Classification: **Recovered**.

## 15. Anti-analysis / obfuscation

- None observed. Binary is not stripped, strings are plaintext,
  no packer, no debugger detection.
- Classification: **Recovered** (observation of absence).

## 16. Kill switches / guardrails

- `cancel_orders_on_start` behaves as advertised.
- `dry_run` gates the `register_order` POST at the network edge.
- `enable_gamble` is **decorative** (zero runtime readers).
- No anti-giveback / drawdown-abort logic observed in the
  emit path. Primary/secondary CANCEL stacks (states 19, 22)
  are the only self-throttle, and they fire on book-state
  changes, not on PnL.
- Classification: **Recovered**.

## 17. Multi-strategy surface

- Two strategies coexist in this binary:
  - `run_trading_loop` — outer orchestrator, reads the broader
    BotConfig. Behavior mostly structural (market scheduling,
    cooldown, cancel-on-start).
  - `run_side_capture` — the actual market-making quoter. This
    is the live money-moving loop.
- BotConfig field bundles between the two paths are **disjoint**:
  the two closures consume non-overlapping subsets of BotConfig.
  See §32 for the bundle proof.
- Classification: **Recovered**.

## 18. Dashboard / radar client

- JS bundle under `bot/dist/` is intact and unrealized by this
  audit. It is a local-only observability surface and does not
  affect trading behavior.
- Classification: **Unknown** (not deobfuscated; not attempted).

## 19. Replica buildability

- A from-spec Rust replica of `run_side_capture` + order
  construction is now buildable without the binary. See
  `IMPLEMENTATION_SPEC.md` and `replica/`.
- Confidence that replica matches observed behavior on market
  replays: **~85%**. The 15% gap is decorative fields and the
  exfil HMAC schedule, neither of which alters trading.
- Confidence that replica recovers the **seller's edge**:
  **not recoverable from the sold artifact alone.** The edge,
  if any, lives in parameter values and market selection —
  neither was sold with the artifact.
- Classification: **Rebuilt**.

---

## Summary scorecard

| Area                          | Classification |
|-------------------------------|----------------|
| Binary ID + toolchain         | Recovered      |
| Crate dependencies            | Recovered      |
| Async state machines          | Recovered      |
| BotConfig layout              | Recovered (2 inferred offsets) |
| SpreadConfig layout           | Recovered (8 decorative inferred) |
| Spread-capture state machine  | Recovered      |
| Pivot comparator              | Recovered      |
| target_spread semantics       | Recovered      |
| Order construction            | Recovered      |
| EIP-712 signing               | Recovered      |
| Network endpoints             | Recovered      |
| Exfil path                    | Recovered (key schedule inferred) |
| Nonce persistence             | Recovered (defect)    |
| Kill switches                 | Recovered      |
| Anti-analysis                 | Recovered (none)      |
| Multi-strategy surface        | Recovered      |
| Dashboard client              | Unknown        |
| Seller's edge                 | Not in the sold artifact |

One-line verdict: **the artifact is substantially reversed; the
seller's edge was never in the artifact to begin with.**
