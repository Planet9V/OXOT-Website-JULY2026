#!/usr/bin/env bash
# Live verification of remediation #1–#5 against the running stack (Docker + host Ollama + Postgres).
# Double-click in Finder. Applies migration 006, seeds pages, creates an admin, and smoke-tests
# the agent, contact form, sitemap/robots. Optionally enables main branch protection.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/verify-remediation.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ verify remediation   $(date '+%H:%M:%S') ════════"

pass(){ echo "  ✅ $1"; }
fail(){ echo "  ❌ $1"; }

echo "── 1. Bring the app up ─────────────────────────────"
docker compose up -d 2>&1 | tail -4
echo -n "   waiting for $BASE "
for _ in $(seq 1 40); do
  if curl -fsS -o /dev/null "$BASE/en" 2>/dev/null; then echo " up"; break; fi
  echo -n "."; sleep 2
done

echo "── 2. Migrate (applies 006_contact) + seed pages ───"
docker compose exec -T app node scripts/migrate.mjs 2>&1 | tail -3
docker compose exec -T app npm run seed:pages 2>&1 | tail -3

echo "── 3. Create an admin user ─────────────────────────"
read -r -p "   admin email (blank = skip): " ADMIN_EMAIL
if [ -n "${ADMIN_EMAIL:-}" ]; then
  read -r -s -p "   admin password: " ADMIN_PW; echo
  docker compose exec -T app node scripts/create-admin.mjs "$ADMIN_EMAIL" "$ADMIN_PW" 2>&1 | tail -2
fi

echo "── 4. Ollama generation model check ────────────────"
TAGS="$(curl -fsS http://localhost:11434/api/tags 2>/dev/null || true)"
if echo "$TAGS" | grep -q 'qwen3'; then pass "Ollama reachable; a qwen3 model is present"
else fail "Ollama chat model not found — set OPENROUTER_API_KEY in .env.local for the fallback path"; fi

echo "── 5. SEO surfaces ─────────────────────────────────"
curl -fsS "$BASE/sitemap.xml" 2>/dev/null | grep -q '<urlset' && pass "sitemap.xml serves a urlset" || fail "sitemap.xml"
curl -fsS "$BASE/sitemap.xml" 2>/dev/null | grep -q 'hreflang' && pass "sitemap has hreflang alternates" || fail "sitemap hreflang"
curl -fsS "$BASE/robots.txt" 2>/dev/null | grep -qi 'sitemap' && pass "robots.txt points to the sitemap" || fail "robots.txt"
curl -fsS "$BASE/en" 2>/dev/null | grep -q 'application/ld+json' && pass "home emits JSON-LD" || fail "home JSON-LD"
curl -fsS "$BASE/en" 2>/dev/null | grep -q 'hreflang' && pass "home has hreflang link tags" || fail "home hreflang"

echo "── 6. Contact API ──────────────────────────────────"
OK=$(curl -fsS -X POST "$BASE/api/contact" -H 'content-type: application/json' \
  -d '{"name":"Verify Bot","email":"verify@oxot.nl","message":"Automated smoke test — please ignore.","locale":"en","page":"/en/contact"}' 2>/dev/null)
echo "$OK" | grep -q '"ok":true' && pass "valid submission accepted" || fail "valid submission ($OK)"
BAD=$(curl -fsS -o /dev/null -w '%{http_code}' -X POST "$BASE/api/contact" -H 'content-type: application/json' \
  -d '{"name":"x","email":"nope","message":"short"}' 2>/dev/null)
[ "$BAD" = "400" ] && pass "invalid submission rejected (400)" || fail "invalid submission got $BAD"
HP=$(curl -fsS -X POST "$BASE/api/contact" -H 'content-type: application/json' \
  -d '{"name":"Bot","email":"b@b.com","message":"honeypot filled here","website":"http://spam"}' 2>/dev/null)
echo "$HP" | grep -q '"ok":true' && pass "honeypot returns fake 200 (bot not stored)" || fail "honeypot ($HP)"

echo "── 7. AI agent (grounded, streamed) ────────────────"
SID=$(curl -fsS -X POST "$BASE/api/session" -H 'content-type: application/json' \
  -d '{"locale":"en","consent":true}' 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{console.log(JSON.parse(s).sessionId||"")}catch{console.log("")}})')
if [ -n "$SID" ]; then
  pass "session created ($SID)"
  echo "   agent answer to 'What are the NIS2 reporting deadlines?':"
  echo "   ----------------------------------------------------------"
  curl -fsS -X POST "$BASE/api/agent" -H 'content-type: application/json' \
    -d "{\"sessionId\":\"$SID\",\"message\":\"What are the NIS2 reporting deadlines?\",\"locale\":\"en\",\"pageId\":\"nis2\"}" 2>/dev/null \
    | sed 's/^/   | /'
  echo ""
  echo "   ----------------------------------------------------------"
else
  fail "could not create a session"
fi

echo "── 8. Row counts (proof of persistence) ────────────"
docker compose exec -T db psql -U oxot -d oxot -tAc \
  "select 'contact_messages='||count(*) from contact_messages; select 'agent_messages='||count(*) from agent_messages;" 2>&1 | sed 's/^/   /'

echo "── 9. Unit tests inside the container ──────────────"
read -r -p "   run 'npm install && npm test' in the app container? [y/N]: " RUNTESTS
if [ "${RUNTESTS:-N}" = "y" ]; then
  docker compose exec -T app npm install --no-audit --no-fund 2>&1 | tail -2
  docker compose exec -T app npm test 2>&1 | tail -12
fi

echo "── 10. Branch protection on main ───────────────────"
read -r -p "   enable branch protection on main (requires CI + review)? [y/N]: " BP
if [ "${BP:-N}" = "y" ] && command -v gh >/dev/null 2>&1; then
  gh api -X PUT repos/Planet9V/OXOT-Website-JULY2026/branches/main/protection \
    -H "Accept: application/vnd.github+json" \
    -f 'required_status_checks[strict]=true' \
    -f 'required_status_checks[contexts][]=build-test' \
    -f 'required_status_checks[contexts][]=secret-scan' \
    -F 'enforce_admins=true' \
    -f 'required_pull_request_reviews[required_approving_review_count]=1' \
    -F 'restrictions=' 2>&1 | tail -5 && pass "branch protection enabled" || fail "branch protection (check gh auth/permits)"
else
  echo "   skipped."
fi

echo "════════ verification complete — see verify-remediation.log ════════"
read -r -p "Press Return to close…" _
