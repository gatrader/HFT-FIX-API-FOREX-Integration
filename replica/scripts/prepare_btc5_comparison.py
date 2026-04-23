from __future__ import annotations

import argparse
import json
from datetime import datetime, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

import requests


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Resolve a live BTC5 market and write the replica config and "
            "command snippets needed for an UP/DOWN comparison."
        )
    )
    parser.add_argument("--slug", default="", help="Explicit btc-updown-5m slug to use.")
    parser.add_argument("--event-id", default="", help="Explicit Gamma event id to fetch.")
    parser.add_argument("--search-query", default="", help="Override the public-search query used when --slug is omitted.")
    parser.add_argument("--output-dir", default=".generated", help="Directory for generated JSON and command files.")
    parser.add_argument("--symbol-prefix", default="btc5-compare", help="Prefix for the generated config symbol.")
    parser.add_argument("--max-buy-order-size", type=float, default=5.0)
    parser.add_argument("--spread-threshold", type=float, default=0.0)
    parser.add_argument("--trade-cooldown", type=int, default=1000)
    parser.add_argument("--balance-factor", type=float, default=1.0)
    parser.add_argument("--stop-before-end-ms", type=int, default=0)
    parser.add_argument("--min-price", type=float, default=0.40)
    parser.add_argument("--max-price", type=float, default=0.62)
    parser.add_argument("--max-position-size", type=float, default=0.0)
    parser.add_argument("--target-spread", type=float, default=0.0)
    parser.add_argument("--interval-minutes", type=int, default=5)
    parser.add_argument("--cancel-orders-on-start", action="store_true")
    parser.add_argument("--seed-shares", type=float, default=5.0, help="Suggested absolute net-position seed for a BUY-only canary.")
    return parser


def default_query() -> str:
    now_et = datetime.now(ZoneInfo("America/New_York"))
    return f"bitcoin up or down {now_et.strftime('%B')} {now_et.day}"


def fallback_queries() -> list[str]:
    now_et = datetime.now(ZoneInfo("America/New_York"))
    midnight = now_et.replace(hour=0, minute=0, second=0, microsecond=0)
    dates = [now_et, midnight, midnight + timedelta(days=1)]
    queries = []
    for dt in dates:
        query = f"bitcoin up or down {dt.strftime('%B')} {dt.day}"
        if query not in queries:
            queries.append(query)
    return queries


def fetch_json(url: str, *, params: dict | None = None) -> dict | list:
    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    return response.json()


def resolve_event(args: argparse.Namespace) -> dict:
    if args.slug:
        event = fetch_json(f"https://gamma-api.polymarket.com/events/slug/{args.slug}")
        if not isinstance(event, dict):
            raise RuntimeError(f"Expected a single event for slug {args.slug}")
        return event
    if args.event_id:
        event = fetch_json(f"https://gamma-api.polymarket.com/events/{args.event_id}")
        if not isinstance(event, dict):
            raise RuntimeError(f"Expected a single event for id {args.event_id}")
        return event

    now_utc = datetime.now(timezone.utc)
    matches = []
    queries = [args.search_query] if args.search_query else fallback_queries()
    for query in queries:
        payload = fetch_json("https://gamma-api.polymarket.com/public-search", params={"q": query})
        if not isinstance(payload, dict):
            raise RuntimeError("Unexpected search payload from Gamma API")
        for event in payload.get("events", []):
            slug = str(event.get("slug") or "")
            if not slug.startswith("btc-updown-5m-"):
                continue
            if bool(event.get("closed")):
                continue
            end_date_raw = event.get("endDate")
            if not end_date_raw:
                continue
            end_date = datetime.fromisoformat(str(end_date_raw).replace("Z", "+00:00"))
            if end_date <= now_utc:
                continue
            matches.append((end_date, event))
        if matches:
            break
    if not matches:
        raise RuntimeError("No BTC5 search hits. Pass --slug for an explicit market.")
    matches.sort(key=lambda item: (item[0] < now_utc, abs((item[0] - now_utc).total_seconds())))
    chosen = matches[0][1]
    event = fetch_json(f"https://gamma-api.polymarket.com/events/{chosen['id']}")
    if not isinstance(event, dict):
        raise RuntimeError(f"Expected a single event for id {chosen['id']}")
    return event


def parse_market_tokens(market: dict) -> tuple[list[str], list[str]]:
    token_ids = json.loads(market["clobTokenIds"])
    outcomes = json.loads(market["outcomes"])
    if len(token_ids) != 2 or len(outcomes) != 2:
        raise RuntimeError("BTC5 market did not expose exactly two token ids/outcomes")
    return token_ids, outcomes


def base_config(args: argparse.Namespace, slug: str) -> dict:
    return {
        "symbol": f"{args.symbol_prefix}-{slug}",
        "current_market": slug,
        "max_buy_order_size": args.max_buy_order_size,
        "spread_threshold": args.spread_threshold,
        "trade_cooldown": args.trade_cooldown,
        "balance_factor": args.balance_factor,
        "stop_before_end_ms": args.stop_before_end_ms,
        "min_price": args.min_price,
        "max_price": args.max_price,
        "max_position_size": args.max_position_size,
        "trade_side": "buy_only",
        "target_spread": args.target_spread,
        "interval_minutes": args.interval_minutes,
        "dry_run": False,
        "enable_gamble": False,
        "log_price": False,
        "cancel_orders_on_start": args.cancel_orders_on_start,
    }


def render_commands(slug: str, condition_id: str, token_map: dict[str, str], config_path: Path, seed_shares: float) -> str:
    lines = [
        f"# Base market",
        f"export MARKET='{condition_id}'",
        f"export CONFIG='{config_path.as_posix()}'",
        "",
        "# UP token canary / runtime",
        f"export TOKEN_ID_UP='{token_map['Up']}'",
        (
            "./target/release/arbigab-replica --key \"$POLYMARKET_PRIVATE_KEY\" "
            "runtime --config \"$CONFIG\" --token-id \"$TOKEN_ID_UP\" --market \"$MARKET\" "
            f"--net-position=-{seed_shares:g} --fee-rate-bps 0 --duration-secs 300"
        ),
        "",
        "# DOWN token canary / runtime (the practical 'reversed' variant for the current replica)",
        f"export TOKEN_ID_DOWN='{token_map['Down']}'",
        (
            "./target/release/arbigab-replica --key \"$POLYMARKET_PRIVATE_KEY\" "
            "runtime --config \"$CONFIG\" --token-id \"$TOKEN_ID_DOWN\" --market \"$MARKET\" "
            f"--net-position=-{seed_shares:g} --fee-rate-bps 0 --duration-secs 300"
        ),
        "",
        (
            "# Note: the current replica is still a single-token, inventory-driven bot. "
            "This prepares a BTC5 comparison target, but it does not turn the replica into "
            "a true dual-leg BTC5 arbitrage engine."
        ),
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    args = build_parser().parse_args()
    event = resolve_event(args)
    markets = event.get("markets") or []
    if len(markets) != 1:
        raise RuntimeError("Expected BTC5 event payload to contain exactly one market")
    market = markets[0]
    token_ids, outcomes = parse_market_tokens(market)
    token_map = {str(outcomes[index]): str(token_ids[index]) for index in range(2)}
    if {"Up", "Down"} - set(token_map):
        raise RuntimeError(f"Expected BTC5 outcomes ['Up', 'Down'], got {outcomes}")

    slug = str(event["slug"])
    condition_id = str(market["conditionId"])
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    config = base_config(args, slug)
    market_path = output_dir / f"{slug}.market.json"
    config_path = output_dir / f"{slug}.replica.json"
    commands_path = output_dir / f"{slug}.commands.sh"

    market_payload = {
        "eventId": str(event["id"]),
        "slug": slug,
        "title": event.get("title"),
        "conditionId": condition_id,
        "endDate": market.get("endDate") or event.get("endDate"),
        "makerBaseFee": market.get("makerBaseFee"),
        "takerBaseFee": market.get("takerBaseFee"),
        "upTokenId": token_map["Up"],
        "downTokenId": token_map["Down"],
        "suggestedNetPosition": -abs(args.seed_shares),
    }

    market_path.write_text(json.dumps(market_payload, indent=2) + "\n", encoding="utf-8")
    config_path.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
    commands_path.write_text(
        render_commands(slug, condition_id, token_map, config_path, abs(args.seed_shares)),
        encoding="utf-8",
    )

    print(json.dumps(
        {
            "event": market_payload,
            "configPath": str(config_path),
            "marketPath": str(market_path),
            "commandsPath": str(commands_path),
        },
        indent=2,
    ))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
