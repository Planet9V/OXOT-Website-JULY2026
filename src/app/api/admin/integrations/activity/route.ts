import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getIntegrationActivity, type IntegrationName } from "@/lib/integration-observability";

export const dynamic = "force-dynamic";

// Unified reverse-chronological activity feed (config saves, OAuth, tests,
// sends, posts) merging integration_events + social_posts. Optional
// ?integration=email|linkedin|x filter, ?limit= (default 50, max 200).
export async function GET(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const rawLimit = Number(req.nextUrl.searchParams.get("limit"));
  const limit = Number.isFinite(rawLimit) && rawLimit > 0 ? Math.min(Math.floor(rawLimit), 200) : 50;
  const rawIntegration = req.nextUrl.searchParams.get("integration");
  const integration: IntegrationName | undefined =
    rawIntegration === "email" || rawIntegration === "linkedin" || rawIntegration === "x" ? rawIntegration : undefined;
  const items = await getIntegrationActivity(limit, integration);
  return NextResponse.json(items);
}
