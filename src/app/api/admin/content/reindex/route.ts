import { NextResponse } from "next/server";
import { pool } from "@/lib/db";
import { getAdminSession } from "@/lib/auth";
import { ingestPage, extractProse } from "@/lib/ingest";
import { isLocale, locales, type Locale } from "@/i18n/config";
import { CRA_HOME_KEY } from "@/lib/cra-home";
import { CDT_HOME_KEY } from "@/lib/cdt";
import { CONFORMITY_HOME_KEY } from "@/lib/conformity-home";
import { getHomeContent, HOME_KEY } from "@/lib/site-content";
import { getPageBlocks } from "@/lib/blocks/page-blocks";

// After the Gate-4 cutover, Home/CDT/Conformity render from page_blocks (the
// Page Builder), so the grounding corpus for these three pages must come from
// page_blocks too — else the AI would drift on the first Page-Builder edit. This
// reads a block page's ordered configs; extractProse walks them to the same prose
// leaves as the reconstructed page object (config IS the section sub-object).
async function blockPageProse(pageSlug: string, locale: Locale): Promise<unknown> {
  const blocks = await getPageBlocks(pageSlug, locale);
  return blocks.map((b) => b.config);
}

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// Strip fenced code blocks (```svg / ```carousel / ```html / code) so they don't
// pollute embeddings — mirrors scripts/ingest.mjs behaviour for CMS page bodies.
function stripFences(md: string): string {
  return md.replace(/```[\s\S]*?```/g, "").replace(/\n{3,}/g, "\n\n");
}

// The coded flagship landing pages: their content lives in site_blocks (JSONB),
// not pages.body, so the plain `pages` query below never sees them. Each entry's
// `get` is the SAME reader the live route uses (getCraHome/getCdt/...), so the
// corpus always matches what's actually rendered — DB row if edited, shipped
// JSON default otherwise — rather than silently skipping un-edited locales.
//
// `slug` is a pseudo page_id, deliberately namespaced "site-blocks-*" and
// DISTINCT from any real `pages.slug`. Reusing a real slug (e.g. the legacy
// markdown page still live at pages.slug='cyber-digital-twin', preserved
// zero-loss by migration 040_consolidate_approach_into_cdt.sql) would be
// unsafe: ingestPage() starts with `DELETE FROM content_chunks WHERE page_id=$1
// AND locale=$2`, so ingesting the site_blocks version under the same page_id
// would wipe out the chunks just ingested from that page's row (or vice versa,
// depending on loop order) instead of adding to them. The tradeoff: these
// chunks don't receive retrieval.ts's same-page +0.05 boost (the visitor's live
// pageId, e.g. "cyber-digital-twin", won't literally match "site-blocks-cdt-home"),
// but they remain fully retrievable by cosine similarity like any other chunk.
const SITE_BLOCK_SOURCES: Array<{
  key: string;
  slug: string;
  get: (locale: Locale) => Promise<unknown>;
}> = [
  // Post-cutover: these three read page_blocks (the live source), keeping the
  // same pseudo page_id so content_chunks are updated in place (no orphans/dupes).
  { key: CRA_HOME_KEY, slug: "site-blocks-cra-home", get: (l) => blockPageProse("home", l) },
  { key: CDT_HOME_KEY, slug: "site-blocks-cdt-home", get: (l) => blockPageProse("cyber-digital-twin", l) },
  { key: CONFORMITY_HOME_KEY, slug: "site-blocks-conformity-home", get: (l) => blockPageProse("conformity", l) },
  // The Approach orphan (HOME_KEY) still reads site_blocks — out of the cutover scope.
  { key: HOME_KEY, slug: "site-blocks-home", get: getHomeContent }
];

type RebuildState = {
  running: boolean;
  startedAt: string | null;
  finishedAt: string | null;
  pagesDone: number;
  chunks: number;
  error: string | null;
};

// Module-level state: survives across requests within one server process
// (this app runs as a persistent `next start` server on Railway, not
// serverless, so background work here reliably continues after the
// triggering response is sent — see src/app/api/intake/route.ts for the same
// fire-and-forget pattern used for follow-up emails).
let rebuildRunning = false;
let rebuildState: RebuildState = {
  running: false, startedAt: null, finishedAt: null, pagesDone: 0, chunks: 0, error: null
};

// Does the actual re-embed work: every published CMS page, then every coded
// flagship landing page's site_blocks content. Errors propagate to the
// caller, which wraps this in try/catch — see POST's fire-and-forget below.
async function runRebuild(): Promise<void> {
  const { rows } = await pool.query<{ slug: string; locale: string; body: string | null }>(
    `SELECT slug, locale, body FROM pages WHERE published = true ORDER BY slug, locale`
  );

  for (const row of rows) {
    if (!isLocale(row.locale)) continue;
    const body = stripFences(row.body ?? "");
    const n = await ingestPage(row.slug, row.locale, body, `pages/${row.locale}/${row.slug}`);
    rebuildState.pagesDone += 1;
    rebuildState.chunks += n;
  }

  for (const source of SITE_BLOCK_SOURCES) {
    for (const locale of locales) {
      const data = await source.get(locale);
      const text = stripFences(extractProse(data).join("\n\n"));
      if (!text.trim()) continue;
      const n = await ingestPage(source.slug, locale, text, `site_blocks/${locale}/${source.key}`);
      rebuildState.pagesDone += 1;
      rebuildState.chunks += n;
    }
  }
}

/**
 * Rebuild the assistant's knowledge: re-embed every published CMS page plus
 * every coded flagship landing page (site_blocks) into content_chunks.
 * Through a rate-limited embedding provider, one full rebuild can take well
 * over the browser's request timeout, so this STARTS the rebuild in a
 * fire-and-forget background task and returns immediately — poll GET on this
 * route for progress. Guarded by the admin session and a single in-process
 * concurrency lock.
 */
export async function POST() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  if (rebuildRunning) {
    return NextResponse.json({ ok: true, started: false, alreadyRunning: true });
  }

  rebuildRunning = true;
  rebuildState = {
    running: true, startedAt: new Date().toISOString(), finishedAt: null,
    pagesDone: 0, chunks: 0, error: null
  };

  void (async () => {
    try {
      await runRebuild();
    } catch (e) {
      rebuildState.error = e instanceof Error ? e.message : "reindex failed";
      console.error("[reindex] background rebuild failed:", e);
    } finally {
      rebuildRunning = false;
      rebuildState.running = false;
      rebuildState.finishedAt = new Date().toISOString();
    }
  })();

  return NextResponse.json({ ok: true, started: true });
}

// Poll for rebuild progress (admin-gated, same as POST).
export async function GET() {
  if (!(await getAdminSession()))
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(rebuildState);
}
