# OXOT Website — Project Setup Plan

**Project:** `OXOT_Website_JULY2026`
**Date:** 2026-07-02
**Owner:** Jim (mckenneyengineers@gmail.com)
**Runtime:** **Docker instance** — the entire application (app, Postgres+pgvector, Ollama, MCP servers, and the Claude Code toolchain) runs inside containers, not on a local macOS host.
**Source of truth:** a **new GitHub repository** (to be created) holds all files; every change flows through GitHub processes — branches, pull requests, review, and CI/CD build the container image. — Section 2B.
**Status:** Plan for review — nothing installed or scaffolded yet

This plan describes how to configure this project so that Claude Code (and Cowork) work here with (1) a project-level `CLAUDE.md` aligned to Karpathy's rules, (2) per-project auto-memory, (3) the Superpowers skills framework, (4) Valyu deep-search, (5) the Context7 documentation MCP, and (6) a set of custom project skills — with **native Dutch + English** and an **interactive AI visitor agent** treated as first-class requirements throughout.

Everything below is grounded in the actual upstream repos and their current install commands (verified 2026-07-02). Where a step needs a secret (Valyu key), the plan uses an environment variable injected by the container runtime and never stores the key in the repo.

> **Docker-first note:** because this is a containerized environment, the plan avoids docker-in-docker. MCP servers run either **in-process via `npx` inside the dev container** (stdio transport) or as **sibling services on the Compose network** (HTTP transport). Secrets come from the container's environment (Compose `env_file` / orchestrator secrets), not from a shell profile like `~/.zshrc`.

---

## 0. Ground truth — what each named thing actually is

| You said | What it really is | Source of truth |
|---|---|---|
| "Karpathy rules" | A `CLAUDE.md` distilled from Andrej Karpathy's Jan 26 2026 post on LLM coding pitfalls. Started as 4 rules; **expanded to 10 rules + a self-check protocol** (June 28 2026). ~111K★. | `multica-ai/andrej-karpathy-skills` (formerly `forrestchang/andrej-karpathy-skills`) |
| "superpowers" | An agentic **skills framework + dev methodology** plugin (brainstorming → plan → subagent-driven TDD). Installed via a **plugin marketplace**. | `obra/superpowers` + `obra/superpowers-marketplace` |
| "superpowers-skills" | The community skills library. **Archived read-only on Oct 27 2025** — do not clone it directly; get skills through the plugin/marketplace instead. | `obra/superpowers-skills` (archived) |
| "mbrains" (per-project memory) | Claude Code's **built-in auto-memory**: a per-project `memory/` directory Claude maintains itself. No external dependency. | Claude Code docs — "How Claude remembers your project" |
| "deep-search" / "valyu-search" | Valyu **Agent Skills** — real-time search across web/academic/financial/medical + a DeepResearch API. Needs `VALYU_API_KEY`. | `valyuAI/skills`, `valyuAI/valyu-mcp`, docs.valyu.ai |
| "Context7" | Upstash's **up-to-date library-docs MCP** (`resolve-library-id`, `get-library-docs`). **Already live in this Cowork session** via the Docker MCP. | `upstash/context7`, `mcp/context7` |
| "using-superpowers" | A real meta-skill inside Superpowers (intro to the skill system). Comes with the plugin. | `obra/superpowers` |
| "multi-agent-brainstorming" | Maps to Superpowers' `brainstorming` + `dispatching-parallel-agents`. | `obra/superpowers` |
| "business analyst", "website-alignment", "AI-vector-automation" | **Not upstream** — these will be authored as **custom project skills** (Section 6). | This plan |

> **Naming note:** the archived `superpowers-skills` repo means the safe, supported path is the plugin marketplace, not a raw `git clone`. The plan reflects that.

---

## 1. Guiding principle — Karpathy alignment (the north star)

The project instruction says *"Always use Karpathy Rules."* Every other choice in this plan is subordinate to these. The `CLAUDE.md` we write will encode them and the newer self-check protocol.

**The four core rules**
1. **Think Before Coding** — state assumptions explicitly, surface ambiguity, ask instead of guessing.
2. **Simplicity First (YAGNI)** — write the minimum code that solves the stated problem; no speculative abstractions or unrequested features.
3. **Surgical Changes** — do not touch code adjacent to the task; every changed line must trace to what was asked.
4. **Goal-Driven Execution** — convert vague instructions into verifiable success criteria before starting.

**The expanded self-check protocol (the "10 rules" update)** adds, in short: verify before claiming done; report uncertainty instead of bluffing; stop and re-plan when confused rather than looping; keep a running assumptions list; and prefer evidence (tests, output) over assertions.

**Design decision:** rather than freeze a copy that goes stale, the `CLAUDE.md` will (a) inline the rules as enforceable project law, and (b) note the upstream file so it can be refreshed. This is what "align perfectly with Karpathy on all aspects" means in practice — the rules govern how Claude edits this codebase.

---

## 2. Target project structure

After execution the repo root will look like this:

```
OXOT_Website_JULY2026/
├── CLAUDE.md                     # Project law: Karpathy rules + OXOT stack + i18n + AI-agent rules
├── .mcp.json                     # Project-scoped MCP servers (Context7, Valyu) — no secrets inside
├── .github/
│   ├── workflows/                # CI/CD: build image → GHCR, tests, lint (Section 2B)
│   │   ├── ci.yml
│   │   └── release.yml
│   ├── pull_request_template.md
│   └── CODEOWNERS
├── .devcontainer/                # optional: Codespaces / VS Code dev-container definition
│   └── devcontainer.json
├── docker-compose.yml            # app + postgres(pgvector) + ollama + mcp services (Section 5c)
├── Dockerfile                    # multi-stage: build app image + dev container (Node + Claude Code)
├── .dockerignore                 # keep .env.local, .git, node_modules out of the image
├── .claude/
│   ├── settings.json             # Project settings (enables plugins, memory, permissions)
│   └── skills/                   # Custom project skills (Section 6)
│       ├── website-alignment/
│       ├── ai-vector-automation/
│       ├── business-analyst/
│       └── i18n-nl-en/
├── memory/                       # Claude Code auto-memory (per project) — Section 3
├── .env.local                    # Secrets (VALYU_API_KEY, DB URL) — gitignored, injected as container env
├── .env.example                  # Placeholder names only, safe to commit
└── SETUP_PLAN.md                 # This file
```

Superpowers itself is **not** copied into the repo — it installs as a plugin at the Claude Code level (inside the dev container) and its skills become available automatically. The dev container is where Claude Code runs; `.env.local` is mounted/injected as environment via Compose `env_file`, never baked into the image (enforced by `.dockerignore`).

---

## 2B. GitHub repository, container linkage & workflow

**Requirement:** the entire application runs in a Docker container that is **linked to a GitHub repository we create**; GitHub is the single source of truth and all changes go through GitHub processes (branches, PRs, review, tracking).

### 2B.1 Create the repository
> **Auth note:** creating the repo needs the **GitHub connector authorized** (this non-interactive session can't run its OAuth). Do it one of two ways:
> - **GitHub connector** — authorize it in claude.ai connector settings / an interactive session, then I can create + configure the repo directly; **or**
> - **`gh` CLI** — run the commands below yourself (or I generate a script you run in the Docker instance).

**Decided:** owner **`Planet9v`**, repo **`OXOT-Website-JULY2026`**, **public**.

```bash
# from the project root, inside the Docker instance — after `gh auth login` as Planet9v
git init -b main
git add . && git commit -m "chore: initial project scaffold"
gh repo create Planet9v/OXOT-Website-JULY2026 --public --source=. --remote=origin --push
```

### 2B.2 Repo ↔ container linkage
- **Image registry:** CI builds the app image and pushes it to **GHCR** (`ghcr.io/<owner>/oxot-website`) on every merge to `main` and every tag — so the container that runs is always traceable to a commit.
- **Reproducible dev:** `.devcontainer/devcontainer.json` (optional) lets the same container open in **GitHub Codespaces** or VS Code, so "the app in a container" and "the repo" are one environment.
- **Provenance:** images are tagged with the git SHA; `docker compose` can pull a pinned SHA, closing the loop between repo and running container.

### 2B.3 Branching & PR process (GitHub-native tracking)
- **Trunk:** `main` is protected — no direct pushes; changes land via PR only.
- **Branches:** short-lived `feature/*`, `fix/*`, `chore/*` off `main`.
- **PRs:** required review (CODEOWNERS), required status checks (CI green), and the `pull_request_template.md` enforces a description + test evidence (Karpathy: evidence over claims).
- **Tracking:** GitHub **Issues** for work items, **Projects** for the board, PRs auto-linked to issues (`Closes #n`), releases via tags.
- **Ties to shared memory (Section 3):** because `memory/` is committed with `merge=union`, the shared brain updates through the *same* PR flow and converges no matter which branch a PR comes from.

### 2B.4 CI/CD (`.github/workflows/`)
- `ci.yml` — on every PR: install, lint, run tests (incl. the bilingual + skill checks), and a **secret scan** so no key is ever committed. Blocks merge on failure.
- `release.yml` — on merge to `main` / tag: build the Docker image, push to GHCR, (optionally) deploy.
- **Secrets:** `VALYU_API_KEY`, `OPENROUTER_API_KEY`, DB creds live in **GitHub Actions secrets / environments**, mirroring the runtime `.env.local` — never in the repo.

### 2B.5 Guardrails
- `.gitignore` excludes `.env.local`, build artifacts, `node_modules`.
- Branch protection + required checks + secret scanning (GitHub push protection) on from day one.

---

## 3. Per-project memory ("mbrains") — Claude Code auto-memory

**Chosen:** the official built-in auto-memory (your selection), configured as a **shared team brain** — one memory store every user can read/write **regardless of which develop branch or PR they're working from.**

Claude accumulates build commands, architecture notes, decisions, and style preferences across sessions. By default this store is per-machine and can drift per branch/worktree; the config below removes both problems.

**How "shared for all users, branch-independent" is achieved (two layers):**

1. **In-repo, committed `memory/`.** Point Claude's memory directory at `./memory` (via `.claude/settings.json`) and **commit it**. Because it lives in version control, the brain travels with every clone, checkout, and PR — no matter whose machine or which branch the PR originates from.
2. **Union-merge to prevent branch divergence.** Add a `.gitattributes` rule so memory files merge additively instead of conflicting:
   ```gitattributes
   memory/** merge=union
   ```
   This lets two branches each append memory and have both survive the merge — so the brain converges rather than forking per PR.
3. **Shared Docker volume (runtime layer).** In `docker-compose.yml`, back `memory/` with a **named volume shared by every `app`/tools container** so concurrent containers see one live copy during a session, not per-container copies:
   ```yaml
   services:
     app:
       volumes: [".:/workspace", "oxot_memory:/workspace/memory"]
   volumes: { oxot_memory: {} }
   ```
   Git remains the source of truth across machines; the volume keeps it consistent within the Docker instance.

**Steps:**
1. `git init`; set the memory path to `./memory` in `.claude/settings.json` and confirm memory is enabled (on by default).
2. Commit `memory/` (do **not** gitignore it) and add the `.gitattributes` union rule.
3. Add the shared named volume in Compose.

**Optional hardening:** to keep the canonical brain clean, treat substantive memory updates like any change — land them on `main` via small PRs — while union-merge absorbs incidental session notes without conflicts.

**Verification:** on branch A record a decision, on branch B record another, merge both → confirm both notes survive (union merge) and a fresh clone on a different machine recalls them.

---

## 4. Superpowers — install via marketplace

Superpowers is a **Claude Code plugin**. This is the one step that requires an **interactive Claude Code session** (the `/plugin` commands run in Claude Code's REPL, not in Cowork). In this setup that REPL runs **inside the dev container**, e.g. `docker compose exec app claude`.

**Chosen (your selection): obra's own marketplace** — gets Superpowers plus the related plugins from Prime Radiant.

**Steps (run inside Claude Code in the dev container, at the project directory):**

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

*(The Anthropic official marketplace — `/plugin install superpowers@claude-plugins-official` — remains a fallback if obra's marketplace is ever unreachable.)*

**What you get automatically** (skills trigger themselves; no config needed): `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents` (this covers your "multi-agent-brainstorming"), `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `using-git-worktrees`, `finishing-a-development-branch`, `writing-skills`, and **`using-superpowers`**.

**Karpathy fit:** Superpowers' brainstorm-first + plan-first + TDD flow reinforces rules 1–4 directly, so the two systems are complementary rather than conflicting. The `CLAUDE.md` will state that when they overlap, **Karpathy rules win**.

> Because the standalone `superpowers-skills` repo is archived, do not `git clone` it. The marketplace delivers current skills.

---

## 5. MCP servers — Context7 + Valyu (`.mcp.json`)

Project-scoped MCP config lives in `.mcp.json` at the repo root so the whole team inherits it.

**Docker-first choice:** run MCP servers with `npx` **inside the dev container** (stdio) — not `docker run` from inside a container. This avoids docker-in-docker (mounting the Docker socket, nested images, permission headaches). For a heavier setup you can instead run each MCP as its own Compose service over HTTP (Section 5c).

### 5a. Context7 (library docs)
Already available in this Cowork session via the Docker MCP. Inside the dev container, use the npm server over stdio:

```jsonc
// .mcp.json (excerpt) — runs in-container, no docker-in-docker
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--transport", "stdio"]
    }
    // Alternative: run mcp/context7 as a sibling Compose service and connect over HTTP (Section 5c)
  }
}
```

**Use:** pull current docs for the exact stack in the project brief — Next.js (latest), Tailwind, shadcn/ui, PostgreSQL + **pgvector**, and Ollama embeddings — so Claude codes against real APIs, not stale memory.

### 5b. Valyu — full development SDK + MCP + skill (all in Docker)
**Chosen (your selection): the full Valyu development stack**, not skill-only. Three layers, all installed **inside the containers** and all reading the key from the **container environment**:

1. **Agent skill** — so Claude uses Valyu automatically:
   ```bash
   # run inside the dev container
   npx skills add valyuAI/skills
   ```
2. **MCP server** — exposes Valyu search/research as tools:
   ```jsonc
   // .mcp.json (excerpt) — key comes from container env, not stored here
   {
     "mcpServers": {
       "valyu": {
         "command": "npx",
         "args": ["-y", "@valyu/valyu-mcp"],
         "env": { "VALYU_API_KEY": "${VALYU_API_KEY}" }
       }
     }
   }
   ```
3. **Development SDK** — for calling Valyu directly from OXOT app code (the AI visitor agent, background research jobs). Pick the SDK matching each service and bake it into that service's image:
   - **Python** (`valyuAI/valyu-py`): add `valyu` to `requirements.txt` / `pyproject.toml` → `pip install valyu` in the `Dockerfile`.
   - **Node/TS** (`@valyu/ai-sdk`): add to `package.json` → `npm install @valyu/ai-sdk` in the build stage.

   Because the SDK is a **build-time dependency baked into the image**, `VALYU_API_KEY` is supplied only at **runtime** via `env_file`/secret — never `ARG`/`ENV` in the Dockerfile (that would bake the secret into image layers).

**Key handling in Docker (important) — applies to all secrets, incl. `VALYU_API_KEY` and `OPENROUTER_API_KEY`:**
- Put real keys in `.env.local` (gitignored): `VALYU_API_KEY=...`, `OPENROUTER_API_KEY=...`
- Inject them into the container via Compose `env_file: .env.local` (or an orchestrator secret / `docker run --env-file`) — **not** `~/.zshrc`, which doesn't persist across container rebuilds.
- Commit only `.env.example` with the names and no values.
- Keep `.env.local` out of the image via `.dockerignore`; never paste a key into `CLAUDE.md`, `.mcp.json`, or `memory/`. Never set keys via Dockerfile `ARG`/`ENV` (they'd persist in image layers).

### 5c. Container topology (Compose)
The MCP servers sit alongside the project's own services. Sketch:

```yaml
# docker-compose.yml (sketch)
services:
  app:            # Next.js + Claude Code dev container; runs npx-based MCPs (stdio)
    build: .
    env_file: [.env.local]
    volumes: [".:/workspace"]
    depends_on: [db, ollama]
  db:             # PostgreSQL (latest) + pgvector; file storage in Postgres per the brief
    image: pgvector/pgvector:pg17
    env_file: [.env.local]
    volumes: ["pgdata:/var/lib/postgresql/data"]
  ollama:         # embeddings — Qwen3-4B (4096-dim)
    image: ollama/ollama
    volumes: ["ollama:/root/.ollama"]
  # Optional: context7 as its own HTTP MCP service instead of in-container npx
  # context7:
  #   image: mcp/context7
volumes: { pgdata: {}, ollama: {} }
```

This keeps everything reproducible in the Docker instance and lets `app` reach `db` and `ollama` by service name on the Compose network.

---

## 6. Custom project skills (authored for OXOT)

These do not exist upstream; the plan is to write them under `.claude/skills/`, each as a `SKILL.md` following Superpowers' `writing-skills` conventions.

1. **`website-alignment`** — enforces the OXOT style contract on every change: the global stylesheet is the single source of truth, dark/light mode always honored, Tailwind + shadcn/ui + Next.js patterns, mobile-first, consistent theming. Triggers when editing components, styles, or pages.
2. **`ai-vector-automation`** — the pgvector + Ollama pipeline: chunk → embed with **Qwen3 4B (4096-dim)** → store in Postgres (with file storage in Postgres) → similarity query. Encodes the exact embedding dimension and table/index conventions so retrieval stays consistent.
3. **`business-analyst`** — turns feature requests into specs, acceptance criteria, and success metrics before code (a natural amplifier of Karpathy rule 4). Feeds Superpowers' `writing-plans`.
4. **`i18n-nl-en`** — **native Dutch + English by default.** Every user-facing string ships in both `nl` and `en`; new pages/components must add both locales or fail review. Defines the locale routing, translation-key structure, and a checklist so nothing ships English-only.

> "using-superpowers" is **not** custom — it arrives with the plugin (Section 4). Listed here only to avoid double-building it.

---

## 7. Bilingual (NL + EN) as a cross-cutting requirement

Beyond the `i18n-nl-en` skill, the plan bakes bilingual support into the whole project:
- **CLAUDE.md rule:** no user-facing string may ship in one language only; both `nl` and `en` are mandatory.
- **Stack:** Next.js i18n routing (`/nl`, `/en`) with a shared translation-key file; the admin CMS stores content per-locale in Postgres.
- **AI agent:** the interactive visitor agent (Section 8) detects/serves the visitor's language and answers in NL or EN accordingly.
- **Review gate:** the `website-alignment` + `i18n-nl-en` skills reject PRs that add English-only copy.

---

## 8. Interactive AI visitor agent — full design pass

**Chosen (your selection): scope the full brainstorm/design now.** This section is the design pass, so setup choices (embedding dim, DB schema, i18n, containers) are made *with* the agent in mind rather than retrofitted. It doubles as the input document for Superpowers' `brainstorming` skill once the base site exists.

### 8.1 Goal & success criteria (Karpathy rule 4)
An agent that (a) watches a visitor's behavior — pages viewed, clicks, dwell time, scroll depth — and (b) proactively aligns its questions and answers to what the visitor is currently looking at, in the visitor's own language (NL/EN). **Success = measurable:** agent answers are grounded in the exact content the visitor is viewing (cited), respond in the correct language ≥99% of the time, and first token arrives fast enough to feel live (target < 1.5s).

### 8.2 Assumptions to confirm before build (Karpathy rule 1)
- Content corpus = the site's own pages/services (plus any uploaded docs), embedded with **Qwen3-4B → 4096-dim** vectors in pgvector.
- Visitor tracking is **first-party, consent-gated** (cookie/GDPR banner — relevant for a NL/EU audience). No behavioral capture before consent.
- Real-time transport is WebSocket/SSE from the Next.js app.
- "Watch and align" = context-aware retrieval + optional proactive prompts, **not** covert surveillance; the visitor sees the agent and can dismiss it.

### 8.3 Architecture
```
Browser (Next.js, /nl or /en)
  │  page/click/scroll/dwell events  ──▶  Event ingest (app API route)
  │  chat (WebSocket/SSE)                        │
  ▼                                              ▼
Agent orchestrator (app service) ──▶ session context store (Postgres)
  │        │                                     ▲
  │        └── retrieval: pgvector similarity ───┘ (site content embeddings, 4096-dim)
  │        └── embeddings: Ollama · Qwen3-4B (Compose service)
  │        └── external research (optional): Valyu SDK/MCP
  │        └── generation: LOCAL Ollama (primary) ──▶ OpenRouter (fallback)
  ▼
LLM response (grounded + cited) ──▶ streamed to visitor in NL/EN
```

### 8.4 Data model (Postgres + pgvector + file storage in Postgres, per brief)
- `content_chunks(id, page_id, locale, text, embedding vector(4096), source_ref)` — HNSW/IVF index on `embedding`.
- `visitor_sessions(id, locale, consent_at, created_at)`.
- `visitor_events(id, session_id, type, page_id, element, ts, meta jsonb)` — the behavioral stream.
- `agent_messages(id, session_id, role, text, cited_chunk_ids, ts)`.
- Uploaded files stored as `bytea`/large objects in Postgres (matches the brief's "file storage on Postgres itself").

### 8.5 Retrieval + behavior fusion (the "align to what they're viewing" part)
1. Current page → its `content_chunks` become a **hard context boost**.
2. Recent `visitor_events` (last N) → build an intent signal (e.g., lingering on pricing → surface pricing Q&A).
3. Query = visitor message (or proactive trigger) → embed → pgvector similarity, **filtered by the active locale and boosted toward the current page**.
4. Answer is generated from retrieved chunks only, with citations; if confidence is low, the agent says so (Karpathy self-check) rather than inventing.

### 8.5b LLM provider strategy — local Ollama primary, OpenRouter backup
**Chosen (your selection):** generation runs on the **local Ollama** service by default; **OpenRouter** is the automatic fallback.
- **Primary:** the same `ollama` Compose service that serves Qwen3-4B embeddings also serves the generation model — everything stays on-box, no per-token cost, data doesn't leave the instance.
- **Fallback triggers:** Ollama unreachable/overloaded, latency past the < 1.5s budget, or a request needing a larger model than the local one. The orchestrator then calls **OpenRouter** and streams that response instead.
- **Provider abstraction:** put a thin `LLMProvider` interface in the `app` so `ollama` and `openrouter` are swappable and the fallback is one policy, not scattered `if`s (Karpathy: simplicity + surgical).
- **Key handling:** `OPENROUTER_API_KEY` lives in `.env.local`, injected as container env (same rules as Valyu — never in the image or committed files). Add it to `.env.example` as a name-only placeholder.
- **Grounding is provider-independent:** citations/low-confidence self-checks apply whether the answer came from Ollama or OpenRouter.

### 8.6 Bilingual behavior
- Locale inferred from the route (`/nl` vs `/en`) and confirmable by the visitor.
- Embeddings and chunks carry a `locale`; retrieval filters to it so NL visitors get NL sources.
- All agent UI strings come from the `i18n-nl-en` skill's translation keys.

### 8.7 Docker footprint
- `app` (Next.js + agent orchestrator + Valyu SDK), `db` (pgvector), `ollama` (Qwen3-4B) — already in the Compose sketch (5c). The agent adds no new container; it's code in `app` talking to `db` and `ollama` by service name.

### 8.8 Privacy / trust (non-negotiable for EU/NL)
- Consent before any event capture; clear "you're talking to an AI" disclosure; visitor can clear their session; retention policy defined up front.

### 8.9 Open design questions for the brainstorm session
- Proactive vs. reactive: may the agent open the conversation, or only respond when addressed?
- Which **specific** models: which Ollama generation model locally, and which OpenRouter model as the fallback tier? (Provider strategy itself is settled — Section 8.5b.)
- How aggressive is behavioral personalization before it feels intrusive?
- Anonymous visitors only, or link sessions to the admin/CRM?

---

## 9. Execution order (when you approve)

1. `git init -b main`; add `.gitignore` (`.env.local`, build artifacts, `node_modules`), `.dockerignore`, `.env.example`.
2. **Create the GitHub repo** and push (Section 2B.1) — via authorized GitHub connector or `gh` CLI. Turn on branch protection + secret scanning.
3. Write **`Dockerfile`** + **`docker-compose.yml`** (Section 5c): `app` (Node + Claude Code), `db` (pgvector), `ollama`; add the shared `memory` volume.
4. Add **`.github/`** — `workflows/ci.yml`, `workflows/release.yml`, `pull_request_template.md`, `CODEOWNERS` (Section 2B.4).
5. Write **`CLAUDE.md`** — Karpathy 10-rule set + self-check protocol, OXOT stack, bilingual mandate, AI-agent + LLM-provider rules, "Karpathy wins on conflict."
6. Configure **shared memory** — `memory/` path in `.claude/settings.json`, commit it, add `memory/** merge=union` to `.gitattributes` (Section 3).
7. Write **`.mcp.json`** for Context7 + Valyu; put `VALYU_API_KEY` + `OPENROUTER_API_KEY` in `.env.local`; wire via Compose `env_file`; mirror to GitHub Actions secrets.
8. `docker compose build && docker compose up -d`; pull the Qwen3-4B model (embeddings + generation) into the `ollama` service.
9. Inside the dev container (`docker compose exec app claude`): install **Superpowers** from obra's marketplace (Section 4); run `npx skills add valyuAI/skills`; install the Valyu **SDK** into the app image (Section 5b).
10. Author the four **custom skills** (Section 6).
11. **Verify** (Section 10).

**Split by environment:** Steps 1, 3–7, 10 (writing files) can be done here in Cowork. Step 2 (repo create) needs the GitHub connector authorized or `gh`. Steps 8–9 (`docker compose` up, plugin/skill/SDK install) run in a terminal against the Docker instance with an interactive Claude Code session — I'll give you the exact commands to paste.

---

## 10. Verification checklist (Karpathy rule: evidence over claims)

- [ ] `CLAUDE.md` loads and the rules are visible to Claude in a fresh session.
- [ ] Auto-memory persists a test decision across a restart.
- [ ] `docker compose up` brings `app`, `db` (pgvector extension present), and `ollama` (Qwen3-4B pulled) healthy.
- [ ] `superpowers` appears in `/plugin` list inside the container; `brainstorming` triggers on a new feature request.
- [ ] Context7 returns live docs for Next.js/pgvector from inside the dev container (no docker-in-docker needed).
- [ ] Valyu returns a search result using `VALYU_API_KEY` from the container env **and** the key is absent from all committed files and the image (`git grep` / image inspect find no key).
- [ ] Each custom skill triggers on its intended prompt.
- [ ] A sample new page ships with both `nl` and `en` strings, or review blocks it.

---

## 11. Decisions — resolved

1. **Superpowers marketplace:** ✅ **obra's marketplace** (`obra/superpowers-marketplace`) — Section 4.
2. **Memory:** ✅ **shared team brain** — committed in-repo `memory/` + union-merge + shared Docker volume, so it's accessible to all users regardless of the develop branch/PR — Section 3.
3. **Valyu:** ✅ **full development stack in Docker** — skill + MCP + SDK (`valyu` / `@valyu/ai-sdk`) — Section 5b.
4. **AI visitor agent:** ✅ **full design pass done now** — Section 8.

### Still to confirm
- ✅ **GitHub repo:** `Planet9v/OXOT-Website-JULY2026`, **public** — created via `gh` after `gh auth login` as Planet9v (Section 2B.1).
- **Public-repo hygiene:** since the repo is public, turn on secret-scanning **push protection** immediately and never commit `.env.local` (already gitignored). All keys stay in GitHub Actions secrets + runtime env.
- **Claude Code container placement:** same `app` container as the Next.js dev server, or its own dedicated `dev`/`tools` service on the Compose network? (Affects where the MCPs and `.env` wire in.)
- **Deploy target:** does `release.yml` just build+push the image to GHCR, or also deploy somewhere (and where)?
- The Section 8.9 brainstorm questions (proactive vs. reactive, specific model names, personalization aggressiveness, anonymous vs. CRM-linked).

---

### Sources
- [obra/superpowers](https://github.com/obra/superpowers) · [superpowers README (raw)](https://raw.githubusercontent.com/obra/superpowers/main/README.md) · [superpowers-skills (archived)](https://github.com/obra/superpowers-skills) · [superpowers-marketplace](https://github.com/obra/superpowers-marketplace)
- [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) · [Karpathy CLAUDE.md grows to ten rules (TechTimes, Jun 28 2026)](https://www.techtimes.com/articles/319214/20260628/karpathy-claudemd-grows-ten-rules-new-self-check-protocol-ai-coding-loops.htm)
- [Claude Code memory docs](https://code.claude.com/docs/en/memory)
- [Valyu agent-skills docs](https://docs.valyu.ai/integrations/agent-skills) · [valyuAI/skills](https://github.com/valyuAI/skills) · [valyuAI/valyu-mcp](https://github.com/valyuAI/valyu-mcp)
- [upstash/context7](https://github.com/upstash/context7) · [mcp/context7 (Docker)](https://hub.docker.com/r/mcp/context7)
