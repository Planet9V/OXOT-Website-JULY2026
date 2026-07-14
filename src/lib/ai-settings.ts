import { pool } from "@/lib/db";
import { scryptSync, randomBytes, createCipheriv, createDecipheriv } from "node:crypto";

/**
 * Secret-at-rest encryption for the OpenRouter key (AES-256-GCM). The key is
 * derived from SETTINGS_SECRET (falls back to AUTH_SECRET) via scrypt. Stored
 * values are tagged "enc:v1:…"; anything without the tag is treated as plaintext
 * (backward-compatible with values written before encryption existed).
 */
const SECRET = process.env.SETTINGS_SECRET ?? process.env.AUTH_SECRET ?? "dev-insecure-settings-secret";
const ENC_PREFIX = "enc:v1:";

function encryptSecret(plain: string): string {
  const salt = randomBytes(16);
  const iv = randomBytes(12);
  const dk = scryptSync(SECRET, salt, 32);
  const cipher = createCipheriv("aes-256-gcm", dk, iv);
  const ct = Buffer.concat([cipher.update(plain, "utf8"), cipher.final()]);
  const tag = cipher.getAuthTag();
  return ENC_PREFIX + [salt, iv, tag, ct].map((b) => b.toString("base64")).join(":");
}

function decryptSecret(stored: string): string {
  if (!stored.startsWith(ENC_PREFIX)) return stored; // legacy plaintext
  try {
    const [saltB, ivB, tagB, ctB] = stored.slice(ENC_PREFIX.length).split(":");
    const dk = scryptSync(SECRET, Buffer.from(saltB, "base64"), 32);
    const decipher = createDecipheriv("aes-256-gcm", dk, Buffer.from(ivB, "base64"));
    decipher.setAuthTag(Buffer.from(tagB, "base64"));
    return Buffer.concat([decipher.update(Buffer.from(ctB, "base64")), decipher.final()]).toString("utf8");
  } catch {
    return ""; // secret rotated or corrupt — fall back to env key
  }
}

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
  embedProvider: ChatProvider; // which backend produces embeddings
  openrouterEmbedModel: string; // OpenRouter embedding model id (qwen/qwen3-embedding-4b)
  chatProvider: ChatProvider; // which provider is tried first (other is fallback)
  ollamaChatModel: string;
  openrouterModel: string;
  openrouterKey: string; // "" if unset
}

export const AI_SETTING_KEYS = [
  "ollama_host",
  "embed_model",
  "embed_provider",
  "openrouter_embed_model",
  "chat_provider",
  "ollama_chat_model",
  "openrouter_model",
  "openrouter_api_key"
] as const;
export type AiSettingKey = (typeof AI_SETTING_KEYS)[number];

const ENV = {
  ollamaHost: process.env.OLLAMA_HOST ?? "http://ollama:11434",
  embedModel: process.env.OLLAMA_EMBED_MODEL ?? "qwen3-embedding:4b",
  embedDim: Number(process.env.EMBED_DIM ?? 1536),
  // Embeddings default to OpenRouter (reachable from Railway; Ollama isn't deployed
  // there). qwen3-embedding-4b is hosted on OpenRouter. Ollama stays as a fallback.
  embedProvider: (process.env.EMBED_PROVIDER ?? "openrouter").toLowerCase() === "ollama" ? "ollama" : "openrouter",
  openrouterEmbedModel: process.env.OPENROUTER_EMBED_MODEL ?? "qwen/qwen3-embedding-4b",
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
  const embedProvider =
    s.embed_provider === "ollama" || s.embed_provider === "openrouter"
      ? (s.embed_provider as ChatProvider)
      : (ENV.embedProvider as ChatProvider);
  return {
    ollamaHost: (s.ollama_host || ENV.ollamaHost).replace(/\/$/, ""),
    embedModel: s.embed_model || ENV.embedModel,
    embedDim: ENV.embedDim,
    embedProvider,
    openrouterEmbedModel: s.openrouter_embed_model || ENV.openrouterEmbedModel,
    chatProvider: provider,
    ollamaChatModel: s.ollama_chat_model || ENV.ollamaChatModel,
    openrouterModel: s.openrouter_model || ENV.openrouterModel,
    openrouterKey: (s.openrouter_api_key ? decryptSecret(s.openrouter_api_key) : "") || ENV.openrouterKey
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
    embedProvider: cfg.embedProvider,
    openrouterEmbedModel: cfg.openrouterEmbedModel,
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
      // Encrypt the OpenRouter key at rest; other settings are non-secret.
      const stored = key === "openrouter_api_key" ? encryptSecret(value as string) : (value as string);
      await pool.query(
        `INSERT INTO app_settings (key, value, updated_at) VALUES ($1,$2, now())
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`,
        [key, stored]
      );
    }
  }
  cache = null; // invalidate so next read is fresh
}
