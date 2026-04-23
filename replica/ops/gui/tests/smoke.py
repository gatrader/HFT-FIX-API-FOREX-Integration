#!/usr/bin/env python3
"""End-to-end smoke test for the replica operator GUI.

Stands up the real stdlib server on a throw-away port, against a
tempdir of fake whitelisted scripts, and exercises every route the
frontend depends on. Exits 0 on success, non-zero on the first
unexpected response.

Run directly:

    python3 replica/ops/gui/tests/smoke.py

Idempotent: uses a random high port, tears down the server, and
cleans up the tempdir on its way out.
"""
from __future__ import annotations

import json
import os
import shutil
import socket
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SERVER = ROOT / "server.py"


def free_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("127.0.0.1", 0))
        return s.getsockname()[1]


def mk_fake_scripts(dir_: Path) -> None:
    dir_.mkdir(parents=True, exist_ok=True)
    # `paper` exits quickly and prints every marker — exercises the
    # status-card path and the log filter path in one run.
    (dir_ / "replica-paper.sh").write_text(
        # Includes a user-WS "connected" and "disconnected" marker so
        # the status-card WS logic is exercised end-to-end. The
        # disconnect phrase matches the exact warn! body from
        # replica/src/user_ws.rs (reconnect path on session close).
        "#!/usr/bin/env bash\n"
        "echo 'paper: starting'\n"
        "echo 'startup cancel_all ok'\n"
        "echo 'user channel connected + subscribed'\n"
        "echo 'submit complete id=1'\n"
        "echo 'fill applied'\n"
        "echo 'user-channel session closed before HEALTHY_SESSION_MIN'\n"
        "echo 'duration reached'\n"
    )
    # `live5m` sleeps long enough that we can observe `running` state
    # and exercise the SIGTERM stop path. Trap INT/TERM so SIGKILL is
    # reached only if the test asks for it.
    (dir_ / "replica-live-5m.sh").write_text(
        "#!/usr/bin/env bash\n"
        "echo 'live: starting'\n"
        "trap 'echo caught; exit 0' INT TERM\n"
        "for i in 1 2 3 4 5 6 7 8 9 10; do sleep 1; done\n"
    )
    for name in ("replica-paper.sh", "replica-live-5m.sh"):
        (dir_ / name).chmod(0o755)


def http_get(url: str) -> tuple[int, bytes]:
    try:
        with urllib.request.urlopen(url, timeout=5) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def http_post(url: str) -> tuple[int, bytes]:
    req = urllib.request.Request(url, data=b"", method="POST")
    try:
        with urllib.request.urlopen(req, timeout=5) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def expect(cond: bool, msg: str) -> None:
    if not cond:
        print(f"FAIL: {msg}", file=sys.stderr)
        raise SystemExit(1)
    print(f"ok   {msg}")


def wait_for(url: str, deadline_s: float = 5.0) -> None:
    end = time.monotonic() + deadline_s
    while time.monotonic() < end:
        try:
            code, _ = http_get(url)
            if code == 200:
                return
        except Exception:
            pass
        time.sleep(0.05)
    raise SystemExit(f"server never came up at {url}")


def main() -> int:
    tmp = Path(tempfile.mkdtemp(prefix="replica-gui-smoke-"))
    bin_dir = tmp / "bin"
    log_dir = tmp / "logs"
    mk_fake_scripts(bin_dir)
    log_dir.mkdir(parents=True, exist_ok=True)

    port = free_port()
    env = {
        **os.environ,
        "GUI_BIND":        f"127.0.0.1:{port}",
        "GUI_SCRIPT_DIR":  str(bin_dir),
        "GUI_LOG_DIR":     str(log_dir),
        "GUI_REPLICA_DIR": str(ROOT.parents[1]),
        "GUI_HOST_LABEL":  "smoke",
    }
    base = f"http://127.0.0.1:{port}"
    proc = subprocess.Popen(
        [sys.executable, str(SERVER)],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    try:
        wait_for(f"{base}/healthz")

        # ── static ─────────────────────────────────────────────────
        code, body = http_get(f"{base}/")
        expect(code == 200, "GET / → 200")
        expect(b"Arbigab" in body, "index references Arbigab")
        expect(b"logo_gabagool.png" in body, "index references logo")

        code, body = http_get(f"{base}/static/style.css")
        expect(code == 200, "GET /static/style.css → 200")
        expect(b"--accent:" in body, "style.css has arbigab palette")

        code, body = http_get(f"{base}/static/logo_gabagool.png")
        expect(code == 200, "GET logo → 200")
        expect(body[:8] == b"\x89PNG\r\n\x1a\n", "logo is a PNG")

        code, _ = http_get(f"{base}/static/../server.py")
        expect(code == 404, "path traversal on /static → 404")

        # ── slug validation ────────────────────────────────────────
        code, body = http_post(f"{base}/api/run/bogus")
        expect(code == 400, "unknown run slug → 400")
        expect(b"unknown script slug" in body, "unknown slug message")

        code, _ = http_post(f"{base}/api/stop/")
        expect(code == 400, "empty stop id → 400")

        # ── happy path: paper run ──────────────────────────────────
        code, body = http_post(f"{base}/api/run/paper")
        expect(code == 200, "POST /api/run/paper → 200")
        paper_job = json.loads(body)["job"]

        # Wait for the fake script to exit before asserting on logs.
        for _ in range(50):
            code, body = http_get(f"{base}/api/status")
            s = json.loads(body)
            if not s["running"]:
                break
            time.sleep(0.1)
        expect(not s["running"], "status.running flips false after paper exits")

        code, body = http_get(f"{base}/api/logs?limit=50")
        lines = json.loads(body)["lines"]
        joined = "\n".join(lines)
        for marker in ("startup cancel_all ok", "submit complete",
                       "fill applied", "duration reached"):
            expect(marker in joined, f"log tail contains '{marker}'")

        # Filtered tail — only lines containing "fill applied".
        code, body = http_get(f"{base}/api/logs?filter=fill+applied")
        lines = json.loads(body)["lines"]
        expect(all("fill applied" in ln for ln in lines) and lines,
               "filter=fill applied keeps only matching lines")

        # Status markers — the fake paper log has a connect line
        # followed by a real-replica disconnect phrase, so the last
        # observed ws_connected state must be False.
        code, body = http_get(f"{base}/api/status")
        s = json.loads(body)
        mk = s.get("markers") or {}
        expect(mk.get("ws_connected") is False,
               f"ws_connected reflects last 'user-channel session closed' (got {mk.get('ws_connected')!r})")
        expect(mk.get("submit") and "submit complete" in mk["submit"],
               "markers.submit populated from log")
        expect(mk.get("fill") and "fill applied" in mk["fill"],
               "markers.fill populated from log")
        expect(mk.get("cancel_all") and "startup cancel_all ok" in mk["cancel_all"],
               "markers.cancel_all populated from log")
        expect(mk.get("duration") and "duration reached" in mk["duration"],
               "markers.duration populated from log")

        # Stop on an already-exited job returns a clear error.
        code, body = http_post(f"{base}/api/stop/{paper_job['id']}")
        expect(code == 400, "stop on exited job → 400")
        expect(b"already exited" in body, "stop-exited message")

        # ── live stop path ─────────────────────────────────────────
        code, body = http_post(f"{base}/api/run/live5m")
        expect(code == 200, "POST /api/run/live5m → 200")
        live_job = json.loads(body)["job"]

        # Give the shell a moment to install its signal trap.
        time.sleep(0.3)

        # Confirm the status endpoint now reports running.
        code, body = http_get(f"{base}/api/status")
        s = json.loads(body)
        expect(s["running"] is True, "status.running True during live job")
        expect(s["current_job"]["id"] == live_job["id"],
               "current_job matches the launched live job")

        # Stop it. The trap catches SIGTERM and exits 0 promptly, so
        # we should see `signal: SIGTERM` and `exit_code: 0`.
        code, body = http_post(f"{base}/api/stop/{live_job['id']}")
        expect(code == 200, "POST /api/stop → 200")
        report = json.loads(body)
        expect(report["ok"] is True, "stop report ok=true")
        expect(report.get("signal") == "SIGTERM",
               f"stop sent SIGTERM (got {report.get('signal')})")

        # ── recent-jobs list ───────────────────────────────────────
        code, body = http_get(f"{base}/api/status")
        s = json.loads(body)
        slugs = [j["slug"] for j in s["recent_jobs"]]
        expect("paper" in slugs and "live5m" in slugs,
               "recent_jobs lists both launched jobs")
        expect(not s["running"], "running flips false after stop")

        print("\nall smoke checks passed")
        return 0
    finally:
        try:
            proc.terminate()
            proc.wait(timeout=3)
        except subprocess.TimeoutExpired:
            proc.kill()
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
