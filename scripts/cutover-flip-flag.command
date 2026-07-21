#!/usr/bin/env bash
# Gate-4 Stage 2 — flip BLOCKS_ROUTING so the LIVE Home/CDT/Conformity render from
# page_blocks (the Page Builder). Byte-identical output (parity-proven). Env-only:
# Railway restarts the service; no deploy. INSTANT ROLLBACK: re-run with the value
# emptied (see the ROLLBACK line at the bottom) or `railway variables --set "BLOCKS_ROUTING="`.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/cutover-flip-flag.log"; : > "$LOG"; exec > >(tee -a "$LOG") 2>&1
echo "cutover flip-flag $(date '+%H:%M:%S')"
command -v railway >/dev/null 2>&1 || { echo "railway CLI not found"; read -r -p "Return…" _; exit 1; }

echo "--- target service/env ---"
railway status 2>&1 | head -12

echo "--- setting BLOCKS_ROUTING (triggers a restart) ---"
railway variables --set "BLOCKS_ROUTING=home,cyber-digital-twin,conformity"

echo "--- confirm ---"
railway variables 2>&1 | grep -i "BLOCKS_ROUTING" || echo "(grep found nothing — check the table above)"
echo
echo "Flag set. The live pages now render from page_blocks."
echo "ROLLBACK (instant): railway variables --set \"BLOCKS_ROUTING=\""
read -r -p "Return…" _
