-- 006_contact.sql — contact enquiries submitted from /[locale]/contact. Idempotent.

CREATE TABLE IF NOT EXISTS contact_messages (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT        NOT NULL,
  email      TEXT        NOT NULL,
  company    TEXT,
  message    TEXT        NOT NULL,
  locale     TEXT        NOT NULL DEFAULT 'en',
  page       TEXT,
  ip_hash    TEXT,
  handled    BOOLEAN     NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS contact_messages_created_idx ON contact_messages (created_at DESC);
CREATE INDEX IF NOT EXISTS contact_messages_handled_idx ON contact_messages (handled, created_at DESC);
