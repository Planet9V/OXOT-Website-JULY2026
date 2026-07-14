#!/usr/bin/env node
// Apply SQL migrations in db/migrations in order. Uses DATABASE_URL from env.
import { readdirSync, readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import pg from "pg";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const dir = join(root, "db", "migrations");
const files = readdirSync(dir).filter((f) => f.endsWith(".sql")).sort();

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  for (const f of files) {
    console.log(`applying ${f}`);
    const dim = Number(process.env.EMBED_DIM ?? 1536);
    const sql = readFileSync(join(dir, f), "utf8").replaceAll("__EMBED_DIM__", String(dim));
    await client.query(sql);
  }
  console.log(`Done: ${files.length} migration(s).`);
} finally {
  await client.end();
}
