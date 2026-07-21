#!/usr/bin/env node
// Phase 1 backfill (docs/BLOCK-CMS-PLAN.md §E) — populate page_blocks from the
// CURRENT CDT/Conformity content, 1:1 and idempotently. READS the same source
// getCdt()/getConformityHome() read (site_blocks row if present, else the shipped
// JSON default); WRITES ordered page_blocks rows in manifest order.
//
// Idempotent: DELETE the page's blocks for that locale, then re-INSERT. Safe to
// re-run. The written rows are INERT until a route reads them (Phase 2 flag), so
// this changes no rendered page.
//
// Requires DATABASE_URL (run via `railway run`, with PROXY_HOST/PROXY_PORT to
// reach the public proxy). Refuses to run without a DB.
import { loadSource, decompose, PAGE_MANIFEST } from "./lib/block-manifest.mjs";

const LOCALES = ["en", "nl"];
const SLUGS = Object.keys(PAGE_MANIFEST);

const base = process.env.DATABASE_URL;
if (!base) {
  console.error("backfill: no DATABASE_URL — run via `railway run` (writes to the DB).");
  process.exit(2);
}
const { default: pg } = await import("pg");
const u = new URL(base);
if (process.env.PROXY_HOST) u.hostname = process.env.PROXY_HOST;
if (process.env.PROXY_PORT) u.port = process.env.PROXY_PORT;

async function connect() {
  for (const ssl of [{ rejectUnauthorized: false }, false]) {
    const c = new pg.Client({ connectionString: u.toString(), ssl, connectionTimeoutMillis: 15000 });
    c.on("error", () => {});
    try { await c.connect(); return c; } catch { try { await c.end(); } catch {} }
  }
  throw new Error("could not connect to the database");
}

const db = await connect();
console.log("=== Backfill page_blocks ===\n");
let total = 0;
try {
  for (const slug of SLUGS) {
    for (const locale of LOCALES) {
      const { source, data } = await loadSource(slug, locale, db);
      const blocks = decompose(slug, data);
      await db.query("BEGIN");
      try {
        await db.query(`DELETE FROM page_blocks WHERE slug=$1 AND locale=$2`, [slug, locale]);
        for (const b of blocks) {
          await db.query(
            `INSERT INTO page_blocks (slug, locale, position, type, config)
             VALUES ($1,$2,$3,$4,$5)`,
            [slug, locale, b.position, b.type, JSON.stringify(b.config)]
          );
        }
        await db.query("COMMIT");
      } catch (e) {
        await db.query("ROLLBACK");
        throw e;
      }
      total += blocks.length;
      console.log(`  ${slug}/${locale}: ${blocks.length} blocks written (from ${source})`);
    }
  }
  console.log(`\nDone — ${total} block rows written. Inert until a route reads them.`);
} finally {
  await db.end();
}
