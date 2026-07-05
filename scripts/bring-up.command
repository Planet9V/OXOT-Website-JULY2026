#!/usr/bin/env bash
# OXOT local bring-up — double-click to run on macOS.
# Uses the Mac's Ollama (see docker-compose.override.yml). Idempotent & safe to re-run.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
# Mirror all output to a logfile so it can be monitored out-of-band.
LOG="$(pwd)/bring-up.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════════════════════════════════════════"
echo " OXOT bring-up  —  $(pwd)   $(date '+%H:%M:%S')"
echo "════════════════════════════════════════════"

step() { echo ""; echo "▶ $*"; }
die()  { echo "✖ $*"; echo ""; echo "Stopped. Fix the above and double-click again."; read -r -p "Press Return to close…" _; exit 1; }

# ---------- preflight ----------
step "Preflight checks"
command -v docker >/dev/null || die "docker not found on PATH"
docker info >/dev/null 2>&1 || die "Docker daemon not running — start Docker Desktop, then retry."
docker compose version >/dev/null 2>&1 || die "'docker compose' plugin not available."
echo "  ✓ docker + compose OK"

if curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then
  echo "  ✓ Ollama reachable on the Mac (localhost:11434)"
  TAGS=$(curl -fs http://localhost:11434/api/tags)
  for m in "qwen3-embedding:4b" "qwen3.5:9b"; do
    if echo "$TAGS" | grep -q "$m"; then echo "  ✓ model present: $m"
    else echo "  ⚠ model MISSING: $m  → run:  ollama pull $m"; fi
  done
else
  echo "  ⚠ Ollama not reachable at localhost:11434. Start it with:  ollama serve"
fi
[ -f .env.local ] || die ".env.local missing"
echo "  ✓ .env.local present"

# ---------- build & up (db + app only; ollama container is profiled off) ----------
step "docker compose build"
docker compose build || die "build failed"

step "docker compose up -d  (starts db + app; uses the Mac's Ollama)"
docker compose up -d || die "compose up failed"

step "Waiting for Postgres to accept connections"
for i in $(seq 1 30); do
  if docker compose exec -T db pg_isready -U "${POSTGRES_USER:-oxot}" >/dev/null 2>&1; then echo "  ✓ db ready"; break; fi
  sleep 2; [ "$i" = 30 ] && die "db never became ready"
done

# ---------- app deps, schema, content ----------
step "npm install (inside app container)"
docker compose exec -T app sh -lc "rm -rf node_modules package-lock.json package-lock.json.bak && npm install" || die "npm install failed"

step "Typecheck (non-fatal; reports real green light)"
docker compose exec -T app npm run typecheck 2>&1 | tail -30 || echo "  ⚠ typecheck reported errors (see above)"

step "db:migrate (creates vector(2560) schema)"
docker compose exec -T app npm run db:migrate || die "migration failed"

step "ingest (embeds content/{nl,en}/*.md via the Mac's Ollama)"
docker compose exec -T app npm run ingest || echo "  ⚠ ingest failed — re-run: docker compose exec app npm run ingest"

step "Starting Next.js dev server (detached) on http://localhost:3000"
docker compose exec -d app npm run dev || echo "  ⚠ start manually: docker compose exec app npm run dev"

echo ""
echo "════════════════════════════════════════════"
echo " DONE $(date '+%H:%M:%S').  Open  http://localhost:3000/en  or /nl"
echo " Create an admin login (choose your own password):"
echo "   docker compose exec app node scripts/create-admin.mjs you@oxot.example 'strong-password'"
echo "════════════════════════════════════════════"
read -r -p "Press Return to close this window…" _
