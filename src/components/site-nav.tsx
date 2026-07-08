import type { Locale } from "@/i18n/config";
import { getMenu } from "@/lib/content";
import { SiteNavClient } from "@/components/site-nav-client";

// Fetches the 'main' menu server-side and hands it to the sticky client nav shell.
export async function SiteNav({ locale }: { locale: Locale }) {
  let items: { label: string; href: string }[] = [];
  try {
    items = await getMenu("main", locale);
  } catch {
    items = [];
  }
  return <SiteNavClient locale={locale} items={items} />;
}
