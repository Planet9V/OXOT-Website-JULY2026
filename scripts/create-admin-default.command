#!/usr/bin/env bash
# Create a DEFAULT admin login for the local dev/test system. Double-click to run.
# DEV ONLY — change this password before any non-local/production use.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/create-admin-default.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1

ADMIN_EMAIL="admin@oxot.local"
ADMIN_PW="OxotDev!2026"

echo "════════ create default admin  $(date '+%H:%M:%S') ════════"
echo "  email:    $ADMIN_EMAIL"
echo "  password: $ADMIN_PW   (DEV ONLY — change before production)"
echo ""

# App must be up (deploy.command / bring-up.command). Create/upsert the admin.
docker compose exec -T app node scripts/create-admin.mjs "$ADMIN_EMAIL" "$ADMIN_PW" 2>&1 | tail -5 \
  || { echo "✖ failed — is the stack up?  Run scripts/deploy.command first."; read -r -p "Return to close…" _; exit 1; }

echo ""
echo "✅ Log in at  http://localhost:3000/admin/login"
echo "   $ADMIN_EMAIL / $ADMIN_PW"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
