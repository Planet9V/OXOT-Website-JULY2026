import type { ChatMessage } from "./provider";
import { OllamaProvider } from "./ollama";
import { OpenRouterProvider } from "./openrouter";
import { getAiConfig } from "@/lib/ai-settings";

const ollama = new OllamaProvider();
const openrouter = new OpenRouterProvider();

// Non-streaming generation with automatic failover: try the configured primary
// provider (admin settings over env, same resolution chatStream() uses), fall
// back to the other on failure.
//
// opts.model, when set, overrides the OpenRouter model for this call only (used
// to route a specific role — e.g. translation_model — through OpenRouter
// without touching the Ollama model, which stays the single configured local
// chat model regardless of role).
export async function chat(
  messages: ChatMessage[],
  opts?: { model?: string }
): Promise<{ content: string; provider: string }> {
  const cfg = await getAiConfig();
  const order = cfg.chatProvider === "ollama" ? ([ollama, openrouter] as const) : ([openrouter, ollama] as const);
  let lastErr: unknown;
  for (const provider of order) {
    try {
      const content = await provider.chat(
        messages,
        provider.name === "ollama"
          ? { model: cfg.ollamaChatModel, host: cfg.ollamaHost }
          : { model: opts?.model ?? cfg.openrouterModel, key: cfg.openrouterKey }
      );
      return { content, provider: provider.name };
    } catch (err) {
      console.warn(`[llm] ${provider.name} failed, trying fallback:`, err);
      lastErr = err;
    }
  }
  throw lastErr instanceof Error ? lastErr : new Error("All LLM providers failed");
}
