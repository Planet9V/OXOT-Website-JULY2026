import type { Locale } from "@/i18n/config";
import { getMenuTree, type MenuNode } from "@/lib/content";
import { SiteNavClient } from "@/components/site-nav-client";

// Fetches the nested 'main' menu server-side and hands it to the sticky mega-menu shell.
export async function SiteNav({ locale }: { locale: Locale }) {
  let items: MenuNode[] = [];
  try {
    items = await getMenuTree("main", locale);
  } catch {
    items = [];
  }
  return <SiteNavClient locale={locale} items={items} />;
}
