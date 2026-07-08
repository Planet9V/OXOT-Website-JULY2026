// Seed the CRA hero-carousel PDFs (paginated EN + NL) from content-source into
// the media table. Idempotent by stable filename. Run inside the app container:
//   node scripts/seed-media.mjs
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

// stable media filename -> candidate source files (first existing wins). Prefer the
// normalized (-norm) copy — content streams rewritten, rotation forced to 0 — to
// avoid a renderer-specific page flip; fall back to the original.
const FILES = [
  { name: "cra-hero-en.pdf", src: ["content-source/OXOT CRA Hero Carousel-English-paginatedL-norm.pdf", "content-source/OXOT CRA Hero Carousel-English-paginatedL.pdf"] },
  { name: "cra-hero-nl.pdf", src: ["content-source/OXOT CRA Hero Carousel-N-paginatedL-norm.pdf", "content-source/OXOT CRA Hero Carousel-N-paginatedL.pdf"] }
];

async function main() {
  for (const { name, src } of FILES) {
    const candidates = Array.isArray(src) ? src : [src];
    const rel = candidates.find((c) => existsSync(join(root, c)));
    if (!rel) { console.log(`SKIP (missing): ${candidates.join(" | ")}`); continue; }
    const path = join(root, rel);
    const buf = readFileSync(path);
    // Update-in-place to keep the id stable across re-runs (home content
    // references the id, so a fresh id on every run would break the hero).
    const existing = await pool.query(`SELECT id FROM media WHERE filename = $1 LIMIT 1`, [name]);
    let id;
    if (existing.rows.length) {
      id = existing.rows[0].id;
      await pool.query(`UPDATE media SET mime=$1, bytes=$2, size=$3 WHERE id=$4`, ["application/pdf", buf, buf.length, id]);
    } else {
      const { rows } = await pool.query(
        `INSERT INTO media (filename, mime, bytes, size) VALUES ($1,$2,$3,$4) RETURNING id`,
        [name, "application/pdf", buf, buf.length]
      );
      id = rows[0].id;
    }
    console.log(`seeded ${name} -> media id ${id} (${buf.length} bytes)`);
  }
  await pool.end();
  console.log("media seed done.");
}
main().catch((e) => { console.error(e); process.exit(1); });
