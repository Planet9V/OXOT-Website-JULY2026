import type { ChatMessage } from "./provider";
import { OpenRouterProvider } from "./openrouter";

const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const CHAT_MODEL = process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b";

// Streamed generation: local Ollama primary (NDJSON), OpenRouter fallback.
// Yields text deltas; reports which provider served the response via onProvider.
export async function* chatStream(
  messages: ChatMessage[],
  onProvider?: (name: string) => void
): AsyncGenerator<string> {
  try {
    const res = await fetch(`${OLLAMA_HOST}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: CHAT_MODEL, messages, stream: true })
    });
    if (!res.ok || !res.body) throw new Error(`Ollama stream failed: ${res.status}`);
    onProvider?.("ollama");
    const reader = res.body.getReader();
    const decoder = new TextDecoder();
    let buf = "";
    for (;;) {
      const { done, value } = await reader.read();
      if (done) break;
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
  } catch (err) {
    console.warn("[llm] ollama stream failed, falling back to OpenRouter:", err);
    onProvider?.("openrouter");
    const content = await new OpenRouterProvider().chat(messages);
    yield content;
  }
}
