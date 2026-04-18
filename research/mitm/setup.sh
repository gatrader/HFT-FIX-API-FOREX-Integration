#!/usr/bin/env bash
# Regenerate the MITM harness from scratch.
#
# Creates /tmp/mitm/ with:
#   ca.key, ca.crt         — self-signed CA
#   srv.key, srv.crt       — leaf cert signed by the CA, SAN covers both hosts
# Installs the CA into the system trust store and writes /etc/hosts entries
# redirecting gabagool22.com and gamma-api.polymarket.com to 127.0.0.1.
#
# Run as root inside the sandbox. Private keys are intentionally NOT committed;
# this script regenerates them deterministically-enough for the purpose.

set -euo pipefail

MITM_DIR=/tmp/mitm
mkdir -p "$MITM_DIR"
cd "$MITM_DIR"

# 1. CA
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
    -subj "/CN=localmitm-ca" -out ca.crt

# 2. Server cert with SAN covering every host we'll intercept
cat > srv.ext <<'EOF'
subjectAltName=DNS:gabagool22.com,DNS:gamma-api.polymarket.com,DNS:clob.polymarket.com
basicConstraints=CA:FALSE
EOF

openssl genrsa -out srv.key 2048
openssl req -new -key srv.key -subj "/CN=gabagool22.com" -out srv.csr
openssl x509 -req -in srv.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out srv.crt -days 3650 -sha256 -extfile srv.ext

# 3. Trust the CA system-wide (for reqwest/rustls which read OS trust store)
cp ca.crt /usr/local/share/ca-certificates/localmitm.crt
update-ca-certificates >/dev/null

# 4. Redirect target hosts to localhost
for H in gabagool22.com gamma-api.polymarket.com clob.polymarket.com; do
    grep -q "$H" /etc/hosts || echo "127.0.0.1 $H" >> /etc/hosts
done

echo "MITM harness ready. Start the server with:"
echo "  python3 $(dirname "$0")/server.py >> $MITM_DIR/capture.log 2>&1 &"
