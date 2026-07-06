// Test stub for next/headers — the auth crypto helpers under test never call
// cookies(); this exists only so importing auth.ts doesn't pull the real module.
export function cookies() {
  return { get: (_name: string) => undefined };
}
