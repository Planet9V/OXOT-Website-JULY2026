"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";

/** Dutch tricolour. */
function NlFlag() {
  return (
    <svg viewBox="0 0 9 6" className="h-full w-full" aria-hidden>
      <rect width="9" height="6" fill="#fff" />
      <rect width="9" height="2" fill="#AE1C28" />
      <rect y="4" width="9" height="2" fill="#21468B" />
    </svg>
  );
}

/** Simplified, recognisable US flag (stripes + starred canton). */
function UsFlag() {
  return (
    <svg viewBox="0 0 19 10" className="h-full w-full" aria-hidden>
      <rect width="19" height="10" fill="#fff" />
      {[0, 2, 4, 6, 8].map((y) => (
        <rect key={y} y={y} width="19" height="1" fill="#B22234" />
      ))}
      {[1, 3, 5, 7, 9].map((y) => (
        <rect key={y} y={y} width="19" height="1" fill="#B22234" opacity="0" />
      ))}
      <rect width="8.5" height="6" fill="#3C3B6E" />
      {[1, 3, 5, 7].map((x) =>
        [1, 3, 5].map((y) => <circle key={`${x}-${y}`} cx={x} cy={y} r="0.5" fill="#fff" />)
      )}
    </svg>
  );
}

export function LocaleSwitcher({ locale }: { locale: string }) {
  const pathname = usePathname() || `/${locale}`;
  // strip the current locale prefix, keep the rest of the path
  const rest = pathname.replace(/^\/(en|nl)(?=\/|$)/, "");
  const to = (target: string) => `/${target}${rest || ""}`;

  const item = (target: "en" | "nl", label: string, Flag: () => React.JSX.Element) => {
    const active = locale === target;
    return (
      <Link
        href={to(target)}
        hrefLang={target}
        aria-label={label}
        aria-current={active ? "true" : undefined}
        title={label}
        className={cn(
          "block h-4 w-6 overflow-hidden rounded-[3px] ring-1 transition-all duration-150 ease-brand active:scale-95",
          active
            ? "ring-primary opacity-100"
            : "ring-border opacity-55 hover:opacity-100 hover:ring-primary/50"
        )}
      >
        <Flag />
      </Link>
    );
  };

  return (
    <div className="flex items-center gap-1.5" role="group" aria-label="Language / Taal">
      {item("en", "English", UsFlag)}
      {item("nl", "Nederlands", NlFlag)}
    </div>
  );
}
