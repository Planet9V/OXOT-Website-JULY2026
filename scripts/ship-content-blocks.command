#!/usr/bin/env bash
# Ship: keyfacts/timeline blocks + related-frameworks cross-link footer + CRA enrichment.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/ship-content-blocks.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ ship content blocks + cross-links  $(date '+%H:%M:%S') ════════"
die(){ echo "✖ $*"; read -r -p "Return to close…" _; exit 1; }
rm -f .git/*.lock 2>/dev/null || true

git add -A
git commit -m "feat(pages): scannable keyfacts + timeline markdown blocks; auto 'related frameworks' cross-link footer on every regulation page (internal linking + SEO); CRA at-a-glance panel (en+nl)" || echo "  (nothing to commit)"
git push origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tail -3 || echo "  ⚠ push failed"

echo "▶ re-seed pages (loads enriched CRA)"; docker compose exec -T app npm run seed:pages 2>&1 | tail -4 || die "seed failed"
echo "▶ restart"; docker compose restart app 2>&1 | tail -2
for i in $(seq 1 30); do code=$(docker compose exec -T app node -e "fetch('http://localhost:3000/en').then(r=>process.stdout.write(''+r.status)).catch(()=>process.stdout.write('x'))" 2>/dev/null || echo x); [ "$code" = "200" ] && { echo "  ready ~$((i*5))s"; break; }; sleep 5; done
echo "▶ verify keyfacts + related render on /en/cra"
docker compose exec -T app node -e "fetch('http://localhost:3000/en/cra').then(r=>r.text()).then(t=>{console.log('   At a glance panel:', /At a glance/.test(t)); console.log('   Related frameworks:', /Related frameworks/.test(t)); console.log('   h2 sections:', (t.match(/<h2/g)||[]).length)})" 2>&1
echo "════════ done — open http://localhost:3000/en/cra ════════"
read -r -p "Press Return to close…" _
