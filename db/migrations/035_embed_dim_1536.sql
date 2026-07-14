-- Switch embeddings to EMBED_DIM (1536) via qwen3-embedding Matryoshka truncation.
-- (__EMBED_DIM__ is substituted by scripts/migrate.mjs from the EMBED_DIM env var.)
--
-- CONDITIONAL + idempotent: each block only acts when the live column dimension
-- differs from the target. So this migration is a total no-op while EMBED_DIM is
-- still 2560, and it never needlessly truncates data or thrashes the index on a
-- re-run. content_chunks is fully regenerable via re-ingest, so truncating it on the
-- dimension switch is safe; contact_messages embeddings are nulled (regenerable/
-- optional) so the column type can change.

-- content_chunks: retype only on a real dimension change.
DO $$
DECLARE cur int;
BEGIN
  SELECT (atttypmod - 4) INTO cur FROM pg_attribute
   WHERE attrelid = 'content_chunks'::regclass AND attname = 'embedding';
  IF cur IS DISTINCT FROM __EMBED_DIM__ THEN
    DROP INDEX IF EXISTS content_chunks_embedding_hnsw;
    TRUNCATE content_chunks;
    ALTER TABLE content_chunks ALTER COLUMN embedding TYPE vector(__EMBED_DIM__);
    RAISE NOTICE 'content_chunks.embedding retyped % -> % (re-ingest required)', cur, __EMBED_DIM__;
  END IF;
END $$;

-- contact_messages: same conditional retype (nullable, so just clear then alter).
DO $$
DECLARE cur int;
BEGIN
  SELECT (atttypmod - 4) INTO cur FROM pg_attribute
   WHERE attrelid = 'contact_messages'::regclass AND attname = 'embedding';
  IF cur IS DISTINCT FROM __EMBED_DIM__ THEN
    UPDATE contact_messages SET embedding = NULL WHERE embedding IS NOT NULL;
    ALTER TABLE contact_messages ALTER COLUMN embedding TYPE vector(__EMBED_DIM__);
  END IF;
END $$;

-- Plain HNSW cosine index now that dims are <= 2000 (no halfvec needed). Defensive:
-- if the column is still > 2000 dims (EMBED_DIM not yet flipped) or the pgvector
-- build lacks hnsw, skip rather than fail the migration run.
DO $$
BEGIN
  CREATE INDEX IF NOT EXISTS content_chunks_embedding_hnsw
    ON content_chunks USING hnsw (embedding vector_cosine_ops);
EXCEPTION WHEN others THEN
  RAISE NOTICE 'Skipped plain HNSW index (dims may exceed 2000 until EMBED_DIM flips): %', SQLERRM;
END $$;
