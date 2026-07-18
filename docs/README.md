# OXOT Website — Documentation Index

This is the map of everything under `docs/`. Each document is written for a
specific reader and deliberately does not repeat what another document already
covers — follow the cross-references rather than duplicating content when you
extend any of them.

---

## The documents

| Document | One-line description | Primary audience |
|---|---|---|
| [`ARCHITECTURE.md`](./ARCHITECTURE.md) | System shape: what the app is, the stack, rendering flow, the AI visitor agent, deployment topology. | Developers, technical leads |
| [`DATA-MODEL.md`](./DATA-MODEL.md) | Every database table and column, pgvector/embedding specifics, the migration ledger and template. | Developers |
| [`SITEMAP.md`](./SITEMAP.md) | Full route inventory (public, admin, API), navigation structure, redirects, SEO surface. | Developers, marketers |
| [`DEVELOPER-GUIDE.md`](./DEVELOPER-GUIDE.md) | How to work in this codebase safely: conventions, known traps, the operational runbook. | Developers |
| [`CONFORMITY-APP.md`](./CONFORMITY-APP.md) | The Conformity/Frameworks application in depth (regulations, requirements, coverage matrix). **[Planned — see note below if not yet present.]** | Developers |
| [`ADMIN-USER-MANUAL.md`](./ADMIN-USER-MANUAL.md) | Non-technical, step-by-step guide to every section of the admin studio — what it controls, where it shows on the live site, how to publish safely. | Admin / content editors |
| [`LOCAL-DOCKER-SETUP.md`](./LOCAL-DOCKER-SETUP.md) | Copy-pasteable full-stack local setup: Docker, Postgres/pgvector, every environment variable, migrations, first admin login, verification, troubleshooting. | Developers, ops |
| [`MARKETING-SALES.md`](./MARKETING-SALES.md) | What OXOT sells, in plain language, sourced from the actual live site copy — offerings, buyer segments, approved messaging, the lead funnel, and where each message lives in the CMS. | Marketing, sales |

Root-level references outside `docs/` that these documents point to but don't
duplicate: `CLAUDE.md` (binding project rules — read this first, it overrides
everything else on conflict), `SETUP.md` (Railway/production deploy steps), and
`SETUP_PLAN.md` (original build plan).

> **Note on `CONFORMITY-APP.md`:** if this file doesn't yet exist in `docs/`, its
> content is a work in progress by another contributor — the Conformity/Frameworks
> platform (`/conformity-platform/**`) is otherwise covered structurally in
> `ARCHITECTURE.md` §1 and `SITEMAP.md`, and its data tables in `DATA-MODEL.md`.

---

## Start here, by reader

### New developer
1. `CLAUDE.md` (repo root) — the binding rules; read before touching anything.
2. `ARCHITECTURE.md` — what the system is and how it fits together.
3. `DATA-MODEL.md` — the schema you'll be reading and writing against.
4. `LOCAL-DOCKER-SETUP.md` — get a working local stack, step by step.
5. `DEVELOPER-GUIDE.md` — conventions and traps before you open a PR.
6. `SITEMAP.md` — as a reference while you work, to find the route/file for any
   page.

### Admin / content editor
1. `ADMIN-USER-MANUAL.md` — start to finish; it's written for you specifically,
   in plain language, with step-by-step instructions for every section of the
   admin.
2. `MARKETING-SALES.md` — useful background on what the content is actually
   selling, if you're writing or editing copy.

### Marketer
1. `MARKETING-SALES.md` — the offerings, buyer segments, approved messaging and
   lead funnel, all sourced from live site copy.
2. `ADMIN-USER-MANUAL.md` → sections for **Home page**, **Cyber Digital Twin**,
   **Conformity page**, **Carousel**, **Newsletter & Social**, **Affiliate & SEO**,
   **Integrations** — where to actually go make a copy change.
3. `SITEMAP.md` — to confirm a URL before it goes in an ad, email, or deck.

### Sales
1. `MARKETING-SALES.md` §4–5 — the lead funnel end to end and what to do in the
   CRA Leads console.
2. `ADMIN-USER-MANUAL.md` → **CRA Leads** and **Enquiries** — the console itself,
   step by step.

### Ops / deployment
1. `LOCAL-DOCKER-SETUP.md` — environment variables, migrations, health checks,
   troubleshooting table (also the source of truth for what a working local stack
   looks like, which is what a broken production stack should be diffed against).
2. `ARCHITECTURE.md` — deployment topology (Railway, Docker multi-stage build).
3. `DEVELOPER-GUIDE.md` — the operational runbook.
4. `SETUP.md` (repo root, not under `docs/`) — the Railway-specific provisioning
   and deploy steps not repeated here.

---

## Conventions used across these documents

- **`[UNVERIFIED]`** marks any claim that could not be confirmed by reading the
  actual code, config, or content in this repository — per `CLAUDE.md` §1, rule 6
  ("report uncertainty; do not bluff or paper over gaps"). Treat these as flags to
  double-check, not settled facts.
- Mermaid diagrams are used where a flow or structure is easier to read visually
  than as prose — most render natively on GitHub and in most Markdown viewers.
- No document in this set commits or pushes anything; they are all read-only
  documentation generated by reading the live repository state.
