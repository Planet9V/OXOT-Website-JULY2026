# CLAUDE.md — OXOT Website (Planet9v/OXOT-Website-JULY2026)

Project law for any AI coding agent working in this repo. **These rules are binding.**
When any guidance conflicts, **the Karpathy rules in Section 1 win.**

---

## 1. Karpathy rules (the north star)

Derived from Andrej Karpathy's observations on LLM coding pitfalls (Jan 2026), as distilled in the widely-used Karpathy `CLAUDE.md` (grown from 4 core rules to a 10-rule self-check protocol).

**Core four**
1. **Think before coding.** State assumptions explicitly, surface ambiguity, and *ask instead of guessing*. Never invent requirements.
2. **Simplicity first (YAGNI).** Write the minimum code that solves the stated problem. No speculative abstractions, no unrequested features.
3. **Surgical changes.** Do not touch code adjacent to the task. Every changed line must trace to what was asked.
4. **Goal-driven execution.** Convert vague instructions into verifiable success criteria *before* starting.

**Self-check protocol (the expanded set)**
5. **Verify before claiming done.** Show evidence — tests, output, a diff — not assertions.
6. **Report uncertainty.** If unsure, say so and stop; do not bluff or paper over gaps.
7. **Stop when confused.** If you've looped twice without progress, halt and re-plan rather than thrash.
8. **Keep a running assumptions list** in the PR description; update it as facts are confirmed.
9. **Prefer evidence over confidence.** "It should work" is not acceptance; a passing test is.
10. **Leave the tree greener.** Don't introduce lint/type regressions; if you can't verify, don't merge.

---

## 2. What this project is

A professional-services website: modern, reactive, mobile-first, highly interactive, with an
interactive AI agent that watches visitor behavior and aligns answers to what they're viewing.

**Stack (authoritative):**
- **Frontend:** Next.js (latest) + Tailwind CSS + shadcn/ui. A **global stylesheet is the single source of truth**; dark/light mode always enforced through it.
- **Backend/admin:** simple admin system for a small team to log in, edit menus, add pages, and add content.
- **Data:** PostgreSQL (latest) with **pgvector**; **file storage lives in Postgres itself**.
- **Embeddings:** **Ollama, `qwen3-embedding:4b`.** Vector dimension is **1536** (`EMBED_DIM=1536`, decision 2026-07-14). qwen3-embedding:4b emits **2560** natively, so we take the first 1536 dims and L2-renormalize (Matryoshka/MRL truncation) via the shared `fitDim` helper — applied identically in `src/lib/embeddings.ts` (query) and `scripts/ingest.mjs` (index) so vectors share one space. 1536 ≤ 2000 enables a plain pgvector **HNSW** index (no halfvec). The pgvector column, `fitDim`/`EMBED_DIM`, migration 001's placeholder, and migration 035 must all agree at 1536. Changing the dimension requires a full re-ingest.
- **Generation (AI agent):** provider is admin-configurable (`chatProvider`/`embedProvider` in `src/lib/ai-settings.ts`). Design intent is **Ollama as the local/primary path, OpenRouter as automatic fallback**; the shipped production default is **OpenRouter first** because no Ollama host is reachable from Railway.
- **Everything runs in Docker** (see `docker-compose.yml`).

---

## 3. Language — native Dutch + English (non-negotiable)

- **No user-facing string ships in only one language.** Every page, component, email, and agent
  reply must exist in both `nl` and `en`.
- Routing is locale-prefixed (`/nl`, `/en`); translation keys are shared; CMS content is stored per-locale.
- A change that adds English-only copy must fail review. See `.claude/skills/i18n-nl-en`.

---

## 4. The interactive AI visitor agent

- **Retrieval:** pgvector similarity over site-content embeddings (qwen3-embedding:4b, EMBED_DIM), filtered by
  active locale and boosted toward the visitor's current page.
- **Behavioral signals:** first-party, **consent-gated** capture of page/click/scroll/dwell events feeds
  the agent's context. No capture before consent (EU/NL).
- **Generation:** local Ollama first; fall back to OpenRouter on outage/latency/size. One swappable
  `LLMProvider` interface — not scattered conditionals.
- **Grounding:** answers cite retrieved chunks; on low confidence the agent says so (rule 6) rather than inventing.
- Full design in `SETUP_PLAN.md` §8.

---

## 5. How we work — GitHub process

- `main` is protected. **All changes via pull request** off `feature/*`, `fix/*`, or `chore/*`.
- PRs need green CI + review (see `.github/`). Fill in the PR template, including the assumptions list.
- Track work in GitHub Issues/Projects; link PRs with `Closes #n`.
- Superpowers skills (obra marketplace) drive the flow: brainstorm → plan → subagent-driven TDD → review.

---

## 6. Secrets — never commit

- Keys (`VALYU_API_KEY`, `OPENROUTER_API_KEY`, DB creds) live only in `.env.local` (gitignored) and
  GitHub Actions secrets. Never in code, `CLAUDE.md`, `.mcp.json`, `memory/`, or Docker image layers.
- The repo is **public** — treat every commit as world-readable. CI runs a secret scan; push protection is on.

---

## 7. Memory (shared team brain)

- `memory/` is committed and shared across all users and branches; it uses `merge=union` (see `.gitattributes`)
  so notes converge rather than conflict. Record durable decisions here, not one-off chatter.

---

## 8. Definition of done (enforce rule 5)

- [ ] Tests written and passing (TDD: red → green → refactor).
- [ ] Both `nl` and `en` strings present for any user-facing change.
- [ ] No new lint/type errors; no secrets added.
- [ ] Global stylesheet respected; dark/light both verified.
- [ ] PR description lists assumptions and shows evidence.
