from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import requests

from prepare_btc5_comparison import base_config
from resolve_next_btc5 import resolve


CLOB_BOOK_URL = "https://clob.polymarket.com/book"
DEFAULT_ROOT = f"/home/ubuntu/autoredeeem-{datetime.now(timezone.utc).date().isoformat()}"
DEFAULT_FUNDER = "0x31d39De926465dc288948846efc44Bfe64914399"
DEFAULT_SRC_BIN = "/home/ubuntu/worktrees/review-head/replica/target/release/arbigab-replica"
DEFAULT_SRC_CREDS = "/home/ubuntu/worktrees/review-head/replica/.replica-livefill/creds.json"
RUST_LOG = (
    "runtime=info,hotpath=info,order_body=info,order_response=info,"
    "order_reject=warn,cancel=info,shutdown=warn,ws=info"
)


@dataclass
class BookQuote:
    price: float
    size: float


@dataclass
class LegPlan:
    outcome: str
    token_id: str
    price: float
    size: float
    config_path: Path


def leg_log_name(outcome: str, *, suffix: str = "") -> str:
    normalized = outcome.lower().replace(" ", "-")
    if suffix:
        normalized = f"{normalized}.{suffix}"
    return normalized


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Resolve one BTC5 market, check the paired edge, and optionally place "
            "back-to-back Up/Down canary orders with residual-risk cleanup."
        )
    )
    parser.add_argument("--root", default=DEFAULT_ROOT, help="Clean-room root on AWS.")
    parser.add_argument("--which", choices=("current", "next"), default="current")
    parser.add_argument("--lookahead-windows", type=int, default=6)
    parser.add_argument("--pair-shares", type=float, default=5.0)
    parser.add_argument(
        "--edge-threshold",
        type=float,
        default=0.96,
        help="Trade only if best ask Up + best ask Down is at or below this value.",
    )
    parser.add_argument(
        "--min-seconds-left",
        type=int,
        default=30,
        help="Abort if fewer than this many seconds remain before market end.",
    )
    parser.add_argument(
        "--open-wait-buffer-seconds",
        type=int,
        default=5,
        help="When targeting the next market, wait this many extra seconds after open.",
    )
    parser.add_argument(
        "--symbol-prefix",
        default="btc5-paired",
        help="Symbol prefix used when writing generated configs.",
    )
    parser.add_argument(
        "--output-dir",
        default="generated",
        help="Directory inside the clean room for configs, logs, and summaries.",
    )
    parser.add_argument(
        "--depth-band",
        type=float,
        default=0.02,
        help="Price band above best ask used for cumulative ask-depth checks.",
    )
    parser.add_argument(
        "--min-depth-ratio",
        type=float,
        default=1.5,
        help="Require cumulative ask depth within the band to cover this multiple of pair size.",
    )
    parser.add_argument(
        "--min-best-level-ratio",
        type=float,
        default=0.5,
        help="Require the top ask level itself to cover at least this multiple of pair size.",
    )
    parser.add_argument(
        "--live-ok",
        action="store_true",
        help="Actually place live orders. Omit for a dry-run planner.",
    )
    return parser


def require_env(name: str, *, default: str | None = None) -> str:
    value = os.environ.get(name, "")
    value = normalize_env_value(value)
    if value:
        return value
    if default is not None:
        return normalize_env_value(default)
    raise SystemExit(f"Missing required environment variable: {name}")


def normalize_env_value(value: str) -> str:
    cleaned = str(value).strip()
    while len(cleaned) >= 2 and cleaned[0] == cleaned[-1] and cleaned[0] in {"'", '"'}:
        cleaned = cleaned[1:-1].strip()
    return cleaned


def fetch_json(url: str, *, params: dict[str, Any] | None = None) -> Any:
    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    return response.json()


def parse_levels(raw_levels: list[dict[str, Any]]) -> list[BookQuote]:
    levels: list[BookQuote] = []
    for row in raw_levels:
        try:
            price = float(row["price"])
            size = float(row["size"])
        except (KeyError, TypeError, ValueError):
            continue
        if price <= 0 or size <= 0:
            continue
        levels.append(BookQuote(price=price, size=size))
    return levels


def best_ask(book: dict[str, Any]) -> BookQuote | None:
    asks = parse_levels(book.get("asks", []))
    if not asks:
        return None
    price = min(level.price for level in asks)
    size = sum(level.size for level in asks if abs(level.price - price) < 1e-9)
    return BookQuote(price=price, size=size)


def best_bid(book: dict[str, Any]) -> BookQuote | None:
    bids = parse_levels(book.get("bids", []))
    if not bids:
        return None
    price = max(level.price for level in bids)
    size = sum(level.size for level in bids if abs(level.price - price) < 1e-9)
    return BookQuote(price=price, size=size)


def ask_depth_within_band(book: dict[str, Any], band: float) -> dict[str, float] | None:
    asks = parse_levels(book.get("asks", []))
    if not asks:
        return None
    best = min(level.price for level in asks)
    max_price = best + max(0.0, band)
    cumulative = sum(level.size for level in asks if level.price <= max_price + 1e-9)
    return {
        "bestPrice": best,
        "maxPrice": max_price,
        "cumulativeSize": cumulative,
    }


def fetch_book(token_id: str) -> dict[str, Any]:
    payload = fetch_json(CLOB_BOOK_URL, params={"token_id": token_id})
    if not isinstance(payload, dict):
        raise RuntimeError(f"Unexpected book payload for token {token_id}")
    return payload


def ensure_binary(src_bin: Path, dest_bin: Path) -> None:
    dest_bin.parent.mkdir(parents=True, exist_ok=True)
    if not dest_bin.exists() or src_bin.stat().st_mtime > dest_bin.stat().st_mtime:
        shutil.copy2(src_bin, dest_bin)
        dest_bin.chmod(0o755)


def bootstrap_creds(
    *,
    binary: Path,
    creds: Path,
    nonce: Path,
    private_key: str,
    signature_type: str,
    funder: str,
    source_creds: Path,
) -> None:
    if creds.exists() and creds.stat().st_size > 0:
        return
    creds.parent.mkdir(parents=True, exist_ok=True)
    nonce.parent.mkdir(parents=True, exist_ok=True)
    command = [
        str(binary),
        "--key",
        private_key,
        "--creds",
        str(creds),
        "--nonce",
        str(nonce),
        "--signature-type",
        signature_type,
        "--funder",
        funder,
        "bootstrap",
    ]
    result = subprocess.run(
        command,
        text=True,
        capture_output=True,
        env={**os.environ, "RUST_LOG": RUST_LOG},
    )
    if result.returncode == 0 and creds.exists() and creds.stat().st_size > 0:
        return
    if not source_creds.exists():
        raise RuntimeError(
            "Bootstrap failed and no cached creds fallback exists. "
            f"stderr={result.stderr.strip()}"
        )
    shutil.copy2(source_creds, creds)


def build_config(
    *,
    slug: str,
    symbol_prefix: str,
    price: float,
    size: float,
    stop_before_end_ms: int,
    current_market: str,
    trade_side: str,
) -> dict[str, Any]:
    args = argparse.Namespace(
        symbol_prefix=symbol_prefix,
        max_buy_order_size=size,
        spread_threshold=0.0,
        trade_cooldown=1000,
        balance_factor=1.0,
        stop_before_end_ms=stop_before_end_ms,
        min_price=price,
        max_price=price,
        max_position_size=0.0,
        target_spread=0.0,
        interval_minutes=5,
        cancel_orders_on_start=False,
    )
    config = base_config(args, slug)
    config["trade_side"] = trade_side
    config["min_price"] = price
    config["max_price"] = price
    config["max_buy_order_size"] = size
    config["current_market"] = current_market
    return config


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def run_command(command: list[str], log_path: Path) -> int:
    log_path.parent.mkdir(parents=True, exist_ok=True)
    with log_path.open("w", encoding="utf-8") as handle:
        completed = subprocess.run(
            command,
            stdout=handle,
            stderr=subprocess.STDOUT,
            text=True,
            env={**os.environ, "RUST_LOG": RUST_LOG},
        )
    return completed.returncode


def parse_order_response(log_path: Path) -> dict[str, Any]:
    payload: dict[str, Any] = {
        "logPath": str(log_path),
        "orderResponse": None,
        "orderReject": [],
        "cleanupOk": False,
        "fatalError": None,
        "returnCode": None,
    }
    text = log_path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"\x1b\[[0-9;]*m", "", text)
    body_re = re.compile(r"body=(\{.*\})")
    for line in text.splitlines():
        if "order_response:" in line and "body=" in line:
            match = body_re.search(line)
            if match:
                try:
                    payload["orderResponse"] = json.loads(match.group(1))
                except json.JSONDecodeError:
                    payload["orderResponse"] = {"raw": match.group(1)}
        elif "order_reject:" in line:
            payload["orderReject"].append(line.strip())
        elif "startup cancel_all ok" in line:
            payload["cleanupOk"] = True
        elif line.startswith("Error: "):
            payload["fatalError"] = line.strip()
    return payload


def order_status(parsed: dict[str, Any]) -> str:
    body = parsed.get("orderResponse")
    if isinstance(body, dict):
        status = body.get("status")
        if isinstance(status, str) and status:
            return status.lower()
    if parsed.get("fatalError"):
        return "error"
    if parsed.get("orderReject"):
        return "reject"
    return "unknown"


def wait_for_market_open(event: dict[str, Any], *, buffer_seconds: int) -> None:
    start = datetime.fromisoformat(str(event["startDate"]).replace("Z", "+00:00"))
    now = datetime.now(timezone.utc)
    sleep_seconds = int((start - now).total_seconds()) + buffer_seconds
    if sleep_seconds > 0:
        print(f"Waiting {sleep_seconds}s for {event['slug']} to open...")
        time.sleep(sleep_seconds)


def seconds_left(event: dict[str, Any]) -> int:
    end = datetime.fromisoformat(str(event["endDate"]).replace("Z", "+00:00"))
    return int((end - datetime.now(timezone.utc)).total_seconds())


def cleanup_cancel_all(
    *,
    binary: Path,
    creds: Path,
    nonce: Path,
    private_key: str,
    signature_type: str,
    funder: str,
    config_path: Path,
    token_id: str,
    market_id: str,
    fee_rate_bps: int,
    log_path: Path,
) -> dict[str, Any]:
    nonce.write_text("", encoding="utf-8")
    command = [
        str(binary),
        "--key",
        private_key,
        "--creds",
        str(creds),
        "--nonce",
        str(nonce),
        "--signature-type",
        signature_type,
        "--funder",
        funder,
        "runtime",
        "--config",
        str(config_path),
        "--token-id",
        token_id,
        "--market",
        market_id,
        "--force-cancel-on-start",
        "--net-position=0",
        "--fee-rate-bps",
        str(fee_rate_bps),
        "--tick-interval-ms",
        "250",
        "--book-max-age-ms",
        "1000",
        "--dedup-window-ms",
        "20000",
        "--submit-budget-per-sec",
        "1",
        "--price-bucket",
        "0.01",
        "--size-bucket",
        "1",
        "--cancel-dedup-ms",
        "250",
        "--cancel-queue-capacity",
        "4",
        "--duration-secs",
        "3",
        "--submit-queue-capacity",
        "4",
        "--realtime",
    ]
    return_code = run_command(command, log_path)
    parsed = parse_order_response(log_path)
    parsed["returnCode"] = return_code
    return parsed


def canary_submit(
    *,
    binary: Path,
    creds: Path,
    nonce: Path,
    private_key: str,
    signature_type: str,
    funder: str,
    config_path: Path,
    token_id: str,
    net_position: float,
    fee_rate_bps: int,
    log_path: Path,
) -> dict[str, Any]:
    nonce.write_text("", encoding="utf-8")
    command = [
        str(binary),
        "--key",
        private_key,
        "--creds",
        str(creds),
        "--nonce",
        str(nonce),
        "--signature-type",
        signature_type,
        "--funder",
        funder,
        "canary",
        "--config",
        str(config_path),
        "--token-id",
        token_id,
        f"--net-position={net_position:g}",
        "--fee-rate-bps",
        str(fee_rate_bps),
        "--iterations",
        "1",
    ]
    return_code = run_command(command, log_path)
    parsed = parse_order_response(log_path)
    parsed["returnCode"] = return_code
    parsed["status"] = order_status(parsed)
    return parsed


def plan_leg(
    *,
    slug: str,
    output_dir: Path,
    symbol_prefix: str,
    outcome: str,
    token_id: str,
    price: float,
    size: float,
    stop_before_end_ms: int,
    trade_side: str,
) -> LegPlan:
    config_path = output_dir / f"{slug}.{outcome.lower()}.{trade_side}.replica.json"
    config = build_config(
        slug=slug,
        symbol_prefix=f"{symbol_prefix}-{outcome.lower()}",
        price=price,
        size=size,
        stop_before_end_ms=stop_before_end_ms,
        current_market=slug,
        trade_side=trade_side,
    )
    write_json(config_path, config)
    return LegPlan(
        outcome=outcome,
        token_id=token_id,
        price=price,
        size=size,
        config_path=config_path,
    )


def dry_run_summary(
    *,
    event: dict[str, Any],
    ask_up: BookQuote | None,
    ask_down: BookQuote | None,
    depth_up: dict[str, float] | None,
    depth_down: dict[str, float] | None,
    pair_shares: float,
    edge_threshold: float,
    min_seconds_left: int,
    min_depth_ratio: float,
    min_best_level_ratio: float,
) -> dict[str, Any]:
    gross_cost = None
    enough_size = False
    enough_depth = False
    enough_best_level = False
    if ask_up and ask_down:
        gross_cost = round(ask_up.price + ask_down.price, 6)
        enough_size = ask_up.size >= pair_shares and ask_down.size >= pair_shares
        if depth_up and depth_down:
            enough_depth = (
                depth_up["cumulativeSize"] >= pair_shares * min_depth_ratio
                and depth_down["cumulativeSize"] >= pair_shares * min_depth_ratio
            )
        enough_best_level = (
            ask_up.size >= pair_shares * min_best_level_ratio
            and ask_down.size >= pair_shares * min_best_level_ratio
        )
    return {
        "event": event,
        "asks": {
            "up": None if ask_up is None else {"price": ask_up.price, "size": ask_up.size},
            "down": None if ask_down is None else {"price": ask_down.price, "size": ask_down.size},
        },
        "depth": {
            "up": None
            if depth_up is None
            else {
                "bestPrice": depth_up["bestPrice"],
                "maxPrice": depth_up["maxPrice"],
                "cumulativeSize": depth_up["cumulativeSize"],
                "ratio": round(depth_up["cumulativeSize"] / pair_shares, 6),
            },
            "down": None
            if depth_down is None
            else {
                "bestPrice": depth_down["bestPrice"],
                "maxPrice": depth_down["maxPrice"],
                "cumulativeSize": depth_down["cumulativeSize"],
                "ratio": round(depth_down["cumulativeSize"] / pair_shares, 6),
            },
        },
        "pairShares": pair_shares,
        "edgeThreshold": edge_threshold,
        "grossCost": gross_cost,
        "edge": None if gross_cost is None else round(1.0 - gross_cost, 6),
        "enoughSize": enough_size,
        "enoughDepth": enough_depth,
        "enoughBestLevel": enough_best_level,
        "minDepthRatio": min_depth_ratio,
        "minBestLevelRatio": min_best_level_ratio,
        "secondsLeft": seconds_left(event),
        "minSecondsLeft": min_seconds_left,
        "eligible": (
            gross_cost is not None
            and gross_cost <= edge_threshold
            and enough_size
            and enough_depth
            and enough_best_level
            and seconds_left(event) >= min_seconds_left
        ),
    }


def outcome_reason(summary: dict[str, Any]) -> str:
    if summary["asks"]["up"] is None or summary["asks"]["down"] is None:
        return "missing_best_ask"
    if not summary["enoughSize"]:
        return "insufficient_size_at_best_ask"
    if not summary.get("enoughBestLevel", False):
        return "thin_top_of_book"
    if not summary.get("enoughDepth", False):
        return "insufficient_depth_within_band"
    if summary["secondsLeft"] < summary["minSecondsLeft"]:
        return "too_close_to_resolution"
    if summary["grossCost"] is not None and summary["grossCost"] > summary["edgeThreshold"]:
        return "no_edge_after_threshold"
    return "eligible"


def build_outcome_summary(summary: dict[str, Any]) -> dict[str, Any]:
    live_run = summary.get("liveRun")
    base = {
        "slug": summary["event"]["slug"],
        "title": summary["event"]["title"],
        "grossCost": summary.get("grossCost"),
        "edgeThreshold": summary.get("edgeThreshold"),
        "eligible": summary.get("eligible", False),
        "reason": outcome_reason(summary),
    }
    if not live_run:
        base["phase"] = "dry_run"
        base["result"] = "skipped" if not summary.get("eligible") else "ready_for_live"
        return base

    up_status = live_run["upResult"]["status"]
    down_status = live_run["downResult"]["status"]
    flatten = live_run.get("flattenResult")
    base.update(
        {
            "phase": "live",
            "upStatus": up_status,
            "downStatus": down_status,
            "preCleanupOk": live_run["preCleanup"].get("cleanupOk", False),
            "postCleanupOk": live_run["postCleanup"].get("cleanupOk", False),
            "flattenStatus": None if flatten is None else flatten.get("status"),
        }
    )
    statuses = {up_status, down_status}
    if statuses == {"matched"}:
        base["result"] = "both_matched_hold_to_resolution"
    elif statuses == {"live"}:
        base["result"] = "both_posted_then_cleaned_up"
    elif statuses <= {"reject"}:
        base["result"] = "both_rejected"
    elif "matched" in statuses and flatten is not None:
        base["result"] = "residual_leg_detected_flatten_attempted"
    elif "matched" in statuses:
        base["result"] = "residual_leg_detected_no_flatten"
    else:
        base["result"] = "mixed_acceptance_no_fill"
    return base


def write_outcome_artifacts(summary_path: Path, summary: dict[str, Any]) -> None:
    outcome = build_outcome_summary(summary)
    summary["outcomeSummary"] = outcome
    write_json(summary_path, summary)
    text_path = summary_path.with_suffix(".outcome.txt")
    lines = [
        f"slug: {outcome['slug']}",
        f"title: {outcome['title']}",
        f"phase: {outcome['phase']}",
        f"result: {outcome['result']}",
        f"eligible: {outcome['eligible']}",
        f"reason: {outcome['reason']}",
    ]
    gross_cost = outcome.get("grossCost")
    if gross_cost is not None:
        lines.append(f"gross_cost: {gross_cost:.6f}")
        lines.append(f"edge_threshold: {outcome['edgeThreshold']:.6f}")
    if outcome["phase"] == "live":
        lines.extend(
            [
                f"up_status: {outcome.get('upStatus')}",
                f"down_status: {outcome.get('downStatus')}",
                f"flatten_status: {outcome.get('flattenStatus')}",
                f"pre_cleanup_ok: {outcome.get('preCleanupOk')}",
                f"post_cleanup_ok: {outcome.get('postCleanupOk')}",
            ]
        )
    text_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    args = build_parser().parse_args()
    root = Path(args.root)
    output_dir = root / args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    event = resolve(args.which, args.lookahead_windows)
    summary_path = output_dir / f"{event['slug']}.paired.summary.json"

    if args.which == "next":
        wait_for_market_open(event, buffer_seconds=args.open_wait_buffer_seconds)

    remaining = seconds_left(event)
    if remaining < args.min_seconds_left:
        raise SystemExit(
            f"Refusing paired test for {event['slug']}: only {remaining}s remain."
        )

    up_book = fetch_book(event["upTokenId"])
    down_book = fetch_book(event["downTokenId"])
    ask_up = best_ask(up_book)
    ask_down = best_ask(down_book)
    depth_up = ask_depth_within_band(up_book, args.depth_band)
    depth_down = ask_depth_within_band(down_book, args.depth_band)
    summary = dry_run_summary(
        event=event,
        ask_up=ask_up,
        ask_down=ask_down,
        depth_up=depth_up,
        depth_down=depth_down,
        pair_shares=args.pair_shares,
        edge_threshold=args.edge_threshold,
        min_seconds_left=args.min_seconds_left,
        min_depth_ratio=args.min_depth_ratio,
        min_best_level_ratio=args.min_best_level_ratio,
    )

    if ask_up is None or ask_down is None:
        write_outcome_artifacts(summary_path, summary)
        print(json.dumps(summary, indent=2))
        raise SystemExit("Could not find both best asks, so no paired decision was possible.")

    up_plan = plan_leg(
        slug=event["slug"],
        output_dir=output_dir,
        symbol_prefix=args.symbol_prefix,
        outcome="Up",
        token_id=event["upTokenId"],
        price=ask_up.price,
        size=args.pair_shares,
        stop_before_end_ms=20_000,
        trade_side="buy_only",
    )
    down_plan = plan_leg(
        slug=event["slug"],
        output_dir=output_dir,
        symbol_prefix=args.symbol_prefix,
        outcome="Down",
        token_id=event["downTokenId"],
        price=ask_down.price,
        size=args.pair_shares,
        stop_before_end_ms=20_000,
        trade_side="buy_only",
    )

    summary["plans"] = {
        "up": {
            "price": up_plan.price,
            "size": up_plan.size,
            "tokenId": up_plan.token_id,
            "configPath": str(up_plan.config_path),
        },
        "down": {
            "price": down_plan.price,
            "size": down_plan.size,
            "tokenId": down_plan.token_id,
            "configPath": str(down_plan.config_path),
        },
    }
    write_outcome_artifacts(summary_path, summary)
    print(json.dumps(summary, indent=2))

    if not summary["eligible"]:
        return 0

    if not args.live_ok:
        return 0

    private_key = require_env("POLYMARKET_PRIVATE_KEY")
    signature_type = require_env("POLYMARKET_SIGNATURE_TYPE", default="2")
    funder = require_env("POLYMARKET_FUNDER", default=DEFAULT_FUNDER)

    src_bin = Path(DEFAULT_SRC_BIN)
    src_creds = Path(DEFAULT_SRC_CREDS)
    binary = root / "bin" / "arbigab-replica"
    creds = root / "state" / "creds.json"
    nonce = root / "state" / "nonce"

    ensure_binary(src_bin, binary)
    bootstrap_creds(
        binary=binary,
        creds=creds,
        nonce=nonce,
        private_key=private_key,
        signature_type=signature_type,
        funder=funder,
        source_creds=src_creds,
    )

    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    fee_rate_bps = int(event.get("makerBaseFee") or 0)

    pre_cleanup = cleanup_cancel_all(
        binary=binary,
        creds=creds,
        nonce=nonce,
        private_key=private_key,
        signature_type=signature_type,
        funder=funder,
        config_path=up_plan.config_path,
        token_id=up_plan.token_id,
        market_id=event["conditionId"],
        fee_rate_bps=fee_rate_bps,
        log_path=output_dir / f"{event['slug']}.{stamp}.paired.pre-cleanup.log",
    )

    up_result = canary_submit(
        binary=binary,
        creds=creds,
        nonce=nonce,
        private_key=private_key,
        signature_type=signature_type,
        funder=funder,
        config_path=up_plan.config_path,
        token_id=up_plan.token_id,
        net_position=-args.pair_shares,
        fee_rate_bps=fee_rate_bps,
        log_path=output_dir / f"{event['slug']}.{stamp}.paired.up.log",
    )
    down_result = canary_submit(
        binary=binary,
        creds=creds,
        nonce=nonce,
        private_key=private_key,
        signature_type=signature_type,
        funder=funder,
        config_path=down_plan.config_path,
        token_id=down_plan.token_id,
        net_position=-args.pair_shares,
        fee_rate_bps=fee_rate_bps,
        log_path=output_dir / f"{event['slug']}.{stamp}.paired.down.log",
    )

    post_cleanup = cleanup_cancel_all(
        binary=binary,
        creds=creds,
        nonce=nonce,
        private_key=private_key,
        signature_type=signature_type,
        funder=funder,
        config_path=down_plan.config_path,
        token_id=down_plan.token_id,
        market_id=event["conditionId"],
        fee_rate_bps=fee_rate_bps,
        log_path=output_dir / f"{event['slug']}.{stamp}.paired.post-cleanup.log",
    )

    statuses = {up_result["status"], down_result["status"]}
    flatten_result: dict[str, Any] | None = None
    if statuses == {"matched", "live"} or statuses == {"matched", "reject"} or statuses == {"matched", "unknown"}:
        matched_leg = up_plan if up_result["status"] == "matched" else down_plan
        flatten_book = fetch_book(matched_leg.token_id)
        flatten_bid = best_bid(flatten_book)
        if flatten_bid is not None:
            flatten_plan = plan_leg(
                slug=event["slug"],
                output_dir=output_dir,
                symbol_prefix=args.symbol_prefix,
                outcome=f"{matched_leg.outcome}-flatten",
                token_id=matched_leg.token_id,
                price=flatten_bid.price,
                size=args.pair_shares,
                stop_before_end_ms=20_000,
                trade_side="both",
            )
            flatten_result = canary_submit(
                binary=binary,
                creds=creds,
                nonce=nonce,
                private_key=private_key,
                signature_type=signature_type,
                funder=funder,
                config_path=flatten_plan.config_path,
                token_id=flatten_plan.token_id,
                net_position=args.pair_shares,
                fee_rate_bps=fee_rate_bps,
                log_path=output_dir / f"{event['slug']}.{stamp}.paired.flatten.log",
            )
            summary["flattenPlan"] = {
                "outcome": matched_leg.outcome,
                "price": flatten_bid.price,
                "size": args.pair_shares,
                "configPath": str(flatten_plan.config_path),
            }

    summary["liveRun"] = {
        "preCleanup": pre_cleanup,
        "upResult": up_result,
        "downResult": down_result,
        "postCleanup": post_cleanup,
        "flattenResult": flatten_result,
    }
    write_outcome_artifacts(summary_path, summary)
    print(json.dumps(summary["liveRun"], indent=2))
    print(json.dumps(summary["outcomeSummary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
