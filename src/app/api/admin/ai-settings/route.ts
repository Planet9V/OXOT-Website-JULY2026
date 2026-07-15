import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getAiConfigMasked, saveAiSettings, type AiSettingKey } from "@/lib/ai-settings";

export const dynamic = "force-dynamic";

// Current AI provider settings — secret masked, never leaks the key to the client.
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(await getAiConfigMasked());
}

// Save settings. Only fields present in the body are changed. For the OpenRouter
// key: omit to keep it, send "" to clear it (fall back to env), send a value to set.
export async function PUT(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;

  const map: Record<string, AiSettingKey> = {
    ollamaHost: "ollama_host",
    embedModel: "embed_model",
    embedProvider: "embed_provider",
    openrouterEmbedModel: "openrouter_embed_model",
    chatProvider: "chat_provider",
    ollamaChatModel: "ollama_chat_model",
    openrouterModel: "openrouter_model",
    openrouterApiKey: "openrouter_api_key",
    chatModel: "chat_model",
    briefModel: "brief_model",
    translationModel: "translation_model",
    longContextModel: "long_context_model",
    searchModel: "search_model"
  };
  // Guard the embedding provider enum too.
  if (typeof b.embedProvider === "string" && b.embedProvider !== "ollama" && b.embedProvider !== "openrouter") {
    return NextResponse.json({ error: "embedProvider must be 'ollama' or 'openrouter'" }, { status: 400 });
  }

  const patch: Partial<Record<AiSettingKey, string>> = {};
  for (const [field, key] of Object.entries(map)) {
    if (typeof b[field] === "string") patch[key] = (b[field] as string).trim();
  }
  if (patch.chat_provider && patch.chat_provider !== "ollama" && patch.chat_provider !== "openrouter") {
    return NextResponse.json({ error: "chatProvider must be 'ollama' or 'openrouter'" }, { status: 400 });
  }

  await saveAiSettings(patch);
  return NextResponse.json(await getAiConfigMasked());
}
