#!/usr/bin/env bash
# Ship the bug fixes + mega-menu: push, apply migrations 011/012, and reseed the
# hero media from the normalized PDFs. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-menu-bugs.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ apply menu + bug fixes  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "chore: apply menu/bug marker" >/dev/null 2>&1 || echo "  (nothing to commit)"
echo "▶ push"; git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ migrate (011 parent_id/description, 012 frameworks mega-menu)"
docker compose exec -T app npm run db:migrate 2>&1 | tail -6
echo "▶ reseed hero media (normalized PDFs — fixes the page flip)"
docker compose exec -T app node scripts/seed-media.mjs 2>&1 | tail -4
echo "▶ menu tree check (top-level + children per locale)"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
  "select locale||': '||count(*) filter (where parent_id is null)||' top, '||count(*) filter (where parent_id is not null)||' child' from menu_items group by locale order by locale;" 2>&1 | sed 's/^/   /'
echo "════════ done — reload http://localhost:3000/en (hover 'Frameworks') ════════"
read -r -p "Press Return to close…" _
