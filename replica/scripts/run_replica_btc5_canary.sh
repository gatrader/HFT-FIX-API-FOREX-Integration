#!/usr/bin/env bash
set -euo pipefail

ROOT="${ROOT:-/home/ubuntu/autoredeeem-2026-04-22}"
SIDE="${1:-down}"

case "$SIDE" in
  up|UP)
    SIDE="up"
    ;;
  down|DOWN)
    SIDE="down"
    ;;
  *)
    echo "Usage: $0 [up|down]" >&2
    exit 1
    ;;
esac

: "${POLYMARKET_PRIVATE_KEY:?Set POLYMARKET_PRIVATE_KEY first}"
SIG_TYPE="${POLYMARKET_SIGNATURE_TYPE:-2}"
FUNDER="${POLYMARKET_FUNDER:-0x31d39De926465dc288948846efc44Bfe64914399}"
CANARY_SHARES="${CANARY_SHARES:-5}"
SRC_BIN="${SRC_BIN:-/home/ubuntu/worktrees/review-head/replica/target/release/arbigab-replica}"
SRC_CREDS="${SRC_CREDS:-/home/ubuntu/worktrees/review-head/replica/.replica-livefill/creds.json}"
BIN_DIR="$ROOT/bin"
STATE_DIR="$ROOT/state"
GEN_DIR="$ROOT/generated"
BIN="$BIN_DIR/arbigab-replica"
CREDS="$STATE_DIR/creds.json"
NONCE="$STATE_DIR/nonce"
EVENT_JSON="$GEN_DIR/current-btc5-event.json"

mkdir -p "$BIN_DIR" "$STATE_DIR" "$GEN_DIR"

if [ ! -x "$BIN" ] || [ "$SRC_BIN" -nt "$BIN" ]; then
  install -m 755 "$SRC_BIN" "$BIN"
fi

if [ ! -s "$CREDS" ]; then
  echo "Bootstrapping clean-room creds into $CREDS"
  if ! "$BIN" \
      --key "$POLYMARKET_PRIVATE_KEY" \
      --creds "$CREDS" \
      --signature-type "$SIG_TYPE" \
      --funder "$FUNDER" \
      bootstrap; then
    echo "Bootstrap failed; falling back to the existing cached creds from the live worktree." >&2
    cp "$SRC_CREDS" "$CREDS"
  fi
fi

. "$ROOT/.venv/bin/activate"

python3 "$ROOT/scripts/resolve_next_btc5.py" --which next > "$EVENT_JSON"

SLUG="$(python3 - <<'PY' "$EVENT_JSON"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
print(data["slug"])
PY
)"

python3 "$ROOT/scripts/prepare_btc5_comparison.py" \
  --slug "$SLUG" \
  --output-dir "$GEN_DIR" \
  --symbol-prefix "btc5-canary" \
  --max-buy-order-size "$CANARY_SHARES" \
  --seed-shares "$CANARY_SHARES" \
  --min-price 0.35 \
  --max-price 0.65 \
  --stop-before-end-ms 20000 \
  --cancel-orders-on-start

TOKEN_ID="$(python3 - <<'PY' "$EVENT_JSON" "$SIDE"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
field = "upTokenId" if sys.argv[2] == "up" else "downTokenId"
print(data[field])
PY
)"

MARKET_ID="$(python3 - <<'PY' "$EVENT_JSON"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
print(data["conditionId"])
PY
)"

SLEEP_SECS="$(python3 - <<'PY' "$EVENT_JSON"
import datetime as dt
import json
import sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
start = dt.datetime.fromisoformat(data["startDate"].replace("Z", "+00:00"))
now = dt.datetime.now(dt.timezone.utc)
delta = int((start - now).total_seconds()) + 5
print(max(0, delta))
PY
)"

if [ "$SLEEP_SECS" -gt 0 ]; then
  echo "Waiting ${SLEEP_SECS}s for ${SLUG} to open..."
  sleep "$SLEEP_SECS"
fi

SECONDS_LEFT="$(python3 - <<'PY' "$EVENT_JSON"
import datetime as dt
import json
import sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
end = dt.datetime.fromisoformat(data["endDate"].replace("Z", "+00:00"))
now = dt.datetime.now(dt.timezone.utc)
remaining = int((end - now).total_seconds()) - 20
print(max(0, remaining))
PY
)"

FEE_RATE_BPS="${FEE_RATE_BPS:-$(python3 - <<'PY' "$EVENT_JSON"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
print(int(data.get("makerBaseFee") or 0))
PY
)}"

if [ "$SECONDS_LEFT" -lt 30 ]; then
  echo "Less than 30 seconds remain in ${SLUG}; aborting canary." >&2
  exit 1
fi

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
CONFIG_PATH="$GEN_DIR/${SLUG}.replica.json"
PRE_CLEANUP_LOG="$GEN_DIR/replica-btc5-${SIDE}-${SLUG}-${STAMP}.pre-cleanup.log"
CANARY_LOG="$GEN_DIR/replica-btc5-${SIDE}-${SLUG}-${STAMP}.canary.log"
POST_CLEANUP_LOG="$GEN_DIR/replica-btc5-${SIDE}-${SLUG}-${STAMP}.post-cleanup.log"

export RUST_LOG="${RUST_LOG:-runtime=info,hotpath=info,order_body=info,order_response=info,order_reject=warn,cancel=info,shutdown=warn,ws=info}"

run_cleanup_pass() {
  local log_path="$1"
  : > "$NONCE"
  "$BIN" \
    --key "$POLYMARKET_PRIVATE_KEY" \
    --creds "$CREDS" \
    --nonce "$NONCE" \
    --signature-type "$SIG_TYPE" \
    --funder "$FUNDER" \
    runtime \
    --config "$CONFIG_PATH" \
    --token-id "$TOKEN_ID" \
    --market "$MARKET_ID" \
    --force-cancel-on-start \
    --net-position=0 \
    --fee-rate-bps "$FEE_RATE_BPS" \
    --tick-interval-ms 250 \
    --book-max-age-ms 1000 \
    --dedup-window-ms 20000 \
    --submit-budget-per-sec 1 \
    --price-bucket 0.01 \
    --size-bucket 1 \
    --cancel-dedup-ms 250 \
    --cancel-queue-capacity 4 \
    --duration-secs 3 \
    --submit-queue-capacity 4 \
    --realtime \
    > "$log_path" 2>&1 || true
}

echo "Running pre-canary cleanup cancel pass"
run_cleanup_pass "$PRE_CLEANUP_LOG"
echo "Pre-cleanup log: $PRE_CLEANUP_LOG"
grep -E 'startup cancel_all ok|startup cancel_all failed|duration reached' "$PRE_CLEANUP_LOG" || true

echo "Running single-order BTC5 ${SIDE} canary on ${SLUG} with ${CANARY_SHARES} shares and fee ${FEE_RATE_BPS} bps"
# Intentional safety choice:
# use the single-shot `canary` subcommand instead of the long-lived `runtime`
# loop so one invocation cannot keep stacking repeated same-side exposure.
: > "$NONCE"
"$BIN" \
  --key "$POLYMARKET_PRIVATE_KEY" \
  --creds "$CREDS" \
  --nonce "$NONCE" \
  --signature-type "$SIG_TYPE" \
  --funder "$FUNDER" \
  canary \
  --config "$CONFIG_PATH" \
  --token-id "$TOKEN_ID" \
  --net-position="-$CANARY_SHARES" \
  --fee-rate-bps "$FEE_RATE_BPS" \
  --iterations 1 \
  > "$CANARY_LOG" 2>&1 || true

echo "Canary log: $CANARY_LOG"
grep -E 'placing single order|submit complete|order_response|order_reject|iteration failed|done' "$CANARY_LOG" || true

echo "Running post-canary cleanup cancel pass"
run_cleanup_pass "$POST_CLEANUP_LOG"
echo "Post-cleanup log: $POST_CLEANUP_LOG"
grep -E 'startup cancel_all ok|startup cancel_all failed|duration reached' "$POST_CLEANUP_LOG" || true
