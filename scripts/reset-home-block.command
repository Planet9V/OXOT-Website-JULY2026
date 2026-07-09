#!/usr/bin/env bash
# Reset the homepage block to the (updated) dictionary defaults by removing the
# stored site_blocks rows. Use only when the homepage hasn't been hand-edited in
# admin — after this the homepage renders from the shipped dictionary (new service
# hrefs + editable frameworks marquee), and the admin editor loads those defaults.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/reset-home-block.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
DBU="${POSTGRES_USER:-oxot}"; DBN="${POSTGRES_DB:-oxot}"
echo "════════ reset home block  $(date '+%H:%M:%S') ════════"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -c "DELETE FROM site_blocks WHERE key='home';" 2>&1 | sed 's/^/   /'
echo "▶ home block rows remaining (expect 0):"
docker compose exec -T db psql -U "$DBU" -d "$DBN" -tAc "select count(*) from site_blocks where key='home';" 2>&1 | sed 's/^/   /'
echo "════════ done — reload /en (homepage now uses updated defaults) ════════"
read -r -p "Press Return to close…" _
