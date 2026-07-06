#!/usr/bin/env bash
# Commit Phase 4: campaign plan, LinkedIn/X assets, carousel scripts, and the carousel builder tool.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/pr-marketing.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ marketing PR  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git checkout feat/oxot-content 2>/dev/null || git checkout -B feat/oxot-content
git add marketing public/tools .gitignore
git commit -m "feat: Phase 4 marketing — GTM campaign plan + 12-week calendar, LinkedIn posts + X threads (8 topics), paste-ready carousel scripts, and a brand-styled LinkedIn PDF carousel builder tool" || echo "nothing to commit"
git push origin feat/oxot-content 2>&1 | tail -4 || { echo "push failed"; read -r -p _ _; exit 1; }
echo ""; echo "PR #2 → https://github.com/Planet9V/OXOT-Website-JULY2026/pull/2"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
