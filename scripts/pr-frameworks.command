#!/usr/bin/env bash
# Commit the expanded framework content (en+nl) + renderer + seed pipeline to the content PR branch.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/pr-frameworks.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ frameworks PR  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git checkout feat/oxot-content 2>/dev/null || git checkout -B feat/oxot-content
git add content src scripts/seed-pages.mjs package.json docker-compose.override.yml
git commit -m "feat: expand 6 EU framework pages (en+nl) — tables, SVG diagrams, carousels, callouts, cited; add markdown renderer, carousel, file->CMS seed + auto-seed watcher" || echo "nothing to commit"
git push origin feat/oxot-content 2>&1 | tail -5 || { echo "✖ push failed"; read -r -p _ _; exit 1; }
echo ""
echo "PR #2 updated → https://github.com/Planet9V/OXOT-Website-JULY2026/pull/2"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
