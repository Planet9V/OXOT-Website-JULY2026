# OXOT Website — Developer Guide

**Audience:** a developer who has to keep building this codebase and troubleshoot it in production.

**Scope:** how to work here safely — layout, the non-negotiable rules, the traps that have actually
bitten us, and the runbook. This document deliberately does **not** re-derive things covered by its
peers:

| For… | Read |
| --- | --- |
| System shape, rendering flow, AI agent, deployment topology | [`docs/ARCHITECTURE.md`](./ARCHITECTURE.md) |
| Every table, column, pgvector specifics, migration template | [`docs/DATA-MODEL.md`](./DATA-MODEL.md) |
| Route inventory, nav, redirects, SEO surface | [`docs/SITEMAP.md`](./SITEMAP.md) |
| The Conformity application in depth | [`docs/CONFORMITY-APP.md`](./CONFORMITY-APP.md) |

The binding project law is [`CLAUDE.md`](../CLAUDE.md) at the repo root. Where this guide and
`CLAUDE.md` disagree, `CLAUDE.md` wins.

---

## 1. Repo layout tour

```
OXOT_Website_JULY2026/
├── CLAUDE.md                  ← project law (Karpathy rules, bilingual rule, stack)
├── Dockerfile                 ← multi-stage: dev / builder / runner (Railway + GHCR)
├── railway.json               ← builder=DOCKERFILE, preDeployCommand, healthcheck /en
├── next.config.mjs            ← redirects, webpack "@" alias, ignore TS/ESLint on build
├── tailwind.config.ts         ← maps CSS vars → Tailwind color names
├── data/                      ← shipped JSON defaults for the coded pages
├── db/migrations/             ← 001…040, numbered SQL, applied by scripts/migrate.mjs
├── docs/                      ← this documentation set
├── scripts/                   ← migrate.mjs, ingest.mjs, i18n-check.mjs, seed-*.mjs, *.command
└── src/
    ├── app/
    │   ├── globals.css        ← THE design system: all tokens, light + dark
    │   ├── [locale]/          ← every public route, locale-prefixed
    │   │   ├── page.tsx                 CRA readiness landing (the front door)
    │   │   ├── cyber-digital-twin/      CDT flagship page
    │   │   ├── conformity/              conformity home (preserved former front door)
    │   │   ├── conformity-platform/     the Conformity app (matrix/requirements/themes/sources)
    │   │   ├── [slug]/                  markdown CMS catch-all
    │   │   ├── blog/, contact/, newsletter/, industrial-operations/
    │   │   └── layout.tsx, loading.tsx, not-found.tsx
    │   ├── admin/             ← admin console route
    │   └── api/               ← ~60 route handlers (see SITEMAP.md §6)
    ├── components/
    │   ├── cra-home/          sections + interactive widgets for /[locale]
    │   ├── cdt/               seven-layer graph, BOM drilldown, priority matrix, Monte Carlo
    │   ├── conformity-home/   hero carousel, consulting carousel, FAQ, sections
    │   ├── conformity/        matrix-grid, requirements-explorer, timeline, coverage-ring, subnav
    │   ├── admin/             admin-shell + one manager/editor per section
    │   ├── agent/             the visitor AI assistant
    │   ├── motion/fx.tsx      Reveal / Stagger / StaggerItem / CountUp / SpotlightCard
    │   └── ui/                shadcn primitives (badge, button, card, input, tabs, …)
    ├── i18n/
    │   ├── config.ts          locales, isLocale(), Locale type
    │   ├── dictionaries.ts    getDictionary(locale)
    │   └── dictionaries/{en,nl}.json
    └── lib/                   data access + domain logic (server-side unless noted)
```

### `src/lib` at a glance

- **Server-only** (they value-import `./db`, i.e. `pg`): `db`, `content`, `site-content`,
  `cra-home`, `cdt`, `conformity`, `conformity-home`, `carousel`, `intake`, `intake-settings`,
  `newsletter`, `social`, `affiliate`, `retrieval`, `ingest`, `reindex`, `page-versions`,
  `ai-settings`, `integration-settings`, `integration-observability`.
- **Client-safe** (no DB import — safe to value-import from a `"use client"` file):
  `segments.ts`, `utils.ts` (`cn`), `i18n/config.ts`.

This split is not cosmetic. See §3.

---

## 2. The project's hard rules

### 2.1 Karpathy rules

`CLAUDE.md` §1 is binding. In practice, on this repo, the four that get violated most:

- **Rule 3 — surgical changes.** Every migration in `db/migrations/` documents its own reversal;
  every consolidation migration (038, 040) explains exactly what it did and did *not* touch. Match
  that standard.
- **Rule 5 — verify before claiming done.** `next build` does *not* type-check here (see §7), so
  "it builds" proves nothing. Run `npx tsc --noEmit`.
- **Rule 6 — report uncertainty.** Say `[UNVERIFIED]` rather than asserting.
- **Rule 10 — leave the tree greener.** Don't add lint/type regressions.

### 2.2 Bilingual nl + en, always

No user-facing string ships in one language. Enforced mechanically for the *dictionary* by
`scripts/i18n-check.mjs`, which flattens both dictionaries to dotted key paths and compares the sets:

```bash
node scripts/i18n-check.mjs      # or: npm run i18n:check
```

Success:

```
i18n OK — 812 keys present in both nl and en.
```

Failure (exit code 1):

```
Missing in nl: [ 'conformity.matrix.heatLess', 'conformity.matrix.heatMore' ]
```

It only checks **key parity**, not that the Dutch value is actually Dutch. A copy-pasted English
value passes the check. That is a human-review responsibility.

It also does **not** cover the two other content mechanisms:

| Mechanism | Bilingual enforcement |
| --- | --- |
| `src/i18n/dictionaries/{en,nl}.json` | `scripts/i18n-check.mjs` (automated) |
| `site_blocks` JSONB (`data/*_{en,nl}.json` + DB rows) | manual — keep the two JSON files structurally identical |
| `pages` markdown rows | manual — one row per `(slug, locale)` |

For `site_blocks`, a cheap structural check:

```bash
node -e '
const a=require("./data/cdt_en.json"), b=require("./data/cdt_nl.json");
const f=(o,p="")=>Object.entries(o).flatMap(([k,v])=>v&&typeof v==="object"?f(v,p+k+"."):[p+k]);
const A=new Set(f(a)),B=new Set(f(b));
const d=[...A].filter(k=>!B.has(k)).concat([...B].filter(k=>!A.has(k)));
console.log(d.length?["KEY DRIFT",d]:"cdt en/nl structurally identical");'
```

### 2.3 Zero content loss

**Invariant: nothing may ever overwrite a `pages.body` without first snapshotting it.**

The mechanism is `page_versions` (append-only) + `snapshotCurrent()` in
`src/lib/page-versions.ts`:

```ts
export async function snapshotCurrent(
  slug: string, locale: string,
  state: "draft" | "published" | "archived",
  note: string,
  client: PoolClient | typeof pool = pool
): Promise<void>
```

It reads the current `pages` row and inserts it at
`COALESCE(MAX(version_number), 0) + 1`. It is a no-op if the page row doesn't exist yet, and it
accepts a `PoolClient` so it can participate in a caller's transaction —
`restoreVersion()` in the same file does exactly that: `BEGIN` → snapshot current →
`UPDATE pages` → `COMMIT`, with `ROLLBACK` on any error. Nothing in that module ever deletes.

**Applies to SQL too.** Migration `038_consolidate_conformity_into_frameworks.sql` appends a
"Coverage tools" section to the `frameworks` pages, and it inserts a `page_versions` row
(`note = 'Auto-snapshot before 038 coverage-tools enrichment'`) *before* the `UPDATE`. Copy that
shape for any content-touching migration.

**Checklist before you write anything that mutates `pages`:**

1. Does a `snapshotCurrent(...)` / equivalent `INSERT INTO page_versions` run first?
2. Is it inside the same transaction as the write?
3. Does the note say *why*, so the history is readable?

### 2.4 The global stylesheet is the single source of truth

All colour, radius, shadow, easing and the display font live in `src/app/globals.css`, defined
twice — `:root` (light) and `.dark`:

```css
:root {
  --background: 60 33% 98%;      --foreground: 212 51% 11%;
  --primary: 28 100% 47%;        /* OXOT orange #F07000 */
  --border: 214 25% 88%;         --ring: 28 100% 47%;
  --radius: 0.75rem;
  --font-display: "Fraunces", "Newsreader", Georgia, …, serif;
  --elev-1/-2/-3: …;             --ease-out/--ease-in-out: …;  --dur-1/-2/-3: …;
}
.dark { --background: 210 50% 12%;  /* OXOT navy #102030 */  --primary: 28 100% 53%; … }
```

Values are **bare HSL triplets**, so consumption is always through `hsl(var(--…))` or the Tailwind
names that `tailwind.config.ts` maps onto them.

**Do:**

```tsx
<div className="bg-card text-foreground border border-border rounded-[var(--radius)]" />
<h1 style={{ fontFamily: "var(--font-display)" }}>…</h1>
<span style={{ backgroundColor: `hsl(var(--primary) / ${alpha})` }} />   // dynamic alpha
```

**Don't:** hardcode `#F07000`, `rgb(...)`, `bg-orange-500`, or a literal serif stack.

Audit before shipping:

```bash
grep -rnE '#[0-9a-fA-F]{3,8}\b' src/components src/app --include=*.tsx | grep -v globals.css
```

(Expect a small number of legitimate hits in SVG/brand assets — read each one.)

**Both themes must be verified visually.** The theme toggle is `src/components/theme-toggle.tsx`,
driven by `next-themes` via `src/components/theme-provider.tsx`.

---

## 3. The client/server boundary rule — with the real incident

### The rule

> A `"use client"` component must **never value-import** a module that transitively imports
> `@/lib/db`.

`@/lib/db` instantiates a `pg.Pool`. `pg` pulls in Node built-ins — `fs`, `dns`, `net`, `tls`. Those
have no browser equivalent, so webpack cannot bundle them and `next build` fails hard with
`Module not found: Can't resolve 'dns'` (and friends). Dev is lenient (SWC, on-demand compilation),
so **this only shows up at build time** — usually in CI or on Railway, not on your machine.

### The incident

Commit `8a35128` — *"Fix CRA build: client-safe segments module (no pg in browser bundle)"*:

> `next build` failed: client component `intake-leads-manager.tsx` value-imported `SEGMENTS` from
> `src/lib/intake.ts`, which imports the pg pool → Node built-ins (fs/dns/net/tls) leaked into the
> browser bundle.

`src/components/admin/intake-leads-manager.tsx` is `"use client"` (it uses `recharts` and local
state). It needed one constant — the five CRA intake segments — and imported it from the module
that owned it, `@/lib/intake`, which is server-only.

### The fix

Extract the client-safe part into its own module, `src/lib/segments.ts`:

```ts
// Client-safe single source of truth for the 5 CRA intake segments.
// IMPORTANT: this module must NOT import server-only code (no @/lib/db / pg),
// so it can be imported by BOTH server code and client components …
export const SEGMENTS = ["manufacturer", "oem", "integrator", "reseller", "operator"] as const;
export type Segment = (typeof SEGMENTS)[number];
export function isSegment(v: unknown): v is Segment { … }
```

`src/lib/intake.ts` re-exports them so there is still exactly one source of truth; the client
component's import changed to `import { SEGMENTS } from "@/lib/segments";`.

### The two escape hatches

1. **Types are free.** `import type { … }` is erased at compile time and never emits a runtime
   import. This is why `src/lib/cdt.ts` carries the comment *"client components must only
   `import type { … }` from this module — it value-imports the DB pool"*, and why
   `src/components/conformity/matrix-grid.tsx` can safely do
   `import type { MatrixCell, Requirement } from "@/lib/conformity";`.
2. **Extract the constant.** If a client component needs a *value* from a server module, move that
   value to a client-safe module (the `segments.ts` pattern) and re-export it from the server module.

### The audit grep — run this before you ship

```bash
# 1. Derive the set of server-only libs (anything that value-imports the pg pool).
SERVER_LIBS=$(grep -rl 'from "\./db"\|from "@/lib/db"' src/lib \
  | sed 's|src/lib/||; s|\.ts$||' | paste -sd'|' -)
echo "server-only libs: $SERVER_LIBS"

# 2. Find any "use client" file that VALUE-imports one of them. Zero output = clean.
grep -rl '"use client"' src \
  | xargs grep -nE "^import[[:space:]]+(type[[:space:]]+)?.*from[[:space:]]+\"@/lib/($SERVER_LIBS)\"" \
  | grep -v "import type"
```

Verified against the tree as of this writing: **`SERVER_LIBS` resolves to 19 modules and the
violation search returns nothing.** Keep it that way.

> Caveat: the grep is a first-order check on `@/lib/*` only. It will not catch a client component
> importing a *component* that in turn imports a server lib, nor relative-path imports. When
> `next build` still fails with `Module not found`, read the module trace webpack prints — it names
> the full import chain.

---

## 4. Content model patterns — which mechanism to use

There are three. Pick deliberately (`docs/ARCHITECTURE.md` §8 has the decision matrix).

| | `pages` (markdown) | `site_blocks` (JSONB + coded sections) | dictionary |
| --- | --- | --- | --- |
| Storage | one row per `(slug, locale)` | one row per `(key, locale)` | JSON in the repo |
| Editing | admin Pages tab, rich editor | bespoke admin editor per key | code change + PR |
| Layout | generic prose renderer | bespoke React sections | n/a |
| Use for | articles, reference pages, legal | flagship landing pages | UI chrome, labels |

### 4.1 A simple markdown page

Create the row (migration or admin UI) with `slug`, `locale`, `title`, `body`, `published`,
plus SEO fields. It renders through `src/app/[locale]/[slug]/page.tsx`. **Both locales, always.**
If you seed it from a migration, use `ON CONFLICT … DO NOTHING` (see §5.4).

### 4.2 A new bespoke coded page (the `cra-home` / `cdt` pattern)

This is the pattern used by `cra_home`, `cdt_home`, `conformity_home` and `home`. Concretely, for a
new page `foo`:

**Step 1 — the typed model + getter, `src/lib/foo.ts`:**

```ts
import { pool } from "./db";
import type { Locale } from "@/i18n/config";
import enDefault from "../../data/foo_en.json";
import nlDefault from "../../data/foo_nl.json";

// NOTE (build-safety): client components must only `import type { … }` from this
// module — it value-imports the DB pool (server-only).

export interface Foo { hero: FooHero; /* …every section, fully typed… */ }

export const FOO_KEY = "foo_home";

export function defaultFoo(locale: Locale): Foo {
  return (locale === "nl" ? nlDefault : enDefault) as Foo;
}

/** DB-first, JSON-default. Never 500s if the DB is down. */
export async function getFoo(locale: Locale): Promise<Foo> {
  try {
    const { rows } = await pool.query(
      `SELECT data FROM site_blocks WHERE key = $1 AND locale = $2 LIMIT 1`,
      [FOO_KEY, locale]
    );
    if (rows[0]?.data) return rows[0].data as Foo;
  } catch (e) {
    console.warn("[foo] DB unavailable, using JSON defaults:", e);
  }
  return defaultFoo(locale);
}

/** Admin read — stored row if present, else defaults so the editor is never blank. */
export async function getFooForEdit(locale: Locale): Promise<Foo> { return getFoo(locale); }

export async function saveFoo(locale: Locale, data: Foo): Promise<void> {
  await pool.query(
    `INSERT INTO site_blocks (key, locale, data, updated_at) VALUES ($1,$2,$3,now())
     ON CONFLICT (key, locale) DO UPDATE SET data = EXCLUDED.data, updated_at = now()`,
    [FOO_KEY, locale, JSON.stringify(data)]
  );
}
```

The **resilience contract** matters: the `try/catch` around the DB read plus the JSON fallback is
why `/[locale]` and `/[locale]/conformity` still render during a database outage. Don't drop it.

**Step 2 — the shipped defaults:** `data/foo_en.json` and `data/foo_nl.json`, structurally
identical, both fully written in their own language.

**Step 3 — the section components:** `src/components/foo/sections.tsx` (server components taking
typed props) plus any `"use client"` interactive widget in the same folder. Every widget label must
come from the content model or dictionary — see §6.

**Step 4 — the page:** `src/app/[locale]/foo/page.tsx`, `export const dynamic = "force-dynamic"`,
`generateMetadata` using `alternates(locale, "/foo")` from `@/lib/seo`, `isLocale()` guard →
`notFound()`.

**Step 5 — the admin editor:** `src/components/admin/foo-editor.tsx` (`"use client"`), fetching
`GET /api/admin/foo` and `PUT`ing per locale.

**Step 6 — the API route:** `src/app/api/admin/foo/route.ts`, mirroring
`src/app/api/admin/cdt/route.ts` exactly:

```ts
export const runtime = "nodejs";
export const dynamic = "force-dynamic";

export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [en, nl] = await Promise.all([getFooForEdit("en"), getFooForEdit("nl")]);
  return NextResponse.json({ en, nl });
}

export async function PUT(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const body = await req.json().catch(() => ({}));
  if (!body.locale || !isLocale(body.locale) || !body.data?.hero)
    return NextResponse.json({ error: "locale + data{hero,…} required" }, { status: 400 });
  await saveFoo(body.locale, body.data);
  return NextResponse.json(body.data);
}
```

**Step 7 — register in the admin shell.** In `src/components/admin/admin-shell.tsx`:
add `"foo"` to the `Section` union, add `{ key: "foo", label: "Foo page", icon: … }` to `NAV`, and
add `{section === "foo" && <FooEditor />}` to the render switch.

**Step 8 — seed migration** (optional but recommended) inlining both JSON files with
`ON CONFLICT (key, locale) DO NOTHING` — see `db/migrations/029_seed_conformity_home.sql`.

**Step 9 — add it to the AI grounding corpus.** In
`src/app/api/admin/content/reindex/route.ts`, append to `SITE_BLOCK_SOURCES`:

```ts
{ key: FOO_KEY, slug: "site-blocks-foo", get: getFoo },
```

The `slug` **must** be a `site-blocks-*` pseudo-id distinct from any real `pages.slug` — that route
documents why: `ingestPage()` begins with `DELETE FROM content_chunks WHERE page_id=$1 AND locale=$2`,
so reusing a real slug would wipe the chunks just ingested from that page's row.

**Checklist**

- [ ] `src/lib/foo.ts` with `FOO_KEY`, typed model, `getFoo` (try/catch + JSON default), `saveFoo`
- [ ] `data/foo_en.json` + `data/foo_nl.json`, key-identical, genuinely translated
- [ ] section components; **no hardcoded English labels**
- [ ] `src/app/[locale]/foo/page.tsx` + `generateMetadata` + `alternates`
- [ ] `src/components/admin/foo-editor.tsx`
- [ ] `src/app/api/admin/foo/route.ts` (admin-gated GET + PUT)
- [ ] `admin-shell.tsx`: `Section` union + `NAV` + render switch
- [ ] seed migration with `ON CONFLICT DO NOTHING`
- [ ] `SITE_BLOCK_SOURCES` entry in the reindex route
- [ ] nav/menu entries in both locales (`menu_items`, via migration)
- [ ] `npx tsc --noEmit`, `node scripts/i18n-check.mjs`, boundary grep, both locales, both themes

---

## 5. Adding or altering DB schema

`docs/DATA-MODEL.md` §4 has the canonical migration template. What follows is the operational
detail you need at the keyboard.

### 5.1 Naming and numbering

`db/migrations/NNN_snake_case_description.sql`, zero-padded to three digits. `scripts/migrate.mjs`
does `readdirSync(dir).filter(f => f.endsWith(".sql")).sort()` — a **lexicographic** sort, which is
why the padding is load-bearing. Current head is `040_consolidate_approach_into_cdt.sql`; take the
next free number. (Note `027` is absent — the sequence has a gap, and that is fine.)

### 5.2 The run-once ledger

`scripts/migrate.mjs`:

1. Creates `schema_migrations (filename PRIMARY KEY, applied_at)` if absent.
2. **First-run backfill:** if the ledger table did *not* exist but `pages` does (i.e. an existing
   prod DB predating the ledger), every file with numeric prefix `<= BASELINE_MAX` (**35**) is
   inserted into the ledger *without running*. On a genuinely fresh DB (no `pages` table) nothing is
   backfilled and everything runs from `001`.
3. Then, for each file: skip if in the ledger, else substitute `__EMBED_DIM__`, `client.query(sql)`,
   and record the filename.

Practical consequences:

- **A migration runs exactly once per database, ever.** Editing an already-applied migration file
  has no effect in that environment. To change applied schema, write a *new* migration.
- To force a re-run in a non-production DB:
  `DELETE FROM schema_migrations WHERE filename = '0NN_whatever.sql';`
- Each file is executed as **one `client.query()` call** — a single implicit transaction in
  `node-postgres` multi-statement mode. If any statement fails, the whole file rolls back and the
  ledger row is not written. Explicit `BEGIN; … COMMIT;` (as in `024_conformity_nl.sql`) is fine and
  makes the intent obvious.

### 5.3 `__EMBED_DIM__` substitution

```js
const dim = Number(process.env.EMBED_DIM ?? 1536);
const sql = readFileSync(...).replaceAll("__EMBED_DIM__", String(dim));
```

Use the placeholder — never a literal — for any `vector(...)` column. Files using it today:
`001_init.sql`, `008_inquiries.sql`, `035_embed_dim_1536.sql`, `039_cra_intake.sql`.

`035_embed_dim_1536.sql` is the model for a conditional, idempotent dimension change: it reads
`(atttypmod - 4)` from `pg_attribute`, and only if it differs from `__EMBED_DIM__` does it drop the
HNSW index, `TRUNCATE content_chunks`, and retype the column. It is a total no-op otherwise. Changing
the dimension **requires a full re-ingest** (`npm run ingest`, or the admin "Rebuild now").

### 5.4 Idempotency conventions

| Object | Convention |
| --- | --- |
| Tables | `CREATE TABLE IF NOT EXISTS` |
| Columns | `ALTER TABLE … ADD COLUMN IF NOT EXISTS` |
| Indexes | `CREATE INDEX IF NOT EXISTS` |
| Reference data (safe to refresh) | `INSERT … ON CONFLICT (key) DO UPDATE SET …` |
| **Editable content** (must never clobber) | `INSERT … ON CONFLICT (key, locale) DO NOTHING` |
| Translation backfills | plain `UPDATE … WHERE key='…'` (naturally re-runnable) |
| Conditional/structural work | `DO $$ … END $$;` with a guard |

### 5.5 ⚠ Seed migrations that overwrite content clobber admin edits

This was a real **MUST-FIX**. `scripts/migrate.mjs` says so in its own header:

> Run-once ledger: each migration filename is recorded in `schema_migrations` after it applies, so
> re-deploys skip already-applied migrations **instead of re-running seed migrations that would
> otherwise clobber live admin edits.**

The ledger is the *backstop*, not the fix. The fix is the `ON CONFLICT` policy. Get it right:

- Content a **human edits in the admin** (`site_blocks`, `pages`): `DO NOTHING`.
  `029_seed_conformity_home.sql` states it explicitly — *"this seeds the INITIAL content once and
  then LEAVES ADMIN EDITS ALONE."*
- Reference data **only code owns** (`conformity_*`): `DO UPDATE` is correct — that's how
  `021_conformity_platform.sql` stays refreshable.
- If you genuinely must overwrite editable content: **snapshot to `page_versions` first**, exactly
  as migration 038 does.

### 5.6 Reversal notes

Every non-trivial migration carries a `-- REVERSAL:` block. `038` is the exemplar: four numbered
steps covering nav restoration, re-parenting with original positions/labels, removing the appended
content section (or restoring the named `page_versions` snapshot), and reverting `next.config.mjs`.
Write yours the same way — someone will need it at 2am.

### 5.7 Template

```sql
-- 041_short_description.sql
-- WHAT: one sentence.
-- WHY: the reason, and what breaks without it.
-- IDEMPOTENT: yes — <how>.
-- REVERSAL: <numbered steps, or "irreversible: <why>">.

CREATE TABLE IF NOT EXISTS my_thing (
  id         serial PRIMARY KEY,
  key        text UNIQUE NOT NULL,
  name       text NOT NULL,
  name_nl    text,                 -- NL column: getters COALESCE(NULLIF(name_nl,''), name)
  sort_order int DEFAULT 0,
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS my_thing_sort_idx ON my_thing (sort_order);

-- Reference data owned by code: refreshable.
INSERT INTO my_thing (key, name, sort_order) VALUES ('alpha','Alpha',1)
  ON CONFLICT (key) DO UPDATE SET name = EXCLUDED.name, sort_order = EXCLUDED.sort_order;

-- Admin-editable content: seed once, never clobber.
-- INSERT INTO site_blocks (key, locale, data) VALUES ('my_thing','en', $json$ … $json$)
--   ON CONFLICT (key, locale) DO NOTHING;
```

Dutch text with apostrophes (`thema's`, `commando's`) must use dollar quoting (`$$…$$`) — see the
header of `024_conformity_nl.sql`.

Run it:

```bash
npm run db:migrate                  # applies pending files, prints "applying …" / "skipped …"
```

---

## 6. i18n workflow

### 6.1 Dictionary keys vs. content

- **Dictionary** (`src/i18n/dictionaries/{en,nl}.json`) — UI chrome that never changes without a code
  change: nav labels, table headers, filter labels, button text, breadcrumbs, empty states. Top-level
  namespaces today: `home, nav, theme, a11y, notFound, newsletterResult, agent, footer, cookies,
  contact, conformity, conformityHome, craHome, cdt, intakeForm, intakeSuccess`.
- **`site_blocks` content** — everything a marketer should be able to edit without a deploy: headlines,
  body copy, CTA labels, card text, and (importantly) **widget labels that are part of the narrative**.

Read a dictionary in a server component:

```ts
const t = getDictionary(locale).conformity;
```

### 6.2 The rule: component chrome must never hardcode English

> If a component renders a user-visible string, that string arrives as a **prop** — sourced from the
> dictionary or the content model. Never as a literal in the component.

The pattern throughout: pages pass a `labels` object down. E.g.
`src/app/[locale]/conformity-platform/matrix/page.tsx` builds

```tsx
labels={{ themeColumn: t.matrix.themeColumn, legend: t.matrix.legend, detailTitle: t.matrix.detailTitle,
          refsLabel: t.matrix.refsLabel, connector: t.matrix.connector, close: t.matrix.close,
          heatLess: t.matrix.heatLess, heatMore: t.matrix.heatMore }}
obligationLabels={t.obligationTypes}
```

and `MatrixGrid` types it as `MatrixLabels` — so a missing label is a **type error**, not a silent
English leak. Do this: define an exported `…Labels` interface next to the component.

### 6.3 The two real leaks that were fixed

Both were interactive widgets built quickly with English baked in, caught only on the Dutch pages.

**(a) CRA road map — `437c7a2` "CRA home: localize hardcoded labels (OXOT does/BUYS/Human-Machine-readable)".**
`src/components/cra-home/roads-split.tsx` rendered a literal `"OXOT does · "` prefix, and
`persona-card.tsx` a literal `"BUYS →"`. Fix: both became content-model fields with explicit
docblocks in `src/lib/cra-home.ts`:

```ts
/** Prefix label before each road's "oxotDoes" line, e.g. "OXOT does · ". */
oxotDoesLabel: string;
/** Prefix label before each card's "buys" line, e.g. "BUYS →". */
buysLabel: string;
```

and the components now take them as props (`oxotDoesLabel`, `buysLabel`). Because they live in
`cra_home` `site_blocks`, they're admin-editable *and* per-locale.

**(b) CDT widgets — `f5b0851` "CDT: localize interactive-widget labels (level names, matrix axes, hints, Monte Carlo)".**
Seven files, +195/−52: drilldown level names / sort / priority / collapse labels, priority-matrix
axes + consequence/exploitability level names + hint, Monte-Carlo axis/mean/CI labels, seven-layer
graph hint. All moved into `src/lib/cdt.ts` (new interfaces `CdtDrilldownLevelNames`,
`CdtDrilldownSortOptions`, `CdtPriorityConsequenceLevels`, `CdtPriorityExploitLevels`, …) and into
`data/cdt_{en,nl}.json`. NL now shows *Organisatie / Kritiek / Consequentie*.

**The lesson for the next widget:** the moment you type a string literal inside a chart, table
header, axis label, tooltip, legend, or empty state — stop, and add it to the labels interface.

### 6.4 Known deviation

`src/components/conformity/framework-platform-link.tsx` holds its own inline `STR = { en: {…}, nl: {…} }`
const rather than reading the dictionary. It *is* bilingual, so it satisfies the language rule, but it
sits outside the enforcement of `i18n-check.mjs`. Prefer the dictionary for new code.

---

## 7. Local development

### 7.1 Install and env

```bash
cd OXOT_Website_JULY2026
npm ci
cp .env.example .env.local        # then fill it in — .env.local is gitignored, NEVER commit it
```

Variables that matter (full list and comments in `.env.example`):

| Var | Purpose |
| --- | --- |
| `DATABASE_URL` | Postgres + pgvector connection string. Required by everything. |
| `EMBED_DIM` | Vector dimension. **1536** per the 2026-07-14 decision. Substituted into migrations. |
| `OLLAMA_HOST`, `OLLAMA_EMBED_MODEL`, `OLLAMA_CHAT_MODEL` | Local generation/embedding. |
| `OPENROUTER_API_KEY`, `OPENROUTER_MODEL` | Fallback/production provider. |
| `AUTH_SECRET` | Admin session signing. |
| `SETTINGS_SECRET` | AES-256-GCM for the admin-stored OpenRouter key; falls back to `AUTH_SECRET`. |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | Bootstrap admin — only used if no admin exists yet. |
| `CRON_SECRET` | Enables `/api/cron`; unset keeps it disabled. |
| `DEFAULT_LOCALE`, `SUPPORTED_LOCALES` | `en`, `nl,en`. |

> ⚠ `.env.example` still ships `EMBED_DIM=2560` with the comment *"MUST match your embedding model's
> output length"*. That predates the 1536 decision recorded in `CLAUDE.md` §2 and implemented by
> `035_embed_dim_1536.sql` + `fitDim`. **Set `EMBED_DIM=1536` locally** unless you deliberately want
> the native 2560-dim space, and remember the pgvector column, `EMBED_DIM`, `fitDim`, migration 001's
> placeholder and migration 035 must all agree.

### 7.2 The loop

```bash
npm run dev                       # http://localhost:3000/en  and  /nl
npm run db:migrate                # apply pending migrations
npm run seed:pages                # markdown page seeds
npm run seed:site                 # site_blocks seeds
npm run seed:admin                # idempotent bootstrap admin
npm run ingest                    # rebuild the pgvector corpus from scratch
npx tsc --noEmit                  # or: npm run typecheck
node scripts/i18n-check.mjs       # or: npm run i18n:check
npm test                          # vitest
```

Docker Compose is available (`docker-compose.yml` + `docker-compose.override.yml`) and brings up
Postgres/pgvector alongside the app — see `SETUP.md`.

### 7.3 ⚠ `next build` does not type-check

`next.config.mjs`:

```js
eslint:     { ignoreDuringBuilds: true },
typescript: { ignoreBuildErrors: true },
```

The stated reason is keeping Railway/GHCR deploys green. The consequence: **a green build proves
nothing about types or lint.** `npx tsc --noEmit` is not optional, it is the only type gate. Two
notes:

- `tsconfig.tsbuildinfo` is committed/present; `tsc --noEmit` is incremental and fast after the
  first run.
- The `@` alias is belt-and-braces: `tsconfig.json` `paths` **and** an explicit webpack alias in
  `next.config.mjs`, added because production builds failed with
  `Module not found: Can't resolve '@/…'`.

---

## 8. Deploy and release

### 8.1 What Railway does

`railway.json`:

```json
{
  "build":  { "builder": "DOCKERFILE", "dockerfilePath": "Dockerfile" },
  "deploy": {
    "preDeployCommand": "npm run db:migrate && npm run seed:pages && npm run seed:site && npm run seed:admin",
    "healthcheckPath": "/en",
    "healthcheckTimeout": 300,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 3,
    "numReplicas": 1
  }
}
```

So a deploy is: **build the Dockerfile → run migrations + seeds → start → healthcheck `/en`.**

### 8.2 What the Dockerfile does (and the traps baked into it)

Three stages — `dev`, `builder`, `runner`. Each of the following comments is a scar; do not "clean
them up":

- `builder` runs `npm ci` with `NODE_ENV=development` **on purpose**. Setting it to `production`
  earlier makes npm skip devDependencies (typescript, tailwindcss, postcss) and `next build` fails.
- `RUN npm run build` **must not** be masked with `|| true`. A masked build ships an incomplete
  `.next` and `next start` then crashes with `ENOENT … .next/prerender-manifest.json`.
- `runner` does a **full copy** from the builder (`.next`, `scripts/`, `db/migrations/`) so the
  pre-deploy migrate/seed commands exist in the production image.
- Start command binds `$PORT` on all interfaces:
  `next start -H 0.0.0.0 -p ${PORT:-3000}`. Listening on a hardcoded 3000 gives
  *"502 Application failed to respond"*.
- `next.config.mjs` deliberately has **no `output: "standalone"`** — in Next 15 that is incompatible
  with `next start` and the container crash-loops with `"next start" does not work with "output: standalone"`.

### 8.3 Diagnosing a failed deploy

1. **Read the build log first.** `Module not found` → §3 (client/server boundary) or the `@` alias.
   Missing tailwind/postcss → the `NODE_ENV` trap above.
2. **If the build was green but the deploy failed**, the failure is almost always the pre-deploy
   command — i.e. a migration threw. The log prints `applying 0NN_….sql` immediately before the
   error, which names the offending file. Because each file runs as one transaction, nothing partial
   was committed and its ledger row was **not** written, so a fixed re-deploy retries just that file.
3. **If migrations passed but the healthcheck timed out**, the app is starting but `/en` isn't
   200-ing within 300s — check runtime logs for a DB connection failure or an unhandled throw in a
   server component.
4. **Verify a live route** rather than trusting the dashboard:
   ```bash
   curl -sS -o /dev/null -w '%{http_code} %{url_effective}\n' -L https://<host>/en https://<host>/nl
   ```

There is a large corpus of `*.command` scripts + matching `*.log` files at the repo root
(`deploy.command`/`deploy.log`, `verify-deploy.command`, `rwinfo.command`, `logs-check.command`,
`schema-audit.command`, …) capturing prior deploy/verify runs. They are useful as history; treat
them as a record of what was done, not as a supported CLI. `[UNVERIFIED]` whether each still runs
as-is today.

**Do not commit or push as part of a documentation change.** Ship code through a PR off
`feature/*` / `fix/*` / `chore/*` (`CLAUDE.md` §5).

---

## 9. Troubleshooting runbook

| Symptom | Cause | Fix |
| --- | --- | --- |
| `next build` fails: `Module not found: Can't resolve 'dns'` / `fs` / `net` / `tls` | A `"use client"` component value-imports a module that transitively imports `@/lib/db` (`pg`). Dev doesn't catch it. Real case: `admin/intake-leads-manager.tsx` imported `SEGMENTS` from `@/lib/intake`. | Switch to `import type` if it's only a type; otherwise extract the value into a client-safe module (`src/lib/segments.ts`) and re-export from the server module. Run the §3 audit grep. |
| `next build` fails: `Module not found: Can't resolve '@/…'` | Path alias not resolving in the production webpack build. | Already mitigated by `tsconfig` `baseUrl`+`paths` **and** the explicit alias in `next.config.mjs`. If it recurs, confirm both are intact. |
| Build fails on missing tailwind/postcss/typescript | `NODE_ENV=production` during `npm ci` in the builder stage → devDependencies skipped. | Keep the builder stage at `NODE_ENV=development` for install; flip to production only after. |
| Container crash-loops: `"next start" does not work with "output: standalone"` | `output: "standalone"` added to `next.config.mjs`. | Remove it. This app runs plain `next build` + `next start`. |
| `502 Application failed to respond` on Railway | App listening on hardcoded 3000 while the proxy routes `$PORT`. | Keep `next start -H 0.0.0.0 -p ${PORT:-3000}`. |
| Runtime `ENOENT … .next/prerender-manifest.json` | An earlier failed build was masked and an incomplete `.next` shipped. | Never mask `npm run build`. Rebuild. |
| **Hero looks blank / faded in an automated screenshot** | **Not a bug.** framer-motion (`motion/react`) drives reveals via `requestAnimationFrame`; a backgrounded or hidden tab has rAF throttled/frozen, so elements stay at their `initial` opacity. | Foreground the tab, or wait/scroll before capturing. `CoverageRing` already ships a 1.4s `setTimeout` fallback for exactly this class of problem (`src/components/conformity/coverage-ring.tsx`). Don't "fix" the animation. |
| Admin AI page shows `Rebuild failed: …` | `src/components/admin/ai-settings.tsx:153` renders `` `Rebuild failed: ${d.error ?? "server error"}` `` — the `"server error"` half is the **fallback shown when the API response contains no `error` field**, which in practice means the POST never got a well-formed JSON reply (request dropped, proxy timeout, worker restart). It is not a diagnosis. | Check server logs for `[reindex] background rebuild failed:`; poll `GET /api/admin/content/reindex` for real state. Historical wording of this fallback mentioned Ollama — `[UNVERIFIED]`; the current string is `"server error"`. |
| Rebuild appears to hang / browser request times out | Full re-embed exceeds the browser timeout. | Already handled: POST starts a **fire-and-forget background task** and returns `{ok:true, started:true}` immediately; the UI polls `GET` every ~5s (`pollRebuildStatus`). A second POST while running returns `{alreadyRunning:true}`. |
| Embedding calls fail with OpenRouter 429 / `engine_overloaded` / "Model busy" | Transient provider rate limiting. OpenRouter may return it as HTTP 429 **or** wrap it in a 200 body like `{"error":{"message":"HTTP 429: …engine_overloaded…"}}`. | Already handled in `src/lib/embeddings.ts`: `isRetryable()` inspects **both** status and body text; `embedOpenRouter` retries up to `MAX_ATTEMPTS = 6` honouring `Retry-After`, else exponential backoff (`600·2^n`, capped 8s, +jitter). If it still fails after 6, the error names the last detail. |
| Embeddings come back `undefined` / `data[0].embedding` missing | The OpenAI `dimensions` parameter. It's only honoured by OpenAI's `text-embedding-3-*`; for `qwen3-embedding-4b` OpenRouter returns a body **without** the embedding when it's present. Fixed in `65ce4bd`. | Never send `dimensions`. Let the model return native 2560 and truncate with `fitDim()` (Matryoshka + L2 renormalize). |
| Retrieval returns nothing / nonsense after a model or dimension change | Query-side and index-side vectors are in different spaces. | `src/lib/embeddings.ts::fitDim` and `scripts/ingest.mjs::fitDim` must be byte-identical in behaviour, and `EMBED_DIM` must match the pgvector column. After any dimension change, **full re-ingest** (`npm run ingest` or admin *Rebuild now*). |
| A migration "didn't run" | It's already in the run-once ledger — `migrate.mjs` prints `skipped 0NN_….sql (already applied)`. Also: everything with prefix ≤ **35** was ledger-**backfilled** without executing on pre-existing prod DBs. | Write a **new** migration. Only in a disposable DB: `DELETE FROM schema_migrations WHERE filename='0NN_….sql';` then re-run. Inspect with `SELECT filename, applied_at FROM schema_migrations ORDER BY filename;`. |
| Admin edits silently reverted after a deploy | A seed migration used `ON CONFLICT … DO UPDATE` on editable content and re-ran. | Editable content (`site_blocks`, `pages`) must use `DO NOTHING`. Recover the prior body from `page_versions` via the admin restore (`restoreVersion()` snapshots before restoring, so recovery is itself lossless). |
| `fatal: Unable to create '…/.git/index.lock': File exists.` | A previous git process died mid-operation, or another tool holds it. | Confirm no git process is running, then `rm -f .git/index.lock` and retry. Never delete it while a real git process is live. |
| Dutch page shows English chrome | A widget hardcoded a label (§6.3). | Move it into the labels interface / content model; add to **both** `data/*_{en,nl}.json`; re-run `i18n-check`. |
| `/en/conformity-platform` redirects but `/en/conformity-platform/matrix` doesn't | Intentional. The redirect source is `/:locale(en\|nl)/conformity-platform` **without** a trailing wildcard, so only the bare overview matches. | See `next.config.mjs` and `docs/CONFORMITY-APP.md` §7. |
| Page 500s when the DB is down | A getter without the try/catch + JSON-default fallback. | Follow the `getCraHome` / `getCdt` / `getConformityHome` pattern (§4.2). `/[locale]/conformity` additionally wraps `getSummary()` in its own try/catch with literal fallback counts. |

---

## 10. Verification expectations before shipping

Definition of done, per `CLAUDE.md` §8, made concrete:

```bash
# 1. Types — the ONLY type gate (next build ignores errors).
npx tsc --noEmit

# 2. Dictionary parity.
node scripts/i18n-check.mjs

# 3. Client/server boundary audit (§3). Zero output = clean.
SERVER_LIBS=$(grep -rl 'from "\./db"\|from "@/lib/db"' src/lib | sed 's|src/lib/||; s|\.ts$||' | paste -sd'|' -)
grep -rl '"use client"' src \
  | xargs grep -nE "^import[[:space:]]+(type[[:space:]]+)?.*from[[:space:]]+\"@/lib/($SERVER_LIBS)\"" \
  | grep -v "import type"

# 4. No hardcoded colours.
grep -rnE '#[0-9a-fA-F]{3,8}\b' src/components src/app --include=*.tsx | grep -v globals.css

# 5. Tests.
npm test

# 6. Build (proves bundling, not types).
npm run build
```

Then, by hand:

- [ ] **Both locales.** Load the changed route at `/en/…` **and** `/nl/…`. Read the Dutch — key
      parity does not mean it's translated.
- [ ] **Both themes.** Toggle light/dark on the changed route; check contrast on tinted surfaces
      (heatmap cells, badges, rings).
- [ ] **Zero loss.** If anything writes to `pages`, confirm a `page_versions` row was created first.
- [ ] **Mobile.** The stack is mobile-first; check the narrow breakpoint (several components ship a
      separate mobile card list, e.g. `RequirementsExplorer`).
- [ ] **Reduced motion.** `globals.css` has a global guard and `fx.tsx`/`CoverageRing` honour
      `useReducedMotion()`; new animation must too.
- [ ] **Grounding.** If you added or changed a flagship page's content model, add it to
      `SITE_BLOCK_SOURCES` and run a rebuild.
- [ ] **PR description** lists assumptions and shows evidence (command output, screenshots of both
      locales/themes) — `CLAUDE.md` rules 5, 8, 9.
