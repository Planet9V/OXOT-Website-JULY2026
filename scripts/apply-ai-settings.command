#!/usr/bin/env bash
# Push the AI-settings feature and apply migration 010 (app_settings) in the container.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-ai-settings.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ apply AI settings  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "chore(ai-settings): apply migration marker" >/dev/null 2>&1 || echo "  (nothing to commit)"
echo "▶ push"; git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"
echo "▶ migrate (creates app_settings)"; docker compose exec -T app npm run db:migrate 2>&1 | tail -6
echo "▶ app_settings table check"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
  "select 'app_settings exists = '||to_regclass('public.app_settings') is not null;" 2>&1 | sed 's/^/   /'
echo "════════ done — open http://localhost:3000/admin (AI & Models) ════════"
read -r -p "Press Return to close…" _
