import crypto from "node:crypto";

/**
 * HMAC-signed, TTL'd `state` tokens for the LinkedIn and Gmail OAuth2
 * "connect" flows (src/app/api/admin/social/linkedin/oauth/* and
 * src/app/api/admin/email/oauth/*). Protects the redirect-based flow against
 * CSRF: the state is generated on /start, sent to the provider, and must come
 * back unmodified and within 10 minutes on /callback before any code exchange
 * happens. Signed with SETTINGS_SECRET (falls back to AUTH_SECRET), matching
 * the secret used to encrypt stored integration secrets.
 */
const SECRET = process.env.SETTINGS_SECRET ?? process.env.AUTH_SECRET ?? "dev-insecure-settings-secret";
const TTL_MS = 10 * 60 * 1000;

/** Create a signed state token: base64url(nonce.timestamp) + "." + signature. */
export function signOAuthState(): string {
  const nonce = crypto.randomBytes(16).toString("hex");
  const payload = `${nonce}.${Date.now()}`;
  const sig = crypto.createHmac("sha256", SECRET).update(payload).digest("base64url");
  return `${Buffer.from(payload).toString("base64url")}.${sig}`;
}

/** Validate a state token created by signOAuthState (10-minute TTL). */
export function verifyOAuthState(state: string | undefined | null): boolean {
  if (!state) return false;
  const [payloadB64, sig] = state.split(".");
  if (!payloadB64 || !sig) return false;
  let payload: string;
  try {
    payload = Buffer.from(payloadB64, "base64url").toString("utf8");
  } catch {
    return false;
  }
  const expected = crypto.createHmac("sha256", SECRET).update(payload).digest("base64url");
  const a = Buffer.from(sig);
  const b = Buffer.from(expected);
  try {
    if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) return false;
  } catch {
    return false;
  }
  const ts = Number(payload.split(".")[1]);
  if (!Number.isFinite(ts)) return false;
  return Date.now() - ts < TTL_MS;
}

/** The exact redirect URI the admin must whitelist in their Google OAuth app. */
export function getGmailRedirectUri(origin: string): string {
  return `${origin.replace(/\/+$/, "")}/api/admin/email/oauth/callback`;
}
