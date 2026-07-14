import { NextRequest } from "next/server";
import { confirmSubscription } from "@/lib/newsletter";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function page(title: string, body: string): Response {
  const html = `<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>${title}</title></head>
<body style="margin:0;background:#f4f4f5;font-family:Arial,Helvetica,sans-serif;color:#1a1a1a">
<div style="max-width:560px;margin:64px auto;background:#fff;border-radius:12px;padding:40px;text-align:center;line-height:1.6">
<h1 style="margin:0 0 12px;font-size:22px">${title}</h1>
<p style="color:#444">${body}</p>
<p style="margin-top:24px"><a href="/en" style="color:#0b5;font-weight:bold;text-decoration:none">Back to OXOT</a></p>
</div></body></html>`;
  return new Response(html, { status: 200, headers: { "Content-Type": "text/html; charset=utf-8" } });
}

// Double opt-in confirmation: GET ?token=… flips the subscriber to confirmed and
// records consent (timestamp + IP).
export async function GET(req: NextRequest) {
  const token = req.nextUrl.searchParams.get("token") ?? "";
  const ip = req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
  const ok = token ? await confirmSubscription(token, ip) : false;
  return ok
    ? page("Subscription confirmed", "Thank you — your subscription is confirmed. You'll now receive OXOT compliance updates.")
    : page("Link invalid or expired", "This confirmation link is invalid or has already been used.");
}
