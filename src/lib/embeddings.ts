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

export async function embed(text: string): Promise<number[]> {
  // Host + model come from admin settings (DB) with env fallback, resolved per call.
  const { ollamaHost, embedModel } = await getAiConfig();
  const res = await fetch(`${ollamaHost}/api/embeddings`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ model: embedModel, prompt: text })
  });
  if (!res.ok) throw new Error(`Ollama embeddings failed: ${res.status}`);
  const json = (await res.json()) as { embedding: number[] };
  const raw = json.embedding;
  if (!Array.isArray(raw) || raw.length < EMBED_DIM) {
    throw new Error(
      `Embedding too small: ${embedModel} returned ${raw?.length}, need >= EMBED_DIM=${EMBED_DIM}. ` +
        `Set EMBED_DIM to a value the model can produce (qwen3-embedding:4b native = 2560).`
    );
  }
  return fitDim(raw, EMBED_DIM);
}
