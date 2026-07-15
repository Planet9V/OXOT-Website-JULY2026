import { NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getLinkedInConfig } from "@/lib/integration-settings";
import { verifyLinkedInToken } from "@/lib/social";
import { recordIntegrationEvent } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

// Verify the stored LinkedIn access token still works (GET /v2/userinfo),
// without posting anything. Records the outcome so health/activity reflect it.
export async function POST() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const cfg = await getLinkedInConfig();
  if (!cfg.accessToken) {
    return NextResponse.json({ ok: false, error: "LinkedIn is not connected yet", checkedAt: new Date().toISOString() });
  }
  const result = await verifyLinkedInToken(cfg.accessToken);
  await recordIntegrationEvent({
    integration: "linkedin",
    kind: "verify",
    success: result.ok,
    detail: result.error ?? "Connection test passed"
  });
  return NextResponse.json({ ...result, checkedAt: new Date().toISOString() });
}
