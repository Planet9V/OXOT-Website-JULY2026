# OXOT Website — Remediation Plan (gaps 1–5)

> **Status — 2026-07-06: EXECUTED (waves A–D).** All five items implemented on
> `feature/remediation-1-5`. #2, #3, #4, #5 complete with evidence (29 passing
> Vitest tests, `tsc` clean, i18n balanced). #1 code fix done (agent `pageId`);
> its live agent/CMS smoke + branch protection run via
> `scripts/verify-remediation.command`; ship via `scripts/ship-remediation.command`.
> Remaining human steps: set `OPENROUTER_API_KEY` (agent fallback), run the two
> `.command` scripts, and have a lawyer/native reviewer sign off Dutch + regulatory copy.


Grounded in a code review on 2026-07-06. Each item lists the goal, what the code
actually does today, the concrete tasks (with files), how we prove it's done
(evidence, per Karpathy rule 5), and effort. Work lands via `feature/*` PRs.

**Recommended order:** 2 → 3 → 1 → 4 → 5 (quick visual/SEO wins first, then verify
the interactive features, then the form, then lock it down with tests).

---

## 1. Verify + fix the AI agent and the admin CMS end-to-end

**Goal / done-when:** an admin exists and can log in, create/edit/publish a
page in both locales, and manage menus + SEO fields; and a visitor can accept
consent, ask the chat widget a question, and get a **streamed, grounded** answer
that cites content — verified with evidence (screenshots + a saved `agent_messages` row).

**Current state (from code):**
- `/api/agent/route.ts` is sound: consent-gated, retrieves locale-filtered chunks, builds a grounded system prompt, streams via `chatStream`, persists user + assistant turns with provider + citations.
- **Bug:** `src/app/[locale]/layout.tsx` renders `<ChatWidget … pageId="home" />` — hardcoded. The current-page boost in `retrieve()` therefore always boosts toward `home`, not the page the visitor is on.
- **Generation dependency:** `chat`/`chatStream` use Ollama (`qwen3.5:9b`) first, OpenRouter fallback. `.env.local` has `OPENROUTER_API_KEY` **blank**, so if the Ollama chat model isn't pulled/reachable the agent fails with no fallback.
- **Never exercised:** no admin user was created (`create-admin.mjs` never run); `/api/session`, `/api/events`, `/api/agent` and the admin CRUD/publish/menus were never tested.

**Tasks:**
1. **Create an admin** and smoke the admin: `docker compose exec app node scripts/create-admin.mjs admin@oxot.nl '<pw>'`; log in at `/admin/login`; create a throwaway `nl`+`en` page, exercise the **bilingual publish guard** (publish blocked until both exist), the SEO fields, `menu-manager`, and delete. Fix any bug found.
2. **Fix `pageId`**: pass the real page id into `ChatWidget`. Move it out of the shared layout (or thread the current slug through) so the widget knows the actual page. On the home page use `"home"`; on `[slug]` pages use the slug.
3. **Guarantee a working generation path**: confirm `qwen3.5:9b` is pulled on the host (`ollama list`) and reachable from the container (`node -e fetch(host.docker.internal:11434)`); if not, set `OPENROUTER_API_KEY` in `.env.local` so the fallback works. Read `src/lib/llm/stream.ts` and `ollama.ts`/`openrouter.ts` to confirm the streaming contract; fix if the stream shape is wrong.
4. **End-to-end test in the browser**: on `/en/nis2`, open the widget → Accept → ask "What are the NIS2 reporting deadlines?" → confirm a streamed, grounded answer citing `[id]`s; confirm a row lands in `agent_messages`.

**Evidence:** admin screenshots (login, page published, menu edited); a browser screenshot of a grounded agent answer; `select count(*) from agent_messages`.
**Effort:** M (mostly verification + 1–2 small fixes). **Owner:** Opus (drives), with fixes inline.

---

## 2. Fix the diagrams (and the whole site) in light mode

**Goal / done-when:** every page — especially the inline SVG diagrams — is legible
and on-brand in **both** dark and light mode.

**Current state:** `globals.css` light mode is paper bg + ink + orange primary.
The Markdown renderer wraps ```svg blocks in a `figure` with `bg-muted/20`
(light in light mode), while the framework SVGs draw light text (`#e5e7eb`,
`#cbd5e1`) — so on a light background the diagram text is near-invisible. 6
framework pages are affected.

**Tasks:**
1. **One-line renderer fix (best):** give the ```svg `figure` in `src/components/markdown.tsx` a **fixed dark panel** background (navy `#102030` + subtle border) regardless of theme, so the light-on-dark diagrams always read. This fixes all 14 diagrams at once without editing each SVG.
2. **Audit the rest in light mode:** tables (`bg-muted/50` header), callouts (the orange/green tints), the carousel, the hero visual, code blocks, and body contrast (muted-foreground on paper). Adjust any low-contrast token.
3. Verify with the theme toggle on a content page + the home page.

**Evidence:** screenshots of `/en/cra` (diagram + table + carousel) and `/en` in **light** mode; a quick WCAG-AA contrast check on text/accent pairs.
**Effort:** S. **Owner:** Opus.

---

## 3. Bilingual SEO plumbing (hreflang, sitemap, robots, metadata, JSON-LD)

**Goal / done-when:** search engines can crawl and correctly index both locales;
every important page has proper title/description/OG; `/en`↔`/nl` are linked via
`hreflang`.

**Current state:** `src/app/layout.tsx` metadata is `{ title: "OXOT", description: "Professional services" }` — generic, no `metadataBase`, no title template. Home/services/about have **no** `generateMetadata`. **No** `hreflang`/alternates, `sitemap`, `robots`, or JSON-LD anywhere. `[slug]` pages do have per-page metadata (good).

**Tasks:**
1. **Root layout:** add `metadataBase`, a title template (`%s | OXOT`), and default description/OpenGraph (site name, locale, a default OG image).
2. **hreflang:** in `[locale]/layout.tsx` (or a shared metadata helper) set `alternates.languages = { en: /en…, nl: /nl… }` and `alternates.canonical` for every route, including `[slug]`.
3. **Home / services / about / frameworks / contact metadata:** add `generateMetadata` (or seed those as CMS pages so they inherit the `[slug]` metadata path — decision below).
4. **`src/app/sitemap.ts`:** enumerate both locales × all **published** pages (query `pages`) + the static routes (home, services, about, blog, contact) with `alternates`. **`src/app/robots.ts`:** allow all, point to the sitemap.
5. **JSON-LD:** `Organization` on the home page; `Article` on `content_type='article'` pages (author, datePublished from `published_at`).
6. **Default OG image:** add a branded 1200×630 share image (navy/orange) in `public/`, referenced by default; per-page `og_image` overrides it (already supported in the schema).

**Decision needed:** are `services`/`about`/`frameworks`/`contact` best kept as CMS pages (then they already get `[slug]` metadata + just need hreflang) or hard-coded routes? Recommend: keep as CMS pages; only `home` needs bespoke metadata.

**Evidence:** `curl -s localhost:3000/sitemap.xml`; view-source of `/en` and `/nl` showing `<link rel="alternate" hreflang>` + JSON-LD; a rich-results/OG check.
**Effort:** M. **Owner:** Opus (code) + Sonnet (OG image asset if needed).

---

## 4. Build a real contact form

**Goal / done-when:** a visitor can submit an enquiry from `/en/contact` and
`/nl/contact`; it's validated, stored, spam-resistant, bilingual, and the team
can see submissions.

**Current state:** `contact` is a static CMS stub ("form coming soon"). No form, no
API, no storage.

**Tasks:**
1. **Schema:** migration `006_contact.sql` — `contact_messages (id, name, email, company, message, locale, page, created_at, handled bool)`.
2. **API:** `src/app/api/contact/route.ts` (POST) — validate (name/email/message, email format), a **honeypot** field + a simple per-IP rate limit, insert into `contact_messages`. Return `{ok}` / field errors.
3. **UI:** `src/components/contact-form.tsx` (client) — bilingual labels from the dictionaries, inline validation, success/error state, disabled-while-submitting. Render it on a dedicated `src/app/[locale]/contact/page.tsx` that shows the CMS `contact` body **above** the form (so the copy stays CMS-editable).
4. **Admin view (optional, recommended):** a read-only list of submissions in the admin dashboard (`/api/admin/contact` GET + a table) so the team actually sees leads.
5. **Email (deferred):** no SMTP/Resend creds today — store in DB now; add email delivery (Resend/SMTP) when a key exists. Note in the wiki.

**Evidence:** submit the form in both locales → rows in `contact_messages`; honeypot + a missing-field case rejected; screenshots.
**Effort:** M. **Owner:** Opus (code), Sonnet (bilingual microcopy).

---

## 5. First automated test suite (start the DoD/TDD baseline)

**Goal / done-when:** `npm test` runs green in CI, covering the highest-risk pure
logic and a couple of API/route contracts — the start of the TDD baseline your
`CLAUDE.md` §8 requires.

**Current state:** no test runner, no tests, no `test` script. `ci.yml` already
calls `npm test --if-present`, so adding tests wires straight into CI.

**Tasks:**
1. **Add Vitest** (+ `@testing-library/react` for component render) as devDeps; add `"test": "vitest run"` and `"test:watch"`; a minimal `vitest.config.ts` (jsdom for component tests).
2. **Unit tests (highest value first):**
   - `markdown.tsx` — the parser: tables, callouts, fenced svg/carousel/html, unclosed fence, empty cells, **heading-anchor de-dup**, and a no-infinite-loop guard on pathological input.
   - `seed-pages.mjs` frontmatter parser — a `:` inside a value, quoted values, missing frontmatter, `published` default.
   - `auth.ts` — `hashPassword`/`verifyPassword` round-trip + wrong password; `makeSessionToken`/`verifySessionToken` valid / tampered / expired.
   - `retrieval` / `content` — assert the SQL is parameterized and the vector literal is well-formed (pure-shape test, mock `pool`).
3. **Route/contract tests (mock `pg` pool):** `/api/admin/pages` POST validation + the bilingual publish 409; `/api/agent` 400/403/404 guards (no consent, no session).
4. **CI:** confirm `npm test` runs in `ci.yml`; make failures block (once branch protection is on — see below).
5. **(Later) Playwright smoke:** home renders, a framework page renders with a diagram, admin login — a follow-up, not this pass.

**Evidence:** `npm test` output (all green) locally and in the PR's CI run.
**Effort:** M–L. **Owner:** Sonnet (writes tests) + Opus (QA/coverage).

---

## Cross-cutting (do alongside)

- **Turn on `main` branch protection** + require the CI check (your §5 isn't actually enforced — PRs have been self-merged). One `gh api` call.
- Update `memory/decisions.md` and the wiki as each item lands.

## Rough sequencing

| Wave | Items | Why |
|---|---|---|
| A | #2 light mode, #3 SEO | Fast, visible, low-risk; no live-feature dependency |
| B | #1 agent + admin verify/fix | Needs Ollama/OpenRouter confirmed; unblocks confidence in core features |
| C | #4 contact form | New feature; depends on nothing above |
| D | #5 tests + branch protection | Locks in everything; retrofits coverage for #1–#4 |
