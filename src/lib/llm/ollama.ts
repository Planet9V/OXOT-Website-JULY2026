import type { ChatMessage, LLMProvider } from "./provider";

const OLLAMA_HOST = process.env.OLLAMA_HOST ?? "http://ollama:11434";
const CHAT_MODEL = process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b";

export class OllamaProvider implements LLMProvider {
  readonly name = "ollama";
  async chat(messages: ChatMessage[]): Promise<string> {
    const res = await fetch(`${OLLAMA_HOST}/api/chat`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: CHAT_MODEL, messages, stream: false })
    });
    if (!res.ok) throw new Error(`Ollama chat failed: ${res.status}`);
    const json = (await res.json()) as { message?: { content?: string } };
    return json.message?.content ?? "";
  }
}
