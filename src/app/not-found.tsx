import Link from "next/link";
import { Button } from "@/components/ui/button";

// Global fallback for paths outside the [locale] segment (e.g. a bare "/" or a
// malformed URL) — there is no locale to resolve here, so this is intentionally
// EN-only, minimal, on-brand chrome. Bilingual pages live at
// src/app/[locale]/not-found.tsx.
export default function GlobalNotFound() {
  return (
    <main className="mx-auto flex min-h-[70vh] max-w-2xl flex-col items-center justify-center px-6 py-24 text-center">
      <p className="oxot-kicker mb-4">404</p>
      <h1
        className="text-4xl font-bold tracking-tight sm:text-5xl"
        style={{ fontFamily: "var(--font-display)" }}
      >
        Page not found
      </h1>
      <p className="mt-4 max-w-md text-muted-foreground">
        The page you&apos;re looking for doesn&apos;t exist or may have moved.
      </p>
      <div className="mt-8">
        <Button asChild>
          <Link href="/en">Back to home</Link>
        </Button>
      </div>
    </main>
  );
}
