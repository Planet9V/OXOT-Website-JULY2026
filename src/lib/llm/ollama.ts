import type { ChatMessage, LLMProvider } from "./provider";

const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const CHAT_MODEL = process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b";
// Hard timeout so a stalled local model can't hang the request; caller falls back.
const TIMEOUT_MS = Number(process.env.OLLAMA_TIMEOUT_MS ?? 45000);

export class OllamaProvider implements LLMProvider {
  readonly name = "ollama";
  async chat(messages: ChatMessage[]): Promise<string> {
    const res = await fetch(`${OLLAMA_HOST}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: CHAT_MODEL, messages, stream: false }),
      signal: AbortSignal.timeout(TIMEOUT_MS)
    });
    if (!res.ok) throw new Error(`Ollama chat failed: ${res.status}`);
    const json = (await res.json()) as { message?: { content?: string } };
    return json.message?.content ?? "";
  }
}
