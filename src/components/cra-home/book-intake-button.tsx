"use client";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";

/** Scrolls to the intake form (src/components/cra-home/intake-form.tsx) without
 *  changing the currently selected segment. */
export function BookIntakeButton({ label, className }: { label: string; className?: string }) {
  function onClick() {
    window.dispatchEvent(new CustomEvent("oxot:intake-preselect", { detail: {} }));
  }
  return (
    <Button type="button" size="lg" onClick={onClick} className={className}>
      {label}
      <ArrowRight />
    </Button>
  );
}
