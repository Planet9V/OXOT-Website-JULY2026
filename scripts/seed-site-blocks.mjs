#!/usr/bin/env node
// Seed site_blocks with the homepage content from the shipped dictionaries.
// ON CONFLICT DO NOTHING — never clobbers content the admin has already edited.
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const load = (l) =>
  JSON.parse(readFileSync(join(root, "src", "i18n", "dictionaries", `${l}.json`), "utf8"));

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  for (const locale of ["en", "nl"]) {
    const home = load(locale).home; // { hero, services }
    const res = await client.query(
      `INSERT INTO site_blocks (key, locale, data)
       VALUES ('home', $1, $2)
       ON CONFLICT (key, locale) DO NOTHING`,
      [locale, JSON.stringify({ hero: home.hero, services: home.services })]
    );
    console.log(`site_blocks home/${locale}: ${res.rowCount ? "seeded" : "already present (kept)"}`);
  }
  console.log("Done.");
} finally {
  await client.end();
}
