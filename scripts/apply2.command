#!/usr/bin/env bash
# Apply migrations (incl. 005 Insights menu) + re-seed pages + typecheck. Does NOT touch the dev server
# (it runs as the container's main process now). Safe to run anytime.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/apply2.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ apply2  $(date '+%H:%M:%S') ════════"
echo "▶ migrate"; docker compose exec -T app npm run db:migrate || { echo "✖ migrate failed"; read -r -p _ _; exit 1; }
echo ""; echo "▶ seed:pages"; docker compose exec -T app npm run seed:pages || echo "  ⚠ seed issue"
echo ""; echo "▶ typecheck"; docker compose exec -T app npm run typecheck 2>&1 | tail -25 || echo "  ⚠ typecheck errors above"
echo ""; echo "▶ main menu (should include Insights):"
docker compose exec -T app node -e "const{Client}=require('pg');(async()=>{const c=new Client({connectionString:process.env.DATABASE_URL});await c.connect();const r=await c.query(\"select label,href from menu_items mi join menus m on m.id=mi.menu_id where m.key='main' and locale='en' order by position\");console.log(r.rows.map(x=>x.label+' -> '+x.href).join('\n'));await c.end();})().catch(e=>console.log('menu check err',e.message))" 2>&1 || true
echo ""; echo "▶ smoke: /en/blog /nl/cra"
docker compose exec -T app node -e "Promise.all(['en/blog','nl/cra','en/cdt-fooled-by-randomness','nl/cdt-fooled-by-randomness'].map(p=>fetch('http://localhost:3000/'+p).then(r=>console.log('  '+p,r.status)).catch(e=>console.log('  '+p,'ERR')))).then(()=>0)" 2>&1 || true
echo "════════ done ════════"
read -r -p "Press Return to close…" _
