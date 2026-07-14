#!/usr/bin/env node
// Ensure the DEFAULT dev/demo admin exists WITH the intended password. This is a
// PRIVATE / dev deployment, so the credential is a fixed, known default and this
// script FORCE-SETS it on every run (create-or-update). That way the documented
// dev login always works, even across DB resets / redeploys.
//
// Credentials come from ADMIN_EMAIL / ADMIN_PASSWORD (defaults below). Override via
// the environment (.env.local locally, or Railway variables). For a real, private
// admin whose password should NOT be reset by deploys, create it with a DIFFERENT
// email via scripts/create-admin.mjs — this script only manages ADMIN_EMAIL.
import { scryptSync, randomBytes } from "node:crypto";
import pg from "pg";

const email = process.env.ADMIN_EMAIL || "admin@oxot.local";
const password = process.env.ADMIN_PASSWORD || "OxotDev!2026";

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  const salt = randomBytes(16).toString("hex");
  const hash = scryptSync(password, salt, 64).toString("hex");
  await client.query(
    `INSERT INTO admin_users (email, password_hash) VALUES ($1,$2)
     ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash`,
    [email, `${salt}:${hash}`]
  );
  console.log("┌───────────────────────────────────────────────┐");
  console.log("│  DEV/DEMO ADMIN ENSURED (password force-set)    │");
  console.log(`│  email:    ${email}`);
  console.log(`│  password: ${password}`);
  console.log("│  Log in at /admin/login.                        │");
  console.log("└───────────────────────────────────────────────┘");
} finally {
  await client.end();
}
