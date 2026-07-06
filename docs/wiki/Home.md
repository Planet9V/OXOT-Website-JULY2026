For: admins / developers — start here.

# OXOT Website Wiki

**OXOT** is a Dutch Operational Technology (OT) cybersecurity consultancy. This repo (`Planet9V/OXOT-Website-JULY2026`, public) is its bilingual (NL + EN) marketing site: a Next.js app with a small-team admin CMS, a Postgres/pgvector backend, and an interactive AI visitor agent (local Ollama, OpenRouter fallback) that answers questions grounded in site content.

This wiki is the map. Read [`CLAUDE.md`](../../CLAUDE.md) first if you're an AI coding agent — it contains the binding project rules (Karpathy rules win any conflict).

## Table of contents

| Page | For | What's in it |
|---|---|---|
| [Home](Home.md) | everyone | this page — orientation and index |
| [Architecture](Architecture.md) | developers | system design, data model, request flow, AI agent flow, trade-offs |
| [Stack](Stack.md) | developers | every technology, version, and *why* it was chosen |
| [Backend](Backend.md) | developers | DB schema, content/embeddings/retrieval/auth code, admin API with curl examples |
| [Frontend](Frontend.md) | developers | Next.js routes, components, i18n, styling, the chat widget |
| [Content-Authoring](Content-Authoring.md) | admins + developers | how Markdown becomes a live bilingual page (both content pipelines) |
| [Admin-Guide](Admin-Guide.md) | admins | day-to-day CMS use: login, pages, menus, publishing rules |
| [Developer-Guide](Developer-Guide.md) | developers | local setup, project conventions, PR flow, testing |
| [Deployment-Operations](Deployment-Operations.md) | developers + admins | Docker Compose, environment variables, migrations, the auto-seed watcher, backups |
| [Marketing](Marketing.md) | admins + marketing | campaign plan, LinkedIn/X assets, the carousel-builder tool |

Also outside the wiki: [`CLAUDE.md`](../../CLAUDE.md) (binding project rules), [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md) (original design doc), [`docs/HANDOFF.md`](../HANDOFF.md) (Cowork → Claude Code runbook), [`docs/OXOT_BRAND_IMAGE_STYLEGUIDE.md`](../OXOT_BRAND_IMAGE_STYLEGUIDE.md) (brand/image guide).

## 5-minute orientation — developers

1. **Read** [Architecture](Architecture.md) for the request flow and data model, then [Stack](Stack.md) for why each piece was chosen.
2. **Run it locally**: see [Developer-Guide](Developer-Guide.md) — `docker compose up -d`, then `db:migrate`, `seed:pages`, `ingest`, `create-admin.mjs`.
3. **Know the fixed points**: `EMBED_DIM=2560` (native `qwen3-embedding:4b` output — not 4096 as the original brief said), `pages` is `UNIQUE(slug, locale)`, publishing a page requires *both* `nl` and `en` rows to exist, `content_type` is `page` or `article`, the main nav lives in `menus.key = 'main'`.
5. **Every route/query lives in a small number of files**: `src/lib/db.ts` (pool), `src/lib/content.ts` (page/menu/article reads), `src/lib/embeddings.ts` + `src/lib/retrieval.ts` (agent grounding), `src/lib/llm/*` (Ollama → OpenRouter fallback), `src/lib/auth.ts` (admin auth). See [Backend](Backend.md).
6. **Before you change anything**: Karpathy rules in `CLAUDE.md` §1 — surgical changes, state assumptions, verify before claiming done. Both `nl` and `en` strings are required for any user-facing change.

## 5-minute orientation — admins

1. **Log in** at `/admin/login` with the email/password an engineer created via `scripts/create-admin.mjs`.
2. **Pages**: the admin dashboard (`/admin`) lists every page (slug + locale + type + published state). Add or edit a page with the form below the table — see [Admin-Guide](Admin-Guide.md) for every field, including the SEO fields (meta title, meta description, excerpt, OG image).
3. **Publishing rule**: a page cannot be marked "published" unless the *other* locale's version of the same slug already exists. Create both `nl` and `en` before you publish either.
4. **Menus**: the "Menu: main" panel under Pages edits the top navigation per locale (label, URL, position).
5. **Content edited as Markdown files** (in `content/pages/{en,nl}/*.md`) is auto-imported within seconds by a background watcher in the dev container — see [Content-Authoring](Content-Authoring.md).
6. **The AI chat widget** on the live site only answers from content that has been *ingested* (embedded) — ask a developer to run `npm run ingest` after adding agent-facing content in `content/{nl,en}/*.md` (a separate corpus from CMS pages).
