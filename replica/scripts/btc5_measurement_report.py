from __future__ import annotations

import argparse
import json
import os
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from statistics import median
from typing import Any


def default_generated_dir() -> Path:
    return Path(__file__).resolve().parents[1] / ".generated"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Build a compact dashboard from the latest BTC5 shadow/reference recorder "
            "output plus the latest reference-vs-bot forensics report."
        )
    )
    parser.add_argument("--generated-dir", default=str(default_generated_dir()))
    parser.add_argument("--output-prefix", default="btc5-measurement-dashboard")
    return parser.parse_args()


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def latest_match(directory: Path, pattern: str) -> Path | None:
    matches = sorted(directory.glob(pattern), key=lambda item: item.stat().st_mtime, reverse=True)
    return matches[0] if matches else None


def round_or_none(value: float | None, digits: int = 4) -> float | None:
    if value is None:
        return None
    return round(float(value), digits)


def summarize_shadow(payload: dict[str, Any]) -> dict[str, Any]:
    windows = payload.get("windows", [])
    if not windows:
        return {
            "windowCount": 0,
            "referenceRowsMedian": 0.0,
            "shadowActionsMedian": 0.0,
            "bestPairedQuoteMin": None,
            "largestShadowResidual": 0.0,
            "shadowFillRate": 0.0,
            "highActivityZeroFillWindows": 0,
            "diagnosis": "No shadow windows captured yet.",
        }
    reference_rows = [float(row.get("referenceTradeRows") or 0.0) for row in windows]
    shadow_actions = [float(row.get("shadowActionCount") or 0.0) for row in windows]
    best_quotes = [
        float(row["bestPairQuoteSeen"])
        for row in windows
        if row.get("bestPairQuoteSeen") is not None
    ]
    residuals = [
        float((row.get("shadowFinalState") or {}).get("residualQty") or 0.0)
        for row in windows
    ]
    total_actions = sum(float(row.get("shadowActionCount") or 0.0) for row in windows)
    total_fills = sum(float(row.get("shadowFillCount") or 0.0) for row in windows)
    zero_fill_high_activity = sum(
        1
        for row in windows
        if float(row.get("referenceTradeRows") or 0.0) >= 200.0
        and float(row.get("shadowActionCount") or 0.0) >= 100.0
        and float(row.get("shadowFillCount") or 0.0) == 0.0
    )
    if zero_fill_high_activity > 0:
        diagnosis = (
            "Shadow recorder is generating many paper actions against very active reference "
            "windows but still showing zero heuristic fills. That strongly suggests our "
            "current cancel/repost model or fill proxy is too different from the reference "
            "wallet's persistent maker behavior."
        )
    else:
        diagnosis = (
            "Shadow recorder is producing at least some heuristic alignment with reference "
            "flow, so the current paper model is informative."
        )
    return {
        "windowCount": len(windows),
        "referenceRowsMedian": median(reference_rows),
        "shadowActionsMedian": median(shadow_actions),
        "bestPairedQuoteMin": min(best_quotes) if best_quotes else None,
        "largestShadowResidual": max(residuals) if residuals else 0.0,
        "shadowFillRate": 0.0 if total_actions <= 0 else total_fills / total_actions,
        "highActivityZeroFillWindows": zero_fill_high_activity,
        "diagnosis": diagnosis,
    }


def summarize_forensics(payload: dict[str, Any]) -> dict[str, Any]:
    reference_windows = payload.get("reference_windows", [])
    bot_windows = payload.get("bot_windows", [])
    ref_rows = [float(row.get("trade_rows") or 0.0) for row in reference_windows]
    ref_avgs = [
        float(row["combined_buy_avg"])
        for row in reference_windows
        if row.get("combined_buy_avg") is not None
    ]
    bot_residuals = [float(row.get("residual_qty") or 0.0) for row in bot_windows]
    bot_avgs = [
        float(row["combined_buy_avg"])
        for row in bot_windows
        if row.get("combined_buy_avg") is not None
    ]
    return {
        "referenceWindowCount": len(reference_windows),
        "botWindowCount": len(bot_windows),
        "referenceMedianTradeRows": median(ref_rows) if ref_rows else 0.0,
        "referenceMinCombinedAvg": min(ref_avgs) if ref_avgs else None,
        "referenceMaxCombinedAvg": max(ref_avgs) if ref_avgs else None,
        "botMedianResidual": median(bot_residuals) if bot_residuals else 0.0,
        "botMinCombinedAvg": min(bot_avgs) if bot_avgs else None,
        "botMaxCombinedAvg": max(bot_avgs) if bot_avgs else None,
    }


def recorder_status(generated_dir: Path) -> dict[str, Any]:
    pid_file = generated_dir / "overnight-shadow-recorder.pid.json"
    if not pid_file.exists():
        return {"status": "missing"}
    payload = load_json(pid_file)
    pid = int(payload.get("pid") or 0)
    status = "stopped"
    if pid > 0:
        try:
            if os.name == "nt":
                result = subprocess.run(
                    ["powershell", "-NoProfile", "-Command", f"Get-Process -Id {pid}"],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=False,
                )
                status = "running" if result.returncode == 0 else "stopped"
            else:
                os.kill(pid, 0)
                status = "running"
        except Exception:
            status = "stopped"
    return {
        "status": status,
        "pid": pid,
        "startedAtUtc": payload.get("startedAtUtc"),
        "stdout": payload.get("stdout"),
        "stderr": payload.get("stderr"),
    }


def render_markdown(payload: dict[str, Any]) -> str:
    shadow = payload["shadow"]
    forensics = payload["forensics"]
    recorder = payload["recorder"]
    lines = [
        "# BTC5 Measurement Dashboard",
        "",
        f"Generated: `{payload['generatedAtUtc']}`",
        "",
        "## Recorder",
        "",
        f"- Status: `{recorder['status']}`",
    ]
    if recorder.get("startedAtUtc"):
        lines.append(f"- Started: `{recorder['startedAtUtc']}`")
    if recorder.get("stdout"):
        lines.append(f"- Stdout log: `{recorder['stdout']}`")
    if recorder.get("stderr"):
        lines.append(f"- Stderr log: `{recorder['stderr']}`")
    lines.extend(
        [
            "",
            "## Shadow Recorder Snapshot",
            "",
            f"- Windows captured: `{shadow['windowCount']}`",
            f"- Median reference trade rows/window: `{round(shadow['referenceRowsMedian'], 2)}`",
            f"- Median shadow actions/window: `{round(shadow['shadowActionsMedian'], 2)}`",
            f"- Best paired quote seen: `{round_or_none(shadow['bestPairedQuoteMin'])}`",
            f"- Largest shadow residual: `{round(shadow['largestShadowResidual'], 4)}`",
            f"- Shadow fill rate: `{round(shadow['shadowFillRate'], 6)}`",
            f"- High-activity zero-fill windows: `{shadow['highActivityZeroFillWindows']}`",
            f"- Diagnosis: {shadow['diagnosis']}",
            "",
            "## Recent Wallet Forensics",
            "",
            f"- Reference windows analyzed: `{forensics['referenceWindowCount']}`",
            f"- Bot windows analyzed: `{forensics['botWindowCount']}`",
            f"- Reference median trade rows/window: `{round(forensics['referenceMedianTradeRows'], 2)}`",
            f"- Reference combined avg range: `{round_or_none(forensics['referenceMinCombinedAvg'])}` to `{round_or_none(forensics['referenceMaxCombinedAvg'])}`",
            f"- Bot median residual: `{round(forensics['botMedianResidual'], 4)}`",
            f"- Bot combined avg range: `{round_or_none(forensics['botMinCombinedAvg'])}` to `{round_or_none(forensics['botMaxCombinedAvg'])}`",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    generated_dir = Path(args.generated_dir)
    shadow_path = latest_match(generated_dir, "btc5-shadow-vs-reference.*.json")
    forensics_path = latest_match(generated_dir, "reference_wallet_vs_bot_forensics_*.json")
    shadow_payload = load_json(shadow_path) if shadow_path else {"windows": []}
    forensics_payload = (
        load_json(forensics_path)
        if forensics_path
        else {"reference_windows": [], "bot_windows": []}
    )
    payload = {
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "shadowSource": None if shadow_path is None else str(shadow_path),
        "forensicsSource": None if forensics_path is None else str(forensics_path),
        "recorder": recorder_status(generated_dir),
        "shadow": summarize_shadow(shadow_payload),
        "forensics": summarize_forensics(forensics_payload),
    }
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    json_path = generated_dir / f"{args.output_prefix}.{stamp}.json"
    md_path = generated_dir / f"{args.output_prefix}.{stamp}.md"
    json_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    md_path.write_text(render_markdown(payload), encoding="utf-8")
    print(json.dumps({"json": str(json_path), "markdown": str(md_path)}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
