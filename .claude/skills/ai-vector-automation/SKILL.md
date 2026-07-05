---
name: ai-vector-automation
description: The OXOT pgvector + Ollama embedding pipeline. Use when adding/retrieving embeddings, writing migrations for vector columns, or wiring the AI visitor agent's retrieval. Embeddings are Qwen3-4B, 4096-dim, stored in Postgres.
---

# AI Vector Automation

Owns the retrieval backbone for the interactive visitor agent.

## Invariants (do not change without a decision record in memory/)
- **Embedding model:** Ollama `qwen3-embedding:4b` (via `OLLAMA_EMBED_MODEL`).
- **Dimension:** `EMBED_DIM` env (native 2560 for qwen3-embedding:4b). The `vector(EMBED_DIM)` column, the assertion in `embeddings.ts`, and migration 001 must all match. Never hard-code 4096.
- **Store:** PostgreSQL + pgvector; file storage also in Postgres (`bytea`/large objects).

## Pipeline
1. **Chunk** source content (site pages, uploaded docs) into retrieval-sized pieces, tagged with `locale` (`nl`/`en`).
2. **Embed** each chunk via Ollama → 4096-dim vector.
3. **Store** in `content_chunks(id, page_id, locale, text, embedding vector(EMBED_DIM), source_ref)` with an HNSW or IVFFlat index.
4. **Query:** embed the query, filter by active `locale`, boost the visitor's current page, return top-k with citations.

## Rules
- Keep embedding + generation providers behind interfaces (Ollama primary, OpenRouter fallback for generation).
- Never store secrets; read `OLLAMA_HOST`, model names from env.
- Add a migration for any schema change; verify the index exists.
