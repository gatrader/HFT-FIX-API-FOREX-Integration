#!/usr/bin/env python3
"""
Deterministic parser for the EC2 A/B benchmark recipe.

Consumes two JSONL files produced by running the replica binary with
`RUNTIME_LOG_JSON=1` set, and prints a two-column comparison of the
10 hot-path metrics. stdlib only — no jq, no pandas.

Usage:
    python3 bench/parse.py arm_a_inline.jsonl arm_b_queued.jsonl

Event targets consumed:
    - runtime_tick : 1 Hz sample of the RuntimeStats gauges/counters.
      Fields (all from tracing JSON with flatten_event=true):
        ticks, tick_us, dedups, drops, queue_depth, queue_full_drops,
        last_queue_wait_us, last_http_submit_us,
        ws_fallback_to_rest_count  -> numbers
        last_decision_age_ms, last_submit_age_ms, book_age_ms,
        best_bid, best_ask         -> Debug-formatted strings
                                      ("Some(50)" / "None")
    - hotpath : one event per submit.
      Fields: request_id, sign_us, submit_ms, body_ms, status.

Any other target is ignored. Lines that fail to parse as JSON are
skipped with a stderr warning — the parser does not crash on partial
logs or non-JSON prologue lines.
"""

import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable, List, Optional


# ── helpers ─────────────────────────────────────────────────────────

_DBG_SOME = re.compile(r"^Some\((.*)\)$")


def parse_debug_opt_u64(value: object) -> Optional[int]:
    """`"Some(50)"` -> 50, `"None"` -> None, anything else -> None."""
    if not isinstance(value, str):
        return None
    if value == "None":
        return None
    m = _DBG_SOME.match(value)
    if not m:
        return None
    inner = m.group(1).strip()
    try:
        return int(inner)
    except ValueError:
        return None


def percentile(xs: List[float], p: float) -> Optional[float]:
    if not xs:
        return None
    s = sorted(xs)
    # Nearest-rank. Deterministic, no interpolation surprises.
    k = max(0, min(len(s) - 1, int(round((p / 100.0) * (len(s) - 1)))))
    return s[k]


def fmt(v: Optional[float]) -> str:
    if v is None:
        return "n/a"
    if isinstance(v, float):
        return f"{v:.1f}"
    return str(v)


# ── aggregation ─────────────────────────────────────────────────────

@dataclass
class ArmStats:
    # runtime_tick samples
    tick_count_last: int = 0
    observed_tick_us: List[int] = field(default_factory=list)
    book_age_ms: List[int] = field(default_factory=list)
    queue_depth: List[int] = field(default_factory=list)
    queue_full_drops_last: int = 0
    last_queue_wait_us: List[int] = field(default_factory=list)
    last_http_submit_us: List[int] = field(default_factory=list)
    ws_fallback_last: int = 0
    runtime_tick_samples: int = 0
    # hotpath per-submit samples
    submit_ms: List[int] = field(default_factory=list)
    body_ms: List[int] = field(default_factory=list)
    hotpath_samples: int = 0

    def record_runtime_tick(self, ev: dict) -> None:
        self.runtime_tick_samples += 1
        if isinstance(ev.get("ticks"), int):
            # monotonic counter — keep last observed
            self.tick_count_last = ev["ticks"]
        if isinstance(ev.get("tick_us"), int):
            # observed_tick_us is the most recent tick interval as of
            # the sample; collecting the 1 Hz sequence gives us
            # jitter / p99 behavior.
            self.observed_tick_us.append(ev["tick_us"])
        ba = parse_debug_opt_u64(ev.get("book_age_ms"))
        if ba is not None:
            self.book_age_ms.append(ba)
        if isinstance(ev.get("queue_depth"), int):
            self.queue_depth.append(ev["queue_depth"])
        if isinstance(ev.get("queue_full_drops"), int):
            self.queue_full_drops_last = ev["queue_full_drops"]
        if isinstance(ev.get("last_queue_wait_us"), int):
            v = ev["last_queue_wait_us"]
            # 0 == "no sample yet"; don't pollute the percentile set.
            if v > 0:
                self.last_queue_wait_us.append(v)
        if isinstance(ev.get("last_http_submit_us"), int):
            v = ev["last_http_submit_us"]
            if v > 0:
                self.last_http_submit_us.append(v)
        if isinstance(ev.get("ws_fallback_to_rest_count"), int):
            self.ws_fallback_last = ev["ws_fallback_to_rest_count"]

    def record_hotpath(self, ev: dict) -> None:
        self.hotpath_samples += 1
        if isinstance(ev.get("submit_ms"), int):
            self.submit_ms.append(ev["submit_ms"])
        if isinstance(ev.get("body_ms"), int):
            self.body_ms.append(ev["body_ms"])


def ingest(path: Path) -> ArmStats:
    stats = ArmStats()
    with path.open("r", encoding="utf-8", errors="replace") as f:
        for lineno, raw in enumerate(f, 1):
            raw = raw.strip()
            if not raw:
                continue
            try:
                ev = json.loads(raw)
            except json.JSONDecodeError:
                # non-JSON lines (e.g. startup noise) are fine; skip.
                print(
                    f"warn: {path}:{lineno} not JSON; skipped",
                    file=sys.stderr,
                )
                continue
            if not isinstance(ev, dict):
                continue
            target = ev.get("target")
            if target == "runtime_tick":
                stats.record_runtime_tick(ev)
            elif target == "hotpath":
                stats.record_hotpath(ev)
            # any other target is not part of the A/B table
    return stats


# ── reporting ───────────────────────────────────────────────────────

METRIC_ORDER = [
    "tick_count",
    "observed_tick_us p50",
    "observed_tick_us p99",
    "book_age_ms p50",
    "book_age_ms p99",
    "queue_depth mean",
    "queue_depth max",
    "queue_full_drops total",
    "last_queue_wait_us p50",
    "last_queue_wait_us p99",
    "last_http_submit_us p50",
    "last_http_submit_us p99",
    "submit_ms p50",
    "submit_ms p99",
    "body_ms p50",
    "body_ms p99",
    "ws_fallback_to_rest_count",
    "runtime_tick samples",
    "hotpath samples",
]


def metrics_for(a: ArmStats) -> dict:
    qd_mean = (sum(a.queue_depth) / len(a.queue_depth)) if a.queue_depth else None
    qd_max = max(a.queue_depth) if a.queue_depth else None
    return {
        "tick_count":                  a.tick_count_last,
        "observed_tick_us p50":        percentile(a.observed_tick_us, 50),
        "observed_tick_us p99":        percentile(a.observed_tick_us, 99),
        "book_age_ms p50":             percentile(a.book_age_ms, 50),
        "book_age_ms p99":             percentile(a.book_age_ms, 99),
        "queue_depth mean":            qd_mean,
        "queue_depth max":             qd_max,
        "queue_full_drops total":      a.queue_full_drops_last,
        "last_queue_wait_us p50":      percentile(a.last_queue_wait_us, 50),
        "last_queue_wait_us p99":      percentile(a.last_queue_wait_us, 99),
        "last_http_submit_us p50":     percentile(a.last_http_submit_us, 50),
        "last_http_submit_us p99":     percentile(a.last_http_submit_us, 99),
        "submit_ms p50":               percentile(a.submit_ms, 50),
        "submit_ms p99":               percentile(a.submit_ms, 99),
        "body_ms p50":                 percentile(a.body_ms, 50),
        "body_ms p99":                 percentile(a.body_ms, 99),
        "ws_fallback_to_rest_count":   a.ws_fallback_last,
        "runtime_tick samples":        a.runtime_tick_samples,
        "hotpath samples":             a.hotpath_samples,
    }


def print_table(label_a: str, a: ArmStats, label_b: str, b: ArmStats) -> None:
    ma = metrics_for(a)
    mb = metrics_for(b)
    name_w = max(len(m) for m in METRIC_ORDER)
    col_w = max(16, len(label_a), len(label_b))
    header = f"{'metric'.ljust(name_w)}  {label_a.ljust(col_w)}  {label_b.ljust(col_w)}"
    print(header)
    print("-" * len(header))
    for key in METRIC_ORDER:
        va = fmt(ma[key])
        vb = fmt(mb[key])
        print(f"{key.ljust(name_w)}  {va.ljust(col_w)}  {vb.ljust(col_w)}")


def main(argv: Iterable[str]) -> int:
    args = list(argv)
    if len(args) != 2:
        print(
            "usage: parse.py <arm_a.jsonl> <arm_b.jsonl>",
            file=sys.stderr,
        )
        return 2
    path_a, path_b = Path(args[0]), Path(args[1])
    a = ingest(path_a)
    b = ingest(path_b)
    print_table(path_a.stem, a, path_b.stem, b)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
