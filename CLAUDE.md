# replica BTC5 engine — operator context for Claude Code

This file is read by Claude Code when started in this repo. It pins
scope, current state, and the default measurement loop so the agent
doesn't drift or reinvent work that already exists.

## Scope — hard rules

- **Engine work only on BTC5.** No other markets, no GUI refactors.
- **Paper / shadow runs only. Never live.** Never pass `--live-ok` to
  any script. A live run requires explicit human approval in writing.
- **GUI (`replica/ops/gui/**`) is frozen except bugfixes.** Do not
  redesign, restyle, or expand it.
- **Prefer measurement + patch loops over discussion.** If you have
  a hypothesis, write code that proves or disproves it against
  recorded data.

## Wallets

- Reference wallet (the one whose behavior we're trying to resemble):
  `0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82`
- Bot wallet:
  `0x31d39De926465dc288948846efc44Bfe64914399`

## What exists on this branch

Active trunk: **`codex/btc5-autoredeem-tooling`**.

Key scripts under `replica/scripts/`:

- `btc5_shadow_reference.py` — shadow recorder. Read-only against
  `data-api.polymarket.com` and `gamma-api.polymarket.com`. No creds
  needed. Subcommands: `record`, `forensics`.
- `run_replica_btc5_accumulator.py` — main accumulator engine. Has
  `decide_actions`, `session_risk_context`, `build_quote_context`,
  `compute_inventory_state`, `run_cycle_actions`.
- `btc5_ladder_manager.py` — ladder primitives. Already has:
  - `reconcile_orders(..., price_tolerance=0.01, size_tolerance=0.01)`
    with fuzzy-match (`_take_match` reuses order IDs when the key
    shifts but the price is within tolerance). **Tolerance defaults
    already act as a 1-tick persistence band.**
  - `working_order_exposure()` — per-outcome remaining size + order
    ages
  - `consume_working_order_fills()` — drain working orders against
    recorded fill events
  - `prune_expired_orders()` — TTL
- `btc5_measurement_pipeline.py` — subcommands `start-recorder`,
  `status`, `refresh`.
- `btc5_measurement_report.py` — dashboard generator.
- `btc5_market_feed.py`, `btc5_private_feed.py` — REST impl + WS
  scaffolds.

What's **not** here (lives on sibling branches if you need the idea):

- Explicit `--projected-exposure-limit-shares` flag — was M1 (branch
  `codex/btc5-milestone1-persistent-ladder`). The concept is still
  valid, but be aware this trunk may eventually gain a cleaner
  implementation with different naming.
- Explicit `--quote-price-band-ticks` flag — was M2 (branch
  `codex/btc5-milestone2-quote-planner`). Note this trunk's
  `price_tolerance=0.01` default already provides ~the same hysteresis.
- Offline replay harness (`btc5_shadow_replay.py`) — was an M2
  follow-up, genuinely useful and orthogonal, worth porting.
- Contextual cancel-reason classifier
  (`target_ladder_empty` / `mode_not_in_target` / etc.) — same M2
  follow-up, worth porting.

**Do not naively cherry-pick from M1/M2.** Names and shapes diverged;
diff before you import anything.

## Engine-shape priorities (from `replica/BTC5_ENGINE_REDESIGN_SPEC.md`)

In priority order:

1. **Stable quote planner.** `decide_actions` currently recomputes
   prices from the current best-bid every cycle. The reconciler's
   `price_tolerance` absorbs single-tick drifts; larger drifts still
   trigger amends. Planner-side anchor memory or price banding at
   the planner level is the next lever.
2. **Persistent per-side ladders across cycles.** `reconcile_orders`
   already supports this; verify it's actually wired into the
   accumulator's `run_cycle_actions` (live path may still call
   `cleanup_cancel_all` per cycle — audit before assuming).
3. **Lower cancel / repost churn.** Track `cancelled%` in shadow
   windows. Target: << current baseline.
4. **Touch-following anchors with hysteresis.** Layered band —
   deeper layers should tolerate more drift than the top touch.
5. **Session-level inventory behavior.** `session_risk_context`
   already exists — verify it's driving phase transitions cleanly.
6. **Paired / risk control.** Outstanding orders must count as real
   risk, not just completed fills.

## Default measurement loop

All commands run from `/home/ubuntu/hft-fix-api-forex-integration`.

```bash
# 1. State check — is there a live recorder?
python3 replica/scripts/btc5_measurement_pipeline.py --generated-dir .generated status
pgrep -fa btc5_shadow_reference || echo "no recorder"
ls -lt .generated | head -20

# 2. Refresh dashboard — always safe, aggregates existing outputs
python3 replica/scripts/btc5_measurement_pipeline.py --generated-dir .generated refresh --forensics-hours 24

# 3. Read the latest dashboard JSON
ls -t .generated/btc5-measurement-dashboard.*.json | head -1 | xargs python3 -m json.tool | head -60

# 4. Start a 30–60 min recorder for fresh data
#    (but do not start one if pgrep already shows one running)
python3 replica/scripts/btc5_measurement_pipeline.py --generated-dir .generated \
    start-recorder --duration-minutes 60 --poll-seconds 1
```

## Metrics to track

From spec §"Metrics To Track" and §"Acceptance Criteria":

- **Reconciliation mix**: `preserved%` (target ≫ 50%), `amended%`,
  `created%`, `cancelled%`.
- **Action tempo**: `shadowActionsMedian`, `shadowActionCount`
  per window, `firstActionSecond` / `lastActionSecond`.
- **Fill proxy**: `shadowFillCount`, `shadowFillRate`,
  `highActivityZeroFillWindows` in the dashboard JSON.
- **Exposure and residuals**: `residualQty`, `workingOrderCount` by
  outcome, average/max order age, outstanding-side exposure.
- **Session shape**: how close trade tempo + touch residency match
  the reference wallet forensics
  (`reference_wallet_vs_bot_forensics_*.json`).

## Honest limits

- **The shadow fill heuristic is queue-unaware.** A paper order
  counts filled when a reference trade prints at or through our
  quoted price. If the reference wallet is a persistent maker sitting
  in queue ahead of us, a reference trade does not mean *we* would
  have filled.
- **Exact trade-for-trade matching against the reference wallet is
  blocked** by hidden queue position + private cancels we cannot
  observe publicly. Do not optimize for that.
- **Achievable targets**: closer trade tempo, touch residency,
  paired size, residual control, session shape.

## Git hygiene

- Commit messages: describe why + measurement context, not just
  what. Include before/after numbers when reporting an engine
  change.
- Do not force-push anything.
- Never commit `.generated/` contents (they're large and
  time-sensitive; kept out via `.gitignore`).
- Before opening a PR from a working branch to `main`, confirm the
  commit touches only BTC5 engine files unless the user has
  explicitly asked for something broader.

## Checkpoint format

At each checkpoint, summarize:
1. What changed (code).
2. What improved (measured).
3. What still blocks live (honest list).
4. What you are trying next.

Mirrors the spec's acceptance-criteria rhythm.
