import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "@/lib/auth";
import { getSocialStatus, getRecentSocialPosts, postToSocial, type Platform } from "@/lib/social";

export const dynamic = "force-dynamic";

// Configured-and-enabled status per platform + the recent outcome log.
export async function GET() {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const [status, recentPosts] = await Promise.all([getSocialStatus(), getRecentSocialPosts()]);
  return NextResponse.json({ status, recentPosts });
}

// Compose a post to one or both platforms. Each platform's toggle + credential
// gate is enforced in the lib; every attempt is recorded in social_posts.
export async function POST(req: NextRequest) {
  if (!(await getAdminSession())) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const b = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const text = typeof b.text === "string" ? b.text.trim() : "";
  const requested = Array.isArray(b.platforms) ? (b.platforms as unknown[]) : ["linkedin", "x"];
  const platforms = requested.filter((p): p is Platform => p === "linkedin" || p === "x");
  if (!text) return NextResponse.json({ error: "Post text is required" }, { status: 400 });
  if (platforms.length === 0) return NextResponse.json({ error: "Select at least one platform" }, { status: 400 });
  const results = await postToSocial(text, platforms, "manual");
  return NextResponse.json({ results });
}
