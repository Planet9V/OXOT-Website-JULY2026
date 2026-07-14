-- SUPERSEDED by 035_embed_dim_1536.sql.
-- The original halfvec(2560) HNSW approach was abandoned: embeddings moved to 1536
-- dims (qwen3-embedding Matryoshka truncation), which is under pgvector's 2000-dim
-- HNSW cap, so a plain HNSW index is used instead (created in 035). Kept as a no-op
-- to preserve migration numbering (migrate.mjs runs every .sql on each deploy).
SELECT 1;
