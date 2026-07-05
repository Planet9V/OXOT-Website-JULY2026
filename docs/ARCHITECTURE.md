# OXOT Website — System Design

**Repo:** `Planet9v/OXOT-Website-JULY2026` (public) · **Runtime:** Docker · **Status:** scaffold complete, pre-first-boot
This is the authoritative architecture reference. `SETUP_PLAN.md` holds the setup/plan narrative; `CLAUDE.md` holds the binding rules. On conflict, `CLAUDE.md` §1 (Karpathy) wins.

---

## 1. Requirements

### Functional
- Public, bilingual (NL + EN) professional-services website; content managed via a small-team admin/CMS (pages + menus).
- Interactive AI visitor agent: answers questions grounded in site content, aware of the page the visitor is on, in the visitor's language.
- Consent-gated capture of behavioral signals (page/click/scroll/dwell) to inform the agent.

### Non-functional
- **Latency:** agent first token target < 1.5s (local model on-box).
- **Availability:** generation degrades gracefully (local Ollama → OpenRouter fallback).
- **Privacy:** EU/NL — no behavioral capture before consent; data stays on-box by default.
- **Cost:** local-first (Ollama) to avoid per-token cost; hosted fallback only when needed.
- **Maintainability:** small senior team; simplicity over cleverness (Karpathy YAGNI).

### Constraints
- Fixed stack (project brief): Next.js + Tailwind + shadcn/ui, PostgreSQL + pgvector (files in Postgres), Ollama embeddings, Docker, GitHub PR flow.
- Every user-facing string must exist in both locales.

---

## 2. High-Level Design

```
                         ┌─────────────────────────────────────────────┐
   Visitor (browser)     │                Next.js app                   │
   /nl or /en            │  (App Router, RSC + client components)       │
   ┌───────────────┐     │                                              │
   │ Pages + Nav   │◀────┤ SiteNav, [locale]/[slug] (CMS render)        │
   │ ChatWidget    │────▶│ /api/session  /api/events  /api/agent        │
   └──────┬────────┘     │        │           │            │            │
          │ SSE/stream   │        ▼           ▼            ▼            │
          │              │  auth/consent   ingest events  orchestrator  │
          │              │                                 │            │
          │              │   retrieval ◀───────────────────┘            │
          │              │      │  embeddings          generation        │
          └──────────────┤      ▼      │                  │              │
                         └──────┼──────┼──────────────────┼─────────────┘
                                ▼      ▼                  ▼
                         ┌──────────┐ ┌──────────┐  ┌──────────────────┐
                         │ Postgres │ │  Ollama  │  │ Ollama (primary) │
                         │ pgvector │ │ embed    │  │  → OpenRouter     │
                         │ + files  │ │ qwen3-4b │  │    (fallback)     │
                         └──────────┘ └──────────┘  └──────────────────┘
```

**Containers (docker-compose):** `app` (Next.js + Claude Code dev), `db` (`pgvector/pgvector:pg17`), `ollama` (embeddings + generation). Shared named volume `oxot_memory` for the team brain.

---

## 3. Data Model (Postgres + pgvector)

`vector(EMBED_DIM)` where **EMBED_DIM = 2560** (native `qwen3-embedding:4b`). Migration 001 templates the dimension; `migrate.mjs` substitutes it at apply time.

| Table | Purpose | Key columns |
|---|---|---|
| `content_chunks` | embedded site content for retrieval | `page_id, locale, text, embedding vector(2560), source_ref`; HNSW cosine index; locale index |
| `visitor_sessions` | consent-gated sessions | `id uuid, locale, consent_at` |
| `visitor_events` | behavioral stream | `session_id, type(page/click/scroll/dwell), page_id, element, meta jsonb, ts` |
| `agent_messages` | conversation + provenance | `session_id, role, text, cited_chunk_ids bigint[], provider, ts` |
| `files` | file storage in Postgres | `filename, content_type, bytes bytea` |
| `admin_users` | CMS auth | `email unique, password_hash` (scrypt `salt:hash`) |
| `pages` | CMS pages per locale | `unique(slug, locale), title, body, published` |
| `menus` / `menu_items` | navigation per locale | `menu.key`, `menu_items(locale,label,href,position)` |

---

## 4. API Contracts

| Endpoint | Method | Auth | Behavior |
|---|---|---|---|
| `/api/session` | POST / PATCH | none | create session (optional consent) / grant consent |
| `/api/events` | POST | consent required (403 otherwise) | store a behavioral event |
| `/api/agent` | POST | consent required | retrieve → grounded bilingual prompt → **stream** answer; persists user+assistant turns with citations + provider. Citations also in `x-agent-citations` header |
| `/api/admin/login` \| `/logout` | POST | credentials | scrypt verify → signed-cookie session (8h) |
| `/api/admin/pages` | GET/POST/DELETE | admin cookie | list / upsert (publish requires both locales) / delete |
| `/api/admin/menu-items` | GET/POST/DELETE | admin cookie | list / add / delete menu items |

**Agent request:** `{ sessionId, message, locale, pageId }` → `text/plain` stream.

---

## 5. Deep Dive — retrieval + generation

1. **Retrieval** (`lib/retrieval.ts`): embed query → pgvector cosine distance, **filtered by active locale**, **boosted toward the current page** (`page_id` match subtracts a small distance bonus), top-k.
2. **Grounding**: system prompt injects retrieved chunks with `[id]`s; instructs answer-in-locale, cite sources, and admit uncertainty rather than invent (Karpathy rule 6).
3. **Generation** (`lib/llm/`): `chatStream` streams from local Ollama (NDJSON); on any failure it falls back to OpenRouter and streams that. One `LLMProvider` interface — the fallback is a single policy, not scattered conditionals.
4. **Persistence**: assistant turn saved with `cited_chunk_ids` + which `provider` served it.

---

## 6. Scale & Reliability

- **Load estimate (initial):** small-business traffic; single `app` + single `db` + single `ollama` suffice. Ollama concurrency is the first bottleneck for generation.
- **Scaling path:** `app` is stateless behind the DB → scale horizontally; move `ollama` to a dedicated GPU host; add pgBouncer if connection count climbs; consider IVFFlat vs HNSW tuning as `content_chunks` grows.
- **Failover:** generation already fails over to OpenRouter. DB and Ollama are single points today (acceptable for launch; note below).
- **Provenance:** CI builds image → GHCR tagged by git SHA; running container traces to a commit.
- **Monitoring (to add):** health checks per service, request/latency metrics on `/api/agent`, Ollama up/down signal to drive fallback proactively.

---

## 7. Trade-offs (explicit)

| Decision | Why | Trade-off / cost |
|---|---|---|
| **Local Ollama primary** | privacy, zero per-token cost, low latency on-box | single host = capacity ceiling; needs fallback (have it) |
| **Files in Postgres (bytea)** | brief requirement; one backup surface, transactional | bloats DB, no CDN; revisit with object storage if media grows |
| **2560-dim (not 4096)** | matches the real installed model | brief said 4096; corrected to real data — env-driven so changeable |
| **Signed-cookie sessions (no lib)** | zero deps, simple for a small team | no server-side revocation list; fine at this scale |
| **`force-dynamic` locale routes** | menus/pages are DB-driven, always fresh | loses static caching; add ISR/caching if traffic grows |
| **Superpowers + Karpathy methodology** | disciplined TDD/PR flow | Claude Code-native; not fully usable from Cowork |

---

## 8. What to revisit as it grows

- **Caching:** ISR or a cache layer for published CMS pages and menus once traffic is real.
- **Media:** move large files from Postgres to object storage (S3/MinIO) if media becomes heavy.
- **Ollama HA:** dedicated GPU node + queue; proactively route to OpenRouter under load, not just on failure.
- **Retrieval quality:** evaluate chunk size, hybrid (keyword + vector) search, and re-ranking.
- **AuthZ:** roles beyond a single admin tier; audit log for CMS edits.
- **Observability:** structured logs, latency SLOs on `/api/agent`, alerting.

---

## 9. Open design questions (for the first Claude Code brainstorm)

- Proactive vs. reactive agent (may it open the conversation?).
- Exact local generation tag (`qwen3.5:9b` per the box) and OpenRouter fallback model tier.
- Personalization aggressiveness before it feels intrusive.
- Anonymous sessions only, or link to a CRM/admin identity.
