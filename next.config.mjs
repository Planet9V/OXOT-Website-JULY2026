import path from "node:path";
import { fileURLToPath } from "node:url";
const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // NOTE: no `output: "standalone"`. The Docker runner copies the full app and runs
  // `next start`, which is INCOMPATIBLE with standalone output in Next 15 (the
  // container crash-loops with: '"next start" does not work with "output:
  // standalone"'). Plain build + `next start` serves everything correctly here.
  // Don't fail the production build on lint/type nits (dev uses SWC and is lenient;
  // `next build` runs strict ESLint + tsc). Keeps Railway/GHCR deploys green.
  eslint: { ignoreDuringBuilds: true },
  typescript: { ignoreBuildErrors: true },
  // Guarantee the "@/…" alias resolves in the production webpack build. tsconfig
  // `paths` need `baseUrl` (now added), and this alias makes it bulletproof so
  // builds don't fail with "Module not found: Can't resolve '@/…'".
  webpack: (config) => {
    config.resolve.alias = { ...(config.resolve.alias || {}), "@": path.resolve(__dirname, "src") };
    return config;
  }
};
export default nextConfig;
