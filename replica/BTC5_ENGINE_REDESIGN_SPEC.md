# BTC5 Engine Redesign Spec

## Goal

Move the BTC5 engine away from cycle-local "pair/rebalance and cancel everything" behavior and toward a session-based maker engine that behaves more like the reference wallet.

This redesign is for paper/shadow validation first. Do not scale live usage until the new engine shape proves it can:

- keep larger paired inventory on the book
- reduce residual/orphan exposure
- maintain more persistent quotes
- generate more plausible fills in shadow mode

## Why The Current Engine Falls Short

The current engine in `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\run_replica_btc5_accumulator.py` already has:

- hybrid arb + maker logic
- residual brakes
- late-session guards
- inventory skew
- maker ladders

But the overnight measurement still shows a structural mismatch:

- reference wallet trade tempo is high
- our shadow engine can emit many actions
- our shadow engine still gets very few plausible fills

This strongly suggests the main problem is not just thresholds. The main problem is engine shape:

- too much cancel/repost behavior
- not enough persistent queue position
- not enough session-level exposure accounting
- not enough distinction between filled exposure and outstanding exposure

## Target Engine Shape

The redesigned engine should behave like a session manager with four cooperating pieces:

1. `SessionState`
2. `QuotePlanner`
3. `RiskManager`
4. `OrderManager`

### SessionState

Tracks the whole 5-minute market as one evolving session.

Required fields:

- event slug
- market start / end
- filled `Up` qty / avg
- filled `Down` qty / avg
- working `Up` order ladder
- working `Down` order ladder
- outstanding `Up` size
- outstanding `Down` size
- paired qty
- filled residual side / qty
- projected residual if all live orders fill
- last fill timestamp
- current phase: `early`, `mid`, `late`, `flatten`

### QuotePlanner

Produces target ladders, not one-shot actions.

It should output:

- target `Up` ladder
- target `Down` ladder
- target aggressiveness / skew
- reason code explaining the current mode

Planner rules:

- early window: allow paired maker quoting while near flat
- mid window: allow paired maker only if residual is small
- late window: prioritize the lagging side
- flatten window: no fresh paired expansion, only flatten-biased quoting

### RiskManager

Approves or clips the planner output before orders are sent.

It must account for:

- filled residual
- outstanding same-side exposure
- projected post-fill residual
- residual as a ratio of paired inventory
- time left in the market

The key change is:

Outstanding orders must count as risk, not just completed fills.

### OrderManager

Reconciles current working orders to the target ladder.

It should:

- keep orders live if still acceptable
- amend price or size only when materially stale
- cancel only the orders that are wrong
- avoid full cancel-all per cycle

This is the mechanism that preserves queue position.

## Core Behavior Changes

### 1. Persistent Per-Side Ladders

Use the ladder manager model already started in:

- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\btc5_ladder_manager.py`

The live engine should maintain:

- one managed `Up` ladder
- one managed `Down` ladder

Each cycle should reconcile to target state instead of recreating everything.

### 2. Projected Residual Limits

Before adding a new order, compute:

- current filled residual
- projected residual if this order fills
- projected residual if all current same-side orders fill

Block or clip new orders if projected residual exceeds:

- one clip
- or a configured fraction of paired inventory

### 3. Inventory-Skewed Quoting

If `Up` is ahead:

- quote `Up` less aggressively
- quote `Down` more aggressively

If `Down` is ahead:

- do the reverse

The planner should not just stop. It should steer.

### 4. Time-State Modes

Define the window as four phases:

#### Early

- paired maker allowed
- moderate aggression
- wider quote budget allowed only while near flat

#### Mid

- paired maker allowed only if residual is small
- otherwise skew toward lagging side

#### Late

- no new paired expansion once residual is meaningful
- rebalance-first behavior

#### Flatten

- last 60 to 90 seconds
- no new paired expansion
- only flatten-biased or lagging-side quotes

### 5. Quote Aging Rules

To avoid losing queue position, only amend when necessary.

Suggested rules:

- keep order if price is within one tick of target and size is still valid
- amend when price deviates by more than one tick
- cancel if order is on the wrong side of current risk budget
- expire old orders only after a configurable age threshold

## Minimum File Changes

Primary implementation target:

- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\run_replica_btc5_accumulator.py`

Supporting files:

- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\btc5_ladder_manager.py`
- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\btc5_shadow_reference.py`
- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\btc5_market_feed.py`
- `C:\Users\gadil\Documents\New project\github_publish\replica\scripts\btc5_private_feed.py`

Implementation order:

1. extend ladder manager so it can represent target ladders and working ladders for live use
2. refactor accumulator decision logic into planner + risk + reconciliation steps
3. mirror the same behavior in shadow mode
4. compare new shadow outputs against the reference wallet before any live expansion

## Acceptance Criteria

The redesign is successful only if shadow mode improves on these dimensions:

- higher plausible fill count
- fewer full ladder resets
- longer average order lifetime
- larger paired qty
- smaller residual qty
- better residual ratio
- closer timing pattern to the reference wallet

Success is not:

- exact trade-for-trade matching
- more actions by themselves
- lower thresholds by themselves

## Metrics To Track

Add these metrics to the shadow and measurement outputs:

- working order count by side
- average order lifetime
- reconcile operations per cycle: created / amended / cancelled / kept
- outstanding exposure by side
- projected residual by cycle
- filled residual by cycle
- paired qty by cycle
- first action second in window
- last action second in window

## Non-Goals

Do not spend time on these until the engine shape improves:

- bigger live budget
- GUI redesign
- exact cloning of the reference wallet
- heavy websocket migration before the persistent ladder logic exists

WebSockets are still desirable, but only after the engine can manage a persistent book correctly.

## Immediate Next Step

Implement persistent ladder reconciliation inside `run_replica_btc5_accumulator.py`, then validate the same behavior in `btc5_shadow_reference.py` over one-hour paper runs.
