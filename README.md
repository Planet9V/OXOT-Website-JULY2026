# OXOT Website

The bilingual (Dutch + English) website for **OXOT** — a Dutch Operational Technology (OT) cybersecurity consultancy that turns fragmented technical findings into clear, risk-based decisions, built around a **Cyber Digital Twin** and a focus on EU sovereignty.

It is a modern, mobile-first Next.js site with a small-team **admin CMS**, a Postgres/pgvector backend, an interactive AI visitor agent (local Ollama, OpenRouter fallback), and a content engine that renders long-form, cited, magazine-styled pages from Markdown — all editable by non-developers.

**Repo:** `Planet9V/OXOT-Website-JULY2026` (public) · **Docs:** see [`docs/wiki/`](docs/wiki/Home.md)

---

## What's in it

- **Bilingual site** — every page in `nl` and `en`, locale-prefixed routing (`/nl`, `/en`), enforced by a global stylesheet with dark/light mode.
- **Six deeply-researched EU framework guides** (en + nl) — NIS2, the Cyber Resilience Act, the AI Act, the Machinery Regulation, IEC 62443, and TS 50701 — each with sourced tables, inline SVG diagrams, callouts, carousels and an auto "On this page" nav.
- **Insights / blog** — long-form articles (e.g. the founder essay *"Fooled by Randomness"*).
- **Admin CMS** — a small team logs in to create/edit/delete pages, menus and SEO metadata per locale (publish requires both `nl` + `en`).
- **AI visitor agent** — consent-gated, retrieval-grounded chat (pgvector over site content, boosted to the current page), local Ollama first with OpenRouter fallback.
- **Brand system** — OXOT navy `#102030` + orange `#F07000`, editorial serif headlines; a built Cyber Digital Twin hero visual; a reusable [image style guide](docs/OXOT_BRAND_IMAGE_STYLEGUIDE.md).
- **Marketing kit** — campaign plan, LinkedIn/X posts and carousel scripts (en + nl), plus a self-contained **LinkedIn PDF carousel builder** at `/tools/carousel-builder.html`.

## Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js 15 (App Router, React 19), Tailwind CSS, global-token stylesheet (dark/light) |
| Content | Markdown → custom server renderer (tables, SVG, carousels, callouts, TOC); CMS bodies stored in Postgres |
| Backend | PostgreSQL 17 + **pgvector**, file storage in Postgres, Node `pg` |
| Embeddings | Ollama **`qwen3-embedding:4b`** (2560-dim, `EMBED_DIM`) |
| AI generation | Local Ollama (`qwen3.5:9b`) primary → **OpenRouter** automatic fallback (one `LLMProvider` interface) |
| Auth | scrypt + signed-cookie sessions (`AUTH_SECRET`) |
| Infra | Docker Compose (app + db); local dev uses the Mac's host Ollama via `docker-compose.override.yml` |
| Dev methodology | Karpathy rules (`CLAUDE.md` §1) + Superpowers (obra) |

## Quick start (local dev)

Prerequisites: Docker Desktop, and Ollama running on the host with `qwen3-embedding:4b` and `qwen3.5:9b` pulled.

```bash
cp .env.example .env.local      # set AUTH_SECRET (long random); OpenRouter/Valyu keys optional. NEVER commit this file.
docker compose up -d            # starts db + app (app runs `next dev` + an auto-seed watcher as its main process)
docker compose exec app npm run db:migrate   # applies migrations (creates the vector(2560) schema, CMS tables, SEO fields, menu)
docker compose exec app npm run seed:pages   # imports content/pages/**/*.md into the CMS
docker compose exec app npm run ingest       # embeds content/{nl,en}/*.md for the AI agent
docker compose exec app node scripts/create-admin.mjs you@oxot.example 'a-strong-password'
```

Then open **http://localhost:3000/en** (or `/nl`), and the admin at **/admin/login**.

> The `app` container runs the dev server as PID 1 alongside a watcher that re-imports `content/pages/**` on change — edit a Markdown page and it publishes itself within seconds. See [`docs/wiki/Deployment-Operations.md`](docs/wiki/Deployment-Operations.md).

## Repository layout

```
src/app/           Next.js routes ([locale] pages, [slug] CMS pages, blog, admin, api)
src/components/     markdown renderer, carousel, hero-visual, admin UI, agent chat widget
src/lib/            db, content queries, embeddings, retrieval, LLM provider, auth
db/migrations/      SQL (001 schema · 002 CMS · 003 seed · 004 SEO fields · 005 menu)
content/pages/      CMS page sources (en/nl Markdown + frontmatter) → seeded into Postgres
content/{nl,en}/    agent-embedding Markdown (retrieval corpus)
public/             media (CRA Annex A PDF), tools/carousel-builder.html
marketing/          campaign plan, LinkedIn/X posts + carousel scripts (en + nl)
docs/               ARCHITECTURE, HANDOFF, brand style guide, and the wiki/ (start here)
content-source/     internal source material (gitignored — never committed)
```

## Documentation (wiki)

Full admin + developer documentation lives in **[`docs/wiki/`](docs/wiki/Home.md)**:

- [Home](docs/wiki/Home.md) · [Architecture](docs/wiki/Architecture.md) · [Stack](docs/wiki/Stack.md)
- [Backend](docs/wiki/Backend.md) · [Frontend](docs/wiki/Frontend.md) · [Content authoring](docs/wiki/Content-Authoring.md)
- [Admin guide](docs/wiki/Admin-Guide.md) · [Developer guide](docs/wiki/Developer-Guide.md) · [Deployment & operations](docs/wiki/Deployment-Operations.md)
- [Marketing & carousel builder](docs/wiki/Marketing.md) · [Brand & image style guide](docs/OXOT_BRAND_IMAGE_STYLEGUIDE.md)

Also: [`CLAUDE.md`](CLAUDE.md) — project law (Karpathy rules, stack, i18n, agent) · [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · [`docs/HANDOFF.md`](docs/HANDOFF.md).

## How we work

`main` is the source of truth; changes land via pull request off `feature/*` / `fix/*` / `chore/*`. The repo is **public** — treat every commit as world-readable; secrets live only in `.env.local` (gitignored) and CI secrets. Both `nl` and `en` strings are required for any user-facing change.
