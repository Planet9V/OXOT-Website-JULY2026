#!/usr/bin/env node
// Ingest content/{locale}/*.md into content_chunks (chunk + embed via Ollama).
// Run inside the container after `docker compose up` and after pulling the embed model.
import { readdirSync, readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join, basename } from "node:path";
import pg from "pg";
import { parseFrontmatter } from "./lib/frontmatter.mjs";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const EMBED_MODEL = process.env.OLLAMA_EMBED_MODEL ?? "qwen3-embedding:4b";
const EMBED_DIM = Number(process.env.EMBED_DIM ?? 2560);
const LOCALES = ["nl", "en"];

function chunk(text, max = 800) {
  const paras = text.split(/\n\s*\n/).map((p) => p.trim()).filter(Boolean);
  const out = [];
  let cur = "";
  for (const p of paras) {
    if ((cur + "\n\n" + p).length > max && cur) { out.push(cur); cur = p; }
    else cur = cur ? `${cur}\n\n${p}` : p;
  }
  if (cur) out.push(cur);
  return out;
}

// Strip fenced code blocks (```svg / ```carousel / ```html / code) — they're not
// useful retrieval text and pollute embeddings. Keeps prose, headings and tables.
function stripFences(md) {
  return md.replace(/```[\s\S]*?```/g, "").replace(/\n{3,}/g, "\n\n");
}

async function embed(text) {
  const res = await fetch(`${OLLAMA_HOST}/api/embeddings`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ model: EMBED_MODEL, prompt: text })
  });
  if (!res.ok) throw new Error(`embed failed ${res.status}`);
  const j = await res.json();
  if (j.embedding?.length !== EMBED_DIM)
    throw new Error(`expected ${EMBED_DIM}-dim, got ${j.embedding?.length}`);
  return j.embedding;
}

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
let total = 0;
try {
  for (const locale of LOCALES) {
    const dir = join(root, "content", locale);
    if (!existsSync(dir)) continue;
    for (const file of readdirSync(dir).filter((f) => f.endsWith(".md"))) {
      const pageId = basename(file, ".md");
      const text = readFileSync(join(dir, file), "utf8");
      const parts = chunk(text);
      await client.query(
        `DELETE FROM content_chunks WHERE page_id=$1 AND locale=$2`,
        [pageId, locale]
      );
      for (const part of parts) {
        const v = await embed(part);
        await client.query(
          `INSERT INTO content_chunks (page_id, locale, text, embedding, source_ref)
           VALUES ($1,$2,$3,$4::vector,$5)`,
          [pageId, locale, part, `[${v.join(",")}]`, `content/${locale}/${file}`]
        );
        total++;
      }
      console.log(`ingested ${locale}/${file}: ${parts.length} chunks`);
    }
  }

  // Also embed the rich CMS pages (content/pages/{locale}/*.md) so the agent can
  // ground answers in the full framework content — NIS2/CRA/IEC 62443/etc. Strip
  // YAML frontmatter and code fences first. page_id = slug so the current-page
  // boost in retrieval works for these pages too.
  for (const locale of LOCALES) {
    const dir = join(root, "content", "pages", locale);
    if (!existsSync(dir)) continue;
    for (const file of readdirSync(dir).filter((f) => f.endsWith(".md"))) {
      const pageId = basename(file, ".md");
      const { body } = parseFrontmatter(readFileSync(join(dir, file), "utf8"));
      const parts = chunk(stripFences(body));
      await client.query(
        `DELETE FROM content_chunks WHERE page_id=$1 AND locale=$2`,
        [pageId, locale]
      );
      for (const part of parts) {
        const v = await embed(part);
        await client.query(
          `INSERT INTO content_chunks (page_id, locale, text, embedding, source_ref)
           VALUES ($1,$2,$3,$4::vector,$5)`,
          [pageId, locale, part, `[${v.join(",")}]`, `content/pages/${locale}/${file}`]
        );
        total++;
      }
      console.log(`ingested pages/${locale}/${file}: ${parts.length} chunks`);
    }
  }
  console.log(`Done: ${total} chunks embedded.`);
} finally {
  await client.end();
}
