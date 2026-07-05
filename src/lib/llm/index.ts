import type { ChatMessage } from "./provider";
import { OllamaProvider } from "./ollama";
import { OpenRouterProvider } from "./openrouter";

const primary = new OllamaProvider();
const fallback = new OpenRouterProvider();

// Local Ollama primary; automatic OpenRouter fallback on failure/outage.
export async function chat(messages: ChatMessage[]): Promise<{
  content: string;
  provider: string;
}> {
  try {
    return { content: await primary.chat(messages), provider: primary.name };
  } catch (err) {
    console.warn(`[llm] ${primary.name} failed, falling back:`, err);
    return { content: await fallback.chat(messages), provider: fallback.name };
  }
}
