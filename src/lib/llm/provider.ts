// One swappable interface. Fallback is a single policy, not scattered conditionals.
export interface ChatMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

// Per-call overrides. `model` swaps which model a call uses (e.g. a specific
// role's assigned model from ai-catalog.ts); `host`/`key` let callers pass the
// resolved admin-setting values through instead of relying on each provider's
// module-level env default.
export interface ChatOptions {
  model?: string;
  host?: string;
  key?: string;
}

export interface LLMProvider {
  readonly name: string;
  chat(messages: ChatMessage[], opts?: ChatOptions): Promise<string>;
}
