-- App settings — admin-editable runtime config (AI providers / models).
-- Simple key/value store; values are read at request time and merged over .env
-- defaults (env stays the fallback). Secrets (e.g. OpenRouter key) live here, not
-- in the client. Secure the database at rest.
CREATE TABLE IF NOT EXISTS app_settings (
  key        TEXT PRIMARY KEY,
  value      TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
