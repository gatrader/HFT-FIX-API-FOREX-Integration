# Pseudo-source reconstruction of the high-value code paths

This directory reconstructs the two code paths that matter for the defensive
finding — the **phone-home exfiltration** and the **CLOB order-signing
pipeline** — as readable pseudo-Rust, cross-referenced to the stripped
disassembly.

**Source of truth**: `bot/bin/arbitrage_bot` (SHA-1 build-id
`0e348a5a11960611219d789b86331c82194f0dbb`, rustc 1.88.0, release, LTO).
Symbols intact, no debug info. Decompilation was by hand from
`objdump -d` + `rustfilt` output — no Ghidra/IDA was available in the
sandbox, so the reconstructions are behaviour-equivalent but not
byte-for-byte source. Offsets in the comments refer to addresses in the
as-built binary and can be re-checked with e.g.

```
objdump -d --start-address=0x91f80 --stop-address=0x920d0 bot/bin/arbitrage_bot | rustfilt
```

## Files

| File | Reconstructs | Asm source |
|---|---|---|
| `phone_home.rs` | `AuthenticationBuilder::send_debug_data` (inlined in `TradingClient::new`) | `phone_home_inlined.asm` |
| `l1_create_headers.rs` | `ClientInner<Unauthenticated>::create_headers` — EIP-712 `ClobAuth` signer for `/auth/api-key` | `l1_create_headers.asm` |
| `l2_create_headers.rs` | `Client<Authenticated>::create_headers` — L2 HMAC headers for every authenticated POST | `l2_create_headers.asm` |
| `auth_to_message.rs` | `polymarket_client_sdk::auth::to_message` — canonical string for HMAC input | `auth_to_message.asm` |
| `auth_hmac.rs` | `polymarket_client_sdk::auth::hmac` — base64-decode secret + HMAC-SHA256 + base64url-encode | `auth_hmac.asm` |
| `post_orders.rs` | `Client<Authenticated>::post_orders` — batch order serialiser + POST | `post_orders.asm` |

All asm files were produced by:

```
objdump -d --no-show-raw-insn --start-address=<addr> --stop-address=<addr> \
  bot/bin/arbitrage_bot | rustfilt > <name>.asm
```

## What this reconstruction *does not* give you

- **Exact source line numbering** — LTO + inlining has fused small helpers
  into their callers; the reconstructions show the observable behaviour,
  not the pre-compilation layout.
- **Private `#[derive]` expansions** — serde/thiserror-derived code is
  summarised rather than transcribed byte-for-byte.
- **Generic monomorphizations beyond the `Normal` auth mode** — the binary
  contains several monomorphs of each `create_headers` (`.3909`, `.4086`,
  `.4114`, `.4240`, `.4299`, `.5574` …). They differ only in the concrete
  K parameter of `Authenticated<K>`; the behaviour shown here is the
  `Authenticated<Normal>` code path that actually runs on trade orders.
