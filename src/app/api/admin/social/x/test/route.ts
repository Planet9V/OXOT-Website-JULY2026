import { NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getXConfig } from "@/lib/integration-settings";
import { verifyXCredentials } from "@/lib/social";
import { recordIntegrationEvent } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

// Verify stored X OAuth 1.0a credentials still work (GET /2/users/me),
// without posting anything. Records the outcome so health/activity reflect it.
export async function POST() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const cfg = await getXConfig();
  if (!cfg.apiKey || !cfg.apiSecret || !cfg.accessToken || !cfg.accessSecret) {
    return NextResponse.json({ ok: false, error: "X credentials are not fully configured", checkedAt: new Date().toISOString() });
  }
  const result = await verifyXCredentials(cfg.apiKey, cfg.apiSecret, cfg.accessToken, cfg.accessSecret);
  await recordIntegrationEvent({
    integration: "x",
    kind: "verify",
    success: result.ok,
    detail: result.error ?? "Connection test passed"
  });
  return NextResponse.json({ ...result, checkedAt: new Date().toISOString() });
}
