#!/usr/bin/env bash
# Commit + push the editorial restyle (homepage hero + services). Double-click.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-editorial.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship editorial restyle  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git add -A
git commit -m "feat(home): editorial restyle of hero + services (design handoff)

- Fonts: Newsreader / Instrument Sans / IBM Plex Mono (Google Fonts)
- Scoped editorial CSS in globals.css (exact tokens/sizes/spacing, hover, responsive 900/600)
- Hero (hero_1b): eyebrow, serif H1, lede, ink CTA + orange-underline link, trust row,
  white insight card with SVG risk-map + stats
- Services (services_2a): 3-col hairline grid, mono indices, 'Meer over deze dienst' links,
  dark CTA cell in the 8th slot; links wired to real routes
- Bilingual (nl reference copy + en); nav left unchanged per decision" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed (auth?)"
echo "════════ done ════════"
read -r -p "Press Return to close…" _
