from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class PrivateFeedStatus:
    orders_supported: bool
    positions_supported: bool
    balance_supported: bool
    endpoint: str


class PrivateFeedScaffold:
    def __init__(self, *, endpoint: str | None = None) -> None:
        self.endpoint = endpoint or "wss://api.polymarket.us/v1/ws/user"

    def status(self) -> PrivateFeedStatus:
        return PrivateFeedStatus(
            orders_supported=False,
            positions_supported=False,
            balance_supported=False,
            endpoint=self.endpoint,
        )

    def connect(self) -> None:
        raise NotImplementedError(
            "Private websocket order/position/balance updates are not wired into the BTC5 engine yet."
        )
