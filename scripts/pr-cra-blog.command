#!/usr/bin/env bash
# Commit: enriched CRA (en+nl), founder essay (en+nl), Insights nav migration, html-embed renderer, CRA assets.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/pr-cra-blog.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ CRA+blog PR  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git checkout feat/oxot-content 2>/dev/null || git checkout -B feat/oxot-content
git add content src db public .gitignore package.json docker-compose.override.yml
git commit -m "feat: CRA enriched from OXOT CRA<->62443 analysis (en+nl) + Readiness carousel, Annex A PDF & video; founder essay 'Fooled by Randomness' (en+nl); Insights nav (mig 005); markdown html-embed support" || echo "nothing to commit"
git push origin feat/oxot-content 2>&1 | tail -4 || { echo "push failed"; read -r -p _ _; exit 1; }
echo ""; echo "PR #2 → https://github.com/Planet9V/OXOT-Website-JULY2026/pull/2"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
