# OXOT — Orchestration Plan (2026-07-14)

Owner: AI orchestrator. Source of truth for the multi-phase build the user requested. Grounded in a full read of **both** codebases (not reverse-engineered). Binding rules: `CLAUDE.md` Karpathy rules; **2560-dim embeddings everywhere**; **Ollama primary + OpenRouter fallback, no Replit/OpenAI**; **files stored in Postgres**; **zero page-content loss (NL or EN)**.

---

## 0. Ground truth (verified this session)
- **Railway HEAD = `b754c7a` (Analytics).** The Affiliate & SEO, Carousel, and AI-reskin work from last session is built **locally but never pushed** (the Finder ship was blocked by a locked screen). → This is *why* the user sees no SEO page live and an old AI page. First action: ship the backlog.
- **Media is already done and Postgres-backed** — `media` table, `/api/media/[id]` streams bytes from Postgres, `media-manager.tsx` with crop/zoom/pan + PDF. The user's screenshot #2 is *our* app. Requirement "no media page" is already satisfied; we only verify + wire references into pages/newsletters.
- **Source's AI page is itself half-wired:** 6 role selectors but only `briefModel` + `translationModel` are consumed at runtime; chat/embeddings/search/longContext are decorative. "Use the whole page, not just show it" applies to the source too — we must actually wire them.
- **Source has NO Gmail OAuth** — email is SMTP + Gmail App Password only. True Gmail OAuth2 is net-new work, not a port.
- **Behavioral capture is already ahead of source** (page/click/scroll/dwell vs page-views-only). Keep; add first-visit proactive greeting.

---

## Phase 1 — Ship the backlog + safe foundation (low risk, high value)
1. **Push the uncommitted admin batch** (Affiliate & SEO, Carousel, AI reskin, carousel wiring) so live catches up to local. Verify SEO/Carousel/Affiliate render on Railway.
2. **pgvector HNSW index** on `content_chunks.embedding` (migration, `vector_cosine_ops`) — 2560-safe. *(ICE 7.7)*
3. **Rate limiting** on `/api/agent`, `/api/newsletter/subscribe`, `/api/events`, `/api/track` — port source's in-memory fixed-window limiter. *(ICE 7.7)*

## Phase 2 — Zero-loss CMS: draft/publish + version history (CRITICAL)
Tables: keep `pages`; add `page_versions` (full JSON section snapshots, `state` draft|published|archived, `versionNumber`, `note`). Migration **snapshots every existing page's current content into a v1 `published` version before anything else** so nothing pre-existing is at risk.
- API: `GET/PUT /admin/pages/:id/draft`, `POST .../publish`, `GET .../versions`, `POST .../versions/:id/restore`.
- **Zero-loss hardening (beyond source):** snapshot-before-overwrite on every draft save; snapshot the counterpart-locale draft before any AI translation writes it; publish + restore fully transactional; nothing hard-deleted.
- Editor UI: draft/publish/versions/restore controls; live preview; unsaved-changes guard.

## Phase 3 — AI EN↔NL translation (serves the bilingual law) *(ICE 6.7)*
- `POST /admin/pages/:id/translate` using the existing `LLMProvider` (translation role from the AI page). Section-by-section, preserve JSON structure, never translate urls/icons/numbers/bools.
- **Guarded by Phase 2's snapshot-before-write** so existing NL/EN drafts are never clobbered. Confirm/preview before it writes.

## Phase 4 — Auto-embeddings (no manual reindex) *(ICE 7.0)*
- Call `ingestPage()` fire-and-forget (coalesced) from page publish/save + site-content save, so the agent always sees current content. 2560-dim only.

## Phase 5 — Full "AI & Models" page, truly wired
Port the 6-role layout (Assistant chat, Wizard & briefs, Translation, Long context, Embeddings, Web search) but wired to **our** providers:
- Providers card: **Ollama (local)** + **OpenRouter (fallback)**; "Connected" = env/host present.
- Catalog = Ollama models + OpenRouter models (Claude Haiku, GPT-4o-mini, Gemini, Perplexity Sonar for web search).
- **Wire for real:** chatModel→agent, briefModel→wizard/newsletter/affiliate/analytics drafts, translationModel→Phase 3. **Embeddings row locked to qwen3 2560** with a "changing needs reindent + is dimension-critical" guard. Web search (Perplexity Sonar) + long-context = wired if in scope (see open decision).
- Persist in `app_settings.llm_config` (jsonb, merge-over-defaults, empty=unchanged).

## Phase 6 — Full "Integrations" page + real connections
Port the full page (config + test + health + activity feed), all reading creds from `app_settings` at call time:
- **Email:** SMTP + test send. Gmail via App Password by default; **Gmail OAuth2 = open decision** (net-new).
- **LinkedIn:** full OAuth 2.0 authorization-code flow (`/oauth/start|callback|redirect-uri`, scopes `openid profile w_member_social`, HMAC-signed state, token stored in `app_settings`, 7-day expiry email watcher).
- **X:** OAuth 1.0a (4 creds) + verify.
- `integration_events` table + health snapshots (jsonb_set subpath writes) + activity feed.
- **Scheduled-send worker** *(ICE 6.3)*: a guarded `/api/cron/*` route hit by Railway Cron running `runDueScheduledSends()` (single-flight). Also drives the LinkedIn expiry watcher.

## Phase 7 — Visitor UX
- **First-visit proactive chat greeting:** on a first-time visitor (no stored session), after consent, the widget auto-opens with a localized "Hi 👋" intro. Respect reduced-motion; once per visitor (localStorage flag); never before consent.
- Keep/parity-check behavioral capture.

---

## Decisions (CONFIRMED 2026-07-14)
- **D1 — Gmail sending → FULL Gmail OAuth2.** Build a real Google OAuth2 flow (nodemailer OAuth2 transport or Gmail API), configurable in admin, mirroring the LinkedIn OAuth pattern. Requires the user to register a Google Cloud OAuth app + consent screen; admin stores client id/secret/refresh token in `app_settings`.
- **D2 — AI page scope → WIRE ALL 6 ROLES.** Also build live Perplexity-Sonar web-search answer path + long-context routing via OpenRouter, in addition to chat/brief/translation + locked qwen3-2560 embeddings.

## Ship + verify discipline (every phase)
- `npx tsc --noEmit` clean; migrations `pglast`-validated + idempotent; seeds via migrations (Railway pre-deploy runs only `db:migrate`).
- Push via Finder `scripts/ship-*.command`; verify live via browser; both `nl` + `en`.
- No secrets committed. Both light/dark verified. Update this plan's checkboxes as phases land.
