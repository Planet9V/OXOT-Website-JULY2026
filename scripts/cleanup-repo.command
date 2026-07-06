#!/usr/bin/env bash
# Remove stray uploaded archives that got committed to the public repo.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/cleanup-repo.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ repo cleanup  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true

echo "▶ removing stray archives from git + working tree"
git rm --ignore-unmatch "Services website interface feedback.zip" "new_style" 2>&1 | tail -5

echo "▶ gitignore them so they don't return"
{
  grep -q '^/new_style$' .gitignore 2>/dev/null || echo '/new_style'
  grep -q 'Services website interface feedback.zip' .gitignore 2>/dev/null || echo '/Services website interface feedback.zip'
} >> .gitignore
git add .gitignore

git commit -m "chore: remove stray uploaded archives from repo (Services website interface feedback.zip, new_style)" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"

echo "▶ remaining stray check:"
git ls-files | grep -iE 'feedback|new_style|\.zip$' | sed 's/^/   still tracked: /' || echo "   none ✓"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
