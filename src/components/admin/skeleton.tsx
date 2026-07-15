import { cn } from "@/lib/utils";

/** Generic animate-pulse block. Compose into rows/cards for list/table skeletons. */
export function Skeleton({ className }: { className?: string }) {
  return <div className={cn("animate-pulse rounded-md bg-muted", className)} />;
}

/** A single skeleton table row matching the admin table's px-4 py-2 cell rhythm. */
export function SkeletonRow({ cols = 4 }: { cols?: number }) {
  return (
    <tr className="border-b border-border/60 last:border-0">
      {Array.from({ length: cols }).map((_, i) => (
        <td key={i} className="px-4 py-2">
          <Skeleton className="h-4 w-full max-w-[160px]" />
        </td>
      ))}
    </tr>
  );
}

/** A handful of skeleton rows, for use inside a <tbody> while a list is first loading. */
export function SkeletonRows({ cols = 4, rows = 3 }: { cols?: number; rows?: number }) {
  return (
    <>
      {Array.from({ length: rows }).map((_, i) => (
        <SkeletonRow key={i} cols={cols} />
      ))}
    </>
  );
}

/** Skeleton block for non-tabular areas (cards, chart panels). */
export function SkeletonBlock({ className }: { className?: string }) {
  return <Skeleton className={cn("h-24 w-full", className)} />;
}
