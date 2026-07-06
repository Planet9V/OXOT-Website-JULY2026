For: developers — deep reference for the database, retrieval/generation, auth, and admin API.

# Backend

See also: [Home](Home.md) · [Architecture](Architecture.md) · [Stack](Stack.md) · [Frontend](Frontend.md) · [Developer-Guide](Developer-Guide.md)

## Database connection

`src/lib/db.ts` exports a single pooled `Pool` from `pg`, cached on `globalThis` outside production so Next.js hot reload doesn't leak connections:

```ts
export const pool =
  globalForPool.pgPool ??
  new Pool({ connectionString: process.env.DATABASE_URL });
```

`DATABASE_URL` is injected by `docker-compose.yml` as `postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}`.

## Schema, table by table

All DDL lives in `db/migrations/001_init.sql` through `005_menu_insights.sql`, applied in filename order by `scripts/migrate.mjs` (never edit an applied migration — add a new numbered file).

### `content_chunks` (001) — AI-agent retrieval corpus

```sql
CREATE TABLE content_chunks (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  page_id     TEXT NOT NULL,
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  text        TEXT NOT NULL,
  embedding   vector(__EMBED_DIM__) NOT NULL,   -- __EMBED_DIM__ → 2560 at migrate time
  source_ref  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX content_chunks_locale_idx ON content_chunks (locale);
```

`__EMBED_DIM__` is substituted by `scripts/migrate.mjs` from `process.env.EMBED_DIM` (default `2560`) at apply time — **this must match** the real output length of the installed embedding model (see [Stack](Stack.md)). No ANN index exists: pgvector's HNSW/IVFFlat cap at 2000 dimensions, and 2560 exceeds that, so `retrieval.ts` does exact cosine search (`embedding <=> query`), which the migration's comment notes is "correct and fast for this small corpus." The documented upgrade path (in the migration file) is to cast to `halfvec(2560)` and add an HNSW cosine index once the corpus grows.

### `visitor_sessions` / `visitor_events` (001) — consent-gated behavioral capture

```sql
CREATE TABLE visitor_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  locale TEXT NOT NULL CHECK (locale IN ('nl','en')),
  consent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE visitor_events (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id UUID NOT NULL REFERENCES visitor_sessions(id) ON DELETE CASCADE,
  type TEXT NOT NULL,      -- page | click | scroll | dwell
  page_id TEXT,
  element TEXT,
  meta JSONB,
  ts TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

`consent_at IS NULL` means no consent — both `/api/events` and `/api/agent` check this and return `403` rather than storing/answering. Only `page` and `click` events are actually emitted by `ChatWidget` today; `scroll`/`dwell` are allowed by the `ALLOWED` set in `/api/events/route.ts` but not yet wired client-side.

### `agent_messages` (001) — conversation + provenance

```sql
CREATE TABLE agent_messages (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id UUID NOT NULL REFERENCES visitor_sessions(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('system','user','assistant')),
  text TEXT NOT NULL,
  cited_chunk_ids BIGINT[],
  provider TEXT,           -- ollama | openrouter
  ts TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### `files` (001) — file storage in Postgres

```sql
CREATE TABLE files (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  filename TEXT NOT NULL,
  content_type TEXT,
  bytes BYTEA NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Per the project brief: file storage lives in Postgres, not an object store. (Note: the one PDF/video currently shipped — `public/media/OXOT-CRA-Readiness*.pdf|mp4` — is served as a static asset, not via this table; nothing in `src/app/api` currently reads/writes `files` yet.)

### `admin_users` (002)

```sql
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,        -- scrypt: salt:hash (hex)
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### `pages` (002, + SEO columns in 004)

```sql
CREATE TABLE pages (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug TEXT NOT NULL,
  locale TEXT NOT NULL CHECK (locale IN ('nl','en')),
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  published BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (slug, locale)
);
-- 004 adds:
ALTER TABLE pages ADD COLUMN meta_title       TEXT;
ALTER TABLE pages ADD COLUMN meta_description TEXT;
ALTER TABLE pages ADD COLUMN excerpt          TEXT;
ALTER TABLE pages ADD COLUMN og_image         TEXT;
ALTER TABLE pages ADD COLUMN content_type     TEXT NOT NULL DEFAULT 'page';
ALTER TABLE pages ADD COLUMN published_at     TIMESTAMPTZ;
ALTER TABLE pages ADD CONSTRAINT pages_content_type_chk CHECK (content_type IN ('page','article'));
CREATE INDEX pages_content_type_idx ON pages (content_type, locale, published);
```

**`UNIQUE(slug, locale)`** — one row per language per slug; the same slug can (and typically does) have both an `en` and `nl` row. **`content_type IN ('page','article')`** — articles show up in the blog index (`listArticles`), plain pages don't.

### `menus` / `menu_items` (002, re-seeded in 005)

```sql
CREATE TABLE menus (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  key TEXT NOT NULL UNIQUE           -- e.g. 'main', 'footer'
);
CREATE TABLE menu_items (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  menu_id BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  locale TEXT NOT NULL CHECK (locale IN ('nl','en')),
  label TEXT NOT NULL,
  href TEXT NOT NULL,
  position INT NOT NULL DEFAULT 0
);
CREATE INDEX menu_items_menu_idx ON menu_items (menu_id, locale, position);
```

The only menu key in use today is **`'main'`** (migrations 003 and 005 both target `menus.key = 'main'`; 005 re-seeds it to add the Insights/blog link).

## `src/lib/content.ts` — the read API pages use

```ts
export async function getPublishedPage(slug: string, locale: Locale): Promise<Page | null>
export async function getMenu(key: string, locale: Locale): Promise<MenuItem[]>
export async function listArticles(locale: Locale): Promise<ArticleSummary[]>
```

- `getPublishedPage` — `SELECT ... FROM pages WHERE slug=$1 AND locale=$2 AND published=true LIMIT 1`, mapping `meta_title→metaTitle`, `meta_description→metaDescription`, `og_image→ogImage`, `content_type→contentType`. Used by `/[locale]/[slug]/page.tsx` for both content and `generateMetadata`.
- `getMenu` — joins `menu_items`→`menus` on `key`, filtered by locale, ordered by `position`. Used by `SiteNav`.
- `listArticles` — `WHERE locale=$1 AND published=true AND content_type='article' ORDER BY COALESCE(published_at, updated_at) DESC`. Used by the blog index route.

## Embeddings (`src/lib/embeddings.ts`)

```ts
const EMBED_MODEL = process.env.OLLAMA_EMBED_MODEL ?? "qwen3-embedding:4b";
export const EMBED_DIM = Number(process.env.EMBED_DIM ?? 2560);

export async function embed(text: string): Promise<number[]> {
  const res = await fetch(`${OLLAMA_HOST}/api/embeddings`, { ... });
  const json = (await res.json()) as { embedding: number[] };
  if (json.embedding?.length !== EMBED_DIM) {
    throw new Error(
      `Embedding dim mismatch: model returned ${json.embedding?.length}, EMBED_DIM=${EMBED_DIM}. ` +
        `Set EMBED_DIM to match ${EMBED_MODEL} and re-run migrations.`
    );
  }
  return json.embedding;
}
```

**The dim-mismatch assertion is load-bearing.** `EMBED_DIM` must agree in three places simultaneously: `.env.local` (`EMBED_DIM=2560`), migration 001's `vector(__EMBED_DIM__)` column (materialized at migrate time), and this runtime check. If you swap embedding models, update all three and re-run `db:migrate` (which likely means dropping and recreating `content_chunks`, since you can't `ALTER COLUMN` a vector's dimension in place with existing data of a different width).

## Retrieval (`src/lib/retrieval.ts`)

```ts
export async function retrieve(
  query: string, locale: Locale, currentPageId?: string, k = 6
): Promise<RetrievedChunk[]> {
  const vector = await embed(query);
  const { rows } = await pool.query(
    `SELECT id, text, page_id,
       (embedding <=> $1::vector)
         - (CASE WHEN page_id = $3 THEN 0.05 ELSE 0 END) AS score
     FROM content_chunks
     WHERE locale = $2
     ORDER BY score ASC
     LIMIT $4`,
    [`[${vector.join(",")}]`, locale, currentPageId ?? null, k]
  );
  ...
}
```

Locale filter is a hard `WHERE`; the current-page boost is a soft `-0.05` cosine-distance subtraction (lower distance = closer = ranked first), so same-page chunks are preferred but off-page chunks are never excluded outright. Default `k=6`.

## LLM provider fallback (`src/lib/llm/`)

`provider.ts` defines one interface:

```ts
export interface LLMProvider {
  readonly name: string;
  chat(messages: ChatMessage[]): Promise<string>;
}
```

`ollama.ts` (`OllamaProvider`, model from `OLLAMA_CHAT_MODEL`, default `qwen3.5:9b`) and `openrouter.ts` (`OpenRouterProvider`, model from `OPENROUTER_MODEL`, default `openai/gpt-4o-mini`, requires `OPENROUTER_API_KEY`) both implement it. `index.ts`'s `chat()` tries Ollama, falls back to OpenRouter on any thrown error:

```ts
try {
  return { content: await primary.chat(messages), provider: primary.name };
} catch (err) {
  console.warn(`[llm] ${primary.name} failed, falling back:`, err);
  return { content: await fallback.chat(messages), provider: fallback.name };
}
```

`stream.ts`'s `chatStream()` applies the same policy but for streaming: it reads Ollama's NDJSON stream line-by-line and yields text deltas; on any failure (bad status or thrown error) it falls back to a single non-streamed OpenRouter call and yields the whole reply as one delta. `onProvider(name)` callback reports which provider actually served the request so the caller can persist it.

## Auth (`src/lib/auth.ts`)

- **Password hashing**: `scryptSync(password, salt, 64)`, stored as `${salt}:${hash}` hex in `admin_users.password_hash`. `verifyPassword` recomputes and compares with `timingSafeEqual` (constant-time, avoids timing attacks).
- **Session token**: `makeSessionToken(userId, email)` builds a base64url JSON payload `{userId, email, exp}` (8h from now — `MAX_AGE = 60*60*8`) and appends an HMAC-SHA256 signature (`createHmac("sha256", AUTH_SECRET)`) as `payload.signature`. `verifySessionToken` re-signs the payload and compares with `timingSafeEqual`, then checks `exp`.
- **Cookie**: name `oxot_admin` (`SESSION_COOKIE`), `httpOnly`, `sameSite: "lax"`, `secure` in production, 8h `maxAge` (`sessionCookieOptions`).
- **Route guard**: `getAdminSession()` reads the cookie via `next/headers` and verifies it; every admin API route calls this first and returns `401` if it fails.
- **No server-side revocation** — logout (`POST /api/admin/logout`) just clears the client cookie (`maxAge: 0`); a stolen token remains valid until it expires. Accepted trade-off for a small team (see [Architecture](Architecture.md) §6).

## Admin API

All admin routes require the `oxot_admin` session cookie (send `-b` with the cookie file from a prior login in curl examples below).

### `POST /api/admin/login`

```bash
curl -c cookies.txt -X POST http://localhost:3000/api/admin/login \
  -H "content-type: application/json" \
  -d '{"email":"you@oxot.example","password":"a-strong-password"}'
```
`200 {"ok":true}` + sets the `oxot_admin` cookie. `401 {"error":"invalid credentials"}` on failure.

### `POST /api/admin/logout`

```bash
curl -b cookies.txt -X POST http://localhost:3000/api/admin/logout
```

### `GET /api/admin/pages` — list every page (all locales, all types)

```bash
curl -b cookies.txt http://localhost:3000/api/admin/pages
```
```json
{"pages":[{"slug":"about","locale":"en","title":"About OXOT","contentType":"page","published":true,"updated_at":"..."}]}
```

### `POST /api/admin/pages` — upsert a page (one locale at a time)

Body fields (exact JSON keys, from `src/app/api/admin/pages/route.ts`):

```jsonc
{
  "slug": "about",                 // required
  "locale": "en",                  // required, "en" | "nl"
  "title": "About OXOT",           // required — H1 / <title> fallback
  "body": "Markdown body text...", // optional, default ""
  "published": true,               // optional, default false
  "metaTitle": "About OXOT — Dutch OT Cybersecurity",   // SEO: <title>/OG title override
  "metaDescription": "OXOT is a Dutch OT cybersecurity...", // SEO: <meta description>/OG description
  "excerpt": "Dutch OT cybersecurity experts...",        // short summary, used in blog listings
  "ogImage": "https://.../image.png",                    // social share image URL
  "contentType": "page"             // "page" | "article", default "page"
}
```

```bash
curl -b cookies.txt -X POST http://localhost:3000/api/admin/pages \
  -H "content-type: application/json" \
  -d '{
    "slug": "about",
    "locale": "en",
    "title": "About OXOT",
    "body": "OXOT is a Dutch OT cybersecurity company...",
    "published": true,
    "metaTitle": "About OXOT — Dutch OT Cybersecurity",
    "metaDescription": "OXOT is a Dutch OT cybersecurity company founded by former Fox-IT OT security leads.",
    "excerpt": "Dutch OT cybersecurity experts, founded by former Fox-IT OT security leads.",
    "contentType": "page"
  }'
```

**Bilingual publish guard** (exact logic in the route): if `published: true`, the route checks the *other* locale for the same `slug`:

```ts
if (b.published) {
  const other = b.locale === "nl" ? "en" : "nl";
  const sib = await pool.query(`SELECT 1 FROM pages WHERE slug=$1 AND locale=$2`, [b.slug, other]);
  if (!sib.rows.length) {
    return NextResponse.json(
      { error: `cannot publish: missing ${other} version of "${b.slug}"` },
      { status: 409 }
    );
  }
}
```
So publishing the `en` row for a brand-new slug fails with `409` until the `nl` row exists (in any state, published or not) — and vice versa.

**`published_at` logic**: on insert, `published_at` is set to `now()` only if `published=true` at insert time; on every subsequent upsert it's `COALESCE(pages.published_at, EXCLUDED.published_at)` — i.e. once a page has ever had a `published_at` timestamp, it's preserved (first-publish date), not bumped on every edit.

### `DELETE /api/admin/pages?slug=...&locale=...`

```bash
curl -b cookies.txt -X DELETE "http://localhost:3000/api/admin/pages?slug=about&locale=en"
```

### `GET /api/admin/menu-items?menu=main`

```bash
curl -b cookies.txt "http://localhost:3000/api/admin/menu-items?menu=main"
```
```json
{"items":[{"id":1,"locale":"en","label":"Home","href":"/en","position":0}]}
```

### `POST /api/admin/menu-items`

```bash
curl -b cookies.txt -X POST http://localhost:3000/api/admin/menu-items \
  -H "content-type: application/json" \
  -d '{"menu":"main","locale":"en","label":"Careers","href":"/en/careers","position":7}'
```
`menu` defaults to `"main"` if omitted; `locale`, `label`, `href` are required (`400` otherwise).

### `DELETE /api/admin/menu-items?id=...`

```bash
curl -b cookies.txt -X DELETE "http://localhost:3000/api/admin/menu-items?id=12"
```

## Public (non-admin) APIs, for completeness

| Endpoint | Method | Consent required? | Behavior |
|---|---|---|---|
| `/api/session` | `POST` | no | creates a `visitor_sessions` row; sets `consent_at` only if `consent:true` is sent |
| `/api/session` | `PATCH` | no | updates `consent_at` for an existing `sessionId` |
| `/api/events` | `POST` | **yes** (403 otherwise) | inserts one `visitor_events` row; `type` must be one of `page`,`click`,`scroll`,`dwell` |
| `/api/agent` | `POST` | **yes** (403 otherwise) | retrieves grounding chunks, streams a generated answer, persists both turns |

## How to add a migration

1. Create `db/migrations/006_<short_name>.sql` — **never edit 001–005** once applied.
2. Make it idempotent: `CREATE TABLE IF NOT EXISTS`, `ADD COLUMN IF NOT EXISTS`, guard `ADD CONSTRAINT` with a `pg_constraint` existence check (see 004's `DO $$ ... END $$` pattern), and `ON CONFLICT` for any seed data.
3. If you touch `content_chunks`/vector dimension, keep `__EMBED_DIM__` as the placeholder — `scripts/migrate.mjs` substitutes it from `process.env.EMBED_DIM`.
4. Apply: `docker compose exec app npm run db:migrate` (runs `scripts/migrate.mjs`, which applies every `.sql` file in `db/migrations/` in sorted filename order — safe to re-run since everything is idempotent).

## How to reset the DB

Local dev only — this destroys all data:

```bash
docker compose down -v      # drops the pgdata volume (and ollama/oxot_memory volumes too)
docker compose up -d
docker compose exec app npm run db:migrate
docker compose exec app npm run seed:pages
docker compose exec app npm run ingest
docker compose exec app node scripts/create-admin.mjs you@oxot.example 'a-strong-password'
```

For a narrower reset (keep the DB container, just recreate the schema), you can instead `docker compose exec db psql -U oxot -d oxot -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'` then re-run `db:migrate`/`seed:pages`/`ingest` above.
