import { NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getIntegrationsHealth } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

// Per-integration health summary: enabled/configured/connected + recent
// success/failure counts (30d) + LinkedIn token expiry. Powers the health
// badges on the admin Integrations page.
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  return NextResponse.json(await getIntegrationsHealth());
}
