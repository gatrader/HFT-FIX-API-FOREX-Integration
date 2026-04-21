# replica operator GUI

A zero-dependency Python 3 stdlib web GUI that wraps the four validated
`replica-*.sh` operator scripts. The CLI workflow is unchanged — this
just gives you a single pane over the same scripts + log markers you
already grep for.

## what it shows

- **Header:** host, branch / commit, current mode, server clock.
- **Status cards:** user-WS connected, last `submit complete`, last
  `fill applied`, last `order_reject`, last `startup cancel_all ok`,
  last `duration reached`.
- **Actions:** buttons for paper, live 5m, user-ws 30s, cleanup — each
  exec's the matching `replica-*.sh` on disk; buttons disable when a
  script isn't present.
- **Log viewer:** tails the current job's log file, optional filters
  for the five known marker strings.

## running it

On the operator host (AWS):

```bash
python3 /home/ubuntu/worktrees/review-head/replica/ops/gui/server.py
```

That's it — Python 3 stdlib only, nothing to install. By default it
binds `127.0.0.1:8787`; from your laptop tunnel it:

```bash
ssh -N -L 8787:127.0.0.1:8787 ubuntu@<host>
# then open http://localhost:8787
```

## environment knobs

All optional; defaults target the existing AWS host layout.

| var              | default                                              | purpose                                     |
| ---------------- | ---------------------------------------------------- | ------------------------------------------- |
| `GUI_BIND`       | `127.0.0.1:8787`                                     | host:port to listen on                      |
| `GUI_SCRIPT_DIR` | `/home/ubuntu/bin`                                   | where `replica-*.sh` live                   |
| `GUI_LOG_DIR`    | `/home/ubuntu/logs`                                  | where job log files are written             |
| `GUI_REPLICA_DIR`| `/home/ubuntu/worktrees/review-head/replica`         | git worktree for branch/commit detection    |
| `GUI_HOST_LABEL` | `$(hostname)`                                        | label shown in the header                   |

Example with overrides:

```bash
GUI_BIND=0.0.0.0:8787 GUI_LOG_DIR=/tmp/replica-logs \
  python3 server.py
```

(Don't bind `0.0.0.0` without an auth layer in front — actions are
unauthenticated and will exec scripts.)

## scripts it knows about

Whitelisted; the slug is what the frontend POSTs:

| slug         | script                     |
| ------------ | -------------------------- |
| `paper`      | `replica-paper.sh`         |
| `live5m`     | `replica-live-5m.sh`       |
| `userws30s`  | `replica-userws-30s.sh`    |
| `cleanup`    | `replica-cleanup.sh`       |

No other paths can be executed — the GUI never accepts an
operator-supplied command string.

## endpoints

- `GET  /`              → dashboard
- `GET  /api/status`    → JSON (mode, git, markers, current job)
- `GET  /api/jobs`      → JSON (up to 32 most recent jobs)
- `GET  /api/logs?filter=…&job_id=…&limit=…` → tail of job log
- `POST /api/run/<slug>` → launch script, return job record
- `GET  /healthz`       → `{ ok: true }`

## log file layout

Each run writes to `$GUI_LOG_DIR/<slug>-YYYYmmddTHHMMSSZ.log`, stdout
and stderr merged. The GUI reads these — nothing else depends on them,
so they can be pruned at will.

## what's still missing (known non-goals)

- no auth; intended behind SSH tunnel for a single operator.
- no job stop button; kill via `pkill` or wait out the duration.
- no historical chart of fills / rejects — the log pane is source
  of truth.
- branch / commit are read-only; switching branches is still a
  shell thing.
- does not parse structured JSON tracing output; pure substring
  match on the five known marker strings. If the replica changes
  those strings, update `KNOWN_FILTERS` in `server.py` and
  `KNOWN_FILTERS` in `static/app.js`.
