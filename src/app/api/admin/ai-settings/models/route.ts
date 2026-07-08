import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getAiConfig } from "@/lib/ai-settings";

export const dynamic = "force-dynamic";

/**
 * List available models for a provider (also serves as a connection test).
 *   GET ?provider=ollama[&host=http://...]   -> installed Ollama models
 *   GET ?provider=openrouter                  -> OpenRouter catalog
 * Returns { ok, models: [{ id, label }] } or { ok:false, error }.
 */
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const url = new URL(req.url);
  const provider = url.searchParams.get("provider");
  const cfg = await getAiConfig();

  try {
    if (provider === "ollama") {
      const host = (url.searchParams.get("host") || cfg.ollamaHost).replace(/\/$/, "");
      const res = await fetch(`${host}/api/tags`, { signal: AbortSignal.timeout(8000) });
      if (!res.ok) throw new Error(`Ollama responded ${res.status}`);
      const json = (await res.json()) as { models?: { name: string; details?: { parameter_size?: string } }[] };
      const models = (json.models ?? [])
        .map((m) => ({ id: m.name, label: m.details?.parameter_size ? `${m.name} (${m.details.parameter_size})` : m.name }))
        .sort((a, b) => a.id.localeCompare(b.id));
      return NextResponse.json({ ok: true, models });
    }

    if (provider === "openrouter") {
      // The catalog is public; a key isn't required just to list.
      const headers: Record<string, string> = {};
      if (cfg.openrouterKey) headers.authorization = `Bearer ${cfg.openrouterKey}`;
      const res = await fetch("https://openrouter.ai/api/v1/models", { headers, signal: AbortSignal.timeout(10000) });
      if (!res.ok) throw new Error(`OpenRouter responded ${res.status}`);
      const json = (await res.json()) as { data?: { id: string; name?: string }[] };
      const models = (json.data ?? [])
        .map((m) => ({ id: m.id, label: m.name ? `${m.name} — ${m.id}` : m.id }))
        .sort((a, b) => a.id.localeCompare(b.id));
      return NextResponse.json({ ok: true, models });
    }

    return NextResponse.json({ error: "provider must be 'ollama' or 'openrouter'" }, { status: 400 });
  } catch (e) {
    return NextResponse.json({ ok: false, error: e instanceof Error ? e.message : "lookup failed" }, { status: 200 });
  }
}
