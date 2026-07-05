# OXOT Website

Professional-services website — modern, reactive, mobile-first, bilingual (NL + EN), with an
interactive AI visitor agent. Everything runs in Docker; GitHub is the source of truth.

**Repo:** `Planet9v/OXOT-Website-JULY2026` (public)

## Stack
- Next.js (latest) + Tailwind + shadcn/ui, global stylesheet enforced, dark/light mode
- PostgreSQL + pgvector (file storage in Postgres), Ollama embeddings (Qwen3-4B, 4096-dim)
- AI agent generation: local Ollama primary, OpenRouter fallback
- Research: Valyu (skill + MCP + SDK); docs: Context7 MCP
- Dev methodology: Superpowers (obra) + Karpathy rules (see `CLAUDE.md`)

## Quick start
```bash
cp .env.example .env.local     # fill in real keys — NEVER commit .env.local
docker compose build
docker compose up -d
# pull models into the ollama service:
docker compose exec ollama ollama pull qwen3-embedding-4b
docker compose exec ollama ollama pull qwen2.5:7b
# work inside the dev container:
docker compose exec app claude
```

## Inside the dev container (one-time)
```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
npx skills add valyuAI/skills
```

## Docs
- `docs/HANDOFF.md` — **start here in Claude Code** (first-session runbook)
- `docs/ARCHITECTURE.md` — system design (data model, APIs, trade-offs)
- `SETUP_PLAN.md` — full setup plan narrative
- `CLAUDE.md` — project law (Karpathy rules, stack, i18n, agent)
- `.claude/skills/` — custom project skills

## Superpowers + Karpathy
- **Karpathy rules** are installed as project law (`CLAUDE.md` §1) and a project skill (`.claude/skills/karpathy-guidelines`) — active in every session.
- **Superpowers** is declared in `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`), so opening this repo in Claude Code and trusting the folder prompts you to install it. It also auto-installs in the dev container via `npm run claude:bootstrap` (also run by the devcontainer `postCreateCommand`). It runs:
  `claude plugin marketplace add obra/superpowers-marketplace` then
  `claude plugin install superpowers@superpowers-marketplace --scope project`, and `npx skills add valyuAI/skills`.

## Admin (CMS)
```bash
# after db:migrate, create your first admin (inside the container)
node scripts/create-admin.mjs you@oxot.example 'a-strong-password'
# then visit /admin/login  (AUTH_SECRET must be set in .env.local)
```
The admin lets the team manage pages and menu items per locale; publishing a page
requires both nl and en to exist (bilingual guard).
