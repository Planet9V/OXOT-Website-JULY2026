#!/usr/bin/env bash
# Commit the SSL-fallback fix to verify-migration.mjs (the proxy doesn't support
# SSL; migrate + verify must both try SSL then fall back, like verify-cutover).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
exec > >(tee -a "$(pwd)/ship-verifyfix.log") 2>&1
echo "ship-verifyfix $(date '+%H:%M:%S')"
rm -f .git/index.lock 2>/dev/null || true
git add scripts/verify-migration.mjs scripts/ship-verifyfix.command
git diff --cached --quiet && echo "nothing to commit" || git commit -m "verify-migration: SSL-fallback connect (proxy has no SSL), matches migrate script"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "push failed"
git log --oneline -1
read -r -p "Return…" _
