import { NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { ingestPage } from "@/lib/ingest";
import { isLocale } from "@/i18n/config";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Strip fenced code blocks (```svg / ```carousel / ```html / code) so they don't
// pollute embeddings — mirrors scripts/ingest.mjs behaviour for CMS page bodies.
function stripFences(md: string): string {
  return md.replace(/```[\s\S]*?```/g, "").replace(/\n{3,}/g, "\n\n");
}

/**
 * Rebuild the assistant's knowledge: re-embed every published CMS page into
 * content_chunks using the existing ingest logic (src/lib/ingest.ts). Requires
 * Ollama reachable for embeddings; if the embed call fails the whole request
 * returns { ok:false, error } (HTTP 200) so the admin UI can surface it cleanly
 * rather than crash. Guarded by the admin session.
 */
export async function POST() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  try {
    const { rows } = await pool.query<{ slug: string; locale: string; body: string | null }>(
      `SELECT slug, locale, body FROM pages WHERE published = true ORDER BY slug, locale`
    );

    let pages = 0;
    let chunks = 0;
    for (const row of rows) {
      if (!isLocale(row.locale)) continue;
      const body = stripFences(row.body ?? "");
      const n = await ingestPage(row.slug, row.locale, body, `pages/${row.locale}/${row.slug}`);
      pages += 1;
      chunks += n;
    }

    return NextResponse.json({ ok: true, pages, chunks });
  } catch (e) {
    return NextResponse.json(
      { ok: false, error: e instanceof Error ? e.message : "reindex failed" },
      { status: 200 }
    );
  }
}
