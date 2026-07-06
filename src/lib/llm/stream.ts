import type { ChatMessage } from "./provider";
import { OpenRouterProvider } from "./openrouter";

const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const CHAT_MODEL = process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b";
// If the local model produces no bytes for this long (connection stall or a
// model that never loads), abort and fall back to OpenRouter instead of hanging
// the request forever. Overridable via env.
const IDLE_MS = Number(process.env.OLLAMA_IDLE_TIMEOUT_MS ?? 60000);

// Streamed generation: local Ollama primary (NDJSON), OpenRouter fallback.
// Yields text deltas; reports which provider served the response via onProvider.
// A watchdog aborts a stalled Ollama stream so the agent never hangs (falls back
// to OpenRouter only if no Ollama tokens were emitted yet).
export async function* chatStream(
  messages: ChatMessage[],
  onProvider?: (name: string) => void
): AsyncGenerator<string> {
  let yielded = false;
  try {
    const ac = new AbortController();
    let watchdog = setTimeout(() => ac.abort(), IDLE_MS);
    const res = await fetch(`${OLLAMA_HOST}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: CHAT_MODEL, messages, stream: true }),
      signal: ac.signal
    });
    if (!res.ok || !res.body) throw new Error(`Ollama stream failed: ${res.status}`);
    onProvider?.("ollama");
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
          if (delta) { yielded = true; yield delta; }
        }
      }
    } finally {
      clearTimeout(watchdog);
    }
    // If Ollama returned OK but emitted nothing usable, fall through to fallback.
    if (!yielded) throw new Error("Ollama produced no content");
  } catch (err) {
    if (yielded) {
      // Partial Ollama answer already streamed; don't duplicate with a full
      // fallback answer — end here (the route persists what was sent).
      console.warn("[llm] ollama stream aborted after partial output:", err);
      return;
    }
    console.warn("[llm] ollama stream failed, falling back to OpenRouter:", err);
    onProvider?.("openrouter");
    const content = await new OpenRouterProvider().chat(messages);
    yield content;
  }
}
