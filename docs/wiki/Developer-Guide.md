For: developers

# Developer Guide

Setup, the day-to-day dev loop, and how-tos for the most common changes in this repo. For the
system-level picture see [Architecture](Architecture.md) and [Stack](Stack.md); for the
non-technical content workflow see [Admin-Guide](Admin-Guide.md) and
[Content-Authoring](Content-Authoring.md).

## 1. Setup

Everything runs in Docker (see [Deployment-Operations](Deployment-Operations.md) for the full
Compose breakdown). The short version:

```bash
cp .env.example .env.local     # fill in real values, never commit this file
docker compose up -d           # starts app (sleep infinity) + db (pgvector/pg17)
docker compose exec app npm install
docker compose exec app npm run db:migrate
docker compose exec app npm run seed:pages
docker compose exec app npm run ingest
docker compose exec app npm run dev
```

The repo also ships `.command` files in `scripts/` (see §7) that wrap this sequence into
double-clickable macOS launchers — `scripts/bring-up.command` does preflight checks (Docker
running, Ollama reachable on `localhost:11434` with `qwen3-embedding:4b` and `qwen3.5:9b`
pulled), then builds, migrates, ingests, and starts dev for you.

Once running, the app is at `http://localhost:3000`, and the admin panel at
`http://localhost:3000/admin`.

## 2. The npm scripts

Defined in `package.json`:

| Script | Command | What it does |
|---|---|---|
| `npm run dev` | `next dev` | Start the Next.js dev server (hot reload). |
| `npm run build` | `next build` | Production build. |
| `npm run start` | `next start` | Run a production build. |
| `npm run typecheck` | `tsc --noEmit` | Type-check the whole project without emitting files. **Run this before every PR.** |
| `npm run lint` | `next lint` | ESLint (Next's config). |
| `npm run i18n:check` | `node scripts/i18n-check.mjs` | Fails if `src/i18n/dictionaries/en.json` and `nl.json` don't have identical key sets. |
| `npm run db:migrate` | `node scripts/migrate.mjs` | Applies every `.sql` file in `db/migrations/` in filename order. |
| `npm run seed:pages` | `node scripts/seed-pages.mjs` | Imports `content/pages/<locale>/<slug>.md` into the `pages` table. |
| `npm run ingest` | `node scripts/ingest.mjs` | Chunks and embeds `content/<locale>/*.md` into `content_chunks` for the AI agent's retrieval. |
| `npm run claude:bootstrap` | `bash scripts/bootstrap-claude.sh` | Installs the Superpowers plugin marketplace + skills into the container's Claude Code. |

Run `typecheck` and `i18n:check` locally before opening a PR — CI runs both and will block on
failure.

## 3. How-to: add a CMS page via Markdown file

This is the file-based alternative to using the admin UI (see
[Admin-Guide](Admin-Guide.md#4-creating-or-editing-a-page)) — useful for bulk content, or
content you want reviewed in a PR diff.

1. Create `content/pages/en/<slug>.md` and `content/pages/nl/<slug>.md` (both locales — see
   `content/pages/en/nis2.md` for a full real example, including SVG diagrams and callouts).
2. Add YAML frontmatter:

```markdown
---
title: NIS2 for Operational Technology
meta_title: NIS2 Directive for OT & Industry | OXOT
meta_description: What NIS2 means for industrial and OT operators — scope, the ten Article 21 measures, reporting, penalties, and a practical roadmap.
excerpt: An OT-first field guide to NIS2.
content_type: page
published: true
---

Body content in Markdown goes here.
```

Recognized frontmatter keys (see `scripts/seed-pages.mjs`): `title`, `meta_title`,
`meta_description`, `excerpt`, `og_image`, `content_type` (`page` or `article`, defaults to
`page`), `published` (defaults to `true` — set `published: false` explicitly to keep it a
draft).

3. Import it:

```bash
npm run seed:pages
```

This is an idempotent upsert on `(slug, locale)` — safe to re-run any time you edit the file.
In local dev with `docker-compose.override.yml`, a background watcher already re-runs
`seed:pages` automatically whenever a file under `content/pages/**` changes (see
[Deployment-Operations](Deployment-Operations.md)), so you often don't need to run it by hand.

4. If the page should also feed the AI visitor agent's retrieval, add a corresponding file
   under `content/<locale>/<slug>.md` (not `content/pages/`) and run `npm run ingest` — this is
   a separate pipeline that chunks and embeds text into `content_chunks` (see §11 in
   [Architecture](Architecture.md) or the schema in
   [Deployment-Operations](Deployment-Operations.md)).

## 4. How-to: add a new framework page (App Router)

Static/framework pages under `/en/frameworks`, `/en/nis2`, etc. are rendered by the dynamic CMS
route (`src/app/[locale]/[slug]/page.tsx`), which fetches the published `pages` row for that
locale+slug and renders `page.body` through the custom Markdown renderer
(`src/components/markdown.tsx`). In most cases you do **not** need a new route file — adding a
new page is just adding a new `pages` row (via admin UI or a Markdown file, as above).

Only add a new file under `src/app/` when the page needs custom React (not just Markdown
content) — e.g. an interactive component, a form, or bespoke layout. In that case:

1. Create `src/app/[locale]/<route>/page.tsx` following the existing pattern: read `params`,
   validate the locale with `isLocale()` from `src/i18n/config.ts`, `notFound()` if invalid.
2. Add both `en` and `nl` copy — either as dictionary keys in
   `src/i18n/dictionaries/{en,nl}.json`, or by rendering per-locale content directly.
3. Run `npm run i18n:check` if you touched the dictionaries.
4. Add a menu entry if it should be navigable (see §6).

## 5. How-to: add a database migration

Migrations live in `db/migrations/*.sql` and are applied **in filename order** by
`scripts/migrate.mjs` — hence the `00N_description.sql` naming (`001_init.sql`,
`002_admin_cms.sql`, `003_seed_content.sql`, `004_seo_fields.sql`, `005_menu_insights.sql`).

Rules:
- **Name it `00N_<description>.sql`**, one number higher than the latest existing file.
- **Make it idempotent.** Every existing migration uses `IF NOT EXISTS` /
  `ON CONFLICT ... DO UPDATE` / `DO $$ BEGIN IF NOT EXISTS ... END $$` guards so the migration
  runner can be safely re-run. Follow that pattern — never assume a migration runs exactly once.
- If you need the embedding dimension, use the literal placeholder `__EMBED_DIM__` in your SQL
  (see `001_init.sql`'s `vector(__EMBED_DIM__)`) — `migrate.mjs` does a text substitution of
  `__EMBED_DIM__` → `process.env.EMBED_DIM` (2560) before executing.

Example skeleton (adding a column, following `004_seo_fields.sql`'s style):

```sql
-- 006_my_change.sql — short description. Idempotent.
ALTER TABLE pages ADD COLUMN IF NOT EXISTS my_field TEXT;
```

Apply it:

```bash
npm run db:migrate
```

## 6. How-to: add a menu item

Two ways:
- **Admin UI** — see [Admin-Guide](Admin-Guide.md#7-managing-menu-items). Simplest for one-off
  changes.
- **Seed migration** — for changes that should ship with a PR (so they're reviewable and apply
  consistently across environments), follow the pattern in `005_menu_insights.sql`: it deletes
  all `menu_items` for the `main` menu key and re-inserts the full list from a `VALUES` table,
  one row per `(locale, label, href, position)`. This "delete + reinsert" approach keeps the
  menu's order and full membership explicit and reviewable in a diff, rather than issuing
  incremental inserts.

Either way, the underlying tables are `menus` (a `key`, e.g. `'main'`) and `menu_items`
(`locale`, `label`, `href`, `position`, FK to `menus.id`) — see `002_admin_cms.sql`.

## 7. How-to: extend the Markdown renderer

Page bodies are rendered by `src/components/markdown.tsx` — a dependency-free, hand-written
parser (no `react-markdown`/`remark` in `package.json`). It already supports:

- Headings h1–h4 with slugified anchors, and an auto-generated table of contents when a page
  has 3+ `##` headings.
- Horizontal rules, lists, GFM tables.
- Callout blockquotes: `> [!NOTE]`, `> [!TIP]`, `> [!WARNING]`, `> [!IMPORTANT]`.
- Fenced code blocks with special handling by language tag:
  - ` ```svg ` — raw SVG rendered inline via `dangerouslySetInnerHTML` (wrapped in a `<figure>`).
  - ` ```carousel ` — parsed into slide data and rendered via a `Carousel` component.
  - ` ```html ` — raw HTML rendered via `dangerouslySetInnerHTML`.
  - anything else — a plain code block.
- Images and standard inline formatting (bold/italic/links/inline code) via an internal
  `parseInline` helper.

**Trust boundary:** the `svg` and `html` fence types use `dangerouslySetInnerHTML` on the
assumption that "content is authored by trusted admins" (see the doc comment in the file
itself). Do not expose Markdown body content from untrusted/public input through this renderer
without re-evaluating that assumption.

To add a new fence-language behavior (e.g. a new interactive block type), extend the
language-tag switch in `markdown.tsx` alongside the existing `svg`/`carousel`/`html` branches,
and add a matching component if it needs interactivity.

## 8. Running typecheck and i18n:check

```bash
npm run typecheck   # tsc --noEmit — must be clean before opening a PR
npm run i18n:check  # fails loudly listing exact missing keys per locale
```

`i18n:check` output on failure looks like:

```
Missing in nl: [ 'hero.ctaSecondary' ]
```

Fix by adding the missing key to the other locale's dictionary file under
`src/i18n/dictionaries/`, then re-run.

## 9. PR flow

Per the repo's [CLAUDE.md](../../CLAUDE.md) (binding project rules):

1. Branch off `main` using `feature/*`, `fix/*`, or `chore/*` naming.
2. Make surgical changes — only touch what the task requires.
3. Run `npm run typecheck` and `npm run i18n:check` (and `npm run lint` where relevant) locally.
4. Open a PR against `main`. Fill in the PR template, including a running **assumptions list**.
5. `main` is protected — PRs need green CI plus review before merge.
6. Link the PR to its GitHub Issue with `Closes #n` where applicable.

The repo's `.command` scripts (see §10) automate parts of this — e.g.
`scripts/ship-dutch-qa.command` explicitly gates on `npm run typecheck` passing before it will
commit or merge anything.

## 10. The `.command` helper-script pattern

`scripts/*.command` are double-clickable macOS launchers (`#!/usr/bin/env bash` under the hood
— Finder runs `.command` files in Terminal on double-click). They exist so non-terminal-fluent
teammates, or anyone who wants a one-click action, can trigger a scripted Docker/git workflow
without typing commands.

Examples in this repo:

| Script | Purpose |
|---|---|
| `bring-up.command` | Preflight-check Docker + Ollama, build/start Compose, run migrate + ingest, start dev. |
| `init-repo.command` | First-time repo/environment initialization. |
| `seed-content.command` / `apply-content.command` | Re-run content seeding. |
| `restart-app.command` / `diag-restart.command` | Restart the app container; diagnostics on restart. |
| `pr-content.command`, `pr-frameworks.command`, `pr-cra-blog.command`, `pr-brand.command`, `pr-marketing.command` | Stage/commit/push a themed slice of work and open (or update) a PR via `gh`. |
| `merge-pr.command` | Stage relevant paths, commit, push, and merge a specific PR via `gh pr merge`. |
| `ship-dutch-qa.command` | Gate on `npm run typecheck`, then commit/merge a QA branch. |

Conventions to follow if you add a new one:
- Start with `#!/usr/bin/env bash` and `set -euo pipefail`.
- Log output to a `*.log` file (existing scripts redirect their own output for later
  inspection) rather than only printing to the terminal.
- Keep them idempotent/safe to double-click more than once — check state before mutating
  (e.g. check if a branch/PR already exists before creating another).
- Prefer calling the existing npm scripts (`db:migrate`, `seed:pages`, `ingest`, `typecheck`)
  rather than duplicating their logic.

## Quick reference

| Task | Command |
|---|---|
| Start everything | `docker compose up -d` then `docker compose exec app npm run dev` (or double-click `bring-up.command`) |
| Apply migrations | `npm run db:migrate` |
| Import Markdown pages | `npm run seed:pages` |
| Re-embed agent content | `npm run ingest` |
| Type-check | `npm run typecheck` |
| Check locale parity | `npm run i18n:check` |
| Create/reset an admin login | `node scripts/create-admin.mjs email password` |
