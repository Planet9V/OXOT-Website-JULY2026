"use client";
import * as React from "react";
import {
  LayoutDashboard, Home, FileText, Menu as MenuIcon, Inbox, LogOut, ShieldCheck, ExternalLink
} from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { DashboardOverview } from "@/components/admin/dashboard-overview";
import { HomeContentEditor } from "@/components/admin/home-content-editor";
import { PagesManager } from "@/components/admin/pages-manager";
import { MenuManager } from "@/components/admin/menu-manager";
import { ContactInbox } from "@/components/admin/contact-inbox";

type Section = "overview" | "homepage" | "pages" | "menus" | "enquiries";
const NAV: { key: Section; label: string; icon: React.ElementType }[] = [
  { key: "overview", label: "Dashboard", icon: LayoutDashboard },
  { key: "homepage", label: "Homepage", icon: Home },
  { key: "pages", label: "Pages", icon: FileText },
  { key: "menus", label: "Menus", icon: MenuIcon },
  { key: "enquiries", label: "Enquiries", icon: Inbox }
];

export function AdminShell({ email }: { email: string }) {
  const [section, setSection] = React.useState<Section>("overview");

  async function logout() {
    await fetch("/api/admin/logout", { method: "POST" }).catch(() => {});
    window.location.href = "/admin/login";
  }

  const NavList = ({ onNavigate }: { onNavigate?: () => void }) => (
    <nav className="space-y-1">
      {NAV.map(({ key, label, icon: Icon }) => (
        <button
          key={key}
          onClick={() => { setSection(key); onNavigate?.(); }}
          className={cn(
            "flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
            section === key ? "bg-primary/10 text-primary" : "text-muted-foreground hover:bg-accent hover:text-accent-foreground"
          )}
        >
          <Icon className="h-4 w-4" />
          {label}
        </button>
      ))}
    </nav>
  );

  return (
    <div className="flex min-h-screen bg-muted/20">
      {/* Sidebar (desktop) */}
      <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-r border-border bg-card lg:flex">
        <div className="flex items-center gap-2 border-b border-border px-5 py-4">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
            <ShieldCheck className="h-4 w-4" />
          </div>
          <div>
            <div className="text-sm font-semibold leading-tight">OXOT Admin</div>
            <div className="text-[11px] text-muted-foreground">Content studio</div>
          </div>
        </div>
        <div className="flex-1 overflow-y-auto p-3"><NavList /></div>
        <div className="border-t border-border p-3">
          <a href="/en" target="_blank" rel="noreferrer"
             className="mb-2 flex items-center gap-2 rounded-lg px-3 py-2 text-sm text-muted-foreground hover:bg-accent hover:text-accent-foreground">
            <ExternalLink className="h-4 w-4" /> View live site
          </a>
          <div className="flex items-center justify-between rounded-lg px-3 py-2">
            <span className="truncate text-xs text-muted-foreground" title={email}>{email}</span>
            <button onClick={logout} aria-label="Sign out" className="text-muted-foreground hover:text-foreground">
              <LogOut className="h-4 w-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main */}
      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-10 flex items-center justify-between gap-3 border-b border-border bg-background/80 px-4 py-3 backdrop-blur lg:px-8">
          <div className="flex items-center gap-2">
            <span className="text-sm font-semibold capitalize">{NAV.find((n) => n.key === section)?.label}</span>
          </div>
          <div className="flex items-center gap-2">
            {/* mobile section switcher */}
            <select
              className="rounded-lg border border-input bg-background px-2 py-1.5 text-sm lg:hidden"
              value={section} onChange={(e) => setSection(e.target.value as Section)}
            >
              {NAV.map((n) => <option key={n.key} value={n.key}>{n.label}</option>)}
            </select>
            <ThemeToggle label="Theme" />
            <Button variant="outline" size="sm" onClick={logout} className="hidden sm:inline-flex">
              <LogOut className="h-4 w-4" /> Sign out
            </Button>
          </div>
        </header>

        <main className="mx-auto w-full max-w-6xl flex-1 p-4 lg:p-8">
          {section === "overview" && <DashboardOverview />}
          {section === "homepage" && <HomeContentEditor />}
          {section === "pages" && <PagesManager />}
          {section === "menus" && <MenuManager />}
          {section === "enquiries" && <ContactInbox />}
        </main>
      </div>
    </div>
  );
}
