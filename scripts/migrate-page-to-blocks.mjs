#!/usr/bin/env node
// Migrate a MARKDOWN page into the block CMS, zero-loss (docs/BLOCK-CMS-PLAN.md).
//
// For each locale of each given slug, in ONE transaction:
//   1. snapshot the current `pages` row into page_versions (append-only history)
//   2. write a single `prose` block whose markdown === the page body, VERBATIM
//   3. flip pages.content_type -> 'blocks' so the [slug] route renders the block
//      (pages.body is LEFT INTACT — nothing is deleted; grounding keeps reading it
//       and it is a second safety copy on top of the version snapshot)
// Then it re-reads the block back and ASSERTS the stored markdown equals the
// original body exactly. Any mismatch aborts that page (its txn already rolled
// back leaves nothing changed).
//
// Safe by default: DRY-RUN unless --apply is passed. Usage:
//   node scripts/migrate-page-to-blocks.mjs            # dry-run privacy services
//   node scripts/migrate-page-to-blocks.mjs --apply privacy services
import pg from "pg";

const args = process.argv.slice(2);
const APPLY = args.includes("--apply");
const slugs = args.filter((a) => !a.startsWith("--"));
const SLUGS = slugs.length ? slugs : ["privacy", "services"];

const base = process.env.DATABASE_URL;
if (!base) { console.error("no DATABASE_URL — run via `railway run`"); process.exit(2); }
const u = new URL(base);
if (process.env.PROXY_HOST) u.hostname = process.env.PROXY_HOST;
if (process.env.PROXY_PORT) u.port = process.env.PROXY_PORT;

async function connect() {
  for (const ssl of [{ rejectUnauthorized: false }, false]) {
    const c = new pg.Client({ connectionString: u.toString(), ssl, connectionTimeoutMillis: 15000 });
    c.on("error", () => {});
    try { await c.connect(); return c; } catch { try { await c.end(); } catch {} }
  }
  throw new Error("could not connect");
}

const c = await connect();
const results = [];
try {
  for (const slug of SLUGS) {
    const { rows: locs } = await c.query(
      `SELECT slug, locale, title, body, published, content_type
         FROM pages WHERE slug=$1 ORDER BY locale`, [slug]
    );
    if (!locs.length) { results.push({ slug, locale: "-", status: "SKIP — no such page" }); continue; }

    for (const p of locs) {
      const locale = p.locale;
      const body = p.body ?? "";
      if (p.content_type === "blocks") { results.push({ slug, locale, status: "SKIP — already blocks" }); continue; }
      if (!body.trim()) { results.push({ slug, locale, status: "SKIP — empty body" }); continue; }

      if (!APPLY) {
        results.push({ slug, locale, status: `DRY — would snapshot + write 1 prose block (${body.length} chars) + flip content_type` });
        continue;
      }

      try {
        await c.query("BEGIN");
        // 1. snapshot current pages row (blocks NULL — markdown page has none yet)
        await c.query(
          `INSERT INTO page_versions
             (slug, locale, version_number, state, title, body,
              meta_title, meta_description, excerpt, og_image, content_type, note, blocks)
           SELECT slug, locale,
                  COALESCE((SELECT MAX(version_number) FROM page_versions v WHERE v.slug=pages.slug AND v.locale=pages.locale), 0) + 1,
                  CASE WHEN published THEN 'published' ELSE 'draft' END,
                  title, body, meta_title, meta_description, excerpt, og_image, content_type,
                  'Auto-snapshot before block migration', NULL
             FROM pages WHERE slug=$1 AND locale=$2`,
          [slug, locale]
        );
        // 2. write the single prose block (verbatim body), replacing any existing
        await c.query(`DELETE FROM page_blocks WHERE slug=$1 AND locale=$2`, [slug, locale]);
        await c.query(
          `INSERT INTO page_blocks (slug, locale, position, type, config)
           VALUES ($1, $2, 0, 'prose', $3)`,
          [slug, locale, JSON.stringify({ markdown: body })]
        );
        // 3. flip render source to blocks (body preserved)
        await c.query(`UPDATE pages SET content_type='blocks', updated_at=now() WHERE slug=$1 AND locale=$2`, [slug, locale]);

        // parity read-back BEFORE commit
        const { rows: back } = await c.query(
          `SELECT config->>'markdown' AS md FROM page_blocks WHERE slug=$1 AND locale=$2 AND position=0`,
          [slug, locale]
        );
        const stored = back[0]?.md ?? null;
        if (stored !== body) {
          await c.query("ROLLBACK");
          results.push({ slug, locale, status: `FAIL — parity mismatch (${stored?.length ?? "null"} vs ${body.length}), rolled back` });
          continue;
        }
        await c.query("COMMIT");
        results.push({ slug, locale, status: `OK — 1 prose block, ${body.length} chars verbatim, content_type=blocks` });
      } catch (e) {
        await c.query("ROLLBACK").catch(() => {});
        results.push({ slug, locale, status: `ERROR — ${String(e.message).slice(0, 120)}` });
      }
    }
  }

  console.log(`\n=== page -> blocks migration (${APPLY ? "APPLY" : "DRY-RUN"}) ===`);
  console.log(`slugs: ${SLUGS.join(", ")}\n`);
  for (const r of results) console.log(`  ${r.slug}/${r.locale}: ${r.status}`);
  const bad = results.some((r) => r.status.startsWith("FAIL") || r.status.startsWith("ERROR"));
  console.log(`\n${bad ? "SOME PAGES FAILED — see above" : "no failures"}`);
  process.exitCode = bad ? 1 : 0;
} finally {
  await c.end();
}
