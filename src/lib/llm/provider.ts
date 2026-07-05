// One swappable interface. Fallback is a single policy, not scattered conditionals.
export interface ChatMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface LLMProvider {
  readonly name: string;
  chat(messages: ChatMessage[]): Promise<string>;
}
