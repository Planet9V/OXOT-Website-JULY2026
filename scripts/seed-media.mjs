// Seed the CRA hero-carousel PDFs (paginated EN + NL) from content-source into
// the media table. Idempotent by stable filename. Run inside the app container:
//   node scripts/seed-media.mjs
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

// stable media filename  ->  source file in content-source/
const FILES = [
  { name: "cra-hero-en.pdf", src: "content-source/OXOT CRA Hero Carousel-English-paginatedL.pdf" },
  { name: "cra-hero-nl.pdf", src: "content-source/OXOT CRA Hero Carousel-N-paginatedL.pdf" }
];

async function main() {
  for (const { name, src } of FILES) {
    const path = join(root, src);
    if (!existsSync(path)) { console.log(`SKIP (missing): ${src}`); continue; }
    const buf = readFileSync(path);
    await pool.query(`DELETE FROM media WHERE filename = $1`, [name]);
    const { rows } = await pool.query(
      `INSERT INTO media (filename, mime, bytes, size) VALUES ($1,$2,$3,$4) RETURNING id`,
      [name, "application/pdf", buf, buf.length]
    );
    console.log(`seeded ${name} -> media id ${rows[0].id} (${buf.length} bytes)`);
  }
  await pool.end();
  console.log("media seed done.");
}
main().catch((e) => { console.error(e); process.exit(1); });
