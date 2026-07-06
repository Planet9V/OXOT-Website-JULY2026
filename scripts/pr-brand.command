#!/usr/bin/env bash
# Commit OXOT brand alignment: navy+orange theme, serif headlines, hero visual, style guide, nl frameworks hub.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/pr-brand.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ brand PR  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock .tmp_annexA_p1.png 2>/dev/null || true
git checkout feat/oxot-content 2>/dev/null || git checkout -B feat/oxot-content
git add src docs content .gitignore
git commit -m "feat: OXOT brand alignment — navy+orange theme, editorial serif headlines, orange kicker + left rule, Cyber Digital Twin hero visual (SVG), image style guide; Dutch frameworks hub" || echo "nothing to commit"
git push origin feat/oxot-content 2>&1 | tail -4 || { echo "push failed"; read -r -p _ _; exit 1; }
echo ""; echo "PR #2 → https://github.com/Planet9V/OXOT-Website-JULY2026/pull/2"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
