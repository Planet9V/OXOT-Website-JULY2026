---
name: website-alignment
description: Enforce the OXOT visual/style contract on every UI change. Use when editing components, pages, styles, or themes — global stylesheet is the single source of truth, dark/light always honored, Tailwind + shadcn/ui + Next.js patterns, mobile-first.
---

# Website Alignment

Guard the OXOT look-and-feel. Trigger on any change under `app/`, `components/`, `styles/`, or theme config.

## Rules
1. **Global stylesheet is the single source of truth.** No hard-coded colors, spacing, or fonts in components — use the design tokens / CSS variables and Tailwind theme.
2. **Dark and light mode both work, always.** Verify both before done; never ship a change that only looks right in one mode.
3. **Components come from shadcn/ui** where one exists; extend, don't reinvent.
4. **Mobile-first & responsive.** Check the smallest breakpoint first.
5. **Bilingual:** any user-facing string routes through the i18n layer (see `i18n-nl-en`) — never inline literals.

## Checklist before finishing
- [ ] No literal hex/rgb or magic spacing in the diff (tokens only)
- [ ] Toggled dark + light — both correct
- [ ] Looks right at mobile, tablet, desktop
- [ ] Reference: `OXOT Document Template.html` for brand cues
