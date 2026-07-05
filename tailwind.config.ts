import type { Config } from "tailwindcss";

// Tokens are defined in src/app/globals.css (single source of truth) and mapped here.
const config: Config = {
  darkMode: "class",
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: { DEFAULT: "hsl(var(--primary))", foreground: "hsl(var(--primary-foreground))" },
        muted: { DEFAULT: "hsl(var(--muted))", foreground: "hsl(var(--muted-foreground))" },
        border: "hsl(var(--border))"
      },
      borderRadius: { lg: "var(--radius)" }
    }
  },
  plugins: []
};
export default config;
