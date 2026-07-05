-- OXOT initial schema. Postgres + pgvector. Embeddings: qwen3-embedding:4b, EMBED_DIM (2560).
CREATE EXTENSION IF NOT EXISTS vector;

-- Site content, embedded per locale for the AI visitor agent's retrieval.
CREATE TABLE IF NOT EXISTS content_chunks (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  page_id     TEXT NOT NULL,
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  text        TEXT NOT NULL,
  embedding   vector(__EMBED_DIM__) NOT NULL,
  source_ref  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS content_chunks_locale_idx ON content_chunks (locale);
-- No ANN index: pgvector HNSW/IVFFlat cap at 2000 dims, but EMBED_DIM=2560.
-- Exact cosine search (embedding <=> query) is correct and fast for this small corpus.
-- To add ANN when content grows, switch the column to halfvec(2560) (HNSW supports halfvec
-- up to 4000 dims) and cast the query in retrieval.ts:
--   CREATE INDEX content_chunks_embedding_idx
--     ON content_chunks USING hnsw ((embedding::halfvec(2560)) halfvec_cosine_ops);

-- Consent-gated visitor sessions + behavioral signal stream.
CREATE TABLE IF NOT EXISTS visitor_sessions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  consent_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS visitor_events (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id  UUID NOT NULL REFERENCES visitor_sessions(id) ON DELETE CASCADE,
  type        TEXT NOT NULL,      -- page | click | scroll | dwell
  page_id     TEXT,
  element     TEXT,
  meta        JSONB,
  ts          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS visitor_events_session_idx ON visitor_events (session_id);

-- Agent conversation, with citations back to content_chunks.
CREATE TABLE IF NOT EXISTS agent_messages (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id      UUID NOT NULL REFERENCES visitor_sessions(id) ON DELETE CASCADE,
  role            TEXT NOT NULL CHECK (role IN ('system','user','assistant')),
  text            TEXT NOT NULL,
  cited_chunk_ids BIGINT[],
  provider        TEXT,           -- ollama | openrouter
  ts              TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- File storage in Postgres (per project brief).
CREATE TABLE IF NOT EXISTS files (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  filename     TEXT NOT NULL,
  content_type TEXT,
  bytes        BYTEA NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
