import { getAiConfig } from "@/lib/ai-settings";

// Embedding dimension is fixed by the pgvector schema (migration 001) and stays
// env-driven; it must match the installed model (qwen3-embedding:4b is 2560-dim).
export const EMBED_DIM = Number(process.env.EMBED_DIM ?? 2560);

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
  if (json.embedding?.length !== EMBED_DIM) {
    throw new Error(
      `Embedding dim mismatch: model returned ${json.embedding?.length}, EMBED_DIM=${EMBED_DIM}. ` +
        `Set EMBED_DIM to match ${embedModel} and re-run migrations.`
    );
  }
  return json.embedding;
}
