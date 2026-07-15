import { pool } from "@/lib/db";
import { scryptSync, randomBytes, createCipheriv, createDecipheriv } from "node:crypto";

/**
 * Integration settings (email/SMTP + LinkedIn + X) stored as key/value rows in the
 * EXISTING `app_settings` table — no migration needed. Secret values are encrypted
 * at rest with AES-256-GCM, keyed from SETTINGS_SECRET (falls back to AUTH_SECRET)
 * via scrypt. Stored secrets are tagged "enc:v1:…"; anything without the tag is
 * treated as plaintext (backward-compatible).
 *
 * NOTE: the encryptSecret/decryptSecret helpers are intentionally DUPLICATED from
 * src/lib/ai-settings.ts (kept independent so this file cannot destabilise the AI
 * settings module).
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
    return ""; // secret rotated or corrupt
  }
}

/** All keys this module owns in app_settings. */
export const INTEGRATION_SETTING_KEYS = [
  // Email (SMTP / Gmail OAuth2)
  "email_enabled",
  "smtp_from_name",
  "smtp_from_email",
  "smtp_host",
  "smtp_port",
  "smtp_username",
  "smtp_password",
  "smtp_alert_email",
  "smtp_secure",
  "email_auth_type", // "password" | "oauth2"
  "email_oauth_client_id",
  "email_oauth_client_secret",
  "email_oauth_refresh_token",
  "email_oauth_user",
  // LinkedIn
  "linkedin_enabled",
  "linkedin_access_token",
  "linkedin_token_expires_at", // epoch ms, stringified; set by the OAuth callback
  "linkedin_author_urn",
  "linkedin_auto_publish",
  "linkedin_client_id",
  "linkedin_client_secret",
  // X
  "x_enabled",
  "x_api_key",
  "x_api_secret",
  "x_access_token",
  "x_access_secret",
  "x_username",
  "x_auto_publish"
] as const;
export type IntegrationSettingKey = (typeof INTEGRATION_SETTING_KEYS)[number];

/** Keys whose values are secrets (encrypted at rest, never returned to the client). */
const SECRET_KEYS: ReadonlySet<IntegrationSettingKey> = new Set([
  "smtp_password",
  "email_oauth_client_secret",
  "email_oauth_refresh_token",
  "linkedin_access_token",
  "linkedin_client_secret",
  "x_api_key",
  "x_api_secret",
  "x_access_token",
  "x_access_secret"
]);

export interface EmailConfig {
  enabled: boolean;
  fromName: string;
  fromEmail: string;
  host: string;
  port: number;
  username: string;
  password: string; // decrypted; "" if unset
  alertEmail: string;
  secure: boolean;
  authType: "password" | "oauth2";
  oauthClientId: string;
  oauthClientSecret: string; // decrypted; "" if unset
  oauthRefreshToken: string; // decrypted; "" if unset
  oauthUser: string;
}

export interface LinkedInConfig {
  enabled: boolean;
  accessToken: string; // decrypted; "" if unset
  tokenExpiresAt: number | null; // epoch ms
  authorUrn: string;
  autoPublish: boolean;
  clientId: string;
  clientSecret: string; // decrypted; "" if unset
}

export interface XConfig {
  enabled: boolean;
  apiKey: string; // decrypted; "" if unset
  apiSecret: string;
  accessToken: string;
  accessSecret: string;
  username: string;
  autoPublish: boolean;
}

let cache: { at: number; rows: Record<string, string> } | null = null;
const TTL_MS = 10_000;

async function readSettings(): Promise<Record<string, string>> {
  if (cache && Date.now() - cache.at < TTL_MS) return cache.rows;
  const rows: Record<string, string> = {};
  try {
    const r = await pool.query<{ key: string; value: string | null }>(`SELECT key, value FROM app_settings`);
    for (const row of r.rows) if (row.value != null && row.value !== "") rows[row.key] = row.value;
  } catch {
    // table may not exist yet — treat as empty.
  }
  cache = { at: Date.now(), rows };
  return rows;
}

function bool(v: string | undefined, dflt = false): boolean {
  if (v == null) return dflt;
  return v === "true" || v === "1";
}

function decryptOrEmpty(v: string | undefined): string {
  return v ? decryptSecret(v) : "";
}

/** Effective email config with the SMTP password / OAuth2 secrets decrypted. */
export async function getEmailConfig(): Promise<EmailConfig> {
  const s = await readSettings();
  const port = Number(s.smtp_port);
  return {
    enabled: bool(s.email_enabled),
    fromName: s.smtp_from_name ?? "",
    fromEmail: s.smtp_from_email ?? "",
    host: s.smtp_host ?? "",
    port: Number.isFinite(port) && port > 0 ? port : 587,
    username: s.smtp_username ?? "",
    password: decryptOrEmpty(s.smtp_password),
    alertEmail: s.smtp_alert_email ?? "",
    secure: bool(s.smtp_secure),
    authType: s.email_auth_type === "oauth2" ? "oauth2" : "password",
    oauthClientId: s.email_oauth_client_id ?? "",
    oauthClientSecret: decryptOrEmpty(s.email_oauth_client_secret),
    oauthRefreshToken: decryptOrEmpty(s.email_oauth_refresh_token),
    oauthUser: s.email_oauth_user ?? ""
  };
}

/** Effective LinkedIn config with the access token / client secret decrypted. */
export async function getLinkedInConfig(): Promise<LinkedInConfig> {
  const s = await readSettings();
  const expiresAt = Number(s.linkedin_token_expires_at);
  return {
    enabled: bool(s.linkedin_enabled),
    accessToken: decryptOrEmpty(s.linkedin_access_token),
    tokenExpiresAt: Number.isFinite(expiresAt) && expiresAt > 0 ? expiresAt : null,
    authorUrn: s.linkedin_author_urn ?? "",
    autoPublish: bool(s.linkedin_auto_publish),
    clientId: s.linkedin_client_id ?? "",
    clientSecret: decryptOrEmpty(s.linkedin_client_secret)
  };
}

/** Effective X config with the secrets decrypted. */
export async function getXConfig(): Promise<XConfig> {
  const s = await readSettings();
  return {
    enabled: bool(s.x_enabled),
    apiKey: decryptOrEmpty(s.x_api_key),
    apiSecret: decryptOrEmpty(s.x_api_secret),
    accessToken: decryptOrEmpty(s.x_access_token),
    accessSecret: decryptOrEmpty(s.x_access_secret),
    username: s.x_username ?? "",
    autoPublish: bool(s.x_auto_publish)
  };
}

/**
 * Admin view: all non-secret values plus a boolean `<field>Set` for each secret.
 * NEVER returns a secret value.
 */
export async function getIntegrationsMasked() {
  const s = await readSettings();
  const expiresAt = Number(s.linkedin_token_expires_at);
  return {
    // Email
    emailEnabled: bool(s.email_enabled),
    smtpFromName: s.smtp_from_name ?? "",
    smtpFromEmail: s.smtp_from_email ?? "",
    smtpHost: s.smtp_host ?? "",
    smtpPort: s.smtp_port ?? "",
    smtpUsername: s.smtp_username ?? "",
    smtpPasswordSet: !!s.smtp_password,
    smtpAlertEmail: s.smtp_alert_email ?? "",
    smtpSecure: bool(s.smtp_secure),
    emailAuthType: s.email_auth_type === "oauth2" ? "oauth2" : "password",
    emailOauthClientId: s.email_oauth_client_id ?? "",
    emailOauthClientSecretSet: !!s.email_oauth_client_secret,
    emailOauthRefreshTokenSet: !!s.email_oauth_refresh_token,
    emailOauthUser: s.email_oauth_user ?? "",
    // LinkedIn
    linkedinEnabled: bool(s.linkedin_enabled),
    linkedinAccessTokenSet: !!s.linkedin_access_token,
    linkedinTokenExpiresAt: Number.isFinite(expiresAt) && expiresAt > 0 ? expiresAt : null,
    linkedinAuthorUrn: s.linkedin_author_urn ?? "",
    linkedinAutoPublish: bool(s.linkedin_auto_publish),
    linkedinClientId: s.linkedin_client_id ?? "",
    linkedinClientSecretSet: !!s.linkedin_client_secret,
    // X
    xEnabled: bool(s.x_enabled),
    xApiKeySet: !!s.x_api_key,
    xApiSecretSet: !!s.x_api_secret,
    xAccessTokenSet: !!s.x_access_token,
    xAccessSecretSet: !!s.x_access_secret,
    xUsername: s.x_username ?? "",
    xAutoPublish: bool(s.x_auto_publish)
  };
}

export type IntegrationsMasked = Awaited<ReturnType<typeof getIntegrationsMasked>>;

/** Recipient for operational alert emails (expiring tokens): alertEmail, else fromEmail, else null. */
export async function getAlertRecipient(): Promise<string | null> {
  const c = await getEmailConfig();
  return c.alertEmail?.trim() || c.fromEmail?.trim() || null;
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/**
 * Upsert a batch of settings.
 *   - Secret keys: an empty/omitted value PRESERVES the stored secret (skip); a
 *     non-empty value is encrypted + upserted.
 *   - Non-secret keys: upsert the value; an empty string deletes the row.
 * Booleans should be passed as "true"/"false" by the caller.
 * Validates smtp_port (1–65535) and email fields when provided.
 */
export async function saveIntegrationSettings(patch: Partial<Record<IntegrationSettingKey, string>>): Promise<void> {
  const entries = Object.entries(patch).filter(([k]) =>
    (INTEGRATION_SETTING_KEYS as readonly string[]).includes(k)
  ) as [IntegrationSettingKey, string][];

  // Cheap validation before writing anything.
  for (const [key, value] of entries) {
    if (value === "") continue;
    if (key === "smtp_port") {
      const n = Number(value);
      if (!Number.isInteger(n) || n < 1 || n > 65535) {
        throw new Error("smtp_port must be an integer between 1 and 65535");
      }
    }
    if ((key === "smtp_from_email" || key === "smtp_alert_email") && !EMAIL_RE.test(value)) {
      throw new Error(`${key} must be a valid email address`);
    }
  }

  for (const [key, value] of entries) {
    const isSecret = SECRET_KEYS.has(key);
    if (isSecret) {
      if (value === "") continue; // blank-on-save preserves the stored secret
      const stored = encryptSecret(value);
      await pool.query(
        `INSERT INTO app_settings (key, value, updated_at) VALUES ($1,$2, now())
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`,
        [key, stored]
      );
    } else if (value === "") {
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
