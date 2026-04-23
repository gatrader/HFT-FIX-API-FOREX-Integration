from __future__ import annotations

import argparse
import json
import math
import os
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import requests

from btc5_ladder_manager import (
    WorkingOrder,
    compute_outstanding_exposure,
    ladder_summary,
    project_residual_if_all_fill,
    reconcile_orders,
)
from btc5_market_feed import RestPollingMarketFeed
from resolve_next_btc5 import resolve
from run_replica_btc5_paired import (
    DEFAULT_FUNDER,
    DEFAULT_ROOT,
    DEFAULT_SRC_BIN,
    DEFAULT_SRC_CREDS,
    BookQuote,
    bootstrap_creds,
    canary_submit,
    cleanup_cancel_all,
    ensure_binary,
    fetch_book,
    normalize_env_value,
    parse_levels,
    plan_leg,
    require_env,
    seconds_left,
    wait_for_market_open,
    write_json,
)


TRADES_URL = "https://data-api.polymarket.com/trades"
ORDER_SIZE_STEP = 0.01
VENUE_MIN_ORDER_SHARES = 5.0
ORDER_SIZE_DECIMALS = 2


@dataclass(frozen=True)
class FillRecord:
    outcome: str
    side: str
    size: float
    price: float
    timestamp: int
    transaction_hash: str


@dataclass
class InventoryState:
    up_qty: float = 0.0
    up_cost: float = 0.0
    down_qty: float = 0.0
    down_cost: float = 0.0
    trade_count: int = 0
    last_fill_timestamp: int | None = None

    @property
    def up_avg(self) -> float | None:
        if self.up_qty <= 0:
            return None
        return self.up_cost / self.up_qty

    @property
    def down_avg(self) -> float | None:
        if self.down_qty <= 0:
            return None
        return self.down_cost / self.down_qty

    @property
    def paired_qty(self) -> float:
        return min(self.up_qty, self.down_qty)

    @property
    def residual_qty(self) -> float:
        return abs(self.up_qty - self.down_qty)

    @property
    def residual_side(self) -> str | None:
        if self.up_qty > self.down_qty:
            return "Up"
        if self.down_qty > self.up_qty:
            return "Down"
        return None

    @property
    def paired_avg_cost(self) -> float | None:
        if self.paired_qty <= 0:
            return None
        if self.up_avg is None or self.down_avg is None:
            return None
        return self.up_avg + self.down_avg

    def to_dict(self) -> dict[str, Any]:
        return {
            "upQty": round(self.up_qty, 6),
            "upCost": round(self.up_cost, 6),
            "upAvg": None if self.up_avg is None else round(self.up_avg, 6),
            "downQty": round(self.down_qty, 6),
            "downCost": round(self.down_cost, 6),
            "downAvg": None if self.down_avg is None else round(self.down_avg, 6),
            "pairedQty": round(self.paired_qty, 6),
            "pairedAvgCost": None
            if self.paired_avg_cost is None
            else round(self.paired_avg_cost, 6),
            "residualQty": round(self.residual_qty, 6),
            "residualSide": self.residual_side,
            "tradeCount": self.trade_count,
            "lastFillTimestamp": self.last_fill_timestamp,
        }


def round_up_shares(
    value: float,
    step: float = ORDER_SIZE_STEP,
    decimals: int = ORDER_SIZE_DECIMALS,
) -> float:
    if value <= 0:
        return 0.0
    units = math.ceil(value / step - 1e-9)
    return round(units * step, decimals)


def residual_ratio(state: InventoryState, *, clip_shares: float) -> float:
    base = max(state.paired_qty, clip_shares, ORDER_SIZE_STEP)
    return state.residual_qty / base


def event_total_seconds(event: dict[str, Any]) -> int | None:
    try:
        start_ts = datetime.fromisoformat(str(event["startDate"]).replace("Z", "+00:00")).timestamp()
        end_ts = datetime.fromisoformat(str(event["endDate"]).replace("Z", "+00:00")).timestamp()
    except (KeyError, TypeError, ValueError):
        return None
    return max(0, int(round(end_ts - start_ts)))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Maker-style BTC5 rolling accumulator: quote both outcomes on the bid, "
            "track rolling fill cost, and cap residual imbalance while the market is live."
        )
    )
    parser.add_argument("--root", default=DEFAULT_ROOT, help="Clean-room root on AWS.")
    parser.add_argument("--which", choices=("current", "next"), default="current")
    parser.add_argument("--lookahead-windows", type=int, default=6)
    parser.add_argument("--watch-seconds", type=int, default=240)
    parser.add_argument(
        "--residual-watch-seconds",
        type=int,
        default=120,
        help=(
            "If a live fill creates residual inventory, keep watching this many extra "
            "seconds for a later same-session rebalance opportunity, capped by market end."
        ),
    )
    parser.add_argument("--poll-seconds", type=float, default=1.0)
    parser.add_argument("--rest-seconds", type=float, default=1.25)
    parser.add_argument("--clip-shares", type=float, default=5.0)
    parser.add_argument(
        "--max-clip-shares",
        type=float,
        default=10.0,
        help="Do not scale a clip above this share count to satisfy minimum notional.",
    )
    parser.add_argument(
        "--maker-layers",
        type=int,
        default=3,
        help="Number of deeper market-making layers to quote around the current bid on each side.",
    )
    parser.add_argument(
        "--maker-price-step",
        type=float,
        default=0.01,
        help="Price step between deeper market-making layers.",
    )
    parser.add_argument(
        "--maker-pair-threshold",
        type=float,
        default=1.02,
        help="Allow deeper paired maker quotes while the combined bid stays at or below this value.",
    )
    parser.add_argument(
        "--maker-layer-size-ratio",
        type=float,
        default=0.5,
        help="Each deeper maker layer uses this share multiple of the base clip size before notional checks.",
    )
    parser.add_argument(
        "--max-actions-per-cycle",
        type=int,
        default=6,
        help="Cap the total number of order actions emitted in one cycle.",
    )
    parser.add_argument(
        "--entry-threshold",
        type=float,
        default=0.98,
        help="Quote both sides only if the quoted Up+Down bid pair stays at or below this value.",
    )
    parser.add_argument(
        "--rebalance-threshold",
        type=float,
        default=0.98,
        help="When one side lags, quote only the lagging side if its bid plus the leading side's avg fill stays at or below this value.",
    )
    parser.add_argument(
        "--max-residual-shares",
        type=float,
        default=5.0,
        help="Stop adding fresh two-sided exposure once the residual imbalance reaches this size.",
    )
    parser.add_argument(
        "--late-session-residual-seconds",
        type=int,
        default=90,
        help=(
            "Once this many or fewer seconds remain, do not open fresh paired clips if "
            "an existing residual already exceeds the late-session threshold."
        ),
    )
    parser.add_argument(
        "--late-session-residual-threshold",
        type=float,
        default=1.0,
        help=(
            "Residual size that triggers the late-session safety brake for fresh paired clips."
        ),
    )
    parser.add_argument(
        "--session-residual-stop-shares",
        type=float,
        default=5.0,
        help=(
            "If residual inventory reaches this size at any point in the session, stop "
            "opening fresh paired clips until the lagging side catches up."
        ),
    )
    parser.add_argument(
        "--session-residual-stop-ratio",
        type=float,
        default=0.25,
        help=(
            "If residual inventory grows beyond this fraction of paired inventory, stop "
            "opening fresh paired clips and only work the lagging side."
        ),
    )
    parser.add_argument(
        "--inventory-skew-step",
        type=float,
        default=0.01,
        help=(
            "When one side is ahead, shade quotes away from the leading side and toward "
            "the lagging side by this price step."
        ),
    )
    parser.add_argument(
        "--inventory-skew-trigger-shares",
        type=float,
        default=5.0,
        help=(
            "Do not apply inventory-skewed quoting until the residual reaches this size."
        ),
    )
    parser.add_argument(
        "--early-session-seconds",
        type=int,
        default=120,
        help=(
            "During the first part of the 5-minute window, allow a larger paired maker "
            "budget if inventory is still nearly flat."
        ),
    )
    parser.add_argument(
        "--early-session-flat-residual-threshold",
        type=float,
        default=1.0,
        help=(
            "Only enable early-session aggression while residual inventory stays at or "
            "below this size."
        ),
    )
    parser.add_argument(
        "--early-session-pair-budget",
        type=float,
        default=20.0,
        help=(
            "Per-outcome session budget for fresh paired quoting during the early flat part "
            "of the window."
        ),
    )
    parser.add_argument(
        "--early-session-max-actions",
        type=int,
        default=8,
        help=(
            "Allow up to this many order actions per cycle during the early flat part of "
            "the window."
        ),
    )
    parser.add_argument(
        "--min-seconds-left",
        type=int,
        default=30,
        help="Do not place fresh orders once fewer than this many seconds remain before market end.",
    )
    parser.add_argument(
        "--open-wait-buffer-seconds",
        type=int,
        default=5,
        help="When targeting the next market, wait this many extra seconds after open.",
    )
    parser.add_argument(
        "--bid-improve",
        type=float,
        default=0.0,
        help="Optional positive improvement to add above the current best bid when quoting.",
    )
    parser.add_argument(
        "--depth-band",
        type=float,
        default=0.02,
        help="Price band below the best bid used for cumulative bid-depth checks.",
    )
    parser.add_argument(
        "--min-depth-ratio",
        type=float,
        default=1.5,
        help="Require cumulative bid depth within the band to cover this multiple of clip size.",
    )
    parser.add_argument(
        "--min-best-level-ratio",
        type=float,
        default=0.5,
        help="Require the top bid level itself to cover at least this multiple of clip size.",
    )
    parser.add_argument(
        "--min-order-notional",
        type=float,
        default=1.0,
        help="Minimum dollar notional per submitted order leg.",
    )
    parser.add_argument(
        "--wallet-address",
        default="",
        help="Wallet to track for fills. Defaults to POLYMARKET_FUNDER or the clean-room default funder.",
    )
    parser.add_argument(
        "--symbol-prefix",
        default="btc5-accumulator",
        help="Symbol prefix used when writing generated configs.",
    )
    parser.add_argument(
        "--output-dir",
        default="generated",
        help="Directory inside the clean room for configs, logs, and summaries.",
    )
    parser.add_argument(
        "--live-ok",
        action="store_true",
        help="Actually place live orders. Omit for a dry-run forensic pass.",
    )
    # Milestone 1 — persistent-ladder + exposure-as-risk flags.
    # Both default off so existing behavior is preserved; validation
    # is done in paper/shadow mode (btc5_shadow_reference.py) first.
    parser.add_argument(
        "--persistent-ladder",
        action="store_true",
        help=(
            "Skip per-cycle cleanup_cancel_all and reconcile the working "
            "ladder against the target ladder instead. Preserves queue "
            "position for orders still in the target set."
        ),
    )
    parser.add_argument(
        "--ladder-ttl-seconds",
        type=float,
        default=30.0,
        help=(
            "Target-ladder TTL used by reconcile_orders when "
            "--persistent-ladder is on. Longer TTL = longer average "
            "order lifetime = more queue persistence."
        ),
    )
    parser.add_argument(
        "--projected-exposure-limit-shares",
        type=float,
        default=0.0,
        help=(
            "If > 0, clip any new order that would push projected "
            "post-fill residual (filled + all outstanding) past this "
            "many shares. 0 disables the check (current behavior)."
        ),
    )
    return parser


def fetch_json(url: str, *, params: dict[str, Any]) -> Any:
    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    return response.json()


def quote_price_from_bid(bid: BookQuote, improve: float) -> float:
    return round(min(0.99, max(0.01, bid.price + max(0.0, improve))), 6)


def bid_depth_within_band(book: dict[str, Any], band: float) -> dict[str, float] | None:
    bids = parse_levels(book.get("bids", []))
    if not bids:
        return None
    best = max(level.price for level in bids)
    min_price = max(0.0, best - max(0.0, band))
    cumulative = sum(level.size for level in bids if level.price >= min_price - 1e-9)
    return {
        "bestPrice": best,
        "minPrice": min_price,
        "cumulativeSize": cumulative,
    }


def best_bid(book: dict[str, Any]) -> BookQuote | None:
    bids = parse_levels(book.get("bids", []))
    if not bids:
        return None
    price = max(level.price for level in bids)
    size = sum(level.size for level in bids if abs(level.price - price) < 1e-9)
    return BookQuote(price=price, size=size)


def fetch_wallet_trades(
    *,
    wallet: str,
    slug: str,
    since_timestamp: int,
    max_pages: int = 4,
    page_size: int = 500,
) -> list[FillRecord]:
    seen_hashes: set[str] = set()
    fills: list[FillRecord] = []
    offset = 0
    for _ in range(max_pages):
        payload = fetch_json(
            TRADES_URL,
            params={
                "user": wallet,
                "limit": page_size,
                "offset": offset,
                "takerOnly": "false",
            },
        )
        if not isinstance(payload, list) or not payload:
            break
        found_relevant = False
        for row in payload:
            try:
                row_slug = str(row.get("slug") or row.get("eventSlug") or "")
                timestamp = int(row["timestamp"])
                side = str(row.get("side") or "")
                outcome = str(row.get("outcome") or "")
                size = float(row["size"])
                price = float(row["price"])
                tx_hash = str(row.get("transactionHash") or f"{timestamp}:{outcome}:{size}:{price}")
            except (KeyError, TypeError, ValueError):
                continue
            if row_slug != slug or timestamp < since_timestamp or side != "BUY":
                continue
            found_relevant = True
            if tx_hash in seen_hashes:
                continue
            seen_hashes.add(tx_hash)
            fills.append(
                FillRecord(
                    outcome=outcome,
                    side=side,
                    size=size,
                    price=price,
                    timestamp=timestamp,
                    transaction_hash=tx_hash,
                )
            )
        if len(payload) < page_size:
            break
        if not found_relevant:
            oldest_timestamp = min(
                int(row.get("timestamp") or 0) for row in payload if row.get("timestamp") is not None
            )
            if oldest_timestamp and oldest_timestamp < since_timestamp:
                break
        offset += page_size
    fills.sort(key=lambda row: (row.timestamp, row.transaction_hash))
    return fills


def compute_inventory_state(fills: list[FillRecord]) -> InventoryState:
    state = InventoryState()
    for fill in fills:
        if fill.outcome == "Up":
            state.up_qty += fill.size
            state.up_cost += fill.size * fill.price
        elif fill.outcome == "Down":
            state.down_qty += fill.size
            state.down_cost += fill.size * fill.price
        else:
            continue
        state.trade_count += 1
        state.last_fill_timestamp = fill.timestamp
    return state


def merge_fills(public_fills: list[FillRecord], inferred_fills: list[FillRecord]) -> list[FillRecord]:
    by_hash: dict[str, FillRecord] = {fill.transaction_hash: fill for fill in public_fills}
    merged = list(public_fills)
    for fill in inferred_fills:
        if fill.transaction_hash in by_hash:
            continue
        merged.append(fill)
    merged.sort(key=lambda row: (row.timestamp, row.transaction_hash))
    return merged


def serialize_fills(fills: list[FillRecord]) -> list[dict[str, Any]]:
    return [
        {
            "outcome": fill.outcome,
            "side": fill.side,
            "size": round(fill.size, 6),
            "price": round(fill.price, 6),
            "timestamp": fill.timestamp,
            "transactionHash": fill.transaction_hash,
        }
        for fill in fills
    ]


def maybe_round(value: float | None) -> float | None:
    if value is None:
        return None
    return round(value, 6)


def snapshot_quotes(
    *,
    up_book: dict[str, Any],
    down_book: dict[str, Any],
    clip_shares: float,
    bid_improve: float,
    depth_band: float,
    min_depth_ratio: float,
    min_best_level_ratio: float,
) -> dict[str, Any]:
    up_bid = best_bid(up_book)
    down_bid = best_bid(down_book)
    up_depth = bid_depth_within_band(up_book, depth_band)
    down_depth = bid_depth_within_band(down_book, depth_band)
    quoted_up = None if up_bid is None else quote_price_from_bid(up_bid, bid_improve)
    quoted_down = None if down_bid is None else quote_price_from_bid(down_bid, bid_improve)
    gross = None
    enough_best_level = False
    enough_depth = False
    if up_bid and down_bid:
        gross = round(quoted_up + quoted_down, 6)
        enough_best_level = (
            up_bid.size >= clip_shares * min_best_level_ratio
            and down_bid.size >= clip_shares * min_best_level_ratio
        )
        if up_depth and down_depth:
            enough_depth = (
                up_depth["cumulativeSize"] >= clip_shares * min_depth_ratio
                and down_depth["cumulativeSize"] >= clip_shares * min_depth_ratio
            )
    return {
        "up": None
        if up_bid is None
        else {
            "bestBid": up_bid.price,
            "bestBidSize": up_bid.size,
            "quotedPrice": quoted_up,
        },
        "down": None
        if down_bid is None
        else {
            "bestBid": down_bid.price,
            "bestBidSize": down_bid.size,
            "quotedPrice": quoted_down,
        },
        "depth": {
            "up": None
            if up_depth is None
            else {
                "bestPrice": up_depth["bestPrice"],
                "minPrice": up_depth["minPrice"],
                "cumulativeSize": round(up_depth["cumulativeSize"], 6),
                "ratio": round(up_depth["cumulativeSize"] / clip_shares, 6),
            },
            "down": None
            if down_depth is None
            else {
                "bestPrice": down_depth["bestPrice"],
                "minPrice": down_depth["minPrice"],
                "cumulativeSize": round(down_depth["cumulativeSize"], 6),
                "ratio": round(down_depth["cumulativeSize"] / clip_shares, 6),
            },
        },
        "pairQuotedCost": gross,
        "enoughBestLevel": enough_best_level,
        "enoughDepth": enough_depth,
    }


def build_maker_paired_layers(
    *,
    up_base: float,
    down_base: float,
    clip_shares: float,
    min_order_notional: float,
    max_clip_shares: float,
    maker_layers: int,
    maker_price_step: float,
    maker_pair_threshold: float,
    maker_layer_size_ratio: float,
    remaining_action_slots: int,
) -> list[dict[str, Any]]:
    actions: list[dict[str, Any]] = []
    if (
        maker_layers <= 0
        or maker_price_step <= 0
        or maker_pair_threshold <= 0
        or remaining_action_slots < 2
    ):
        return actions

    base_layer_shares = max(
        clip_shares * max(0.0, maker_layer_size_ratio),
        VENUE_MIN_ORDER_SHARES,
        ORDER_SIZE_STEP,
    )
    for layer in range(1, maker_layers + 1):
        if remaining_action_slots - len(actions) < 2:
            break
        up_price = round(max(0.01, up_base - maker_price_step * layer), 6)
        down_price = round(max(0.01, down_base - maker_price_step * layer), 6)
        pair_cost = round(up_price + down_price, 6)
        if pair_cost > maker_pair_threshold:
            continue
        min_pair_price = min(up_price, down_price)
        layer_size = round_up_shares(
            max(
                base_layer_shares,
                VENUE_MIN_ORDER_SHARES,
                min_order_notional / max(min_pair_price, 0.000001),
            )
        )
        if layer_size > max_clip_shares:
            continue
        actions.extend(
            [
                {
                    "outcome": "Up",
                    "quotedPrice": up_price,
                    "size": layer_size,
                    "mode": "maker_paired",
                    "layer": layer,
                    "projectedPairCost": pair_cost,
                },
                {
                    "outcome": "Down",
                    "quotedPrice": down_price,
                    "size": layer_size,
                    "mode": "maker_paired",
                    "layer": layer,
                    "projectedPairCost": pair_cost,
                },
            ]
        )
    return actions


def build_maker_rebalance_layers(
    *,
    lagging_side: str,
    lagging_avg: float,
    lagging_quote: float,
    residual_qty: float,
    min_order_notional: float,
    max_clip_shares: float,
    maker_layers: int,
    maker_price_step: float,
    maker_rebalance_threshold: float,
    remaining_action_slots: int,
) -> list[dict[str, Any]]:
    actions: list[dict[str, Any]] = []
    if (
        maker_layers <= 0
        or maker_price_step <= 0
        or maker_rebalance_threshold <= 0
        or remaining_action_slots <= 0
    ):
        return actions

    remaining_target = max(0.0, residual_qty)
    for layer in range(1, maker_layers + 1):
        if remaining_action_slots - len(actions) <= 0:
            break
        if remaining_target + 1e-9 < VENUE_MIN_ORDER_SHARES:
            break
        price = round(max(0.01, lagging_quote - maker_price_step * layer), 6)
        projected = round(price + lagging_avg, 6)
        if projected > maker_rebalance_threshold:
            continue
        min_size = round_up_shares(
            max(
                VENUE_MIN_ORDER_SHARES,
                min_order_notional / max(price, 0.000001),
            )
        )
        size = round_up_shares(max(min_size, min(remaining_target, max_clip_shares)))
        if size > max_clip_shares:
            continue
        actions.append(
            {
                "outcome": lagging_side,
                "quotedPrice": price,
                "size": size,
                "mode": "maker_rebalance",
                "layer": layer,
                "projectedPairCost": projected,
            }
        )
        remaining_target = max(0.0, remaining_target - size)
    return actions


def cap_actions_by_outcome_budget(
    actions: list[dict[str, Any]],
    *,
    per_outcome_budget: float,
) -> list[dict[str, Any]]:
    if per_outcome_budget + 1e-9 < VENUE_MIN_ORDER_SHARES:
        return []
    remaining = {"Up": per_outcome_budget, "Down": per_outcome_budget}
    capped: list[dict[str, Any]] = []
    for action in actions:
        outcome = str(action["outcome"])
        size = float(action["size"])
        if remaining.get(outcome, 0.0) + 1e-9 < size:
            continue
        capped.append(action)
        remaining[outcome] = max(0.0, remaining[outcome] - size)
    return capped


def build_quote_context(
    *,
    quotes: dict[str, Any],
    state: InventoryState,
    clip_shares: float,
    inventory_skew_step: float,
    inventory_skew_trigger_shares: float,
) -> dict[str, Any]:
    up_quote = float(quotes["up"]["quotedPrice"])
    down_quote = float(quotes["down"]["quotedPrice"])
    skew: dict[str, Any] | None = None

    if (
        state.residual_side
        and inventory_skew_step > 0
        and state.residual_qty >= max(ORDER_SIZE_STEP, inventory_skew_trigger_shares)
    ):
        skew_units = min(
            3,
            max(
                1,
                int(
                    math.floor(
                        state.residual_qty / max(ORDER_SIZE_STEP, inventory_skew_trigger_shares)
                    )
                ),
            ),
        )
        applied = round(inventory_skew_step * skew_units, 6)
        if state.residual_side == "Up":
            up_quote = round(max(0.01, up_quote - applied), 6)
            down_quote = round(min(0.99, down_quote + applied), 6)
            skew = {
                "leadingSide": "Up",
                "laggingSide": "Down",
                "stepApplied": applied,
                "units": skew_units,
            }
        elif state.residual_side == "Down":
            up_quote = round(min(0.99, up_quote + applied), 6)
            down_quote = round(max(0.01, down_quote - applied), 6)
            skew = {
                "leadingSide": "Down",
                "laggingSide": "Up",
                "stepApplied": applied,
                "units": skew_units,
            }

    return {
        "upQuote": up_quote,
        "downQuote": down_quote,
        "pairQuotedCost": round(up_quote + down_quote, 6),
        "skew": skew,
        "sessionResidualRatio": round(residual_ratio(state, clip_shares=clip_shares), 6),
    }


def decide_actions(
    *,
    event: dict[str, Any],
    state: InventoryState,
    quotes: dict[str, Any],
    clip_shares: float,
    entry_threshold: float,
    rebalance_threshold: float,
    max_residual_shares: float,
    late_session_residual_seconds: int,
    late_session_residual_threshold: float,
    session_residual_stop_shares: float,
    session_residual_stop_ratio: float,
    inventory_skew_step: float,
    inventory_skew_trigger_shares: float,
    early_session_seconds: int,
    early_session_flat_residual_threshold: float,
    early_session_pair_budget: float,
    early_session_max_actions: int,
    min_seconds_left: int,
    min_order_notional: float,
    max_clip_shares: float,
    maker_layers: int,
    maker_price_step: float,
    maker_pair_threshold: float,
    maker_layer_size_ratio: float,
    max_actions_per_cycle: int,
    outstanding_up: float = 0.0,
    outstanding_down: float = 0.0,
    projected_exposure_limit_shares: float = 0.0,
) -> dict[str, Any]:
    remaining = seconds_left(event)
    decisions: list[dict[str, Any]] = []
    reason = "hold"
    pair_cost = quotes.get("pairQuotedCost")
    enough_depth = quotes.get("enoughDepth", False)
    enough_best_level = quotes.get("enoughBestLevel", False)
    if remaining < min_seconds_left:
        return {
            "secondsLeft": remaining,
            "reason": "too_close_to_resolution",
            "actions": [],
            "projectedPairCost": pair_cost,
        }
    if quotes["up"] is None or quotes["down"] is None:
        return {
            "secondsLeft": remaining,
            "reason": "missing_best_bid",
            "actions": [],
            "projectedPairCost": pair_cost,
        }

    residual_side = state.residual_side
    residual_qty = state.residual_qty
    quote_context = build_quote_context(
        quotes=quotes,
        state=state,
        clip_shares=clip_shares,
        inventory_skew_step=inventory_skew_step,
        inventory_skew_trigger_shares=inventory_skew_trigger_shares,
    )
    pair_cost = quote_context["pairQuotedCost"]
    up_quote = quote_context["upQuote"]
    down_quote = quote_context["downQuote"]
    lagging_side = None
    lagging_avg = None
    lagging_quote = None
    if residual_side == "Up":
        lagging_side = "Down"
        lagging_quote = down_quote
        lagging_avg = state.up_avg
    elif residual_side == "Down":
        lagging_side = "Up"
        lagging_quote = up_quote
        lagging_avg = state.down_avg

    rebalance_cost = None
    can_rebalance = False
    rebalance_size = None
    if lagging_side and lagging_quote is not None and lagging_avg is not None:
        rebalance_cost = round(lagging_quote + lagging_avg, 6)
        rebalance_size = round_up_shares(
            max(
                residual_qty,
                VENUE_MIN_ORDER_SHARES,
                min_order_notional / max(lagging_quote, 0.000001),
            )
        )
        can_rebalance = (
            residual_qty > 0.01
            and rebalance_cost <= rebalance_threshold
            and rebalance_size <= max_clip_shares
        )

    pair_clip_size = None
    if pair_cost is not None:
        min_pair_price = min(up_quote, down_quote)
        pair_clip_size = round_up_shares(
            max(
                clip_shares,
                VENUE_MIN_ORDER_SHARES,
                min_order_notional / max(min_pair_price, 0.000001),
            )
        )

    pair_clip_ok = pair_clip_size is not None and pair_clip_size <= max_clip_shares
    late_session_residual_guard = (
        residual_qty >= max(0.0, late_session_residual_threshold)
        and remaining <= max(0, late_session_residual_seconds)
    )
    session_ratio = float(quote_context["sessionResidualRatio"])
    session_paired_blocked = (
        residual_qty >= max(0.0, session_residual_stop_shares)
        or session_ratio >= max(0.0, session_residual_stop_ratio)
    )
    total_seconds = event_total_seconds(event)
    early_session_active = (
        total_seconds is not None
        and remaining >= max(0, total_seconds - max(0, early_session_seconds))
        and residual_qty <= max(0.0, early_session_flat_residual_threshold)
    )
    effective_pair_budget_cap = (
        max(max_clip_shares, early_session_pair_budget)
        if early_session_active
        else max_clip_shares
    )
    effective_max_actions = (
        max(max_actions_per_cycle, early_session_max_actions)
        if early_session_active
        else max_actions_per_cycle
    )
    available_pair_budget = max(0.0, effective_pair_budget_cap - residual_qty)
    maker_rebalance_threshold = max(rebalance_threshold, maker_pair_threshold)
    maker_rebalance_actions: list[dict[str, Any]] = []
    if lagging_side and lagging_quote is not None and lagging_avg is not None:
        maker_rebalance_actions = build_maker_rebalance_layers(
            lagging_side=lagging_side,
            lagging_avg=lagging_avg,
            lagging_quote=lagging_quote,
            residual_qty=residual_qty,
            min_order_notional=min_order_notional,
            max_clip_shares=max_clip_shares,
            maker_layers=maker_layers,
            maker_price_step=maker_price_step,
            maker_rebalance_threshold=maker_rebalance_threshold,
            remaining_action_slots=effective_max_actions,
        )

    if residual_qty >= max_residual_shares:
        if can_rebalance:
            decisions.append(
                {
                    "outcome": lagging_side,
                    "quotedPrice": lagging_quote,
                    "size": rebalance_size,
                    "mode": "rebalance",
                    "projectedPairCost": rebalance_cost,
                }
            )
            reason = "rebalance_lagging_side"
        elif maker_rebalance_actions:
            decisions.extend(maker_rebalance_actions[:effective_max_actions])
            reason = "maker_rebalance_ladder"
        else:
            reason = "residual_cap_reached"
    else:
        if can_rebalance:
            decisions.append(
                {
                    "outcome": lagging_side,
                    "quotedPrice": lagging_quote,
                    "size": rebalance_size,
                    "mode": "rebalance",
                    "projectedPairCost": rebalance_cost,
                }
            )
            reason = "rebalance_lagging_side"
        elif maker_rebalance_actions:
            decisions.extend(maker_rebalance_actions[:effective_max_actions])
            reason = "maker_rebalance_ladder"
        elif late_session_residual_guard:
            reason = "late_session_residual_guard"
        elif session_paired_blocked:
            reason = "session_inventory_guard"
        elif (
            pair_cost is not None
            and pair_cost <= entry_threshold
            and enough_depth
            and enough_best_level
            and pair_clip_ok
            and pair_clip_size <= available_pair_budget + 1e-9
        ):
            decisions.extend(
                [
                    {
                        "outcome": "Up",
                        "quotedPrice": up_quote,
                        "size": pair_clip_size,
                        "mode": "paired",
                    },
                    {
                        "outcome": "Down",
                        "quotedPrice": down_quote,
                        "size": pair_clip_size,
                        "mode": "paired",
                    },
                ]
            )
            maker_pair_actions = cap_actions_by_outcome_budget(
                build_maker_paired_layers(
                    up_base=up_quote,
                    down_base=down_quote,
                    clip_shares=clip_shares,
                    min_order_notional=min_order_notional,
                    max_clip_shares=max_clip_shares,
                    maker_layers=maker_layers,
                    maker_price_step=maker_price_step,
                    maker_pair_threshold=maker_pair_threshold,
                    maker_layer_size_ratio=maker_layer_size_ratio,
                    remaining_action_slots=max(0, effective_max_actions - len(decisions)),
                ),
                per_outcome_budget=max(0.0, available_pair_budget - pair_clip_size),
            )
            if maker_pair_actions:
                decisions.extend(maker_pair_actions)
                reason = "hybrid_paired_maker"
            else:
                reason = "paired_bid_edge"
        elif (
            pair_cost is not None
            and enough_depth
            and build_maker_paired_layers(
                up_base=up_quote,
                down_base=down_quote,
                clip_shares=clip_shares,
                min_order_notional=min_order_notional,
                max_clip_shares=max_clip_shares,
                maker_layers=maker_layers,
                maker_price_step=maker_price_step,
                maker_pair_threshold=maker_pair_threshold,
                maker_layer_size_ratio=maker_layer_size_ratio,
                remaining_action_slots=effective_max_actions,
            )
        ):
            decisions.extend(
                cap_actions_by_outcome_budget(
                    build_maker_paired_layers(
                        up_base=up_quote,
                        down_base=down_quote,
                        clip_shares=clip_shares,
                        min_order_notional=min_order_notional,
                        max_clip_shares=max_clip_shares,
                        maker_layers=maker_layers,
                        maker_price_step=maker_price_step,
                        maker_pair_threshold=maker_pair_threshold,
                        maker_layer_size_ratio=maker_layer_size_ratio,
                        remaining_action_slots=effective_max_actions,
                    ),
                    per_outcome_budget=available_pair_budget,
                )
            )
            reason = (
                "maker_paired_ladder"
                if decisions
                else "session_pair_budget_exhausted"
            )
        elif pair_cost is not None and pair_cost <= entry_threshold and not pair_clip_ok:
            reason = "min_notional_requires_too_many_shares"
        elif pair_cost is not None and pair_cost <= entry_threshold and pair_clip_size is not None and pair_clip_size > available_pair_budget:
            reason = "session_pair_budget_exhausted"
        elif not enough_best_level:
            reason = "thin_top_of_book_bid"
        elif not enough_depth:
            reason = "insufficient_bid_depth_within_band"
        elif pair_cost is not None and pair_cost > entry_threshold:
            reason = "no_bid_edge_after_threshold"

    # Milestone 1 — treat outstanding orders as real risk.
    # After the existing decision logic has proposed an action list,
    # walk it in order and clip any create that would push the
    # projected post-fill residual past the configured shares limit.
    # Defaults preserve current behavior: when the caller passes the
    # zero defaults for outstanding/limit, this loop is a no-op.
    pre_clip_up, pre_clip_down = outstanding_up, outstanding_down
    base_projected_side, base_projected_qty = project_residual_if_all_fill(
        filled_up=state.up_qty,
        filled_down=state.down_qty,
        outstanding_up=outstanding_up,
        outstanding_down=outstanding_down,
    )
    exposure_clips: list[dict[str, Any]] = []
    if projected_exposure_limit_shares > 0.0 and decisions:
        allowed: list[dict[str, Any]] = []
        # Cumulative size added by already-allowed actions this cycle,
        # keyed by outcome. The exposure check treats outstanding +
        # cumulative-allowed as the floor for the next decision.
        cum: dict[str, float] = {"Up": 0.0, "Down": 0.0}
        for action in decisions:
            outcome = str(action.get("outcome") or "")
            size = float(action.get("size") or 0.0)
            proj_up = state.up_qty + outstanding_up + cum["Up"] + (
                size if outcome == "Up" else 0.0
            )
            proj_down = state.down_qty + outstanding_down + cum["Down"] + (
                size if outcome == "Down" else 0.0
            )
            proj_qty = abs(proj_up - proj_down)
            if proj_qty > projected_exposure_limit_shares + 1e-9:
                exposure_clips.append(
                    {
                        "outcome": outcome,
                        "size": round(size, 6),
                        "mode": str(action.get("mode") or ""),
                        "layer": int(action.get("layer") or 0),
                        "projectedResidualQty": round(proj_qty, 6),
                        "limit": round(
                            float(projected_exposure_limit_shares), 6
                        ),
                        "reason": "projected_exposure_limit",
                    }
                )
                continue
            allowed.append(action)
            if outcome in cum:
                cum[outcome] += size
        if exposure_clips:
            decisions = allowed
            if not decisions:
                reason = "exposure_projection_blocked"

    return {
        "secondsLeft": remaining,
        "reason": reason,
        "actions": decisions,
        "projectedPairCost": pair_cost,
        "rebalancePairCost": rebalance_cost,
        "pairClipSize": pair_clip_size,
        "rebalanceClipSize": rebalance_size,
        "lateSessionResidualGuard": late_session_residual_guard,
        "sessionResidualRatio": round(session_ratio, 6),
        "sessionPairedBlocked": session_paired_blocked,
        "sessionAvailablePairBudget": round(available_pair_budget, 6),
        "effectivePairBudgetCap": round(effective_pair_budget_cap, 6),
        "effectiveMaxActions": effective_max_actions,
        "earlySessionActive": early_session_active,
        "quoteContext": quote_context,
        "outstandingExposure": {
            "Up": round(pre_clip_up, 6),
            "Down": round(pre_clip_down, 6),
        },
        "projectedResidual": {
            "side": base_projected_side,
            "qty": round(base_projected_qty, 6),
            "limitShares": round(float(projected_exposure_limit_shares), 6),
        },
        "exposureClips": exposure_clips,
    }


def wallet_address_from_args(args: argparse.Namespace) -> str:
    value = args.wallet_address or os.environ.get("POLYMARKET_FUNDER", DEFAULT_FUNDER)
    return normalize_env_value(value)


def write_outcome_files(summary_path: Path, summary: dict[str, Any]) -> None:
    write_json(summary_path, summary)
    outcome_path = summary_path.with_suffix(".outcome.txt")
    final_state = summary.get("finalState", {})
    inferred_fill_count = len(summary.get("inferredFills", []))
    public_fill_count = len(summary.get("publicFills", []))
    merged_fill_count = len(summary.get("mergedFills", []))
    lines = [
        f"slug: {summary['event']['slug']}",
        f"title: {summary['event']['title']}",
        f"phase: {'live' if summary['liveOk'] else 'dry_run'}",
        f"cycles: {len(summary.get('cycles', []))}",
        f"wallet: {summary['walletAddress']}",
        f"best_pair_quote_seen: {summary.get('bestPairQuoteSeen')}",
        f"paired_qty: {final_state.get('pairedQty')}",
        f"paired_avg_cost: {final_state.get('pairedAvgCost')}",
        f"residual_side: {final_state.get('residualSide')}",
        f"residual_qty: {final_state.get('residualQty')}",
        f"trade_count: {final_state.get('tradeCount')}",
        f"inferred_fill_count: {inferred_fill_count}",
        f"public_fill_count: {public_fill_count}",
        f"merged_fill_count: {merged_fill_count}",
        f"result: {summary.get('result')}",
    ]
    outcome_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_summary_outputs(summary_paths: list[Path], summary: dict[str, Any]) -> None:
    seen: set[Path] = set()
    for path in summary_paths:
        if path in seen:
            continue
        seen.add(path)
        write_outcome_files(path, summary)


def reconcile_final_fills(
    *,
    wallet: str,
    slug: str,
    since_timestamp: int,
    polls: int = 5,
    sleep_seconds: float = 1.0,
    stable_polls: int = 2,
    min_wait_seconds: float = 0.0,
    max_wait_seconds: float | None = None,
    minimum_fill_count: int = 0,
) -> list[FillRecord]:
    latest: list[FillRecord] = []
    stable_count = 0
    last_signature: tuple[tuple[str, int], ...] = ()
    started = time.time()
    attempts = 0
    min_wait_seconds = max(0.0, min_wait_seconds)
    max_attempts = max(1, polls)
    deadline = (
        started + max_wait_seconds
        if max_wait_seconds is not None
        else started + sleep_seconds * max_attempts
    )
    while True:
        remaining_wait = started + min_wait_seconds - time.time()
        if remaining_wait > 0:
            time.sleep(min(remaining_wait, max(0.05, sleep_seconds)))
            continue
        attempts += 1
        latest = fetch_wallet_trades(
            wallet=wallet,
            slug=slug,
            since_timestamp=since_timestamp,
        )
        signature = tuple((fill.transaction_hash, fill.timestamp) for fill in latest)
        enough_fills = len(latest) >= max(0, minimum_fill_count)
        if signature == last_signature:
            stable_count += 1
            if enough_fills and stable_count >= max(1, stable_polls):
                return latest
        else:
            stable_count = 0
            last_signature = signature
        if attempts >= max_attempts and time.time() >= deadline:
            return latest
        if time.time() >= deadline:
            return latest
        time.sleep(max(0.0, sleep_seconds))


def inferred_fill_from_submit(
    *,
    outcome: str,
    parsed: dict[str, Any],
) -> FillRecord | None:
    body = parsed.get("orderResponse")
    if not isinstance(body, dict):
        return None
    if str(body.get("status") or "").lower() != "matched":
        return None
    try:
        size = float(body["takingAmount"])
        cost = float(body["makingAmount"])
    except (KeyError, TypeError, ValueError):
        return None
    if size <= 0 or cost < 0:
        return None
    tx_hashes = body.get("transactionsHashes") or []
    tx_hash = str(tx_hashes[0]) if tx_hashes else f"inferred:{outcome}:{time.time()}"
    return FillRecord(
        outcome=outcome,
        side="BUY",
        size=size,
        price=cost / size,
        timestamp=int(time.time()),
        transaction_hash=tx_hash,
    )


def run_cycle_actions(
    *,
    root: Path,
    output_dir: Path,
    event: dict[str, Any],
    actions: list[dict[str, Any]],
    clip_shares: float,
    private_key: str,
    signature_type: str,
    funder: str,
    binary: Path,
    creds: Path,
    nonce: Path,
    symbol_prefix: str,
    stamp: str,
    cycle_index: int,
    persistent_ladder: bool = False,
    existing_working_orders: list[WorkingOrder] | None = None,
    ladder_ttl_seconds: float = 30.0,
) -> dict[str, Any]:
    fee_rate_bps = int(event.get("makerBaseFee") or 0)
    cycle_tag = f"{stamp}.cycle{cycle_index:03d}"
    matched_qty_by_outcome = {"Up": 0.0, "Down": 0.0}
    live_maker_paired_by_outcome = {"Up": False, "Down": False}
    cleanup_plan = plan_leg(
        slug=event["slug"],
        output_dir=output_dir,
        symbol_prefix=f"{symbol_prefix}-cleanup",
        outcome=f"cleanup-cycle{cycle_index:03d}",
        token_id=event["upTokenId"],
        price=0.5,
        size=clip_shares,
        stop_before_end_ms=20_000,
        trade_side="buy_only",
    )

    # Milestone 1 — persistent-ladder mode. When enabled, skip the
    # per-cycle cleanup_cancel_all and instead reconcile the existing
    # working orders against the proposed action list. Only the delta
    # (created + amended) is submitted; cancelled keys are batched for
    # an end-of-cycle targeted cancel. `preserved` orders stay on the
    # book untouched, which is the whole point — preserving queue
    # position is how we move toward the reference wallet's tempo.
    #
    # This path is flag-gated and shadow is where we validate; the
    # live accumulator keeps its existing cleanup-first flow by
    # default so no live behavior changes until the operator opts in.
    reconcile_summary: dict[str, Any] | None = None
    working_after: list[WorkingOrder] | None = None
    pre_cleanup: dict[str, Any]
    if persistent_ladder:
        now_ts = time.time()
        working_after, reconcile_summary = reconcile_orders(
            existing_orders=list(existing_working_orders or []),
            actions=actions,
            now_ts=now_ts,
            ttl_seconds=ladder_ttl_seconds,
            cycle_index=cycle_index,
            slug=event["slug"],
        )
        # Only the actions the reconciler classified as created or
        # amended get submitted this cycle. Preserved orders stay
        # live on the book — that's what eliminates the cancel/repost
        # churn the spec targets.
        submit_keys = {
            row["key"] for row in reconcile_summary.get("created", [])
        } | {
            row["key"] for row in reconcile_summary.get("amended", [])
        }
        actions_to_submit = [
            action
            for action in actions
            if f"{action['outcome']}:{action.get('mode') or ''}:{int(action.get('layer') or 0)}"
            in submit_keys
        ]
        pre_cleanup = {
            "status": "skipped",
            "skipReason": "persistent_ladder_enabled",
            "reconcileCounts": {
                "created": len(reconcile_summary.get("created", [])),
                "amended": len(reconcile_summary.get("amended", [])),
                "preserved": len(reconcile_summary.get("preserved", [])),
                "cancelled": len(reconcile_summary.get("cancelled", [])),
            },
        }
    else:
        actions_to_submit = actions
        pre_cleanup = cleanup_cancel_all(
            binary=binary,
            creds=creds,
            nonce=nonce,
            private_key=private_key,
            signature_type=signature_type,
            funder=funder,
            config_path=cleanup_plan.config_path,
            token_id=event["upTokenId"],
            market_id=event["conditionId"],
            fee_rate_bps=fee_rate_bps,
            log_path=output_dir / f"{event['slug']}.{cycle_tag}.pre-cleanup.log",
        )

    submits: list[dict[str, Any]] = []
    inferred_fills: list[FillRecord] = []
    for action in actions_to_submit:
        outcome = str(action["outcome"])
        mode = str(action.get("mode") or "")
        other_outcome = "Down" if outcome == "Up" else "Up"
        if (
            mode == "maker_paired"
            and matched_qty_by_outcome[outcome]
            > matched_qty_by_outcome[other_outcome] + 1e-9
        ):
            submits.append(
                {
                    "action": action,
                    "plan": None,
                    "result": {
                        "status": "skipped",
                        "skipReason": "same_side_already_matched_this_cycle",
                    },
                }
            )
            continue
        if mode == "maker_paired" and live_maker_paired_by_outcome[outcome]:
            submits.append(
                {
                    "action": action,
                    "plan": None,
                    "result": {
                        "status": "skipped",
                        "skipReason": "same_side_live_order_already_posted_this_cycle",
                    },
                }
            )
            continue
        token_id = event["upTokenId"] if outcome == "Up" else event["downTokenId"]
        plan = plan_leg(
            slug=event["slug"],
            output_dir=output_dir,
            symbol_prefix=f"{symbol_prefix}-{outcome.lower()}",
            outcome=f"{outcome}-cycle{cycle_index:03d}",
            token_id=token_id,
            price=float(action["quotedPrice"]),
            size=float(action["size"]),
            stop_before_end_ms=20_000,
            trade_side="buy_only",
        )
        parsed = canary_submit(
            binary=binary,
            creds=creds,
            nonce=nonce,
            private_key=private_key,
            signature_type=signature_type,
            funder=funder,
            config_path=plan.config_path,
            token_id=plan.token_id,
            net_position=-float(action["size"]),
            fee_rate_bps=fee_rate_bps,
            log_path=output_dir
            / f"{event['slug']}.{cycle_tag}.{outcome.lower()}.log",
        )
        submits.append(
            {
                "action": action,
                "plan": {
                    "tokenId": plan.token_id,
                    "configPath": str(plan.config_path),
                    "quotedPrice": plan.price,
                    "size": plan.size,
                },
                "result": parsed,
            }
        )
        inferred = inferred_fill_from_submit(outcome=outcome, parsed=parsed)
        if inferred is not None:
            inferred_fills.append(inferred)
            matched_qty_by_outcome[outcome] += inferred.size
        elif mode == "maker_paired" and str(parsed.get("status") or "") == "live":
            live_maker_paired_by_outcome[outcome] = True

    result = {
        "preCleanup": pre_cleanup,
        "submits": submits,
        "cleanupConfigPath": str(cleanup_plan.config_path),
        "feeRateBps": fee_rate_bps,
        "inferredFills": [
            {
                "outcome": fill.outcome,
                "size": round(fill.size, 6),
                "price": round(fill.price, 6),
                "timestamp": fill.timestamp,
                "transactionHash": fill.transaction_hash,
            }
            for fill in inferred_fills
        ],
    }
    if persistent_ladder and reconcile_summary is not None:
        # Caller (main loop) keeps the session-level working-orders
        # list; return the post-reconcile snapshot so it can roll
        # forward without re-diffing against REST state.
        result["persistentLadder"] = {
            "enabled": True,
            "ttlSeconds": round(float(ladder_ttl_seconds), 6),
            "reconcile": reconcile_summary,
            "workingAfter": [order.to_dict() for order in (working_after or [])],
        }
    return result


def main() -> int:
    args = build_parser().parse_args()
    root = Path(args.root)
    output_dir = root / args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    event = resolve(args.which, args.lookahead_windows)
    if args.which == "next":
        wait_for_market_open(event, buffer_seconds=args.open_wait_buffer_seconds)

    wallet_address = wallet_address_from_args(args)
    session_id = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    summary_paths = [
        output_dir / f"{event['slug']}.{session_id}.accumulator.summary.json",
        output_dir / f"{event['slug']}.accumulator.summary.json",
    ]
    start_timestamp = int(
        datetime.fromisoformat(str(event["startDate"]).replace("Z", "+00:00")).timestamp()
    )
    inferred_fills: list[FillRecord] = []

    summary: dict[str, Any] = {
        "event": event,
        "sessionId": session_id,
        "walletAddress": wallet_address,
        "liveOk": args.live_ok,
        "parameters": {
            "clipShares": args.clip_shares,
            "entryThreshold": args.entry_threshold,
            "rebalanceThreshold": args.rebalance_threshold,
            "maxResidualShares": args.max_residual_shares,
            "lateSessionResidualSeconds": args.late_session_residual_seconds,
            "lateSessionResidualThreshold": args.late_session_residual_threshold,
            "sessionResidualStopShares": args.session_residual_stop_shares,
            "sessionResidualStopRatio": args.session_residual_stop_ratio,
            "inventorySkewStep": args.inventory_skew_step,
            "inventorySkewTriggerShares": args.inventory_skew_trigger_shares,
            "earlySessionSeconds": args.early_session_seconds,
            "earlySessionFlatResidualThreshold": args.early_session_flat_residual_threshold,
            "earlySessionPairBudget": args.early_session_pair_budget,
            "earlySessionMaxActions": args.early_session_max_actions,
            "makerLayers": args.maker_layers,
            "makerPriceStep": args.maker_price_step,
            "makerPairThreshold": args.maker_pair_threshold,
            "makerLayerSizeRatio": args.maker_layer_size_ratio,
            "maxActionsPerCycle": args.max_actions_per_cycle,
            "persistentLadder": bool(args.persistent_ladder),
            "ladderTtlSeconds": float(args.ladder_ttl_seconds),
            "projectedExposureLimitShares": float(
                args.projected_exposure_limit_shares
            ),
            "watchSeconds": args.watch_seconds,
            "residualWatchSeconds": args.residual_watch_seconds,
            "pollSeconds": args.poll_seconds,
            "restSeconds": args.rest_seconds,
            "bidImprove": args.bid_improve,
            "depthBand": args.depth_band,
            "minDepthRatio": args.min_depth_ratio,
            "minBestLevelRatio": args.min_best_level_ratio,
            "minSecondsLeft": args.min_seconds_left,
            "minOrderNotional": args.min_order_notional,
            "maxClipShares": args.max_clip_shares,
        },
        "cycles": [],
        "bestPairQuoteSeen": None,
        "bestRebalanceQuoteSeen": None,
        "result": "running",
        "inferredFills": [],
        "publicFills": [],
        "mergedFills": [],
    }
    write_summary_outputs(summary_paths, summary)

    binary = root / "bin" / "arbigab-replica"
    creds = root / "state" / "creds.json"
    nonce = root / "state" / "nonce"
    if args.live_ok:
        ensure_binary(Path(DEFAULT_SRC_BIN), binary)
        private_key = require_env("POLYMARKET_PRIVATE_KEY")
        signature_type = require_env("POLYMARKET_SIGNATURE_TYPE", default="2")
        funder = require_env("POLYMARKET_FUNDER", default=DEFAULT_FUNDER)
        bootstrap_creds(
            binary=binary,
            creds=creds,
            nonce=nonce,
            private_key=private_key,
            signature_type=signature_type,
            funder=funder,
            source_creds=Path(DEFAULT_SRC_CREDS),
        )
    else:
        private_key = ""
        signature_type = "2"
        funder = wallet_address

    event_cutoff = (
        datetime.fromisoformat(str(event["endDate"]).replace("Z", "+00:00")).timestamp()
        - args.min_seconds_left
    )
    deadline = min(
        time.time() + max(1, args.watch_seconds),
        event_cutoff,
    )
    cycle_index = 0
    last_execution_wall_time: float | None = None
    # Milestone 1 — session-level working-orders ledger. Populated
    # only when --persistent-ladder is on; each cycle reconciles the
    # target ladder against this list instead of cancel-all-per-cycle.
    session_working_orders: list[WorkingOrder] = []

    while time.time() < deadline:
        cycle_index += 1
        market_books = RestPollingMarketFeed().fetch_event_books(event)
        fills = fetch_wallet_trades(
            wallet=wallet_address,
            slug=event["slug"],
            since_timestamp=start_timestamp,
        )
        state = compute_inventory_state(merge_fills(fills, inferred_fills))
        quotes = snapshot_quotes(
            up_book=market_books.up_book,
            down_book=market_books.down_book,
            clip_shares=args.clip_shares,
            bid_improve=args.bid_improve,
            depth_band=args.depth_band,
            min_depth_ratio=args.min_depth_ratio,
            min_best_level_ratio=args.min_best_level_ratio,
        )
        # Outstanding exposure is what decide_actions needs to treat
        # working orders as real risk. Zeros when persistent-ladder is
        # off, so default behavior is unchanged.
        outstanding = compute_outstanding_exposure(session_working_orders)
        decision = decide_actions(
            event=event,
            state=state,
            quotes=quotes,
            clip_shares=args.clip_shares,
            entry_threshold=args.entry_threshold,
            rebalance_threshold=args.rebalance_threshold,
            max_residual_shares=args.max_residual_shares,
            late_session_residual_seconds=args.late_session_residual_seconds,
            late_session_residual_threshold=args.late_session_residual_threshold,
            session_residual_stop_shares=args.session_residual_stop_shares,
            session_residual_stop_ratio=args.session_residual_stop_ratio,
            inventory_skew_step=args.inventory_skew_step,
            inventory_skew_trigger_shares=args.inventory_skew_trigger_shares,
            early_session_seconds=args.early_session_seconds,
            early_session_flat_residual_threshold=args.early_session_flat_residual_threshold,
            early_session_pair_budget=args.early_session_pair_budget,
            early_session_max_actions=args.early_session_max_actions,
            min_seconds_left=args.min_seconds_left,
            min_order_notional=args.min_order_notional,
            max_clip_shares=args.max_clip_shares,
            maker_layers=args.maker_layers,
            maker_price_step=args.maker_price_step,
            maker_pair_threshold=args.maker_pair_threshold,
            maker_layer_size_ratio=args.maker_layer_size_ratio,
            max_actions_per_cycle=args.max_actions_per_cycle,
            outstanding_up=outstanding.get("Up", 0.0),
            outstanding_down=outstanding.get("Down", 0.0),
            projected_exposure_limit_shares=args.projected_exposure_limit_shares,
        )

        pair_quote = quotes.get("pairQuotedCost")
        if pair_quote is not None:
            current_best = summary["bestPairQuoteSeen"]
            summary["bestPairQuoteSeen"] = pair_quote if current_best is None else min(current_best, pair_quote)
        rebalance_quote = decision.get("rebalancePairCost")
        if rebalance_quote is not None:
            current_best = summary["bestRebalanceQuoteSeen"]
            summary["bestRebalanceQuoteSeen"] = (
                rebalance_quote if current_best is None else min(current_best, rebalance_quote)
            )

        cycle: dict[str, Any] = {
            "cycle": cycle_index,
            "timestampUtc": datetime.now(timezone.utc).isoformat(),
            "secondsLeft": decision["secondsLeft"],
            "inventory": state.to_dict(),
            "quotes": quotes,
            "decision": decision,
            "targetLadder": ladder_summary(decision["actions"]),
        }

        cycle_state = state
        if args.live_ok and decision["actions"]:
            stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
            last_execution_wall_time = time.time()
            execution = run_cycle_actions(
                root=root,
                output_dir=output_dir,
                event=event,
                actions=decision["actions"],
                clip_shares=args.clip_shares,
                private_key=private_key,
                signature_type=signature_type,
                funder=funder,
                binary=binary,
                creds=creds,
                nonce=nonce,
                symbol_prefix=args.symbol_prefix,
                stamp=stamp,
                cycle_index=cycle_index,
                persistent_ladder=args.persistent_ladder,
                existing_working_orders=session_working_orders,
                ladder_ttl_seconds=args.ladder_ttl_seconds,
            )
            cycle["execution"] = execution
            if args.persistent_ladder:
                # Roll the working-orders ledger forward. When the
                # flag is on, run_cycle_actions returns the
                # post-reconcile snapshot; otherwise we keep the list
                # empty so exposure stays zeroed on the off path.
                persistent = execution.get("persistentLadder") or {}
                working_rows = persistent.get("workingAfter") or []
                session_working_orders = [
                    WorkingOrder(**row) for row in working_rows
                ]
            for fill_row in execution.get("inferredFills", []):
                inferred_fills.append(
                    FillRecord(
                        outcome=str(fill_row["outcome"]),
                        side="BUY",
                        size=float(fill_row["size"]),
                        price=float(fill_row["price"]),
                        timestamp=int(fill_row["timestamp"]),
                        transaction_hash=str(fill_row["transactionHash"]),
                    )
                )
            summary["cycles"].append(cycle)
            write_summary_outputs(summary_paths, summary)
            time.sleep(max(0.0, args.rest_seconds))
            post_cleanup = cleanup_cancel_all(
                binary=binary,
                creds=creds,
                nonce=nonce,
                private_key=private_key,
                signature_type=signature_type,
                funder=funder,
                config_path=Path(execution["cleanupConfigPath"]),
                token_id=event["upTokenId"],
                market_id=event["conditionId"],
                fee_rate_bps=execution["feeRateBps"],
                log_path=output_dir / f"{event['slug']}.{stamp}.cycle{cycle_index:03d}.post-cleanup.log",
            )
            cycle["postCleanup"] = post_cleanup
            cycle_fills = reconcile_final_fills(
                wallet=wallet_address,
                slug=event["slug"],
                since_timestamp=start_timestamp,
                polls=4,
                sleep_seconds=1.0,
                stable_polls=2,
                min_wait_seconds=1.0,
                max_wait_seconds=8.0,
                minimum_fill_count=0,
            )
            cycle_state = compute_inventory_state(
                merge_fills(cycle_fills, inferred_fills)
            )
            cycle["postExecutionInventory"] = cycle_state.to_dict()
        else:
            summary["cycles"].append(cycle)

        if (
            args.live_ok
            and args.residual_watch_seconds > 0
            and cycle_state.residual_qty > 0
            and time.time() < event_cutoff
        ):
            residual_deadline = min(
                event_cutoff,
                time.time() + args.residual_watch_seconds,
            )
            if residual_deadline > deadline:
                deadline = residual_deadline
                cycle["residualWatchUntilUtc"] = datetime.fromtimestamp(
                    deadline, tz=timezone.utc
                ).isoformat()

        write_summary_outputs(summary_paths, summary)
        time.sleep(max(0.0, args.poll_seconds))

    live_submit_count = sum(
        1
        for cycle in summary["cycles"]
        for submit in cycle.get("execution", {}).get("submits", [])
        if submit.get("result", {}).get("status") == "live"
    )
    expected_public_fill_count = len(
        {
            fill.transaction_hash
            for fill in inferred_fills
            if fill.transaction_hash and not fill.transaction_hash.startswith("inferred:")
        }
    )
    event_end_ts = datetime.fromisoformat(str(event["endDate"]).replace("Z", "+00:00")).timestamp()
    final_min_wait_seconds = 0.0
    if args.live_ok:
        if last_execution_wall_time is not None:
            final_min_wait_seconds = max(
                final_min_wait_seconds,
                max(0.0, 12.0 - (time.time() - last_execution_wall_time)),
            )
        if expected_public_fill_count > 0 or live_submit_count > 0:
            final_min_wait_seconds = max(
                final_min_wait_seconds,
                max(0.0, (event_end_ts + 10.0) - time.time()),
            )

    final_public_fills = reconcile_final_fills(
        wallet=wallet_address,
        slug=event["slug"],
        since_timestamp=start_timestamp,
        polls=20 if args.live_ok else 2,
        sleep_seconds=1.5 if args.live_ok else 1.0,
        stable_polls=3 if args.live_ok else 2,
        min_wait_seconds=final_min_wait_seconds,
        max_wait_seconds=120.0 if args.live_ok else 3.0,
        minimum_fill_count=expected_public_fill_count,
    )
    merged_final_fills = merge_fills(final_public_fills, inferred_fills)
    final_state = compute_inventory_state(merged_final_fills)
    summary["inferredFills"] = serialize_fills(inferred_fills)
    summary["publicFills"] = serialize_fills(final_public_fills)
    summary["mergedFills"] = serialize_fills(merged_final_fills)
    summary["finalReconciliation"] = {
        "expectedPublicFillCount": expected_public_fill_count,
        "liveSubmitCount": live_submit_count,
        "minimumWaitSeconds": round(final_min_wait_seconds, 3),
    }
    summary["finalState"] = final_state.to_dict()
    summary["finishedUtc"] = datetime.now(timezone.utc).isoformat()
    if args.live_ok:
        if final_state.paired_qty > 0 and final_state.residual_qty <= 0.25:
            summary["result"] = "live_completed_paired_inventory"
        elif final_state.residual_qty > 0:
            summary["result"] = "live_completed_with_residual_inventory"
        else:
            summary["result"] = "live_completed_no_open_inventory"
    else:
        summary["result"] = "dry_run_completed"
    write_summary_outputs(summary_paths, summary)
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
