import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/db";
import {
  verifyPassword,
  makeSessionToken,
  SESSION_COOKIE,
  sessionCookieOptions
} from "@/lib/auth";

export async function POST(req: NextRequest) {
  const { email, password } = (await req.json().catch(() => ({}))) as {
    email?: string;
    password?: string;
  };
  if (!email || !password) {
    return NextResponse.json({ error: "email and password required" }, { status: 400 });
  }
  const { rows } = await pool.query(
    `SELECT id, email, password_hash FROM admin_users WHERE email = $1`,
    [email]
  );
  const user = rows[0];
  if (!user || !verifyPassword(password, user.password_hash)) {
    return NextResponse.json({ error: "invalid credentials" }, { status: 401 });
  }
  const res = NextResponse.json({ ok: true });
  res.cookies.set(SESSION_COOKIE, makeSessionToken(user.id, user.email), sessionCookieOptions);
  return res;
}
