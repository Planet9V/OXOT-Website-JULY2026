#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# OXOT — one-time Railway provisioning.
#
# Sets ALL required Railway variables for the app service and provisions a linked
# Postgres, so a Railway deploy works without touching the dashboard. Idempotent:
# re-running only updates values; it won't add a second database.
#
# What it configures on the app service:
#   DATABASE_URL      -> reference to the Postgres plugin  ${{Postgres.DATABASE_URL}}
#   AUTH_SECRET       -> freshly generated 32-byte secret (session signing)
#   SETTINGS_SECRET   -> freshly generated 32-byte secret (encrypts stored keys)
#   ADMIN_EMAIL       -> admin@oxot.local   (override: ADMIN_EMAIL=… before running)
#   ADMIN_PASSWORD    -> changeme           (override: ADMIN_PASSWORD=… before running)
#   EMBED_DIM         -> 2560               (qwen3-embedding:4b)
#   DEFAULT_LOCALE    -> en
#   SUPPORTED_LOCALES -> nl,en
#   NODE_ENV          -> production
#
# The default admin is auto-created on deploy by the railway.json preDeployCommand
# (npm run seed:admin) — no first-login change required (private/dev deployment).
#
# PREREQUISITES (you do these — I never enter your credentials):
#   1. npm i -g @railway/cli
#   2. railway login
#   3. railway link            # pick the project + environment for this app
#
# USAGE:
#   ./scripts/railway-provision.command <APP_SERVICE_NAME>
#   e.g.  ./scripts/railway-provision.command web
# The app service name is the one shown in the Railway dashboard for this site.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"

APP_SERVICE="${1:-${RAILWAY_APP_SERVICE:-}}"
PG_SERVICE="${RAILWAY_PG_SERVICE:-Postgres}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@oxot.local}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-changeme}"

log() { printf '\n\033[1;36m▶ %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

# ── preconditions ────────────────────────────────────────────────────────────
command -v railway >/dev/null 2>&1 || die "Railway CLI not found. Install:  npm i -g @railway/cli"
railway whoami >/dev/null 2>&1     || die "Not logged in. Run:  railway login"
[ -n "$APP_SERVICE" ] || die "Pass the app service name, e.g.  ./scripts/railway-provision.command web"

gen_secret() { openssl rand -hex 32 2>/dev/null || node -e 'console.log(require("crypto").randomBytes(32).toString("hex"))'; }
AUTH_SECRET="$(gen_secret)"
SETTINGS_SECRET="$(gen_secret)"

# ── 1) Postgres (skip if it already exists) ──────────────────────────────────
if railway variable list -s "$PG_SERVICE" >/dev/null 2>&1; then
  log "Postgres service '$PG_SERVICE' already exists — leaving it in place."
else
  log "Adding Postgres database…"
  railway add --database postgres
fi

# ── 2) App variables (single set = single redeploy) ──────────────────────────
log "Setting variables on app service '$APP_SERVICE'…"
railway variable set \
  "DATABASE_URL=\${{${PG_SERVICE}.DATABASE_URL}}" \
  "AUTH_SECRET=${AUTH_SECRET}" \
  "SETTINGS_SECRET=${SETTINGS_SECRET}" \
  "ADMIN_EMAIL=${ADMIN_EMAIL}" \
  "ADMIN_PASSWORD=${ADMIN_PASSWORD}" \
  "EMBED_DIM=2560" \
  "DEFAULT_LOCALE=en" \
  "SUPPORTED_LOCALES=nl,en" \
  "NODE_ENV=production" \
  -s "$APP_SERVICE"

log "Done. Railway will redeploy the app; preDeploy runs migrations + seeds + the default admin."
echo    "   Admin login after deploy:  ${ADMIN_EMAIL} / ${ADMIN_PASSWORD}   (at /admin/login)"
echo    "   NOTE: Railway's Postgres must have the pgvector extension. If migration 001"
echo    "         fails on 'CREATE EXTENSION vector', deploy the Postgres from Railway's"
echo    "         pgvector template instead of the plain Postgres, then re-run the deploy."
# Keep the Terminal window open when double-clicked from Finder.
if [ -t 1 ]; then read -r -p "Press Return to close…" _; fi
