import type { ChatMessage, ChatOptions, LLMProvider } from "./provider";

const KEY = process.env.OPENROUTER_API_KEY;
const MODEL = process.env.OPENROUTER_MODEL ?? "openai/gpt-4o-mini";

export class OpenRouterProvider implements LLMProvider {
  readonly name = "openrouter";
  async chat(messages: ChatMessage[], opts?: ChatOptions): Promise<string> {
    const key = opts?.key ?? KEY;
    const model = opts?.model ?? MODEL;
    if (!key) throw new Error("OPENROUTER_API_KEY not set");
    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        authorization: `Bearer ${key}`
      },
      body: JSON.stringify({ model, messages })
    });
    if (!res.ok) throw new Error(`OpenRouter chat failed: ${res.status}`);
    const json = (await res.json()) as {
      choices?: { message?: { content?: string } }[];
    };
    return json.choices?.[0]?.message?.content ?? "";
  }
}
