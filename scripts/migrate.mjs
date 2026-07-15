#!/usr/bin/env node
// Apply SQL migrations in db/migrations in order. Uses DATABASE_URL from env.
// Run-once ledger: each migration filename is recorded in schema_migrations
// after it applies, so re-deploys skip already-applied migrations instead of
// re-running seed migrations that would otherwise clobber live admin edits.
import { readdirSync, readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const dir = join(root, "db", "migrations");
const files = readdirSync(dir).filter((f) => f.endsWith(".sql")).sort();

// Migrations at or below this numeric prefix are the baseline that already
// ran on any existing prod DB before the ledger existed.
const BASELINE_MAX = 35;

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  const { rows: existing } = await client.query(
    `SELECT to_regclass('public.schema_migrations') IS NOT NULL AS exists`
  );
  const ledgerExisted = existing[0].exists;

  await client.query(
    `CREATE TABLE IF NOT EXISTS schema_migrations (
       filename TEXT PRIMARY KEY,
       applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
     )`
  );

  if (!ledgerExisted) {
    const { rows: pagesRows } = await client.query(
      `SELECT to_regclass('public.pages') IS NOT NULL AS exists`
    );
    const hasPages = pagesRows[0].exists;

    if (hasPages) {
      // Existing prod DB: backfill the ledger with everything already applied
      // (numeric prefix <= BASELINE_MAX) without re-running it.
      const baseline = files.filter((f) => {
        const m = f.match(/^(\d+)_/);
        return m && Number(m[1]) <= BASELINE_MAX;
      });
      for (const f of baseline) {
        await client.query(
          `INSERT INTO schema_migrations (filename) VALUES ($1) ON CONFLICT DO NOTHING`,
          [f]
        );
        console.log(`baseline ${f}`);
      }
    }
    // Fresh DB (no pages table): no backfill, bootstrap runs everything below.
  }

  const { rows: appliedRows } = await client.query(`SELECT filename FROM schema_migrations`);
  const applied = new Set(appliedRows.map((r) => r.filename));

  for (const f of files) {
    if (applied.has(f)) {
      console.log(`skipped ${f} (already applied)`);
      continue;
    }
    console.log(`applying ${f}`);
    const dim = Number(process.env.EMBED_DIM ?? 1536);
    const sql = readFileSync(join(dir, f), "utf8").replaceAll("__EMBED_DIM__", String(dim));
    await client.query(sql);
    await client.query(
      `INSERT INTO schema_migrations (filename) VALUES ($1) ON CONFLICT DO NOTHING`,
      [f]
    );
  }
  console.log(`Done: ${files.length} migration(s) checked.`);
} finally {
  await client.end();
}
