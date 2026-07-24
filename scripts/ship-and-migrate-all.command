#!/usr/bin/env bash
# Migrate EVERY remaining markdown page -> blocks, zero-loss. Ships the script
# updates (--all support + verify SSL fallback), then DRY-RUN all, APPLY all,
# VERIFY all. Each page is snapshotted + in-txn parity-checked; rollback on any
# mismatch. pages.body is left intact.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-and-migrate-all.log"; : > "$LOG"; exec > >(tee -a "$LOG") 2>&1
echo "ship-and-migrate-all $(date '+%H:%M:%S')"
rm -f .git/index.lock 2>/dev/null || true
command -v railway >/dev/null 2>&1 || { echo "railway CLI not found"; read -r -p "Return…" _; exit 1; }
PROXY_HOST="tokaido.proxy.rlwy.net"; PROXY_PORT="39903"
RUN="PROXY_HOST=$PROXY_HOST PROXY_PORT=$PROXY_PORT"

echo "--- commit + push script updates ---"
git add scripts/migrate-page-to-blocks.mjs scripts/verify-migration.mjs scripts/ship-and-migrate-all.command scripts/ship-verifyfix.command
git diff --cached --quiet && echo "nothing to commit" || git commit -m "migrate/verify: --all support + verify SSL-fallback; migrate every remaining markdown page to blocks (lossless)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "push failed"

echo
echo "=================== DRY-RUN --all (read-only) ==================="
railway run bash -c "$RUN node scripts/migrate-page-to-blocks.mjs --all"
DRY=$?
if [ $DRY -ne 0 ]; then echo "DRY-RUN reported problems (exit $DRY) — NOT applying."; read -r -p "Return…" _; exit 1; fi

echo
echo "=================== APPLY --all ==================="
railway run bash -c "$RUN node scripts/migrate-page-to-blocks.mjs --apply --all"
echo "apply exit=$?"

echo
echo "=================== VERIFY --all (live DB) ==================="
railway run bash -c "$RUN node scripts/verify-migration.mjs --all"
echo "verify exit=$?"
read -r -p "Return…" _
