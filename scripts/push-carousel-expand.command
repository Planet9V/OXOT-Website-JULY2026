#!/usr/bin/env bash
# One-off: push the already-committed carousel expand-to-fullscreen feature.
# No DB work — pure frontend change hot-reloads in the running container.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/push-carousel-expand.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ push carousel expand  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock .git/refs/heads/*.lock 2>/dev/null || true
git status --short
echo "▶ pushing $(git rev-parse --abbrev-ref HEAD) …"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -4 || echo "  ⚠ push failed"
echo "▶ HEAD is now:"; git log --oneline -1
echo "════════ done ════════"
read -r -p "Press Return to close…" _
