# OXOT Website — Setup on another machine (Docker, from GitHub)

Everything runs in Docker. These steps take a clean computer to a working local
copy of the site + admin, pulled from GitHub.

**Repo:** `https://github.com/Planet9V/OXOT-Website-JULY2026` (public)

---

## 1. Prerequisites

- **Docker Desktop** (with Compose v2) installed and running.
- **git**.
- Optional (for the AI visitor agent only): **Ollama** with the models pulled.
  The website itself runs fully without it — only the chat agent + embeddings need it.

---

## 2. Clone

```bash
git clone https://github.com/Planet9V/OXOT-Website-JULY2026.git
cd OXOT-Website-JULY2026
```

## 3. Configure environment

```bash
cp .env.example .env.local
```

Open `.env.local` and set at least:

| Variable | What to set |
|---|---|
| `POSTGRES_PASSWORD` | any strong password (used by the bundled Postgres) |
| `AUTH_SECRET` | a long random string (admin session signing) |
| `SETTINGS_SECRET` | optional; a second random string to encrypt the stored OpenRouter key (falls back to `AUTH_SECRET`) |
| `OPENROUTER_API_KEY` | optional; or set it later in **Admin → AI & Models** |
| `EMBED_DIM` | leave `2560` unless you change the embedding model (see caveats) |

Never commit `.env.local` — it's gitignored.

### Ollama wiring — important on a new machine
The repo ships `docker-compose.override.yml` tuned for a Mac that already runs
Ollama on the host (`OLLAMA_HOST=http://host.docker.internal:11434`). On a fresh
box you have two choices:

- **A — Use the bundled Ollama container** (simplest, self-contained). In `.env.local` set
  `OLLAMA_HOST=http://ollama:11434`, then after step 4 run:
  ```bash
  docker compose --profile with-ollama up -d ollama
  docker compose exec ollama ollama pull qwen3-embedding:4b
  docker compose exec ollama ollama pull qwen3.5:9b
  ```
- **B — No Ollama at all.** The site works; the AI chat agent just won't answer.
  You can still set an OpenRouter key in Admin → AI & Models to power generation.

## 4. Start the stack

```bash
docker compose up -d
```

The `app` container installs dependencies on first boot and runs `next dev` as its
main process — give it **30–60 seconds** the first time. Check it's up:

```bash
docker compose ps
docker compose logs -f app        # Ctrl-C to stop following
```

## 5. Database + admin — automatic

On `docker compose up` the app container runs `scripts/docker-init.sh` **before** the
dev server: it waits for Postgres, applies all migrations, seeds the CMS pages +
homepage, and creates a **default admin if none exists**. Every step is idempotent,
so it's safe on every boot — a fresh clone needs **zero manual DB steps**.

### Default admin login (works out of the box — no change required)

This is a private / dev deployment, so a default admin is created automatically and
you can log straight in. Same behaviour locally and on Railway.

| | |
|---|---|
| **email** | `admin@oxot.local` |
| **password** | `changeme` |

- Log in at **`/admin/login`**.
- To use different credentials instead, set `ADMIN_EMAIL` and `ADMIN_PASSWORD`
  **before the first deploy** — in `.env.local` locally, or as Railway variables.
  Once an admin row exists these values are ignored and never overwrite it.
- No password change is enforced. To rotate later, either change it in the admin
  UI or re-run `scripts/create-admin.mjs` (below).

Watch it happen: `docker compose logs -f app` (look for the `[init]` lines).

Optional — embed the corpus for the AI agent (needs Ollama reachable):

```bash
docker compose exec app npm run ingest
```

You can also re-run any step by hand: `docker compose exec app npm run db:migrate`
(or `seed:pages`, `seed:site`, `seed:admin`).

## 6. Add or change an admin

Create additional admins (or set a stronger password) any time:

```bash
docker compose exec app node scripts/create-admin.mjs you@example.com 'a-strong-password'
```

## 7. Open it

- Site: **http://localhost:3000/en** (or `/nl`)
- Admin: **http://localhost:3000/admin/login**

From the admin you manage pages, the mega-menu, the homepage, media, inquiries and
the AI/model settings — all changes reflect on the site immediately.

---

## Caveats (read these on a fresh machine)

1. **`EMBED_DIM` must match the embedding model.** It's `2560` for
   `qwen3-embedding:4b`. If you switch embedding models, change `EMBED_DIM` in
   `.env.local` **and** re-run `db:migrate` — the pgvector column dimension is fixed
   by migration 001.
2. **Homepage hero PDFs are not in the repo.** The CRA hero-carousel source PDFs
   live in `content-source/`, which is **gitignored**. A clean clone falls back to
   the built-in risk-map hero card instead — expected, not a bug. To restore the
   PDF carousel, drop the PDFs into `content-source/` and run
   `docker compose exec app node scripts/seed-media.mjs`, then set the hero media id
   in Admin → Homepage.
3. **Port 3000** must be free (the app publishes it). Postgres is internal-only by
   default; for a DB shell use `docker compose exec db psql -U oxot -d oxot`.
4. **The repo is public** — never commit secrets; keep them in `.env.local`.

## Updating later

```bash
git pull
docker compose up -d
docker compose exec app npm run db:migrate     # apply any new migrations
docker compose exec app npm run seed:pages      # re-import content if it changed
```

## Handy scripts
The `scripts/` folder has double-click `.command` helpers used during development
(push, migrate, seed, restart). On another machine you can run the same steps
directly with the `docker compose exec app …` commands above.
