import { pool } from "@/lib/db";
import { getEmailConfig, getLinkedInConfig, getXConfig } from "@/lib/integration-settings";

/**
 * Observability for the admin Integrations console: a per-integration health
 * summary (`getIntegrationsHealth`) and a unified activity feed
 * (`getIntegrationActivity`). Sources:
 *   - `integration_events` (migration 037): config saves, OAuth, connection
 *     tests, sends — every integration writes here via `recordIntegrationEvent`.
 *   - `social_posts` (migration 030): per-post outcomes for linkedin/x, already
 *     written by src/lib/social.ts's postToSocial(). Never written for "email",
 *     so email health/activity is derived from integration_events alone.
 * Both tables are queried by a plain string match (integration/platform), so
 * combining them needs no schema change to either table.
 */

export type IntegrationName = "email" | "linkedin" | "x";

/** Thin best-effort insert into `integration_events`. Never throws. */
export async function recordIntegrationEvent(event: {
  integration: IntegrationName;
  kind: string;
  success: boolean;
  detail?: string | null;
}): Promise<void> {
  try {
    await pool.query(
      `INSERT INTO integration_events (integration, kind, success, detail) VALUES ($1,$2,$3,$4)`,
      [event.integration, event.kind, event.success, event.detail ? event.detail.slice(0, 1000) : null]
    );
  } catch (err) {
    console.error("[integration-observability] failed to record event:", err);
  }
}

interface CombinedStats {
  recentSuccessCount: number;
  recentFailureCount: number;
  lastSuccessAt: number | null;
  lastFailureAt: number | null;
  lastCheckedAt: number | null;
  lastError: string | null;
}

const EMPTY_STATS: CombinedStats = {
  recentSuccessCount: 0,
  recentFailureCount: 0,
  lastSuccessAt: null,
  lastFailureAt: null,
  lastCheckedAt: null,
  lastError: null
};

/**
 * Aggregate integration_events (all integrations) + social_posts (linkedin/x
 * only — the platform column never contains "email") for one integration name.
 */
async function combinedStats(integration: IntegrationName): Promise<CombinedStats> {
  try {
    const { rows } = await pool.query<{
      recent_success: string;
      recent_failure: string;
      last_success_at: Date | null;
      last_failure_at: Date | null;
      last_checked_at: Date | null;
    }>(
      `WITH combined AS (
         SELECT created_at, success FROM integration_events WHERE integration = $1
         UNION ALL
         SELECT created_at, success FROM social_posts WHERE platform = $1
       )
       SELECT
         count(*) FILTER (WHERE success AND created_at >= now() - interval '30 days')      AS recent_success,
         count(*) FILTER (WHERE NOT success AND created_at >= now() - interval '30 days')   AS recent_failure,
         max(created_at) FILTER (WHERE success)     AS last_success_at,
         max(created_at) FILTER (WHERE NOT success) AS last_failure_at,
         max(created_at)                            AS last_checked_at
       FROM combined`,
      [integration]
    );
    const r = rows[0];
    if (!r) return EMPTY_STATS;

    let lastError: string | null = null;
    if (r.last_failure_at) {
      const { rows: errRows } = await pool.query<{ detail: string | null }>(
        `SELECT detail FROM (
           SELECT created_at, detail FROM integration_events WHERE integration = $1 AND success = false
           UNION ALL
           SELECT created_at, error AS detail FROM social_posts WHERE platform = $1 AND success = false
         ) t ORDER BY created_at DESC LIMIT 1`,
        [integration]
      );
      lastError = errRows[0]?.detail ?? null;
    }

    return {
      recentSuccessCount: Number(r.recent_success ?? 0),
      recentFailureCount: Number(r.recent_failure ?? 0),
      lastSuccessAt: r.last_success_at ? new Date(r.last_success_at).getTime() : null,
      lastFailureAt: r.last_failure_at ? new Date(r.last_failure_at).getTime() : null,
      lastCheckedAt: r.last_checked_at ? new Date(r.last_checked_at).getTime() : null,
      lastError
    };
  } catch (err) {
    console.error(`[integration-observability] stats query failed for ${integration}:`, err);
    return EMPTY_STATS;
  }
}

/**
 * `connected` reflects the outcome of the most recent check: true if the most
 * recent success is at least as recent as the most recent failure, false if a
 * failure is newer, null if nothing has ever been recorded.
 */
function connectedFromStats(s: CombinedStats): boolean | null {
  if (s.lastSuccessAt === null && s.lastFailureAt === null) return null;
  if (s.lastFailureAt === null) return true;
  if (s.lastSuccessAt === null) return false;
  return s.lastSuccessAt >= s.lastFailureAt;
}

export interface IntegrationHealthEntry {
  enabled: boolean;
  configured: boolean;
  connected: boolean | null;
  lastCheckedAt: number | null;
  lastSuccessAt: number | null;
  lastFailureAt: number | null;
  lastError: string | null;
  tokenExpiresAt: number | null;
  recentSuccessCount: number;
  recentFailureCount: number;
}

export interface IntegrationsHealth {
  email: IntegrationHealthEntry;
  linkedin: IntegrationHealthEntry;
  x: IntegrationHealthEntry;
}

/** Per-integration health summary powering the admin Integrations health badges. */
export async function getIntegrationsHealth(): Promise<IntegrationsHealth> {
  const [email, linkedin, x] = await Promise.all([getEmailConfig(), getLinkedInConfig(), getXConfig()]);
  const [emailStats, linkedinStats, xStats] = await Promise.all([
    combinedStats("email"),
    combinedStats("linkedin"),
    combinedStats("x")
  ]);

  const emailConfigured =
    email.authType === "oauth2"
      ? Boolean(email.oauthClientId && email.oauthClientSecret && email.oauthRefreshToken && email.oauthUser)
      : Boolean(email.host && email.username && email.password && email.fromEmail);
  const linkedinConfigured = Boolean(linkedin.accessToken && linkedin.authorUrn);
  const xConfigured = Boolean(x.apiKey && x.apiSecret && x.accessToken && x.accessSecret);

  return {
    email: {
      enabled: email.enabled,
      configured: emailConfigured,
      connected: connectedFromStats(emailStats),
      lastCheckedAt: emailStats.lastCheckedAt,
      lastSuccessAt: emailStats.lastSuccessAt,
      lastFailureAt: emailStats.lastFailureAt,
      lastError: emailStats.lastError,
      tokenExpiresAt: null,
      recentSuccessCount: emailStats.recentSuccessCount,
      recentFailureCount: emailStats.recentFailureCount
    },
    linkedin: {
      enabled: linkedin.enabled,
      configured: linkedinConfigured,
      connected: connectedFromStats(linkedinStats),
      lastCheckedAt: linkedinStats.lastCheckedAt,
      lastSuccessAt: linkedinStats.lastSuccessAt,
      lastFailureAt: linkedinStats.lastFailureAt,
      lastError: linkedinStats.lastError,
      tokenExpiresAt: linkedin.tokenExpiresAt,
      recentSuccessCount: linkedinStats.recentSuccessCount,
      recentFailureCount: linkedinStats.recentFailureCount
    },
    x: {
      enabled: x.enabled,
      configured: xConfigured,
      connected: connectedFromStats(xStats),
      lastCheckedAt: xStats.lastCheckedAt,
      lastSuccessAt: xStats.lastSuccessAt,
      lastFailureAt: xStats.lastFailureAt,
      lastError: xStats.lastError,
      tokenExpiresAt: null,
      recentSuccessCount: xStats.recentSuccessCount,
      recentFailureCount: xStats.recentFailureCount
    }
  };
}

export interface ActivityItem {
  id: string;
  integration: string;
  kind: string;
  success: boolean;
  detail: string | null;
  createdAt: string;
}

/**
 * Unified reverse-chronological activity feed merging `social_posts` (mapped
 * to `post` events) and `integration_events`. Ids are namespaced (`sp:`/`ie:`)
 * so they stay unique across the two source tables.
 */
export async function getIntegrationActivity(
  limit: number,
  integration?: IntegrationName
): Promise<ActivityItem[]> {
  const safeLimit = Number.isFinite(limit) && limit > 0 ? Math.floor(limit) : 50;

  const socialParams: unknown[] = [];
  let socialWhere = "";
  if (integration) {
    // "email" never appears in social_posts.platform — short-circuit to no rows.
    if (integration === "email") socialWhere = "WHERE false";
    else {
      socialParams.push(integration);
      socialWhere = `WHERE platform = $1`;
    }
  }
  socialParams.push(safeLimit);
  const socialLimitIdx = socialParams.length;

  const eventsParams: unknown[] = [];
  let eventsWhere = "";
  if (integration) {
    eventsParams.push(integration);
    eventsWhere = `WHERE integration = $1`;
  }
  eventsParams.push(safeLimit);
  const eventsLimitIdx = eventsParams.length;

  const [socialRows, eventRows] = await Promise.all([
    pool.query<{
      id: number;
      platform: string;
      success: boolean;
      error: string | null;
      text: string;
      created_at: Date;
    }>(
      `SELECT id, platform, success, error, text, created_at FROM social_posts ${socialWhere}
       ORDER BY created_at DESC LIMIT $${socialLimitIdx}`,
      socialParams
    ),
    pool.query<{
      id: number;
      integration: string;
      kind: string;
      success: boolean;
      detail: string | null;
      created_at: Date;
    }>(
      `SELECT id, integration, kind, success, detail, created_at FROM integration_events ${eventsWhere}
       ORDER BY created_at DESC LIMIT $${eventsLimitIdx}`,
      eventsParams
    )
  ]);

  const items: ActivityItem[] = [
    ...socialRows.rows.map((r) => ({
      id: `sp:${r.id}`,
      integration: r.platform,
      kind: "post",
      success: r.success,
      detail: r.error ?? (r.text ? r.text.slice(0, 280) : null),
      createdAt: new Date(r.created_at).toISOString()
    })),
    ...eventRows.rows.map((r) => ({
      id: `ie:${r.id}`,
      integration: r.integration,
      kind: r.kind,
      success: r.success,
      detail: r.detail,
      createdAt: new Date(r.created_at).toISOString()
    }))
  ];

  items.sort((a, b) => (a.createdAt < b.createdAt ? 1 : a.createdAt > b.createdAt ? -1 : 0));
  return items.slice(0, limit);
}
