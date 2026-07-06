#!/usr/bin/env bash
# Ship remediation waves A–D (gaps #1–#5) as one PR off main.
# Double-click in Finder. Commits everything, pushes feature/remediation-1-5, opens the PR.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-remediation.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship remediation #1–#5   $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true

BRANCH=feature/remediation-1-5
git checkout "$BRANCH" 2>/dev/null || git checkout -B "$BRANCH"
git add -A
git commit -m "feat: remediation #1-#5 — light-mode diagrams, bilingual SEO (hreflang/sitemap/robots/JSON-LD/OG), agent pageId fix, contact form + admin inbox, Vitest suite (29 tests)

- #2 light mode: fixed navy .oxot-diagram panel for inline SVGs (globals.css + markdown.tsx)
- #3 SEO: src/lib/seo.ts, root+home metadata, hreflang alternates, sitemap.ts, robots.ts,
        Organization/Article JSON-LD, default OG image public/og/oxot-default.png
- #1 agent: ChatWidget derives pageId from usePathname (was hard-coded 'home')
- #4 contact: migration 006, /api/contact (+honeypot+rate-limit), bilingual ContactForm,
        /[locale]/contact route, admin /api/admin/contact + ContactInbox
- #5 tests: Vitest config + 29 unit tests (contact, auth, markdown, frontmatter, retrieval);
        extracted scripts/lib/frontmatter.mjs" \
  || echo "nothing to commit"

git push -u origin "$BRANCH" 2>&1 | tail -6 || { echo "✖ push failed"; read -r -p "Return to close…" _; exit 1; }

if command -v gh >/dev/null 2>&1; then
  gh pr create --base main --head "$BRANCH" \
    --title "Remediation #1–#5: light mode, SEO, agent pageId, contact form, tests" \
    --body "Executes docs/REMEDIATION_PLAN.md waves A–D.

**#2 Light mode** — inline SVG diagrams now sit on a fixed navy panel (\`.oxot-diagram\`), legible in light + dark.
**#3 SEO** — \`src/lib/seo.ts\`; root+home metadata, hreflang \`alternates\` (incl x-default), \`sitemap.ts\`, \`robots.ts\`, Organization/Article JSON-LD, default OG image.
**#1 Agent** — \`ChatWidget\` derives \`pageId\` from the URL (was hard-coded \`home\`); page-boost + beacons now correct.
**#4 Contact** — migration \`006_contact.sql\`, \`/api/contact\` (validation + honeypot + rate limit), bilingual \`ContactForm\` on \`/[locale]/contact\`, admin inbox (\`/api/admin/contact\` + \`ContactInbox\`). Email delivery deferred (no SMTP key).
**#5 Tests** — Vitest; **29 tests** (contact, auth, markdown parser incl anchor de-dup + no-loop, frontmatter, retrieval shape). Wired to CI via existing \`npm test --if-present\`.

Assumptions: SITE_URL defaults to https://oxot.nl (override via env); OPENROUTER_API_KEY still blank (set for agent fallback); live agent/CMS/contact smoke run via scripts/verify-remediation.command." \
    2>&1 | tail -5 || echo "gh pr create failed — open a PR manually for $BRANCH"
else
  echo "gh not found — open a PR manually:"
  echo "  https://github.com/Planet9V/OXOT-Website-JULY2026/compare/main...$BRANCH"
fi
echo "════════ done — CI will run typecheck + i18n + 29 tests + secret scan ════════"
read -r -p "Press Return to close…" _
