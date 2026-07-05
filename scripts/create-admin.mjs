#!/usr/bin/env node
// Usage: node scripts/create-admin.mjs <email> <password>
import { scryptSync, randomBytes } from "node:crypto";
import pg from "pg";

const [email, password] = process.argv.slice(2);
if (!email || !password) {
  console.error("Usage: node scripts/create-admin.mjs <email> <password>");
  process.exit(1);
}
const salt = randomBytes(16).toString("hex");
const hash = scryptSync(password, salt, 64).toString("hex");
const stored = `${salt}:${hash}`;

const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  await client.query(
    `INSERT INTO admin_users (email, password_hash) VALUES ($1,$2)
     ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash`,
    [email, stored]
  );
  console.log(`Admin upserted: ${email}`);
} finally {
  await client.end();
}
