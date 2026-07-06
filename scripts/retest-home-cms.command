#!/usr/bin/env bash
# Restart the dev server (to load force-dynamic), then prove the homepage reads
# the DB: change the NL hero title, check what the SERVER renders, hold 35s, revert.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/retest-home-cms.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ retest home CMS  $(date '+%H:%M:%S') ════════"

echo "▶ restart app (loads force-dynamic route config)"
docker compose restart app 2>&1 | tail -2
for i in $(seq 1 24); do
  code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x)
  [ "$code" = "200" ] && { echo "  dev ready after ~$((i*5))s"; break; }
  sleep 5
done

echo "▶ set NL hero title in DB"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -c \
 "UPDATE site_blocks SET data = jsonb_set(data,'{hero,title}', to_jsonb('✅ Bewerkt via de database (CMS test)'::text)) WHERE key='home' AND locale='nl';" >/dev/null

echo "▶ what does the SERVER render for /nl ?  (definitive)"
docker compose exec -T app node -e "fetch('http://localhost:3000/nl').then(r=>r.text()).then(t=>{const m=t.match(/<h1[^>]*>([\s\S]*?)<\/h1>/);console.log('   server H1:', (m?m[1]:'(none)').replace(/<[^>]+>/g,'').trim())})" 2>&1

echo "▶ RELOAD http://localhost:3000/nl in the browser now — reverting in 35s…"
sleep 35

echo "▶ revert"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -c "DELETE FROM site_blocks WHERE key='home' AND locale='nl';" >/dev/null 2>&1
docker compose exec -T app npm run seed:site 2>&1 | tail -1
docker compose exec -T app node -e "fetch('http://localhost:3000/nl').then(r=>r.text()).then(t=>{const m=t.match(/<h1[^>]*>([\s\S]*?)<\/h1>/);console.log('   server H1 after revert:', (m?m[1]:'(none)').replace(/<[^>]+>/g,'').trim())})" 2>&1
echo "════════ done ════════"
read -r -p "Press Return to close…" _
