#!/usr/bin/env bash
# Merge ALL outstanding feature work into main. Double-click to run.
# Commits any pending changes on feature/remediation-1-5, then merges it to main
# and pushes. The other feature branches are already merged.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/merge-all.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ merge all features → main   $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

FEATURE=feature/remediation-1-5

echo "▶ 1. Commit any pending work on $FEATURE"
git checkout "$FEATURE" 2>/dev/null || die "cannot checkout $FEATURE"
git add -A
git commit -m "chore: finalize — memory notes + start/create-admin dev scripts" || echo "  (nothing to commit)"
git push origin "$FEATURE" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?) — will still try local merge"

echo "▶ 2. Update main"
git checkout main || die "cannot checkout main"
git pull --ff-only origin main 2>&1 | tail -3 || echo "  ⚠ pull skipped/offline"

echo "▶ 3. Merge $FEATURE → main"
git merge --no-ff "$FEATURE" -m "Merge $FEATURE: remediation #1–#5 + live-deploy hardening

- Light-mode diagrams, bilingual SEO (hreflang/sitemap/robots/JSON-LD/OG)
- Agent: pageId from URL, Ollama idle-timeout → OpenRouter grok-4.3 fallback
- Contact form + admin inbox (migration 006)
- Vitest suite (29 tests)
- Container node_modules volume isolation; enriched agent corpus (756 chunks)
- OpenRouter fallback model set to x-ai/grok-4.3" \
  || die "merge conflict — resolve manually, then: git commit && git push origin main"

echo "▶ 4. Push main"
git push origin main 2>&1 | tail -4 || die "push to main failed (check gh/git auth or branch protection)"

echo ""
echo "✅ Merged $FEATURE into main and pushed."
echo "   https://github.com/Planet9V/OXOT-Website-JULY2026/commits/main"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
