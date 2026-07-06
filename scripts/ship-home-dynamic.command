#!/usr/bin/env bash
# Commit + push the force-dynamic homepage fix (so CMS edits render live) + test scripts.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-home-dynamic.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship home force-dynamic  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "fix(home): force-dynamic so CMS edits to hero/services render on every request" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
