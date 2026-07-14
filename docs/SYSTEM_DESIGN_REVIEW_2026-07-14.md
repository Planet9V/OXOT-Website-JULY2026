# OXOT Website — System-Design Review & Source-App Gap Analysis
**Date:** 2026-07-14 · **Reviewer:** AI agent · **Method:** full read-only inventory of both codebases + targeted verification greps. Every claim below was confirmed against real files, not assumed.

Two codebases were compared:
- **Current app** — `OXOT_Website_JULY2026` (Next.js 15 App Router, raw `pg`, pgvector, Ollama+OpenRouter, bilingual URL routing, Railway).
- **Source app** — `Celestial-Agent-Nexus` (pnpm monorepo: two Vite SPAs + Express 5 API + Drizzle; OpenAI via Replit proxy + OpenRouter embeddings; GCS object storage).

---

## Part 1 — System-design critique (critical thinking)

### What is genuinely good today
- **Clean provider seam.** `src/lib/llm/{provider,ollama,openrouter,stream,index}.ts` is a real `LLMProvider` interface with streaming + non-streaming failover — this matches CLAUDE.md and is better factored than the source, which hard-codes OpenAI.
- **Agent is spec-aligned.** `/api/agent` is consent-gated (403 without `consent_at`), RAG-grounded over `content_chunks`, streams deltas, cites `[id]`, and is boosted toward the visitor's current page. The current app captures **page/click/scroll/dwell** via `/api/events` — the source only ever captured page views, so this app is *closer* to the "watch visitors and align to their clicks" brief than the thing it was ported from.
- **SSR SEO done natively.** `app/sitemap.ts` + `app/robots.ts` + `lib/seo.ts` (canonical/alternates/JSON-LD) replace the source's Vite crawler-UA hack cleanly.
- **URL-prefixed i18n** (`/nl`, `/en`) is correct; the source kept locale in client state, which is worse for SEO and sharing.

### Where the design is thin or risky (the honest part)
1. **Public endpoints have almost no abuse protection.** Only `/api/contact` rate-limits. `/api/agent` (which spends Ollama/OpenRouter tokens), `/api/newsletter/subscribe`, `/api/events`, and `/api/track` are open. The source had an in-memory fixed-window limiter on chat + newsletter; that was dropped in the port. On a public repo + public site this is the single biggest exposure — a scripted client can run up model cost or flood tables.
2. **"Scheduled" newsletters never fire.** `api/admin/newsletters/[id]/schedule` only sets `status=scheduled` with a literal `// A cron/worker to fire scheduled…` TODO. There is no worker. The feature is a UI that quietly does nothing at the scheduled time.
3. **pgvector runs on sequential scan.** The ANN index in `001_init.sql` is commented out. Fine at seed scale, but retrieval cost grows linearly with the corpus and there is no plan to add HNSW.
4. **Embeddings go stale silently.** Reindex is a manual admin button (`/api/admin/content/reindex`). Publish a page → the agent can't cite it until a human remembers to reindex. The source auto-scheduled a coalesced reindex after publish/delete.
5. **No editorial safety net.** Pages are edited in place — no draft/publish separation, no version history, no restore. For a "small team editing content simply," one bad save is unrecoverable. The source had `page_versions` + restore.
6. **Bilingual law is enforced by hand.** CLAUDE.md says no string ships in one language, yet NL content is hand-seeded per migration. There is no tooling to guarantee or assist parity, so drift is a matter of time. The source had AI EN↔NL translation built into the CMS.

---

## Part 2 — Five improvements (low-to-mid ICE)

ICE = Impact × Confidence × Ease, each scored 1–10; **Score = mean of the three** (higher = do sooner). All five are deliberately low-to-mid effort — quick-to-moderate wins, not moonshots.

| # | Improvement | Impact | Confidence | Ease | ICE | Why it's worth it |
|---|-------------|:---:|:---:|:---:|:---:|-------------------|
| 1 | **Add pgvector HNSW index** on `content_chunks.embedding` (one migration; uncomment + `CREATE INDEX … USING hnsw (embedding vector_cosine_ops)`) | 5 | 9 | 9 | **7.7** | Removes the only structural scaling flaw in retrieval; trivially reversible; makes agent latency flat as the corpus grows. |
| 2 | **Rate-limit public endpoints** (`/api/agent`, `/api/newsletter/subscribe`, `/api/events`, `/api/track`) with a small in-memory fixed-window limiter — port the source's `rateLimit.ts` pattern | 8 | 8 | 7 | **7.7** | Caps model-cost and spam abuse on a public repo/site; the pattern already exists in the source, so it's a lift-and-adapt. |
| 3 | **Auto-reindex on publish/save** — call the existing `ingestPage()` from the pages/site-content save routes (fire-and-forget, coalesced) | 6 | 8 | 7 | **7.0** | Kills the "agent can't see new content" gap; reuses code that already exists; no new infra. |
| 4 | **AI EN↔NL translation assist** in admin — one route + a "Translate to NL/EN" button, reusing the `LLMProvider` already wired | 7 | 7 | 6 | **6.7** | Directly serves the non-negotiable bilingual rule; turns a manual migration chore into a click; provider is already there. |
| 5 | **Real scheduled-send worker** — a single guarded cron route (`/api/cron/newsletters`) hit by Railway Cron that runs `runDueScheduledSends()` (single-flight) | 6 | 7 | 6 | **6.3** | Makes an already-built feature actually work; small, isolated, and testable; Railway Cron is native. |

> Deliberately excluded as *above* mid-effort (belongs on a roadmap, not a quick win): full CMS draft/publish + version history, and the entire CRA conformity execution engine (see Part 3, IDs 1–2).

---

## Part 3 — What has NOT been brought over from the source app

Verified gaps. "Comparable?" notes where both apps have a related thing but differ. Significance: **High** = product/security/legal, **Med** = notable capability, **Low** = nice-to-have. IDs are stable for follow-up.

| ID | # | Feature not ported | Significance | Why it matters | Difference (source → current) |
|----|---|--------------------|:---:|----------------|-------------------------------|
| G-01 | 1 | **CRA conformity *execution* engine** — assessments, products, answers, evaluations, grading, evidence, auto-generated artifacts (Declaration of Conformity, technical doc, SBOM, CVD policy, risk assessment), and the CRA incident clock (24h/72h/14-day) | **High** | This is the source's flagship *product* — a real regulatory decision-support tool, an entire second SPA. The current app ships only the **reference** layer (regulations/themes/requirements/mappings/sources as marketing pages). | Source: `conformityEngine.ts`, `craFlow.ts`, 11 execution tables, wizard SPA. Current: reference pages only (migration 021); **no** assessments/grading/artifacts/incidents. Comparable on the *reference* half; the *working* half is entirely absent. |
| G-02 | 2 | **CMS draft/publish + version history + restore** | **High** | Editorial safety for a small team; one bad edit is currently unrecoverable. | Source: `page_versions`, draft vs published state, `versions/:id/restore`. Current: `pages` edited in place, no versions. Comparable feature area, capability missing. |
| G-03 | 3 | **Rate limiting on public endpoints** | **High** | Cost/abuse protection on a public site + public repo (agent burns model tokens). | Source: in-memory limiter on chat + newsletter. Current: only `/api/contact`. Partially comparable; agent/newsletter/events unprotected. |
| G-04 | 4 | **Working scheduled newsletter sender** | **High** | Scheduling exists in the UI but silently never fires — a broken promise to the user. | Source: `runDueScheduledSends()` on a 60s scheduler. Current: schedule endpoint sets status + a `// cron/worker` TODO; no worker. UI comparable, execution missing. |
| G-05 | 5 | **AI page wizard** (generate full page sections from a prompt) | Med | Speeds content creation for the small team. | Source: `/admin/wizard/generate`, `aiContent.ts`, `page_templates`. Current: none (grep for wizard/generate → empty). Not comparable — absent. |
| G-06 | 6 | **AI EN↔NL translation** in CMS | Med | Serves the bilingual "no single-language string" law; removes hand-seeding. | Source: `/admin/pages/:id/translate`. Current: NL hand-seeded per migration. Not comparable — absent. |
| G-07 | 7 | **AI-generated analytics recommendations** | Med | Turns the dashboard from numbers into next actions. | Source: `/admin/analytics/recommendations`. Current: aggregates only, no AI layer. Dashboards comparable; AI layer missing. |
| G-08 | 8 | **AI affiliate keyword suggest + auto-insert links** into page copy | Med | The "smart" half of affiliate monetization. | Source: `affiliate.ts` suggest/apply. Current: affiliate links CRUD + `/go/:id` redirect only. Comparable on CRUD/tracking; AI automation missing. |
| G-09 | 9 | **AI newsletter draft generation** from a topic | Med | Faster campaign authoring. | Source: `/admin/newsletters/generate`. Current: manual compose + send only. Comparable on send; generation missing. |
| G-10 | 10 | **LinkedIn OAuth flow + token-expiry watcher** | Med | Robust, self-renewing social auth with admin email alerts before expiry. | Source: `/admin/social/linkedin/oauth/{start,callback}` + 60s expiry watcher. Current: `social.ts` posts with manually-configured tokens; no OAuth, no watcher. Comparable on posting; auth lifecycle missing. |
| G-11 | 11 | **Newsletter open-tracking pixel** (1×1 GIF) | Med | Open-rate metrics; `newsletter_sends` has the rows but nothing to increment. | Source: `GET /newsletter/track/open/:sendId`. Current: no pixel route. Schema comparable; tracking endpoint missing. |
| G-12 | 12 | **Auto-reindex of embeddings on content change** | Med | Keeps the agent citing current content without human action. | Source: coalesced `scheduleReindex()` after publish/delete. Current: manual reindex button only. Comparable capability, automation missing. |
| G-13 | 13 | **Inline lead capture inside the chat agent** | Med | Converts an engaged chat visitor into a lead in-flow. | Source: `leads` table + `/chat/:id/lead` + widget form. Current: separate `/contact` form + inquiries; agent doesn't capture leads. Related but not the same funnel. |
| G-14 | 14 | **Integration observability — activity feed + health snapshots** | Med | One place to see "did the last LinkedIn/SMTP call succeed?" | Source: `integration_events` table, `/admin/integrations/{health,activity}`. Current: settings + test-email only. Comparable on config; observability missing. |
| G-15 | 15 | **Page templates** (reusable page configs) | Low | Faster consistent page creation. | Source: `page_templates` CRUD. Current: none. Absent. |
| G-16 | 16 | **PDF-to-carousel rasterization** (upload a PDF → per-page slides) | Low | Convenience for producing hero decks. | Source: `pdf.ts` via poppler `pdftoppm`. Current: carousel takes image slides only. Comparable on carousel; PDF ingest missing. |
| G-17 | 17 | **Native LinkedIn/X social-feed embeds** on the public site | Low | Social proof on the marketing pages. | Source: social-feed embed widgets. Current: footer social links are a `TODO` placeholder. Absent. |
| G-18 | 18 | **Structured request logging** (pino/pino-http) | Low | Production debuggability. | Source: pino across the API. Current: ad-hoc `console`/no structured logger. Comparable intent; discipline missing. |

### Deliberate divergences (NOT gaps — the current app chose differently, mostly per CLAUDE.md)
- **LLM/embeddings:** source uses OpenAI (gpt-5.4-mini) + OpenRouter `text-embedding-3-small` (**1536-dim**); current uses **Ollama qwen3 + OpenRouter fallback** via a real `LLMProvider` (EMBED_DIM 2560). Current matches the brief; source does not.
- **Storage:** source uses **Google Cloud Storage** (Replit sidecar, presigned + ACL); current stores **files in Postgres** per CLAUDE.md. Intentional.
- **Locale:** source client-state; current **URL-prefixed `/nl` `/en`**. Current is better.
- **SEO:** source injects meta via a Vite crawler-UA middleware; current uses **native Next `sitemap.ts`/`robots.ts` + metadata**. Current is cleaner.
- **Behavioral capture:** current captures **page/click/scroll/dwell**; source captured page views only. Current is *ahead*.
- **Stack:** Vite SPA + Express → **Next.js App Router**. Intentional re-platform.

---

## Verification notes (evidence, per Karpathy rule 5)
- Absences confirmed by grep, not assumption: AI generation features (`wizard|translate|suggest|recommend` in `src/app/api/admin` + `src/lib`) → **no matches**. Rate limiting → only `contact`. Scheduled send → only a TODO comment. Open pixel / conformity execution tables / LinkedIn OAuth / integration_events → **not present**.
- Confirmed present (so *not* listed as gaps): `app/sitemap.ts`, `app/robots.ts`, `LLMProvider` failover, consent-gated agent, `/api/events` behavioral capture, URL-locale routing.
- Migration set audited: 001–033 (no 027); conformity migration 021 seeds the reference layer only.
