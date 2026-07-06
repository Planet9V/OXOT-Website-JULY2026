// Minimal YAML-frontmatter parser for CMS markdown files. Splits on the first
// `:` of each line so values may contain colons (e.g. URLs, titles). Extracted
// from seed-pages.mjs so it can be unit-tested in isolation.

export function parseFrontmatter(md) {
  const meta = {};
  let body = md;
  const m = /^---\n([\s\S]*?)\n---\n?/.exec(md);
  if (m) {
    body = md.slice(m[0].length);
    for (const line of m[1].split("\n")) {
      const idx = line.indexOf(":");
      if (idx === -1) continue;
      const k = line.slice(0, idx).trim();
      let v = line.slice(idx + 1).trim();
      if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'"))) {
        v = v.slice(1, -1);
      }
      meta[k] = v;
    }
  }
  return { meta, body: body.trim() };
}
