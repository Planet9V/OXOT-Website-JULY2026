/**
 * Static model catalog for the admin "AI & Models" page. Each entry is a
 * selectable OpenRouter model id, tagged with the role(s) it can serve. Ollama
 * models are NOT listed here — they're looked up live via
 * /api/admin/ai-settings/models?provider=ollama (see ai-settings.tsx) because
 * they depend on what's actually installed on the configured host, and there is
 * a single Ollama chat model shared across all generation roles (ollama_chat_model).
 *
 * Embeddings are LOCKED: qwen/qwen3-embedding-4b is the only entry for the
 * "embeddings" role, and the admin UI must render it disabled. EMBED_DIM (1536)
 * is fixed by the pgvector schema (migration 001/035) — changing the embedding
 * model to one with a different native dimension requires a migration and a
 * full re-ingest, so it is intentionally not swappable here.
 */

export type ModelRole = "chat" | "brief" | "translation" | "long-context" | "embeddings" | "search";

export interface CatalogModel {
  id: string; // OpenRouter model id
  label: string;
  provider: "openrouter";
  roles: ModelRole[];
  description: string;
  contextWindow: number; // tokens
  locked?: boolean; // true only for the embedding model — not user-selectable
}

export const ROLE_LABELS: Record<ModelRole, string> = {
  chat: "Assistant chat",
  brief: "Wizard & briefs",
  translation: "Translation",
  "long-context": "Long context",
  embeddings: "Embeddings",
  search: "Web search"
};

export const MODEL_CATALOG: CatalogModel[] = [
  {
    id: "anthropic/claude-3.5-haiku",
    label: "Claude 3.5 Haiku",
    provider: "openrouter",
    roles: ["chat", "brief", "translation"],
    description: "Fast, low-cost Anthropic model. Good default for everyday assistant replies, brief generation, and translation.",
    contextWindow: 200000
  },
  {
    id: "openai/gpt-4o-mini",
    label: "GPT-4o mini",
    provider: "openrouter",
    roles: ["chat", "brief", "translation", "long-context"],
    description: "Balanced OpenAI model with strong instruction-following at low cost.",
    contextWindow: 128000
  },
  {
    id: "google/gemini-2.5-pro",
    label: "Gemini 2.5 Pro",
    provider: "openrouter",
    roles: ["chat", "brief", "translation", "long-context"],
    description: "Very large context window. Best choice when the assembled prompt/context is large — this is the recommended Long context model.",
    contextWindow: 1048576
  },
  {
    id: "qwen/qwen3-embedding-4b",
    label: "Qwen3 Embedding 4B",
    provider: "openrouter",
    roles: ["embeddings"],
    description: "Locked embedding model. Vectors are truncated to 1536 dims and L2-renormalized (Matryoshka/MRL) to match the pgvector schema. Changing this requires a migration and a full re-ingest.",
    contextWindow: 32000,
    locked: true
  },
  {
    id: "perplexity/sonar",
    label: "Perplexity Sonar",
    provider: "openrouter",
    roles: ["search"],
    description: "Web-grounded model used when retrieval finds no relevant site content — answers cite that they used live web search.",
    contextWindow: 127000
  },
  {
    id: "perplexity/sonar-pro",
    label: "Perplexity Sonar Pro",
    provider: "openrouter",
    roles: ["search"],
    description: "Higher-quality web-grounded model for more complex search-fallback queries.",
    contextWindow: 200000
  }
];

export function modelsForRole(role: ModelRole): CatalogModel[] {
  return MODEL_CATALOG.filter((m) => m.roles.includes(role));
}

export function catalogEntry(id: string): CatalogModel | undefined {
  return MODEL_CATALOG.find((m) => m.id === id);
}
