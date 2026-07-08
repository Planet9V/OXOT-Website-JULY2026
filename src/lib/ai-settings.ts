import { pool } from "@/lib/db";

/**
 * Admin-editable AI provider config, stored in app_settings (key/value) and merged
 * OVER the .env defaults so env remains the fallback. Read at request time via
 * getAiConfig(); cached briefly to avoid a DB hit per embed/token.
 *
 * Keys stored in app_settings:
 *   ollama_host, embed_model, chat_provider ('ollama'|'openrouter'),
 *   ollama_chat_model, openrouter_model, openrouter_api_key
 *
 * EMBED_DIM is intentionally NOT runtime-editable: the pgvector column dimension is
 * fixed by migration 001, so changing it requires a migration + re-index.
 */

export type ChatProvider = "ollama" | "openrouter";

export interface AiConfig {
  ollamaHost: string;
  embedModel: string;
  embedDim: number;
  chatProvider: ChatProvider; // which provider is tried first (other is fallback)
  ollamaChatModel: string;
  openrouterModel: string;
  openrouterKey: string; // "" if unset
}

export const AI_SETTING_KEYS = [
  "ollama_host",
  "embed_model",
  "chat_provider",
  "ollama_chat_model",
  "openrouter_model",
  "openrouter_api_key"
] as const;
export type AiSettingKey = (typeof AI_SETTING_KEYS)[number];

const ENV = {
  ollamaHost: process.env.OLLAMA_HOST ?? "http://ollama:11434",
  embedModel: process.env.OLLAMA_EMBED_MODEL ?? "qwen3-embedding:4b",
  embedDim: Number(process.env.EMBED_DIM ?? 2560),
  // stream.ts historically defaults primary to openrouter
  chatProvider: (process.env.LLM_PRIMARY ?? "openrouter").toLowerCase() === "ollama" ? "ollama" : "openrouter",
  ollamaChatModel: process.env.OLLAMA_CHAT_MODEL ?? "qwen3.5:9b",
  openrouterModel: process.env.OPENROUTER_MODEL ?? "openai/gpt-4o-mini",
  openrouterKey: process.env.OPENROUTER_API_KEY ?? ""
} as const;

let cache: { at: number; rows: Record<string, string> } | null = null;
const TTL_MS = 10_000;

async function readSettings(): Promise<Record<string, string>> {
  if (cache && Date.now() - cache.at < TTL_MS) return cache.rows;
  const rows: Record<string, string> = {};
  try {
    const r = await pool.query<{ key: string; value: string | null }>(`SELECT key, value FROM app_settings`);
    for (const row of r.rows) if (row.value != null && row.value !== "") rows[row.key] = row.value;
  } catch {
    // table may not exist yet (pre-migration) — fall back to env silently.
  }
  cache = { at: Date.now(), rows };
  return rows;
}

/** Effective config = DB value if set, else env default. */
export async function getAiConfig(): Promise<AiConfig> {
  const s = await readSettings();
  const provider = s.chat_provider === "ollama" || s.chat_provider === "openrouter" ? (s.chat_provider as ChatProvider) : ENV.chatProvider as ChatProvider;
  return {
    ollamaHost: (s.ollama_host || ENV.ollamaHost).replace(/\/$/, ""),
    embedModel: s.embed_model || ENV.embedModel,
    embedDim: ENV.embedDim,
    chatProvider: provider,
    ollamaChatModel: s.ollama_chat_model || ENV.ollamaChatModel,
    openrouterModel: s.openrouter_model || ENV.openrouterModel,
    openrouterKey: s.openrouter_api_key || ENV.openrouterKey
  };
}

/** Admin view: current settings with the secret masked (never leaks the key). */
export async function getAiConfigMasked() {
  const cfg = await getAiConfig();
  const key = cfg.openrouterKey;
  return {
    ollamaHost: cfg.ollamaHost,
    embedModel: cfg.embedModel,
    embedDim: cfg.embedDim,
    chatProvider: cfg.chatProvider,
    ollamaChatModel: cfg.ollamaChatModel,
    openrouterModel: cfg.openrouterModel,
    openrouterKeySet: !!key,
    openrouterKeyLast4: key ? key.slice(-4) : null,
    openrouterKeyFromEnv: !!process.env.OPENROUTER_API_KEY && !("openrouter_api_key" in (cache?.rows ?? {}))
  };
}

/** Upsert a batch of settings; empty string clears a key back to the env default. */
export async function saveAiSettings(patch: Partial<Record<AiSettingKey, string>>): Promise<void> {
  const entries = Object.entries(patch).filter(([k]) => (AI_SETTING_KEYS as readonly string[]).includes(k));
  for (const [key, value] of entries) {
    if (value === "") {
      await pool.query(`DELETE FROM app_settings WHERE key = $1`, [key]);
    } else {
      await pool.query(
        `INSERT INTO app_settings (key, value, updated_at) VALUES ($1,$2, now())
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`,
        [key, value]
      );
    }
  }
  cache = null; // invalidate so next read is fresh
}
