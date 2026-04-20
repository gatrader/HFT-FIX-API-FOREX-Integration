# EC2 A/B Benchmark Recipe — PR 4 (queued) vs. PR 3 (inline)

Purpose: produce a two-column table of the 10 metrics the hot-path
budget depends on, collected under the same market conditions, so we
can answer:

  - does the queued path preserve tick cadence better than inline
    under real RTT?
  - does `queue_depth` stay low and `queue_full_drops` stay zero in
    normal operation?
  - is `body_ms` tail now the dominant remaining cost (→ detached
    body drain is the next PR) or is something else the bottleneck?

The two arms differ in exactly one flag (`--inline-submit`). Everything
else — build, config, workload, duration, env — is identical.

---

## 1. Release build

From the `replica/` directory on the EC2 host (same host that will run
live):

```bash
cargo build --release --features ws
```

Binary: `./target/release/arbigab-replica`.

Do NOT rebuild between arms — both arms run the same binary. This
removes compiler noise from the comparison.

## 2. Shared workload env

Export once per shell (or put in a `.envrc`):

```bash
export POLYMARKET_PRIVATE_KEY="0x…"          # same key for both arms
export RUST_LOG="runtime_tick=info,hotpath=info,runtime=info"
export RUNTIME_LOG_JSON=1                    # structured JSONL output
```

Shared runtime flags (same for both arms — pick once, reuse):

```bash
COMMON_ARGS=(
  --key "$POLYMARKET_PRIVATE_KEY"
  runtime
  --config           ./config/your-market.toml
  --token-id         "$TOKEN_ID"
  --net-position     0
  --fee-rate-bps     0
  --tick-interval-ms 150
  --book-max-age-ms  1000
  --dedup-window-ms  500
  --submit-budget-per-sec 5
  --price-bucket     0.001
  --size-bucket      1
  --duration-secs    300
  --submit-queue-capacity 32
  --realtime
)
```

## 3. A/B invocation pair

Arm A — inline submit (PR 3 path, decision tick blocks on HTTP):

```bash
./target/release/arbigab-replica "${COMMON_ARGS[@]}" \
    --inline-submit \
    2> bench/arm_a_inline.jsonl
```

Arm B — queued submit (PR 4 path, tick enqueues, worker drains):

```bash
./target/release/arbigab-replica "${COMMON_ARGS[@]}" \
    2> bench/arm_b_queued.jsonl
```

Notes:
  - `tracing-subscriber` writes to stderr, so the 2> redirect is what
    captures the JSONL. stdout stays free.
  - `RUNTIME_LOG_JSON=1` switches the subscriber to `.json()` with
    flattened events (one JSON object per line, keyed by `target`,
    `message`, and the event fields).
  - Run the arms **back-to-back in quick succession** (same wall-clock
    market regime). If the market moves materially between them,
    re-run; otherwise inline vs. queued is comparing apples and
    oranges.
  - `--duration-secs 300` gives enough samples for percentile tails
    without risking a long live session. Raise if you want cleaner
    p99s.

## 4. Post-process into an A/B table

```bash
python3 bench/parse.py bench/arm_a_inline.jsonl bench/arm_b_queued.jsonl
```

Prints a two-column table:

```
metric                   arm_a_inline    arm_b_queued
tick_count               …               …
observed_tick_us p50/p99 …               …
book_age_ms p50/p99      …               …
queue_depth mean/max     n/a             …
queue_full_drops total   0               …
last_queue_wait_us p50/p99 n/a           …
last_http_submit_us p50/p99 n/a          …
submit_ms p50/p99        …               …
body_ms p50/p99          …               …
ws_fallback_to_rest      …               …
```

For inline mode, `queue_*` and `last_http_submit_us` stay at their
defaults (the tick path doesn't enqueue) — the parser prints "n/a".

## 5. Expected signals

  - **tick_us p99 (queued) ≈ 150 000 us; tick_us p99 (inline)
    grows with RTT.** This is the whole point of PR 4.
  - **queue_depth mean ≤ 1, max small.** If mean drifts up, the
    submit side cannot keep up with the enqueue side — investigate
    before trusting the rest.
  - **queue_full_drops = 0 in normal operation.** Non-zero → the
    budget gate is not the effective bottleneck and ticks are
    attempting to enqueue faster than the worker drains. Raise
    capacity only after confirming it's not a real problem.
  - **body_ms p99 as a fraction of total.** If `body_ms` is the
    dominant tail, the next PR is detached-body-drain (return after
    headers, drain on a task), NOT the Gamma scaffold.

## 6. Rollback

If the queued path misbehaves, rollback is one flag — just add
`--inline-submit` and the tick-blocks-on-HTTP path from PR 3 is back.
No code change required.
