-- 039_cra_intake.sql — CRA readiness intake leads (segmented funnel: manufacturer,
-- oem, integrator, reseller, operator). Idempotent.
--
-- REVERSAL: DROP TABLE IF EXISTS cra_readiness_leads; (drops its indexes with it).
-- No other tables/columns are touched by this migration.

CREATE TABLE IF NOT EXISTS cra_readiness_leads (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  segment            TEXT NOT NULL,
  stage              TEXT NOT NULL DEFAULT 'new',
  tags               TEXT[] NOT NULL DEFAULT '{}',
  name               TEXT NOT NULL,
  email              TEXT NOT NULL,
  company            TEXT,
  role               TEXT,
  answers            JSONB NOT NULL DEFAULT '{}',
  blocker            TEXT,
  locale             TEXT NOT NULL DEFAULT 'en',
  page               TEXT,
  utm                JSONB NOT NULL DEFAULT '{}',
  ip_hash            TEXT,
  session_id         UUID,
  scheduling_status  TEXT NOT NULL DEFAULT 'none',
  scheduled_at       TIMESTAMPTZ,
  handled            BOOLEAN NOT NULL DEFAULT false,
  admin_note         TEXT,
  responded_at       TIMESTAMPTZ,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  embedding          vector(__EMBED_DIM__)
);

CREATE INDEX IF NOT EXISTS cra_readiness_leads_created_idx ON cra_readiness_leads (created_at DESC);
CREATE INDEX IF NOT EXISTS cra_readiness_leads_stage_idx   ON cra_readiness_leads (stage, created_at DESC);
CREATE INDEX IF NOT EXISTS cra_readiness_leads_segment_idx ON cra_readiness_leads (segment, created_at DESC);
CREATE INDEX IF NOT EXISTS cra_readiness_leads_session_idx ON cra_readiness_leads (session_id);

-- Guarded HNSW cosine index (same guard as 035): dims are <= 2000 under EMBED_DIM
-- 1536, so a plain HNSW index applies; skip rather than fail if the pgvector build
-- lacks hnsw or the column is unexpectedly oversized.
DO $$
BEGIN
  CREATE INDEX IF NOT EXISTS cra_readiness_leads_embedding_hnsw
    ON cra_readiness_leads USING hnsw (embedding vector_cosine_ops);
EXCEPTION WHEN others THEN
  RAISE NOTICE 'Skipped plain HNSW index on cra_readiness_leads (dims may exceed 2000 until EMBED_DIM flips): %', SQLERRM;
END $$;
