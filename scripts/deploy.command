#!/usr/bin/env bash
# OXOT one-shot DEPLOY + VERIFY — double-click on macOS.
# Pushes code, brings the Docker stack up on the Mac's Ollama, migrates, seeds CMS
# pages, ingests embeddings, then smoke-tests SEO + contact + the AI agent.
# Idempotent. Optional admin creation via env: OXOT_ADMIN_EMAIL / OXOT_ADMIN_PW.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/deploy.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ OXOT deploy + verify   $(date '+%H:%M:%S') ════════"
step(){ echo ""; echo "▶ $*"; }
pass(){ echo "  ✅ $1"; }
fail(){ echo "  ❌ $1"; }
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }

step "Preflight"
command -v docker >/dev/null || die "docker not on PATH"
docker info >/dev/null 2>&1 || die "Docker daemon not running — start Docker Desktop."
[ -f .env.local ] || die ".env.local missing"
curl -fs http://localhost:11434/api/tags >/dev/null 2>&1 && pass "Ollama reachable" || echo "  ⚠ Ollama not reachable at :11434 (run: ollama serve). Agent will use OpenRouter fallback."
echo "  OpenRouter fallback model: $(grep -E '^OPENROUTER_MODEL=' .env.local | cut -d= -f2)"

step "Push code to GitHub (feature/remediation-1-5)"
rm -f .git/*.lock 2>/dev/null || true
git checkout feature/remediation-1-5 2>/dev/null || git checkout -B feature/remediation-1-5
git add -A
git commit -m "chore: deploy — set OpenRouter fallback model, finalize remediation #1-#5" || echo "  (nothing to commit)"
git push -u origin feature/remediation-1-5 2>&1 | tail -4 || echo "  ⚠ push failed (check gh/git auth) — continuing with local deploy"

step "docker compose build + up"
docker compose build || die "build failed"
docker compose up -d || die "compose up failed"

step "Wait for Postgres"
for i in $(seq 1 30); do
  docker compose exec -T db pg_isready -U "${POSTGRES_USER:-oxot}" >/dev/null 2>&1 && { pass "db ready"; break; }
  sleep 2; [ "$i" = 30 ] && die "db never ready"
done

step "Wait for the app to install deps + start (PID1 self-installs on first boot; can take 1-2 min)"
UP=0
for i in $(seq 1 90); do
  if curl -fsS -o /dev/null "$BASE/en" 2>/dev/null; then pass "site up"; UP=1; break; fi
  sleep 3
  if [ $((i % 10)) -eq 0 ]; then echo "   …still starting (${i}0s) — deps: $(docker compose exec -T app sh -lc '[ -x node_modules/.bin/next ] && echo installed || echo installing' 2>/dev/null)"; fi
done
[ "$UP" = 1 ] || echo "  ⚠ site not responding yet — continuing; check: docker compose logs -f app"

step "Migrate schema (incl 006_contact)"
docker compose exec -T app npm run db:migrate 2>&1 | tail -4 || die "migrate failed"

step "Seed CMS pages (en+nl) + ingest embeddings"
docker compose exec -T app npm run seed:pages 2>&1 | tail -3 || echo "  ⚠ seed:pages failed"
docker compose exec -T app npm run ingest 2>&1 | tail -3 || echo "  ⚠ ingest failed — re-run: docker compose exec app npm run ingest"

step "Run unit tests in container"
docker compose exec -T app npm test 2>&1 | tail -8 || echo "  ⚠ tests reported failures (see above)"

step "Admin"
if [ -n "${OXOT_ADMIN_EMAIL:-}" ] && [ -n "${OXOT_ADMIN_PW:-}" ]; then
  docker compose exec -T app node scripts/create-admin.mjs "$OXOT_ADMIN_EMAIL" "$OXOT_ADMIN_PW" 2>&1 | tail -2
else
  echo "  ℹ set OXOT_ADMIN_EMAIL + OXOT_ADMIN_PW before running to auto-create an admin, or run:"
  echo "     docker compose exec app node scripts/create-admin.mjs you@oxot.nl 'strong-pw'"
fi

step "SEO smoke"
curl -fsS "$BASE/sitemap.xml" 2>/dev/null | grep -q '<urlset' && pass "sitemap urlset" || fail "sitemap"
curl -fsS "$BASE/sitemap.xml" 2>/dev/null | grep -q 'hreflang' && pass "sitemap hreflang" || fail "sitemap hreflang"
curl -fsS "$BASE/robots.txt" 2>/dev/null | grep -qi 'sitemap' && pass "robots -> sitemap" || fail "robots"
curl -fsS "$BASE/en" 2>/dev/null | grep -q 'application/ld+json' && pass "home JSON-LD" || fail "home JSON-LD"

step "Contact smoke"
V=$(curl -fsS -X POST "$BASE/api/contact" -H 'content-type: application/json' -d '{"name":"Deploy Bot","email":"deploy@oxot.nl","message":"Automated deploy smoke test.","locale":"en","page":"/en/contact"}' 2>/dev/null)
echo "$V" | grep -q '"ok":true' && pass "contact accepts valid" || fail "contact valid ($V)"
B=$(curl -fsS -o /dev/null -w '%{http_code}' -X POST "$BASE/api/contact" -H 'content-type: application/json' -d '{"name":"x","email":"bad","message":"short"}' 2>/dev/null)
[ "$B" = "400" ] && pass "contact rejects invalid (400)" || fail "invalid got $B"

step "Agent smoke (grounded, streamed)"
SID=$(curl -fsS -X POST "$BASE/api/session" -H 'content-type: application/json' -d '{"locale":"en","consent":true}' 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{process.stdout.write(JSON.parse(s).sessionId||"")}catch{process.stdout.write("")}})')
if [ -n "$SID" ]; then
  pass "session $SID"
  echo "   Q: What are the NIS2 reporting deadlines?"
  echo "   A: --------------------------------------- (up to 120s: Ollama first-load or grok fallback)"
  curl -sS --max-time 120 -X POST "$BASE/api/agent" -H 'content-type: application/json' \
    -d "{\"sessionId\":\"$SID\",\"message\":\"What are the NIS2 reporting deadlines?\",\"locale\":\"en\",\"pageId\":\"nis2\"}" 2>/dev/null | sed 's/^/      /' \
    || echo "      ⚠ agent call timed out at 90s (check: docker compose logs app | tail)"
  echo ""; echo "   ----------------------------------------"
else fail "no session (check DB/app logs)"; fi

step "Row counts"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
  "select 'pages='||count(*) from pages; select 'content_chunks='||count(*) from content_chunks; select 'contact_messages='||count(*) from contact_messages; select 'agent_messages='||count(*) from agent_messages;" 2>&1 | sed 's/^/   /'

echo ""
echo "════════ DEPLOY DONE — open $BASE/en  and  $BASE/nl ════════"
echo " Admin: $BASE/admin/login   |   log: deploy.log"
read -r -p "Press Return to close…" _
