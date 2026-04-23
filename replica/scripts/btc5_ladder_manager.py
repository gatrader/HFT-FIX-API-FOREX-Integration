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


def working_order_exposure(
    orders: list[WorkingOrder],
    *,
    now_ts: float | None = None,
) -> dict[str, Any]:
    active = (
        prune_expired_orders(orders, now_ts)
        if now_ts is not None
        else [order for order in orders if order.remaining_size > 1e-9]
    )
    by_outcome: dict[str, dict[str, Any]] = {}
    ages: list[float] = []
    for order in active:
        bucket = by_outcome.setdefault(
            order.outcome,
            {
                "count": 0,
                "remainingSize": 0.0,
                "oldestCreatedTimestamp": order.created_timestamp,
                "newestUpdatedTimestamp": order.updated_timestamp,
            },
        )
        bucket["count"] += 1
        bucket["remainingSize"] += order.remaining_size
        bucket["oldestCreatedTimestamp"] = min(bucket["oldestCreatedTimestamp"], order.created_timestamp)
        bucket["newestUpdatedTimestamp"] = max(bucket["newestUpdatedTimestamp"], order.updated_timestamp)
        if now_ts is not None:
            ages.append(max(0.0, now_ts - order.created_timestamp))
    for bucket in by_outcome.values():
        bucket["remainingSize"] = round(bucket["remainingSize"], 6)
        bucket["oldestCreatedTimestamp"] = round(bucket["oldestCreatedTimestamp"], 6)
        bucket["newestUpdatedTimestamp"] = round(bucket["newestUpdatedTimestamp"], 6)
    return {
        "orderCount": len(active),
        "byOutcome": by_outcome,
        "averageOrderAgeSeconds": round(sum(ages) / len(ages), 6) if ages else 0.0,
        "maxOrderAgeSeconds": round(max(ages), 6) if ages else 0.0,
    }


def consume_working_order_fills(
    orders: list[WorkingOrder],
    fills: list[dict[str, Any]],
    *,
    now_ts: float,
) -> list[WorkingOrder]:
    active = prune_expired_orders(orders, now_ts)
    for fill in fills:
        try:
            outcome = str(fill["outcome"])
            remaining = float(fill["size"])
        except (KeyError, TypeError, ValueError):
            continue
        if remaining <= 1e-9:
            continue
        candidates = [
            order
            for order in active
            if order.outcome == outcome and order.remaining_size > 1e-9
        ]
        candidates.sort(key=lambda order: (order.created_timestamp, order.layer, order.price))
        for order in candidates:
            if remaining <= 1e-9:
                break
            matched = min(order.remaining_size, remaining)
            order.remaining_size -= matched
            order.updated_timestamp = now_ts
            remaining -= matched
    return prune_expired_orders(active, now_ts)


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


def reconcile_orders(
    *,
    existing_orders: list[WorkingOrder],
    actions: list[dict[str, Any]],
    now_ts: float,
    ttl_seconds: float,
    cycle_index: int,
    slug: str,
    price_tolerance: float = 0.01,
    size_tolerance: float = 0.01,
) -> tuple[list[WorkingOrder], dict[str, Any]]:
    existing_orders = prune_expired_orders(existing_orders, now_ts)
    target_intents = [ladder_intent_from_action(action) for action in actions]
    unmatched_existing = list(existing_orders)

    next_orders: list[WorkingOrder] = []
    created: list[dict[str, Any]] = []
    amended: list[dict[str, Any]] = []
    preserved: list[dict[str, Any]] = []
    cancelled: list[dict[str, Any]] = []

    def _take_match(intent: LadderIntent) -> WorkingOrder | None:
        exact_index = next(
            (index for index, order in enumerate(unmatched_existing) if order.key == intent.key),
            None,
        )
        if exact_index is not None:
            return unmatched_existing.pop(exact_index)
        reusable_candidates = [
            (index, order)
            for index, order in enumerate(unmatched_existing)
            if order.outcome == intent.outcome and order.mode == intent.mode
        ]
        reusable_candidates.sort(
            key=lambda row: (
                abs(row[1].price - intent.price),
                abs(row[1].size - intent.size),
                row[1].created_timestamp,
            )
        )
        for index, order in reusable_candidates:
            if abs(order.price - intent.price) <= price_tolerance + 1e-9:
                return unmatched_existing.pop(index)
        return None

    for index, intent in enumerate(target_intents, start=1):
        current = _take_match(intent)
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

        changed = (
            abs(current.price - intent.price) > price_tolerance + 1e-9
            or abs(current.size - intent.size) > size_tolerance + 1e-9
            or current.key != intent.key
        )
        current.key = intent.key
        current.layer = intent.layer
        current.price = intent.price
        current.size = intent.size
        current.remaining_size = min(current.remaining_size, intent.size)
        current.updated_timestamp = now_ts
        current.expires_timestamp = now_ts + max(0.0, ttl_seconds)
        next_orders.append(current)
        if changed:
            amended.append(current.to_dict())
        else:
            preserved.append(current.to_dict())

    for order in unmatched_existing:
        cancelled.append(
            {
                "orderId": order.order_id,
                "key": order.key,
                "outcome": order.outcome,
                "mode": order.mode,
                "remainingSize": round(order.remaining_size, 6),
                "price": round(order.price, 6),
                "reason": "not_in_target_ladder",
            }
        )

    next_orders.sort(key=lambda order: (order.outcome, order.mode, order.layer, order.price))
    return next_orders, {
        "created": created,
        "amended": amended,
        "preserved": preserved,
        "cancelled": cancelled,
        "targetSummary": ladder_summary(actions),
    }
