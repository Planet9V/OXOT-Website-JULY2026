#!/usr/bin/env bash
# Double-click to create + push the OXOT repo on this Mac (uses your gh auth).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/init-repo.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════════════════════════════════════════"
echo " OXOT repo init  —  $(pwd)   $(date '+%H:%M:%S')"
echo "════════════════════════════════════════════"
bash scripts/init-repo.sh
rc=$?
echo ""
echo "════════════════════════════════════════════"
echo " init-repo.sh exit code: $rc"
echo "════════════════════════════════════════════"
read -r -p "Press Return to close this window…" _
