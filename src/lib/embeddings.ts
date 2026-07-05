// Embeddings via local Ollama. Model + dimension come from env so they match the
// actually-installed model (qwen3-embedding:4b is 2560-dim natively).
const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const EMBED_MODEL = process.env.OLLAMA_EMBED_MODEL ?? "qwen3-embedding:4b";
export const EMBED_DIM = Number(process.env.EMBED_DIM ?? 2560);

export async function embed(text: string): Promise<number[]> {
  const res = await fetch(`${OLLAMA_HOST}/api/embeddings`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ model: EMBED_MODEL, prompt: text })
  });
  if (!res.ok) throw new Error(`Ollama embeddings failed: ${res.status}`);
  const json = (await res.json()) as { embedding: number[] };
  if (json.embedding?.length !== EMBED_DIM) {
    throw new Error(
      `Embedding dim mismatch: model returned ${json.embedding?.length}, EMBED_DIM=${EMBED_DIM}. ` +
        `Set EMBED_DIM to match ${EMBED_MODEL} and re-run migrations.`
    );
  }
  return json.embedding;
}
