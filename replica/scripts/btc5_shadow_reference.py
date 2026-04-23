from __future__ import annotations

import argparse
import csv
import json
import math
import time
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

import requests

from btc5_ladder_manager import (
    WorkingOrder,
    compute_outstanding_exposure,
    ladder_summary,
    project_residual_if_all_fill,
    prune_expired_orders,
    reconcile_orders,
)
from btc5_market_feed import RestPollingMarketFeed
from resolve_next_btc5 import resolve
from run_replica_btc5_accumulator import (
    FillRecord,
    compute_inventory_state,
    decide_actions,
    fetch_wallet_trades,
    serialize_fills,
    snapshot_quotes,
)


REFERENCE_WALLET = "0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82"
BOT_WALLET = "0x31d39De926465dc288948846efc44Bfe64914399"
TRADES_URL = "https://data-api.polymarket.com/trades"
EVENTS_URL = "https://gamma-api.polymarket.com/events"
WINDOW_SECONDS = 300.0
DEFAULT_NETWORK_RETRIES = 4
DEFAULT_NETWORK_BACKOFF_SECONDS = 1.5


@dataclass(frozen=True)
class WalletTrade:
    slug: str
    outcome: str
    side: str
    size: float
    price: float
    timestamp: int
    transaction_hash: str


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def default_output_dir() -> Path:
    return repo_root() / ".generated"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Record BTC5 shadow-vs-reference sessions and generate reusable recent-window "
            "forensics for the reference wallet and our bot wallet."
        )
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    record = subparsers.add_parser(
        "record",
        help=(
            "Run a local shadow recorder for consecutive BTC5 windows, then compare our "
            "paper decisions against the reference wallet's real fills."
        ),
    )
    record.add_argument("--duration-minutes", type=float, default=60.0)
    record.add_argument("--poll-seconds", type=float, default=1.0)
    record.add_argument("--lookahead-windows", type=int, default=6)
    record.add_argument("--reference-wallet", default=REFERENCE_WALLET)
    record.add_argument("--output-dir", default=str(default_output_dir()))
    record.add_argument("--prefix", default="btc5-shadow-vs-reference")
    add_strategy_args(record)

    forensics = subparsers.add_parser(
        "forensics",
        help=(
            "Refresh recent BTC5 per-window forensics for the reference wallet and our bot."
        ),
    )
    forensics.add_argument("--hours", type=float, default=3.0)
    forensics.add_argument("--reference-wallet", default=REFERENCE_WALLET)
    forensics.add_argument("--bot-wallet", default=BOT_WALLET)
    forensics.add_argument("--max-pages", type=int, default=12)
    forensics.add_argument("--page-size", type=int, default=500)
    forensics.add_argument("--output-dir", default=str(default_output_dir()))
    forensics.add_argument("--prefix", default="reference_wallet_vs_bot_forensics")
    return parser.parse_args()


def add_strategy_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--clip-shares", type=float, default=5.0)
    parser.add_argument("--entry-threshold", type=float, default=0.98)
    parser.add_argument("--rebalance-threshold", type=float, default=0.98)
    parser.add_argument("--max-residual-shares", type=float, default=5.0)
    parser.add_argument("--late-session-residual-seconds", type=int, default=90)
    parser.add_argument("--late-session-residual-threshold", type=float, default=1.0)
    parser.add_argument("--session-residual-stop-shares", type=float, default=5.0)
    parser.add_argument("--session-residual-stop-ratio", type=float, default=0.25)
    parser.add_argument("--inventory-skew-step", type=float, default=0.01)
    parser.add_argument("--inventory-skew-trigger-shares", type=float, default=5.0)
    parser.add_argument("--early-session-seconds", type=int, default=120)
    parser.add_argument("--early-session-flat-residual-threshold", type=float, default=1.0)
    parser.add_argument("--early-session-pair-budget", type=float, default=20.0)
    parser.add_argument("--early-session-max-actions", type=int, default=8)
    parser.add_argument("--maker-layers", type=int, default=3)
    parser.add_argument("--maker-price-step", type=float, default=0.01)
    parser.add_argument("--maker-pair-threshold", type=float, default=1.02)
    parser.add_argument("--maker-layer-size-ratio", type=float, default=0.5)
    parser.add_argument("--max-actions-per-cycle", type=int, default=6)
    # Milestone 1 — same flag name as the accumulator so shadow runs
    # validate the identical check the live path will use.
    parser.add_argument(
        "--projected-exposure-limit-shares",
        type=float,
        default=0.0,
        help=(
            "If > 0, clip any new shadow target that would push "
            "projected post-fill residual (filled + all outstanding) "
            "past this many shares. Mirrors the accumulator knob."
        ),
    )
    # Milestone 2 mirrors — price-band hysteresis + phase boundaries.
    parser.add_argument("--quote-price-band-ticks", type=int, default=0)
    parser.add_argument("--quote-size-band-shares", type=float, default=0.0)
    parser.add_argument("--late-phase-seconds", type=int, default=120)
    parser.add_argument("--flatten-phase-seconds", type=int, default=60)
    parser.add_argument("--bid-improve", type=float, default=0.0)
    parser.add_argument("--depth-band", type=float, default=0.02)
    parser.add_argument("--min-depth-ratio", type=float, default=1.5)
    parser.add_argument("--min-best-level-ratio", type=float, default=0.5)
    parser.add_argument("--min-order-notional", type=float, default=1.0)
    parser.add_argument("--max-clip-shares", type=float, default=10.0)
    parser.add_argument("--min-seconds-left", type=int, default=30)
    parser.add_argument(
        "--shadow-rest-seconds",
        type=float,
        default=1.25,
        help="Legacy shadow delay after a decision cycle. Retained for compatibility.",
    )
    parser.add_argument(
        "--shadow-order-ttl-seconds",
        type=float,
        default=15.0,
        help="How long a shadow ladder order remains working before the recorder expires it.",
    )


def log_retry_event(event: str, **fields: Any) -> None:
    payload = {"event": event, "timestampUtc": now_utc_iso(), **fields}
    print(json.dumps(payload))


def retry_call(
    label: str,
    func,
    *,
    attempts: int = DEFAULT_NETWORK_RETRIES,
    backoff_seconds: float = DEFAULT_NETWORK_BACKOFF_SECONDS,
    retry_exceptions: tuple[type[BaseException], ...] = (Exception,),
):
    last_error: BaseException | None = None
    attempts = max(1, attempts)
    for attempt in range(1, attempts + 1):
        try:
            return func()
        except retry_exceptions as exc:
            last_error = exc
            if attempt >= attempts:
                raise
            sleep_for = max(0.25, backoff_seconds * attempt)
            log_retry_event(
                "shadow_retry",
                label=label,
                attempt=attempt,
                maxAttempts=attempts,
                sleepSeconds=round(sleep_for, 3),
                error=f"{type(exc).__name__}: {exc}",
            )
            time.sleep(sleep_for)
    if last_error is not None:
        raise last_error
    raise RuntimeError(f"{label} failed without raising an exception")


def fetch_json(url: str, *, params: dict[str, Any]) -> Any:
    def _request() -> Any:
        response = requests.get(url, params=params, timeout=30)
        response.raise_for_status()
        return response.json()

    return retry_call(
        "fetch_json",
        _request,
        retry_exceptions=(requests.exceptions.RequestException,),
    )


def parse_timestamp(raw: Any) -> int:
    try:
        value = int(raw)
    except (TypeError, ValueError):
        raise ValueError(f"invalid timestamp: {raw!r}") from None
    if value > 10_000_000_000:
        value //= 1000
    return value


def iso_to_timestamp(value: str) -> int:
    return int(datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp())


def btc5_start_timestamp_from_slug(slug: str) -> int | None:
    try:
        return int(str(slug).rsplit("-", 1)[-1])
    except (TypeError, ValueError):
        return None


def fetch_event_by_slug(slug: str) -> dict[str, Any]:
    payload = fetch_json(EVENTS_URL, params={"slug": slug})
    if not isinstance(payload, list) or not payload:
        raise RuntimeError(f"No event returned for slug {slug}")
    return payload[0]


def market_from_event(event: dict[str, Any]) -> dict[str, Any]:
    markets = event.get("markets") or []
    if not markets:
        raise RuntimeError(f"Event {event.get('slug')} has no markets")
    return markets[0]


def parse_json_list(value: Any) -> list[Any]:
    if isinstance(value, list):
        return value
    if isinstance(value, str):
        return json.loads(value)
    return []


def winner_from_event(event: dict[str, Any]) -> str | None:
    market = market_from_event(event)
    outcomes = [str(row) for row in parse_json_list(market.get("outcomes"))]
    prices = [str(row) for row in parse_json_list(market.get("outcomePrices"))]
    if not outcomes or len(outcomes) != len(prices):
        return None
    for index, price in enumerate(prices):
        if price in {"1", "1.0"}:
            return outcomes[index]
    return None


def window_seconds(event: dict[str, Any]) -> float:
    start_ts = btc5_start_timestamp_from_slug(str(event.get("slug") or ""))
    if start_ts is None:
        return WINDOW_SECONDS
    return WINDOW_SECONDS


def recent_btc5_wallet_trades(
    wallet: str,
    *,
    cutoff_timestamp: int,
    max_pages: int,
    page_size: int,
) -> list[WalletTrade]:
    rows: list[WalletTrade] = []
    offset = 0
    for _ in range(max_pages):
        def _request_page() -> requests.Response:
            return requests.get(
                TRADES_URL,
                params={
                    "user": wallet,
                    "limit": page_size,
                    "offset": offset,
                    "takerOnly": "false",
                },
                timeout=30,
            )

        response = retry_call(
            "recent_btc5_wallet_trades",
            _request_page,
            retry_exceptions=(requests.exceptions.RequestException,),
        )
        if response.status_code == 400:
            break
        response.raise_for_status()
        payload = response.json()
        if not isinstance(payload, list) or not payload:
            break
        oldest = None
        for raw in payload:
            try:
                slug = str(raw.get("slug") or raw.get("eventSlug") or "")
                timestamp = parse_timestamp(raw["timestamp"])
                outcome = str(raw.get("outcome") or "")
                side = str(raw.get("side") or "")
                size = float(raw["size"])
                price = float(raw["price"])
                tx_hash = str(raw.get("transactionHash") or f"{timestamp}:{outcome}:{size}:{price}")
            except (KeyError, TypeError, ValueError):
                continue
            oldest = timestamp if oldest is None else min(oldest, timestamp)
            if timestamp < cutoff_timestamp:
                continue
            if not slug.startswith("btc-updown-5m-"):
                continue
            if side != "BUY":
                continue
            rows.append(
                WalletTrade(
                    slug=slug,
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
        if oldest is not None and oldest < cutoff_timestamp:
            break
        offset += page_size
    rows.sort(key=lambda row: (row.timestamp, row.transaction_hash))
    return rows


def group_trades_by_slug(rows: list[WalletTrade]) -> dict[str, list[WalletTrade]]:
    grouped: dict[str, list[WalletTrade]] = defaultdict(list)
    for row in rows:
        grouped[row.slug].append(row)
    return grouped


def fills_from_wallet_trades(rows: list[WalletTrade]) -> list[FillRecord]:
    return [
        FillRecord(
            outcome=row.outcome,
            side=row.side,
            size=row.size,
            price=row.price,
            timestamp=row.timestamp,
            transaction_hash=row.transaction_hash,
        )
        for row in rows
    ]


def window_summary_from_fills(
    *,
    slug: str,
    title: str,
    event: dict[str, Any],
    fills: list[FillRecord],
    distinct_tx: int,
) -> dict[str, Any]:
    state = compute_inventory_state(fills)
    market_seconds = window_seconds(event)
    winner = winner_from_event(event)
    paired_pnl = None
    residual_pnl = None
    total_pnl = None
    if winner and state.paired_avg_cost is not None:
        paired_pnl = state.paired_qty * (1.0 - state.paired_avg_cost)
        residual_avg = state.up_avg if state.residual_side == "Up" else state.down_avg
        if residual_avg is None:
            residual_pnl = 0.0
        elif state.residual_side == winner:
            residual_pnl = state.residual_qty * (1.0 - residual_avg)
        else:
            residual_pnl = -state.residual_qty * residual_avg
        total_pnl = paired_pnl + residual_pnl
    return {
        "slug": slug,
        "title": title,
        "trade_rows": len(fills),
        "distinct_tx": distinct_tx,
        "rows_per_sec": len(fills) / max(1.0, market_seconds),
        "combined_buy_avg": state.paired_avg_cost,
        "paired_qty": state.paired_qty,
        "residual_side": state.residual_side,
        "residual_qty": state.residual_qty,
        "winner": winner,
        "paired_pnl_if_hold": paired_pnl,
        "residual_pnl_if_hold": residual_pnl,
        "total_pnl_if_hold": total_pnl,
    }


def round_or_none(value: float | None, digits: int = 6) -> float | None:
    if value is None:
        return None
    return round(value, digits)


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def write_markdown(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def summarize_wallet_windows(
    *,
    wallet: str,
    grouped: dict[str, list[WalletTrade]],
    event_cache: dict[str, dict[str, Any]],
) -> list[dict[str, Any]]:
    windows: list[dict[str, Any]] = []
    for slug, rows in grouped.items():
        event = event_cache.setdefault(slug, fetch_event_by_slug(slug))
        summary = window_summary_from_fills(
            slug=slug,
            title=str(event.get("title") or slug),
            event=event,
            fills=fills_from_wallet_trades(rows),
            distinct_tx=len({row.transaction_hash for row in rows}),
        )
        windows.append(summary)
    windows.sort(key=lambda row: row["slug"])
    return windows


def render_forensics_markdown(payload: dict[str, Any]) -> str:
    lines = [
        "# BTC5 Reference Wallet vs Bot Forensics",
        "",
        f"Reference wallet: `{payload['reference_wallet']}`",
        f"Bot wallet: `{payload['bot_wallet']}`",
        "",
        "## Reference Wallet Recent Windows",
        "",
        "| Window | Trade rows | Distinct tx | Rows/sec | Combined avg | Residual | PnL if held |",
        "|---|---:|---:|---:|---:|---|---:|",
    ]
    for row in payload["reference_windows"]:
        residual = (
            "-"
            if row["residual_side"] is None
            else f"{row['residual_side']} {row['residual_qty']:.2f}"
        )
        pnl = "+0.00" if row["total_pnl_if_hold"] is None else f"{row['total_pnl_if_hold']:+.2f}"
        avg = 0.0 if row["combined_buy_avg"] is None else row["combined_buy_avg"]
        lines.append(
            f"| {row['title']} | {row['trade_rows']} | {row['distinct_tx']} | "
            f"{row['rows_per_sec']:.2f} | {avg:.4f} | {residual} | {pnl} |"
        )
    lines.extend(
        [
            "",
            "## Bot Live Sessions",
            "",
            "| Window | Public fills | Combined avg | Residual | PnL if held |",
            "|---|---:|---:|---|---:|",
        ]
    )
    for row in payload["bot_windows"]:
        residual = (
            "-"
            if row["residual_side"] is None
            else f"{row['residual_side']} {row['residual_qty']:.2f}"
        )
        pnl = "+0.00" if row["total_pnl_if_hold"] is None else f"{row['total_pnl_if_hold']:+.2f}"
        avg = 0.0 if row["combined_buy_avg"] is None else row["combined_buy_avg"]
        lines.append(
            f"| {row['title']} | {row['trade_rows']} | {avg:.4f} | {residual} | {pnl} |"
        )
    lines.extend(
        [
            "",
            "## Key Difference",
            "",
            "- The reference wallet often drives far more executed flow per window while keeping the session-level combined average near or below 1.00.",
            "- Our bot often finds attractive paired prices too, but its residual inventory still stays too large relative to paired size in bad sessions.",
            "",
        ]
    )
    return "\n".join(lines)


def cmd_forensics(args: argparse.Namespace) -> int:
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    cutoff = int(time.time() - max(0.0, args.hours) * 3600)
    event_cache: dict[str, dict[str, Any]] = {}
    reference_rows = recent_btc5_wallet_trades(
        args.reference_wallet,
        cutoff_timestamp=cutoff,
        max_pages=args.max_pages,
        page_size=args.page_size,
    )
    bot_rows = recent_btc5_wallet_trades(
        args.bot_wallet,
        cutoff_timestamp=cutoff,
        max_pages=args.max_pages,
        page_size=args.page_size,
    )
    payload = {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "cutoff_timestamp": cutoff,
        "reference_wallet": args.reference_wallet,
        "bot_wallet": args.bot_wallet,
        "reference_windows": summarize_wallet_windows(
            wallet=args.reference_wallet,
            grouped=group_trades_by_slug(reference_rows),
            event_cache=event_cache,
        ),
        "bot_windows": summarize_wallet_windows(
            wallet=args.bot_wallet,
            grouped=group_trades_by_slug(bot_rows),
            event_cache=event_cache,
        ),
    }
    day_stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    json_path = output_dir / f"{args.prefix}_{day_stamp}.json"
    md_path = output_dir / f"{args.prefix}_{day_stamp}.md"
    write_json(json_path, payload)
    write_markdown(md_path, render_forensics_markdown(payload))
    print(json.dumps({"json": str(json_path), "markdown": str(md_path)}, indent=2))
    return 0


def counter_dict(rows: list[str]) -> dict[str, int]:
    return dict(sorted(Counter(rows).items()))


def summarize_shadow_window(session: dict[str, Any], event: dict[str, Any], reference_fills: list[FillRecord]) -> dict[str, Any]:
    shadow_fills: list[FillRecord] = session["shadowFills"]
    shadow_state = compute_inventory_state(shadow_fills)
    reference_state = compute_inventory_state(reference_fills)
    shadow_actions = session["shadowActions"]
    shadow_targets = session["shadowTargets"]
    first_shadow_action_ts = min((row["timestamp"] for row in shadow_targets), default=None)
    first_reference_ts = min((row.timestamp for row in reference_fills), default=None)
    start_ts = session["startTimestamp"]
    best_pair_quote = min(
        (cycle["quotes"]["pairQuotedCost"] for cycle in session["cycles"] if cycle["quotes"].get("pairQuotedCost") is not None),
        default=None,
    )
    return {
        "slug": event["slug"],
        "title": event["title"],
        "windowComplete": session["windowComplete"],
        "marketStartUtc": session["marketStartUtc"],
        "marketEndUtc": session["marketEndUtc"],
        "cycles": len(session["cycles"]),
        "shadowActionCount": len(shadow_actions),
        "shadowTargetCount": len(shadow_targets),
        "shadowFillCount": len(shadow_fills),
        "shadowOperationMix": counter_dict([str(row["operation"]) for row in shadow_actions]),
        "shadowActionModes": counter_dict([str(row["mode"]) for row in shadow_actions]),
        "shadowDecisionReasons": counter_dict([str(row["decision"]["reason"]) for row in session["cycles"]]),
        "shadowFirstActionSeconds": None
        if first_shadow_action_ts is None
        else round(first_shadow_action_ts - start_ts, 3),
        "referenceTradeRows": len(reference_fills),
        "referenceDistinctTx": len({row.transaction_hash for row in reference_fills}),
        "referenceRowsPerSec": round(len(reference_fills) / max(1.0, window_seconds(event)), 6),
        "referenceFirstTradeSeconds": None
        if first_reference_ts is None
        else round(first_reference_ts - start_ts, 3),
        "bestPairQuoteSeen": best_pair_quote,
        "shadowFinalState": {
            "pairedQty": round(shadow_state.paired_qty, 6),
            "pairedAvgCost": round_or_none(shadow_state.paired_avg_cost),
            "residualSide": shadow_state.residual_side,
            "residualQty": round(shadow_state.residual_qty, 6),
        },
        "referenceFinalState": {
            "pairedQty": round(reference_state.paired_qty, 6),
            "pairedAvgCost": round_or_none(reference_state.paired_avg_cost),
            "residualSide": reference_state.residual_side,
            "residualQty": round(reference_state.residual_qty, 6),
        },
    }


def render_shadow_markdown(payload: dict[str, Any]) -> str:
    lines = [
        "# BTC5 Shadow vs Reference Recorder",
        "",
        f"Generated: `{payload['generatedAtUtc']}`",
        f"Reference wallet: `{payload['referenceWallet']}`",
        "",
        "The shadow fill model below is heuristic: paper orders are treated as fillable only when later reference-wallet trade prints hit the same outcome at or below our quoted bid while the paper order is still live. It is not queue-aware.",
        "",
        "## Window Summary",
        "",
        "| Window | Ref rows | Ref tx | Shadow ops | Shadow targets | Shadow fills | First shadow action (s) | First ref trade (s) | Best pair quote | Shadow residual |",
        "|---|---:|---:|---:|---:|---:|---:|---:|---|",
    ]
    for row in payload["windows"]:
        residual = row["shadowFinalState"]["residualSide"]
        residual_text = (
            "-"
            if residual is None
            else f"{residual} {row['shadowFinalState']['residualQty']:.2f}"
        )
        lines.append(
            f"| {row['title']} | {row['referenceTradeRows']} | {row['referenceDistinctTx']} | "
            f"{row['shadowActionCount']} | {row['shadowTargetCount']} | {row['shadowFillCount']} | "
            f"{row['shadowFirstActionSeconds'] if row['shadowFirstActionSeconds'] is not None else '-'} | "
            f"{row['referenceFirstTradeSeconds'] if row['referenceFirstTradeSeconds'] is not None else '-'} | "
            f"{row['bestPairQuoteSeen'] if row['bestPairQuoteSeen'] is not None else '-'} | {residual_text} |"
        )
    lines.extend(
        [
            "",
            "## Aggregate Signals",
            "",
            f"- Windows recorded: `{payload['aggregate']['windowCount']}`",
            f"- Total shadow actions: `{payload['aggregate']['shadowActionCount']}`",
            f"- Total shadow fills (heuristic): `{payload['aggregate']['shadowFillCount']}`",
            f"- Total reference trade rows: `{payload['aggregate']['referenceTradeRows']}`",
            f"- Median reference rows/window: `{payload['aggregate']['medianReferenceRowsPerWindow']}`",
            f"- Median shadow actions/window: `{payload['aggregate']['medianShadowActionsPerWindow']}`",
            "",
        ]
    )
    return "\n".join(lines)


def now_utc_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def prune_shadow_orders(session: dict[str, Any], now_ts: float) -> None:
    session["openOrders"] = prune_expired_orders(session["openOrders"], now_ts)


def match_shadow_orders(session: dict[str, Any], new_reference_fills: list[FillRecord]) -> None:
    if not new_reference_fills:
        return
    open_orders: list[WorkingOrder] = session["openOrders"]
    for fill in new_reference_fills:
        available = fill.size
        if available <= 0:
            continue
        for order in open_orders:
            if available <= 1e-9:
                break
            if order.remaining_size <= 1e-9:
                continue
            if order.outcome != fill.outcome:
                continue
            if fill.timestamp + 1e-9 < order.created_timestamp:
                continue
            if fill.timestamp - 1e-9 > order.expires_timestamp:
                continue
            if fill.price - 1e-9 > order.price:
                continue
            matched = min(available, order.remaining_size)
            session["shadowFills"].append(
                FillRecord(
                    outcome=order.outcome,
                    side="BUY",
                    size=matched,
                    price=order.price,
                    timestamp=fill.timestamp,
                    transaction_hash=f"shadow:{order.order_id}:{fill.transaction_hash}:{len(session['shadowFills'])}",
                )
            )
            available -= matched
            order.remaining_size -= matched
    prune_shadow_orders(session, time.time())


def fetch_reference_fills_for_session(session: dict[str, Any], wallet: str) -> list[FillRecord]:
    return fetch_wallet_trades(
        wallet=wallet,
        slug=session["event"]["slug"],
        since_timestamp=session["startTimestamp"],
        max_pages=4,
        page_size=500,
    )


def resilient_reference_fills(session: dict[str, Any], wallet: str) -> tuple[list[FillRecord], dict[str, Any] | None]:
    try:
        fills = retry_call(
            "fetch_reference_fills",
            lambda: fetch_reference_fills_for_session(session, wallet),
        )
        session["latestReferenceFills"] = fills
        return fills, None
    except Exception as exc:  # pragma: no cover - defensive network fallback
        fallback = list(session.get("latestReferenceFills") or [])
        warning = {
            "kind": "reference_fills_stale",
            "error": f"{type(exc).__name__}: {exc}",
            "fallbackCount": len(fallback),
        }
        log_retry_event("shadow_warning", **warning)
        return fallback, warning


def resilient_market_books(event: dict[str, Any]) -> tuple[Any | None, dict[str, Any] | None]:
    try:
        books = retry_call(
            "fetch_market_books",
            lambda: RestPollingMarketFeed().fetch_event_books(event),
        )
        return books, None
    except Exception as exc:  # pragma: no cover - defensive network fallback
        warning = {
            "kind": "market_books_unavailable",
            "error": f"{type(exc).__name__}: {exc}",
        }
        log_retry_event("shadow_warning", **warning)
        return None, warning


def resilient_event_refresh(session: dict[str, Any]) -> tuple[dict[str, Any], dict[str, Any] | None]:
    try:
        event = retry_call(
            "fetch_event_by_slug",
            lambda: fetch_event_by_slug(session["event"]["slug"]),
        )
        return event, None
    except Exception as exc:  # pragma: no cover - defensive network fallback
        warning = {
            "kind": "event_refresh_stale",
            "error": f"{type(exc).__name__}: {exc}",
            "slug": session["event"]["slug"],
        }
        log_retry_event("shadow_warning", **warning)
        return dict(session["event"]), warning


def start_shadow_session(event: dict[str, Any]) -> dict[str, Any]:
    start_ts = btc5_start_timestamp_from_slug(event["slug"])
    if start_ts is None:
        raise RuntimeError(f"Could not derive BTC5 start timestamp from {event['slug']}")
    end_ts = start_ts + int(WINDOW_SECONDS)
    return {
        "event": event,
        "marketStartUtc": datetime.fromtimestamp(start_ts, tz=timezone.utc).isoformat(),
        "marketEndUtc": datetime.fromtimestamp(end_ts, tz=timezone.utc).isoformat(),
        "startTimestamp": start_ts,
        "endTimestamp": end_ts,
        "cycles": [],
        "shadowActions": [],
        "shadowTargets": [],
        "shadowFills": [],
        "openOrders": [],
        "referenceSeenHashes": set(),
        "latestReferenceFills": [],
        "windowComplete": False,
    }


def step_shadow_session(session: dict[str, Any], args: argparse.Namespace, cycle_index: int) -> float:
    now_ts = time.time()
    prune_shadow_orders(session, now_ts)
    reference_fills, reference_warning = resilient_reference_fills(session, args.reference_wallet)
    new_reference_fills = [
        row
        for row in reference_fills
        if row.transaction_hash not in session["referenceSeenHashes"]
    ]
    for row in new_reference_fills:
        session["referenceSeenHashes"].add(row.transaction_hash)
    match_shadow_orders(session, new_reference_fills)
    state = compute_inventory_state(session["shadowFills"])
    event = session["event"]
    market_books, market_warning = resilient_market_books(event)
    if market_books is None:
        seconds_left = max(0, session["endTimestamp"] - int(time.time()))
        cycle = {
            "cycle": cycle_index,
            "timestampUtc": now_utc_iso(),
            "secondsLeft": seconds_left,
            "inventory": state.to_dict(),
            "quotes": {},
            "decision": {
                "secondsLeft": seconds_left,
                "reason": "market_data_unavailable",
                "actions": [],
            },
        }
        warnings = [warning for warning in (reference_warning, market_warning) if warning]
        if warnings:
            cycle["warnings"] = warnings
        session["cycles"].append(cycle)
        return max(0.5, args.poll_seconds)
    quotes = snapshot_quotes(
        up_book=market_books.up_book,
        down_book=market_books.down_book,
        clip_shares=args.clip_shares,
        bid_improve=args.bid_improve,
        depth_band=args.depth_band,
        min_depth_ratio=args.min_depth_ratio,
        min_best_level_ratio=args.min_best_level_ratio,
    )
    # Milestone 1 — mirror the accumulator's exposure-as-risk check.
    # openOrders is pruned upstream (prune_shadow_orders then
    # match_shadow_orders) so it already reflects the shadow's belief
    # about which target orders are still "live" on the book.
    outstanding_shadow = compute_outstanding_exposure(session["openOrders"])
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
        outstanding_up=outstanding_shadow.get("Up", 0.0),
        outstanding_down=outstanding_shadow.get("Down", 0.0),
        projected_exposure_limit_shares=args.projected_exposure_limit_shares,
        late_phase_seconds=args.late_phase_seconds,
        flatten_phase_seconds=args.flatten_phase_seconds,
    )
    # Milestone 1 — cycle-level risk metrics. These match the spec's
    # "metrics to track" list so parameter sweeps can be scored on
    # persistence, not just action count.
    open_orders_now: list[WorkingOrder] = session["openOrders"]
    working_by_outcome = {"Up": 0, "Down": 0}
    for order in open_orders_now:
        working_by_outcome[order.outcome] = (
            working_by_outcome.get(order.outcome, 0) + 1
        )
    projected_side, projected_qty = project_residual_if_all_fill(
        filled_up=state.up_qty,
        filled_down=state.down_qty,
        outstanding_up=outstanding_shadow.get("Up", 0.0),
        outstanding_down=outstanding_shadow.get("Down", 0.0),
    )
    cycle = {
        "cycle": cycle_index,
        "timestampUtc": now_utc_iso(),
        "secondsLeft": decision["secondsLeft"],
        "inventory": state.to_dict(),
        "quotes": quotes,
        "decision": decision,
        "outstandingExposure": {
            "Up": round(outstanding_shadow.get("Up", 0.0), 6),
            "Down": round(outstanding_shadow.get("Down", 0.0), 6),
        },
        "workingOrderCountByOutcome": working_by_outcome,
        "projectedResidual": {
            "side": projected_side,
            "qty": round(projected_qty, 6),
        },
        "exposureClipCount": len(decision.get("exposureClips") or []),
        # Milestone 2 — explicit session phase + band configuration
        # so per-cycle records carry their own provenance and the
        # measurement report can slice by phase / band without
        # re-deriving from the run parameters.
        "sessionPhase": decision.get("sessionPhase"),
        "priceBandTicks": int(args.quote_price_band_ticks),
        "sizeBandShares": float(args.quote_size_band_shares),
    }
    warnings = [warning for warning in (reference_warning, market_warning) if warning]
    if warnings:
        cycle["warnings"] = warnings
    if decision["actions"]:
        placed_at = time.time()
        placed_ts = int(math.floor(placed_at))
        for action in decision["actions"]:
            session["shadowTargets"].append(
                {
                    "timestamp": placed_ts,
                    "cycle": cycle_index,
                    "outcome": str(action["outcome"]),
                    "price": float(action["quotedPrice"]),
                    "size": float(action["size"]),
                    "mode": str(action.get("mode") or ""),
                    "layer": int(action.get("layer") or 0),
                }
            )
        session["openOrders"], reconcile_summary = reconcile_orders(
            existing_orders=session["openOrders"],
            actions=decision["actions"],
            now_ts=placed_at,
            ttl_seconds=args.shadow_order_ttl_seconds,
            cycle_index=cycle_index,
            slug=event["slug"],
            price_band=float(args.quote_price_band_ticks) * 0.01,
            size_band=float(args.quote_size_band_shares),
        )
        cycle["targetLadder"] = ladder_summary(decision["actions"])
        cycle["ladderReconcile"] = reconcile_summary
        cycle["openOrdersAfterReconcile"] = [row.to_dict() for row in session["openOrders"]]
        for operation_name in ("created", "amended", "cancelled"):
            for row in reconcile_summary.get(operation_name, []):
                session["shadowActions"].append(
                    {
                        "operation": operation_name,
                        "timestamp": placed_ts,
                        "cycle": cycle_index,
                        "mode": row.get("mode") or row.get("key", ""),
                        **row,
                    }
                )
    sleep_for = max(0.0, args.poll_seconds)
    session["cycles"].append(cycle)
    return sleep_for


def finalize_shadow_session(session: dict[str, Any], args: argparse.Namespace, output_dir: Path, stamp: str) -> dict[str, Any]:
    event, event_warning = resilient_event_refresh(session)
    end_ts = btc5_start_timestamp_from_slug(session["event"]["slug"])
    session["windowComplete"] = (end_ts is not None and end_ts + int(WINDOW_SECONDS) <= int(time.time()))
    final_reference_fills, reference_warning = resilient_reference_fills(session, args.reference_wallet)
    new_reference_fills = [
        row
        for row in final_reference_fills
        if row.transaction_hash not in session["referenceSeenHashes"]
    ]
    match_shadow_orders(session, new_reference_fills)
    summary = summarize_shadow_window(session, event, final_reference_fills)
    raw_payload = {
        "generatedAtUtc": now_utc_iso(),
        "referenceWallet": args.reference_wallet,
        "event": event,
        "summary": summary,
        "shadowActions": session["shadowActions"],
        "shadowTargets": session["shadowTargets"],
        "shadowFills": serialize_fills(session["shadowFills"]),
        "referenceFills": serialize_fills(final_reference_fills),
        "cycles": session["cycles"],
    }
    warnings = [warning for warning in (event_warning, reference_warning) if warning]
    if warnings:
        raw_payload["warnings"] = warnings
        summary["warnings"] = warnings
    raw_path = output_dir / f"{stamp}.{event['slug']}.shadow-window.json"
    write_json(raw_path, raw_payload)
    summary["rawPath"] = str(raw_path)
    return summary


def median(values: list[float]) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    idx = len(ordered) // 2
    if len(ordered) % 2:
        return ordered[idx]
    return (ordered[idx - 1] + ordered[idx]) / 2


def cmd_record(args: argparse.Namespace) -> int:
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    started_at = time.time()
    deadline = started_at + max(0.05, args.duration_minutes) * 60.0
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    windows: list[dict[str, Any]] = []
    active_session: dict[str, Any] | None = None
    active_slug: str | None = None
    cycle_index = 0
    while time.time() < deadline:
        try:
            event = retry_call(
                "resolve_current_btc5",
                lambda: resolve("current", args.lookahead_windows),
            )
        except Exception as exc:  # pragma: no cover - network edge
            log_retry_event("shadow_loop_warning", kind="resolve_failed", error=f"{type(exc).__name__}: {exc}")
            time.sleep(max(0.5, args.poll_seconds))
            continue
        if active_slug != event["slug"]:
            if active_session is not None:
                try:
                    windows.append(finalize_shadow_session(active_session, args, output_dir, stamp))
                except Exception as exc:  # pragma: no cover - keep recorder alive
                    log_retry_event(
                        "shadow_loop_warning",
                        kind="finalize_failed",
                        slug=active_session["event"]["slug"],
                        error=f"{type(exc).__name__}: {exc}",
                    )
            active_session = start_shadow_session(event)
            active_slug = event["slug"]
            cycle_index = 0
        cycle_index += 1
        try:
            sleep_for = step_shadow_session(active_session, args, cycle_index)
        except Exception as exc:  # pragma: no cover - keep recorder alive
            log_retry_event(
                "shadow_loop_warning",
                kind="step_failed",
                slug=active_session["event"]["slug"],
                cycle=cycle_index,
                error=f"{type(exc).__name__}: {exc}",
            )
            sleep_for = max(0.5, args.poll_seconds)
        time.sleep(min(sleep_for, max(0.1, deadline - time.time())))
    if active_session is not None:
        try:
            windows.append(finalize_shadow_session(active_session, args, output_dir, stamp))
        except Exception as exc:  # pragma: no cover - keep recorder alive
            log_retry_event(
                "shadow_loop_warning",
                kind="finalize_failed",
                slug=active_session["event"]["slug"],
                error=f"{type(exc).__name__}: {exc}",
            )

    aggregate = {
        "windowCount": len(windows),
        "shadowActionCount": sum(int(row["shadowActionCount"]) for row in windows),
        "shadowFillCount": sum(int(row["shadowFillCount"]) for row in windows),
        "referenceTradeRows": sum(int(row["referenceTradeRows"]) for row in windows),
        "medianReferenceRowsPerWindow": median([float(row["referenceTradeRows"]) for row in windows]),
        "medianShadowActionsPerWindow": median([float(row["shadowActionCount"]) for row in windows]),
    }
    payload = {
        "generatedAtUtc": now_utc_iso(),
        "durationMinutes": args.duration_minutes,
        "referenceWallet": args.reference_wallet,
        "shadowModel": "persistent-ladder, reference-print-driven, queue-unaware",
        "parameters": {
            "pollSeconds": args.poll_seconds,
            "shadowRestSeconds": args.shadow_rest_seconds,
            "shadowOrderTtlSeconds": args.shadow_order_ttl_seconds,
            "clipShares": args.clip_shares,
            "entryThreshold": args.entry_threshold,
            "rebalanceThreshold": args.rebalance_threshold,
            "maxResidualShares": args.max_residual_shares,
            "makerLayers": args.maker_layers,
            "makerPairThreshold": args.maker_pair_threshold,
        },
        "windows": windows,
        "aggregate": aggregate,
    }
    json_path = output_dir / f"{args.prefix}.{stamp}.json"
    md_path = output_dir / f"{args.prefix}.{stamp}.md"
    csv_path = output_dir / f"{args.prefix}.{stamp}.csv"
    write_json(json_path, payload)
    write_markdown(md_path, render_shadow_markdown(payload))
    csv_rows = [
        {
            "slug": row["slug"],
            "title": row["title"],
            "windowComplete": row["windowComplete"],
            "referenceTradeRows": row["referenceTradeRows"],
            "referenceDistinctTx": row["referenceDistinctTx"],
            "shadowActionCount": row["shadowActionCount"],
            "shadowTargetCount": row["shadowTargetCount"],
            "shadowFillCount": row["shadowFillCount"],
            "shadowFirstActionSeconds": row["shadowFirstActionSeconds"],
            "referenceFirstTradeSeconds": row["referenceFirstTradeSeconds"],
            "bestPairQuoteSeen": row["bestPairQuoteSeen"],
            "shadowPairedQty": row["shadowFinalState"]["pairedQty"],
            "shadowPairedAvgCost": row["shadowFinalState"]["pairedAvgCost"],
            "shadowResidualSide": row["shadowFinalState"]["residualSide"],
            "shadowResidualQty": row["shadowFinalState"]["residualQty"],
            "referencePairedQty": row["referenceFinalState"]["pairedQty"],
            "referencePairedAvgCost": row["referenceFinalState"]["pairedAvgCost"],
            "referenceResidualSide": row["referenceFinalState"]["residualSide"],
            "referenceResidualQty": row["referenceFinalState"]["residualQty"],
        }
        for row in windows
    ]
    write_csv(
        csv_path,
        csv_rows,
        [
            "slug",
            "title",
            "windowComplete",
            "referenceTradeRows",
            "referenceDistinctTx",
            "shadowActionCount",
            "shadowTargetCount",
            "shadowFillCount",
            "shadowFirstActionSeconds",
            "referenceFirstTradeSeconds",
            "bestPairQuoteSeen",
            "shadowPairedQty",
            "shadowPairedAvgCost",
            "shadowResidualSide",
            "shadowResidualQty",
            "referencePairedQty",
            "referencePairedAvgCost",
            "referenceResidualSide",
            "referenceResidualQty",
        ],
    )
    print(
        json.dumps(
            {
                "json": str(json_path),
                "markdown": str(md_path),
                "csv": str(csv_path),
                "windows": len(windows),
            },
            indent=2,
        )
    )
    return 0


def main() -> int:
    args = parse_args()
    if args.command == "record":
        return cmd_record(args)
    if args.command == "forensics":
        return cmd_forensics(args)
    raise SystemExit(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    raise SystemExit(main())
