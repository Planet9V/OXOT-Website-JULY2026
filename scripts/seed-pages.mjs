#!/usr/bin/env node
// Import CMS pages from markdown files with frontmatter into the pages table.
// content/pages/<locale>/<slug>.md  →  pages(slug, locale, ...). Idempotent upsert.
// Frontmatter keys: title, meta_title, meta_description, excerpt, og_image, content_type, published.
import { readdirSync, readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";
import { parseFrontmatter as parse } from "./lib/frontmatter.mjs";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const base = join(root, "content", "pages");
const locales = ["en", "nl"];

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
let n = 0;
try {
  for (const locale of locales) {
    const dir = join(base, locale);
    if (!existsSync(dir)) continue;
    for (const f of readdirSync(dir).filter((x) => x.endsWith(".md"))) {
      const slug = f.replace(/\.md$/, "");
      const { meta, body } = parse(readFileSync(join(dir, f), "utf8"));
      const title = meta.title || slug;
      const ct = meta.content_type === "article" ? "article" : "page";
      const published = meta.published !== "false";
      await client.query(
        `INSERT INTO pages
           (slug, locale, title, body, published,
            meta_title, meta_description, excerpt, og_image, content_type,
            published_at, updated_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,
            CASE WHEN $5 THEN now() ELSE NULL END, now())
         ON CONFLICT (slug, locale) DO UPDATE SET
           title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
           meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
           excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
           published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()`,
        [slug, locale, title, body, published,
         meta.meta_title || null, meta.meta_description || null, meta.excerpt || null,
         meta.og_image || null, ct]
      );
      n++;
      console.log(`seeded ${locale}/${slug} (${body.length} chars)`);
    }
  }
  console.log(`Done: ${n} page(s) imported.`);
} finally {
  await client.end();
}
