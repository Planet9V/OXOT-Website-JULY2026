import { Loader2 } from "lucide-react";

// Shown while a force-dynamic page under [locale] streams in, so navigation
// never flashes blank. Visual only — no copy, so no dictionary strings needed.
export default function LocaleLoading() {
  return (
    <div className="flex min-h-[50vh] items-center justify-center py-24">
      <Loader2 className="h-6 w-6 animate-spin text-primary" aria-hidden />
    </div>
  );
}
