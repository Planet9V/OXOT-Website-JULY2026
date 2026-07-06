#!/usr/bin/env bash
# Restore the full framework content (that migrate had clobbered to stubs) and
# ship the magazine article layout. Double-click.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-magazine.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"; DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ magazine + content restore  $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

echo "▶ 1. Commit + push (magazine ArticleShell + prose + migration 003 DO NOTHING fix)"
git add -A
git commit -m "feat(pages): magazine article layout (hero + sticky scroll-spy TOC + numbered sections + drop cap + CTA) for all framework/CMS pages; fix migration 003 to DO NOTHING so db:migrate never clobbers seeded content again" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"

echo "▶ 2. RESTORE full content into the DB (seed:pages overwrites the stubs)"
docker compose exec -T app npm run seed:pages 2>&1 | tail -6 || die "seed:pages failed"

echo "▶ 3. Restart dev server (loads magazine layout)"
docker compose restart app 2>&1 | tail -2
for i in $(seq 1 30); do
  code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x)
  [ "$code" = "200" ] && { echo "  dev ready after ~$((i*5))s"; break; }
  sleep 5
done

echo "▶ 4. Verify CRA now has FULL content (server-rendered length + section count)"
docker compose exec -T app node -e "fetch('http://localhost:3000/en/cra').then(r=>r.text()).then(t=>{console.log('   html length:', t.length); console.log('   <h2> sections:', (t.match(/<h2/g)||[]).length); console.log('   has \"coming soon\":', /coming soon/i.test(t))})" 2>&1
echo "▶ 5. DB body lengths per framework page"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
  "select slug||' '||locale||' = '||length(body)||' chars' from pages where slug in ('cra','nis2','ai-act','iec-62443','machine-act','ts-50701') and locale='en' order by slug;" 2>&1 | sed 's/^/   /'
echo "════════ done — open $BASE/en/cra ════════"
read -r -p "Press Return to close…" _
