---
name: i18n-nl-en
description: Native Dutch + English by default. Use whenever adding or editing any user-facing string, page, component, email, or agent reply. Every string must exist in both nl and en or review fails.
---

# i18n — Dutch + English (mandatory)

The site and the AI agent are natively bilingual. English-only changes must not merge.

## Rules
1. **No inline user-facing literals.** Every string goes through a translation key.
2. **Both locales, always:** adding an `en` key requires the matching `nl` key (and vice versa).
3. **Locale routing:** `/nl` and `/en`; a shared translation-key file; CMS content stored per-locale.
4. **Agent:** replies in the visitor's active locale; retrieval filters embeddings by `locale`.
5. **Formatting:** dates, numbers, currency localized per locale.

## Key structure (convention)
`namespace.component.key` → e.g. `home.hero.title`

## Check before finishing (mirrors CI `i18n:check`)
- [ ] Every new key present in BOTH `nl` and `en`
- [ ] No hard-coded user-facing text in components
- [ ] New pages have `/nl` and `/en` routes
