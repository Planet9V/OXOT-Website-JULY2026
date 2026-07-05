import * as React from "react";
import { cn } from "@/lib/utils";

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "default" | "outline";
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = "default", ...props }, ref) => (
    <button
      ref={ref}
      className={cn(
        "inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 disabled:opacity-50",
        variant === "default" &&
          "bg-primary text-primary-foreground hover:opacity-90",
        variant === "outline" &&
          "border border-border bg-background hover:bg-muted",
        className
      )}
      {...props}
    />
  )
);
Button.displayName = "Button";
