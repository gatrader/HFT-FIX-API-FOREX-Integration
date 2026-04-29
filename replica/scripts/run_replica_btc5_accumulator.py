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
    consume_working_order_fills,
    ladder_summary,
    prune_expired_orders,
    reconcile_orders,
    working_order_exposure,
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
    # paired_below_par strategy flags (defaults preserve legacy
    # behavior so existing recordings are unaffected).
    parser.add_argument(
        "--strategy-mode",
        choices=("legacy", "paired_below_par"),
        default="legacy",
        help=(
            "legacy = current residual-first decision tree. "
            "paired_below_par = prioritize paired entry whenever "
            "pair_cost < --pair-par-threshold; treat residual as "
            "repair, not freeze."
        ),
    )
    parser.add_argument(
        "--pair-par-threshold",
        type=float,
        default=1.00,
        help="Maximum pair_cost (Up + Down) considered profitable.",
    )
    parser.add_argument(
        "--touch-rest-band",
        type=float,
        default=0.02,
        help=(
            "When pair_cost is above par but within this band, post "
            "at the venue's current best bid (no improve, no "
            "aggression) instead of holding."
        ),
    )
    parser.add_argument(
        "--max-one-sided-shares",
        type=float,
        default=None,
        help=(
            "Per-side cap on filled+outstanding shares. New legs that "
            "would push a side above this are clipped (not the whole "
            "decision)."
        ),
    )
    parser.add_argument(
        "--hedge-affordability-capital",
        type=float,
        default=None,
        help=(
            "Maximum notional ($) for any single rebalance/leg "
            "submission. Stops the engine from posting orders it "
            "cannot afford to fill. None disables the check."
        ),
    )
    parser.add_argument(
        "--reopen-cooldown-seconds",
        type=float,
        default=0.0,
        help=(
            "When > 0, skip recreating any ladder key cancelled inside "
            "this many seconds. Mitigates reopen loops."
        ),
    )
    parser.add_argument(
        "--live-ok",
        action="store_true",
        help="Actually place live orders. Omit for a dry-run forensic pass.",
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


def best_ask(book: dict[str, Any]) -> BookQuote | None:
    asks = parse_levels(book.get("asks", []))
    if not asks:
        return None
    price = min(level.price for level in asks)
    size = sum(level.size for level in asks if abs(level.price - price) < 1e-9)
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


def working_remaining_size(exposure: dict[str, Any], outcome: str) -> float:
    bucket = exposure.get("byOutcome", {}).get(outcome, {})
    return float(bucket.get("remainingSize") or 0.0)


def projected_inventory_snapshot(
    state: InventoryState,
    *,
    outstanding_up: float,
    outstanding_down: float,
    clip_shares: float,
) -> dict[str, Any]:
    projected_up = state.up_qty + max(0.0, outstanding_up)
    projected_down = state.down_qty + max(0.0, outstanding_down)
    projected_paired = min(projected_up, projected_down)
    projected_residual_qty = abs(projected_up - projected_down)
    projected_residual_side = None
    if projected_up > projected_down:
        projected_residual_side = "Up"
    elif projected_down > projected_up:
        projected_residual_side = "Down"
    projected_ratio = projected_residual_qty / max(projected_paired, clip_shares, ORDER_SIZE_STEP)
    return {
        "upQty": round(projected_up, 6),
        "downQty": round(projected_down, 6),
        "pairedQty": round(projected_paired, 6),
        "residualQty": round(projected_residual_qty, 6),
        "residualSide": projected_residual_side,
        "residualRatio": round(projected_ratio, 6),
    }


def session_risk_context(
    *,
    state: InventoryState,
    working_orders: list[WorkingOrder],
    clip_shares: float,
    now_ts: float,
) -> dict[str, Any]:
    exposure = working_order_exposure(working_orders, now_ts=now_ts)
    outstanding_up = working_remaining_size(exposure, "Up")
    outstanding_down = working_remaining_size(exposure, "Down")
    outstanding_paired = min(outstanding_up, outstanding_down)
    outstanding_residual_qty = abs(outstanding_up - outstanding_down)
    outstanding_residual_side = None
    if outstanding_up > outstanding_down:
        outstanding_residual_side = "Up"
    elif outstanding_down > outstanding_up:
        outstanding_residual_side = "Down"
    projected = projected_inventory_snapshot(
        state,
        outstanding_up=outstanding_up,
        outstanding_down=outstanding_down,
        clip_shares=clip_shares,
    )
    return {
        "workingOrders": exposure,
        "outstandingUp": round(outstanding_up, 6),
        "outstandingDown": round(outstanding_down, 6),
        "outstandingPairedQty": round(outstanding_paired, 6),
        "outstandingResidualQty": round(outstanding_residual_qty, 6),
        "outstandingResidualSide": outstanding_residual_side,
        "projected": projected,
    }


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
    up_ask = best_ask(up_book)
    down_ask = best_ask(down_book)
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
            "bestAsk": None if up_ask is None else up_ask.price,
            "bestAskSize": None if up_ask is None else up_ask.size,
            "quotedPrice": quoted_up,
        },
        "down": None
        if down_bid is None
        else {
            "bestBid": down_bid.price,
            "bestBidSize": down_bid.size,
            "bestAsk": None if down_ask is None else down_ask.price,
            "bestAskSize": None if down_ask is None else down_ask.size,
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
    include_base_layer: bool = False,
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
        step_offset = layer - 1 if include_base_layer else layer
        up_price = round(max(0.01, up_base - maker_price_step * step_offset), 6)
        down_price = round(max(0.01, down_base - maker_price_step * step_offset), 6)
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


def near_touch_quote(base_quote: float, quote_row: dict[str, Any] | None) -> float:
    if quote_row is None:
        return base_quote
    best_ask = quote_row.get("bestAsk")
    candidate = base_quote + 0.01
    if best_ask is not None:
        candidate = min(candidate, float(best_ask) - 0.01)
    candidate = round(max(base_quote, min(0.99, candidate)), 6)
    if candidate <= base_quote + 1e-9:
        return base_quote
    return candidate


def build_reference_like_anchor_pair(
    *,
    quotes: dict[str, Any],
    up_quote: float,
    down_quote: float,
    pair_clip_size: float | None,
    maker_pair_threshold: float,
    remaining_action_slots: int,
    enabled: bool,
) -> tuple[list[dict[str, Any]], dict[str, Any] | None]:
    if not enabled or pair_clip_size is None or remaining_action_slots < 2:
        return [], None
    anchor_up = near_touch_quote(up_quote, quotes.get("up"))
    anchor_down = near_touch_quote(down_quote, quotes.get("down"))
    anchor_cost = round(anchor_up + anchor_down, 6)
    if anchor_cost > maker_pair_threshold:
        return [], None
    if abs(anchor_up - up_quote) < 1e-9 and abs(anchor_down - down_quote) < 1e-9:
        return [], None
    actions = [
        {
            "outcome": "Up",
            "quotedPrice": anchor_up,
            "size": pair_clip_size,
            "mode": "maker_anchor",
            "layer": 0,
            "projectedPairCost": anchor_cost,
        },
        {
            "outcome": "Down",
            "quotedPrice": anchor_down,
            "size": pair_clip_size,
            "mode": "maker_anchor",
            "layer": 0,
            "projectedPairCost": anchor_cost,
        },
    ]
    return actions, {
        "upQuote": anchor_up,
        "downQuote": anchor_down,
        "pairQuotedCost": anchor_cost,
    }


def decide_actions(
    *,
    event: dict[str, Any],
    state: InventoryState,
    session_context: dict[str, Any] | None,
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
    strategy_mode: str = "legacy",
    pair_par_threshold: float = 1.00,
    touch_rest_band: float = 0.02,
    max_one_sided_shares: float | None = None,
    hedge_affordability_capital: float | None = None,
    recently_cancelled_keys: dict[str, float] | None = None,
    reopen_cooldown_seconds: float = 0.0,
    now_ts: float | None = None,
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
    session_context = session_context or {}
    outstanding_up = float(session_context.get("outstandingUp") or 0.0)
    outstanding_down = float(session_context.get("outstandingDown") or 0.0)
    outstanding_residual_qty = float(session_context.get("outstandingResidualQty") or 0.0)
    projected = session_context.get("projected") or {}
    projected_residual_qty = float(projected.get("residualQty") or residual_qty)
    projected_residual_ratio = float(projected.get("residualRatio") or residual_ratio(state, clip_shares=clip_shares))
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
    outstanding_lagging = 0.0
    rebalance_needed_qty = residual_qty
    if lagging_side and lagging_quote is not None and lagging_avg is not None:
        outstanding_lagging = outstanding_down if lagging_side == "Down" else outstanding_up
        rebalance_needed_qty = max(0.0, residual_qty - outstanding_lagging)
        rebalance_cost = round(lagging_quote + lagging_avg, 6)
        rebalance_size = round_up_shares(
            max(
                rebalance_needed_qty,
                VENUE_MIN_ORDER_SHARES,
                min_order_notional / max(lagging_quote, 0.000001),
            )
        )
        can_rebalance = (
            rebalance_needed_qty > 0.01
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
        projected_residual_qty >= max(0.0, late_session_residual_threshold)
        and remaining <= max(0, late_session_residual_seconds)
    )
    session_ratio = max(float(quote_context["sessionResidualRatio"]), projected_residual_ratio)
    session_paired_blocked = (
        projected_residual_qty >= max(0.0, session_residual_stop_shares)
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
    outstanding_residual_up = max(0.0, outstanding_up - outstanding_down)
    outstanding_residual_down = max(0.0, outstanding_down - outstanding_up)
    available_pair_budget_up = max(0.0, effective_pair_budget_cap - outstanding_residual_up)
    available_pair_budget_down = max(0.0, effective_pair_budget_cap - outstanding_residual_down)
    available_pair_budget = min(available_pair_budget_up, available_pair_budget_down)
    maker_rebalance_threshold = max(rebalance_threshold, maker_pair_threshold)
    maker_rebalance_actions: list[dict[str, Any]] = []
    if lagging_side and lagging_quote is not None and lagging_avg is not None:
        maker_rebalance_actions = build_maker_rebalance_layers(
            lagging_side=lagging_side,
            lagging_avg=lagging_avg,
            lagging_quote=lagging_quote,
            residual_qty=rebalance_needed_qty,
            min_order_notional=min_order_notional,
            max_clip_shares=max_clip_shares,
            maker_layers=maker_layers,
            maker_price_step=maker_price_step,
            maker_rebalance_threshold=maker_rebalance_threshold,
            remaining_action_slots=effective_max_actions,
        )
    anchor_pair_enabled = (
        not session_paired_blocked
        and not late_session_residual_guard
        and enough_depth
        and pair_clip_ok
        and pair_clip_size is not None
        and pair_clip_size <= available_pair_budget + 1e-9
        and residual_qty <= max_residual_shares + 1e-9
    )
    anchor_pair_actions, anchor_pair_context = build_reference_like_anchor_pair(
        quotes=quotes,
        up_quote=up_quote,
        down_quote=down_quote,
        pair_clip_size=pair_clip_size,
        maker_pair_threshold=maker_pair_threshold,
        remaining_action_slots=effective_max_actions,
        enabled=anchor_pair_enabled,
    )
    maker_base_up = anchor_pair_context["upQuote"] if anchor_pair_context else up_quote
    maker_base_down = anchor_pair_context["downQuote"] if anchor_pair_context else down_quote
    maker_layers_effective = 1 if anchor_pair_actions else maker_layers

    # ── paired_below_par strategy ────────────────────────────────────
    # Hypothesis: the reference wallet is not predicting direction; it
    # is buying the binary package at price(Up)+price(Down) < 1.00 and
    # realizing through redeem. Therefore the engine should prioritize
    # paired entry whenever pair_cost < pair_par_threshold, NOT only
    # when a thin direct-edge gate (entry_threshold) is satisfied.
    #
    # Decisions inside this branch are still subject to the existing
    # max_residual_shares / projected-exposure / late-session guards,
    # but residual is now treated as a clip on the hot side rather
    # than a global freeze.
    #
    # Reason codes the measurement report can score:
    #   paired_below_par_active           — full-paired below par
    #   paired_below_par_touch_rest       — at-touch posting in
    #                                       [par-band, par)
    #   paired_below_par_one_sided_clip   — Up-leg or Down-leg blocked
    #                                       to avoid widening residual
    #   paired_below_par_reopen_cooldown  — key was just cancelled,
    #                                       skip recreate this cycle
    #   paired_below_par_hedge_affordability_block
    #   paired_below_par_blocked_residual — residual fully blocking
    #                                       entry (rebalance-only)
    #   paired_below_par_above_par        — pair_cost ≥ par + band
    cancelled_recently: set[str] = set()
    cooldown_evidence: list[dict[str, Any]] = []
    if recently_cancelled_keys and reopen_cooldown_seconds > 0 and now_ts is not None:
        for key, last_cancel_ts in recently_cancelled_keys.items():
            if now_ts - float(last_cancel_ts) < reopen_cooldown_seconds:
                cancelled_recently.add(str(key))

    def _filter_reopen(actions: list[dict[str, Any]]) -> list[dict[str, Any]]:
        """Drop actions whose ladder key was cancelled inside the cooldown."""
        if not cancelled_recently:
            return actions
        kept: list[dict[str, Any]] = []
        for a in actions:
            key = f"{a['outcome']}:{a.get('mode') or ''}:{int(a.get('layer') or 0)}"
            if key in cancelled_recently:
                cooldown_evidence.append(
                    {
                        "key": key,
                        "reason": "paired_below_par_reopen_cooldown",
                    }
                )
                continue
            kept.append(a)
        return kept

    def _hedge_affordable(action: dict[str, Any]) -> bool:
        """Stop placing rebalance/legged orders we cannot afford to fill."""
        if hedge_affordability_capital is None:
            return True
        notional = float(action.get("size", 0.0)) * float(action.get("quotedPrice", 0.0))
        return notional <= float(hedge_affordability_capital) + 1e-9

    one_sided_clips: list[dict[str, Any]] = []
    hedge_blocks: list[dict[str, Any]] = []
    paired_below_par_block_reason: str | None = None

    if strategy_mode == "paired_below_par" and pair_cost is not None and pair_clip_ok:
        # Outstanding-aware projected per-side exposure. The engine
        # treats outstanding as risk: if Up is already heavy, posting
        # another Up clip is one-sided accumulation — clip just that
        # leg, keep the Down leg.
        proj_up = state.up_qty + outstanding_up
        proj_down = state.down_qty + outstanding_down
        pair_under_par = pair_cost <= pair_par_threshold + 1e-9
        pair_in_touch_rest = (
            not pair_under_par
            and pair_cost <= pair_par_threshold + max(0.0, touch_rest_band) + 1e-9
        )

        if not enough_depth:
            paired_below_par_block_reason = "insufficient_bid_depth_within_band"
        elif late_session_residual_guard:
            paired_below_par_block_reason = "late_session_residual_guard"
        elif session_paired_blocked:
            paired_below_par_block_reason = "session_inventory_guard"
        elif pair_under_par or pair_in_touch_rest:
            # Touch-rest mode posts at the venue's current best bid
            # (no improve, no aggression). Below-par posts at the
            # planner's improved quote. Same shape, different price.
            base_up = up_quote
            base_down = down_quote
            if pair_in_touch_rest:
                touch_up = quotes.get("up")
                touch_down = quotes.get("down")
                if touch_up is not None:
                    base_up = round(float(touch_up.get("price", up_quote)), 6)
                if touch_down is not None:
                    base_down = round(float(touch_down.get("price", down_quote)), 6)

            candidates = [
                {
                    "outcome": "Up",
                    "quotedPrice": base_up,
                    "size": pair_clip_size,
                    "mode": "paired_below_par" if pair_under_par else "paired_touch_rest",
                    "layer": 0,
                    "projectedPairCost": round(base_up + base_down, 6),
                },
                {
                    "outcome": "Down",
                    "quotedPrice": base_down,
                    "size": pair_clip_size,
                    "mode": "paired_below_par" if pair_under_par else "paired_touch_rest",
                    "layer": 0,
                    "projectedPairCost": round(base_up + base_down, 6),
                },
            ]

            # Residual-as-repair, not residual-as-freeze: when residual
            # is already past the cap, allow only the leg that pairs
            # off the existing imbalance. We do NOT bail out; we clip.
            if residual_qty > max_residual_shares:
                heavy = residual_side  # "Up" or "Down"
                kept_candidates: list[dict[str, Any]] = []
                for cand in candidates:
                    if cand["outcome"] == heavy:
                        one_sided_clips.append(
                            {
                                "outcome": cand["outcome"],
                                "size": cand["size"],
                                "mode": cand["mode"],
                                "reason": "residual_repair_clip",
                                "residualSide": heavy,
                                "residualQty": round(residual_qty, 6),
                            }
                        )
                        continue
                    kept_candidates.append(cand)
                candidates = kept_candidates

            # Outstanding-skew clip: stop adding to whichever side is
            # already over the per-side cap.
            if max_one_sided_shares is not None:
                kept_candidates = []
                for cand in candidates:
                    side = cand["outcome"]
                    side_after = (
                        proj_up + (cand["size"] if side == "Up" else 0.0)
                        if side == "Up"
                        else proj_down + (cand["size"] if side == "Down" else 0.0)
                    )
                    if side_after > max_one_sided_shares + 1e-9:
                        one_sided_clips.append(
                            {
                                "outcome": side,
                                "size": cand["size"],
                                "mode": cand["mode"],
                                "reason": "one_sided_exposure_clip",
                                "projectedSide": round(side_after, 6),
                                "limit": round(max_one_sided_shares, 6),
                            }
                        )
                        continue
                    kept_candidates.append(cand)
                candidates = kept_candidates

            # Hedge-affordability gate (notional check on each leg).
            kept_candidates = []
            for cand in candidates:
                if _hedge_affordable(cand):
                    kept_candidates.append(cand)
                else:
                    hedge_blocks.append(
                        {
                            "outcome": cand["outcome"],
                            "size": cand["size"],
                            "price": cand["quotedPrice"],
                            "reason": "hedge_affordability_block",
                        }
                    )
            candidates = kept_candidates

            # Reopen-loop cooldown: if we just cancelled this key,
            # skip recreate this cycle.
            candidates = _filter_reopen(candidates)

            # Discriminate residual-repair clips from one-sided-cap
            # clips so the top-level reason can be precise. Both end
            # up in `one_sided_clips` for measurement, but the cause
            # is different and should map to a different reason code.
            had_residual_repair_clip = any(
                c.get("reason") == "residual_repair_clip"
                for c in one_sided_clips
            )
            had_one_sided_cap_clip = any(
                c.get("reason") == "one_sided_exposure_clip"
                for c in one_sided_clips
            )
            if candidates:
                decisions.extend(candidates[: max(0, effective_max_actions)])
                if pair_under_par:
                    reason = "paired_below_par_active"
                else:
                    reason = "paired_below_par_touch_rest"
                if had_residual_repair_clip:
                    reason = f"{reason}_with_residual_repair"
                elif had_one_sided_cap_clip:
                    reason = f"{reason}_with_one_sided_clip"
            elif hedge_blocks and not candidates:
                reason = "paired_below_par_hedge_affordability_block"
            elif cooldown_evidence and not candidates:
                reason = "paired_below_par_reopen_cooldown"
            elif had_one_sided_cap_clip:
                reason = "paired_below_par_one_sided_block"
            elif had_residual_repair_clip:
                reason = "paired_below_par_blocked_residual"
            # else: fall through to the legacy decision tree below.
        else:
            paired_below_par_block_reason = "paired_below_par_above_par"

        # If we generated decisions, we still want the rebalance leg
        # to fire alongside (residual repair as side-effect, not
        # primary). Append rebalance once if pending.
        if decisions and can_rebalance and _hedge_affordable({
            "size": rebalance_size,
            "quotedPrice": lagging_quote,
        }):
            decisions.append(
                {
                    "outcome": lagging_side,
                    "quotedPrice": lagging_quote,
                    "size": rebalance_size,
                    "mode": "rebalance",
                    "projectedPairCost": rebalance_cost,
                }
            )

    if not decisions and strategy_mode == "paired_below_par":
        # Strategy ran but produced no actions; record the reason for
        # measurement reporting before falling through.
        if paired_below_par_block_reason and reason == "hold":
            reason = paired_below_par_block_reason

    # When the new strategy fired an anti-pattern guard
    # (one-sided exposure / hedge affordability / reopen cooldown),
    # we must NOT fall through to the permissive legacy tree — that
    # would re-emit exactly the action the guard just blocked. Setting
    # an explicit reason here makes the block visible to scoring.
    paired_below_par_guard_fired = (
        strategy_mode == "paired_below_par"
        and not decisions
        and bool(one_sided_clips or hedge_blocks or cooldown_evidence)
    )
    if paired_below_par_guard_fired and reason == "hold":
        if hedge_blocks:
            reason = "paired_below_par_hedge_affordability_block"
        elif cooldown_evidence:
            reason = "paired_below_par_reopen_cooldown"
        else:
            reason = "paired_below_par_one_sided_block"

    if not decisions and not paired_below_par_guard_fired:
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
                remaining_slots = max(0, effective_max_actions - len(decisions))
                anchor_actions_for_pair = anchor_pair_actions[:remaining_slots]
                if anchor_actions_for_pair:
                    decisions.extend(anchor_actions_for_pair)
                maker_pair_actions = cap_actions_by_outcome_budget(
                    build_maker_paired_layers(
                        up_base=maker_base_up,
                        down_base=maker_base_down,
                        clip_shares=clip_shares,
                        min_order_notional=min_order_notional,
                        max_clip_shares=max_clip_shares,
                        maker_layers=maker_layers_effective,
                        maker_price_step=maker_price_step,
                        maker_pair_threshold=maker_pair_threshold,
                        maker_layer_size_ratio=maker_layer_size_ratio,
                        remaining_action_slots=max(0, effective_max_actions - len(decisions)),
                        include_base_layer=False,
                    ),
                    per_outcome_budget=max(
                        0.0,
                        available_pair_budget
                        - pair_clip_size
                        - (pair_clip_size if anchor_actions_for_pair else 0.0),
                    ),
                )
                if maker_pair_actions:
                    decisions.extend(maker_pair_actions)
                    reason = "hybrid_paired_anchor_maker" if anchor_actions_for_pair else "hybrid_paired_maker"
                elif anchor_actions_for_pair:
                    reason = "reference_like_anchor_pair"
                else:
                    reason = "paired_bid_edge"
            elif (
                pair_cost is not None
                and enough_depth
                and build_maker_paired_layers(
                    up_base=maker_base_up,
                    down_base=maker_base_down,
                    clip_shares=clip_shares,
                    min_order_notional=min_order_notional,
                    max_clip_shares=max_clip_shares,
                    maker_layers=maker_layers_effective,
                    maker_price_step=maker_price_step,
                    maker_pair_threshold=maker_pair_threshold,
                    maker_layer_size_ratio=maker_layer_size_ratio,
                    remaining_action_slots=effective_max_actions,
                    include_base_layer=not anchor_pair_actions,
                )
            ):
                decisions.extend(
                    cap_actions_by_outcome_budget(
                        anchor_pair_actions
                        + build_maker_paired_layers(
                            up_base=maker_base_up,
                            down_base=maker_base_down,
                            clip_shares=clip_shares,
                            min_order_notional=min_order_notional,
                            max_clip_shares=max_clip_shares,
                            maker_layers=maker_layers_effective,
                            maker_price_step=maker_price_step,
                            maker_pair_threshold=maker_pair_threshold,
                            maker_layer_size_ratio=maker_layer_size_ratio,
                            remaining_action_slots=effective_max_actions,
                            include_base_layer=not anchor_pair_actions,
                        ),
                        per_outcome_budget=available_pair_budget,
                    )
                )
                reason = (
                    "reference_like_maker_ladder"
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
        "outstandingExposure": {
            "up": round(outstanding_up, 6),
            "down": round(outstanding_down, 6),
            "residualQty": round(outstanding_residual_qty, 6),
        },
        "projectedResidualQty": round(projected_residual_qty, 6),
        "projectedResidualRatio": round(projected_residual_ratio, 6),
        "sessionPairedBlocked": session_paired_blocked,
        "sessionAvailablePairBudget": round(available_pair_budget, 6),
        "sessionAvailablePairBudgetByOutcome": {
            "up": round(available_pair_budget_up, 6),
            "down": round(available_pair_budget_down, 6),
        },
        "effectivePairBudgetCap": round(effective_pair_budget_cap, 6),
        "effectiveMaxActions": effective_max_actions,
        "earlySessionActive": early_session_active,
        "anchorPairEnabled": anchor_pair_enabled,
        "effectiveMakerLayers": maker_layers_effective,
        "anchorPairContext": anchor_pair_context,
        "quoteContext": quote_context,
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
    for action in actions:
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

    return {
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
            "watchSeconds": args.watch_seconds,
            "residualWatchSeconds": args.residual_watch_seconds,
            "pollSeconds": args.poll_seconds,
            "restSeconds": args.rest_seconds,
            "sessionOrderTtlSeconds": None,
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
    session_open_orders: list[WorkingOrder] = []
    seen_fill_hashes: set[str] = set()
    # paired_below_par strategy — keep a per-key wall-clock timestamp
    # of the last time a key was cancelled, so reopen-loop cooldown
    # can suppress immediate recreation. Empty for legacy mode.
    session_recent_cancels: dict[str, float] = {}
    session_order_ttl = max(
        15.0,
        args.poll_seconds * 6.0,
        (args.rest_seconds if args.live_ok else 0.0) + args.poll_seconds + 1.0,
    )
    summary["parameters"]["sessionOrderTtlSeconds"] = round(session_order_ttl, 3)

    while time.time() < deadline:
        cycle_index += 1
        now_ts = time.time()
        session_open_orders = prune_expired_orders(session_open_orders, now_ts)
        market_books = RestPollingMarketFeed().fetch_event_books(event)
        fills = fetch_wallet_trades(
            wallet=wallet_address,
            slug=event["slug"],
            since_timestamp=start_timestamp,
        )
        merged_cycle_fills = merge_fills(fills, inferred_fills)
        new_fill_rows = []
        for fill in merged_cycle_fills:
            if fill.transaction_hash in seen_fill_hashes:
                continue
            seen_fill_hashes.add(fill.transaction_hash)
            new_fill_rows.append(
                {
                    "outcome": fill.outcome,
                    "size": fill.size,
                    "price": fill.price,
                    "timestamp": fill.timestamp,
                    "transactionHash": fill.transaction_hash,
                }
            )
        session_open_orders = consume_working_order_fills(
            session_open_orders,
            new_fill_rows,
            now_ts=now_ts,
        )
        state = compute_inventory_state(merged_cycle_fills)
        session_context = session_risk_context(
            state=state,
            working_orders=session_open_orders,
            clip_shares=args.clip_shares,
            now_ts=now_ts,
        )
        quotes = snapshot_quotes(
            up_book=market_books.up_book,
            down_book=market_books.down_book,
            clip_shares=args.clip_shares,
            bid_improve=args.bid_improve,
            depth_band=args.depth_band,
            min_depth_ratio=args.min_depth_ratio,
            min_best_level_ratio=args.min_best_level_ratio,
        )
        decision = decide_actions(
            event=event,
            state=state,
            session_context=session_context,
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
            strategy_mode=args.strategy_mode,
            pair_par_threshold=args.pair_par_threshold,
            touch_rest_band=args.touch_rest_band,
            max_one_sided_shares=args.max_one_sided_shares,
            hedge_affordability_capital=args.hedge_affordability_capital,
            recently_cancelled_keys=session_recent_cancels,
            reopen_cooldown_seconds=args.reopen_cooldown_seconds,
            now_ts=time.time(),
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
            "sessionRiskBeforeDecision": session_context,
            "quotes": quotes,
            "decision": decision,
            "targetLadder": ladder_summary(decision["actions"]),
            "workingOrdersBeforeCycle": [row.to_dict() for row in session_open_orders],
        }

        session_open_orders, ladder_reconcile = reconcile_orders(
            existing_orders=session_open_orders,
            actions=decision["actions"],
            now_ts=now_ts,
            ttl_seconds=session_order_ttl,
            cycle_index=cycle_index,
            slug=event["slug"],
        )
        cycle["ladderReconcile"] = ladder_reconcile
        cycle["workingOrdersAfterDecision"] = [row.to_dict() for row in session_open_orders]
        cycle["sessionRiskAfterDecision"] = session_risk_context(
            state=state,
            working_orders=session_open_orders,
            clip_shares=args.clip_shares,
            now_ts=now_ts,
        )

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
            )
            cycle["execution"] = execution
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
            session_open_orders = []
            cycle["workingOrdersAfterCleanup"] = []
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
