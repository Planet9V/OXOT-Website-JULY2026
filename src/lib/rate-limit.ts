// In-memory fixed-window rate limiter for public endpoints. Ported in spirit from
// the source app's lib/rateLimit.ts. Keyed by IP+bucket. Next.js on Railway runs a
// single long-lived Node process, so a process-local Map is an effective guard
// against scripted abuse (model-cost burn on /api/agent, spam on subscribe/track).
// Not a distributed limiter — good enough for a single-instance deploy; if we scale
// horizontally later, move this to Postgres or Redis.

interface Bucket {
  count: number;
  resetAt: number; // epoch ms when the window rolls over
}

const store = new Map<string, Bucket>();
let lastSweep = 0;

// Opportunistic cleanup so the Map can't grow unbounded from unique IPs.
function sweep(now: number): void {
  if (now - lastSweep < 60_000) return;
  lastSweep = now;
  for (const [k, b] of store) {
    if (b.resetAt <= now) store.delete(k);
  }
}

export interface RateResult {
  ok: boolean;
  retryAfter: number; // seconds until the window resets (0 when ok)
  remaining: number;
}

/**
 * Fixed-window limit: at most `limit` hits per `windowMs` for a given `key`.
 * Returns ok=false with a Retry-After (seconds) once the window is exhausted.
 */
export function rateLimit(key: string, limit: number, windowMs: number): RateResult {
  const now = Date.now();
  sweep(now);
  const b = store.get(key);
  if (!b || b.resetAt <= now) {
    store.set(key, { count: 1, resetAt: now + windowMs });
    return { ok: true, retryAfter: 0, remaining: limit - 1 };
  }
  if (b.count >= limit) {
    return { ok: false, retryAfter: Math.max(1, Math.ceil((b.resetAt - now) / 1000)), remaining: 0 };
  }
  b.count += 1;
  return { ok: true, retryAfter: 0, remaining: limit - b.count };
}

/** Best-effort client IP from proxy headers (Railway sets x-forwarded-for). */
export function clientIp(req: Request): string {
  const xff = req.headers.get("x-forwarded-for");
  if (xff) return xff.split(",")[0]!.trim();
  return req.headers.get("x-real-ip") || "unknown";
}

/** 429 JSON response with a Retry-After header. */
export function tooMany(retryAfter: number): Response {
  return new Response(JSON.stringify({ error: "rate_limited", retryAfter }), {
    status: 429,
    headers: {
      "content-type": "application/json",
      "retry-after": String(retryAfter),
      "cache-control": "no-store"
    }
  });
}
