"use client";
import { MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

/**
 * Opens the chat widget (src/components/agent/chat-widget.tsx listens for
 * "oxot:chat-open") seeded with a question about the visitor's segment.
 * `seedTemplate` is the agent.seedTemplate dictionary string with a
 * "{segment}" placeholder; when no segment is known it's used as-is.
 */
export function AskAssistantButton({
  label,
  seedTemplate,
  segmentLabel,
  className
}: {
  label: string;
  seedTemplate: string;
  segmentLabel?: string;
  className?: string;
}) {
  function open() {
    const seed = segmentLabel ? seedTemplate.replace("{segment}", segmentLabel) : seedTemplate.replace(/\s*\{segment\}\s*/, " ");
    window.dispatchEvent(
      new CustomEvent("oxot:chat-open", { detail: { seed, segment: segmentLabel } })
    );
  }
  return (
    <Button type="button" variant="outline" onClick={open} className={className}>
      <MessageCircle className="h-4 w-4" aria-hidden />
      {label}
    </Button>
  );
}
