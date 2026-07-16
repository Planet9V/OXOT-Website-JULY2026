"use client";
import * as React from "react";
import {
  LayoutDashboard, Home, LayoutTemplate, FileText, Menu as MenuIcon, Inbox, LogOut, ShieldCheck, ExternalLink, Images, GalleryHorizontal, Bot, Plug, Send, BarChart3, LineChart, Layers, ClipboardList, Network
} from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { DashboardOverview } from "@/components/admin/dashboard-overview";
import { CraHomeEditor } from "@/components/admin/cra-home-editor";
import { CdtEditor } from "@/components/admin/cdt-editor";
import { ConformityHomeEditor } from "@/components/admin/conformity-home-editor";
import { HomeContentEditor } from "@/components/admin/home-content-editor";
import { IntakeLeadsManager } from "@/components/admin/intake-leads-manager";
import { PagesManager } from "@/components/admin/pages-manager";
import { MenuManager } from "@/components/admin/menu-manager";
import { InquiriesManager } from "@/components/admin/inquiries-manager";
import { MediaManager } from "@/components/admin/media-manager";
import { AiSettings } from "@/components/admin/ai-settings";
import { IntegrationsManager } from "@/components/admin/integrations-manager";
import { NewsletterSocialManager } from "@/components/admin/newsletter-social-manager";
import { AnalyticsManager } from "@/components/admin/analytics-manager";
import { AffiliateSeoManager } from "@/components/admin/affiliate-seo-manager";
import { CarouselManager } from "@/components/admin/carousel-manager";

type Section = "overview" | "cra-home" | "cdt" | "home" | "homepage" | "pages" | "menus" | "media" | "carousel" | "enquiries" | "leads" | "ai" | "integrations" | "newsletter" | "analytics" | "affiliate-seo";
// Order is display-only (each item's key→component wiring is unchanged). Grouped for
// admin UX: Overview → Content authoring → Audience & growth → Configuration, roughly
// by how often a small content team touches each, with set-and-forget config last.
const NAV: { key: Section; label: string; icon: React.ElementType }[] = [
  // Overview
  { key: "overview", label: "Dashboard", icon: LayoutDashboard },
  // Content authoring — flagship pages first, then supporting assets, then site structure
  { key: "cra-home", label: "Home page", icon: Home },
  { key: "cdt", label: "Cyber Digital Twin", icon: Network },
  { key: "home", label: "Conformity page", icon: Layers },
  { key: "homepage", label: "Approach page", icon: LayoutTemplate },
  { key: "pages", label: "Pages", icon: FileText },
  { key: "media", label: "Media", icon: Images },
  { key: "carousel", label: "Carousel", icon: GalleryHorizontal },
  { key: "menus", label: "Menus", icon: MenuIcon },
  // Audience & growth — inbound leads → outbound marketing → measurement → optimization
  { key: "enquiries", label: "Enquiries", icon: Inbox },
  { key: "leads", label: "CRA Leads", icon: ClipboardList },
  { key: "newsletter", label: "Newsletter & Social", icon: Send },
  { key: "analytics", label: "Analytics", icon: BarChart3 },
  { key: "affiliate-seo", label: "Affiliate & SEO", icon: LineChart },
  // Configuration — set-and-forget, kept at the bottom
  { key: "ai", label: "AI & Models", icon: Bot },
  { key: "integrations", label: "Integrations", icon: Plug }
];

export function AdminShell({ email }: { email: string }) {
  const [section, setSection] = React.useState<Section>("overview");

  // OAuth "connect" flows (LinkedIn / Gmail) redirect back to /admin with a
  // status query param (?linkedin=..., ?email=...) or an explicit
  // ?section=integrations — open the Integrations tab so the result is visible
  // without the admin having to navigate there manually.
  React.useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    if (params.has("linkedin") || params.has("email") || params.get("section") === "integrations") {
      setSection("integrations");
    }
  }, []);

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
          {section === "cra-home" && <CraHomeEditor />}
          {section === "cdt" && <CdtEditor />}
          {section === "home" && <ConformityHomeEditor />}
          {section === "homepage" && <HomeContentEditor />}
          {section === "pages" && <PagesManager />}
          {section === "menus" && <MenuManager />}
          {section === "media" && <MediaManager />}
          {section === "carousel" && <CarouselManager />}
          {section === "enquiries" && <InquiriesManager />}
          {section === "leads" && <IntakeLeadsManager />}
          {section === "ai" && <AiSettings />}
          {section === "integrations" && <IntegrationsManager />}
          {section === "newsletter" && <NewsletterSocialManager />}
          {section === "analytics" && <AnalyticsManager />}
          {section === "affiliate-seo" && <AffiliateSeoManager />}
        </main>
      </div>
    </div>
  );
}
