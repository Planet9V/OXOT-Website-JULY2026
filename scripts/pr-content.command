#!/usr/bin/env bash
# Open a PR with the OXOT content + CMS/SEO work (bases off main; commits source + content only).
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/pr-content.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ content PR  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true
git checkout main 2>/dev/null || true
git checkout -B feat/oxot-content
git add src db/migrations/003_seed_content.sql db/migrations/004_seo_fields.sql content .gitignore
git commit -m "feat: OXOT bilingual content, CMS pages + menu, SEO/meta fields, blog index" || echo "nothing to commit"
git push -u origin feat/oxot-content || { echo "✖ push failed"; read -r -p "Return…" _; exit 1; }
gh pr create --base main --head feat/oxot-content \
  --title "OXOT content: hero, services, bilingual CMS pages + SEO foundation" \
  --body "Adds the OXOT hero + services home page (nl/en), seeds CMS pages and the main menu for both locales (Services, Cyber Digital Twin, About, Frameworks stubs, Contact), agent content for embeddings, and the SEO foundation: pages gain meta_title/meta_description/excerpt/og_image/content_type, rendered via generateMetadata, editable in the admin, plus a Blog/Insights index. Typecheck clean; verified rendering both locales.

Assumptions: base main; gh authenticated as Planet9v." \
  2>&1 || echo "NOTE: PR create failed — branch pushed; open from GitHub if needed."
echo "════════ done ════════"
read -r -p "Press Return to close…" _
