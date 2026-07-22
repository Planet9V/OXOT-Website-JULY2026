import { NextResponse, type NextRequest } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { chatStream } from "@/lib/llm/stream";
import type { ChatMessage } from "@/lib/llm/provider";
import { isLocale } from "@/i18n/config";
import { BLOCK_REGISTRY } from "@/lib/blocks/registry";
import { BLOCK_SCHEMAS } from "@/lib/blocks/schema";
import type { BlockType } from "@/lib/blocks/types";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

// ─────────────────────────────────────────────────────────────────────────────
// OXOT styleguide — the voice + rules the AI must follow so generated copy stays
// on-brand and aligned to the site's structure. Editable here in one place.
// ─────────────────────────────────────────────────────────────────────────────
const STYLEGUIDE = `You write copy for OXOT — an operational-technology (OT) cybersecurity
consultancy. Audience: OT / industrial security leaders, plant and infrastructure
operators, product manufacturers. Voice: authoritative, precise, risk-based and
concrete — never hypey, never generic marketing fluff, no exclamation marks.
Prefer specific nouns and verbs over adjectives. Reference real frameworks where
apt (IEC 62443, NIS2, CRA, AI Act, Machinery Regulation) but never invent facts,
figures, dates or certifications. Keep sentences tight. Match the locale exactly:
for 'nl', write natural, professional Dutch (not translated-sounding); for 'en',
British-leaning English. Preserve the meaning and intent of existing content unless
told to change it. Output must fit the block's existing structure.`;

function extractJson(text: string): unknown {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const raw = (fenced ? fenced[1] : text).trim();
  return JSON.parse(raw);
}

async function complete(messages: ChatMessage[]): Promise<string> {
  let out = "";
  for await (const delta of chatStream(messages)) out += delta;
  return out;
}

// POST /api/admin/pages/blocks/assist
//   { mode:"block-copy", blockType, config, instruction, locale } -> { config }
//   { mode:"page-draft", instruction, locale }                    -> { blocks:[{type,config}] }
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = (await req.json().catch(() => ({}))) as {
    mode?: "block-copy" | "page-draft";
    blockType?: BlockType;
    config?: unknown;
    instruction?: string;
    locale?: string;
  };
  const locale = body.locale && isLocale(body.locale) ? body.locale : "en";
  const instruction = (body.instruction ?? "").trim();

  try {
    if (body.mode === "block-copy") {
      const def = body.blockType ? BLOCK_REGISTRY[body.blockType] : undefined;
      if (!def) return NextResponse.json({ error: "unknown block type" }, { status: 400 });
      const messages: ChatMessage[] = [
        {
          role: "system",
          content:
            `${STYLEGUIDE}\n\nYou are editing a "${def.label}" section. You are given its ` +
            `current content as a JSON object. Apply the editor's instruction to the TEXT ` +
            `fields only. Keep EXACTLY the same JSON keys and structure. Do NOT change ` +
            `non-text fields (icon names, href/url values, tone/status enums, ids, numeric ` +
            `layout values). Locale = "${locale}". Return ONLY the updated JSON object — no prose, no code fences.`
        },
        {
          role: "user",
          content: `Instruction: ${instruction || "Improve the copy: clearer, tighter, more on-brand."}\n\nCurrent JSON:\n${JSON.stringify(body.config ?? {}, null, 2)}`
        }
      ];
      const out = await complete(messages);
      const config = extractJson(out);
      return NextResponse.json({ config });
    }

    if (body.mode === "page-draft") {
      // Only the generic, composable blocks are offered to the drafter.
      const palette = (Object.values(BLOCK_SCHEMAS) as { type: BlockType; category: string; label: string; hint?: string; defaultConfig: () => unknown }[])
        .filter((s) => s.category === "generic");
      const catalog = palette
        .map((s) => `- "${s.type}" (${s.label}${s.hint ? `: ${s.hint}` : ""}) shape: ${JSON.stringify(s.defaultConfig())}`)
        .join("\n");
      const messages: ChatMessage[] = [
        {
          role: "system",
          content:
            `${STYLEGUIDE}\n\nDraft a landing page as an ORDERED JSON array of blocks. Use ONLY ` +
            `these block types, each with a config matching the given shape:\n${catalog}\n\n` +
            `Locale = "${locale}". A good page: one "block.hero", then a few content blocks ` +
            `(stats / feature grid / prose), and a closing "block.cta". Return ONLY a JSON array ` +
            `of objects like [{"type":"block.hero","config":{…}}, …] — no prose, no code fences.`
        },
        { role: "user", content: `Brief: ${instruction || "A concise landing page for an OXOT OT-security service."}` }
      ];
      const out = await complete(messages);
      const parsed = extractJson(out);
      const blocks = Array.isArray(parsed) ? parsed : [];
      // Drop anything not in the registry (defensive).
      const clean = blocks.filter((b) => b && BLOCK_REGISTRY[(b as { type: BlockType }).type]);
      return NextResponse.json({ blocks: clean });
    }

    return NextResponse.json({ error: "unknown mode" }, { status: 400 });
  } catch (e) {
    return NextResponse.json({ error: (e as Error).message.slice(0, 300) || "assist failed" }, { status: 500 });
  }
}
