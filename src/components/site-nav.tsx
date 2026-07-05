import Link from "next/link";
import type { Locale } from "@/i18n/config";
import { getMenu } from "@/lib/content";

// Renders the 'main' menu for the active locale. Falls back to nothing if empty.
export async function SiteNav({ locale }: { locale: Locale }) {
  let items: { label: string; href: string }[] = [];
  try {
    items = await getMenu("main", locale);
  } catch {
    items = [];
  }
  if (!items.length) return null;
  return (
    <nav className="flex gap-4 border-b border-border px-6 py-3 text-sm">
      {items.map((it, i) => (
        <Link key={i} href={it.href} className="hover:text-primary">
          {it.label}
        </Link>
      ))}
    </nav>
  );
}
