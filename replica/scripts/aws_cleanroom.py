from __future__ import annotations

import argparse
import csv
import json
import os
import re
import shlex
import subprocess
import sys
import time
from dataclasses import dataclass
from datetime import date, datetime, timezone
from pathlib import Path


DEFAULT_HOST = os.environ.get("REPLICA_AWS_HOST", "ubuntu@34.251.21.41")
DEFAULT_ROOT = os.environ.get(
    "REPLICA_AWS_ROOT",
    f"/home/ubuntu/autoredeeem-{date.today().isoformat()}",
)
DEFAULT_PORT = int(os.environ.get("REPLICA_AWS_PORT", "22"))
DEFAULT_KEY_ENV = "REPLICA_AWS_KEY"
DRY_RUN_TEST_KEY = (
    "0x59c6995e998f97a5a0044966f0945382d7c4cf4e867e5a1a1b3f1f1b2c3d4e5f"
)


@dataclass(frozen=True)
class SyncItem:
    local_path: Path
    remote_path: str


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def default_identity() -> Path | None:
    env_value = os.environ.get(DEFAULT_KEY_ENV, "")
    if env_value:
        path = Path(env_value).expanduser()
        if path.exists():
            return path
    downloads_candidate = Path.home() / "Downloads" / "aws-trading-key.pem"
    if downloads_candidate.exists():
        return downloads_candidate
    return None


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Bitdefender-safe AWS clean-room helper for the BTC5 / autoredeem workflow."
        )
    )
    parser.add_argument("--host", default=DEFAULT_HOST, help="SSH target, e.g. ubuntu@34.251.21.41")
    parser.add_argument(
        "--identity",
        default=str(default_identity() or ""),
        help=f"SSH private key path. Defaults to ${DEFAULT_KEY_ENV} or ~/Downloads/aws-trading-key.pem when present.",
    )
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help="SSH port.")
    parser.add_argument("--remote-root", default=DEFAULT_ROOT, help="Remote clean-room root directory.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    sync_parser = subparsers.add_parser("sync", help="Upload the local helper scripts into the remote clean room.")
    sync_parser.add_argument("--quiet", action="store_true", help="Suppress scp progress output.")

    prepare_parser = subparsers.add_parser(
        "prepare-btc5",
        help="Resolve the current/next BTC5 market on AWS and generate fresh comparison files.",
    )
    prepare_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")
    prepare_parser.add_argument("--which", choices=("current", "next"), default="next")
    prepare_parser.add_argument("--slug", default="", help="Explicit BTC5 slug to prepare.")
    prepare_parser.add_argument("--output-dir", default="generated")
    prepare_parser.add_argument("--symbol-prefix", default="btc5-canary")
    prepare_parser.add_argument("--max-buy-order-size", type=float, default=5.0)
    prepare_parser.add_argument("--seed-shares", type=float, default=5.0)
    prepare_parser.add_argument("--min-price", type=float, default=0.35)
    prepare_parser.add_argument("--max-price", type=float, default=0.65)
    prepare_parser.add_argument("--stop-before-end-ms", type=int, default=20000)
    prepare_parser.add_argument("--cancel-orders-on-start", action="store_true", default=True)

    redeem_parser = subparsers.add_parser(
        "autoredeem-dry",
        help="Run the remote autoredeem scan in dry-run mode.",
    )
    redeem_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")
    redeem_parser.add_argument("--wallet-type", choices=("eoa", "proxy", "safe"), required=True)
    redeem_parser.add_argument("--wallet-address", required=True)
    redeem_parser.add_argument("--min-value", type=float, default=0.01)
    redeem_parser.add_argument("--limit", type=int, default=0)
    redeem_parser.add_argument("--include-negative-risk", action="store_true")
    redeem_parser.add_argument("--allow-wallet-mismatch", action="store_true", default=True)

    canary_parser = subparsers.add_parser(
        "canary",
        help="Run the remote single-order BTC5 canary script. Requires explicit live-money confirmation.",
    )
    canary_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")
    canary_parser.add_argument("--side", choices=("up", "down"), required=True)
    canary_parser.add_argument("--live-ok", action="store_true", help="Required guardrail for the real-money canary.")

    paired_parser = subparsers.add_parser(
        "paired",
        help="Run the remote paired BTC5 coordinator. Dry-run by default; add --live-ok for real orders.",
    )
    paired_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")
    paired_parser.add_argument("--which", choices=("current", "next"), default="current")
    paired_parser.add_argument("--pair-shares", type=float, default=5.0)
    paired_parser.add_argument("--edge-threshold", type=float, default=0.96)
    paired_parser.add_argument("--lookahead-windows", type=int, default=6)
    paired_parser.add_argument("--depth-band", type=float, default=0.02)
    paired_parser.add_argument("--min-depth-ratio", type=float, default=1.5)
    paired_parser.add_argument("--min-best-level-ratio", type=float, default=0.5)
    paired_parser.add_argument("--live-ok", action="store_true", help="Required guardrail for the real-money paired run.")

    accumulate_parser = subparsers.add_parser(
        "accumulate",
        help="Run the maker-style BTC5 rolling accumulator. Dry-run by default; add --live-ok for real orders.",
    )
    accumulate_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")
    accumulate_parser.add_argument("--which", choices=("current", "next"), default="current")
    accumulate_parser.add_argument("--watch-seconds", type=int, default=240)
    accumulate_parser.add_argument("--residual-watch-seconds", type=int, default=120)
    accumulate_parser.add_argument("--poll-seconds", type=float, default=1.0)
    accumulate_parser.add_argument("--rest-seconds", type=float, default=1.25)
    accumulate_parser.add_argument("--clip-shares", type=float, default=5.0)
    accumulate_parser.add_argument("--entry-threshold", type=float, default=0.98)
    accumulate_parser.add_argument("--rebalance-threshold", type=float, default=0.98)
    accumulate_parser.add_argument("--max-residual-shares", type=float, default=5.0)
    accumulate_parser.add_argument("--late-session-residual-seconds", type=int, default=90)
    accumulate_parser.add_argument("--late-session-residual-threshold", type=float, default=1.0)
    accumulate_parser.add_argument("--session-residual-stop-shares", type=float, default=5.0)
    accumulate_parser.add_argument("--session-residual-stop-ratio", type=float, default=0.25)
    accumulate_parser.add_argument("--inventory-skew-step", type=float, default=0.01)
    accumulate_parser.add_argument("--inventory-skew-trigger-shares", type=float, default=5.0)
    accumulate_parser.add_argument("--early-session-seconds", type=int, default=120)
    accumulate_parser.add_argument("--early-session-flat-residual-threshold", type=float, default=1.0)
    accumulate_parser.add_argument("--early-session-pair-budget", type=float, default=20.0)
    accumulate_parser.add_argument("--early-session-max-actions", type=int, default=8)
    accumulate_parser.add_argument("--lookahead-windows", type=int, default=6)
    accumulate_parser.add_argument("--bid-improve", type=float, default=0.0)
    accumulate_parser.add_argument("--maker-layers", type=int, default=3)
    accumulate_parser.add_argument("--maker-price-step", type=float, default=0.01)
    accumulate_parser.add_argument("--maker-pair-threshold", type=float, default=1.02)
    accumulate_parser.add_argument("--maker-layer-size-ratio", type=float, default=0.5)
    accumulate_parser.add_argument("--max-actions-per-cycle", type=int, default=6)
    accumulate_parser.add_argument("--depth-band", type=float, default=0.02)
    accumulate_parser.add_argument("--min-depth-ratio", type=float, default=1.5)
    accumulate_parser.add_argument("--min-best-level-ratio", type=float, default=0.5)
    accumulate_parser.add_argument("--min-order-notional", type=float, default=1.0)
    accumulate_parser.add_argument("--max-clip-shares", type=float, default=10.0)
    accumulate_parser.add_argument("--wallet-address", default="")
    accumulate_parser.add_argument("--live-ok", action="store_true", help="Required guardrail for the real-money accumulator run.")

    watch_parser = subparsers.add_parser(
        "watch-paired",
        help="Poll current BTC5 markets until a paired edge appears, then optionally fire a guarded live run.",
    )
    watch_parser.add_argument("--no-sync", action="store_true", help="Skip the initial sync step.")
    watch_parser.add_argument("--pair-shares", type=float, default=5.0)
    watch_parser.add_argument("--edge-threshold", type=float, default=0.96)
    watch_parser.add_argument("--lookahead-windows", type=int, default=6)
    watch_parser.add_argument("--depth-band", type=float, default=0.02)
    watch_parser.add_argument("--min-depth-ratio", type=float, default=1.5)
    watch_parser.add_argument("--min-best-level-ratio", type=float, default=0.5)
    watch_parser.add_argument("--watch-seconds", type=int, default=900)
    watch_parser.add_argument("--poll-seconds", type=float, default=15.0)
    watch_parser.add_argument("--confirm-polls", type=int, default=2)
    watch_parser.add_argument("--stats-dir", default=str(repo_root() / ".generated"))
    watch_parser.add_argument("--stats-prefix", default="paired-watch")
    watch_parser.add_argument("--live-ok", action="store_true", help="When an eligible edge appears, execute the paired live run.")

    status_parser = subparsers.add_parser(
        "status",
        help="Show the remote clean-room directories and latest generated files.",
    )
    status_parser.add_argument("--no-sync", action="store_true", help="Skip the pre-sync step.")

    return parser


def sync_items() -> list[SyncItem]:
    root = repo_root()
    return [
        SyncItem(root / "scripts" / "auto_redeem.py", "scripts/auto_redeem.py"),
        SyncItem(root / "scripts" / "polymarket_relayer.py", "scripts/polymarket_relayer.py"),
        SyncItem(root / "scripts" / "prepare_btc5_comparison.py", "scripts/prepare_btc5_comparison.py"),
        SyncItem(root / "scripts" / "resolve_next_btc5.py", "scripts/resolve_next_btc5.py"),
        SyncItem(root / "scripts" / "run_replica_btc5_canary.sh", "run_replica_btc5_canary.sh"),
        SyncItem(root / "scripts" / "run_replica_btc5_paired.py", "scripts/run_replica_btc5_paired.py"),
        SyncItem(root / "scripts" / "run_replica_btc5_accumulator.py", "scripts/run_replica_btc5_accumulator.py"),
    ]


def quoted(path: str) -> str:
    return shlex.quote(path)


def normalize_env_value(value: str) -> str:
    cleaned = str(value).strip()
    while len(cleaned) >= 2 and cleaned[0] == cleaned[-1] and cleaned[0] in {"'", '"'}:
        cleaned = cleaned[1:-1].strip()
    return cleaned


def validate_live_trading_env(name: str, value: str, pattern: str, hint: str) -> str:
    cleaned = normalize_env_value(value)
    if not cleaned:
        return cleaned
    if not re.fullmatch(pattern, cleaned):
        raise SystemExit(
            f"{name} looks malformed after trimming quotes/whitespace. "
            f"Expected {hint}, got {cleaned!r}."
        )
    return cleaned


def ssh_base_args(args: argparse.Namespace) -> list[str]:
    if not args.identity:
        raise SystemExit(
            "Missing SSH identity. Pass --identity or set REPLICA_AWS_KEY, "
            "or place aws-trading-key.pem in your Downloads folder."
        )
    identity_path = Path(args.identity).expanduser()
    if not identity_path.exists():
        raise SystemExit(f"SSH identity not found: {identity_path}")
    return [
        "-i",
        str(identity_path),
        "-p",
        str(args.port),
        "-o",
        "BatchMode=yes",
    ]


def run_local(command: list[str], *, capture_output: bool = False) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        check=True,
        text=True,
        capture_output=capture_output,
    )


def run_ssh(args: argparse.Namespace, remote_command: str, *, capture_output: bool = False) -> subprocess.CompletedProcess[str]:
    command = ["ssh", *ssh_base_args(args), args.host, remote_command]
    return run_local(command, capture_output=capture_output)


def run_scp(args: argparse.Namespace, local_path: Path, remote_path: str, *, quiet: bool = False) -> None:
    ssh_args = ssh_base_args(args)
    command = ["scp"]
    idx = 0
    while idx < len(ssh_args):
        token = ssh_args[idx]
        if token == "-p":
            command.extend(["-P", ssh_args[idx + 1]])
            idx += 2
            continue
        command.append(token)
        idx += 1
    if quiet:
        command.append("-q")
    command.extend([str(local_path), f"{args.host}:{remote_path}"])
    run_local(command)


def ensure_remote_root(args: argparse.Namespace) -> None:
    root = quoted(args.remote_root)
    remote_command = (
        f"mkdir -p {root} {root}/scripts {root}/generated {root}/state {root}/bin"
    )
    run_ssh(args, remote_command)


def sync_remote(args: argparse.Namespace, *, quiet: bool = False) -> None:
    ensure_remote_root(args)
    for item in sync_items():
        if not item.local_path.exists():
            raise SystemExit(f"Missing local file to sync: {item.local_path}")
        remote_path = f"{args.remote_root}/{item.remote_path}"
        print(f"Syncing {item.local_path.name} -> {remote_path}")
        run_scp(args, item.local_path, remote_path, quiet=quiet)
    run_ssh(
        args,
        (
            f"chmod +x {quoted(args.remote_root)}/run_replica_btc5_canary.sh"
        ),
    )


def remote_python_expr(root: str) -> str:
    root_q = quoted(root)
    return (
        f'if [ -x {root_q}/.venv/bin/python3 ]; then PY={root_q}/.venv/bin/python3; '
        f'else PY=python3; fi'
    )


def remote_trading_env(
    *,
    require_private_key: bool,
    allow_test_key: bool = False,
) -> str:
    private_key = validate_live_trading_env(
        "POLYMARKET_PRIVATE_KEY",
        os.environ.get("POLYMARKET_PRIVATE_KEY", ""),
        r"0x[0-9a-fA-F]{64}",
        "a 32-byte hex private key like 0xabc... with 64 hex digits",
    )
    signature_type = validate_live_trading_env(
        "POLYMARKET_SIGNATURE_TYPE",
        os.environ.get("POLYMARKET_SIGNATURE_TYPE", ""),
        r"[012]",
        "0, 1, or 2",
    )
    funder = validate_live_trading_env(
        "POLYMARKET_FUNDER",
        os.environ.get("POLYMARKET_FUNDER", ""),
        r"0x[0-9a-fA-F]{40}",
        "an Ethereum address like 0xabc... with 40 hex digits",
    )

    if require_private_key and not private_key and not allow_test_key:
        raise SystemExit(
            "Missing POLYMARKET_PRIVATE_KEY in your local environment. "
            "Set it in this PowerShell session before running the live canary."
        )

    exports: list[str] = []
    if private_key:
        exports.append(f"export POLYMARKET_PRIVATE_KEY={quoted(private_key)};")
    elif allow_test_key:
        exports.append(f"export POLYMARKET_PRIVATE_KEY={quoted(DRY_RUN_TEST_KEY)};")

    if signature_type:
        exports.append(f"export POLYMARKET_SIGNATURE_TYPE={quoted(signature_type)};")
    if funder:
        exports.append(f"export POLYMARKET_FUNDER={quoted(funder)};")

    return " ".join(exports)


def extract_json_payload(text: str) -> dict:
    start = text.find("{")
    end = text.rfind("}")
    if start == -1 or end == -1 or end < start:
        raise ValueError("No JSON object found in command output.")
    return json.loads(text[start : end + 1])


def watch_stats_paths(args: argparse.Namespace) -> tuple[Path, Path]:
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    stats_dir = Path(args.stats_dir).expanduser()
    stats_dir.mkdir(parents=True, exist_ok=True)
    prefix = f"{args.stats_prefix}-{stamp}"
    return stats_dir / f"{prefix}.json", stats_dir / f"{prefix}.csv"


def write_watch_stats(json_path: Path, csv_path: Path, rows: list[dict], metadata: dict) -> None:
    payload = {
        "metadata": metadata,
        "rows": rows,
    }
    json_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    if not rows:
        csv_path.write_text(
            "attempt,timestamp_utc,slug,gross_cost,eligible,reason,seconds_left,up_price,down_price,up_size,down_size,up_depth_ratio,down_depth_ratio,eligible_streak\n",
            encoding="utf-8",
        )
        return
    fieldnames = [
        "attempt",
        "timestamp_utc",
        "slug",
        "gross_cost",
        "eligible",
        "reason",
        "seconds_left",
        "up_price",
        "down_price",
        "up_size",
        "down_size",
        "up_depth_ratio",
        "down_depth_ratio",
        "eligible_streak",
    ]
    with csv_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def prepare_btc5(args: argparse.Namespace) -> None:
    if not args.no_sync:
        sync_remote(args)
    root_q = quoted(args.remote_root)
    output_dir = f"{args.remote_root}/{args.output_dir}".replace("\\", "/")
    output_dir_q = quoted(output_dir)
    current_event_q = quoted(f"{output_dir}/current-btc5-event.json")
    prepare_parts = [
        '"$PY"',
        quoted(f"{args.remote_root}/scripts/prepare_btc5_comparison.py"),
        "--output-dir",
        output_dir_q,
        "--symbol-prefix",
        quoted(args.symbol_prefix),
        "--max-buy-order-size",
        str(args.max_buy_order_size),
        "--seed-shares",
        str(args.seed_shares),
        "--min-price",
        str(args.min_price),
        "--max-price",
        str(args.max_price),
        "--stop-before-end-ms",
        str(args.stop_before_end_ms),
    ]
    if args.cancel_orders_on_start:
        prepare_parts.append("--cancel-orders-on-start")

    if args.slug:
        prepare_parts.extend(["--slug", quoted(args.slug)])
        resolve_block = ""
    else:
        resolve_block = (
            f'"$PY" {quoted(f"{args.remote_root}/scripts/resolve_next_btc5.py")} '
            f'--which {quoted(args.which)} > {current_event_q}; '
            f'SLUG=$("$PY" -c "import json,sys;print(json.load(open(sys.argv[1],'
            f' encoding=\'utf-8\'))[\'slug\'])" {current_event_q}); '
        )
        prepare_parts.extend(["--slug", '"$SLUG"'])

    remote_command = (
        f"set -euo pipefail; mkdir -p {root_q} {output_dir_q}; "
        f"{remote_python_expr(args.remote_root)}; "
        f"{resolve_block}"
        + " ".join(prepare_parts)
    )
    run_ssh(args, remote_command)


def autoredeem_dry(args: argparse.Namespace) -> None:
    if not args.no_sync:
        sync_remote(args)
    root_q = quoted(args.remote_root)
    cmd_parts = [
        '"$PY"',
        quoted(f"{args.remote_root}/scripts/auto_redeem.py"),
        "--wallet-type",
        quoted(args.wallet_type),
        "--wallet-address",
        quoted(args.wallet_address),
        "--min-value",
        str(args.min_value),
        "--json",
    ]
    if args.limit:
        cmd_parts.extend(["--limit", str(args.limit)])
    if args.include_negative_risk:
        cmd_parts.append("--include-negative-risk")
    if args.allow_wallet_mismatch:
        cmd_parts.append("--allow-wallet-mismatch")
        remote_key_block = remote_trading_env(
            require_private_key=False,
            allow_test_key=True,
        )
    else:
        remote_key_block = remote_trading_env(
            require_private_key=True,
            allow_test_key=False,
        )

    remote_command = (
        f"set -euo pipefail; mkdir -p {root_q}; "
        f"{remote_python_expr(args.remote_root)}; "
        f"{remote_key_block}"
        + " ".join(cmd_parts)
    )
    run_ssh(args, remote_command)


def canary(args: argparse.Namespace) -> None:
    if not args.live_ok:
        raise SystemExit(
            "Refusing to run the live canary without --live-ok. "
            "This subcommand can place real-money orders."
        )
    if not args.no_sync:
        sync_remote(args)
    remote_env = remote_trading_env(
        require_private_key=True,
        allow_test_key=False,
    )
    remote_command = (
        f"set -euo pipefail; {remote_env} ROOT={quoted(args.remote_root)} "
        f"{quoted(args.remote_root)}/run_replica_btc5_canary.sh {quoted(args.side)}"
    )
    run_ssh(args, remote_command)


def paired(args: argparse.Namespace) -> None:
    if not args.no_sync:
        sync_remote(args)
    remote_env = ""
    if args.live_ok:
        remote_env = remote_trading_env(
            require_private_key=True,
            allow_test_key=False,
        )
    remote_command = (
        f"set -euo pipefail; {remote_env}{remote_python_expr(args.remote_root)}; "
        f'"$PY" {quoted(f"{args.remote_root}/scripts/run_replica_btc5_paired.py")} '
        f"--root {quoted(args.remote_root)} "
        f"--which {quoted(args.which)} "
        f"--pair-shares {args.pair_shares} "
        f"--edge-threshold {args.edge_threshold} "
        f"--lookahead-windows {args.lookahead_windows} "
        f"--depth-band {args.depth_band} "
        f"--min-depth-ratio {args.min_depth_ratio} "
        f"--min-best-level-ratio {args.min_best_level_ratio} "
        + ("--live-ok" if args.live_ok else "")
    )
    run_ssh(args, remote_command)


def accumulate(args: argparse.Namespace) -> None:
    if not args.no_sync:
        sync_remote(args)
    remote_env = ""
    if args.live_ok:
        remote_env = remote_trading_env(
            require_private_key=True,
            allow_test_key=False,
        )
    wallet_clause = ""
    if args.wallet_address:
        wallet_clause = f"--wallet-address {quoted(args.wallet_address)} "
    remote_command = (
        f"set -euo pipefail; {remote_env}{remote_python_expr(args.remote_root)}; "
        f'"$PY" {quoted(f"{args.remote_root}/scripts/run_replica_btc5_accumulator.py")} '
        f"--root {quoted(args.remote_root)} "
        f"--which {quoted(args.which)} "
        f"--watch-seconds {args.watch_seconds} "
        f"--residual-watch-seconds {args.residual_watch_seconds} "
        f"--poll-seconds {args.poll_seconds} "
        f"--rest-seconds {args.rest_seconds} "
        f"--clip-shares {args.clip_shares} "
        f"--entry-threshold {args.entry_threshold} "
        f"--rebalance-threshold {args.rebalance_threshold} "
        f"--max-residual-shares {args.max_residual_shares} "
        f"--late-session-residual-seconds {args.late_session_residual_seconds} "
        f"--late-session-residual-threshold {args.late_session_residual_threshold} "
        f"--session-residual-stop-shares {args.session_residual_stop_shares} "
        f"--session-residual-stop-ratio {args.session_residual_stop_ratio} "
        f"--inventory-skew-step {args.inventory_skew_step} "
        f"--inventory-skew-trigger-shares {args.inventory_skew_trigger_shares} "
        f"--early-session-seconds {args.early_session_seconds} "
        f"--early-session-flat-residual-threshold {args.early_session_flat_residual_threshold} "
        f"--early-session-pair-budget {args.early_session_pair_budget} "
        f"--early-session-max-actions {args.early_session_max_actions} "
        f"--lookahead-windows {args.lookahead_windows} "
        f"--bid-improve {args.bid_improve} "
        f"--maker-layers {args.maker_layers} "
        f"--maker-price-step {args.maker_price_step} "
        f"--maker-pair-threshold {args.maker_pair_threshold} "
        f"--maker-layer-size-ratio {args.maker_layer_size_ratio} "
        f"--max-actions-per-cycle {args.max_actions_per_cycle} "
        f"--depth-band {args.depth_band} "
        f"--min-depth-ratio {args.min_depth_ratio} "
        f"--min-best-level-ratio {args.min_best_level_ratio} "
        f"--min-order-notional {args.min_order_notional} "
        f"--max-clip-shares {args.max_clip_shares} "
        f"{wallet_clause}"
        + ("--live-ok" if args.live_ok else "")
    )
    run_ssh(args, remote_command)


def paired_remote_command(
    args: argparse.Namespace,
    *,
    live_ok: bool,
) -> str:
    remote_env = ""
    if live_ok:
        remote_env = remote_trading_env(
            require_private_key=True,
            allow_test_key=False,
        )
    return (
        f"set -euo pipefail; {remote_env}{remote_python_expr(args.remote_root)}; "
        f'"$PY" {quoted(f"{args.remote_root}/scripts/run_replica_btc5_paired.py")} '
        f"--root {quoted(args.remote_root)} "
        "--which current "
        f"--pair-shares {args.pair_shares} "
        f"--edge-threshold {args.edge_threshold} "
        f"--lookahead-windows {args.lookahead_windows} "
        f"--depth-band {args.depth_band} "
        f"--min-depth-ratio {args.min_depth_ratio} "
        f"--min-best-level-ratio {args.min_best_level_ratio} "
        + ("--live-ok" if live_ok else "")
    )


def watch_paired(args: argparse.Namespace) -> None:
    if not args.no_sync:
        sync_remote(args)
    deadline = time.time() + args.watch_seconds
    attempt = 0
    json_path, csv_path = watch_stats_paths(args)
    stats_rows: list[dict] = []
    eligible_streak = 0
    last_eligible_slug = ""
    metadata = {
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "edge_threshold": args.edge_threshold,
        "pair_shares": args.pair_shares,
        "depth_band": args.depth_band,
        "min_depth_ratio": args.min_depth_ratio,
        "min_best_level_ratio": args.min_best_level_ratio,
        "confirm_polls": args.confirm_polls,
        "watch_seconds": args.watch_seconds,
        "poll_seconds": args.poll_seconds,
        "live_ok": args.live_ok,
        "remote_root": args.remote_root,
    }
    while time.time() < deadline:
        attempt += 1
        row = {
            "attempt": attempt,
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            "slug": "",
            "gross_cost": None,
            "eligible": False,
            "reason": "",
            "seconds_left": None,
            "up_price": None,
            "down_price": None,
            "up_size": None,
            "down_size": None,
            "up_depth_ratio": None,
            "down_depth_ratio": None,
            "eligible_streak": 0,
        }
        try:
            result = run_ssh(
                args,
                paired_remote_command(args, live_ok=False),
                capture_output=True,
            )
            payload = extract_json_payload(result.stdout)
        except subprocess.CalledProcessError as exc:
            stderr = exc.stderr.strip() if exc.stderr else ""
            stdout = exc.stdout.strip() if exc.stdout else ""
            detail = stderr or stdout or str(exc)
            print(f"[attempt {attempt}] paired dry-run failed: {detail}")
            row["reason"] = detail
            stats_rows.append(row)
            write_watch_stats(json_path, csv_path, stats_rows, metadata)
            time.sleep(args.poll_seconds)
            continue
        except ValueError as exc:
            print(f"[attempt {attempt}] could not parse paired dry-run output: {exc}")
            row["reason"] = f"parse_error: {exc}"
            stats_rows.append(row)
            write_watch_stats(json_path, csv_path, stats_rows, metadata)
            time.sleep(args.poll_seconds)
            continue

        outcome = payload.get("outcomeSummary", {})
        slug = outcome.get("slug", payload.get("event", {}).get("slug", "unknown"))
        gross_cost = payload.get("grossCost")
        reason = outcome.get("reason", "unknown")
        row["slug"] = slug
        row["gross_cost"] = gross_cost
        row["eligible"] = bool(outcome.get("eligible"))
        row["reason"] = reason
        row["seconds_left"] = payload.get("secondsLeft")
        row["up_price"] = payload.get("asks", {}).get("up", {}).get("price")
        row["down_price"] = payload.get("asks", {}).get("down", {}).get("price")
        row["up_size"] = payload.get("asks", {}).get("up", {}).get("size")
        row["down_size"] = payload.get("asks", {}).get("down", {}).get("size")
        row["up_depth_ratio"] = payload.get("depth", {}).get("up", {}).get("ratio")
        row["down_depth_ratio"] = payload.get("depth", {}).get("down", {}).get("ratio")
        if outcome.get("eligible"):
            if slug == last_eligible_slug:
                eligible_streak += 1
            else:
                eligible_streak = 1
                last_eligible_slug = slug
        else:
            eligible_streak = 0
            last_eligible_slug = ""
        row["eligible_streak"] = eligible_streak
        stats_rows.append(row)
        write_watch_stats(json_path, csv_path, stats_rows, metadata)
        print(
            f"[attempt {attempt}] slug={slug} gross_cost={gross_cost} "
            f"eligible={outcome.get('eligible')} reason={reason} "
            f"streak={eligible_streak}"
        )

        if outcome.get("eligible") and eligible_streak >= args.confirm_polls:
            print(
                f"[attempt {attempt}] qualifying paired edge found on {slug} "
                f"after {eligible_streak} confirming polls"
            )
            if args.live_ok:
                live_result = run_ssh(
                    args,
                    paired_remote_command(args, live_ok=True),
                    capture_output=True,
                )
                print(live_result.stdout.strip())
            metadata["finished_utc"] = datetime.now(timezone.utc).isoformat()
            metadata["result"] = "edge_found"
            metadata["trigger_slug"] = slug
            write_watch_stats(json_path, csv_path, stats_rows, metadata)
            return

        time.sleep(args.poll_seconds)

    metadata["finished_utc"] = datetime.now(timezone.utc).isoformat()
    metadata["result"] = "no_edge_found"
    write_watch_stats(json_path, csv_path, stats_rows, metadata)
    print(f"Saved watch stats to {json_path} and {csv_path}")
    raise SystemExit(
        f"No qualifying paired edge appeared within {args.watch_seconds} seconds."
    )


def status(args: argparse.Namespace) -> None:
    remote_command = (
        f"set -euo pipefail; ROOT={quoted(args.remote_root)}; "
        'echo "Root:" "$ROOT"; '
        'echo "--- scripts ---"; ls -l "$ROOT/scripts" 2>/dev/null || true; '
        'echo "--- generated ---"; ls -lt "$ROOT/generated" 2>/dev/null | head -n 20 || true; '
        'echo "--- latest logs ---"; find "$ROOT/generated" -maxdepth 1 -type f '
        '-name "*.log" -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" 2>/dev/null | sort -r | head -n 10 || true'
    )
    run_ssh(args, remote_command)


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "sync":
        sync_remote(args, quiet=args.quiet)
    elif args.command == "prepare-btc5":
        prepare_btc5(args)
    elif args.command == "autoredeem-dry":
        autoredeem_dry(args)
    elif args.command == "canary":
        canary(args)
    elif args.command == "paired":
        paired(args)
    elif args.command == "accumulate":
        accumulate(args)
    elif args.command == "watch-paired":
        watch_paired(args)
    elif args.command == "status":
        status(args)
    else:
        parser.error(f"Unhandled command: {args.command}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
