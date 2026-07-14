import { getAiConfig } from "@/lib/ai-settings";

// Embedding dimension is fixed by the pgvector schema (migration 001) and stays
// env-driven; it must match the installed model (qwen3-embedding:4b is 2560-dim).
export const EMBED_DIM = Number(process.env.EMBED_DIM ?? 1536);

// qwen3-embedding:4b emits 2560-dim vectors natively. To target a smaller EMBED_DIM
// (1536) we use Matryoshka truncation: keep the first EMBED_DIM components and
// L2-renormalize. qwen3-embedding is MRL-trained, so a normalized prefix is a valid
// lower-dim embedding. This MUST match scripts/ingest.mjs exactly, or query and index
// vectors live in different spaces. No-op when the model already returns EMBED_DIM.
export function fitDim(v: number[], dim = EMBED_DIM): number[] {
  if (!Array.isArray(v) || v.length <= dim) return v;
  const t = v.slice(0, dim);
  const norm = Math.sqrt(t.reduce((s, x) => s + x * x, 0)) || 1;
  return t.map((x) => x / norm);
}

// Embed via OpenRouter's OpenAI-compatible endpoint (qwen/qwen3-embedding-4b by
// default). This is the production path — OpenRouter is reachable from Railway and
// hosts qwen3-embedding; we pass `dimensions` so MRL-capable models can return the
// target size directly, and fitDim guarantees EMBED_DIM regardless.
async function embedOpenRouter(text: string, key: string, model: string): Promise<number[]> {
  const res = await fetch("https://openrouter.ai/api/v1/embeddings", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: `Bearer ${key}` },
    body: JSON.stringify({ model, input: text, dimensions: EMBED_DIM })
  });
  if (!res.ok) throw new Error(`OpenRouter embeddings failed: ${res.status} ${await res.text().catch(() => "")}`.slice(0, 200));
  const json = (await res.json()) as { data?: { embedding: number[] }[] };
  const raw = json.data?.[0]?.embedding;
  if (!Array.isArray(raw) || raw.length < EMBED_DIM) {
    throw new Error(`OpenRouter embedding too small: got ${raw?.length}, need >= ${EMBED_DIM} (${model}).`);
  }
  return fitDim(raw, EMBED_DIM);
}

// Fallback path: local Ollama (only reachable where Ollama is deployed/tunnelled).
async function embedOllama(text: string, host: string, model: string): Promise<number[]> {
  const res = await fetch(`${host}/api/embeddings`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ model, prompt: text })
  });
  if (!res.ok) throw new Error(`Ollama embeddings failed: ${res.status}`);
  const json = (await res.json()) as { embedding: number[] };
  const raw = json.embedding;
  if (!Array.isArray(raw) || raw.length < EMBED_DIM) {
    throw new Error(`Ollama embedding too small: ${model} returned ${raw?.length}, need >= ${EMBED_DIM}.`);
  }
  return fitDim(raw, EMBED_DIM);
}

export async function embed(text: string): Promise<number[]> {
  // Provider + models come from admin settings (DB) with env fallback, per call.
  const cfg = await getAiConfig();
  const preferOpenRouter = cfg.embedProvider === "openrouter" && !!cfg.openrouterKey;
  if (preferOpenRouter) {
    try {
      return await embedOpenRouter(text, cfg.openrouterKey, cfg.openrouterEmbedModel);
    } catch (err) {
      // Only fall through to Ollama if it's actually configured; otherwise rethrow.
      if (!cfg.ollamaHost || cfg.ollamaHost.includes("ollama:11434")) throw err;
      console.error("[embeddings] OpenRouter failed, trying Ollama:", err);
    }
  }
  return embedOllama(text, cfg.ollamaHost, cfg.embedModel);
}
