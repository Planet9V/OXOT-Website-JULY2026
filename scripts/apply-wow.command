#!/usr/bin/env bash
# Ship the animated front page + vectorized inquiry management. Double-click.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-wow.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ ship front page + inquiries  $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

echo "▶ 1. Commit + push"
git add -A
git commit -m "feat: animated front page (motion: aurora, reveals, animated risk-map, count-up, spotlight cards, frameworks marquee) + vectorized inquiry management (migration 008, chat-session linkage, admin analysis view with transcript + similar + respond)" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"

echo "▶ 2. Install 'motion' in the app container"
docker compose exec -T app npm install --no-audit --no-fund 2>&1 | tail -4 || die "container npm install failed"

echo "▶ 3. Migrate (008 adds inquiry embedding + session link)"
docker compose exec -T app npm run db:migrate 2>&1 | tail -4 || die "migrate failed"

echo "▶ 4. Restart dev server"
docker compose restart app 2>&1 | tail -2
for i in $(seq 1 30); do
  code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x)
  [ "$code" = "200" ] && { echo "  dev ready after ~$((i*5))s"; break; }
  sleep 5
done

echo "▶ 5. Smoke: contact insert (should store + embed + link)"
V=$(curl -sS --max-time 20 -X POST "$BASE/api/contact" -H 'content-type: application/json' \
  -d '{"name":"Wow Test","email":"wow@oxot.nl","company":"Acme OT","message":"We need an IEC 62443 assessment for our water treatment SCADA.","locale":"en","page":"/en/contact"}' 2>/dev/null)
echo "   contact -> $V"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
  "select 'inquiries='||count(*)||'  with_vector='||count(embedding) from contact_messages;" 2>&1 | sed 's/^/   /'

echo "════════ done — open $BASE/en (front page) and $BASE/admin (Inquiries) ════════"
read -r -p "Press Return to close…" _
