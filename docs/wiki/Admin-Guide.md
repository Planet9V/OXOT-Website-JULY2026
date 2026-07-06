For: admins (non-developers) — the OXOT content team

# Admin Guide

This is the practical, no-jargon guide to running the OXOT website day-to-day: logging in,
creating and editing pages in both languages, filling in SEO fields, publishing safely, and
using the LinkedIn carousel builder.

See also: [Home](Home.md) · [Content-Authoring](Content-Authoring.md) · [Developer-Guide](Developer-Guide.md) for setup, [Marketing](Marketing.md) for campaign assets.

## 1. Creating the first admin account

Admin accounts aren't created through a signup form — they're created from the command line
by whoever is running the server (a developer, or you with help). This is a one-time
per-person setup.

```bash
node scripts/create-admin.mjs you@oxot.nl "a-strong-password"
```

What this does:
- Hashes the password (scrypt) and stores it in the `admin_users` table.
- If the email already exists, it **updates** the password instead of erroring — so you can
  use the same command to reset a forgotten password.

There's no self-service "forgot password" flow yet — ask a developer to re-run the command
above for you.

## 2. Logging in

1. Go to `/admin/login` (e.g. `https://oxot.nl/admin/login`).
2. Enter your email and password.
3. On success you're redirected to `/admin`, the main dashboard.

The session lasts **8 hours**, after which you'll need to log in again. Sessions are stored in
a secure cookie — there's no "remember me" option.

If you see "invalid credentials", double-check with whoever ran `create-admin.mjs` for you.

## 3. The admin dashboard

`/admin` has two sections, stacked top to bottom:
- **Pages** — a table of every page/article across both locales, with an add/edit form below it.
- **Menu** — the site navigation, with an add form below it.

Both sections talk to the same backend the moment you click Save/Add/delete — there is no
separate "publish" step beyond the Published checkbox described below.

## 4. Creating or editing a page

Every piece of content — whether a static page like "About" or a blog-style article — lives in
the same **Pages** table, distinguished by the **Type** field (`page` vs `article`, see §6).

### Fields you'll fill in

| Field | What it's for |
|---|---|
| Slug | The URL segment, e.g. `ot-security-assessments` → becomes `/en/ot-security-assessments`. Use lowercase, hyphens, no spaces. |
| Locale | `en` or `nl`. **A page only exists for one locale per row** — you create the English version and the Dutch version as two separate saves. |
| Type | `page` or `article` (see §6). |
| Title (H1) | The big heading shown at the top of the page. |
| Body | The main content, written in Markdown (headings, lists, tables, images — see [Content-Authoring](Content-Authoring.md) for the full syntax). |
| Published | Checkbox — see the bilingual guard below before you check this. |

### The SEO / social box

Every page has a dedicated SEO panel:

| Field | What it's for | Guidance |
|---|---|---|
| Meta title | The blue link text in Google search results, and the browser tab title. | Aim for ~60 characters. |
| Meta description | The grey snippet under the title in search results. | Keep to 160 characters or less. |
| Excerpt | A short summary used in listings (e.g. the Insights/blog index, or link previews). | 1–2 sentences. |
| OG image | The image URL used when the page is shared on LinkedIn/X/Slack. | Use a full URL to an image, not a local file path. |

Fill these in for **both** locales — an English meta description doesn't carry over to the
Dutch version of the page.

### Saving

Click **Save**. If it worked you'll see "Saved." under the form and the row will appear (or
update) in the Pages table above. If something's wrong, the error appears in the same spot —
most often it's the bilingual guard described next.

### Deleting

Click **delete** next to any row in the Pages table. This deletes that slug+locale
combination only — it does not touch the other language's version of the same page.

## 5. The bilingual publish guard

**This is the most important rule in the admin system: you cannot publish a page in one
language without the other language already existing.**

If you try to check "Published" and save an English page called `services`, but no Dutch
`services` page exists yet, you'll get this error and the save will be rejected:

```
cannot publish: missing nl version of "services"
```

Why: OXOT ships as a fully bilingual site (see the project's [CLAUDE.md](../../CLAUDE.md) rule
on language) — no page is allowed to go live in only one language.

**How to work around this while you're still writing the second language:** save the page with
**Published unchecked** first (this just saves it as a draft — it won't error). Once both the
`en` and `nl` rows exist, go back and check Published on each and save again.

## 6. Page vs Article — and where Articles show up

The Type dropdown has two options:

- **`page`** — a normal static page (About, Services, Contact, a framework explainer like
  NIS2 or the CRA, etc.). Reachable at `/<locale>/<slug>`.
- **`article`** — a blog-style post. Articles are what populate the **Insights** section of the
  site, linked from the main menu as "Insights" (English) / "Kennisbank" (Dutch), living at
  `/en/blog` and `/nl/blog`.

Use `article` for time-stamped, topical content (e.g. "What NIS2 means for your OT estate"),
and `page` for evergreen reference content people navigate to directly.

Everything else about creating an article is identical to creating a page — same form, same
SEO box, same bilingual publish guard.

## 7. Managing menu items

The **Menu** section manages the site's main navigation (the `main` menu key).

To add a link:
1. Pick the **locale** (`en` or `nl`) — menu items are per-locale, just like pages.
2. **Label** — the visible text, e.g. "Services" or "Diensten".
3. **Href** — the destination path, e.g. `/en/services` or `/nl/services`. Always include the
   locale prefix.
4. **Pos** — a number controlling left-to-right order (lower numbers appear first).
5. Click **Add**.

To remove a link, click **delete** next to its row.

There is no drag-and-drop reordering — to move an item, delete it and re-add it with a
different position number, or ask a developer to adjust several at once.

## 8. Using the carousel builder

For LinkedIn carousel graphics (the multi-slide "document post" format), use the built-in
tool at:

```
/tools/carousel-builder.html
```

This is a static page (not part of the admin login system — anyone with the link can use it).
It's a plain-text-to-slides tool: you paste a script using a simple syntax, pick a format, and
export a PDF ready to upload to LinkedIn.

For the full slide syntax (`#COVER`, kicker/title, giant stat, bullets, footer) and the
step-by-step export flow, see [Marketing](Marketing.md#the-carousel-builder) — the same tool is
used for every campaign carousel and is documented there alongside the ready-made scripts in
`marketing/carousel-scripts.md`.

## Quick reference

| I want to... | Do this |
|---|---|
| Create my login | `node scripts/create-admin.mjs email password` (ask a developer) |
| Log in | Go to `/admin/login` |
| Add a new page | `/admin` → fill the Pages form → Save (repeat for both locales) |
| Publish a page | Check Published — only works once both `en` and `nl` rows exist |
| Add a blog post | Same as a page, but set Type to `article` |
| Add a nav link | `/admin` → Menu form → fill locale/label/href/position → Add |
| Build a LinkedIn carousel | `/tools/carousel-builder.html` |
