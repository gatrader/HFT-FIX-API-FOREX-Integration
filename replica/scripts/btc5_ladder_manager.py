from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any


@dataclass(frozen=True)
class LadderIntent:
    key: str
    outcome: str
    mode: str
    layer: int
    price: float
    size: float

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass
class WorkingOrder:
    order_id: str
    key: str
    outcome: str
    mode: str
    layer: int
    price: float
    size: float
    remaining_size: float
    created_timestamp: float
    updated_timestamp: float
    expires_timestamp: float

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


def ladder_intent_from_action(action: dict[str, Any]) -> LadderIntent:
    outcome = str(action["outcome"])
    mode = str(action.get("mode") or "")
    layer = int(action.get("layer") or 0)
    key = f"{outcome}:{mode}:{layer}"
    return LadderIntent(
        key=key,
        outcome=outcome,
        mode=mode,
        layer=layer,
        price=float(action["quotedPrice"]),
        size=float(action["size"]),
    )


def ladder_summary(actions: list[dict[str, Any]]) -> dict[str, Any]:
    intents = [ladder_intent_from_action(action) for action in actions]
    by_outcome: dict[str, dict[str, Any]] = {}
    for intent in intents:
        bucket = by_outcome.setdefault(
            intent.outcome,
            {
                "count": 0,
                "totalSize": 0.0,
                "modes": {},
            },
        )
        bucket["count"] += 1
        bucket["totalSize"] += intent.size
        bucket["modes"][intent.mode] = bucket["modes"].get(intent.mode, 0) + 1
    for bucket in by_outcome.values():
        bucket["totalSize"] = round(bucket["totalSize"], 6)
    return {
        "intents": [intent.to_dict() for intent in intents],
        "byOutcome": by_outcome,
    }


def prune_expired_orders(orders: list[WorkingOrder], now_ts: float) -> list[WorkingOrder]:
    return [
        order
        for order in orders
        if order.remaining_size > 1e-9 and order.expires_timestamp >= now_ts
    ]


def compute_outstanding_exposure(
    orders: list[WorkingOrder],
) -> dict[str, float]:
    """Sum remaining_size per outcome across working orders.

    Returns a dict with at least ``Up`` and ``Down`` keys so callers
    can rely on shape without branching. An empty working-orders list
    returns zeros, not missing keys.
    """
    exposure: dict[str, float] = {"Up": 0.0, "Down": 0.0}
    for order in orders:
        exposure[order.outcome] = (
            exposure.get(order.outcome, 0.0) + float(order.remaining_size)
        )
    return exposure


def project_residual_if_all_fill(
    *,
    filled_up: float,
    filled_down: float,
    outstanding_up: float,
    outstanding_down: float,
) -> tuple[str | None, float]:
    """Residual side + qty if every outstanding order fills.

    The spec treats outstanding orders as real risk: this pair shape
    makes that risk first-class. Used both as a pre-submit gate
    (``decide_actions`` exposure clip) and as a cycle-level metric
    (``projectedResidual`` in shadow output).
    """
    projected_up = max(0.0, float(filled_up) + float(outstanding_up))
    projected_down = max(0.0, float(filled_down) + float(outstanding_down))
    if projected_up > projected_down + 1e-9:
        return ("Up", projected_up - projected_down)
    if projected_down > projected_up + 1e-9:
        return ("Down", projected_down - projected_up)
    return (None, 0.0)


def reconcile_orders(
    *,
    existing_orders: list[WorkingOrder],
    actions: list[dict[str, Any]],
    now_ts: float,
    ttl_seconds: float,
    cycle_index: int,
    slug: str,
    price_band: float = 0.0,
    size_band: float = 0.0,
) -> tuple[list[WorkingOrder], dict[str, Any]]:
    """Diff working orders against target intents.

    ``price_band`` / ``size_band`` are hysteresis tolerances. When the
    incoming intent drifts within this band of the current order,
    that order is classified as ``preserved`` and its price / size are
    not updated — this is what keeps queue position across cycles.
    Outside the band the order is ``amended``: price / size rewritten
    to the new intent values so subsequent cycles re-align.

    Milestone 2 — the reconciler's amended-vs-preserved decision is
    now the knob that controls ladder stability, not a hard-coded
    1e-9 exact match.
    """
    existing_orders = prune_expired_orders(existing_orders, now_ts)
    existing_by_key = {order.key: order for order in existing_orders}
    target_intents = [ladder_intent_from_action(action) for action in actions]

    next_orders: list[WorkingOrder] = []
    created: list[dict[str, Any]] = []
    amended: list[dict[str, Any]] = []
    preserved: list[dict[str, Any]] = []
    cancelled: list[dict[str, Any]] = []

    target_keys = {intent.key for intent in target_intents}
    # Milestone 2b — contextualize cancels so the measurement report
    # can distinguish "planner produced no targets this cycle"
    # (likely a phase transition or mode flip) from "planner kept
    # targets on the other side but not this specific key" (likely
    # a layer-depth adjustment or inventory skew). Raw
    # "not_in_target_ladder" lumped all those together and hid the
    # real churn driver.
    target_modes = {intent.mode for intent in target_intents}
    target_outcomes_in_mode: dict[str, set[str]] = {}
    for intent in target_intents:
        target_outcomes_in_mode.setdefault(intent.mode, set()).add(intent.outcome)
    empty_target = not target_intents
    for order in existing_orders:
        if order.key not in target_keys:
            if empty_target:
                reason = "target_ladder_empty"
            elif order.mode not in target_modes:
                # The whole class of orders (e.g. "paired") vanished
                # from target — strategy mode flipped (paired→flatten
                # or paired→rebalance).
                reason = "mode_not_in_target"
            elif order.outcome not in target_outcomes_in_mode.get(order.mode, set()):
                reason = "outcome_dropped_in_mode"
            else:
                # Same mode + outcome present, but this specific
                # layer key isn't — layer depth changed.
                reason = "layer_dropped"
            cancelled.append(
                {
                    "orderId": order.order_id,
                    "key": order.key,
                    "outcome": order.outcome,
                    "mode": order.mode,
                    "remainingSize": round(order.remaining_size, 6),
                    "price": round(order.price, 6),
                    "reason": reason,
                }
            )

    for index, intent in enumerate(target_intents, start=1):
        current = existing_by_key.get(intent.key)
        if current is None:
            new_order = WorkingOrder(
                order_id=f"{slug}.c{cycle_index:03d}.o{index:02d}",
                key=intent.key,
                outcome=intent.outcome,
                mode=intent.mode,
                layer=intent.layer,
                price=intent.price,
                size=intent.size,
                remaining_size=intent.size,
                created_timestamp=now_ts,
                updated_timestamp=now_ts,
                expires_timestamp=now_ts + max(0.0, ttl_seconds),
            )
            next_orders.append(new_order)
            created.append(new_order.to_dict())
            continue

        price_drift = abs(current.price - intent.price)
        size_drift = abs(current.size - intent.size)
        price_eff_band = max(1e-9, float(price_band))
        size_eff_band = max(1e-9, float(size_band))
        # Preserved when the incoming intent drifted INSIDE the band.
        # Both price and size must fit in the band — otherwise we
        # have to re-anchor and it's an amend. Tolerance epsilon
        # absorbs the IEEE-754 noise from 0.51-0.50 ≠ 0.01 exactly.
        cmp_eps = 1e-9
        preserve = (
            price_drift <= price_eff_band + cmp_eps
            and size_drift <= size_eff_band + cmp_eps
        )
        anchor_residency = {
            "priceDrift": round(price_drift, 6),
            "sizeDrift": round(size_drift, 6),
            "priceBand": round(float(price_band), 6),
            "sizeBand": round(float(size_band), 6),
        }
        if preserve:
            # Do NOT rewrite price/size — preserving queue position
            # is the whole point of the band. Refresh TTL so target
            # orders don't age out mid-session.
            current.remaining_size = min(current.remaining_size, current.size)
            current.updated_timestamp = now_ts
            current.expires_timestamp = now_ts + max(0.0, ttl_seconds)
            next_orders.append(current)
            preserved.append({**current.to_dict(), **anchor_residency})
        else:
            current.price = intent.price
            current.size = intent.size
            current.remaining_size = min(current.remaining_size, intent.size)
            current.updated_timestamp = now_ts
            current.expires_timestamp = now_ts + max(0.0, ttl_seconds)
            next_orders.append(current)
            amended.append({**current.to_dict(), **anchor_residency})

    next_orders.sort(key=lambda order: (order.outcome, order.mode, order.layer, order.price))
    cancel_reason_counts: dict[str, int] = {}
    for row in cancelled:
        r = row.get("reason") or "unknown"
        cancel_reason_counts[r] = cancel_reason_counts.get(r, 0) + 1
    return next_orders, {
        "created": created,
        "amended": amended,
        "preserved": preserved,
        "cancelled": cancelled,
        "cancelReasonCounts": cancel_reason_counts,
        "targetSummary": ladder_summary(actions),
        "bands": {
            "priceBand": round(float(price_band), 6),
            "sizeBand": round(float(size_band), 6),
        },
    }
