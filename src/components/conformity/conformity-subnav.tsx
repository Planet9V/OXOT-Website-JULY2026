"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";

interface Tab {
  key: string;
  label: string;
  href: string;
}

/**
 * Horizontal sub-nav for the Conformity Platform. Highlights the active tab by
 * matching usePathname against each tab href. Fully tokenized (dark/light).
 */
export function ConformitySubnav({ locale, labels }: {
  locale: string;
  labels: {
    overview: string;
    regulations: string;
    requirements: string;
    themes: string;
    matrix: string;
    sources: string;
  };
}) {
  const base = `/${locale}/conformity-platform`;
  const pathname = usePathname() || base;
  // Aligned to the consolidated "Frameworks" mega-menu: only the four folded-in
  // views appear here, in the same order/labels as the dropdown. The old
  // Overview tab was dropped (its /conformity-platform URL now redirects to
  // /frameworks, so a tab pointing at it would bounce the user out), and
  // Regulations was dropped to match the mega-menu (its route stays live).
  const tabs: Tab[] = [
    { key: "matrix", label: labels.matrix, href: `${base}/matrix` },
    { key: "requirements", label: labels.requirements, href: `${base}/requirements` },
    { key: "themes", label: labels.themes, href: `${base}/themes` },
    { key: "sources", label: labels.sources, href: `${base}/sources` }
  ];

  const isActive = (href: string) =>
    href === base ? pathname === base : pathname.startsWith(href);

  return (
    <nav aria-label="Conformity Platform" className="border-b border-border">
      <ul className="-mb-px flex flex-wrap gap-x-1 gap-y-1">
        {tabs.map((t) => {
          const active = isActive(t.href);
          return (
            <li key={t.key}>
              <Link
                href={t.href}
                aria-current={active ? "page" : undefined}
                className={cn(
                  "inline-flex items-center border-b-2 px-3 py-2.5 text-sm font-medium no-underline transition-colors duration-150 ease-brand",
                  active
                    ? "border-primary text-foreground"
                    : "border-transparent text-muted-foreground hover:border-border hover:text-foreground"
                )}
              >
                {t.label}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
