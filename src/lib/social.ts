/**
 * Social posting lib: LinkedIn (UGC Posts v2) and X/Twitter (API v2 + OAuth 1.0a).
 *
 * Ported from Celestial-Agent-Nexus/artifacts/api-server/src/lib/social.ts. The
 * LinkedIn UGC request body/headers and the X OAuth 1.0a HMAC-SHA1 signer are
 * carried over byte-for-byte; only the plumbing is adapted: credentials come from
 * this app's getLinkedInConfig()/getXConfig() (decrypted), and outcome logging
 * uses raw pg (social_posts) instead of Drizzle. The Replit-domain LinkedIn OAuth
 * authorization flow is intentionally omitted — the admin pastes tokens on the
 * Integrations page; only the posting path is kept.
 */

import crypto from "node:crypto";
import { pool } from "@/lib/db";
import {
  getLinkedInConfig,
  getXConfig,
  type LinkedInConfig,
  type XConfig
} from "@/lib/integration-settings";

// ---------------------------------------------------------------------------
// Result + status types
// ---------------------------------------------------------------------------

export interface PostOutcome {
  platform: string;
  success: boolean;
  error: string | null;
}

export type Platform = "linkedin" | "x";

export interface SocialPlatformStatus {
  configured: boolean;
}

export interface SocialStatus {
  linkedin: SocialPlatformStatus;
  x: SocialPlatformStatus;
}

function linkedinConfigured(cfg: LinkedInConfig): boolean {
  return Boolean(cfg.accessToken && cfg.authorUrn);
}

function xConfigured(cfg: XConfig): boolean {
  return Boolean(cfg.apiKey && cfg.apiSecret && cfg.accessToken && cfg.accessSecret);
}

// "Ready" = the platform is active (not disabled) AND has complete credentials.
// Mirrors the gate in postLinkedIn/postX so the status a caller sees accurately
// predicts whether a manual post will go through.
function linkedinReady(cfg: LinkedInConfig): boolean {
  return cfg.enabled !== false && linkedinConfigured(cfg);
}

function xReady(cfg: XConfig): boolean {
  return cfg.enabled !== false && xConfigured(cfg);
}

/** Configured-and-enabled booleans per platform. Powers the Social tab cards. */
export async function getSocialStatus(): Promise<SocialStatus> {
  const [linkedin, x] = await Promise.all([getLinkedInConfig(), getXConfig()]);
  return {
    linkedin: { configured: linkedinReady(linkedin) },
    x: { configured: xReady(x) }
  };
}

// ---------------------------------------------------------------------------
// LinkedIn — UGC Posts v2
// ---------------------------------------------------------------------------

export async function postLinkedIn(text: string, url?: string): Promise<PostOutcome> {
  const cfg = await getLinkedInConfig();
  if (cfg.enabled === false) {
    return { platform: "linkedin", success: false, error: "LinkedIn posting is turned off in the admin Integrations page" };
  }
  const token = cfg.accessToken;
  const author = cfg.authorUrn;
  if (!token || !author) {
    return { platform: "linkedin", success: false, error: "LinkedIn credentials not configured in the admin Integrations page" };
  }
  try {
    // When a page URL is provided, attach it as an ARTICLE so LinkedIn fetches
    // the page's OG metadata (thumbnail, title, description) and renders a rich
    // link card instead of plain text. Without a URL, fall back to a text post.
    const shareContent: Record<string, unknown> = url
      ? {
          shareCommentary: { text },
          shareMediaCategory: "ARTICLE",
          media: [{ status: "READY", originalUrl: url }]
        }
      : {
          shareCommentary: { text },
          shareMediaCategory: "NONE"
        };
    const body = JSON.stringify({
      author,
      lifecycleState: "PUBLISHED",
      specificContent: {
        "com.linkedin.ugc.ShareContent": shareContent
      },
      visibility: {
        "com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"
      }
    });
    const res = await fetch("https://api.linkedin.com/v2/ugcPosts", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
        "X-Restli-Protocol-Version": "2.0.0"
      },
      body
    });
    if (!res.ok) {
      const detail = await res.text().catch(() => "");
      return { platform: "linkedin", success: false, error: `LinkedIn API ${res.status}: ${detail}` };
    }
    return { platform: "linkedin", success: true, error: null };
  } catch (err) {
    return { platform: "linkedin", success: false, error: err instanceof Error ? err.message : "Unknown error" };
  }
}

// ---------------------------------------------------------------------------
// LinkedIn — OAuth 2.0 "Connect" flow (admin console -> LinkedIn -> callback)
// ---------------------------------------------------------------------------

const LINKEDIN_OAUTH_SCOPES = "openid profile w_member_social";

/** The exact redirect URI the admin must whitelist in their LinkedIn OAuth app. */
export function getLinkedinRedirectUri(origin: string): string {
  return `${origin.replace(/\/+$/, "")}/api/admin/social/linkedin/oauth/callback`;
}

/** Build the LinkedIn authorization URL the admin browser is redirected to. */
export function buildLinkedinAuthUrl(origin: string, clientId: string, state: string): string {
  const params = new URLSearchParams({
    response_type: "code",
    client_id: clientId,
    redirect_uri: getLinkedinRedirectUri(origin),
    scope: LINKEDIN_OAUTH_SCOPES,
    state
  });
  return `https://www.linkedin.com/oauth/v2/authorization?${params.toString()}`;
}

export interface LinkedinTokenResult {
  accessToken: string;
  expiresAt: number | null; // epoch ms
}

/** Exchange an authorization code for an access token. Throws on failure. */
export async function exchangeLinkedinCode(
  origin: string,
  code: string,
  clientId: string,
  clientSecret: string
): Promise<LinkedinTokenResult> {
  const body = new URLSearchParams({
    grant_type: "authorization_code",
    code,
    redirect_uri: getLinkedinRedirectUri(origin),
    client_id: clientId,
    client_secret: clientSecret
  });
  const res = await fetch("https://www.linkedin.com/oauth/v2/accessToken", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: body.toString()
  });
  if (!res.ok) {
    const detail = await res.text().catch(() => "");
    throw new Error(`LinkedIn token exchange ${res.status}: ${detail}`);
  }
  const json = (await res.json()) as { access_token?: string; expires_in?: number };
  if (!json.access_token) {
    throw new Error("LinkedIn token response missing access_token");
  }
  const expiresAt = typeof json.expires_in === "number" ? Date.now() + json.expires_in * 1000 : null;
  return { accessToken: json.access_token, expiresAt };
}

/** Verify a stored LinkedIn access token is still valid (used by the test/health check). */
export async function verifyLinkedInToken(accessToken: string): Promise<{ ok: boolean; error?: string }> {
  try {
    const res = await fetch("https://api.linkedin.com/v2/userinfo", {
      headers: { Authorization: `Bearer ${accessToken}` }
    });
    if (!res.ok) {
      const detail = await res.text().catch(() => "");
      return { ok: false, error: `LinkedIn API ${res.status}: ${detail}` };
    }
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : "Unknown error" };
  }
}

// ---------------------------------------------------------------------------
// X / Twitter — OAuth 1.0a
// ---------------------------------------------------------------------------

function percentEncode(s: string): string {
  return encodeURIComponent(s).replace(
    /[!'()*]/g,
    (c) => `%${c.charCodeAt(0).toString(16).toUpperCase()}`
  );
}

/**
 * Build a signed OAuth 1.0a Authorization header for X/Twitter. Copied
 * byte-for-byte from the source signer (HMAC-SHA1 over the percent-encoded
 * base string; signing key is apiSecret&accessSecret).
 */
export function buildXAuthHeader(
  method: string,
  url: string,
  apiKey: string,
  apiSecret: string,
  accessToken: string,
  accessSecret: string
): string {
  const oauthParams: Record<string, string> = {
    oauth_consumer_key: apiKey,
    oauth_nonce: crypto.randomBytes(16).toString("hex"),
    oauth_signature_method: "HMAC-SHA1",
    oauth_timestamp: Math.floor(Date.now() / 1000).toString(),
    oauth_token: accessToken,
    oauth_version: "1.0"
  };

  const sortedParamStr = Object.keys(oauthParams)
    .sort()
    .map((k) => `${percentEncode(k)}=${percentEncode(oauthParams[k])}`)
    .join("&");

  const baseString = [
    method.toUpperCase(),
    percentEncode(url),
    percentEncode(sortedParamStr)
  ].join("&");

  const signingKey = `${percentEncode(apiSecret)}&${percentEncode(accessSecret)}`;
  const signature = crypto
    .createHmac("sha1", signingKey)
    .update(baseString)
    .digest("base64");

  oauthParams.oauth_signature = signature;

  return (
    "OAuth " +
    Object.keys(oauthParams)
      .map((k) => `${percentEncode(k)}="${percentEncode(oauthParams[k])}"`)
      .join(", ")
  );
}

/** Verify stored X OAuth 1.0a credentials are still valid (used by the test/health check). */
export async function verifyXCredentials(
  apiKey: string,
  apiSecret: string,
  accessToken: string,
  accessSecret: string
): Promise<{ ok: boolean; error?: string }> {
  try {
    const url = "https://api.twitter.com/2/users/me";
    const authHeader = buildXAuthHeader("GET", url, apiKey, apiSecret, accessToken, accessSecret);
    const res = await fetch(url, { headers: { Authorization: authHeader } });
    if (!res.ok) {
      const detail = await res.text().catch(() => "");
      return { ok: false, error: `X API ${res.status}: ${detail}` };
    }
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : "Unknown error" };
  }
}

export async function postX(text: string, pageUrl?: string): Promise<PostOutcome> {
  const cfg = await getXConfig();
  if (cfg.enabled === false) {
    return { platform: "x", success: false, error: "X posting is turned off in the admin Integrations page" };
  }
  const { apiKey, apiSecret, accessToken, accessSecret } = cfg;
  if (!apiKey || !apiSecret || !accessToken || !accessSecret) {
    return { platform: "x", success: false, error: "X credentials not configured in the admin Integrations page" };
  }
  try {
    // Append the page URL after the text so X unfurls it into a summary card
    // from the page's OG metadata. X auto-detects the trailing link.
    const tweetText = pageUrl ? `${text}\n\n${pageUrl}` : text;
    const url = "https://api.twitter.com/2/tweets";
    const authHeader = buildXAuthHeader("POST", url, apiKey, apiSecret, accessToken, accessSecret);
    const res = await fetch(url, {
      method: "POST",
      headers: {
        Authorization: authHeader,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ text: tweetText })
    });
    if (!res.ok) {
      const detail = await res.text().catch(() => "");
      return { platform: "x", success: false, error: `X API ${res.status}: ${detail}` };
    }
    return { platform: "x", success: true, error: null };
  } catch (err) {
    return { platform: "x", success: false, error: err instanceof Error ? err.message : "Unknown error" };
  }
}

// ---------------------------------------------------------------------------
// Combined post + outcome logging
// ---------------------------------------------------------------------------

/**
 * Post to one or both platforms, recording a social_posts row per attempt.
 * Each platform's own `enabled` toggle + credential gate is enforced inside
 * postLinkedIn/postX, so an unconfigured platform is a graceful no-op that is
 * still recorded (success:false) so the failure is never silent.
 */
export async function postToSocial(
  text: string,
  platforms: Platform[],
  source: "manual" | "publish" | "retry" = "manual",
  url?: string
): Promise<PostOutcome[]> {
  if (platforms.length === 0) return [];
  const outcomes = await Promise.all(
    platforms.map((p) => (p === "linkedin" ? postLinkedIn(text, url) : postX(text, url)))
  );
  await recordSocialOutcomes(outcomes, text, source);
  return outcomes;
}

/** Persist post outcomes so failures never go unnoticed. Best-effort. */
async function recordSocialOutcomes(
  outcomes: PostOutcome[],
  text: string,
  source: "manual" | "publish" | "retry"
): Promise<void> {
  if (outcomes.length === 0) return;
  const excerpt = text.slice(0, 500);
  try {
    for (const o of outcomes) {
      await pool.query(
        `INSERT INTO social_posts (platform, success, error, text, source)
         VALUES ($1, $2, $3, $4, $5)`,
        [o.platform, o.success, o.error, excerpt, source]
      );
    }
  } catch (err) {
    console.error("[social] failed to record outcomes:", err);
  }
}

export interface SocialPostLogEntry {
  id: number;
  platform: string;
  success: boolean;
  error: string | null;
  text: string;
  source: string;
  createdAt: string;
}

/** Most-recent social post outcomes, newest first. Powers the Social tab log. */
export async function getRecentSocialPosts(limit = 25): Promise<SocialPostLogEntry[]> {
  const { rows } = await pool.query<{
    id: number;
    platform: string;
    success: boolean;
    error: string | null;
    text: string;
    source: string;
    created_at: Date;
  }>(
    `SELECT id, platform, success, error, text, source, created_at
       FROM social_posts
      ORDER BY created_at DESC
      LIMIT $1`,
    [limit]
  );
  return rows.map((r) => ({
    id: r.id,
    platform: r.platform,
    success: r.success,
    error: r.error,
    text: r.text,
    source: r.source,
    createdAt: new Date(r.created_at).toISOString()
  }));
}
