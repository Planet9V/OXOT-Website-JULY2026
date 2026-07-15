"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Copy, Check } from "lucide-react";

/**
 * Small copy-to-clipboard button. Copies `value`, shows a 2s "Copied" state,
 * then reverts. Styled like the setup-guide buttons (outline, size sm).
 */
export function ClipboardButton({ value, label }: { value: string; label?: string }) {
  const [copied, setCopied] = React.useState(false);
  const timeoutRef = React.useRef<ReturnType<typeof setTimeout> | null>(null);

  React.useEffect(() => {
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, []);

  async function onClick() {
    try {
      await navigator.clipboard.writeText(value);
      setCopied(true);
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      timeoutRef.current = setTimeout(() => setCopied(false), 2000);
    } catch {
      // Clipboard API can throw (permissions, insecure context) — no-op UI stays as-is.
    }
  }

  return (
    <Button
      type="button"
      variant="outline"
      size="sm"
      aria-label={label ? `Copy ${label}` : "Copy to clipboard"}
      onClick={onClick}
    >
      {copied ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />}
      {copied ? "Copied" : "Copy"}
    </Button>
  );
}
