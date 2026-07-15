"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Mail, Linkedin, Save, Send, CheckCircle2, XCircle, Plug, RefreshCw } from "lucide-react";

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

type Masked = {
  emailEnabled: boolean;
  smtpFromName: string;
  smtpFromEmail: string;
  smtpHost: string;
  smtpPort: string;
  smtpUsername: string;
  smtpPasswordSet: boolean;
  smtpAlertEmail: string;
  smtpSecure: boolean;
  emailAuthType: "password" | "oauth2";
  emailOauthClientId: string;
  emailOauthClientSecretSet: boolean;
  emailOauthRefreshTokenSet: boolean;
  emailOauthUser: string;
  linkedinEnabled: boolean;
  linkedinAccessTokenSet: boolean;
  linkedinTokenExpiresAt: number | null;
  linkedinAuthorUrn: string;
  linkedinAutoPublish: boolean;
  linkedinClientId: string;
  linkedinClientSecretSet: boolean;
  linkedinProfileUrl: string;
  xEnabled: boolean;
  xApiKeySet: boolean;
  xApiSecretSet: boolean;
  xAccessTokenSet: boolean;
  xAccessSecretSet: boolean;
  xUsername: string;
  xAutoPublish: boolean;
};

type HealthEntry = {
  enabled: boolean;
  configured: boolean;
  connected: boolean | null;
  lastCheckedAt: number | null;
  lastSuccessAt: number | null;
  lastFailureAt: number | null;
  lastError: string | null;
  tokenExpiresAt: number | null;
  recentSuccessCount: number;
  recentFailureCount: number;
};
type Health = { email: HealthEntry; linkedin: HealthEntry; x: HealthEntry };

type ActivityItem = {
  id: string;
  integration: string;
  kind: string;
  success: boolean;
  detail: string | null;
  createdAt: string;
};

type TestResult = { ok: boolean; error?: string; checkedAt: string } | null;

const SECRET_PLACEHOLDER = "•••• (stored — leave blank to keep)";

// Small styled toggle button (no shared switch component in this project).
function Toggle({ on, onChange, label }: { on: boolean; onChange: (v: boolean) => void; label?: string }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      aria-label={label}
      onClick={() => onChange(!on)}
      className={`relative inline-flex h-6 w-11 shrink-0 items-center rounded-full transition-colors ${on ? "bg-primary" : "bg-muted"}`}
    >
      <span className={`inline-block h-5 w-5 transform rounded-full bg-background shadow transition-transform ${on ? "translate-x-5" : "translate-x-0.5"}`} />
    </button>
  );
}

// Tiny inline X (Twitter) glyph — lucide has no dedicated X icon in this version.
function XIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className={className} aria-hidden="true">
      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24h-6.66l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231 5.45-6.231Zm-1.161 17.52h1.833L7.084 4.126H5.117L17.083 19.77Z" />
    </svg>
  );
}

/** Human-relative timestamp, e.g. "2h ago" / "in 5d". Accepts epoch ms or ISO. */
function relativeTime(value: number | string | null | undefined): string | null {
  if (value == null) return null;
  const ts = typeof value === "number" ? value : Date.parse(value);
  if (Number.isNaN(ts)) return null;
  const diffMs = ts - Date.now();
  const future = diffMs > 0;
  const abs = Math.abs(diffMs);
  const sec = Math.round(abs / 1000);
  const min = Math.round(sec / 60);
  const hr = Math.round(min / 60);
  const day = Math.round(hr / 24);
  let unit: string;
  if (sec < 60) unit = `${sec}s`;
  else if (min < 60) unit = `${min}m`;
  else if (hr < 24) unit = `${hr}h`;
  else unit = `${day}d`;
  return future ? `in ${unit}` : `${unit} ago`;
}

type HealthState = "disabled" | "unconfigured" | "connected" | "error" | "unknown";

function computeHealthState(h: HealthEntry | undefined): HealthState {
  if (!h) return "unknown";
  if (!h.enabled) return "disabled";
  if (!h.configured) return "unconfigured";
  if (h.connected === true) return "connected";
  if (h.connected === false && h.lastError) return "error";
  return "unknown";
}

const HEALTH_META: Record<HealthState, { label: string; className: string }> = {
  disabled: { label: "Disabled", className: "bg-muted text-muted-foreground border-transparent" },
  unconfigured: { label: "Not configured", className: "bg-amber-100 text-amber-800 border-amber-200 dark:bg-amber-500/15 dark:text-amber-300 dark:border-amber-500/30" },
  connected: { label: "Connected", className: "bg-emerald-100 text-emerald-800 border-emerald-200 dark:bg-emerald-500/15 dark:text-emerald-300 dark:border-emerald-500/30" },
  error: { label: "Error", className: "bg-destructive/10 text-destructive border-destructive/30" },
  unknown: { label: "Unknown", className: "bg-muted text-muted-foreground border-transparent" }
};

function HealthBadge({ state }: { state: HealthState }) {
  const meta = HEALTH_META[state];
  return <span className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold ${meta.className}`}>{meta.label}</span>;
}

function HealthSummary({ health }: { health: HealthEntry | undefined }) {
  if (!health) return null;
  const success = relativeTime(health.lastSuccessAt);
  const failure = relativeTime(health.lastFailureAt);
  const tokenDays = health.tokenExpiresAt != null ? Math.floor((health.tokenExpiresAt - Date.now()) / (1000 * 60 * 60 * 24)) : null;
  const tokenExpired = tokenDays != null && tokenDays < 0;
  const tokenSoon = tokenDays != null && tokenDays >= 0 && tokenDays <= 7;
  return (
    <div className="space-y-1.5 text-xs">
      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-muted-foreground">
        <span className="inline-flex items-center gap-1"><CheckCircle2 className="h-3.5 w-3.5 text-emerald-600" />{health.recentSuccessCount} ok <span className="text-muted-foreground/60">(30d)</span></span>
        <span className="inline-flex items-center gap-1"><XCircle className="h-3.5 w-3.5 text-destructive" />{health.recentFailureCount} failed</span>
        {success && <span>Last ok {success}</span>}
        {failure && <span>Last fail {failure}</span>}
      </div>
      {health.tokenExpiresAt != null && (
        <div className={tokenExpired || tokenSoon ? "font-medium text-destructive" : "text-muted-foreground"}>
          {tokenExpired ? "Token expired — reconnect required" : `Token expires ${relativeTime(health.tokenExpiresAt)}`}
        </div>
      )}
      {health.lastError && <p className="rounded bg-destructive/5 px-2 py-1 text-destructive break-words">{health.lastError}</p>}
    </div>
  );
}

function TestResultBanner({ result }: { result: TestResult }) {
  if (!result) return null;
  return (
    <div className={`mt-3 flex items-start gap-2 rounded-md border p-2.5 text-xs ${result.ok ? "border-emerald-200 bg-emerald-50 text-emerald-800 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-300" : "border-destructive/30 bg-destructive/5 text-destructive"}`}>
      {result.ok ? <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0" /> : <XCircle className="mt-0.5 h-4 w-4 shrink-0" />}
      <div className="min-w-0">
        <span className="font-medium">{result.ok ? "Connection OK" : "Connection failed"}</span>
        {result.error && <span className="ml-1 break-words">— {result.error}</span>}
      </div>
    </div>
  );
}

const INTEGRATION_LABEL: Record<string, string> = { email: "Email", linkedin: "LinkedIn", x: "X" };
function fmtDate(value: string): string {
  return new Date(value).toLocaleString(undefined, { dateStyle: "medium", timeStyle: "short" });
}

function ActivityFeed({ items, loading, filter, onFilter, onRefresh, refreshing }: {
  items: ActivityItem[];
  loading: boolean;
  filter: "all" | "email" | "linkedin" | "x";
  onFilter: (f: "all" | "email" | "linkedin" | "x") => void;
  onRefresh: () => void;
  refreshing: boolean;
}) {
  const filters: { key: "all" | "email" | "linkedin" | "x"; label: string }[] = [
    { key: "all", label: "All" }, { key: "email", label: "Email" }, { key: "linkedin", label: "LinkedIn" }, { key: "x", label: "X" }
  ];
  return (
    <div className="rounded-xl border border-border p-5">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <div>
          <h3 className="font-semibold">Activity</h3>
          <p className="mt-0.5 text-xs text-muted-foreground">Recent connection tests, sends, and shares across all integrations.</p>
        </div>
        <div className="flex items-center gap-1">
          <div className="flex rounded-md border border-border p-0.5">
            {filters.map((f) => (
              <button key={f.key} type="button" onClick={() => onFilter(f.key)}
                className={`rounded px-2.5 py-1 text-xs font-medium transition-colors ${filter === f.key ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:text-foreground"}`}>
                {f.label}
              </button>
            ))}
          </div>
          <button type="button" onClick={onRefresh} title="Refresh" className="rounded-md p-1.5 text-muted-foreground hover:bg-accent hover:text-foreground">
            <RefreshCw className={`h-4 w-4 ${refreshing ? "animate-spin" : ""}`} />
          </button>
        </div>
      </div>
      {loading ? (
        <div className="h-24 animate-pulse rounded-lg bg-muted/40" />
      ) : items.length === 0 ? (
        <div className="rounded-lg border border-dashed border-border p-8 text-center text-sm text-muted-foreground">No activity recorded yet.</div>
      ) : (
        <div className="divide-y divide-border">
          {items.map((item) => (
            <div key={item.id} className="flex items-start gap-3 py-2.5 text-sm">
              {item.success ? <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" /> : <XCircle className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />}
              <div className="min-w-0 flex-1">
                <div className="flex flex-wrap items-center gap-2">
                  <span className="rounded-full border border-border px-2 py-0.5 text-[10px] font-medium text-muted-foreground">{INTEGRATION_LABEL[item.integration] ?? item.integration}</span>
                  <span className="font-medium capitalize">{item.kind.replace(/_/g, " ")}</span>
                  <span className="ml-auto text-xs text-muted-foreground">{relativeTime(item.createdAt)} · {fmtDate(item.createdAt)}</span>
                </div>
                {item.detail && <p className={`mt-0.5 break-words text-xs ${item.success ? "text-muted-foreground" : "text-destructive"}`}>{item.detail}</p>}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export function IntegrationsManager() {
  const [email, setEmail] = React.useState({
    emailEnabled: false, smtpFromName: "", smtpFromEmail: "", smtpHost: "", smtpPort: "",
    smtpUsername: "", smtpAlertEmail: "", smtpSecure: false, emailAuthType: "password" as "password" | "oauth2",
    emailOauthClientId: "", emailOauthUser: ""
  });
  const [smtpPassword, setSmtpPassword] = React.useState("");
  const [smtpPasswordSet, setSmtpPasswordSet] = React.useState(false);
  const [emailOauthClientSecret, setEmailOauthClientSecret] = React.useState("");
  const [emailOauthClientSecretSet, setEmailOauthClientSecretSet] = React.useState(false);
  const [emailOauthRefreshTokenSet, setEmailOauthRefreshTokenSet] = React.useState(false);
  const [testTo, setTestTo] = React.useState("");

  const [linkedin, setLinkedin] = React.useState({
    linkedinEnabled: false, linkedinAuthorUrn: "", linkedinAutoPublish: false, linkedinClientId: "",
    linkedinTokenExpiresAt: null as number | null, linkedinProfileUrl: ""
  });
  const [linkedinToken, setLinkedinToken] = React.useState("");
  const [linkedinTokenSet, setLinkedinTokenSet] = React.useState(false);
  const [linkedinClientSecret, setLinkedinClientSecret] = React.useState("");
  const [linkedinClientSecretSet, setLinkedinClientSecretSet] = React.useState(false);
  const [linkedinRedirectUri, setLinkedinRedirectUri] = React.useState("");
  const [linkedinTest, setLinkedinTest] = React.useState<TestResult>(null);

  const [x, setX] = React.useState({ xEnabled: false, xUsername: "", xAutoPublish: false });
  const [xSecrets, setXSecrets] = React.useState({ xApiKey: "", xApiSecret: "", xAccessToken: "", xAccessSecret: "" });
  const [xSet, setXSet] = React.useState({ xApiKeySet: false, xApiSecretSet: false, xAccessTokenSet: false, xAccessSecretSet: false });
  const [xTest, setXTest] = React.useState<TestResult>(null);

  const [status, setStatus] = React.useState<{ kind: "idle" | "ok" | "err"; msg: string }>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState<string | null>(null);

  const [health, setHealth] = React.useState<Health | null>(null);
  const [activity, setActivity] = React.useState<ActivityItem[]>([]);
  const [activityLoading, setActivityLoading] = React.useState(true);
  const [activityRefreshing, setActivityRefreshing] = React.useState(false);
  const [activityFilter, setActivityFilter] = React.useState<"all" | "email" | "linkedin" | "x">("all");

  const apply = React.useCallback((d: Masked) => {
    setEmail({
      emailEnabled: d.emailEnabled, smtpFromName: d.smtpFromName, smtpFromEmail: d.smtpFromEmail,
      smtpHost: d.smtpHost, smtpPort: d.smtpPort, smtpUsername: d.smtpUsername,
      smtpAlertEmail: d.smtpAlertEmail, smtpSecure: d.smtpSecure, emailAuthType: d.emailAuthType,
      emailOauthClientId: d.emailOauthClientId, emailOauthUser: d.emailOauthUser
    });
    setSmtpPasswordSet(d.smtpPasswordSet);
    setEmailOauthClientSecretSet(d.emailOauthClientSecretSet);
    setEmailOauthRefreshTokenSet(d.emailOauthRefreshTokenSet);
    setLinkedin({
      linkedinEnabled: d.linkedinEnabled, linkedinAuthorUrn: d.linkedinAuthorUrn, linkedinAutoPublish: d.linkedinAutoPublish,
      linkedinClientId: d.linkedinClientId, linkedinTokenExpiresAt: d.linkedinTokenExpiresAt, linkedinProfileUrl: d.linkedinProfileUrl
    });
    setLinkedinTokenSet(d.linkedinAccessTokenSet);
    setLinkedinClientSecretSet(d.linkedinClientSecretSet);
    setX({ xEnabled: d.xEnabled, xUsername: d.xUsername, xAutoPublish: d.xAutoPublish });
    setXSet({ xApiKeySet: d.xApiKeySet, xApiSecretSet: d.xApiSecretSet, xAccessTokenSet: d.xAccessTokenSet, xAccessSecretSet: d.xAccessSecretSet });
  }, []);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/integrations");
    if (!res.ok) return;
    apply((await res.json()) as Masked);
  }, [apply]);

  const loadHealth = React.useCallback(async () => {
    const res = await fetch("/api/admin/integrations/health");
    if (!res.ok) return;
    setHealth((await res.json()) as Health);
  }, []);

  const loadActivity = React.useCallback(async (filter: "all" | "email" | "linkedin" | "x", showSpinner = false) => {
    if (showSpinner) setActivityRefreshing(true);
    try {
      const qs = filter === "all" ? "" : `?integration=${filter}`;
      const res = await fetch(`/api/admin/integrations/activity${qs}`);
      if (res.ok) setActivity((await res.json()) as ActivityItem[]);
    } finally {
      setActivityLoading(false);
      setActivityRefreshing(false);
    }
  }, []);

  const loadRedirectUri = React.useCallback(async () => {
    const res = await fetch("/api/admin/social/linkedin/oauth/redirect-uri");
    if (!res.ok) return;
    const d = (await res.json()) as { redirectUri?: string };
    if (d.redirectUri) setLinkedinRedirectUri(d.redirectUri);
  }, []);

  React.useEffect(() => { void load(); void loadHealth(); void loadRedirectUri(); }, [load, loadHealth, loadRedirectUri]);
  React.useEffect(() => { void loadActivity(activityFilter); }, [activityFilter, loadActivity]);

  // Surface the outcome of an OAuth redirect (?linkedin=... or ?email=...), then
  // clear it from the URL so a refresh doesn't re-show the toast.
  React.useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const linkedinFlag = params.get("linkedin");
    const emailFlag = params.get("email");
    const messages: Record<string, string> = {
      connected: "connected successfully.",
      denied: "authorization was denied.",
      bad_state: "connection failed (invalid or expired state — try again).",
      no_code: "connection failed (no authorization code returned).",
      missing_client: "set the Client ID and Secret first, then try again.",
      error: "connection failed. Check the activity log below for details."
    };
    if (linkedinFlag) {
      setStatus({ kind: linkedinFlag === "connected" ? "ok" : "err", msg: `LinkedIn ${messages[linkedinFlag] ?? "connection updated."}` });
    } else if (emailFlag) {
      setStatus({ kind: emailFlag === "connected" ? "ok" : "err", msg: `Gmail ${messages[emailFlag] ?? "connection updated."}` });
    }
    if (linkedinFlag || emailFlag) {
      window.history.replaceState({}, "", window.location.pathname);
      void load();
      void loadHealth();
      void loadActivity(activityFilter);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const afterMutate = React.useCallback(() => {
    void loadHealth();
    void loadActivity(activityFilter);
  }, [loadHealth, loadActivity, activityFilter]);

  async function put(body: Record<string, unknown>, doneMsg: string, key: string) {
    setBusy(key); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/integrations", {
        method: "PUT", headers: { "content-type": "application/json" }, body: JSON.stringify(body)
      });
      if (!res.ok) {
        const e = (await res.json().catch(() => ({}))) as { error?: string };
        setStatus({ kind: "err", msg: e.error ?? "Save failed" });
        return;
      }
      apply((await res.json()) as Masked);
      setSmtpPassword(""); setEmailOauthClientSecret("");
      setLinkedinToken(""); setLinkedinClientSecret("");
      setXSecrets({ xApiKey: "", xApiSecret: "", xAccessToken: "", xAccessSecret: "" });
      setStatus({ kind: "ok", msg: doneMsg });
      afterMutate();
    } finally { setBusy(null); }
  }

  function saveEmail() {
    const body: Record<string, unknown> = {
      emailEnabled: email.emailEnabled, smtpFromName: email.smtpFromName, smtpFromEmail: email.smtpFromEmail,
      smtpHost: email.smtpHost, smtpPort: email.smtpPort, smtpUsername: email.smtpUsername,
      smtpAlertEmail: email.smtpAlertEmail, smtpSecure: email.smtpSecure, emailAuthType: email.emailAuthType,
      emailOauthClientId: email.emailOauthClientId, emailOauthUser: email.emailOauthUser
    };
    if (smtpPassword.trim()) body.smtpPassword = smtpPassword.trim();
    if (emailOauthClientSecret.trim()) body.emailOauthClientSecret = emailOauthClientSecret.trim();
    void put(body, "Email settings saved.", "email");
  }

  function saveLinkedin() {
    const body: Record<string, unknown> = {
      linkedinEnabled: linkedin.linkedinEnabled, linkedinAuthorUrn: linkedin.linkedinAuthorUrn,
      linkedinAutoPublish: linkedin.linkedinAutoPublish, linkedinClientId: linkedin.linkedinClientId,
      linkedinProfileUrl: linkedin.linkedinProfileUrl
    };
    if (linkedinToken.trim()) body.linkedinAccessToken = linkedinToken.trim();
    if (linkedinClientSecret.trim()) body.linkedinClientSecret = linkedinClientSecret.trim();
    void put(body, "LinkedIn settings saved.", "linkedin");
  }

  function saveX() {
    const body: Record<string, unknown> = {
      xEnabled: x.xEnabled, xUsername: x.xUsername, xAutoPublish: x.xAutoPublish
    };
    if (xSecrets.xApiKey.trim()) body.xApiKey = xSecrets.xApiKey.trim();
    if (xSecrets.xApiSecret.trim()) body.xApiSecret = xSecrets.xApiSecret.trim();
    if (xSecrets.xAccessToken.trim()) body.xAccessToken = xSecrets.xAccessToken.trim();
    if (xSecrets.xAccessSecret.trim()) body.xAccessSecret = xSecrets.xAccessSecret.trim();
    void put(body, "X settings saved.", "x");
  }

  async function sendTest() {
    setBusy("test"); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/integrations/test-email", {
        method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ to: testTo.trim() })
      });
      const d = (await res.json().catch(() => ({}))) as { ok?: boolean; error?: string };
      if (res.ok && d.ok) setStatus({ kind: "ok", msg: `Test email sent to ${testTo.trim()}.` });
      else setStatus({ kind: "err", msg: d.error ?? "Test email failed." });
    } catch (e) {
      setStatus({ kind: "err", msg: e instanceof Error ? e.message : "Test email failed." });
    } finally { setBusy(null); afterMutate(); }
  }

  async function testLinkedinConnection() {
    setBusy("linkedin-test"); setLinkedinTest(null);
    try {
      const res = await fetch("/api/admin/social/linkedin/test", { method: "POST" });
      const d = (await res.json().catch(() => ({ ok: false, checkedAt: new Date().toISOString() }))) as TestResult;
      setLinkedinTest(d);
    } catch (e) {
      setLinkedinTest({ ok: false, error: e instanceof Error ? e.message : "Request failed", checkedAt: new Date().toISOString() });
    } finally { setBusy(null); afterMutate(); }
  }

  async function testXConnection() {
    setBusy("x-test"); setXTest(null);
    try {
      const res = await fetch("/api/admin/social/x/test", { method: "POST" });
      const d = (await res.json().catch(() => ({ ok: false, checkedAt: new Date().toISOString() }))) as TestResult;
      setXTest(d);
    } catch (e) {
      setXTest({ ok: false, error: e instanceof Error ? e.message : "Request failed", checkedAt: new Date().toISOString() });
    } finally { setBusy(null); afterMutate(); }
  }

  const gmailRedirectUri = typeof window !== "undefined" ? `${window.location.origin}/api/admin/email/oauth/callback` : "";

  return (
    <section className="max-w-3xl space-y-8">
      <div>
        <h2 className="text-lg font-semibold">Integrations</h2>
        <p className="text-sm text-muted-foreground">Connect outbound email, LinkedIn, and X. Secrets are encrypted at rest and never shown again — leave a secret field blank to keep the stored value.</p>
      </div>

      {status.kind !== "idle" && (
        <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
          {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
          {status.msg}
        </div>
      )}

      {/* Email */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <Mail className="h-4 w-4 text-primary" /><h3 className="font-semibold">Email</h3>
            <HealthBadge state={computeHealthState(health?.email)} />
          </div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{email.emailEnabled ? "On" : "Off"}</span>
            <Toggle on={email.emailEnabled} onChange={(v) => setEmail({ ...email, emailEnabled: v })} label="Enable email" />
          </div>
        </div>

        <div className="mb-4 rounded-lg border border-border bg-muted/20 p-3"><HealthSummary health={health?.email} /></div>

        <div className="mb-4 flex items-center gap-4 text-sm">
          <label className="flex items-center gap-2">
            <input type="radio" checked={email.emailAuthType === "password"} onChange={() => setEmail({ ...email, emailAuthType: "password" })} />
            SMTP password
          </label>
          <label className="flex items-center gap-2">
            <input type="radio" checked={email.emailAuthType === "oauth2"} onChange={() => setEmail({ ...email, emailAuthType: "oauth2" })} />
            Gmail OAuth2
          </label>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className={lbl}>From name</label>
            <input className={`${inp} mt-1`} value={email.smtpFromName} onChange={(e) => setEmail({ ...email, smtpFromName: e.target.value })} placeholder="OXOT" />
          </div>
          <div>
            <label className={lbl}>From email</label>
            <input className={`${inp} mt-1`} value={email.smtpFromEmail} onChange={(e) => setEmail({ ...email, smtpFromEmail: e.target.value })} placeholder="no-reply@oxot.example" />
          </div>

          {email.emailAuthType === "password" ? (
            <>
              <div>
                <label className={lbl}>SMTP host</label>
                <input className={`${inp} mt-1`} value={email.smtpHost} onChange={(e) => setEmail({ ...email, smtpHost: e.target.value })} placeholder="smtp.example.com" />
              </div>
              <div>
                <label className={lbl}>SMTP port</label>
                <input className={`${inp} mt-1`} value={email.smtpPort} onChange={(e) => setEmail({ ...email, smtpPort: e.target.value })} placeholder="587" inputMode="numeric" />
                <p className="mt-1 text-xs text-muted-foreground">465 for SSL, 587 for STARTTLS</p>
              </div>
              <div>
                <label className={lbl}>SMTP username</label>
                <input className={`${inp} mt-1`} value={email.smtpUsername} onChange={(e) => setEmail({ ...email, smtpUsername: e.target.value })} autoComplete="off" />
              </div>
              <div>
                <label className={lbl}>SMTP password</label>
                <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={smtpPassword} onChange={(e) => setSmtpPassword(e.target.value)} placeholder={smtpPasswordSet ? SECRET_PLACEHOLDER : "SMTP password"} />
              </div>
              <div className="flex items-end justify-between gap-2">
                <div>
                  <label className={lbl}>Use SSL/TLS</label>
                  <p className="mt-1 text-xs text-muted-foreground">On for port 465</p>
                </div>
                <Toggle on={email.smtpSecure} onChange={(v) => setEmail({ ...email, smtpSecure: v })} label="Use SSL/TLS" />
              </div>
            </>
          ) : (
            <>
              <div>
                <label className={lbl}>Gmail address</label>
                <input className={`${inp} mt-1`} value={email.emailOauthUser} onChange={(e) => setEmail({ ...email, emailOauthUser: e.target.value })} placeholder="you@gmail.com" autoComplete="off" />
              </div>
              <div>
                <label className={lbl}>OAuth Client ID</label>
                <input className={`${inp} mt-1`} value={email.emailOauthClientId} onChange={(e) => setEmail({ ...email, emailOauthClientId: e.target.value })} placeholder="Google OAuth client ID" />
              </div>
              <div>
                <label className={lbl}>OAuth Client secret</label>
                <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={emailOauthClientSecret} onChange={(e) => setEmailOauthClientSecret(e.target.value)} placeholder={emailOauthClientSecretSet ? SECRET_PLACEHOLDER : "Google OAuth client secret"} />
              </div>
              <div className="sm:col-span-2 rounded-md border border-border p-3 text-xs text-muted-foreground">
                <p>Whitelist this redirect URI in your Google Cloud OAuth client:</p>
                <code className="mt-1 block break-all rounded bg-muted px-2 py-1">{gmailRedirectUri}</code>
                <p className="mt-2">{emailOauthRefreshTokenSet ? "Gmail is connected." : "Save the Client ID/secret above, then click Connect Google."}</p>
              </div>
            </>
          )}

          <div>
            <label className={lbl}>Alert email</label>
            <input className={`${inp} mt-1`} value={email.smtpAlertEmail} onChange={(e) => setEmail({ ...email, smtpAlertEmail: e.target.value })} placeholder="alerts@oxot.example" />
          </div>
        </div>

        {email.emailAuthType === "oauth2" && (
          <div className="mt-4">
            <Button type="button" variant="outline" onClick={() => { window.location.href = "/api/admin/email/oauth/start"; }}>
              <Mail className="h-4 w-4" /> {emailOauthRefreshTokenSet ? "Reconnect Google" : "Connect Google"}
            </Button>
          </div>
        )}

        <div className="mt-4 flex flex-wrap items-end gap-2 rounded-md border border-border p-3">
          <div className="flex-1 min-w-[200px]">
            <label className={lbl}>Send a test email to</label>
            <input className={`${inp} mt-1`} value={testTo} onChange={(e) => setTestTo(e.target.value)} placeholder="you@example.com" />
          </div>
          <Button type="button" variant="outline" onClick={sendTest} disabled={busy === "test" || !testTo.trim()}>
            <Send className="h-4 w-4" /> {busy === "test" ? "Sending…" : "Send test email"}
          </Button>
        </div>

        <div className="mt-4">
          <Button onClick={saveEmail} disabled={busy === "email"}><Save className="h-4 w-4" /> {busy === "email" ? "Saving…" : "Save email settings"}</Button>
        </div>
      </div>

      {/* LinkedIn */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <Linkedin className="h-4 w-4 text-primary" /><h3 className="font-semibold">LinkedIn</h3>
            <HealthBadge state={computeHealthState(health?.linkedin)} />
          </div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{linkedin.linkedinEnabled ? "On" : "Off"}</span>
            <Toggle on={linkedin.linkedinEnabled} onChange={(v) => setLinkedin({ ...linkedin, linkedinEnabled: v })} label="Enable LinkedIn" />
          </div>
        </div>

        <div className="mb-4 rounded-lg border border-border bg-muted/20 p-3"><HealthSummary health={health?.linkedin} /></div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className={lbl}>Author URN</label>
            <input className={`${inp} mt-1`} value={linkedin.linkedinAuthorUrn} onChange={(e) => setLinkedin({ ...linkedin, linkedinAuthorUrn: e.target.value })} placeholder="urn:li:organization:12345" />
          </div>
          <div>
            <label className={lbl}>Company / profile URL</label>
            <input className={`${inp} mt-1`} value={linkedin.linkedinProfileUrl} onChange={(e) => setLinkedin({ ...linkedin, linkedinProfileUrl: e.target.value })} placeholder="https://www.linkedin.com/company/oxot" />
            <p className="mt-1 text-xs text-muted-foreground">Public — shown on the site's Follow Along card and footer link.</p>
          </div>
          <div>
            <label className={lbl}>Access token</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={linkedinToken} onChange={(e) => setLinkedinToken(e.target.value)} placeholder={linkedinTokenSet ? SECRET_PLACEHOLDER : "Set via Connect, or paste manually"} />
          </div>
          <div>
            <label className={lbl}>OAuth Client ID</label>
            <input className={`${inp} mt-1`} value={linkedin.linkedinClientId} onChange={(e) => setLinkedin({ ...linkedin, linkedinClientId: e.target.value })} placeholder="LinkedIn app client ID" />
          </div>
          <div>
            <label className={lbl}>OAuth Client secret</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={linkedinClientSecret} onChange={(e) => setLinkedinClientSecret(e.target.value)} placeholder={linkedinClientSecretSet ? SECRET_PLACEHOLDER : "LinkedIn app client secret"} />
          </div>
          <div className="sm:col-span-2 flex items-end justify-between gap-2">
            <label className={lbl}>Auto-publish</label>
            <Toggle on={linkedin.linkedinAutoPublish} onChange={(v) => setLinkedin({ ...linkedin, linkedinAutoPublish: v })} label="Auto-publish to LinkedIn" />
          </div>
          <div className="sm:col-span-2 rounded-md border border-border p-3 text-xs text-muted-foreground">
            <p>Whitelist this redirect URI in your LinkedIn OAuth app (Auth &gt; OAuth 2.0 settings):</p>
            <code className="mt-1 block break-all rounded bg-muted px-2 py-1">{linkedinRedirectUri || "Loading…"}</code>
          </div>
        </div>

        <TestResultBanner result={linkedinTest} />

        <div className="mt-4 flex flex-wrap items-center gap-2">
          <Button type="button" variant="outline" onClick={testLinkedinConnection} disabled={busy === "linkedin-test"}>
            <Plug className="h-4 w-4" /> {busy === "linkedin-test" ? "Testing…" : "Test connection"}
          </Button>
          <Button type="button" variant="outline" onClick={() => { window.location.href = "/api/admin/social/linkedin/oauth/start"; }}>
            <Linkedin className="h-4 w-4" /> {linkedinTokenSet ? "Reconnect LinkedIn" : "Connect LinkedIn"}
          </Button>
          <Button onClick={saveLinkedin} disabled={busy === "linkedin"}><Save className="h-4 w-4" /> {busy === "linkedin" ? "Saving…" : "Save LinkedIn settings"}</Button>
        </div>
        <p className="mt-2 text-xs text-muted-foreground">Save your Client ID and Secret first, then click Connect to authorize via LinkedIn.</p>
      </div>

      {/* X */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <XIcon className="h-4 w-4 text-primary" /><h3 className="font-semibold">X</h3>
            <HealthBadge state={computeHealthState(health?.x)} />
          </div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{x.xEnabled ? "On" : "Off"}</span>
            <Toggle on={x.xEnabled} onChange={(v) => setX({ ...x, xEnabled: v })} label="Enable X" />
          </div>
        </div>

        <div className="mb-4 rounded-lg border border-border bg-muted/20 p-3"><HealthSummary health={health?.x} /></div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className={lbl}>API key</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={xSecrets.xApiKey} onChange={(e) => setXSecrets({ ...xSecrets, xApiKey: e.target.value })} placeholder={xSet.xApiKeySet ? SECRET_PLACEHOLDER : "API key"} />
          </div>
          <div>
            <label className={lbl}>API secret</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={xSecrets.xApiSecret} onChange={(e) => setXSecrets({ ...xSecrets, xApiSecret: e.target.value })} placeholder={xSet.xApiSecretSet ? SECRET_PLACEHOLDER : "API secret"} />
          </div>
          <div>
            <label className={lbl}>Access token</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={xSecrets.xAccessToken} onChange={(e) => setXSecrets({ ...xSecrets, xAccessToken: e.target.value })} placeholder={xSet.xAccessTokenSet ? SECRET_PLACEHOLDER : "Access token"} />
          </div>
          <div>
            <label className={lbl}>Access secret</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={xSecrets.xAccessSecret} onChange={(e) => setXSecrets({ ...xSecrets, xAccessSecret: e.target.value })} placeholder={xSet.xAccessSecretSet ? SECRET_PLACEHOLDER : "Access secret"} />
          </div>
          <div>
            <label className={lbl}>Username</label>
            <input className={`${inp} mt-1`} value={x.xUsername} onChange={(e) => setX({ ...x, xUsername: e.target.value })} placeholder="@oxot" />
          </div>
          <div className="flex items-end justify-between gap-2">
            <label className={lbl}>Auto-publish</label>
            <Toggle on={x.xAutoPublish} onChange={(v) => setX({ ...x, xAutoPublish: v })} label="Auto-publish to X" />
          </div>
        </div>

        <TestResultBanner result={xTest} />

        <div className="mt-4 flex flex-wrap items-center gap-2">
          <Button type="button" variant="outline" onClick={testXConnection} disabled={busy === "x-test"}>
            <Plug className="h-4 w-4" /> {busy === "x-test" ? "Testing…" : "Test connection"}
          </Button>
          <Button onClick={saveX} disabled={busy === "x"}><Save className="h-4 w-4" /> {busy === "x" ? "Saving…" : "Save X settings"}</Button>
        </div>
      </div>

      <ActivityFeed
        items={activity}
        loading={activityLoading}
        filter={activityFilter}
        onFilter={setActivityFilter}
        onRefresh={() => void loadActivity(activityFilter, true)}
        refreshing={activityRefreshing}
      />
    </section>
  );
}
