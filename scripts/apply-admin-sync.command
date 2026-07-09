#!/usr/bin/env bash
# Push the admin-audit fixes and reseed the homepage block from the updated
# dictionary (new service hrefs + editable frameworks marquee). Double-click.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-admin-sync.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ apply admin sync  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A; git commit -m "chore: admin sync marker" >/dev/null 2>&1 || echo "  (nothing to commit)"
echo "▶ push"; git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ migrate (no-op if none pending)"; docker compose exec -T app npm run db:migrate 2>&1 | tail -2
echo "▶ reseed homepage block (applies new service hrefs + frameworks marquee)"
docker compose exec -T app npm run seed:site 2>&1 | tail -4
echo "▶ homepage service hrefs now in DB"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
  "select locale||': '||jsonb_array_length(data->'services'->'items')||' services, '||coalesce(jsonb_array_length(data->'services'->'frameworks'),0)||' marquee' from site_blocks where key='home' order by locale;" 2>&1 | sed 's/^/   /'
echo "════════ done — reload /en (homepage) ════════"
read -r -p "Press Return to close…" _
