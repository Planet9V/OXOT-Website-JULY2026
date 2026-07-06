#!/usr/bin/env bash
# Update the GitHub repo About (description + topics) and ship docs (memory, README, wiki) as a PR.
set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)" || exit 1
LOG="$(pwd)/docs-ship.log"; : > "$LOG"
exec > >(tee -a "$LOG") 2>&1
echo "════════ docs ship  $(date '+%H:%M:%S') ════════"
rm -f .git/*.lock 2>/dev/null || true

echo "▶ update GitHub repo About (description + topics)"
gh repo edit Planet9V/OXOT-Website-JULY2026 \
  --description "Bilingual (NL/EN) OXOT website — Dutch OT cybersecurity. Six cited EU framework guides (NIS2, CRA, AI Act, Machinery Regulation, IEC 62443, TS 50701), a Cyber Digital Twin, an admin CMS, and an AI visitor agent. Next.js + Postgres/pgvector + Ollama, fully Dockerized." \
  --add-topic ot-security --add-topic cybersecurity --add-topic nis2 --add-topic cyber-resilience-act \
  --add-topic iec-62443 --add-topic nextjs --add-topic pgvector --add-topic ollama 2>&1 | tail -3 || echo "  (repo edit skipped/failed)"

echo ""; echo "▶ ship docs on a branch"
git checkout main 2>/dev/null && git pull --ff-only 2>&1 | tail -2 || true
git checkout -b feat/docs-wiki 2>/dev/null || git checkout feat/docs-wiki
git add memory README.md docs
git commit -m "docs: refresh project brain + README, add full admin/developer wiki (docs/wiki: Home, Architecture, Stack, Backend, Frontend, Content-Authoring, Admin-Guide, Developer-Guide, Deployment-Operations, Marketing)" || echo "  (nothing to commit)"
git push -u origin feat/docs-wiki 2>&1 | tail -3 || { echo "push failed"; read -r -p _ _; exit 1; }
PRURL=$(gh pr create --base main --head feat/docs-wiki \
  --title "Docs: refreshed README + full admin/developer wiki + memory update" \
  --body "Brings docs current with the shipped build. Rewrites README.md (project + website + stack + quick start + repo map), updates memory/decisions.md (durable decisions from the content/brand/marketing build), and adds a 10-page admin/developer wiki under docs/wiki/ (Home, Architecture, Stack, Backend, Frontend, Content-Authoring, Admin-Guide, Developer-Guide, Deployment-Operations, Marketing) with Mermaid diagrams, curl/command examples and how-tos. Also updates the GitHub repo About/topics." 2>&1 | tail -1)
echo "  PR: $PRURL"
gh pr merge feat/docs-wiki --merge 2>&1 | tail -6 || echo "  (merge manually if blocked)"
git checkout main 2>/dev/null && git pull --ff-only 2>&1 | tail -2 || true
echo ""; echo "── result ──"; git branch --show-current; git log --oneline -3
echo "════════ done ════════"
read -r -p "Press Return to close…" _
