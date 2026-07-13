#!/usr/bin/env node
// Seed a DEFAULT admin ONLY when the admin_users table is empty. Idempotent:
// once any admin exists (created here or via create-admin.mjs) this is a no-op and
// never touches existing credentials. Runs on both the turnkey `docker compose up`
// boot and the Railway pre-deploy step.
//
// This is a PRIVATE / dev deployment, so the default credentials are intentional
// and no password change is required. Override them by setting ADMIN_EMAIL /
// ADMIN_PASSWORD in the environment (.env.local locally, or Railway variables).
import { scryptSync, randomBytes } from "node:crypto";
import pg from "pg";

const email = process.env.ADMIN_EMAIL || "admin@oxot.local";
const password = process.env.ADMIN_PASSWORD || "changeme";

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  const { rows } = await client.query("SELECT count(*)::int AS n FROM admin_users");
  if (rows[0].n > 0) {
    console.log(`admin: ${rows[0].n} account(s) already exist — leaving untouched.`);
  } else {
    const salt = randomBytes(16).toString("hex");
    const hash = scryptSync(password, salt, 64).toString("hex");
    await client.query(
      "INSERT INTO admin_users (email, password_hash) VALUES ($1,$2)",
      [email, `${salt}:${hash}`]
    );
    console.log("┌───────────────────────────────────────────────┐");
    console.log("│  DEFAULT ADMIN CREATED (private/dev deployment) │");
    console.log(`│  email:    ${email}`);
    console.log(`│  password: ${password}`);
    console.log("│  Log in at /admin/login.                        │");
    console.log("└───────────────────────────────────────────────┘");
  }
} finally {
  await client.end();
}
