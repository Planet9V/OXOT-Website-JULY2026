#!/usr/bin/env bash
# Recreate the app container so the Next dev server runs as its MAIN process (with auto-seed watcher).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/restart-app.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ restart app  $(date '+%H:%M:%S') ════════"
echo "▶ recreate app with new command (dev server + watcher as PID1)"
docker compose up -d app 2>&1 | tail -8
echo ""; echo "▶ waiting for dev server to answer…"
ok=""
for i in $(seq 1 24); do
  code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x)
  if [ "$code" = "200" ]; then ok=1; echo "  dev ready (HTTP 200) after ~$((i*5))s"; break; fi
  sleep 5
done
[ -z "$ok" ] && echo "  ⚠ dev server not answering yet — check /tmp/next-dev.log"
echo ""; echo "▶ page smoke-check"
docker compose exec -T app node -e "Promise.all(['en','en/nis2','en/ai-act','en/cyber-digital-twin'].map(p=>fetch('http://localhost:3000/'+p).then(r=>console.log('  '+p,'->',r.status)).catch(e=>console.log('  '+p,'ERR',e.message)))).then(()=>process.exit(0))" 2>&1 || true
echo "════════ done ════════"
read -r -p "Press Return to close…" _
