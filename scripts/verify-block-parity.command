#!/usr/bin/env bash
# Phase 1 Gate 2 evidence — run the block parity harness against LIVE prod content
# (read-only; writes nothing). Also confirms migration 042 applied: the harness
# queries page_blocks, so a missing table would error here.
# Uses the Railway CLI to inject DATABASE_URL; overrides host:port with the
# current public TCP proxy (credentials stay in the injected env).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/verify-block-parity.log"; : > "$LOG"; exec > >(tee -a "$LOG") 2>&1
echo "verify-block-parity $(date '+%H:%M:%S')"
command -v railway >/dev/null 2>&1 || { echo "railway CLI not found"; read -r -p "Return…" _; exit 1; }

# Current pgvector public proxy (regenerated 2026-07-20). If connection resets,
# re-check Railway → pgvector → Settings → Networking → TCP Proxy and update these.
PROXY_HOST="tokaido.proxy.rlwy.net"
PROXY_PORT="39903"

echo "--- parity against live prod content (read-only) ---"
railway run bash -c "PROXY_HOST=$PROXY_HOST PROXY_PORT=$PROXY_PORT node scripts/verify-block-parity.mjs"
RC=$?
echo "parity exit=$RC"
read -r -p "Return…" _
