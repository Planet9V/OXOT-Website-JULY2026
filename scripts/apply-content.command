#!/usr/bin/env bash
# One-time: migrate + import content/pages/** + typecheck, then start a background AUTO-SEED
# watcher inside the container so future content/pages edits publish themselves (no screen needed).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-content.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ apply content + start watcher  $(date '+%H:%M:%S') ════════"
docker compose up -d db app >/dev/null 2>&1 || true
echo "▶ migrate"; docker compose exec -T app npm run db:migrate || { echo "✖ migrate failed"; read -r -p _ _; exit 1; }
echo ""; echo "▶ seed:pages (import content/pages/**)"; docker compose exec -T app npm run seed:pages || { echo "✖ seed failed"; read -r -p _ _; exit 1; }
echo ""; echo "▶ typecheck"; docker compose exec -T app npm run typecheck 2>&1 | tail -30 || echo "  ⚠ typecheck errors above"

echo ""; echo "▶ ensure Next dev server is alive"
docker compose exec -d app sh -lc "pgrep -f 'next dev' >/dev/null || npm run dev >/tmp/next-dev.log 2>&1 &" || true

echo ""; echo "▶ start AUTO-SEED watcher (polls content/pages every 5s; re-imports on change)"
docker compose exec -d app sh -lc '
  pkill -f oxot-seed-watch 2>/dev/null || true
  ( exec -a oxot-seed-watch sh -c "
      cd /workspace; touch /tmp/seed.stamp;
      while true; do
        if find content/pages -type f -newer /tmp/seed.stamp 2>/dev/null | grep -q .; then
          npm run seed:pages >/tmp/seed-watch.log 2>&1; touch /tmp/seed.stamp;
        fi; sleep 5;
      done
    " )
' || echo "  ⚠ could not start watcher"
sleep 2
echo "  watcher running:"; docker compose exec -T app sh -lc "pgrep -af oxot-seed-watch || echo '  (not found)'"

sleep 5
echo ""; echo "▶ smoke-check pages"
for p in en/nis2 en/ai-act; do
  docker compose exec -T app node -e "fetch('http://localhost:3000/$p').then(r=>console.log('$p ->',r.status)).catch(e=>console.log('$p ERR',e.message))" 2>&1 || true
done
echo "════════ done — watcher will auto-publish future content/pages edits ════════"
read -r -p "Press Return to close…" _
