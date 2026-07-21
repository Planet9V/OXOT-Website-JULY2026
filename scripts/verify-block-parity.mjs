#!/usr/bin/env node
// Phase 1 parity harness (docs/BLOCK-CMS-PLAN.md §E) — the zero-loss PROOF.
//
// For each block page (cyber-digital-twin, conformity) and locale (en, nl):
//   1. load the source content object (site_blocks row if a DB is reachable,
//      else the shipped JSON default — mirroring getCdt/getConformityHome),
//   2. decompose it into ordered blocks, then reconstruct the object from those
//      blocks, and assert reconstruct === source (deep equal). This proves the
//      block decomposition is lossless: nothing added, nothing dropped, nothing
//      reordered. Because render + grounding are pure functions of this object,
//      identity here guarantees identical render + identical corpus.
//   3. if page_blocks already has rows (post-backfill), also reconstruct from
//      the DB rows and assert identity — proving the DB round-trip is lossless.
//
// Runs WITHOUT a DB (proves the logic on default content, which is content-
// agnostic) and, via `railway run`, WITH the prod DB (proves it on the actual
// live content). Exit 0 only if every check passes.
import { loadSource, decompose, reconstruct, PAGE_MANIFEST } from "./lib/block-manifest.mjs";

const LOCALES = ["en", "nl"];
const SLUGS = Object.keys(PAGE_MANIFEST);

// Stable canonical JSON (sorted keys) for order-independent deep comparison.
function canon(v) {
  if (Array.isArray(v)) return `[${v.map(canon).join(",")}]`;
  if (v && typeof v === "object") {
    return `{${Object.keys(v).sort().map((k) => JSON.stringify(k) + ":" + canon(v[k])).join(",")}}`;
  }
  return JSON.stringify(v);
}

// First differing path between two objects, or null if identical.
function firstDiff(a, b, path = "") {
  if (canon(a) === canon(b)) return null;
  const ta = a && typeof a === "object", tb = b && typeof b === "object";
  if (!ta || !tb) return `${path || "(root)"}: ${JSON.stringify(a)} !== ${JSON.stringify(b)}`;
  const keys = new Set([...Object.keys(a), ...Object.keys(b)]);
  for (const k of keys) {
    const d = firstDiff(a[k], b[k], path ? `${path}.${k}` : k);
    if (d) return d;
  }
  return `${path || "(root)"}: differs`;
}

async function maybeDb() {
  const base = process.env.DATABASE_URL;
  if (!base) return null;
  const { default: pg } = await import("pg");
  const u = new URL(base);
  if (process.env.PROXY_HOST) u.hostname = process.env.PROXY_HOST;
  if (process.env.PROXY_PORT) u.port = process.env.PROXY_PORT;
  for (const ssl of [{ rejectUnauthorized: false }, false]) {
    const c = new pg.Client({ connectionString: u.toString(), ssl, connectionTimeoutMillis: 15000 });
    c.on("error", () => {});
    try { await c.connect(); return c; } catch { try { await c.end(); } catch {} }
  }
  return null;
}

const db = await maybeDb();
console.log(`=== Block parity harness ===`);
console.log(`source: ${db ? "LIVE DB (site_blocks) + JSON fallback" : "JSON defaults only (no DB)"}\n`);

let failures = 0;
for (const slug of SLUGS) {
  for (const locale of LOCALES) {
    const { source, data } = await loadSource(slug, locale, db);
    // (1)+(2) in-memory decompose -> reconstruct -> compare
    const blocks = decompose(slug, data);
    const rebuilt = reconstruct(slug, blocks);
    const diff = firstDiff(data, rebuilt);
    const ok = diff === null;
    if (!ok) failures++;
    console.log(
      `${ok ? "PASS" : "FAIL"}  ${slug}/${locale}  (${source}, ${blocks.length} blocks)` +
        (ok ? "" : `\n      first diff -> ${diff}`)
    );

    // (3) DB round-trip if page_blocks already backfilled
    if (db) {
      const { rows } = await db.query(
        `SELECT position, type, config FROM page_blocks WHERE slug=$1 AND locale=$2 ORDER BY position`,
        [slug, locale]
      );
      if (rows.length) {
        const fromDb = reconstruct(slug, rows.map((r) => ({ type: r.type, config: r.config })));
        const d2 = firstDiff(data, fromDb);
        if (d2) { failures++; console.log(`FAIL  ${slug}/${locale}  DB round-trip\n      first diff -> ${d2}`); }
        else console.log(`PASS  ${slug}/${locale}  DB round-trip (${rows.length} rows)`);
      }
    }
  }
}

if (db) await db.end();
console.log(`\n${failures === 0 ? "ALL PARITY CHECKS PASS ✓ — decomposition is lossless." : `${failures} PARITY CHECK(S) FAILED ✗`}`);
process.exit(failures === 0 ? 0 : 1);
