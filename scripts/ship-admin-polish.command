#!/usr/bin/env bash
# Commit + push the admin polish (login placeholder, load-for-edit, memory).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-admin-polish.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship admin polish  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "polish(admin): load-for-edit (GET pages?slug&locale wired to Pencil), login placeholder, design-critique fixes + memory" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
