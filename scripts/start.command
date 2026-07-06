#!/usr/bin/env bash
# Post-reboot START — checks whether the stack is running, then brings it up if
# not. Data persists in Docker volumes (pgdata + embeddings), so NO rebuild or
# re-ingest is needed. Double-click to run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/start.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ OXOT start / status  $(date '+%H:%M:%S') ════════"
pass(){ echo "  ✅ $1"; }
warn(){ echo "  ⚠ $1"; }

echo "▶ 1. Docker daemon"
if ! docker info >/dev/null 2>&1; then
  echo "  ❌ Docker daemon not running. Start Docker Desktop (Applications ▸ Docker),"
  echo "     wait for the whale icon to settle, then double-click this again."
  read -r -p "Press Return to close…" _; exit 1
fi
pass "Docker daemon up"

echo "▶ 2. Current container status (before)"
docker compose ps 2>&1 | sed 's/^/   /'
RUNNING=$(docker compose ps --status running --services 2>/dev/null | tr '\n' ' ')
echo "   running services: ${RUNNING:-<none>}"

echo "▶ 3. Ollama (host) — needed for local generation/embeddings"
if curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then
  pass "Ollama reachable on :11434"
else
  warn "Ollama not reachable — start it (open the Ollama app, or run 'ollama serve')."
  warn "The site still runs; the agent will use the OpenRouter grok-4.3 fallback."
fi

echo "▶ 4. Bring the stack up (idempotent; no rebuild)"
docker compose up -d 2>&1 | sed 's/^/   /'

echo "▶ 5. Wait for Postgres + site"
for i in $(seq 1 30); do docker compose exec -T db pg_isready -U "${POSTGRES_USER:-oxot}" >/dev/null 2>&1 && { pass "db ready"; break; }; sleep 2; done
UP=0
for i in $(seq 1 60); do
  curl -fsS -o /dev/null "$BASE/en" 2>/dev/null && { pass "site up at $BASE"; UP=1; break; }
  sleep 3
  [ $((i % 10)) -eq 0 ] && echo "   …still starting (${i}x3s)"
done
[ "$UP" = 1 ] || warn "site not responding yet — check: docker compose logs -f app"

echo "▶ 6. Data check (persisted across reboot)"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
  "select 'pages='||count(*) from pages; select 'content_chunks='||count(*) from content_chunks; select 'admin_users='||count(*) from admin_users;" 2>&1 | sed 's/^/   /'

echo ""
echo "════════ READY — open $BASE/en  and  $BASE/nl ════════"
echo " Admin: $BASE/admin/login   (admin@oxot.local / OxotDev!2026)"
read -r -p "Press Return to close…" _
