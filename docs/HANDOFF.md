# HANDOFF — Cowork → Claude Code

Read this first when you open the repo in Claude Code. It's the runbook to go from "scaffold in a folder" to "running app," plus exactly what's done and what's left.

## Current state (as of 2026-07-02)
- Full scaffold committed-ready in this folder (~80 files). Verified: JSON valid, all TS/TSX transpile (esbuild), `@/` imports resolve, i18n nl/en balanced, SQL migrations balanced, no secrets committed.
- **Not yet run** (needs your machine/container): `npm install`, `tsc`, `next build`, `docker compose up`, DB migrate/ingest, `git push`, admin creation.
- Superpowers installed + verified in the Cowork sandbox (proof it works); **re-run on your machine** so it's local and persistent.

## Prerequisites
- Docker + Docker Compose, `git`, `gh` (logged in as `Planet9v`), Claude Code (v2.1.195+), and your local Ollama with `qwen3.5:9b` + `qwen3-embedding:4b` already pulled.

## First session — step by step
```bash
cd OXOT_Website_JULY2026
claude                     # trust the folder → prompts to install Superpowers
# If Superpowers was just installed, quit and relaunch `claude` — plugin changes apply on
# restart (there is NO /reload-plugins). Verify with: claude plugin list  (should show "enabled").

# 1. secrets (never commit .env.local)
cp .env.example .env.local
#   set AUTH_SECRET (long random), OPENROUTER_API_KEY, VALYU_API_KEY
#   confirm OLLAMA_CHAT_MODEL / OLLAMA_EMBED_MODEL match `ollama list`

# 2. bring up the stack
docker compose build && docker compose up -d

# 3. database + content
docker compose exec app npm install
docker compose exec app npm run db:migrate      # creates vector(2560) schema
docker compose exec app npm run ingest          # embeds content/{nl,en}/*.md
docker compose exec app node scripts/create-admin.mjs you@oxot.example 'strong-password'

# 4. run + verify
docker compose exec app npm run dev             # http://localhost:3000 -> /en or /nl
docker compose exec app npm run typecheck       # the real green light
docker compose exec app npm run build

# 5. push (public repo) + tracking
bash scripts/init-repo.sh
```

## Verify it works
- `/en` and `/nl` render; theme toggle switches dark/light.
- `/admin/login` → dashboard; create an `en` + `nl` page, publish (publish is blocked unless both locales exist), see it at `/en/<slug>`.
- Chat widget: accept consent → ask a question → streamed, grounded answer (needs ingested content).
- `npm run i18n:check` passes; CI green on first PR.

## Rollback / recovery
- App issues: `docker compose down` (keeps volumes) → fix → `up`. Full reset: `docker compose down -v` (drops `pgdata`, `ollama`, `oxot_memory` — you re-migrate/ingest).
- Bad migration: migrations are idempotent (`IF NOT EXISTS`); write a new `00X_*.sql` to change schema, never edit an applied one.
- Superpowers skills missing: run `claude plugin install superpowers@superpowers-marketplace`, then quit and relaunch `claude` (restart applies plugin changes — there is no `/reload-plugins`). If still missing, `rm -rf ~/.claude/plugins/cache` and reinstall.

## What's left to build (suggested order, via superpowers:writing-plans → TDD)
1. **Tests** — the scaffold has none yet; DoD requires TDD. Start with `lib/` (retrieval, auth, llm fallback) and API routes.
2. **Contact page + form** (bilingual) — common professional-services need.
3. **Public menu wiring** — seed the `main` menu; link pages into nav.
4. **Agent polish** — proactive vs. reactive, low-confidence UX, scroll/dwell beacons (only page+click wired now).
5. **GitHub issues + Project board** — seed from §"What to revisit" in `docs/ARCHITECTURE.md`.
6. **Observability + caching** — see ARCHITECTURE §6/§8.

## Map of the repo
- `CLAUDE.md` — binding rules (Karpathy wins). `SETUP_PLAN.md` — setup narrative. `docs/ARCHITECTURE.md` — system design.
- `.claude/skills/` — project skills (karpathy-guidelines, website-alignment, ai-vector-automation, business-analyst, i18n-nl-en).
- `src/app` (routes + api), `src/lib` (db, embeddings, llm, retrieval, content, auth, ingest), `src/components` (ui, agent, admin).
- `db/migrations` — SQL. `scripts` — migrate, ingest, create-admin, bootstrap-claude, init-repo. `content/{nl,en}` — seed pages.

## Who/what to ask
- Architecture decisions → `docs/ARCHITECTURE.md` + `memory/decisions.md` (shared team brain).
- "How do we work" → `CLAUDE.md` §5 (PR flow) + Superpowers skills.
