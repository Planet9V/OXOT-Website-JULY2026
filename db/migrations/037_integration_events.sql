-- Unified activity/observability log for the admin Integrations console. Every
-- integration (email / linkedin / x) writes a best-effort event here so the
-- admin gets one reverse-chronological feed spanning config saves, verify/test
-- checks, OAuth callbacks, sends, posts, and token-expiry warnings. Complements
-- `social_posts` (per-post outcomes, migration 030) — the activity endpoint
-- merges both. Idempotent: CREATE TABLE IF NOT EXISTS.

CREATE TABLE IF NOT EXISTS integration_events (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  integration TEXT NOT NULL CHECK (integration IN ('email','linkedin','x')),
  kind       TEXT NOT NULL,
  success    BOOLEAN NOT NULL DEFAULT true,
  detail     TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS integration_events_created_at_idx ON integration_events (created_at DESC);
CREATE INDEX IF NOT EXISTS integration_events_integration_idx ON integration_events (integration, created_at DESC);
