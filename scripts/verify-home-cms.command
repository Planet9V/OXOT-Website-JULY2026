#!/usr/bin/env bash
# Prove the homepage is DB-driven: temporarily change the stored NL hero title,
# hold 30s (reload http://localhost:3000/nl to see it), then auto-revert.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/verify-home-cms.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ verify home CMS  $(date '+%H:%M:%S') ════════"

echo "▶ change stored NL hero title in the DB"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -c \
 "UPDATE site_blocks SET data = jsonb_set(data,'{hero,title}', to_jsonb('✅ Bewerkt via de database (CMS test)'::text)) WHERE key='home' AND locale='nl';"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
 "select 'now: '||(data->'hero'->>'title') from site_blocks where key='home' and locale='nl';" | sed 's/^/   /'

echo "▶ RELOAD http://localhost:3000/nl NOW — reverting in 30s…"
sleep 30

echo "▶ revert (delete row → re-seed from dictionary defaults)"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -c \
 "DELETE FROM site_blocks WHERE key='home' AND locale='nl';" >/dev/null 2>&1
docker compose exec -T app npm run seed:site 2>&1 | tail -2
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc \
 "select 'reverted to: '||(data->'hero'->>'title') from site_blocks where key='home' and locale='nl';" | sed 's/^/   /'
echo "════════ done ════════"
read -r -p "Press Return to close…" _
