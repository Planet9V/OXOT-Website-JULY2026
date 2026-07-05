# Decisions log

- 2026-07-02 — Repo: Planet9v/OXOT-Website-JULY2026, public.
- 2026-07-02 — Superpowers via obra/superpowers-marketplace.
- 2026-07-02 — Memory: shared, committed, union-merge.
- 2026-07-02 — Valyu: full stack (skill + MCP + SDK) in Docker.
- 2026-07-02 — Generation: local Ollama primary, OpenRouter fallback.
- 2026-07-02 — Embeddings: Ollama Qwen3-4B, 4096-dim, in Postgres/pgvector.
- 2026-07-02 — Native NL + EN mandatory for all user-facing strings.
- 2026-07-02 — Claude Code runs in the `app` dev container (default).
- 2026-07-02 — release.yml builds+pushes image to GHCR only (no deploy yet).
- 2026-07-02 — Scaffolded: Next.js app (nl/en routing, global-token stylesheet, dark/light), lib (db/embeddings/LLM provider w/ Ollama→OpenRouter fallback), pgvector migration 001, agent API (/api/agent stream + citations, /api/session, /api/events consent-gated), retrieval (locale filter + page boost), content ingestion (content/{nl,en} + scripts/ingest.mjs), chat widget (consent + streaming + click/page beacons). Not yet run: npm install / tsc / next build (run in container/CI).
- 2026-07-02 — Superpowers: auto-install via scripts/bootstrap-claude.sh + devcontainer postCreate (claude plugin CLI, --scope project). Karpathy installed as CLAUDE.md law + .claude/skills/karpathy-guidelines.
- 2026-07-02 — Admin/CMS scaffolded: migration 002 (admin_users, pages, menus, menu_items), auth.ts (scrypt + signed-cookie session, AUTH_SECRET), /api/admin/{login,logout,pages,menu-items}, /admin login + guarded dashboard, PagesManager UI. Publish requires both nl+en. create-admin.mjs seeds users.
- 2026-07-02 — Embedding dimension: REAL model qwen3-embedding:4b emits 2560-dim (not 4096 as the brief stated). Made dim env-driven: EMBED_DIM (default 2560) used by embeddings.ts, ingest.mjs, and migration 001 (vector(__EMBED_DIM__) substituted by migrate.mjs). Chat model default set to qwen3:4b. CONFIRM exact tags + dim against the running Ollama and set EMBED_DIM in .env.local before migrating.
- 2026-07-02 — Generation default set to local Ollama qwen3.5:9b (installed on the box), env OLLAMA_CHAT_MODEL. Embeddings qwen3-embedding:4b @ 2560-dim. OpenRouter remains automatic fallback.
- 2026-07-02 — .claude/settings.json now declares Superpowers via extraKnownMarketplaces (obra/superpowers-marketplace) + enabledPlugins {superpowers@superpowers-marketplace:true}. Corrected auto-memory keys to real schema: autoMemoryEnabled + autoMemoryDirectory=./memory (previously used a wrong "memory" object). When the repo folder is trusted in Claude Code it prompts to install; or run: claude plugin install superpowers@superpowers-marketplace.
- 2026-07-02 — Added docs/ARCHITECTURE.md (system-design: reqs, data model, API contracts, retrieval/gen flow, scale, trade-offs, revisit list) and docs/HANDOFF.md (Cowork→Claude Code runbook). Biggest known gap before build: NO TESTS yet (DoD requires TDD) — first Claude Code task.
- 2026-07-02 — GREEN BASELINE verified (in sandbox, local disk): npm install OK (376 pkgs), tsc --noEmit = 0 errors, `next build` = success (14 routes: /nl,/en SSG; [slug]/admin/api dynamic; middleware built). Scaffold is type-clean and builds. Added next-env.d.ts (gitignored per Next convention). NOTE: the node_modules created on the Downloads mount got corrupted by interrupted installs on the network FS — delete it locally (`rm -rf node_modules`) before `npm install`. Build must run on a normal/local FS or inside the container, not directly on the flaky mount.
