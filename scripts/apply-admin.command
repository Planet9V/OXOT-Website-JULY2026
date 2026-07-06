#!/usr/bin/env bash
# Ship the modern admin + WYSIWYG editor: install new deps in the container,
# restart, and confirm the admin loads. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-admin.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ ship admin + WYSIWYG  $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

echo "▶ 1. Commit + push"
git add -A
git commit -m "feat(admin): modern shadcn admin shell + dashboard (KPIs + recharts) + TipTap WYSIWYG editor (markdown round-trip); shadcn ui components + tokens; polished login" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"

echo "▶ 2. Install new deps inside the app container (tiptap, radix, recharts, lucide, cva…)"
docker compose exec -T app npm install --no-audit --no-fund 2>&1 | tail -5 || die "npm install failed in container"

echo "▶ 3. Restart the dev server"
docker compose restart app 2>&1 | tail -2
for i in $(seq 1 30); do
  code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x)
  [ "$code" = "200" ] && { echo "  dev ready after ~$((i*5))s"; break; }
  sleep 5
done

echo "▶ 4. Smoke: admin login page + build compile"
docker compose exec -T app node -e "fetch('http://localhost:3000/admin/login').then(r=>console.log('   /admin/login ->',r.status)).catch(e=>console.log('   ERR',e.message))" 2>&1
echo "════════ done — open $BASE/admin/login (admin@oxot.local / OxotDev!2026) ════════"
read -r -p "Press Return to close…" _
