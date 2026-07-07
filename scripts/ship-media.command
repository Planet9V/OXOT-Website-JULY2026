#!/usr/bin/env bash
# Push code, apply DB migrations (creates the media table), and seed the CRA
# hero-carousel PDFs into media. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-media.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship media  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "feat(media): media library + reusable carousel + live PDF hero (en+nl)" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ migrate (creates media table)"
docker compose exec -T app npm run db:migrate 2>&1 | tail -12
echo "▶ seed media (CRA hero PDFs)"
docker compose exec -T app node scripts/seed-media.mjs 2>&1 | tail -8
echo "▶ media now in DB:"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
 "select id||' '||filename||' '||size||'B' from media order by id;" 2>&1 | sed 's/^/   /'
echo "════════ done ════════"
read -r -p "Press Return to close…" _
