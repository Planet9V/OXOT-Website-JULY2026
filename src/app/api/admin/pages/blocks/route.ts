import { NextResponse, type NextRequest } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getPageBlocks, setPageBlocks, type BlockInput } from "@/lib/blocks/page-blocks";
import { isLocale } from "@/i18n/config";
import { BLOCK_REGISTRY } from "@/lib/blocks/registry";
import type { BlockType } from "@/lib/blocks/types";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// GET /api/admin/pages/blocks?slug=&locale=  -> ordered blocks for a page+locale.
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { searchParams } = new URL(req.url);
  const slug = searchParams.get("slug") ?? "";
  const locale = searchParams.get("locale") ?? "";
  if (!slug || !isLocale(locale)) return NextResponse.json({ error: "slug and valid locale required" }, { status: 400 });
  const blocks = await getPageBlocks(slug, locale);
  return NextResponse.json({ slug, locale, blocks });
}

// PUT /api/admin/pages/blocks  { slug, locale, blocks:[{type,config}], note? }
// Replaces the page's blocks (snapshot-first). Validates every block type
// against the registry so an unknown type can't be persisted.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as {
    slug?: string;
    locale?: string;
    blocks?: BlockInput[];
    note?: string;
  };
  const { slug, locale } = body;
  if (!slug || !locale || !isLocale(locale) || !Array.isArray(body.blocks)) {
    return NextResponse.json({ error: "slug, valid locale, and blocks[] required" }, { status: 400 });
  }
  const unknown = body.blocks.find((b) => !BLOCK_REGISTRY[b?.type as BlockType]);
  if (unknown) {
    return NextResponse.json({ error: `unknown block type: ${String(unknown.type)}` }, { status: 400 });
  }
  const count = await setPageBlocks(slug, locale, body.blocks, body.note ?? "Block edit (admin)");
  return NextResponse.json({ ok: true, count });
}
