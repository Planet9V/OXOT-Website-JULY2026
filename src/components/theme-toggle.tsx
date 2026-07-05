"use client";
import { useTheme } from "next-themes";
import { Button } from "@/components/ui/button";

export function ThemeToggle({ label }: { label: string }) {
  const { theme, setTheme } = useTheme();
  return (
    <Button
      variant="outline"
      aria-label={label}
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
    >
      {label}
    </Button>
  );
}
