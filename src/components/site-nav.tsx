import Link from "next/link";
import type { Locale } from "@/i18n/config";
import { getMenu } from "@/lib/content";
import { LocaleSwitcher } from "@/components/locale-switcher";

// Renders the 'main' menu + language switcher for the active locale.
export async function SiteNav({ locale }: { locale: Locale }) {
  let items: { label: string; href: string }[] = [];
  try {
    items = await getMenu("main", locale);
  } catch {
    items = [];
  }
  return (
    <nav className="flex items-center justify-between gap-4 border-b border-border px-6 py-3 text-sm">
      <div className="flex flex-wrap items-center gap-x-4 gap-y-1">
        {items.map((it, i) => (
          <Link key={i} href={it.href} className="hover:text-primary">
            {it.label}
          </Link>
        ))}
      </div>
      <LocaleSwitcher locale={locale} />
    </nav>
  );
}
