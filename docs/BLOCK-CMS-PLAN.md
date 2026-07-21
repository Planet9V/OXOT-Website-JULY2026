# Implementation Plan — Block/Section Page Builder CMS (CDT + Conformity under unified CMS)

**Repo:** `OXOT_Website_JULY2026` (Next.js 15 App Router, Postgres/pgvector, EN+NL)
**Scope:** Turn the Markdown-only Pages CMS into a block/section builder; bring **Cyber Digital Twin** and **Conformity** under it with **zero content loss**. **Home (`/`, CRA landing) is out of scope.**
**Status:** PLAN ONLY — no code written or edited. Grounded against the codebase with file:line citations; Karpathy rules applied.

---

## A. Goals / Non-goals

**Goals**
1. Extend the admin "Pages" CMS from Markdown-body editing to composing pages from ordered **interactive blocks** (a palette of typed section components), keeping a rich-text/Markdown block so prose stays editable.
2. Bring `/[locale]/cyber-digital-twin` and `/[locale]/conformity` under this CMS so they are listed, published, SEO-managed and menu-placed like every other page — **preserving byte-for-byte the current rendered output** (all interactive widgets included).
3. Preserve the existing zero-loss guarantees (`page_versions` snapshot-before-write) and extend them to block content.

**Non-goals**
- The Home page (`src/app/[locale]/page.tsx`, `src/lib/cra-home.ts`, `CraHomeEditor`, admin key `"cra-home"`) — **untouched**.
- No visual redesign. No change to `conformity_*` data tables, `carousel_slides`, or the i18n dictionaries' render paths.
- No hard deletion of any existing row (markdown `cyber-digital-twin` included).

---

## B. Verified current-state analysis (with corrections)

### System 1 — Markdown CMS (confirmed)
- Table `pages` — `db/migrations/002_admin_cms.sql:10` (`UNIQUE(slug,locale)`, `body TEXT`); SEO cols in `004_seo_fields.sql:3-8` and `032_affiliate_seo.sql:63-67`. **Load-bearing CHECK** `pages_content_type_chk CHECK (content_type IN ('page','article'))` at `004_seo_fields.sql:12`.
- Rendered by `src/app/[locale]/[slug]/page.tsx` via `MarkdownContent` + `extractToc` (`:5,96,125`); reads `getPublishedPage()` (`src/lib/content.ts:24`).
- Managed by `src/components/admin/pages-manager.tsx` → `/api/admin/pages`, `/api/admin/menu-items`, `/api/admin/pages/translate`, `/api/admin/pages/restore`, `/api/admin/pages/versions`.
- Zero-loss: `snapshotCurrent()` (`src/lib/page-versions.ts:33`) + `page_versions` (`036_page_versions.sql:5`); POST snapshots before upsert (`route.ts:71-78`), DELETE before delete (`:131-140`), restore before overwrite (`page-versions.ts:129`).

### System 2 — Structured/coded pages (confirmed + corrections)
- **Table `site_blocks`** (`007_site_blocks.sql:4`): `PRIMARY KEY (key, locale)`, single `data JSONB` per key+locale. **No ordering, no draft/publish, no version linkage.**
- **CDT:** `src/lib/cdt.ts` — type `CDT` (`:271`), `CDT_HOME_KEY="cdt_home"` (`:285`), `getCdt()` (`:295`), `saveCdt()` (`:314`). Defaults `data/cdt_en.json`/`cdt_nl.json`. Route renders **11 sections** from `src/components/cdt/sections.tsx`: `Hero, StatBand, LivingModel, Boms, Drilldown, Consequence, Priority, MonteCarlo, Methodology, Outcomes, FinalCta` (`page.tsx:8-20,59-75`).
  - **Correction:** 11 sections, not ~8 (`Methodology, Outcomes, FinalCta` were missed). Interactive leaves: `seven-layer-graph.tsx`, `bom-drilldown-table.tsx`, `priority-matrix.tsx`, `monte-carlo-viz.tsx` (all `"use client"`), imported by the **server** `sections.tsx` (`:11-14`).
- **Conformity:** `src/lib/conformity-home.ts` — `ConformityHome` (`:110`), `CONFORMITY_HOME_KEY="conformity_home"` (`:124`), `getConformityHome()` (`:134`). Route `src/app/[locale]/conformity/page.tsx`.
  - **Correction/addition — THREE data sources, not one:** (1) `site_blocks conformity_home` → `Hero, RegulationBand, Stats, Platform, Problem, Shift, Comparison, HowItWorks, Testimonial, FinalCta` + inline FAQ; (2) **i18n dictionary** `c.carousel` → `ConsultingCarousel` (NOT in site_blocks); (3) **DB tables** — `getSummary()` (`src/lib/conformity.ts`) drives the KPI attrs, and Hero's `HeroCarousel` reads `carousel_slides` (migration 033) with static fallback. "Zero loss" for Conformity therefore spans site_blocks + dictionary + two DB tables.
  - `conformity-home.ts:8` docstring ("live front door at `/[locale]`") is **stale** — front door is now CRA home. Cleanup only.
- **Orphan `home` key:** `src/lib/site-content.ts` (`HOME_KEY="home"`), rendered only by `src/app/[locale]/industrial-operations/page.tsx`, which 308-redirects to `/cyber-digital-twin` (`next.config.mjs:35-39`). Dead for users but still code-live (import + grounding corpus `reindex/route.ts:45`). **Leave out of scope.**

### Stale duplicate (confirmed)
- Markdown `pages` row `slug='cyber-digital-twin'` seeded `published=true` in `003_seed_content.sql:75,92`. `040_consolidate_approach_into_cdt.sql:37-54` snapshotted it but did **not** delete it (`:5-7`). Shadowed by the static route; still appears/edits inertly in `pages-manager.tsx` (no coded-slug filter); `published=true` so emitted in sitemap via `listPublishedRefs()` (`content.ts:90`).
- **No `pages` row for `slug='conformity'`** — confirmed.

### Toolchain (confirmed)
- `scripts/migrate.mjs` ledger `schema_migrations`; latest is `041_conformity_fixes.sql`; **next file `042_*`**.
- `next.config.mjs:14-15` ignores eslint+ts in build → run `npm run typecheck` + `npm run build` explicitly (`build` = `check-sql.mjs && next build`).
- Grounding: `reindex/route.ts` reads published `pages` + `SITE_BLOCK_SOURCES` (`:37-46`) via `extractProse` (`src/lib/ingest.ts:57`).
- `"use client"` comps must not transitively import `@/lib/db`.

### Could NOT verify
- Live DB edit state of `cdt_home`/`conformity_home` (row vs JSON default) — parity script handles both via the libs.
- Full byte content of the default JSONs — parity harness treats as opaque, diffs field-by-field.
- Whether any external bookmark relies on the markdown `cyber-digital-twin` sitemap entry — assumed not.

---

## C. Target architecture

### C.1 Block data model — **new `page_blocks` table** (recommended over extending `site_blocks`)
`site_blocks` is `PK (key,locale)`, one blob, no order, read by four libs + corpus — cannot hold ordered rows without a disruptive redefinition. New table is additive.

```sql
CREATE TABLE IF NOT EXISTS page_blocks (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug        TEXT NOT NULL,
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  position    INT  NOT NULL DEFAULT 0,
  type        TEXT NOT NULL,           -- registry key, e.g. 'cdt.hero'
  config      JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS page_blocks_slug_locale_pos_idx
  ON page_blocks (slug, locale, position);
```
- **Per-locale:** one row per locale (mirrors `pages`/`page_versions`); EN/NL siblings share slug+position+type, differ in `config`.
- **Page record stays in `pages`:** publish/SEO/menu unchanged. Add `content_type='blocks'` → ALTER `pages_content_type_chk` to `IN ('page','article','blocks')` in `042`.
- **Zero-loss:** add nullable `blocks JSONB` to `page_versions`; `snapshotCurrent()` also captures the ordered block set. One unified history table. *(Alternative rejected: separate `page_block_versions` — duplicates all snapshot/restore machinery.)*

### C.2 Block-type registry
`src/lib/blocks/registry.ts` (server): `type → { label, Render, schema, defaultConfig, extractProse, editor }`. **Config type per block = the existing per-section interface** from `cdt.ts` / `conformity-home.ts` (reused verbatim → provably lossless). Client editor forms in `src/lib/blocks/editors.tsx` (`"use client"`, `import type` only). Shared `type` constants in a pure `src/lib/blocks/types.ts`.

### C.3 Generic server renderer
`src/components/blocks/block-renderer.tsx` reads ordered blocks and dispatches each to `registry[type].Render`, a thin adapter calling the **existing** `sections.tsx` export with the **existing** props → identical output by construction. Data-bound blocks (Conformity Hero carousel_slides, `getSummary()` KPIs, dictionary carousel) fetch the same sources as today.

### C.4 Admin "Page Builder" UI
Extend `pages-manager.tsx` with a builder panel when `content_type==='blocks'`: palette (registry labels), reorder (persist `position`), delete (snapshot-first), per-block typed forms + **raw-JSON escape hatch** (mirrors the existing Markdown toggle), and a `prose` block wrapping the existing `RichEditor`. Client-only; `import type` + client editor registry, never `registry.ts`/`sections.tsx`.

### C.5 API surface
Reuse: `/api/admin/pages`, `/menu-items`, `/translate`, `/restore`, `/versions`. New (same `getAdminSession()` auth): `GET/PUT /api/admin/pages/blocks?slug&locale` (bulk, snapshot-first). Keep `/api/admin/cdt` + `/api/admin/conformity-home` during transition; retire after parity sign-off.

---

## D. Complete block catalog (1:1)

**CDT** (config = interface in `cdt.ts`; renderer in `cdt/sections.tsx`):
`cdt.hero` (CdtHero+model, SevenLayerGraph) · `cdt.statBand` · `cdt.livingModel` (SevenLayerGraph) · `cdt.boms` · `cdt.drilldown` (BomDrilldownTable) · `cdt.consequence` · `cdt.priority` (PriorityMatrix) · `cdt.monteCarlo` (MonteCarloViz) · `cdt.methodology` · `cdt.outcomes` (needs locale) · `cdt.finalCta` (needs locale).

**Conformity** (config = interface in `conformity-home.ts`; renderer in `conformity-home/sections.tsx`):
`conformity.hero` (data-bound: carousel_slides) · `conformity.consultingCarousel` (**data-bound to i18n dict**) · `conformity.regulationBand` · `conformity.stats` · `conformity.platform` (preserve icon-name keys) · `conformity.problem` · `conformity.shift` · `conformity.comparison` · `conformity.howItWorks` · `conformity.testimonial` · `conformity.faq` (promote inline section) · `conformity.finalCta`.
Page-shell KPIs from `getSummary()` stay a shell concern (not a block). Plus a shared `prose` block.

---

## E. Data migration (reversible, snapshot-first, parity-verified)
1. **Snapshot first**; ensure `pages` rows for both slugs (create `conformity`, `content_type='blocks'`, `published=false` initially).
2. **Node backfill** `scripts/backfill-page-blocks.mjs`: call `getCdt()`/`getConformityHome()` (the same readers the routes use), emit one `page_blocks` row per section **in the exact route order**, copying each sub-object into `config` verbatim. Idempotent.
3. **Parity harness** `scripts/verify-block-parity.mjs`: (a) reconstruct object from blocks, deep-equal vs `getCdt()`/`getConformityHome()` EN+NL (empty diff required); (b) `extractProse` parity for grounding; (c) normalized-HTML render-diff old vs new behind the flag. Zero meaningful diff = gate.
4. **Reversible:** additive; coded routes + `site_blocks` remain source of truth until cutover; rollback = flag off (+ optional `DELETE FROM page_blocks`).

---

## F. CMS integration + retiring the stale row
- `content_type='blocks'` pages appear in `/api/admin/pages` automatically; publish/SEO/versions/translate/menu all apply. Builder panel shown instead of Markdown body.
- Menu placement via existing `/api/admin/menu-items` flow.
- **Retire markdown `cyber-digital-twin`:** one `pages` row per (slug,locale) — snapshot its markdown body to `page_versions`, then flip the row to `content_type='blocks'`. Markdown stays recoverable in history; nothing hard-deleted.
- Add `CODED_SLUGS`/`isBlockPage` awareness so no inert duplicate editors; remove legacy `cdt`/conformity nav editors only after sign-off.
- Sitemap unchanged (one row per slug). Grounding: block pages contribute prose via registry `extractProse`; drop `cdt_home`/`conformity_home` from `SITE_BLOCK_SOURCES` only after cutover; keep `cra_home`/`home`.

---

## G. Phased delivery + gates + testing
Every phase ends with `npm run typecheck`, `check:sql`, `i18n:check`, `build`, plus the functional check. Feature-flag (`BLOCKS_ROUTING`) — never a big-bang cutover.

- **Phase 0 — Foundations:** migration `042` (`page_blocks` + `page_versions.blocks` + CHECK extension); `blocks/{types,registry,editors}`; `BlockRenderer` + adapters. Test: adapters render identical props. **🚦 GATE 1** (schema + registry).
- **Phase 1 — Backfill + parity (read-only):** backfill + parity scripts on a scratch DB; empty field/prose diff EN+NL. **🚦 GATE 2** (parity report review).
- **Phase 2 — Parallel render behind flag:** block path selectable, old path default; Conformity shell keeps `getSummary()` + dict carousel. Test: render-diff both locales; exercise every widget. **🚦 GATE 3** (visual sign-off).
- **Phase 3 — Admin Page Builder:** palette, reorder, forms + JSON escape hatch, `prose` block, `/api/admin/pages/blocks`. Test: edit→snapshot→restore; reindex reads block prose.
- **Phase 4 — Cutover + retire duplicates:** flip flag; convert rows to `blocks`; snapshot+unpublish markdown; remove legacy editors from nav; drop keys from `SITE_BLOCK_SOURCES`. Test: full regression, sitemap, grounding rebuild. **🚦 GATE 4** (before removing legacy).
- **Phase 5 — Cleanup (optional):** retire `/api/admin/cdt`, `/api/admin/conformity-home` + their editors; fix stale docstring.

---

## H. Risks + open questions (need your decision)
1. Conformity's dictionary carousel + `getSummary()` KPIs + `carousel_slides` stay **data-bound** (renderer fetches them), NOT migrated into `page_blocks` — confirm.
2. Add `blocks JSONB` column to `page_versions` (vs separate table) — approve.
3. ALTER `content_type` CHECK to allow `'blocks'` — approve.
4. Retire markdown `cyber-digital-twin` via unpublish-after-snapshot (no hard delete) — approve.
5. Orphan `home`/industrial-operations stays entirely out of scope — confirm.
6. Reorder MVP: up/down buttons first, or drag-drop now?
7. Page-level publish is sufficient (no per-block draft) — confirm.

---

## I. Rollback (per phase)
P0 additive (`DROP TABLE page_blocks` / drop column). P1 `DELETE FROM page_blocks`. P2/P4 flag off restores coded routes; markdown `cyber-digital-twin` restorable from `page_versions`. `page_versions` append-only + `site_blocks` untouched until P4 = safety net; nothing hard-deleted at any point.

---

## J. Karpathy compliance
Assumptions verified with file:line; three of the original notes corrected (11 CDT sections; Conformity's 3 data sources; stale docstring). Evidence over confidence (read DDL/routes/libs/APIs/ingest/migrations). Uncertainty flagged + neutralized by the parity harness. Surgical + goal-driven (additive table + registry; reuse pages/versions/menu/translate/restore; Home untouched). Verification in every phase with explicit STOP gates for zero-loss sign-off.
