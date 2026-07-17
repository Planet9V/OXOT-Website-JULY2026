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
const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

// Is this response body a transient, retryable provider condition? OpenRouter can
// return HTTP 429/5xx directly, OR wrap the upstream error in a 200 body like
// {"error":{"message":"HTTP 429: ...engine_overloaded...","code":429}} — so we
// inspect both the status and the body text.
function isRetryable(status: number, bodyText: string): boolean {
  if (status === 429 || status === 408 || status === 425 || (status >= 500 && status <= 599)) return true;
  return /\b(429|503|502|overloaded|engine_overloaded|rate.?limit|model busy|try again|temporarily)\b/i.test(bodyText);
}

async function embedOpenRouter(text: string, key: string, model: string): Promise<number[]> {
  // NOTE: do NOT send the OpenAI `dimensions` param. It is only honored by
  // OpenAI's text-embedding-3-* models; for qwen3-embedding-4b (and most other
  // providers) OpenRouter returns a body whose `data[0].embedding` is absent when
  // that param is present. qwen3-embedding-4b returns its native 2560-dim vector;
  // fitDim truncates it to EMBED_DIM (Matryoshka), identical to the index-side
  // path in scripts/ingest.mjs.
  //
  // Retry with exponential backoff on transient provider errors (HTTP 429
  // "engine_overloaded" / "Model busy, retry later" — sometimes wrapped in a 200
  // body). Without this, a single overloaded response aborts a whole rebuild.
  const MAX_ATTEMPTS = 6;
  let lastDetail = "";
  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
    const res = await fetch("https://openrouter.ai/api/v1/embeddings", {
      method: "POST",
      headers: { "content-type": "application/json", authorization: `Bearer ${key}` },
      body: JSON.stringify({ model, input: text })
    });
    const bodyText = await res.text().catch(() => "");

    if (res.ok) {
      let raw: number[] | undefined;
      try {
        raw = (JSON.parse(bodyText) as { data?: { embedding: number[] }[] }).data?.[0]?.embedding;
      } catch {
        raw = undefined;
      }
      if (Array.isArray(raw) && raw.length >= EMBED_DIM) return fitDim(raw, EMBED_DIM);
      // 200 with no usable embedding — retry only if the body says it's transient.
      lastDetail = bodyText.slice(0, 180);
      if (!isRetryable(200, bodyText)) {
        throw new Error(`OpenRouter embedding invalid for ${model}: got len=${raw?.length}, need >= ${EMBED_DIM}. Response: ${lastDetail}`);
      }
    } else {
      lastDetail = `${res.status} ${bodyText}`.slice(0, 180);
      if (!isRetryable(res.status, bodyText)) {
        throw new Error(`OpenRouter embeddings failed: ${lastDetail}`);
      }
    }

    // Backoff before the next attempt: honor Retry-After if present, else exponential.
    if (attempt < MAX_ATTEMPTS - 1) {
      const retryAfter = Number(res.headers.get("retry-after"));
      const wait = Number.isFinite(retryAfter) && retryAfter > 0
        ? Math.min(retryAfter * 1000, 10_000)
        : Math.min(600 * 2 ** attempt, 8_000) + Math.floor(Math.random() * 250);
      await sleep(wait);
    }
  }
  throw new Error(`OpenRouter embedding failed after ${MAX_ATTEMPTS} attempts (${model}), last: ${lastDetail}`);
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
