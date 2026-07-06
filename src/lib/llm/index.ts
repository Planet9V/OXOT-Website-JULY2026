import type { ChatMessage } from "./provider";
import { OllamaProvider } from "./ollama";
import { OpenRouterProvider } from "./openrouter";

const ollama = new OllamaProvider();
const openrouter = new OpenRouterProvider();

// Primary provider is env-selectable; default OpenRouter (LLM_PRIMARY=ollama to flip).
const PRIMARY = (process.env.LLM_PRIMARY ?? "openrouter").toLowerCase();

// Non-streaming generation with automatic failover: try PRIMARY, fall back on failure.
export async function chat(messages: ChatMessage[]): Promise<{
  content: string;
  provider: string;
}> {
  const [primary, fallback] = PRIMARY === "ollama" ? [ollama, openrouter] : [openrouter, ollama];
  try {
    return { content: await primary.chat(messages), provider: primary.name };
  } catch (err) {
    console.warn(`[llm] ${primary.name} failed, falling back to ${fallback.name}:`, err);
    return { content: await fallback.chat(messages), provider: fallback.name };
  }
}
