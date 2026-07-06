#!/usr/bin/env bash
# Apply the CMS-editable homepage feature: migrate site_blocks (007) + seed it
# from the current dictionary defaults, and commit/push. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-home-cms.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ apply home CMS  $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

echo "▶ 1. Commit + push"
git add -A
git commit -m "feat(admin): make homepage hero + services CMS-editable (structured fields)

- migration 007 site_blocks (JSONB per key/locale) + seed:site from dictionaries
- src/lib/site-content.ts (typed getHomeContent w/ dictionary fallback + save)
- homepage reads from DB (falls back to defaults if unset)
- /api/admin/site-content GET/POST + HomeContentEditor in the admin dashboard" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"

echo "▶ 2. Migrate (creates site_blocks) + seed"
docker compose exec -T app npm run db:migrate 2>&1 | tail -4 || die "migrate failed"
docker compose exec -T app npm run seed:site 2>&1 | tail -4 || echo "  ⚠ seed:site failed"

echo "▶ 3. Confirm rows"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
  "select 'site_blocks='||count(*) from site_blocks;" 2>&1 | sed 's/^/   /'

echo ""
echo "✅ Done. Edit the homepage in the admin: http://localhost:3000/admin/login"
echo "   (admin@oxot.local / OxotDev!2026) → 'Homepage content (hero + services)'"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
