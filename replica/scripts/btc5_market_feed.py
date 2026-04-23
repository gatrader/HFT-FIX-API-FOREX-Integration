from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Protocol

from run_replica_btc5_paired import fetch_book


@dataclass(frozen=True)
class MarketBooks:
    up_book: dict[str, Any]
    down_book: dict[str, Any]
    fetched_at_utc: str


class MarketFeed(Protocol):
    def fetch_event_books(self, event: dict[str, Any]) -> MarketBooks:
        ...


class RestPollingMarketFeed:
    def fetch_event_books(self, event: dict[str, Any]) -> MarketBooks:
        return MarketBooks(
            up_book=fetch_book(event["upTokenId"]),
            down_book=fetch_book(event["downTokenId"]),
            fetched_at_utc=datetime.now(timezone.utc).isoformat(),
        )


class WebSocketMarketFeedScaffold:
    def __init__(self, *, endpoint: str | None = None) -> None:
        self.endpoint = endpoint or "wss://api.polymarket.us/v1/ws/markets"

    def fetch_event_books(self, event: dict[str, Any]) -> MarketBooks:
        raise NotImplementedError(
            "WebSocket market data is not wired into the BTC5 engine yet. "
            "Use RestPollingMarketFeed for now and extend this scaffold during the websocket migration."
        )
