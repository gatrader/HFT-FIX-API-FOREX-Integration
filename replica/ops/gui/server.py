#!/usr/bin/env python3
"""Operator GUI for the validated replica.

A zero-dependency (Python 3 stdlib) HTTP server that wraps the four
bash scripts already validated on the AWS operator host and exposes:

  * a one-glance status card (mode, host, branch/commit, last fill /
    submit / reject / cancel, user-WS connected)
  * action buttons that exec the same scripts the operator runs from
    the shell — the CLI path is untouched
  * a filtered log tailer over the active job's log file

Bind defaults to 127.0.0.1:8787 so the operator reaches it via SSH
tunnel; do not expose on 0.0.0.0 without an auth layer in front.

Env knobs (all optional):
  GUI_BIND           host:port          default 127.0.0.1:8787
  GUI_SCRIPT_DIR     path               default /home/ubuntu/bin
  GUI_LOG_DIR        path               default /home/ubuntu/logs
  GUI_REPLICA_DIR    path (git tree)    default /home/ubuntu/worktrees/review-head/replica
  GUI_HOST_LABEL     str                default = `hostname`
"""

from __future__ import annotations

import errno
import json
import os
import re
import signal
import socket
import subprocess
import sys
import threading
import time
import urllib.parse
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

# ── Config ────────────────────────────────────────────────────────────
BIND = os.environ.get("GUI_BIND", "127.0.0.1:8787")
SCRIPT_DIR = Path(os.environ.get("GUI_SCRIPT_DIR", "/home/ubuntu/bin"))
LOG_DIR = Path(os.environ.get("GUI_LOG_DIR", "/home/ubuntu/logs"))
REPLICA_DIR = Path(
    os.environ.get("GUI_REPLICA_DIR", "/home/ubuntu/worktrees/review-head/replica")
)
HOST_LABEL = os.environ.get("GUI_HOST_LABEL") or socket.gethostname()

STATIC_DIR = Path(__file__).resolve().parent / "static"

# Whitelist of runnable scripts. The GUI *only* launches these — no
# operator-supplied strings ever reach a shell. Keys are slugs the
# frontend sends; values are (script_name, mode_label).
SCRIPTS = {
    "paper":     ("replica-paper.sh",     "paper"),
    "live5m":    ("replica-live-5m.sh",   "live-5m"),
    "userws30s": ("replica-userws-30s.sh","user-ws-30s"),
    "cleanup":   ("replica-cleanup.sh",   "cleanup"),
}

# Log lines the GUI knows how to highlight. Matching is substring
# (case-sensitive), mirroring what the user already greps for.
KNOWN_FILTERS = [
    "startup cancel_all ok",
    "submit complete",
    "order_reject",
    "fill applied",
    "duration reached",
]

# Optional markers for the status card. None of these fail the build
# if absent — the card just shows "—".
USER_WS_CONNECTED_MARKERS = [
    "user channel connected + subscribed",
]
USER_WS_DISCONNECTED_MARKERS = [
    "user_ws disconnected",
    "user_ws task exited",
]

# ── Job registry ──────────────────────────────────────────────────────
#
# We track the N most recent jobs in memory so the log tailer can
# point at "current log" without the operator guessing a filename.
# Disk log files persist forever — this is a pointer only.

_jobs_lock = threading.Lock()
_jobs: list[dict] = []  # newest last
_MAX_JOBS = 32


def _register_job(slug: str, mode: str, log_path: Path, pid: int, pgid: int) -> dict:
    job = {
        "id": f"{slug}-{int(time.time())}-{pid}",
        "slug": slug,
        "mode": mode,
        "pid": pid,
        "pgid": pgid,
        "log_path": str(log_path),
        "started_at": datetime.utcnow().isoformat() + "Z",
        "ended_at": None,
        "exit_code": None,
        "stop_requested_at": None,
    }
    with _jobs_lock:
        _jobs.append(job)
        del _jobs[:-_MAX_JOBS]
    return job


def _finalize_job(job_id: str, rc: int | None) -> None:
    with _jobs_lock:
        for j in _jobs:
            if j["id"] == job_id:
                j["ended_at"] = datetime.utcnow().isoformat() + "Z"
                j["exit_code"] = rc
                return


def _mark_stop_requested(job_id: str) -> None:
    with _jobs_lock:
        for j in _jobs:
            if j["id"] == job_id:
                if j.get("stop_requested_at") is None:
                    j["stop_requested_at"] = datetime.utcnow().isoformat() + "Z"
                return


def _find_job(job_id: str) -> dict | None:
    with _jobs_lock:
        for j in _jobs:
            if j["id"] == job_id:
                return dict(j)
    return None


def _is_running(job: dict) -> bool:
    return job.get("ended_at") is None


def _current_job() -> dict | None:
    """Most recent job, running or finished. What the log viewer tails."""
    with _jobs_lock:
        return dict(_jobs[-1]) if _jobs else None


def _all_jobs() -> list[dict]:
    with _jobs_lock:
        return [dict(j) for j in _jobs[::-1]]


# ── Git + script helpers ──────────────────────────────────────────────

def _git_info(repo: Path) -> dict:
    out = {"branch": None, "commit": None, "dirty": None}
    if not (repo / ".git").exists() and not repo.joinpath("..", ".git").exists():
        # Not a git worktree at this level — bail quietly so the card
        # renders "—" instead of breaking the whole status call.
        return out
    try:
        out["branch"] = subprocess.check_output(
            ["git", "-C", str(repo), "rev-parse", "--abbrev-ref", "HEAD"],
            text=True, stderr=subprocess.DEVNULL, timeout=3,
        ).strip()
        out["commit"] = subprocess.check_output(
            ["git", "-C", str(repo), "rev-parse", "--short", "HEAD"],
            text=True, stderr=subprocess.DEVNULL, timeout=3,
        ).strip()
        dirty = subprocess.check_output(
            ["git", "-C", str(repo), "status", "--porcelain"],
            text=True, stderr=subprocess.DEVNULL, timeout=3,
        )
        out["dirty"] = bool(dirty.strip())
    except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return out


def _run_script(slug: str) -> dict:
    if slug not in SCRIPTS:
        raise ValueError(f"unknown script slug: {slug}")
    script_name, mode = SCRIPTS[slug]
    script_path = SCRIPT_DIR / script_name
    if not script_path.exists():
        raise FileNotFoundError(f"script not found: {script_path}")
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    stamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    log_path = LOG_DIR / f"{slug}-{stamp}.log"
    # Detached: the GUI must not block on a 5m live run. Stdout +
    # stderr both stream into the single log file.
    f = open(log_path, "ab", buffering=0)
    f.write(f"# gui: launching {script_path} at {stamp}\n".encode())
    proc = subprocess.Popen(
        [str(script_path)],
        stdout=f,
        stderr=subprocess.STDOUT,
        stdin=subprocess.DEVNULL,
        close_fds=True,
        start_new_session=True,  # survive GUI restart via setsid
    )
    # Closed in the child via subprocess; we keep a copy so the reaper
    # below can flush the tail marker. `start_new_session=True` made
    # the child its own process-group leader, so pid == pgid in the
    # common case — but we read it explicitly so /api/stop can killpg
    # without re-deriving.
    try:
        pgid = os.getpgid(proc.pid)
    except ProcessLookupError:
        pgid = proc.pid
    job = _register_job(slug, mode, log_path, proc.pid, pgid)
    threading.Thread(
        target=_reap, args=(proc, f, job["id"]), daemon=True
    ).start()
    return job


def _reap(proc: subprocess.Popen, fh, job_id: str) -> None:
    try:
        rc = proc.wait()
    finally:
        try:
            fh.write(f"\n# gui: exit={proc.returncode}\n".encode())
            fh.flush()
            fh.close()
        except Exception:
            pass
        _finalize_job(job_id, rc)


def _stop_job(job_id: str, escalate_after_s: float = 5.0) -> dict:
    """Signal a job's process group; SIGTERM first, SIGKILL on timeout.

    Returns a small report the HTTP handler surfaces so the operator
    sees what happened. Safe to call on an already-exited job (returns
    a clear error), safe to call concurrently from multiple tabs
    (duplicate SIGTERMs are harmless).
    """
    job = _find_job(job_id)
    if not job:
        return {"ok": False, "error": "unknown job_id"}
    if not _is_running(job):
        return {"ok": False, "error": "job already exited",
                "exit_code": job.get("exit_code")}
    pgid = int(job.get("pgid") or job["pid"])
    _mark_stop_requested(job_id)
    sent = None
    try:
        os.killpg(pgid, signal.SIGTERM)
        sent = "SIGTERM"
    except ProcessLookupError:
        # Group already gone; reaper will catch up.
        return {"ok": True, "signal": "none", "note": "process group already exited"}
    except PermissionError as e:
        return {"ok": False, "error": f"permission denied: {e}"}
    # Poll briefly for the reaper to flip ended_at, then escalate.
    deadline = time.monotonic() + escalate_after_s
    while time.monotonic() < deadline:
        cur = _find_job(job_id) or {}
        if not _is_running(cur):
            return {"ok": True, "signal": sent,
                    "exit_code": cur.get("exit_code")}
        time.sleep(0.1)
    try:
        os.killpg(pgid, signal.SIGKILL)
        sent = "SIGKILL"
    except ProcessLookupError:
        pass
    except OSError as e:
        if e.errno != errno.ESRCH:
            return {"ok": False, "error": f"kill failed: {e}", "signal": sent}
    # Wait a little longer for the reaper.
    deadline = time.monotonic() + 2.0
    while time.monotonic() < deadline:
        cur = _find_job(job_id) or {}
        if not _is_running(cur):
            return {"ok": True, "signal": sent,
                    "exit_code": cur.get("exit_code")}
        time.sleep(0.1)
    return {"ok": True, "signal": sent, "note": "sent but exit not yet observed"}


# ── Log scanning ──────────────────────────────────────────────────────

def _tail_bytes(path: Path, max_bytes: int = 256 * 1024) -> str:
    """Read up to the last `max_bytes` of a file as utf-8 (lossy)."""
    try:
        size = path.stat().st_size
    except FileNotFoundError:
        return ""
    with path.open("rb") as f:
        if size > max_bytes:
            f.seek(size - max_bytes)
        data = f.read()
    return data.decode("utf-8", errors="replace")


_TS_RE = re.compile(r"(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z?)")


def _scan_for_markers(text: str) -> dict:
    """Extract last-seen timestamps for the status-card markers.

    Returns a dict with keys submit/reject/fill/cancel_all/ws_state.
    Values are raw log lines (or None) so the operator sees exactly
    what was logged, not our interpretation.
    """
    last = {
        "submit": None,
        "reject": None,
        "fill": None,
        "cancel_all": None,
        "duration": None,
        "ws_state": None,
    }
    ws_connected = None
    for line in text.splitlines():
        if "submit complete" in line:
            last["submit"] = line
        elif "order_reject" in line:
            last["reject"] = line
        elif "fill applied" in line:
            last["fill"] = line
        elif "startup cancel_all ok" in line or "cancel_all on shutdown ok" in line:
            last["cancel_all"] = line
        elif "duration reached" in line:
            last["duration"] = line
        for m in USER_WS_CONNECTED_MARKERS:
            if m in line:
                ws_connected = True
                last["ws_state"] = line
        for m in USER_WS_DISCONNECTED_MARKERS:
            if m in line:
                ws_connected = False
                last["ws_state"] = line
    last["ws_connected"] = ws_connected
    return last


def _filtered_tail(path: Path, want: list[str], max_lines: int) -> list[str]:
    """Tail the log, optionally keeping only lines matching `want`."""
    text = _tail_bytes(path)
    lines = text.splitlines()
    if want:
        keep = []
        for line in lines:
            if any(w in line for w in want):
                keep.append(line)
        lines = keep
    return lines[-max_lines:]


# ── HTTP layer ────────────────────────────────────────────────────────

def _json(h: BaseHTTPRequestHandler, code: int, body: dict) -> None:
    data = json.dumps(body, default=str).encode()
    h.send_response(code)
    h.send_header("Content-Type", "application/json")
    h.send_header("Content-Length", str(len(data)))
    h.send_header("Cache-Control", "no-store")
    h.end_headers()
    h.wfile.write(data)


def _static(h: BaseHTTPRequestHandler, rel: str) -> None:
    # Strict path containment — rel is whatever came after /static/.
    safe = (STATIC_DIR / rel).resolve()
    if not str(safe).startswith(str(STATIC_DIR.resolve())) or not safe.is_file():
        h.send_error(404)
        return
    ext = safe.suffix.lower()
    ctype = {
        ".html": "text/html; charset=utf-8",
        ".js":   "application/javascript; charset=utf-8",
        ".css":  "text/css; charset=utf-8",
        ".svg":  "image/svg+xml",
        ".png":  "image/png",
        ".ico":  "image/x-icon",
    }.get(ext, "application/octet-stream")
    body = safe.read_bytes()
    h.send_response(200)
    h.send_header("Content-Type", ctype)
    h.send_header("Content-Length", str(len(body)))
    h.send_header("Cache-Control", "no-store")
    h.end_headers()
    h.wfile.write(body)


class Handler(BaseHTTPRequestHandler):
    # Quieter logs — our own stdout prints on startup, and per-request
    # noise just drowns the useful lines during a live run.
    def log_message(self, fmt, *args):
        return

    # ── GET ──────────────────────────────────────────────────────
    def do_GET(self):  # noqa: N802
        url = urllib.parse.urlparse(self.path)
        path = url.path
        qs = urllib.parse.parse_qs(url.query)

        if path == "/" or path == "/index.html":
            return _static(self, "index.html")
        if path.startswith("/static/"):
            return _static(self, path[len("/static/"):])
        if path == "/api/status":
            return _json(self, 200, self._status())
        if path == "/api/jobs":
            return _json(self, 200, {"jobs": _all_jobs()})
        if path == "/api/logs":
            return _json(self, 200, self._logs(qs))
        if path == "/healthz":
            return _json(self, 200, {"ok": True})
        self.send_error(404)

    # ── POST ─────────────────────────────────────────────────────
    def do_POST(self):  # noqa: N802
        url = urllib.parse.urlparse(self.path)
        if url.path.startswith("/api/run/"):
            slug = url.path[len("/api/run/"):]
            try:
                job = _run_script(slug)
            except ValueError as e:
                return _json(self, 400, {"error": str(e)})
            except FileNotFoundError as e:
                return _json(self, 500, {"error": str(e)})
            return _json(self, 200, {"ok": True, "job": job})
        if url.path.startswith("/api/stop/"):
            job_id = url.path[len("/api/stop/"):]
            if not job_id:
                return _json(self, 400, {"error": "missing job_id"})
            report = _stop_job(job_id)
            code = 200 if report.get("ok") else 400
            return _json(self, code, report)
        return self.send_error(404)

    # ── Status payload ──────────────────────────────────────────
    def _status(self) -> dict:
        job = _current_job()
        log_path = Path(job["log_path"]) if job else None
        text = _tail_bytes(log_path) if log_path and log_path.exists() else ""
        markers = _scan_for_markers(text)
        running = bool(job and _is_running(job))
        return {
            "host": HOST_LABEL,
            "mode": job["mode"] if job else None,
            "current_job": job,
            "running": running,
            "git": _git_info(REPLICA_DIR),
            "script_dir": str(SCRIPT_DIR),
            "log_dir": str(LOG_DIR),
            "replica_dir": str(REPLICA_DIR),
            "scripts_available": {
                slug: (SCRIPT_DIR / name).exists()
                for slug, (name, _) in SCRIPTS.items()
            },
            "markers": markers,
            "recent_jobs": _all_jobs()[:8],
            "server_time": datetime.utcnow().isoformat() + "Z",
        }

    # ── Log payload ─────────────────────────────────────────────
    def _logs(self, qs: dict) -> dict:
        raw_filters = qs.get("filter", [])
        want = []
        for v in raw_filters:
            for token in v.split(","):
                token = token.strip()
                if token and token in KNOWN_FILTERS:
                    want.append(token)
        max_lines = int(qs.get("limit", ["500"])[0])
        max_lines = max(1, min(max_lines, 5000))
        log_path = None
        job = _current_job()
        if "job_id" in qs and qs["job_id"]:
            jid = qs["job_id"][0]
            for j in _all_jobs():
                if j["id"] == jid:
                    log_path = Path(j["log_path"])
                    break
        elif job:
            log_path = Path(job["log_path"])
        if log_path is None or not log_path.exists():
            return {"lines": [], "log_path": str(log_path) if log_path else None,
                    "filters_applied": want, "filters_available": KNOWN_FILTERS}
        lines = _filtered_tail(log_path, want, max_lines)
        return {
            "lines": lines,
            "log_path": str(log_path),
            "filters_applied": want,
            "filters_available": KNOWN_FILTERS,
        }


def _parse_bind(s: str) -> tuple[str, int]:
    if ":" not in s:
        return ("127.0.0.1", int(s))
    host, port = s.rsplit(":", 1)
    return (host, int(port))


def main() -> int:
    host, port = _parse_bind(BIND)
    httpd = ThreadingHTTPServer((host, port), Handler)
    print(f"replica-ops-gui: http://{host}:{port}", file=sys.stderr)
    print(f"  script_dir  = {SCRIPT_DIR}", file=sys.stderr)
    print(f"  log_dir     = {LOG_DIR}", file=sys.stderr)
    print(f"  replica_dir = {REPLICA_DIR}", file=sys.stderr)
    print(f"  host_label  = {HOST_LABEL}", file=sys.stderr)

    def _stop(*_):
        print("\nshutting down…", file=sys.stderr)
        httpd.shutdown()

    signal.signal(signal.SIGINT, _stop)
    signal.signal(signal.SIGTERM, _stop)
    httpd.serve_forever()
    return 0


if __name__ == "__main__":
    sys.exit(main())
