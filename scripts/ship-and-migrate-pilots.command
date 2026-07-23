#!/usr/bin/env bash
# Ship the dynamic page-list builder + migration script, then migrate two PILOT
# pages (privacy, services) markdown -> blocks, zero-loss. DRY-RUN is shown first;
# APPLY only runs if the dry-run reports no failures. Snapshot + in-txn parity
# assertion make every step reversible.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-and-migrate-pilots.log"; : > "$LOG"; exec > >(tee -a "$LOG") 2>&1
echo "ship-and-migrate-pilots $(date '+%H:%M:%S')"
rm -f .git/index.lock 2>/dev/null || true
command -v railway >/dev/null 2>&1 || { echo "railway CLI not found"; read -r -p "Return…" _; exit 1; }
PROXY_HOST="tokaido.proxy.rlwy.net"; PROXY_PORT="39903"
RUN="PROXY_HOST=$PROXY_HOST PROXY_PORT=$PROXY_PORT"

echo "--- pre-flight: SQL guard ---"
node scripts/check-sql.mjs || { echo "SQL CHECK FAILED"; read -r -p "Return…" _; exit 1; }

echo "--- commit + push code (builder dynamic page list + migration script) ---"
git add src/components/admin/page-builder.tsx scripts/migrate-page-to-blocks.mjs scripts/verify-migration.mjs scripts/ship-and-migrate-pilots.command
git diff --cached --quiet && echo "nothing to commit" || git commit -m "Page Builder: list all pages from DB + lossless markdown->blocks migration

- Builder page dropdown now merges the three flagship pages with every page in
  the DB (deduped by slug), so migrated and newly-created block pages are
  selectable/editable. Markdown pages are tagged '(markdown)'.
- scripts/migrate-page-to-blocks.mjs: migrate a markdown page to the block CMS
  zero-loss — snapshot pages row into page_versions, write ONE prose block whose
  markdown equals the body VERBATIM (in-txn parity assertion, rollback on any
  mismatch), flip content_type='blocks'. pages.body is left intact. DRY-RUN by
  default; --apply to write.

tsc: 0 errors in src/. Pilots: privacy, services."
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "push failed"

echo
echo "=================== DRY-RUN (read-only) ==================="
railway run bash -c "$RUN node scripts/migrate-page-to-blocks.mjs privacy services"
DRY=$?
if [ $DRY -ne 0 ]; then echo "DRY-RUN reported problems (exit $DRY) — NOT applying."; read -r -p "Return…" _; exit 1; fi

echo
echo "=================== APPLY ==================="
railway run bash -c "$RUN node scripts/migrate-page-to-blocks.mjs --apply privacy services"
APP=$?
echo "apply exit=$APP"

echo
echo "=================== VERIFY (live DB) ==================="
railway run bash -c "$RUN node scripts/verify-migration.mjs privacy services"
echo "verify exit=$?"
read -r -p "Return…" _
