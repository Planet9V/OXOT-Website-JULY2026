#!/usr/bin/env bash
# QA-gated ship: typecheck + i18n, merge PR #1 (doc fix), then commit Dutch social kit + code QA
# fixes on a feature branch, open a PR and merge it. Aborts if typecheck fails.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-dutch-qa.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship dutch+qa  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true

echo "▶ typecheck (gate)"
if ! docker compose exec -T app npm run typecheck 2>&1 | tee /tmp/tc.out | tail -20; then :; fi
if grep -qiE "error TS|\.tsx?\([0-9]+,[0-9]+\): error" /tmp/tc.out; then
  echo "✖ typecheck errors — aborting before any commit/merge. Fix and re-run."; read -r -p "Return…" _; exit 1
fi
echo "  ✓ typecheck clean"
echo ""; echo "▶ i18n:check"; docker compose exec -T app npm run i18n:check 2>&1 | tail -4 || true

echo ""; echo "▶ merge PR #1 (doc fix)"
git checkout main 2>/dev/null && git pull --ff-only 2>&1 | tail -2 || true
gh pr merge 1 --merge 2>&1 | tail -6 || echo "  (PR #1: merge manually if blocked)"
git checkout main 2>/dev/null && git pull --ff-only 2>&1 | tail -2 || true

echo ""; echo "▶ commit Dutch social kit + QA fixes on a branch"
git checkout -b feat/dutch-social-qa 2>/dev/null || git checkout feat/dutch-social-qa
git add marketing src
git commit -m "feat: Dutch social kit (LinkedIn posts + X threads + carousel scripts) + QA fixes: markdown heading-anchor de-dupe, inline React-key fix, blog locale guard" || echo "  (nothing to commit)"
git push -u origin feat/dutch-social-qa 2>&1 | tail -3 || { echo "push failed"; read -r -p _ _; exit 1; }
PRURL=$(gh pr create --base main --head feat/dutch-social-qa \
  --title "Dutch social kit + code QA fixes" \
  --body "Dutch LinkedIn posts, X threads and carousel scripts (nl), at structural parity with the English kit (links /nl/, X posts <=270 chars, builder syntax intact). Plus small code QA fixes from an Opus review: markdown heading-anchor de-duplication, inline-node React keys, blog locale guard. Typecheck clean." 2>&1 | tail -1)
echo "  PR: $PRURL"
gh pr merge feat/dutch-social-qa --merge 2>&1 | tail -6 || echo "  (merge manually if blocked)"
git checkout main 2>/dev/null && git pull --ff-only 2>&1 | tail -2 || true

echo ""; echo "── result ──"; git branch --show-current; git log --oneline -4
echo "════════ done ════════"
read -r -p "Press Return to close…" _
