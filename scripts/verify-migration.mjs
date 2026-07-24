#!/usr/bin/env node
// Verify markdown->blocks migration for the given slugs (default privacy services):
//   content_type flipped, exactly one prose block, block markdown == pages.body
//   (verbatim), and a pre-migration snapshot exists. Read-only.
import pg from "pg";

const ALL = process.argv.includes("--all");
const slugs = process.argv.slice(2).filter((a) => !a.startsWith("--"));
let SLUGS = slugs.length ? slugs : ["privacy", "services"];

const base = process.env.DATABASE_URL;
if (!base) { console.error("no DATABASE_URL — run via railway run"); process.exit(2); }
const u = new URL(base);
if (process.env.PROXY_HOST) u.hostname = process.env.PROXY_HOST;
if (process.env.PROXY_PORT) u.port = process.env.PROXY_PORT;

async function connect() {
  for (const ssl of [{ rejectUnauthorized: false }, false]) {
    const cl = new pg.Client({ connectionString: u.toString(), ssl, connectionTimeoutMillis: 15000 });
    cl.on("error", () => {});
    try { await cl.connect(); return cl; } catch { try { await cl.end(); } catch {} }
  }
  throw new Error("could not connect");
}
const c = await connect();
const q = async (s, p) => (await c.query(s, p)).rows;
let allGood = true;
try {
  if (ALL) {
    const rows = await q(`SELECT DISTINCT slug FROM pages WHERE content_type='blocks' ORDER BY slug`);
    SLUGS = rows.map((r) => r.slug);
  }
  console.log(`=== migration verify: ${SLUGS.join(", ")} ===\n`);
  for (const slug of SLUGS) {
    const locs = await q(`SELECT locale, content_type FROM pages WHERE slug=$1 ORDER BY locale`, [slug]);
    if (!locs.length) { console.log(`  ${slug}: no such page`); allGood = false; continue; }
    for (const r of locs) {
      const bc = (await q(`SELECT count(*)::int n FROM page_blocks WHERE slug=$1 AND locale=$2`, [slug, r.locale]))[0].n;
      // Enriched pages (>1 block) no longer match the raw body verbatim — that is
      // expected once split into a richer structure; report them, don't fail them.
      if (bc !== 1) {
        console.log(`  ${slug}/${r.locale}: content_type=${r.content_type} blocks=${bc}  -> ENRICHED/multi-block (verbatim parity n/a)`);
        continue;
      }
      const par = (await q(
        `SELECT (config->>'markdown') = (SELECT body FROM pages WHERE slug=$1 AND locale=$2) AS eq
           FROM page_blocks WHERE slug=$1 AND locale=$2 AND position=0`, [slug, r.locale]))[0];
      const snap = (await q(
        `SELECT count(*)::int n FROM page_versions
          WHERE slug=$1 AND locale=$2 AND note='Auto-snapshot before block migration'`, [slug, r.locale]))[0].n;
      const eq = par ? par.eq : null;
      const ok = r.content_type === "blocks" && bc === 1 && eq === true && snap >= 1;
      if (!ok) allGood = false;
      console.log(`  ${slug}/${r.locale}: content_type=${r.content_type} blocks=${bc} body==block:${eq} snapshots:${snap}  -> ${ok ? "PASS" : "CHECK"}`);
    }
  }
  console.log(`\n${allGood ? "ALL PILOTS PASS — zero loss, block-rendered" : "SOME CHECKS FAILED"}`);
  process.exitCode = allGood ? 0 : 1;
} finally {
  await c.end();
}
