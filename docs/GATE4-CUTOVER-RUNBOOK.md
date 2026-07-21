# Gate-4 Cutover Runbook — Block CMS becomes the live source of truth

Pages: Home (`home`), Cyber Digital Twin (`cyber-digital-twin`), Conformity (`conformity`).
Constraint: zero content loss, instant rollback at every stage. Grounded against the code (flag.ts, the three routes, backfill/parity scripts, admin-shell, reindex, migration ledger).

## Stage order (each independently reversible)
1. **Re-sync + parity** — parity read-only FIRST (diagnostic gate); backfill only if drift is a stale backfill, never if it's a Page-Builder-only edit. No user gate.
2. **Flip the flag** — `railway variables --set "BLOCKS_ROUTING=home,cyber-digital-twin,conformity"` (env only; instant revert by clearing it). Verify live visible-text diff = 0 (bare URL vs `?blocks=0`) for all 3 × EN/NL.
3. **Grounding repoint** — reindex route: the 3 pages' corpus reads `page_blocks` (via getPageBlocks + existing extractProse) instead of the site_blocks readers; keep the pseudo-slugs identical so chunk counts are unchanged. Rebuild; verify chunk-count equality.
4. **⛔ STOP for user confirmation before any legacy removal.**
5. **Remove legacy editors from nav** (admin-shell.tsx: nav+render+imports for `cra-home`, `cdt`, `home`, `homepage`). Keep the components/APIs on disk one release (rollback escape hatch).
6. **Retire stale markdown `cyber-digital-twin` row** — migration `043_*`: snapshot-first (page_versions) then `published=false`. Never hard-delete.
7. **Verification battery**: typecheck, check-sql, build, i18n, live smoke (6 URLs), parity exit 0, grounding chunk-count equality.

## Critical safeguards
- Backfill is destructive (DELETE+INSERT from site_blocks) → parity FIRST. If DB round-trip FAILs, investigate the first-diff before overwriting (could be a Page-Builder-only edit).
- Flag flip is the master kill-switch: clearing `BLOCKS_ROUTING` reverts all three to the coded/site_blocks path instantly, regardless of later stages.
- Stale-row retirement is snapshot-first + unpublish; rollback = `UPDATE pages SET published=true`.
- Grounding: keep pseudo-slugs `site-blocks-{cra-home,cdt-home,conformity-home}` so `content_chunks.page_id` is unchanged (no orphans, no dup). Leave `HOME_KEY`/`site-blocks-home` (Approach orphan) alone.

## Rollback story
- Flag: `railway variables --set "BLOCKS_ROUTING="` → instant coded revert.
- Grounding: revert reindex commit + rebuild.
- Nav: revert admin-shell commit (editors reappear; never deleted).
- Stale row: re-publish via SQL (content never deleted; snapshot additive).
