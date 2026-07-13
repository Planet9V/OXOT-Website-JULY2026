#!/usr/bin/env sh
# Turnkey database bootstrap for `docker compose up`. Idempotent and safe to run
# on EVERY boot: waits for Postgres, applies migrations, seeds content + a default
# admin. A fresh clone therefore needs zero manual DB steps.
#
# Every step below is idempotent:
#   - migrations use IF NOT EXISTS / insert-if-absent / UPDATE (re-runnable)
#   - seed:pages upserts, seed:site is INSERT ... ON CONFLICT DO NOTHING
#   - seed:admin only creates a default admin when none exists

echo "[init] waiting for database at \$DATABASE_URL ..."
i=0
until node -e "import('pg').then(({default:pg})=>{const c=new pg.Client({connectionString:process.env.DATABASE_URL});return c.connect().then(()=>c.end());}).then(()=>process.exit(0)).catch(()=>process.exit(1));" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 60 ]; then
    echo "[init] database not reachable after 60 attempts — aborting bootstrap"
    exit 1
  fi
  sleep 2
done

echo "[init] database is up — applying migrations and seeds"
npm run db:migrate
npm run seed:pages
npm run seed:site
npm run seed:admin
echo "[init] bootstrap complete"
