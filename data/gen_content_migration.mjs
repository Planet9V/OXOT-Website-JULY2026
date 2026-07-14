import { readFileSync } from "node:fs";
import { parseFrontmatter as parse } from "../scripts/lib/frontmatter.mjs";

const pages = ["frameworks","cra","ai-act","nis2","machine-act","iec-62443","ts-50701"];
const locales = ["en","nl"];
const TAG = "MDBODY";                 // dollar-quote tag: $MDBODY$ ... $MDBODY$
let out = `-- 028_seed_full_framework_content.sql
-- Seed the full, rich framework/regulation page content (EN+NL) from
-- content/pages/*.md into the pages table. seed:pages does not run on Railway,
-- so the DB was left with thin early-migration stubs while the rich .md files
-- (nis2 50KB, ai-act 60KB, machine-act 44KB, etc.) never reached production.
-- Guard: only overwrite when the stored body is SHORTER than the rich one, so
-- this fixes the thin stubs once and then leaves future admin edits alone.
`;
let count = 0;
for (const slug of pages) {
  for (const loc of locales) {
    let raw;
    try { raw = readFileSync(`content/pages/${loc}/${slug}.md`, "utf8"); }
    catch { console.error("MISSING", loc, slug); continue; }
    const { meta, body } = parse(raw);
    if (body.includes(`$${TAG}$`)) { console.error("TAG COLLISION in", loc, slug); process.exit(1); }
    const q = (s) => s == null ? "NULL" : `$${TAG}$${s}$${TAG}$`;
    const title = meta.title || slug;
    const ct = meta.content_type === "article" ? "article" : "page";
    const published = meta.published !== "false";
    out += `\nINSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES (${q(slug)}, ${q(loc)}, ${q(title)}, ${q(body)}, ${published}, ${q(meta.meta_title||null)}, ${q(meta.meta_description||null)}, ${q(meta.excerpt||null)}, ${meta.og_image?q(meta.og_image):"NULL"}, ${q(ct)}, ${published?"now()":"NULL"}, now())
ON CONFLICT (slug, locale) DO UPDATE SET
  title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published,
  meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description,
  excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type,
  published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now()
WHERE length(pages.body) < length(EXCLUDED.body);\n`;
    count++;
  }
}
import { writeFileSync } from "node:fs";
writeFileSync("db/migrations/028_seed_full_framework_content.sql", out);
console.log("wrote 028, pages:", count, "bytes:", out.length);
