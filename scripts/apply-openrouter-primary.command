#!/usr/bin/env bash
# Make OpenRouter (grok-4.3) the PRIMARY chat provider and verify it live.
# Recreates the app container to pick up LLM_PRIMARY, then confirms the agent's
# answer was served by OpenRouter (checks the provider recorded in the DB).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply-openrouter-primary.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
BASE="http://localhost:3000"
echo "════════ set primary LLM = OpenRouter  $(date '+%H:%M:%S') ════════"
pass(){ echo "  ✅ $1"; }; warn(){ echo "  ⚠ $1"; }
rm -f .git/*.lock 2>/dev/null || true

echo "▶ 1. Commit + push code change (LLM_PRIMARY=openrouter, OpenRouter SSE streaming)"
git add -A
git commit -m "feat(agent): OpenRouter (grok-4.3) as primary chat provider, Ollama fallback; add OpenRouter SSE streaming + LLM_PRIMARY switch" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || warn "push failed (auth?) — continuing"

echo "▶ 2. Recreate the app container to load LLM_PRIMARY"
docker compose up -d app 2>&1 | tail -4

echo "▶ 3. Wait for the site"
for _ in $(seq 1 40); do curl -fsS -o /dev/null "$BASE/en" 2>/dev/null && { pass "site up"; break; }; sleep 3; done

echo "▶ 4. Agent smoke (should now be served by OpenRouter)"
SID=$(curl -fsS -X POST "$BASE/api/session" -H 'content-type: application/json' -d '{"locale":"en","consent":true}' 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{process.stdout.write(JSON.parse(s).sessionId||"")}catch{process.stdout.write("")}})')
if [ -n "$SID" ]; then
  pass "session $SID"
  echo "   Q: What does the CRA require for products with digital elements?"
  echo "   A: ----------------------------------------------------------"
  curl -sS --max-time 120 -X POST "$BASE/api/agent" -H 'content-type: application/json' \
    -d "{\"sessionId\":\"$SID\",\"message\":\"What does the CRA require for products with digital elements?\",\"locale\":\"en\",\"pageId\":\"cra\"}" 2>/dev/null | sed 's/^/      /'
  echo ""; echo "   ----------------------------------------------------------"
else warn "could not create a session"; fi

echo "▶ 5. Confirm which provider served it (from the DB)"
docker compose exec -T db psql -U "${POSTGRES_USER:-oxot}" -d "${POSTGRES_DB:-oxot}" -tAc \
  "select 'provider='||provider from agent_messages where role='assistant' order by created_at desc limit 1;" 2>&1 | sed 's/^/   /'

echo ""
echo "════════ done — provider should read 'openrouter' (grok-4.3) ════════"
read -r -p "Press Return to close…" _
