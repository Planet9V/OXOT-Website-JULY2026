#!/usr/bin/env bash
# Commit + re-seed the framework page content and report sizes. Reusable per page.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-pages.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ ship pages  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "content: deep-expand framework page(s) with cited research (en+nl)" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
docker compose exec -T app npm run seed:pages 2>&1 | tail -3
echo "▶ framework page sizes (en)"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
 "select slug||' = '||length(body)||' chars' from pages where slug in ('cra','iec-62443','nis2','ai-act','machine-act','ts-50701') and locale='en' order by slug;" 2>&1 | sed 's/^/   /'
echo "════════ done ════════"
read -r -p "Press Return to close…" _
