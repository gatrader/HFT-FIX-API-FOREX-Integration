# Arbigab Replica — Implementation Spec

This document specifies what a from-scratch Rust replica of the
Arbigab trading engine must implement to reproduce the observed
behavior of `bot/bin/arbitrage_bot` on live Polymarket markets.

Every claim below is traced to a source in `STRATEGY_SEMANTICS.md`
and, where applicable, to a virtual address in the binary.

Out of scope:
- Dashboard / radar JS client (§18 of FINAL_AUDIT, non-trading).
- Credential exfiltration to `gabagool22.com`. Deliberately
  omitted from the replica — the replica is for spec validation
  and defensive review, not for replaying the seller's data
  pipeline.
- NON Stingo strategy (different family; separate track).

---

## 1. Crate layout

```
replica/
├── Cargo.toml
└── src/
    ├── main.rs              # CLI entry + config load + run
    ├── config.rs            # BotConfig + SpreadConfig types
    ├── signer.rs            # EIP-712 signer wrapper
    ├── order.rs             # CLOB order struct + POST
    ├── client.rs            # TradingClient (cached signer, nonce)
    ├── book.rs              # Order book snapshot + spread calc
    ├── state_machine.rs     # 23-state spread_capture loop
    └── nonce_store.rs       # Persistent nonce (fixes seller bug)
```

## 2. Config types (source: FINAL_AUDIT §5, §6)

### 2.1 BotConfig

```rust
#[derive(Deserialize)]
pub struct BotConfig {
    pub symbol: String,                       // +0x18
    pub current_market: Option<String>,       // +0x48
    pub max_buy_order_size: f64,              // +0x60
    pub spread_threshold: f64,                // +0x68
    pub trade_cooldown: i64,                  // +0x70
    pub balance_factor: f64,                  // +0x78
    pub stop_before_end_ms: i64,              // +0x80
    pub min_price: f64,                       // +0x90
    pub max_price: f64,                       // +0x98
    pub max_position_size: f64,               // +0xa0
    pub trade_side: TradeSideMode,            // +0xa8 (see 2.2)
    pub target_spread: f64,                   // +0xc0
    pub spread_reducer_probability: Option<f64>, // +0xd0
    pub interval_minutes: u32,                // +0xe0
    pub dry_run: bool,                        // +0xe4
    #[serde(default)] pub enable_gamble: bool,// +0xe5 (DECORATIVE)
    pub log_price: bool,                      // +0xe6
    pub cancel_orders_on_start: bool,         // +0xe8
}
```

Notes:

- `enable_gamble` must be accepted by the deserializer for
  backwards-compat with existing config files, but it **must
  have zero effect** on runtime behavior. See R-01 in
  `RETRACTED_CLAIMS.md` and §31/§32.
- `spread_reducer_probability` is an Option; the `.Some` path
  gates a secondary throttle branch at `0xc1a1f` (see R-03).

### 2.2 TradeSideMode (source: SpreadConfig+0x38)

```rust
#[derive(Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum TradeSideMode {
    Both,       // u8 = 0, both legs authorized
    BuyOnly,    // u8 = 1, only emit BUY
    SellOnly,   // u8 = 2, only emit SELL
}
```

This is a **static mode selector**. Do not confuse it with the
dynamic BUY↔SELL pivot (see §5). See R-09.

### 2.3 SpreadConfig (runtime state)

```rust
pub struct SpreadConfig {
    pub order_size: f64,                      // +0x10 (live)
    pub edge_threshold: f64,                  // +0x20 (live)
    pub target_spread: f64,                   // +0x28 (live, decays)
    pub trade_side: TradeSideMode,            // +0x38 (live)
    // Decorative offsets +0x00, +0x08, +0x18, +0x30, +0x40..0x6f
    // are not part of the replica spec.
}
```

Invariant: `target_spread` is seeded from BotConfig's
`target_spread` at init and subsequently mutated by the decay in
§6. Replicas must treat it as an instance-level field, not a
static config value.

## 3. TradingClient (source: FINAL_AUDIT §9)

```rust
pub struct TradingClient {
    signer: alloy_signer_local::PrivateKeySigner,
    maker: Address,                 // +0x1b8 in original, cached
    nonce: Arc<AtomicU64>,          // +0x1a8 in original
    nonce_store: NonceStore,        // REPLICA-ADDED (see §10)
    http: reqwest::Client,
    fee_cache: DashMap<TokenId, u32>,
}
```

Construction:
1. Load the Ethereum private key from config (path TBD; artifact
   uses an env var + file lookup).
2. Derive the maker address from the signer's public key once.
3. Initialize the nonce atomic from `nonce_store.load()` (see
   §10) — **not** from zero.

## 4. Order construction (source: FINAL_AUDIT §9, §10)

### 4.1 Struct

```rust
#[derive(Serialize)]
pub struct ClobOrder {
    pub salt:          U256,
    pub maker:         Address,
    pub signer:        Address,
    pub taker:         Address, // always zero
    pub tokenId:       U256,
    pub makerAmount:   U256,
    pub takerAmount:   U256,
    pub expiration:    U256,
    pub nonce:         U256,
    pub feeRateBps:    U256,
    pub side:          u8,
    pub signatureType: u8,
}
```

### 4.2 EIP-712 domain

```rust
Eip712Domain {
    name:               Cow::Borrowed("Polymarket CTF Exchange"),
    version:            Some(Cow::Borrowed("1")),
    chain_id:           Some(137u64.into()),
    verifying_contract: Some(
        address!("4bFb41d5B3570DeFd03C39a9A4D8dE6Bd8B8982E")
    ),
    salt: None,
}
```

### 4.3 Construction rules

| Field        | Rule                                                 |
|--------------|------------------------------------------------------|
| salt         | `U256::from_be_bytes(rand::random::<[u8;32]>())`    |
| maker        | `self.maker`                                         |
| signer       | `self.maker` (same)                                  |
| taker        | `Address::ZERO`                                      |
| tokenId      | caller arg                                           |
| makerAmount  | caller arg                                           |
| takerAmount  | caller arg                                           |
| expiration   | `U256::from(now_secs() + EXPIRATION_WINDOW_SECS)`   |
| nonce        | `U256::from(client.next_nonce())`                    |
| feeRateBps   | `U256::from(client.fee_for(tokenId))`               |
| side         | `0` for BUY, `1` for SELL                            |
| signatureType| `0` (EOA ECDSA via `sign_typed_data`)                |

### 4.4 POST

```
POST https://clob.polymarket.com/data/orders
Content-Type: application/json
Authorization: <API credentials, see Polymarket docs>
Body: serde_json::to_string(&SignedOrder { order, signature })
```

If `dry_run` is true, skip the POST and log the signed payload
instead.

## 5. BUY↔SELL pivot (source: §33.1, 0xdc931)

```rust
fn pick_side(net_position: f64, max_position: f64,
             mode: TradeSideMode) -> Option<(Side, f64)> {
    let abs = net_position.abs();
    if abs <= max_position {
        return None; // SKIP: no rebalance needed
    }
    let surplus = abs - max_position;
    let side = if net_position > 0.0 { Side::Sell }
               else                   { Side::Buy  };
    match (mode, side) {
        (TradeSideMode::BuyOnly,  Side::Sell) => None,
        (TradeSideMode::SellOnly, Side::Buy)  => None,
        _ => Some((side, surplus)),
    }
}
```

The surplus value is both (a) clamped to `order_size` for the
clip size and (b) used to feed the `target_spread` decay in §6.

## 6. target_spread urgency decay (source: FINAL_AUDIT §8)

```rust
// On every emit-or-skip iteration where surplus was computed:
spread_cfg.target_spread =
    (spread_cfg.target_spread - surplus).max(0.0);

// Entry gate (0xde541):
let threshold = spread_cfg.edge_threshold
              + spread_cfg.target_spread;
if observed_spread <= threshold {
    return SKIP;
}
```

Behavior: as inventory surplus grows and iterations accumulate,
`target_spread` ramps toward zero, so the bot accepts tighter
observed spreads. This is the urgency ramp.

## 7. 23-state machine (source: FINAL_AUDIT §7)

Minimal faithful subset a replica needs:

| State | Purpose           |
|-------|-------------------|
| 0     | INIT (build client, load book snapshot) |
| 3     | AWAIT book read (RwLock::read, async suspend) |
| 8     | EMIT BUY  (call place_single_order(Side::Buy))  |
| 15    | EMIT SELL (call place_single_order(Side::Sell)) |
| 19    | CANCEL primary  (cancel all open orders)        |
| 22    | CANCEL secondary (cancel stale / far orders)    |

The remaining 17 states are error-recovery and backoff branches.
A replica with a simplified `loop { state = step(state); }`
driver is acceptable for spec validation. The `tokio::select!`
shape of the original is not behaviorally necessary.

## 8. place_single_order (bridge from state machine to order)

```rust
async fn place_single_order(
    client: &TradingClient,
    token_id: TokenId,
    price: f64,
    size: f64,
    side: Side,
    dry_run: bool,
) -> Result<OrderId> {
    let (maker_amount, taker_amount) =
        encode_amounts(side, price, size);
    let order = build_order(client, token_id,
                            maker_amount, taker_amount, side);
    let signed = client.sign(order)?;
    if dry_run {
        log::info!(target: "dry_run", "{:?}", signed);
        return Ok(OrderId::default());
    }
    client.post(signed).await
}
```

## 9. Book snapshot + spread calc (source: FINAL_AUDIT §7)

Standard CLOB REST snapshot. A replica can use the public
Polymarket CLOB API:

```
GET https://clob.polymarket.com/book?token_id=<id>
```

Spread metric used by the gate is
`best_ask - best_bid` in price-units. Keep the snapshot behind
an `Arc<RwLock<BookSnapshot>>` to mirror the original's
`RwLock::read` suspend point at state 3.

## 10. Nonce persistence (REPLICA-ADDED, fixes seller bug)

The artifact keeps nonce in an in-memory atomic only. On
restart it resets to zero, which the CLOB rejects until the
counter climbs past historical highs. The replica must do
better:

```rust
pub struct NonceStore { path: PathBuf }

impl NonceStore {
    pub fn load(&self) -> u64 { /* read file, default 0 */ }
    pub fn record(&self, n: u64) { /* fsync-append max(n, prev) */ }
}

// Wire into TradingClient:
let n = self.nonce.fetch_add(1, Ordering::SeqCst);
self.nonce_store.record(n + 1);
n
```

Persistence cadence: at minimum, fsync on every increment for
correctness; a 1s flush batch is acceptable if crash recovery
logic re-queries CLOB for the last accepted nonce and resumes
from `max(file, cloud) + 1`.

## 11. What the replica deliberately does NOT implement

- `enable_gamble` has no effect. The field is accepted for
  backwards-compat and then ignored.
- HMAC-SHA256 exfil to `gabagool22.com`. Intentionally absent.
- Dashboard / radar client. Out of scope.
- Guardrails beyond `dry_run` and `cancel_orders_on_start` —
  the artifact has none, so the replica has none. Add your own
  at the boundary if you deploy; do not embed them into the
  core engine.

## 12. What the replica cannot recover

- The seller's parameter values (`max_position_size`,
  `order_size`, `edge_threshold`, cooldowns). These were
  delivered in config, not in code.
- The seller's market-selection logic, if any existed at all.
  The artifact reads one market from `current_market`; any
  multi-market selection was done externally (or manually).
- Any meta-strategy around when to run the bot at all.

These are the three things that would constitute a "bot that
makes money" rather than "a generic market-maker quoter." None
of them is in the artifact. This is structural, not a gap.

## 13. Validation plan

Before running the replica against live markets:

1. `cargo check` clean.
2. Replay a recorded order book against the replica in
   `dry_run = true` and assert:
   - Pivot fires only when `|net_pos| > max_pos`.
   - `target_spread` decays monotonically while surplus is
     present.
   - BUY↔SELL direction matches sign of `net_pos`.
   - Emitted orders match the 12-field Polymarket CLOB schema
     with the correct EIP-712 signature.
3. Canary live with tiny `max_position_size` and `order_size`
   on a throwaway market.

Do not skip step 2.
