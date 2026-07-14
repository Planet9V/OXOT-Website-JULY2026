-- Phase 1 (ICE #1): ANN index for pgvector similarity on content_chunks.
--
-- EMBED_DIM is 2560. Plain pgvector HNSW/IVFFlat cap at 2000 dims, so we index the
-- halfvec(2560) cast (HNSW supports halfvec up to 4000 dims) with cosine ops — the
-- exact path documented in 001_init.sql. retrieval.ts casts the query to the same
-- halfvec(2560) so the planner can use this index; it re-ranks the small candidate
-- set in JS to apply the current-page boost.
--
-- Defensive: if the installed pgvector predates halfvec/hnsw, we skip the index
-- (exact sequential cosine search still works and stays correct) rather than fail
-- the whole migration run. Idempotent: IF NOT EXISTS + guarded.
DO $$
BEGIN
  CREATE INDEX IF NOT EXISTS content_chunks_embedding_hnsw
    ON content_chunks USING hnsw ((embedding::halfvec(2560)) halfvec_cosine_ops);
EXCEPTION WHEN others THEN
  RAISE NOTICE 'Skipped HNSW halfvec index (pgvector may lack halfvec/hnsw): %', SQLERRM;
END $$;
