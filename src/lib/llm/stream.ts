import type { ChatMessage } from "./provider";
import { getAiConfig } from "@/lib/ai-settings";

// Timeouts stay env-tunable (not part of admin settings).
const IDLE_MS = Number(process.env.OLLAMA_IDLE_TIMEOUT_MS ?? 60000);
const OR_TIMEOUT_MS = Number(process.env.OPENROUTER_TIMEOUT_MS ?? 60000);

// Ollama streaming (NDJSON). A watchdog aborts a stalled stream so we can fall back.
async function* ollamaStream(messages: ChatMessage[], host: string, model: string): AsyncGenerator<string> {
  const ac = new AbortController();
  let watchdog = setTimeout(() => ac.abort(), IDLE_MS);
  let res: Response;
  try {
    res = await fetch(`${host}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model, messages, stream: true }),
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
// Exported so webSearchOrChatStream() can drive it directly for the web-search
// fallback (which must always use OpenRouter — Ollama has no web-search model).
export async function* openrouterStream(messages: ChatMessage[], key: string, model: string): AsyncGenerator<string> {
  if (!key) throw new Error("OpenRouter API key not set");
  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: `Bearer ${key}` },
    body: JSON.stringify({ model, messages, stream: true }),
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
//
// opts.model, when set, overrides the OpenRouter model for this call only (e.g.
// chat_model for a normal-length answer, or long_context_model when the
// assembled prompt is large — see src/app/api/agent/route.ts). The Ollama leg
// is unaffected by opts.model: Ollama always uses the single configured
// ollama_chat_model, since there is one local model shared across roles.
export async function* chatStream(
  messages: ChatMessage[],
  onProvider?: (name: string) => void,
  opts?: { model?: string }
): AsyncGenerator<string> {
  // Resolve effective provider config (admin settings over env) once per request.
  const cfg = await getAiConfig();
  const order = cfg.chatProvider === "ollama" ? (["ollama", "openrouter"] as const) : (["openrouter", "ollama"] as const);
  let yielded = false;
  for (const name of order) {
    try {
      onProvider?.(name);
      const gen = name === "ollama"
        ? ollamaStream(messages, cfg.ollamaHost, cfg.ollamaChatModel)
        : openrouterStream(messages, cfg.openrouterKey, opts?.model ?? cfg.chatModel);
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

// Web-search fallback: when RAG retrieval found no/low-confidence context, answer
// via a web-grounded OpenRouter model (search_model, e.g. Perplexity Sonar)
// instead of the normal chat/long-context model — Ollama has no equivalent, so
// this always goes straight to OpenRouter rather than following chatStream's
// ollama<->openrouter order. Degrades to the normal chatStream() (still
// bilingual, still grounded-or-honest) when OpenRouter has no key configured, or
// if the search call fails before producing any output. One branch point here,
// not scattered conditionals in the agent route.
export async function* webSearchOrChatStream(
  messages: ChatMessage[],
  onProvider?: (name: string) => void,
  searchModel?: string
): AsyncGenerator<string> {
  const cfg = await getAiConfig();
  if (searchModel && cfg.openrouterKey) {
    let yielded = false;
    try {
      onProvider?.("openrouter-search");
      for await (const delta of openrouterStream(messages, cfg.openrouterKey, searchModel)) {
        yielded = true;
        yield delta;
      }
      if (yielded) return;
    } catch (err) {
      console.warn("[llm] web search fallback failed, falling back to normal chat:", err);
    }
  }
  yield* chatStream(messages, onProvider);
}
