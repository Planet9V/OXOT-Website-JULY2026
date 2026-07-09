#!/usr/bin/env bash
# Ship the 6 dedicated service pages (en+nl): push, apply migration 015 (menu
# repoint), and seed the new pages into the CMS. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-service-pages.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ apply service pages  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "chore: service pages marker" >/dev/null 2>&1 || echo "  (nothing to commit)"
echo "▶ push"; git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ migrate (015 menu repoint)"; docker compose exec -T app npm run db:migrate 2>&1 | tail -4
echo "▶ seed pages (imports the 12 new markdown pages)"; docker compose exec -T app npm run seed:pages 2>&1 | tail -4
echo "▶ new service pages in DB"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
  "select slug||' ('||string_agg(locale,'/' order by locale)||')' from pages where slug in ('ot-security-assessments','ot-security-programmes','architecture-segmentation','secure-remote-access','ot-security-baseline','capability-transfer') group by slug order by slug;" 2>&1 | sed 's/^/   /'
echo "════════ done — reload /en/services and open a service ════════"
read -r -p "Press Return to close…" _
