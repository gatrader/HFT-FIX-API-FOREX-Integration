#!/usr/bin/env bash
#
# Arbigab replica canary driver.
#
# Modes (see research/CANARY_PLAN.md):
#   bootstrap                     one-time: call /auth/api-key, save creds
#   dryrun   --config F --token-id T [--net-position N]
#                                 build + sign, print payload, do NOT post
#   canary   --config F --token-id T --net-position N [--fee-rate-bps B]
#                                 place ONE real order, print response
#
# Conventions:
#   - Key read from env POLYMARKET_PRIVATE_KEY (never argv).
#   - Credentials cached in .replica/creds.json (gitignored).
#   - Nonce persisted in .replica/nonce (gitignored).
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$here"

require_key() {
  if [[ -z "${POLYMARKET_PRIVATE_KEY:-}" ]]; then
    cat <<EOF >&2
error: POLYMARKET_PRIVATE_KEY is not set.

Generate a fresh key on your own machine:
    cast wallet new                 # if you have foundry
    openssl rand -hex 32            # otherwise

Then export it in this shell (never paste it anywhere else):
    export POLYMARKET_PRIVATE_KEY=0x<hex>

EOF
    exit 1
  fi
}

require_creds() {
  if [[ ! -f .replica/creds.json ]]; then
    echo "error: .replica/creds.json not found — run '$0 bootstrap' first" >&2
    exit 1
  fi
}

build_release() {
  # Use debug build — faster iteration; canary runs seconds.
  cargo build --quiet
}

cmd="${1:-}"
shift || true

case "$cmd" in
  bootstrap)
    require_key
    build_release
    echo "Calling /auth/api-key..."
    ./target/debug/arbigab-replica bootstrap
    echo
    echo "Credentials saved to .replica/creds.json."
    echo "Fund the printed address with minimal MATIC + USDC.e on Polygon to proceed to dryrun."
    ;;

  dryrun)
    require_key
    require_creds
    build_release
    echo "Building + signing one order, NOT posting..."
    ./target/debug/arbigab-replica dryrun "$@"
    echo
    echo "Inspect the signed payload above. If it looks right, flip dry_run=false in the config and run 'canary'."
    ;;

  canary)
    require_key
    require_creds
    build_release
    echo "Placing ONE order on live CLOB. This costs MATIC for gas and commits USDC.e."
    read -r -p "Continue? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "aborted"; exit 0; }
    ./target/debug/arbigab-replica canary "$@"
    echo
    echo "If HTTP 200: verify the order in the Polymarket UI, then cancel and withdraw."
    echo "If HTTP 4xx: read the body. See research/CANARY_PLAN.md for common causes."
    ;;

  *)
    cat <<EOF >&2
usage:
  $0 bootstrap
  $0 dryrun --config <file> --token-id <id> [--net-position <f>]
  $0 canary --config <file> --token-id <id> --net-position <f> [--fee-rate-bps <b>]

See research/CANARY_PLAN.md for the full procedure.
EOF
    exit 2
    ;;
esac
