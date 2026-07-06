#!/usr/bin/env bash
# Diagnose + restart the OXOT dev server; capture container status, logs, and an HTTP check.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/diag.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ OXOT diag/restart  $(date '+%H:%M:%S') ════════"
echo "▶ compose ps"; docker compose ps
echo ""; echo "▶ app container logs (last 60)"; docker compose logs app --tail 60 2>&1 | tail -60
echo ""; echo "▶ ensure containers up"; docker compose up -d db app >/dev/null 2>&1 || true
echo ""; echo "▶ (re)start Next dev server, detached"
docker compose exec -d app sh -lc "pkill -f 'next dev' 2>/dev/null; npm run dev >/tmp/next-dev.log 2>&1 &" || echo "  could not start"
sleep 8
echo ""; echo "▶ HTTP check on /en (inside container)"
docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>console.log('HTTP',r.status)).catch(e=>console.log('ERR',e.message))" 2>&1 || echo "  check failed"
echo ""; echo "▶ next dev log tail"
docker compose exec -T app sh -lc "tail -20 /tmp/next-dev.log 2>/dev/null" || true
echo "════════ done ════════"
read -r -p "Press Return to close…" _
