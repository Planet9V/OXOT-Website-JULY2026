For: developers — Next.js routes, components, styling, i18n.

# Frontend

See also: [Home](Home.md) · [Architecture](Architecture.md) · [Stack](Stack.md) · [Backend](Backend.md)

## Route map

```
src/app/
  layout.tsx                    root layout (html/body, ThemeProvider)
  globals.css                   single source of truth for design tokens (CSS vars)
  [locale]/
    layout.tsx                  resolves locale, renders SiteNav + ChatWidget
    page.tsx                    home page
    [slug]/page.tsx             CMS page renderer (getPublishedPage + MarkdownContent)
    blog/page.tsx                Insights/Kennisbank index (listArticles)
  admin/
    page.tsx                    dashboard (PagesManager + MenuManager), redirects to /admin/login if unauthenticated
    login/page.tsx               login form
  api/
    session/route.ts             POST/PATCH visitor_sessions
    events/route.ts              POST visitor_events (consent-gated)
    agent/route.ts               POST — retrieval + streamed generation
    admin/login/route.ts         POST — verify credentials, set session cookie
    admin/logout/route.ts        POST — clear session cookie
    admin/pages/route.ts         GET/POST/DELETE pages
    admin/menu-items/route.ts    GET/POST/DELETE menu_items
```

`src/middleware.ts` redirects any locale-less public path to `/nl/...` or `/en/...` based on `Accept-Language` (`nl` preferred if the header starts with `nl`, otherwise `defaultLocale` = `en`). `/admin` and `/api` paths are exempt from this redirect. The matcher excludes `_next` and any path with a file extension.

## Components

| Component | File | Role |
|---|---|---|
| `SiteNav` | `src/components/site-nav.tsx` | Server component; calls `getMenu("main", locale)` and renders `<Link>`s. Returns `null` if the menu is empty or the query throws (fails soft). |
| `ChatWidget` | `src/components/agent/chat-widget.tsx` | Client component; the AI visitor agent's UI. See below. |
| `MarkdownContent` | `src/components/markdown.tsx` | Dependency-free server-side Markdown renderer for CMS page bodies — see [Content-Authoring](Content-Authoring.md). |
| `Carousel` | `src/components/carousel.tsx` | Slide renderer used by fenced ` ```carousel ` blocks in Markdown. |
| `PagesManager` | `src/components/admin/pages-manager.tsx` | Admin dashboard: list + create/edit/delete `pages` rows, including SEO fields. |
| `MenuManager` | `src/components/admin/menu-manager.tsx` | Admin dashboard: list + add/delete `menu_items` for a given menu key (defaults to `"main"`). |
| `Button` | `src/components/ui/button.tsx` | Hand-rolled shadcn-style button (Tailwind + `clsx`/`tailwind-merge`), not an external UI library. |
| `ThemeProvider` / `ThemeToggle` | `src/components/theme-provider.tsx` / `theme-toggle.tsx` | Wraps `next-themes`; toggles the `dark` class that `globals.css` keys off of. |

## The chat widget in detail

`ChatWidget` (`src/components/agent/chat-widget.tsx`) is a client component that:

1. Renders a closed floating button (`strings.open`) until clicked.
2. On open, shows a consent gate (`strings.consent.{title,body,accept,decline}`) if consent hasn't been granted yet.
3. On accept, `POST /api/session` with `{locale, consent: true}`, stores the returned `sessionId`, and fires a `page` beacon.
4. Wires a `document`-level click listener that fires a `click` beacon (with the clicked link/button's text, truncated to 60 chars) whenever consent + a session exist.
5. On message send, `POST /api/agent` with `{sessionId, message, locale, pageId}` and reads the response body as a stream, appending each decoded chunk to the last (assistant) message in state.

```tsx
async function send() {
  const res = await fetch("/api/agent", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ sessionId, message: q, locale, pageId })
  });
  const reader = res.body.getReader();
  // ...appends each decoded delta to the last assistant message
}
```

`pageId` is currently hardcoded to `"home"` at the mount site in `src/app/[locale]/layout.tsx` (`<ChatWidget locale={locale} pageId="home" .../>`) — passing the actual current slug through is one of the still-open improvements (the current-page retrieval boost in `retrieval.ts` only has an effect once this is wired per-route).

## Styling — the global stylesheet

Per `CLAUDE.md` §2, `src/app/globals.css` is the single source of truth for all design tokens (colors, radius) as CSS custom properties, e.g. `--background`, `--foreground`, `--primary`, `--primary-foreground`, `--muted`, `--muted-foreground`, `--border`, `--radius`, redefined under a `.dark` selector for dark mode. `tailwind.config.ts` does not hardcode any color — it only maps Tailwind's color keys onto `hsl(var(--*))`:

```ts
const config: Config = {
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: { DEFAULT: "hsl(var(--primary))", foreground: "hsl(var(--primary-foreground))" },
        muted: { DEFAULT: "hsl(var(--muted))", foreground: "hsl(var(--muted-foreground))" },
        border: "hsl(var(--border))"
      },
      borderRadius: { lg: "var(--radius)" }
    }
  }
};
```

`next-themes` (`ThemeProvider`, `darkMode: "class"`) toggles the `.dark` class on `<html>`; every component that wants theme-aware color uses the Tailwind utility classes (`bg-background`, `text-foreground`, `border-border`, etc.) rather than raw hex values, so dark/light mode is enforced everywhere through the one stylesheet.

## i18n

`src/i18n/config.ts` defines `locales = ["nl", "en"]`, `defaultLocale = "en"`, and the `isLocale()` type guard used throughout route handlers and page components to validate the `locale` route param / request body field.

`src/i18n/dictionaries.ts` loads locale JSON files (`src/i18n/dictionaries/en.json`, `nl.json`) and exposes `getDictionary(locale)`. `[locale]/layout.tsx` calls this once per request and passes the `agent` sub-tree into `ChatWidget` as `strings` — this is how the chat widget's UI copy (title, greeting, placeholder, consent text) stays locale-aware without hardcoding English or Dutch in the component. Any new user-facing string must be added to **both** `en.json` and `nl.json` (`CLAUDE.md` §3; enforced by `npm run i18n:check`, see [Developer-Guide](Developer-Guide.md)).

## The Markdown renderer (`MarkdownContent`)

`src/components/markdown.tsx` is a dependency-free, server-side Markdown renderer purpose-built for CMS page bodies. Per its own header comment, it supports: headings (`#`–`####`) with slugified anchor ids and an auto "On this page" TOC, `---`/`***` rules, `>` blockquotes plus `> [!NOTE|TIP|WARNING|IMPORTANT]` callouts, ordered/unordered lists, GFM tables, images, fenced code blocks (plus ` ```svg ` rendered as raw inline SVG and ` ```carousel ` parsed into `Carousel` slides), and inline `**bold**` / `*italic*` / `` `code` `` / `[link](url)`. Because ` ```svg ` is rendered as raw SVG, **page bodies are treated as trusted admin-authored content**, not sanitized user input — do not expose page authoring to untrusted users without adding sanitization.

See [Content-Authoring](Content-Authoring.md) for how content actually reaches this renderer.
