import { Pool } from "pg";

// Single pool per process. DATABASE_URL is injected via container env (.env.local).
const globalForPool = globalThis as unknown as { pgPool?: Pool };
export const pool =
  globalForPool.pgPool ??
  new Pool({ connectionString: process.env.DATABASE_URL });
if (process.env.NODE_ENV !== "production") globalForPool.pgPool = pool;
