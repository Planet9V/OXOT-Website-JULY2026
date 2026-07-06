-- 008_inquiries.sql — turn contact_messages into managed, vectorized inquiries.
-- Adds a chat-session link, admin management fields, and a pgvector embedding so
-- inquiries are semantically searchable ("similar inquiries"). Idempotent.

ALTER TABLE contact_messages ADD COLUMN IF NOT EXISTS session_id   UUID;
ALTER TABLE contact_messages ADD COLUMN IF NOT EXISTS admin_note   TEXT;
ALTER TABLE contact_messages ADD COLUMN IF NOT EXISTS responded_at TIMESTAMPTZ;
ALTER TABLE contact_messages ADD COLUMN IF NOT EXISTS embedding    vector(__EMBED_DIM__);

CREATE INDEX IF NOT EXISTS contact_messages_session_idx ON contact_messages (session_id);
