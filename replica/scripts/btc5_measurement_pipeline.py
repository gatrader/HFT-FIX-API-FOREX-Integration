from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def generated_dir_from_args(value: str) -> Path:
    return Path(value)


def default_generated_dir() -> Path:
    return repo_root() / ".generated"


def recorder_pid_path(generated_dir: Path) -> Path:
    return generated_dir / "overnight-shadow-recorder.pid.json"


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Helper pipeline for the overnight BTC5 measurement loop: start/monitor the "
            "shadow recorder and refresh the forensics/dashboard reports."
        )
    )
    parser.add_argument("--generated-dir", default=str(default_generated_dir()))
    subparsers = parser.add_subparsers(dest="command", required=True)

    start = subparsers.add_parser("start-recorder")
    start.add_argument("--duration-minutes", type=float, default=60.0)
    start.add_argument("--poll-seconds", type=float, default=1.0)
    start.add_argument("--prefix", default="overnight-shadow-recorder")

    subparsers.add_parser("status")

    refresh = subparsers.add_parser("refresh")
    refresh.add_argument("--forensics-hours", type=float, default=3.0)

    return parser


def is_process_running(pid: int) -> bool:
    if pid <= 0:
        return False
    try:
        if os.name == "nt":
            result = subprocess.run(
                ["powershell", "-NoProfile", "-Command", f"Get-Process -Id {pid}"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=False,
            )
            return result.returncode == 0
        os.kill(pid, 0)
        return True
    except Exception:
        return False


def recorder_status(generated_dir: Path) -> dict[str, Any]:
    pid_path = recorder_pid_path(generated_dir)
    if not pid_path.exists():
        return {"status": "missing"}
    payload = load_json(pid_path)
    pid = int(payload.get("pid") or 0)
    return {
        "status": "running" if is_process_running(pid) else "stopped",
        "pid": pid,
        "startedAtUtc": payload.get("startedAtUtc"),
        "stdout": payload.get("stdout"),
        "stderr": payload.get("stderr"),
        "command": payload.get("command"),
    }


def start_recorder(args: argparse.Namespace, generated_dir: Path) -> int:
    status = recorder_status(generated_dir)
    if status["status"] == "running":
        print(json.dumps(status, indent=2))
        return 0
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    stdout = generated_dir / f"overnight-shadow-recorder.{stamp}.stdout.log"
    stderr = generated_dir / f"overnight-shadow-recorder.{stamp}.stderr.log"
    script = repo_root() / "scripts" / "btc5_shadow_reference.py"
    command = [
        sys.executable,
        str(script),
        "record",
        "--duration-minutes",
        str(args.duration_minutes),
        "--poll-seconds",
        str(args.poll_seconds),
        "--output-dir",
        str(generated_dir),
    ]
    creationflags = 0
    if os.name == "nt":
        creationflags = subprocess.CREATE_NO_WINDOW | subprocess.DETACHED_PROCESS
    with stdout.open("w", encoding="utf-8") as out_handle, stderr.open(
        "w", encoding="utf-8"
    ) as err_handle:
        proc = subprocess.Popen(
            command,
            stdout=out_handle,
            stderr=err_handle,
            creationflags=creationflags,
        )
    time.sleep(2)
    payload = {
        "startedAtUtc": datetime.now(timezone.utc).isoformat(),
        "pid": proc.pid,
        "stdout": str(stdout),
        "stderr": str(stderr),
        "command": command,
    }
    write_json(recorder_pid_path(generated_dir), payload)
    print(json.dumps(payload, indent=2))
    return 0


def run_python(script: Path, args: list[str]) -> dict[str, Any]:
    result = subprocess.run(
        [sys.executable, str(script), *args],
        text=True,
        capture_output=True,
        check=True,
    )
    return json.loads(result.stdout)


def refresh_reports(args: argparse.Namespace, generated_dir: Path) -> int:
    scripts = repo_root() / "scripts"
    forensics = run_python(
        scripts / "btc5_shadow_reference.py",
        [
            "forensics",
            "--hours",
            str(args.forensics_hours),
            "--output-dir",
            str(generated_dir),
        ],
    )
    dashboard = run_python(
        scripts / "btc5_measurement_report.py",
        [
            "--generated-dir",
            str(generated_dir),
        ],
    )
    payload = {
        "forensics": forensics,
        "dashboard": dashboard,
        "recorder": recorder_status(generated_dir),
    }
    print(json.dumps(payload, indent=2))
    return 0


def main() -> int:
    args = build_parser().parse_args()
    generated_dir = generated_dir_from_args(args.generated_dir)
    generated_dir.mkdir(parents=True, exist_ok=True)
    if args.command == "start-recorder":
        return start_recorder(args, generated_dir)
    if args.command == "status":
        print(json.dumps(recorder_status(generated_dir), indent=2))
        return 0
    if args.command == "refresh":
        return refresh_reports(args, generated_dir)
    raise SystemExit(f"Unsupported command: {args.command}")


if __name__ == "__main__":
    raise SystemExit(main())
