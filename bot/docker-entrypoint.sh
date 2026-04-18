#!/bin/sh
set -e

echo "========================================="
echo "  Arbigab - Starting up..."
echo "========================================="

# Initialize/migrate the database on every start
# This ensures the schema is up-to-date even after image updates
cd /app/web
echo "[init] Pushing database schema..."
node node_modules/prisma/build/index.js db push --accept-data-loss
echo "[init] Database ready."

echo "[init] Starting Next.js on port ${PORT:-8080}..."
exec node server.js
