// Block CMS — routing flag (docs/BLOCK-CMS-PLAN.md §G, Phase 2).
// Decides whether a page renders from page_blocks (new) or its coded sections
// (current). Defaults to the CODED path, so shipping this changes nothing until
// a preview param or the env flag opts in — never a big-bang cutover.
//
// Precedence:
//   1. ?blocks=1 / ?blocks=0  — per-request override (for the Gate-3 side-by-side)
//   2. BLOCKS_ROUTING env      — comma list of slugs, or "all" (Phase-4 cutover)
//   3. default                 — coded path (false)

type SP = Record<string, string | string[] | undefined> | undefined;

function param(sp: SP, key: string): string | undefined {
  const v = sp?.[key];
  return Array.isArray(v) ? v[0] : v;
}

export function blocksRoutingEnabled(slug: string, searchParams?: SP): boolean {
  const q = param(searchParams, "blocks");
  if (q === "1" || q === "true") return true;
  if (q === "0" || q === "false") return false; // explicit off beats env

  const env = process.env.BLOCKS_ROUTING ?? "";
  const set = new Set(env.split(",").map((s) => s.trim()).filter(Boolean));
  return set.has("all") || set.has(slug);
}
