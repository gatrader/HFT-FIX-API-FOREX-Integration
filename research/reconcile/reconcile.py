#!/usr/bin/env python3
"""Slug-by-slug reconciler for arbigab-bot DB vs public Polymarket activity.

Given one or more reference wallets and (optionally) a gabagool.db, this
script produces a per-slug overlap report: which slugs were touched by the
bot, which are currently held / historically traded by each wallet, and where
those sources overlap.

Usage:
    ./reconcile.py \
        --wallet 0x0006af12cd4dacc450836a0e1ec6ce47365d8c63:main \
        --wallet 0xb27bc932bf8110d8f78e55da7d5f0497a18b5b82:alt \
        --db ../../bot/web/data/gabagool.db \
        --out report.md

Offline mode (pre-downloaded JSON, no network):
    ./reconcile.py \
        --wallet 0x0006...:main \
        --fixtures fixtures/ \
        --out report.md

In offline mode the script reads:
    fixtures/{label}.positions.json
    fixtures/{label}.trades.json

where {label} is the part after `:` in --wallet.
"""

from __future__ import annotations

import argparse
import json
import os
import sqlite3
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field
from typing import Any

DATA_API = "https://data-api.polymarket.com"
PAGE = 500


# --- models ----------------------------------------------------------------

@dataclass
class BotFill:
    slug: str
    symbol: str
    side: str            # "BUY" | "SELL"
    trader_side: str     # "UP" | "DOWN"
    size: float
    price: float
    ts_unix: int

    @property
    def notional(self) -> float:
        return self.size * self.price


@dataclass
class PublicPosition:
    slug: str
    event_slug: str | None
    condition_id: str
    asset: str           # tokenId
    outcome: str         # "Yes" | "No"
    size: float
    avg_price: float
    cash_pnl: float
    realized_pnl: float


@dataclass
class PublicTrade:
    slug: str
    event_slug: str | None
    condition_id: str
    asset: str
    side: str            # BUY | SELL
    outcome: str
    size: float
    price: float
    ts_unix: int
    tx: str


@dataclass
class WalletSnapshot:
    label: str
    address: str
    positions: list[PublicPosition] = field(default_factory=list)
    trades: list[PublicTrade] = field(default_factory=list)


# --- data-api fetch --------------------------------------------------------

def _get_json(url: str, retries: int = 3) -> Any:
    last_err: Exception | None = None
    for attempt in range(retries):
        req = urllib.request.Request(url, headers={"User-Agent": "reconcile/0.1"})
        try:
            with urllib.request.urlopen(req, timeout=20) as resp:
                return json.loads(resp.read())
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
            last_err = e
            time.sleep(2 ** attempt)
    raise RuntimeError(f"fetch failed after {retries} attempts: {url} — {last_err}")


def fetch_positions(addr: str) -> list[dict]:
    out: list[dict] = []
    offset = 0
    while True:
        qs = urllib.parse.urlencode({
            "user": addr, "limit": PAGE, "offset": offset, "sizeThreshold": "0",
        })
        page = _get_json(f"{DATA_API}/positions?{qs}")
        if not isinstance(page, list):
            raise RuntimeError(f"unexpected /positions shape: {type(page).__name__}")
        out.extend(page)
        if len(page) < PAGE:
            break
        offset += PAGE
    return out


def fetch_trades(addr: str) -> list[dict]:
    out: list[dict] = []
    offset = 0
    while True:
        qs = urllib.parse.urlencode({
            "user": addr, "limit": PAGE, "offset": offset, "takerOnly": "false",
        })
        page = _get_json(f"{DATA_API}/trades?{qs}")
        if not isinstance(page, list):
            raise RuntimeError(f"unexpected /trades shape: {type(page).__name__}")
        out.extend(page)
        if len(page) < PAGE:
            break
        offset += PAGE
    return out


# --- fixture fallback ------------------------------------------------------

def load_fixtures(fixtures_dir: str, label: str) -> tuple[list[dict], list[dict]]:
    pos_path = os.path.join(fixtures_dir, f"{label}.positions.json")
    trd_path = os.path.join(fixtures_dir, f"{label}.trades.json")
    positions: list[dict] = []
    trades: list[dict] = []
    if os.path.exists(pos_path):
        with open(pos_path) as f:
            positions = json.load(f)
    if os.path.exists(trd_path):
        with open(trd_path) as f:
            trades = json.load(f)
    return positions, trades


# --- normalisation ---------------------------------------------------------

def _slug_of(raw: dict) -> str:
    return raw.get("slug") or raw.get("eventSlug") or raw.get("marketSlug") or ""


def _ts_of(raw: dict) -> int:
    for k in ("timestamp", "ts", "time"):
        v = raw.get(k)
        if isinstance(v, (int, float)):
            return int(v)
    return 0


def normalise_positions(rows: list[dict]) -> list[PublicPosition]:
    out = []
    for r in rows:
        if float(r.get("size", 0) or 0) == 0:
            continue
        out.append(PublicPosition(
            slug=_slug_of(r),
            event_slug=r.get("eventSlug"),
            condition_id=r.get("conditionId", ""),
            asset=r.get("asset", ""),
            outcome=r.get("outcome", ""),
            size=float(r.get("size", 0) or 0),
            avg_price=float(r.get("avgPrice", 0) or 0),
            cash_pnl=float(r.get("cashPnl", 0) or 0),
            realized_pnl=float(r.get("realizedPnl", 0) or 0),
        ))
    return out


def normalise_trades(rows: list[dict]) -> list[PublicTrade]:
    out = []
    for r in rows:
        out.append(PublicTrade(
            slug=_slug_of(r),
            event_slug=r.get("eventSlug"),
            condition_id=r.get("conditionId", ""),
            asset=r.get("asset", ""),
            side=str(r.get("side", "")).upper(),
            outcome=r.get("outcome", ""),
            size=float(r.get("size", 0) or 0),
            price=float(r.get("price", 0) or 0),
            ts_unix=_ts_of(r),
            tx=r.get("transactionHash", ""),
        ))
    return out


# --- bot DB ---------------------------------------------------------------

def load_bot_fills(db_path: str) -> list[BotFill]:
    if not os.path.exists(db_path):
        return []
    con = sqlite3.connect(db_path)
    try:
        cur = con.cursor()
        # Join Trade → Market to get slug/symbol; schema field names follow Prisma.
        cur.execute("""
            SELECT m.slug, m.symbol, t.side, t.traderSide, t.size, t.price,
                   strftime('%s', t.timestamp)
            FROM Trade t
            JOIN Market m ON m.id = t.marketId
        """)
        rows = cur.fetchall()
    finally:
        con.close()
    fills = []
    for slug, symbol, side, trader_side, size, price, ts in rows:
        fills.append(BotFill(
            slug=slug or "",
            symbol=symbol or "",
            side=(side or "").upper(),
            trader_side=(trader_side or "").upper(),
            size=float(size or 0),
            price=float(price or 0),
            ts_unix=int(ts or 0),
        ))
    return fills


# --- reconciliation -------------------------------------------------------

def reconcile(
    wallets: list[WalletSnapshot],
    bot_fills: list[BotFill],
) -> dict:
    by_slug: dict[str, dict] = {}

    def bucket(slug: str) -> dict:
        return by_slug.setdefault(slug, {
            "slug": slug,
            "bot_fills": [],
            "wallets": {w.label: {
                "positions": [], "trades": [],
            } for w in wallets},
        })

    for f in bot_fills:
        if f.slug:
            bucket(f.slug)["bot_fills"].append(f)

    for w in wallets:
        for p in w.positions:
            if p.slug:
                bucket(p.slug)["wallets"][w.label]["positions"].append(p)
        for t in w.trades:
            if t.slug:
                bucket(t.slug)["wallets"][w.label]["trades"].append(t)

    # Compute overlap summary
    labels = [w.label for w in wallets]
    summary = {
        "slug_count": len(by_slug),
        "bot_slugs": sum(1 for b in by_slug.values() if b["bot_fills"]),
        "per_wallet_current_slugs": {
            w.label: sum(1 for b in by_slug.values() if b["wallets"][w.label]["positions"])
            for w in wallets
        },
        "per_wallet_historical_slugs": {
            w.label: sum(1 for b in by_slug.values() if b["wallets"][w.label]["trades"])
            for w in wallets
        },
        "bot_and_wallet_overlap": {
            w.label: sum(
                1 for b in by_slug.values()
                if b["bot_fills"] and (
                    b["wallets"][w.label]["positions"]
                    or b["wallets"][w.label]["trades"]
                )
            )
            for w in wallets
        },
        "between_wallet_overlap": (
            sum(
                1 for b in by_slug.values()
                if all(
                    b["wallets"][lbl]["positions"] or b["wallets"][lbl]["trades"]
                    for lbl in labels
                )
            ) if len(labels) >= 2 else 0
        ),
    }

    return {"slugs": by_slug, "summary": summary, "labels": labels}


# --- report --------------------------------------------------------------

def render_markdown(result: dict) -> str:
    labels = result["labels"]
    s = result["summary"]
    lines: list[str] = []
    lines.append("# Slug-by-slug reconciliation report\n")
    lines.append(f"Generated: `{time.strftime('%Y-%m-%d %H:%M:%S UTC', time.gmtime())}`\n")
    lines.append("## Summary\n")
    lines.append(f"- Total slugs across all sources: **{s['slug_count']}**")
    lines.append(f"- Slugs touched by the bot DB: **{s['bot_slugs']}**")
    for lbl in labels:
        lines.append(f"- `{lbl}` current open positions: **{s['per_wallet_current_slugs'][lbl]}** slugs")
        lines.append(f"- `{lbl}` historical trades: **{s['per_wallet_historical_slugs'][lbl]}** slugs")
        lines.append(f"- bot ∩ `{lbl}`: **{s['bot_and_wallet_overlap'][lbl]}** slugs")
    if len(labels) >= 2:
        lines.append(f"- **{' ∩ '.join(f'`{l}`' for l in labels)}**: **{s['between_wallet_overlap']}** slugs")
    lines.append("")

    # Interesting slugs first: ones that touch >=2 sources
    def rank(b):
        n = 0
        if b["bot_fills"]:
            n += 1
        for lbl in labels:
            if b["wallets"][lbl]["positions"] or b["wallets"][lbl]["trades"]:
                n += 1
        return (-n, b["slug"])

    slugs = sorted(result["slugs"].values(), key=rank)

    lines.append("## Per-slug detail\n")
    lines.append("Legend: **B** = bot fills present; **O** = wallet currently open; **H** = wallet historical trades; **.** = none.\n")
    header = "| slug | B |" + "".join(f" {l} |" for l in labels) + " bot Σ size | wallet openΣ | wallet histΣ |"
    sep = "|------|---|" + "|".join(["---"] * len(labels)) + "|------|------|------|"
    lines.append(header)
    lines.append(sep)

    for b in slugs:
        bot_tag = "B" if b["bot_fills"] else "."
        wallet_tags = []
        wallet_open_size = 0.0
        wallet_hist_size = 0.0
        for lbl in labels:
            has_pos = bool(b["wallets"][lbl]["positions"])
            has_trd = bool(b["wallets"][lbl]["trades"])
            tag = ("O" if has_pos else "") + ("H" if has_trd else "")
            tag = tag or "."
            wallet_tags.append(tag)
            wallet_open_size += sum(p.size for p in b["wallets"][lbl]["positions"])
            wallet_hist_size += sum(t.size for t in b["wallets"][lbl]["trades"])
        bot_size = sum(f.size for f in b["bot_fills"])
        lines.append(
            f"| `{b['slug'] or '(blank)'}` | {bot_tag} |"
            + "".join(f" {t} |" for t in wallet_tags)
            + f" {bot_size:.2f} | {wallet_open_size:.2f} | {wallet_hist_size:.2f} |"
        )

    # Full rows for anything that overlaps bot+wallet or wallet+wallet
    overlap_rows = [
        b for b in slugs
        if (
            (b["bot_fills"] and any(
                b["wallets"][lbl]["positions"] or b["wallets"][lbl]["trades"]
                for lbl in labels
            ))
            or (
                len(labels) >= 2
                and all(
                    b["wallets"][lbl]["positions"] or b["wallets"][lbl]["trades"]
                    for lbl in labels
                )
            )
        )
    ]

    if overlap_rows:
        lines.append("\n## Overlap detail\n")
        for b in overlap_rows:
            lines.append(f"### `{b['slug']}`\n")
            if b["bot_fills"]:
                lines.append("**Bot fills:**\n")
                lines.append("| ts | side | traderSide | size | price |")
                lines.append("|---|---|---|---|---|")
                for f in sorted(b["bot_fills"], key=lambda x: x.ts_unix):
                    ts = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime(f.ts_unix)) if f.ts_unix else ""
                    lines.append(f"| {ts} | {f.side} | {f.trader_side} | {f.size} | {f.price} |")
            for lbl in labels:
                bw = b["wallets"][lbl]
                if bw["positions"]:
                    lines.append(f"\n**`{lbl}` current positions:**\n")
                    lines.append("| outcome | size | avgPrice | cashPnl |")
                    lines.append("|---|---|---|---|")
                    for p in bw["positions"]:
                        lines.append(f"| {p.outcome} | {p.size} | {p.avg_price} | {p.cash_pnl} |")
                if bw["trades"]:
                    lines.append(f"\n**`{lbl}` trades:**\n")
                    lines.append("| ts | side | outcome | size | price | tx |")
                    lines.append("|---|---|---|---|---|---|")
                    for t in sorted(bw["trades"], key=lambda x: x.ts_unix):
                        ts = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime(t.ts_unix)) if t.ts_unix else ""
                        tx = (t.tx[:10] + "…") if t.tx else ""
                        lines.append(f"| {ts} | {t.side} | {t.outcome} | {t.size} | {t.price} | {tx} |")
            lines.append("")

    return "\n".join(lines) + "\n"


# --- entry ---------------------------------------------------------------

def parse_wallet(spec: str) -> tuple[str, str]:
    if ":" in spec:
        addr, label = spec.split(":", 1)
    else:
        addr, label = spec, spec[:10]
    return addr.lower(), label


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--wallet", action="append", required=True,
                    help="ADDR[:label], repeatable")
    ap.add_argument("--db", default=None, help="path to gabagool.db")
    ap.add_argument("--fixtures", default=None,
                    help="use pre-downloaded {label}.{positions,trades}.json files")
    ap.add_argument("--out", default="report.md")
    ap.add_argument("--raw-out", default=None, help="also dump raw JSON structure")
    args = ap.parse_args()

    wallets: list[WalletSnapshot] = []
    for spec in args.wallet:
        addr, label = parse_wallet(spec)
        if args.fixtures:
            pos_raw, trd_raw = load_fixtures(args.fixtures, label)
        else:
            print(f"[fetch] {label} {addr} positions…", file=sys.stderr)
            pos_raw = fetch_positions(addr)
            print(f"[fetch] {label} {addr} trades…", file=sys.stderr)
            trd_raw = fetch_trades(addr)
        wallets.append(WalletSnapshot(
            label=label,
            address=addr,
            positions=normalise_positions(pos_raw),
            trades=normalise_trades(trd_raw),
        ))

    bot_fills = load_bot_fills(args.db) if args.db else []

    result = reconcile(wallets, bot_fills)
    md = render_markdown(result)
    with open(args.out, "w") as f:
        f.write(md)
    print(f"[write] {args.out} ({len(md)} bytes)")

    if args.raw_out:
        raw = {
            "labels": result["labels"],
            "summary": result["summary"],
            "slugs": {
                slug: {
                    "bot_fills": [f.__dict__ for f in b["bot_fills"]],
                    "wallets": {
                        lbl: {
                            "positions": [p.__dict__ for p in b["wallets"][lbl]["positions"]],
                            "trades": [t.__dict__ for t in b["wallets"][lbl]["trades"]],
                        }
                        for lbl in result["labels"]
                    },
                }
                for slug, b in result["slugs"].items()
            },
        }
        with open(args.raw_out, "w") as f:
            json.dump(raw, f, indent=2)
        print(f"[write] {args.raw_out}")

    # Exit code signals whether any bot∩wallet or wallet∩wallet overlap was found.
    any_overlap = any(result["summary"]["bot_and_wallet_overlap"].values())
    any_overlap |= result["summary"]["between_wallet_overlap"] > 0
    return 0 if not any_overlap else 2


if __name__ == "__main__":
    sys.exit(main())
