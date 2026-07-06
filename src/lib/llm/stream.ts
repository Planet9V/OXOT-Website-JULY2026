import type { ChatMessage } from "./provider";

// --- Ollama (local) ---
const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const CHAT_MODEL = process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b";
const IDLE_MS = Number(process.env.OLLAMA_IDLE_TIMEOUT_MS ?? 60000);

// --- OpenRouter (cloud) ---
const OR_KEY = process.env.OPENROUTER_API_KEY;
const OR_MODEL = process.env.OPENROUTER_MODEL ?? "openai/gpt-4o-mini";
const OR_TIMEOUT_MS = Number(process.env.OPENROUTER_TIMEOUT_MS ?? 60000);

// Which provider serves the chat first. Default: openrouter (set LLM_PRIMARY=ollama
// to prefer the local model). The other provider is the automatic fallback.
const PRIMARY = (process.env.LLM_PRIMARY ?? "openrouter").toLowerCase();

// Ollama streaming (NDJSON). A watchdog aborts a stalled stream so we can fall back.
async function* ollamaStream(messages: ChatMessage[]): AsyncGenerator<string> {
  const ac = new AbortController();
  let watchdog = setTimeout(() => ac.abort(), IDLE_MS);
  let res: Response;
  try {
    res = await fetch(`${OLLAMA_HOST}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: CHAT_MODEL, messages, stream: true }),
      signal: ac.signal
    });
  } catch (e) { clearTimeout(watchdog); throw e; }
  if (!res.ok || !res.body) { clearTimeout(watchdog); throw new Error(`Ollama stream failed: ${res.status}`); }
  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buf = "";
  try {
    for (;;) {
      const { done, value } = await reader.read();
      if (done) break;
      clearTimeout(watchdog);
      watchdog = setTimeout(() => ac.abort(), IDLE_MS);
      buf += decoder.decode(value, { stream: true });
      const lines = buf.split("\n");
      buf = lines.pop() ?? "";
      for (const line of lines) {
        if (!line.trim()) continue;
        const json = JSON.parse(line) as { message?: { content?: string } };
        const delta = json.message?.content;
        if (delta) yield delta;
      }
    }
  } finally {
    clearTimeout(watchdog);
  }
}

// OpenRouter streaming (SSE: `data: {json}` lines, terminated by `data: [DONE]`).
async function* openrouterStream(messages: ChatMessage[]): AsyncGenerator<string> {
  if (!OR_KEY) throw new Error("OPENROUTER_API_KEY not set");
  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: `Bearer ${OR_KEY}` },
    body: JSON.stringify({ model: OR_MODEL, messages, stream: true }),
    signal: AbortSignal.timeout(OR_TIMEOUT_MS)
  });
  if (!res.ok || !res.body) throw new Error(`OpenRouter stream failed: ${res.status}`);
  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buf = "";
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    buf += decoder.decode(value, { stream: true });
    const lines = buf.split("\n");
    buf = lines.pop() ?? "";
    for (const raw of lines) {
      const line = raw.trim();
      if (!line.startsWith("data:")) continue; // skip SSE comments/keep-alives
      const data = line.slice(5).trim();
      if (data === "[DONE]") return;
      try {
        const json = JSON.parse(data) as { choices?: { delta?: { content?: string } }[] };
        const delta = json.choices?.[0]?.delta?.content;
        if (delta) yield delta;
      } catch {
        /* partial/keep-alive line — ignore */
      }
    }
  }
}

// Streamed generation with automatic failover. Tries PRIMARY first, then the
// other provider. Reports the serving provider via onProvider. Falls back only
// if the primary emitted no tokens (avoids duplicating a half-streamed answer).
export async function* chatStream(
  messages: ChatMessage[],
  onProvider?: (name: string) => void
): AsyncGenerator<string> {
  const order = PRIMARY === "ollama" ? (["ollama", "openrouter"] as const) : (["openrouter", "ollama"] as const);
  let yielded = false;
  for (const name of order) {
    try {
      onProvider?.(name);
      const gen = name === "ollama" ? ollamaStream(messages) : openrouterStream(messages);
      for await (const delta of gen) { yielded = true; yield delta; }
      if (!yielded) throw new Error(`${name} produced no content`);
      return; // success
    } catch (err) {
      if (yielded) {
        console.warn(`[llm] ${name} aborted after partial output:`, err);
        return;
      }
      console.warn(`[llm] ${name} failed, trying fallback:`, err);
    }
  }
  if (!yielded) yield "[error generating response]";
}
