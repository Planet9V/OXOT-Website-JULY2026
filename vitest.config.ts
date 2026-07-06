import { defineConfig } from "vitest/config";
import path from "node:path";

// Node-environment unit tests over pure logic and the server-side Markdown
// renderer (rendered with react-dom/server, so no jsdom needed). `next/headers`
// is stubbed because auth.ts imports it at module load but the pure crypto
// helpers under test never touch it.
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "src"),
      "next/headers": path.resolve(__dirname, "tests/stubs/next-headers.ts")
    }
  },
  esbuild: { jsx: "automatic" },
  test: {
    environment: "node",
    globals: true,
    include: ["tests/**/*.test.{ts,tsx,mjs}"]
  }
});
