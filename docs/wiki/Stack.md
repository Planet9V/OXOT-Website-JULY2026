For: developers — technology choices and why.

# Stack

See also: [Home](Home.md) · [Architecture](Architecture.md) · [Backend](Backend.md) · [Frontend](Frontend.md)

Versions below are pinned ranges from [`package.json`](../../package.json) and the images in [`docker-compose.yml`](../../docker-compose.yml) — not aspirational, what's actually declared in this repo.

## Frontend

| Technology | Version (declared) | Why |
|---|---|---|
| **Next.js** | `^15.3.0` (App Router) | Server components for DB-driven pages (`force-dynamic` CMS routes), file-based routing for locale prefixes (`/[locale]/[slug]`), built-in `generateMetadata` for per-page SEO. |
| **React** | `^19.0.0` | Required peer for Next 15; needed for the App Router's server/client component model used throughout `src/app`. |
| **Tailwind CSS** | `^3.4.17` | Utility CSS mapped onto CSS custom properties defined once in `src/app/globals.css` — the "global stylesheet is the single source of truth" required by `CLAUDE.md` §2. `tailwind.config.ts` only maps tokens (`background`, `foreground`, `primary`, `muted`, `border`) to `hsl(var(--*))`; it defines no colors itself. |
| **next-themes** | `^0.4.4` | Dark/light mode toggle (`theme-provider.tsx`, `theme-toggle.tsx`) enforced through the same CSS variables. |
| **shadcn/ui-style components** | n/a (hand-rolled) | `src/components/ui/button.tsx` follows the shadcn pattern (Tailwind + `clsx`/`tailwind-merge`) without a separate UI library dependency — see `clsx` and `tailwind-merge` below. |
| **clsx** / **tailwind-merge** | `^2.1.1` / `^2.6.0` | Conditional class composition for the hand-rolled shadcn-style components. |

## Backend / data

| Technology | Version (declared) | Why |
|---|---|---|
| **PostgreSQL** | `pgvector/pgvector:pg17` (Docker image) | The single datastore for CMS content, menus, admin users, visitor sessions/events, agent messages, embeddings, and file bytes — per the brief's "everything in Postgres, including files" requirement. |
| **pgvector** | bundled in the `pgvector/pgvector:pg17` image | Native vector column type + `<=>` cosine-distance operator, used directly in `retrieval.ts`'s SQL rather than an external vector DB. |
| **`pg`** (node-postgres) | `^8.13.1` | Thin, dependency-light Postgres client; a single pooled `Pool` (`src/lib/db.ts`) is reused across the app via a `globalThis` cache in dev to avoid connection storms from Next.js hot reload. |

## AI / embeddings / generation

| Technology | Version (declared) | Why |
|---|---|---|
| **Ollama (embeddings)** | `qwen3-embedding:4b`, env `OLLAMA_EMBED_MODEL` | Local-first embeddings — no per-token cost, data never leaves the box, satisfies EU/NL privacy requirements in `CLAUDE.md` §2 and §4. |
| **`EMBED_DIM=2560`** | env-driven, default `2560` | The *actual* output length of `qwen3-embedding:4b` (native), not the `4096` the original project brief assumed. Must agree across `.env.local`, migration 001's `vector(__EMBED_DIM__)` template substitution (`scripts/migrate.mjs`), and the runtime length check in `src/lib/embeddings.ts` (`embed()` throws `Embedding dim mismatch` if the model returns something else). |
| **Ollama (generation)** | `qwen3.5:9b`, env `OLLAMA_CHAT_MODEL` | Local chat generation for the visitor agent, targeting first-token latency under ~1.5s on-box (per `docs/ARCHITECTURE.md` §1). |
| **OpenRouter** | env `OPENROUTER_API_KEY` / `OPENROUTER_MODEL` (default `openai/gpt-4o-mini`) | Automatic fallback when local Ollama is unavailable or errors — see `src/lib/llm/openrouter.ts` and the `chatStream()`/`chat()` fallback policy in `src/lib/llm/stream.ts` / `index.ts`. Never primary; only invoked on Ollama failure. |

## Auth

| Technology | Version (declared) | Why |
|---|---|---|
| **scrypt** (Node `node:crypto`) | built into Node, no dependency | Password hashing for the small admin team (`src/lib/auth.ts`: `scryptSync` + `randomBytes` salt, stored as `salt:hash` hex in `admin_users.password_hash`). Chosen to avoid an extra dependency for a handful of admin accounts. |
| **Signed cookie sessions** | hand-rolled HMAC-SHA256, no library | `makeSessionToken()`/`verifySessionToken()` sign a base64url JSON payload (`userId`, `email`, `exp`) with `AUTH_SECRET` via `createHmac`; 8-hour expiry (`MAX_AGE`). Zero deps, simple for a small team; trade-off is no server-side revocation list (see [Architecture](Architecture.md) §6). |

## Infrastructure

| Technology | Version (declared) | Why |
|---|---|---|
| **Docker Compose** | `docker-compose.yml` + `docker-compose.override.yml` | `app` (Next.js + Claude Code dev toolchain) and `db` (`pgvector/pgvector:pg17`) run as containers; an optional `ollama` service exists behind the `with-ollama` Compose profile for environments without a host Ollama. |
| **Host Ollama via `docker-compose.override.yml`** | n/a | Local dev routes `OLLAMA_HOST` to `http://host.docker.internal:11434` (the Mac's own Ollama, already holding the pulled models) instead of the empty in-compose `ollama` container, avoiding a 7GB re-download. The same override file also makes the Next dev server the container's main process, with a background loop that re-runs `npm run seed:pages` whenever `content/pages/**` changes. |
| **TypeScript** | `^5.7.2` | Whole app (`src/`, `scripts/*.mjs` are plain Node ESM, but app code is `.ts`/`.tsx`); `npm run typecheck` (`tsc --noEmit`) is the CI/DoD gate per `CLAUDE.md` §8. |
| **ESLint** | `^9.17.0` + `eslint-config-next` | Lint gate; "no new lint/type errors" is part of the Definition of Done. |

## Dev methodology

| Practice | Why |
|---|---|
| **Karpathy rules** (`CLAUDE.md` §1) | Binding: think before coding, YAGNI, surgical changes, verify before claiming done. Wins over every other instruction on conflict. |
| **Superpowers (obra marketplace)** | Drives the brainstorm → plan → subagent-driven TDD → review workflow referenced in `CLAUDE.md` §5; installed via `scripts/bootstrap-claude.sh` (`npm run claude:bootstrap`). |
| **GitHub PR flow** | `main` protected; changes via `feature/*`/`fix/*`/`chore/*` PRs with CI + review, per `CLAUDE.md` §5. |
