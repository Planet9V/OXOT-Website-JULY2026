#!/usr/bin/env bash
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-cra-expand.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ CRA deep-expand  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "content(cra): +5 article-level sections (en+nl) from OXOT research — Art. 3(1) product scoping, Art. 13 'where applicable' proportionality, SL-T/SL-C/SL-A→CRA mapping, harmonised-standards/Notified-Body gap, 100k-manufacturer scale; keyfacts panels" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ re-seed"; docker compose exec -T app npm run seed:pages 2>&1 | tail -3
echo "▶ new CRA body sizes"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
 "select slug||' '||locale||' = '||length(body)||' chars' from pages where slug='cra' order by locale;" 2>&1 | sed 's/^/   /'
echo "════════ done — open http://localhost:3000/en/cra ════════"
read -r -p "Press Return to close…" _
