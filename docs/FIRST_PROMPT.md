# First Claude Code session — starter prompt

Paste the block below as your first message in `claude` (after trusting the folder; if you just installed Superpowers, quit and relaunch `claude` so its skills load — there is no live reload).

---

You are working in the OXOT Website repo. Before doing anything else, read, in this order:
`CLAUDE.md`, `docs/HANDOFF.md`, `docs/ARCHITECTURE.md`, `SETUP_PLAN.md`, and `memory/decisions.md`.
Then check `.claude/skills/` and use the Superpowers skills — invoke `using-superpowers` and follow the brainstorm → writing-plans → TDD → code-review flow.

Binding rules: follow `CLAUDE.md` §1 (Karpathy rules) — they win on any conflict. Specifically: state assumptions and ask before guessing; keep changes surgical; verify with evidence (tests/output), never claim done without it; report uncertainty instead of bluffing. Respect the GitHub PR flow (§5): no direct commits to `main`; work on a `chore/*` or `feature/*` branch and open a PR using the template.

Context you must know: the repo is a complete scaffold but has NEVER been built or run — no `npm install`, `tsc`, `next build`, `docker compose`, migrations, or tests have executed yet. My local Ollama already has `qwen3.5:9b` (generation) and `qwen3-embedding:4b` (embeddings, 2560-dim). Secrets go only in `.env.local` (gitignored); never commit them.

Milestone 1 — establish a verified green baseline (do this before any feature work):
1. Confirm prerequisites and surface any assumptions/questions you have BEFORE running anything.
2. On a `chore/baseline` branch: `cp .env.example .env.local` (tell me which values I must fill), then `docker compose build && up`, `npm install`, `npm run typecheck`, `npm run build`, `npm run db:migrate`, `npm run ingest`, and create an admin user.
3. Fix whatever the real build/typecheck surfaces — the scaffold was only syntax/​import-checked in Cowork, not type-checked. Keep fixes surgical and explain each.
4. Show me evidence: command output for typecheck, build, migrate, and a working `/en` + `/nl` page and `/admin/login`.
5. Open a PR for the baseline.

Milestone 2 (only after I approve Milestone 1) — set up the test harness and write the first tests, since the Definition of Done requires TDD and there are currently none. Propose the test stack (assume Vitest unless you have a better reason), then TDD-cover `src/lib` (retrieval, auth, llm fallback) and the API routes.

Start by reading the files above and giving me: (a) a short summary of the current state in your own words, (b) your assumptions and any questions, and (c) your proposed plan for Milestone 1. Do not write code until I approve the plan.

---

## Why this prompt works
- **Loads context in priority order** so rules and architecture anchor the session.
- **Triggers the Superpowers workflow** (`using-superpowers` → plan → TDD → review).
- **Forces a green baseline before features** — the scaffold was only syntax-checked in Cowork, so a real `tsc`/`build` pass is the first job.
- **Encodes the Karpathy guardrails + PR flow** so it won't sprawl or commit to `main`.
- **Ends with plan-before-code**, matching rule 1 (think first, ask, don't guess).
