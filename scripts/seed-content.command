#!/usr/bin/env bash
# Apply the content seed (migration 003) + re-embed content + typecheck, inside the running app container.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/seed-content.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ OXOT seed content  $(date '+%H:%M:%S') ════════"
docker compose up -d db app >/dev/null 2>&1 || true

echo ""; echo "▶ db:migrate (applies 003_seed_content.sql)"
docker compose exec -T app npm run db:migrate || { echo "✖ migrate failed"; read -r -p "Return…" _; exit 1; }

echo ""; echo "▶ ingest (re-embeds content/{nl,en}/*.md)"
docker compose exec -T app npm run ingest || echo "  ⚠ ingest issue (check Ollama)"

echo ""; echo "▶ typecheck"
docker compose exec -T app npm run typecheck 2>&1 | tail -30 || echo "  ⚠ typecheck reported errors above"

echo ""; echo "▶ published pages in DB:"
docker compose exec -T db psql -U oxot -d oxot -t -c "select slug||' ('||locale||')' from pages where published order by slug, locale;" 2>/dev/null || true

echo ""
echo "════════ done — open http://localhost:3000/en  and  /nl ════════"
read -r -p "Press Return to close…" _
