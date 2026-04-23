"""Offline replay harness for BTC5 shadow-window JSONs.

The live shadow recorder (btc5_shadow_reference.py) is read-only
against public Polymarket APIs, but reruns still cost wall-clock
time and only measure *today's* market. Each completed 5-minute
window is persisted to
``.generated/<ts>.<slug>.shadow-window.json`` with the per-cycle
``decision["actions"]`` sequence embedded. Those action sequences
are the planner's raw output and are the only input
``reconcile_orders`` needs to classify behavior under a different
band / TTL / phase configuration.

This harness replays those recorded cycles through
``reconcile_orders`` at arbitrary reconcile-band settings so we can
answer "what would preserved / amended / cancelled / created look
like if the band were 0/1/2/3 ticks?" without re-running the
recorder. Pure function over recorded inputs — fully deterministic
and sandbox-runnable.

Usage
-----

Single file, single band:

    python3 replica/scripts/btc5_shadow_replay.py \
        replica/.generated/20260423T130146Z.btc-updown-5m-1776949500.shadow-window.json \
        --price-band-ticks 1

Sweep mode over many files and multiple bands:

    python3 replica/scripts/btc5_shadow_replay.py \
        replica/.generated/20260423T130146Z.btc-updown-5m-*.shadow-window.json \
        --sweep-bands 0,1,2,3

Output is a compact table with reconcile-op percentages and
anchor-residency distributions per band setting, so regressions /
wins are visible at a glance without a second pipeline.
"""
from __future__ import annotations

import argparse
import glob
import json
import math
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

# Keep the harness self-contained — the scripts directory is already
# on PYTHONPATH when run as a CLI, but tests import it directly.
HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from btc5_ladder_manager import WorkingOrder, reconcile_orders


def _cycle_ts(cycle: dict[str, Any], *, fallback_index: int) -> float:
    """Best-effort float timestamp for a cycle.

    Prefer the recorded wall clock; fall back to a monotonic proxy
    based on cycle index so replays don't collapse TTL logic even
    when timestamps are absent.
    """
    raw = cycle.get("timestamp") or cycle.get("timestampUtc")
    if isinstance(raw, (int, float)):
        return float(raw)
    if isinstance(raw, str):
        try:
            from datetime import datetime
            return datetime.fromisoformat(raw.replace("Z", "+00:00")).timestamp()
        except ValueError:
            pass
    # Proxy: 1 second per cycle so TTL logic at 30–60s still behaves.
    return float(fallback_index)


def replay_window(
    window_path: Path,
    *,
    price_band_ticks: int,
    size_band_shares: float,
    ttl_seconds: float,
) -> dict[str, Any]:
    """Replay one shadow-window JSON through reconcile_orders.

    Returns a dict with reconcile-op counts and a handful of derived
    metrics so the caller can score configurations directly.
    """
    with window_path.open("r", encoding="utf-8") as fh:
        window = json.load(fh)
    slug = window.get("event", {}).get("slug") or "replay"

    working: list[WorkingOrder] = []
    counts = {"created": 0, "amended": 0, "preserved": 0, "cancelled": 0}
    price_drifts: list[float] = []
    cycle_count = 0
    action_count = 0
    preserve_with_drift = 0  # within-band preserves that were NOT
                             # exact matches — the anchor-residency
                             # win the spec targets

    price_band = float(price_band_ticks) * 0.01
    for index, cycle in enumerate(window.get("cycles") or [], start=1):
        actions = (cycle.get("decision") or {}).get("actions") or []
        if not actions:
            continue
        cycle_count += 1
        action_count += len(actions)
        now_ts = _cycle_ts(cycle, fallback_index=index)
        working, rec = reconcile_orders(
            existing_orders=working,
            actions=actions,
            now_ts=now_ts,
            ttl_seconds=ttl_seconds,
            cycle_index=index,
            slug=slug,
            price_band=price_band,
            size_band=size_band_shares,
        )
        for key in counts:
            counts[key] += len(rec.get(key) or [])
        for preserved in rec.get("preserved") or []:
            drift = float(preserved.get("priceDrift") or 0.0)
            price_drifts.append(drift)
            if drift > 1e-9:
                preserve_with_drift += 1

    total = sum(counts.values())
    return {
        "path": str(window_path),
        "cyclesWithActions": cycle_count,
        "totalActions": action_count,
        "counts": counts,
        "totalOps": total,
        "percentages": {
            k: (100.0 * v / total) if total else 0.0 for k, v in counts.items()
        },
        "preserveWithDrift": preserve_with_drift,
        "meanPreservedDrift": (
            sum(price_drifts) / len(price_drifts) if price_drifts else 0.0
        ),
        "priceBandTicks": int(price_band_ticks),
        "sizeBandShares": float(size_band_shares),
    }


def aggregate(results: list[dict[str, Any]]) -> dict[str, Any]:
    """Fold per-window results into a single scoreboard row."""
    totals = {"created": 0, "amended": 0, "preserved": 0, "cancelled": 0}
    cycles = 0
    actions = 0
    preserve_drift = 0
    drift_sum = 0.0
    drift_n = 0
    for r in results:
        for k, v in r["counts"].items():
            totals[k] += v
        cycles += r["cyclesWithActions"]
        actions += r["totalActions"]
        preserve_drift += r["preserveWithDrift"]
        drift_sum += r["meanPreservedDrift"] * len(r["counts"])  # weight by ops
        drift_n += len(r["counts"])
    total_ops = sum(totals.values())
    return {
        "windows": len(results),
        "cycles": cycles,
        "actions": actions,
        "totalOps": total_ops,
        "counts": totals,
        "percentages": {
            k: (100.0 * v / total_ops) if total_ops else 0.0
            for k, v in totals.items()
        },
        "preserveWithDrift": preserve_drift,
    }


def _format_row(label: str, agg: dict[str, Any]) -> str:
    p = agg["percentages"]
    return (
        f"{label:>10s}  "
        f"ops={agg['totalOps']:6d}  "
        f"preserved={p['preserved']:5.1f}%  "
        f"amended={p['amended']:5.1f}%  "
        f"created={p['created']:5.1f}%  "
        f"cancelled={p['cancelled']:5.1f}%  "
        f"preserveWithDrift={agg['preserveWithDrift']:4d}"
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Offline replay of BTC5 shadow-window JSONs through reconcile_orders.",
    )
    parser.add_argument(
        "inputs",
        nargs="+",
        help="Shadow-window JSON paths (globs supported).",
    )
    parser.add_argument(
        "--price-band-ticks",
        type=int,
        default=0,
        help="Reconcile price band in venue ticks for single-band mode.",
    )
    parser.add_argument(
        "--size-band-shares",
        type=float,
        default=0.0,
        help="Reconcile size band in shares.",
    )
    parser.add_argument(
        "--ladder-ttl-seconds",
        type=float,
        default=30.0,
        help="TTL applied during replay; match your live recorder.",
    )
    parser.add_argument(
        "--sweep-bands",
        type=str,
        default="",
        help=(
            "Comma-separated tick values for a sweep. When set, "
            "--price-band-ticks is ignored and the tool prints one "
            "scoreboard row per band setting."
        ),
    )
    args = parser.parse_args()

    # Expand globs so shell-less callers can pass literal wildcards.
    paths: list[Path] = []
    for pattern in args.inputs:
        expanded = sorted(glob.glob(pattern))
        if expanded:
            paths.extend(Path(p) for p in expanded)
        else:
            paths.append(Path(pattern))
    paths = [p for p in paths if p.exists() and p.is_file()]
    if not paths:
        print("no shadow-window files matched", file=sys.stderr)
        return 2

    bands: list[int]
    if args.sweep_bands:
        bands = [int(b.strip()) for b in args.sweep_bands.split(",") if b.strip()]
    else:
        bands = [args.price_band_ticks]

    print(f"replay: {len(paths)} file(s), bands={bands}, "
          f"sizeBand={args.size_band_shares}, ttl={args.ladder_ttl_seconds}s")
    for band in bands:
        results = [
            replay_window(
                p,
                price_band_ticks=band,
                size_band_shares=args.size_band_shares,
                ttl_seconds=args.ladder_ttl_seconds,
            )
            for p in paths
        ]
        agg = aggregate(results)
        print(_format_row(f"band={band}t", agg))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
