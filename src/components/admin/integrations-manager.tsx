"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Mail, Linkedin, Save, Send, CheckCircle2, XCircle } from "lucide-react";

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
  linkedinEnabled: boolean;
  linkedinAccessTokenSet: boolean;
  linkedinAuthorUrn: string;
  linkedinAutoPublish: boolean;
  xEnabled: boolean;
  xApiKeySet: boolean;
  xApiSecretSet: boolean;
  xAccessTokenSet: boolean;
  xAccessSecretSet: boolean;
  xUsername: string;
  xAutoPublish: boolean;
};

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

export function IntegrationsManager() {
  const [email, setEmail] = React.useState({
    emailEnabled: false, smtpFromName: "", smtpFromEmail: "", smtpHost: "", smtpPort: "",
    smtpUsername: "", smtpAlertEmail: "", smtpSecure: false
  });
  const [smtpPassword, setSmtpPassword] = React.useState("");
  const [smtpPasswordSet, setSmtpPasswordSet] = React.useState(false);
  const [testTo, setTestTo] = React.useState("");

  const [linkedin, setLinkedin] = React.useState({
    linkedinEnabled: false, linkedinAuthorUrn: "", linkedinAutoPublish: false
  });
  const [linkedinToken, setLinkedinToken] = React.useState("");
  const [linkedinTokenSet, setLinkedinTokenSet] = React.useState(false);

  const [x, setX] = React.useState({ xEnabled: false, xUsername: "", xAutoPublish: false });
  const [xSecrets, setXSecrets] = React.useState({ xApiKey: "", xApiSecret: "", xAccessToken: "", xAccessSecret: "" });
  const [xSet, setXSet] = React.useState({ xApiKeySet: false, xApiSecretSet: false, xAccessTokenSet: false, xAccessSecretSet: false });

  const [status, setStatus] = React.useState<{ kind: "idle" | "ok" | "err"; msg: string }>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState<string | null>(null);

  const apply = React.useCallback((d: Masked) => {
    setEmail({
      emailEnabled: d.emailEnabled, smtpFromName: d.smtpFromName, smtpFromEmail: d.smtpFromEmail,
      smtpHost: d.smtpHost, smtpPort: d.smtpPort, smtpUsername: d.smtpUsername,
      smtpAlertEmail: d.smtpAlertEmail, smtpSecure: d.smtpSecure
    });
    setSmtpPasswordSet(d.smtpPasswordSet);
    setLinkedin({ linkedinEnabled: d.linkedinEnabled, linkedinAuthorUrn: d.linkedinAuthorUrn, linkedinAutoPublish: d.linkedinAutoPublish });
    setLinkedinTokenSet(d.linkedinAccessTokenSet);
    setX({ xEnabled: d.xEnabled, xUsername: d.xUsername, xAutoPublish: d.xAutoPublish });
    setXSet({ xApiKeySet: d.xApiKeySet, xApiSecretSet: d.xApiSecretSet, xAccessTokenSet: d.xAccessTokenSet, xAccessSecretSet: d.xAccessSecretSet });
  }, []);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/integrations");
    if (!res.ok) return;
    apply((await res.json()) as Masked);
  }, [apply]);
  React.useEffect(() => { void load(); }, [load]);

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
      setSmtpPassword(""); setLinkedinToken(""); setXSecrets({ xApiKey: "", xApiSecret: "", xAccessToken: "", xAccessSecret: "" });
      setStatus({ kind: "ok", msg: doneMsg });
    } finally { setBusy(null); }
  }

  function saveEmail() {
    const body: Record<string, unknown> = {
      emailEnabled: email.emailEnabled, smtpFromName: email.smtpFromName, smtpFromEmail: email.smtpFromEmail,
      smtpHost: email.smtpHost, smtpPort: email.smtpPort, smtpUsername: email.smtpUsername,
      smtpAlertEmail: email.smtpAlertEmail, smtpSecure: email.smtpSecure
    };
    if (smtpPassword.trim()) body.smtpPassword = smtpPassword.trim();
    void put(body, "Email settings saved.", "email");
  }

  function saveLinkedin() {
    const body: Record<string, unknown> = {
      linkedinEnabled: linkedin.linkedinEnabled, linkedinAuthorUrn: linkedin.linkedinAuthorUrn,
      linkedinAutoPublish: linkedin.linkedinAutoPublish
    };
    if (linkedinToken.trim()) body.linkedinAccessToken = linkedinToken.trim();
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
    } finally { setBusy(null); }
  }

  return (
    <section className="max-w-3xl space-y-8">
      <div>
        <h2 className="text-lg font-semibold">Integrations</h2>
        <p className="text-sm text-muted-foreground">Connect outbound email (SMTP) and social publishing. Secrets are encrypted at rest and never shown again — leave a secret field blank to keep the stored value.</p>
      </div>

      {status.kind !== "idle" && (
        <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
          {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
          {status.msg}
        </div>
      )}

      {/* Email (SMTP) */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center justify-between gap-2">
          <div className="flex items-center gap-2"><Mail className="h-4 w-4 text-primary" /><h3 className="font-semibold">Email (SMTP)</h3></div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{email.emailEnabled ? "On" : "Off"}</span>
            <Toggle on={email.emailEnabled} onChange={(v) => setEmail({ ...email, emailEnabled: v })} label="Enable email" />
          </div>
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
          <div>
            <label className={lbl}>Alert email</label>
            <input className={`${inp} mt-1`} value={email.smtpAlertEmail} onChange={(e) => setEmail({ ...email, smtpAlertEmail: e.target.value })} placeholder="alerts@oxot.example" />
          </div>
          <div className="flex items-end justify-between gap-2">
            <div>
              <label className={lbl}>Use SSL/TLS</label>
              <p className="mt-1 text-xs text-muted-foreground">On for port 465</p>
            </div>
            <Toggle on={email.smtpSecure} onChange={(v) => setEmail({ ...email, smtpSecure: v })} label="Use SSL/TLS" />
          </div>
        </div>

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
          <div className="flex items-center gap-2"><Linkedin className="h-4 w-4 text-primary" /><h3 className="font-semibold">LinkedIn</h3></div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{linkedin.linkedinEnabled ? "On" : "Off"}</span>
            <Toggle on={linkedin.linkedinEnabled} onChange={(v) => setLinkedin({ ...linkedin, linkedinEnabled: v })} label="Enable LinkedIn" />
          </div>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className={lbl}>Access token</label>
            <input type="password" autoComplete="new-password" className={`${inp} mt-1`} value={linkedinToken} onChange={(e) => setLinkedinToken(e.target.value)} placeholder={linkedinTokenSet ? SECRET_PLACEHOLDER : "LinkedIn access token"} />
          </div>
          <div>
            <label className={lbl}>Author URN</label>
            <input className={`${inp} mt-1`} value={linkedin.linkedinAuthorUrn} onChange={(e) => setLinkedin({ ...linkedin, linkedinAuthorUrn: e.target.value })} placeholder="urn:li:organization:12345" />
          </div>
          <div className="flex items-end justify-between gap-2">
            <label className={lbl}>Auto-publish</label>
            <Toggle on={linkedin.linkedinAutoPublish} onChange={(v) => setLinkedin({ ...linkedin, linkedinAutoPublish: v })} label="Auto-publish to LinkedIn" />
          </div>
        </div>
        <div className="mt-4">
          <Button onClick={saveLinkedin} disabled={busy === "linkedin"}><Save className="h-4 w-4" /> {busy === "linkedin" ? "Saving…" : "Save LinkedIn settings"}</Button>
        </div>
      </div>

      {/* X */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center justify-between gap-2">
          <div className="flex items-center gap-2"><XIcon className="h-4 w-4 text-primary" /><h3 className="font-semibold">X</h3></div>
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span>{x.xEnabled ? "On" : "Off"}</span>
            <Toggle on={x.xEnabled} onChange={(v) => setX({ ...x, xEnabled: v })} label="Enable X" />
          </div>
        </div>
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
        <div className="mt-4">
          <Button onClick={saveX} disabled={busy === "x"}><Save className="h-4 w-4" /> {busy === "x" ? "Saving…" : "Save X settings"}</Button>
        </div>
      </div>
    </section>
  );
}
