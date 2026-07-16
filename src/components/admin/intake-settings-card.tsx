"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Settings, Save, CheckCircle2, XCircle, ChevronDown, ChevronUp } from "lucide-react";

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

const SEGMENTS = ["manufacturer", "oem", "integrator", "reseller", "operator"] as const;
const SEGMENT_LABEL: Record<(typeof SEGMENTS)[number], string> = {
  manufacturer: "Manufacturer",
  oem: "OEM",
  integrator: "Integrator",
  reseller: "Reseller",
  operator: "Operator"
};

type SchedulingProvider = "none" | "calcom" | "calendly";

type IntakeSettings = {
  schedulingProvider: SchedulingProvider;
  schedulingUrl: string;
  segmentEmailAutosend: boolean;
  segmentPdfMap: Record<string, string>;
  notifyEmail: string;
};

const EMPTY: IntakeSettings = {
  schedulingProvider: "none",
  schedulingUrl: "",
  segmentEmailAutosend: false,
  segmentPdfMap: {},
  notifyEmail: ""
};

// Small styled toggle button (mirrors the one in integrations-manager.tsx — no
// shared switch component in this project).
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

export function IntakeSettingsCard() {
  const [open, setOpen] = React.useState(false);
  const [form, setForm] = React.useState<IntakeSettings>(EMPTY);
  const [loading, setLoading] = React.useState(true);
  const [busy, setBusy] = React.useState(false);
  const [status, setStatus] = React.useState<{ kind: "idle" | "ok" | "err"; msg: string }>({ kind: "idle", msg: "" });

  const load = React.useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/admin/intake-settings");
      if (res.ok) setForm((await res.json()) as IntakeSettings);
    } finally {
      setLoading(false);
    }
  }, []);

  React.useEffect(() => { void load(); }, [load]);

  function setPdfPath(segment: string, path: string) {
    setForm((f) => ({ ...f, segmentPdfMap: { ...f.segmentPdfMap, [segment]: path } }));
  }

  async function save() {
    setBusy(true);
    setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/intake-settings", {
        method: "PUT",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          schedulingProvider: form.schedulingProvider,
          schedulingUrl: form.schedulingUrl,
          segmentEmailAutosend: form.segmentEmailAutosend,
          segmentPdfMap: form.segmentPdfMap,
          notifyEmail: form.notifyEmail
        })
      });
      if (!res.ok) {
        const e = (await res.json().catch(() => ({}))) as { error?: string };
        setStatus({ kind: "err", msg: e.error ?? "Save failed" });
        return;
      }
      setForm((await res.json()) as IntakeSettings);
      setStatus({ kind: "ok", msg: "Intake settings saved." });
    } catch (e) {
      setStatus({ kind: "err", msg: e instanceof Error ? e.message : "Save failed" });
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        aria-expanded={open}
        className="flex w-full items-center justify-between gap-2 p-5 text-left"
      >
        <span className="flex items-center gap-2">
          <Settings className="h-4 w-4 text-primary" />
          <span className="font-semibold">Intake settings</span>
          <span className="text-xs font-normal text-muted-foreground">— scheduling, autosend, and segment PDFs</span>
        </span>
        {open ? <ChevronUp className="h-4 w-4 text-muted-foreground" /> : <ChevronDown className="h-4 w-4 text-muted-foreground" />}
      </button>

      {open && (
        <CardContent className="space-y-5 pt-0">
          {loading ? (
            <div className="h-24 animate-pulse rounded-lg bg-muted/40" />
          ) : (
            <>
              {status.kind !== "idle" && (
                <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
                  {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
                  {status.msg}
                </div>
              )}

              <div className="grid gap-4 sm:grid-cols-2">
                <div>
                  <label className={lbl}>Scheduling provider</label>
                  <select
                    className={`${inp} mt-1`}
                    value={form.schedulingProvider}
                    onChange={(e) => setForm({ ...form, schedulingProvider: e.target.value as SchedulingProvider })}
                  >
                    <option value="none">None</option>
                    <option value="calcom">Cal.com</option>
                    <option value="calendly">Calendly</option>
                  </select>
                </div>
                <div>
                  <label className={lbl}>Scheduling URL</label>
                  <input
                    className={`${inp} mt-1`}
                    value={form.schedulingUrl}
                    onChange={(e) => setForm({ ...form, schedulingUrl: e.target.value })}
                    placeholder="https://cal.com/oxot/intro"
                  />
                </div>
                <div>
                  <label className={lbl}>Notify email</label>
                  <input
                    className={`${inp} mt-1`}
                    value={form.notifyEmail}
                    onChange={(e) => setForm({ ...form, notifyEmail: e.target.value })}
                    placeholder="leads@oxot.example"
                  />
                  <p className="mt-1 text-xs text-muted-foreground">Internal address notified when a new lead comes in.</p>
                </div>
                <div className="flex items-end justify-between gap-2">
                  <div>
                    <label className={lbl}>Segment email autosend</label>
                    <p className="mt-1 text-xs text-muted-foreground">Auto-send the matching segment PDF on submit.</p>
                  </div>
                  <Toggle on={form.segmentEmailAutosend} onChange={(v) => setForm({ ...form, segmentEmailAutosend: v })} label="Segment email autosend" />
                </div>
              </div>

              <div>
                <label className={lbl}>Segment PDF map</label>
                <p className="mt-1 mb-2 text-xs text-muted-foreground">Path or ID of the readiness PDF sent for each segment.</p>
                <div className="space-y-2">
                  {SEGMENTS.map((s) => (
                    <div key={s} className="grid grid-cols-3 items-center gap-2 sm:grid-cols-4">
                      <span className="text-sm font-medium">{SEGMENT_LABEL[s]}</span>
                      <input
                        className={`${inp} col-span-2 sm:col-span-3`}
                        value={form.segmentPdfMap[s] ?? ""}
                        onChange={(e) => setPdfPath(s, e.target.value)}
                        placeholder={`/pdfs/${s}-readiness.pdf`}
                      />
                    </div>
                  ))}
                </div>
              </div>

              <div>
                <Button onClick={save} disabled={busy}><Save className="h-4 w-4" /> {busy ? "Saving…" : "Save intake settings"}</Button>
              </div>
            </>
          )}
        </CardContent>
      )}
    </Card>
  );
}
