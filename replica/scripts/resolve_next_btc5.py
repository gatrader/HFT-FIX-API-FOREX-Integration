from __future__ import annotations

import argparse
import json
from datetime import datetime, timedelta, timezone
from typing import Iterable
from zoneinfo import ZoneInfo

import requests


ET = ZoneInfo("America/New_York")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Resolve the exact current or next BTC5 Polymarket event by matching the "
            "canonical market title used on Gamma."
        )
    )
    parser.add_argument(
        "--which",
        choices=("current", "next"),
        default="next",
        help="Whether to resolve the current live window or the next upcoming one.",
    )
    parser.add_argument(
        "--lookahead-windows",
        type=int,
        default=6,
        help="How many 5-minute windows to search forward before giving up.",
    )
    return parser


def floor_to_interval(dt: datetime, minutes: int) -> datetime:
    return dt.replace(
        minute=(dt.minute // minutes) * minutes,
        second=0,
        microsecond=0,
    )


def ceil_to_interval(dt: datetime, minutes: int) -> datetime:
    floored = floor_to_interval(dt, minutes)
    if floored == dt.replace(second=0, microsecond=0):
        return floored
    return floored + timedelta(minutes=minutes)


def format_time_label(dt: datetime) -> str:
    hour = dt.hour % 12 or 12
    suffix = "AM" if dt.hour < 12 else "PM"
    return f"{hour}:{dt.minute:02d}{suffix}"


def format_title(start_et: datetime, end_et: datetime) -> str:
    return (
        f"Bitcoin Up or Down - {start_et.strftime('%B')} {start_et.day}, "
        f"{format_time_label(start_et)}-{format_time_label(end_et)} ET"
    )


def candidate_titles(which: str, lookahead_windows: int) -> Iterable[tuple[datetime, datetime, str]]:
    now_et = datetime.now(ET)
    current_start = floor_to_interval(now_et, 5)
    if which == "current":
        starts = [current_start + timedelta(minutes=5 * offset) for offset in range(lookahead_windows)]
    else:
        first = ceil_to_interval(now_et, 5)
        starts = [first + timedelta(minutes=5 * offset) for offset in range(lookahead_windows)]
    for start_et in starts:
        end_et = start_et + timedelta(minutes=5)
        yield start_et, end_et, format_title(start_et, end_et)


def fetch_json(url: str, params: dict | None = None) -> dict | list:
    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    return response.json()


def resolve(which: str, lookahead_windows: int) -> dict:
    now_utc = datetime.now(timezone.utc)
    for start_et, end_et, title in candidate_titles(which, lookahead_windows):
        payload = fetch_json("https://gamma-api.polymarket.com/public-search", {"q": title})
        if not isinstance(payload, dict):
            continue
        for event_stub in payload.get("events", []):
            if str(event_stub.get("title") or "") != title:
                continue
            if bool(event_stub.get("closed")):
                continue
            event = fetch_json(f"https://gamma-api.polymarket.com/events/{event_stub['id']}")
            if not isinstance(event, dict):
                continue
            markets = event.get("markets") or []
            if len(markets) != 1:
                continue
            market = markets[0]
            end_date_raw = market.get("endDate") or event.get("endDate")
            if not end_date_raw:
                continue
            end_utc = datetime.fromisoformat(str(end_date_raw).replace("Z", "+00:00"))
            if end_utc <= now_utc:
                continue
            outcomes = json.loads(market["outcomes"])
            token_ids = json.loads(market["clobTokenIds"])
            token_map = {str(outcomes[index]): str(token_ids[index]) for index in range(len(outcomes))}
            if {"Up", "Down"} - set(token_map):
                continue
            return {
                "eventId": str(event["id"]),
                "slug": str(event["slug"]),
                "title": str(event.get("title") or title),
                "conditionId": str(market["conditionId"]),
                "startDate": start_et.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
                "endDate": end_utc.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
                "queryTitle": title,
                "makerBaseFee": int(market.get("makerBaseFee") or 0),
                "takerBaseFee": int(market.get("takerBaseFee") or 0),
                "upTokenId": token_map["Up"],
                "downTokenId": token_map["Down"],
            }
    raise RuntimeError(
        f"No open BTC5 event matched the exact {which} window title within {lookahead_windows} windows."
    )


def main() -> int:
    args = build_parser().parse_args()
    payload = resolve(args.which, args.lookahead_windows)
    print(json.dumps(payload, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
