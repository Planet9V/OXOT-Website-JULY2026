For: developers / operators

# Deployment & Operations

How the app runs in Docker, the environment variables it needs, the operational commands, how
to roll back, and the gotchas that have actually bitten this project. See
[Architecture](Architecture.md) and [Stack](Stack.md) for the system design, and
[Developer-Guide](Developer-Guide.md) for the day-to-day dev loop.

## 1. Docker Compose services

Defined in `docker-compose.yml`:

### `app`
- Built from `Dockerfile`'s `dev` target (Node 22 + git/curl/gh + the Claude Code CLI).
- Loads secrets from `.env.local` (gitignored).
- `OLLAMA_HOST=http://ollama:11434` by default, and `DATABASE_URL` built from
  `POSTGRES_USER`/`POSTGRES_PASSWORD`/`POSTGRES_DB` pointing at `db:5432`.
- Mounts the repo at `/workspace` and a named volume `oxot_memory` at `/workspace/memory` — the
  team's shared Claude Code memory, one copy across every container/user.
- Publishes `3000:3000`.
- Base command is `sleep infinity` — i.e. the plain `docker-compose.yml` alone does **not**
  start the app; you run `npm run dev` inside it yourself, **unless** the override file below
  is in play (it is, by default, in local dev).

### `db`
- Image: `pgvector/pgvector:pg17` (Postgres 17 with the pgvector extension preinstalled).
- Env vars from `.env.local`: `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`.
- Data persisted in the `pgdata` named volume.
- **Not host-published.** The app reaches it internally over the Compose network at `db:5432`.
  For a shell: `docker compose exec db psql -U oxot -d oxot`. To expose it to the host, you'd
  need to add a `ports:` mapping yourself, e.g. `ports: ["5434:5432"]` — 5432/5433 are called
  out in the compose file's own comment as likely already taken by a Mac-native Postgres.

### `ollama` (optional, off by default)
- Image: `ollama/ollama:latest`, gated behind the `with-ollama` Compose **profile** so it does
  not start by default and does not collide with a host Ollama already listening on `:11434`.
- Start it explicitly only if you don't have Ollama installed on the host:
  ```bash
  docker compose --profile with-ollama up -d
  ```
- Persists pulled models in the `ollama` named volume.

## 2. `docker-compose.override.yml` — local dev wiring

Compose auto-loads this file alongside `docker-compose.yml` (no flag needed). It changes two
things for local dev:

**1. Points the app at the host's Ollama, not the in-compose one:**

```yaml
environment:
  - OLLAMA_HOST=http://host.docker.internal:11434
extra_hosts:
  - "host.docker.internal:host-gateway"
```

This avoids re-downloading multi-GB models into the container when they're already pulled on
the Mac.

**2. Replaces the base `sleep infinity` command with a real entrypoint** that runs `next dev`
as the container's PID 1, plus a background auto-seed watcher:

```sh
touch /tmp/seed.stamp;
( while true; do
    if find content/pages -type f -newer /tmp/seed.stamp 2>/dev/null | grep -q .; then
      npm run seed:pages > /tmp/seed-watch.log 2>&1;
      touch /tmp/seed.stamp;
    fi;
    sleep 5;
  done & );
exec npm run dev
```

In plain terms: every 5 seconds it checks whether any file under `content/pages/` changed since
the last stamp; if so, it re-runs `npm run seed:pages` (logging to `/tmp/seed-watch.log` inside
the container) and updates the stamp. This is why editing a `content/pages/en/<slug>.md` file
locally shows up on the site without you manually running the seed script. `exec npm run dev`
at the end means the Next dev server is PID 1, so `docker compose stop`/restart behave
correctly and container health reflects the actual server process.

## 3. Environment variables (`.env.example`)

Copy to `.env.local` and fill in real values — **never commit `.env.local`.**

| Variable | Purpose | Notes |
|---|---|---|
| `POSTGRES_USER` / `POSTGRES_PASSWORD` / `POSTGRES_DB` | DB credentials | Defaults to `oxot` / `change-me` / `oxot` — change the password for anything beyond local dev. |
| `DATABASE_URL` | Full Postgres connection string | `postgres://oxot:change-me@db:5432/oxot` inside Compose. |
| `OLLAMA_HOST` | Ollama base URL | `http://ollama:11434` (in-compose) or overridden to `http://host.docker.internal:11434` by the override file. |
| `OLLAMA_EMBED_MODEL` | Embedding model | `qwen3-embedding:4b`, native 2560-dim output. |
| `EMBED_DIM` | Vector column width | **2560** — must match the model's real output length. The original project brief said 4096; the real model emits 2560. This value is substituted into `db/migrations/001_init.sql`'s `vector(__EMBED_DIM__)` placeholder by `scripts/migrate.mjs`, and is asserted at ingest time (`scripts/ingest.mjs` throws if the embedding length returned by Ollama doesn't match). |
| `OLLAMA_CHAT_MODEL` | Local generation model | `qwen3.5:9b` — the AI agent's primary (local) generation model. |
| `OPENROUTER_API_KEY` | Fallback generation | Used only when local Ollama generation fails/is unavailable. Never commit a real key. |
| `OPENROUTER_MODEL` | Fallback model | e.g. `openai/gpt-4o-mini`. |
| `VALYU_API_KEY` | Research/deep-search | Never commit a real key. |
| `NODE_ENV` | Standard Node env flag | `development` locally. |
| `DEFAULT_LOCALE` | Fallback locale | `en`. |
| `SUPPORTED_LOCALES` | Locale allowlist | `nl,en`. |
| `AUTH_SECRET` | HMAC signing key for admin session cookies | Set to a long random string outside local dev — see `src/lib/auth.ts`. |

## 4. Operational commands

Run these inside the `app` container (`docker compose exec app <cmd>`), or via the
`.command` launchers described in [Developer-Guide](Developer-Guide.md#10-the-command-helper-script-pattern):

```bash
npm run db:migrate    # apply every db/migrations/*.sql in filename order (idempotent)
npm run seed:pages    # import content/pages/<locale>/<slug>.md into the pages table
npm run ingest        # chunk + embed content/<locale>/*.md into content_chunks via Ollama
node scripts/create-admin.mjs <email> <password>   # create or reset an admin login
```

`db:migrate` and `seed:pages`/`ingest` are all designed to be safely re-run — migrations use
`IF NOT EXISTS`/`ON CONFLICT` guards, and both seed scripts upsert on natural keys
(`(slug, locale)` for pages, `(page_id, locale)` delete-then-insert for chunks).

## 5. Rollback

- **`docker compose down`** stops and removes containers but **keeps** the named volumes
  (`pgdata`, `ollama`, `oxot_memory`) — your database and pulled models survive. This is the
  safe default for "stop everything, come back later."
- **`docker compose down -v`** additionally removes the named volumes — this **drops the
  database**. Only use this deliberately (e.g. to test migrations from a clean slate), and
  never on an environment with real data you haven't backed up.
- There is no automated point-in-time DB backup/restore tooling in this repo yet — if you need
  one before running `down -v` against anything that matters, take a manual dump first:
  ```bash
  docker compose exec db pg_dump -U oxot oxot > backup.sql
  ```

## 6. Gotchas

**The slim container has no `pgrep`.** Never guard a dev-server startup with a pattern like
`pgrep -f "next dev" || npm run dev`. Because `pgrep` doesn't exist in the `node:22-bookworm-slim`
base image, the check silently fails (command not found → treated as "not running"), so the
guard doesn't guard anything — you get a **second** `next dev` process fighting the first one
for port 3000. If you need to check whether something is already running, use `next dev`'s own
port-bind error as the natural guard, or check via `docker compose ps`, not a process-name grep
inside the container.

**The DB port is not host-published.** `db:5432` is only reachable from inside the Compose
network, by design (see docker-compose.yml's comment) — because the Mac itself commonly already
runs Postgres on `5432` or `5433`, publishing the same port would conflict. If you need a host
DB client (e.g. TablePlus/pgAdmin on the Mac) pointed at the container's Postgres, either
`docker compose exec db psql -U oxot -d oxot` for a quick shell, or deliberately add a free host
port mapping (e.g. `"5434:5432"`) to your own local override — don't assume 5432 is free or
that the container DB is reachable from the host without one of these steps.

**`EMBED_DIM=2560` and pgvector's 2000-dim ANN cap.** pgvector's HNSW/IVFFlat approximate
indexes only support up to 2000 dimensions; `qwen3-embedding:4b` natively emits 2560-dim
vectors. `db/migrations/001_init.sql` therefore does **not** create an ANN index on
`content_chunks.embedding` — retrieval uses **exact cosine distance** (`embedding <=> query`),
which is correct and fast enough for this size of corpus. If content ever grows large enough to
need approximate search, the migration file's own comment documents the upgrade path: switch
the column to `halfvec(2560)` (HNSW supports halfvec up to 4000 dims) and add
`CREATE INDEX ... USING hnsw ((embedding::halfvec(2560)) halfvec_cosine_ops)`, updating the
retrieval query to cast accordingly.

**Large media and `content-source/` are gitignored.** Don't expect raw source images/video or
the `content-source/` working directory to be present after a fresh clone — only the final,
optimized assets and the `content/` Markdown actually used by the app are tracked. If you're
missing an asset a page references, check whether it's expected to come from
`content-source/` or an external URL (e.g. an `og_image` field pointing at a CDN), not the repo.

## Quick reference

| Situation | Action |
|---|---|
| Stop everything, keep data | `docker compose down` |
| Wipe the DB and start clean | `docker compose down -v` (irreversible — dump first if it matters) |
| Need a host DB client | `docker compose exec db psql -U oxot -d oxot`, or add your own port mapping |
| Dev server won't start / double server on :3000 | Check for a stray `pgrep`-guarded restart script; don't add one |
| Vector search feels slow at scale | See the `halfvec(2560)` + HNSW upgrade note in `001_init.sql` |
| Local Ollama not found by the app | Confirm `docker-compose.override.yml` is loaded and `host.docker.internal` resolves; confirm models are pulled on the host |
