"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { RefreshCw, Save, Cpu, Cloud, KeyRound, AlertTriangle, CheckCircle2, XCircle, Database, BrainCircuit } from "lucide-react";
import { ROLE_LABELS, modelsForRole, catalogEntry, type ModelRole } from "@/lib/ai-catalog";

type Model = { id: string; label: string };
type Masked = {
  ollamaHost: string; embedModel: string; embedDim: number;
  embedProvider: "ollama" | "openrouter"; openrouterEmbedModel: string;
  chatProvider: "ollama" | "openrouter";
  ollamaChatModel: string; openrouterModel: string;
  openrouterKeySet: boolean; openrouterKeyLast4: string | null; openrouterKeyFromEnv: boolean;
  chatModel: string; briefModel: string; translationModel: string; longContextModel: string; searchModel: string;
};

// The subset of form fields that hold a per-role OpenRouter model id.
type RoleModelField = "chatModel" | "briefModel" | "translationModel" | "longContextModel" | "searchModel";

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const sel = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm disabled:cursor-not-allowed disabled:opacity-60";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

// One dropdown per role, in display order. Embeddings is NOT in this list — it has
// its own editable card below (model + provider settable; vector dimension fixed at
// EMBED_DIM, with a Rebuild-now reminder after a model change).
const ROLE_ORDER: ModelRole[] = ["chat", "brief", "translation", "long-context", "search"];

const ROLE_FIELD: Record<ModelRole, RoleModelField | null> = {
  chat: "chatModel",
  brief: "briefModel",
  translation: "translationModel",
  "long-context": "longContextModel",
  search: "searchModel",
  embeddings: null
};

export function AiSettings() {
  const [form, setForm] = React.useState({
    ollamaHost: "", embedModel: "", chatProvider: "openrouter" as "ollama" | "openrouter",
    embedProvider: "openrouter" as "ollama" | "openrouter", openrouterEmbedModel: "",
    ollamaChatModel: "", openrouterModel: "",
    chatModel: "", briefModel: "", translationModel: "", longContextModel: "", searchModel: ""
  });
  const [meta, setMeta] = React.useState<Pick<Masked, "embedDim" | "openrouterKeySet" | "openrouterKeyLast4" | "openrouterKeyFromEnv">>({
    embedDim: 0, openrouterKeySet: false, openrouterKeyLast4: null, openrouterKeyFromEnv: false
  });
  const [keyInput, setKeyInput] = React.useState("");
  const [ollamaModels, setOllamaModels] = React.useState<Model[]>([]);
  const [status, setStatus] = React.useState<{ kind: "idle" | "ok" | "err"; msg: string }>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState<string | null>(null);
  const [chunks, setChunks] = React.useState<number | null>(null);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/ai-settings");
    if (!res.ok) return;
    const d = (await res.json()) as Masked;
    setForm({
      ollamaHost: d.ollamaHost, embedModel: d.embedModel, chatProvider: d.chatProvider,
      embedProvider: d.embedProvider ?? "openrouter", openrouterEmbedModel: d.openrouterEmbedModel ?? "",
      ollamaChatModel: d.ollamaChatModel, openrouterModel: d.openrouterModel,
      chatModel: d.chatModel, briefModel: d.briefModel, translationModel: d.translationModel,
      longContextModel: d.longContextModel, searchModel: d.searchModel
    });
    setMeta({ embedDim: d.embedDim, openrouterKeySet: d.openrouterKeySet, openrouterKeyLast4: d.openrouterKeyLast4, openrouterKeyFromEnv: d.openrouterKeyFromEnv });
  }, []);

  const loadStats = React.useCallback(async () => {
    try {
      const res = await fetch("/api/admin/stats");
      if (!res.ok) return;
      const d = (await res.json()) as { kpis?: { chunks?: number } };
      if (typeof d.kpis?.chunks === "number") setChunks(d.kpis.chunks);
    } catch { /* ignore — count stays as-is */ }
  }, []);

  React.useEffect(() => { void load(); void loadStats(); }, [load, loadStats]);

  async function fetchOllamaModels() {
    setBusy("ollama"); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch(`/api/admin/ai-settings/models?provider=ollama&host=${encodeURIComponent(form.ollamaHost)}`);
      const d = (await res.json()) as { ok: boolean; models?: Model[]; error?: string };
      if (!d.ok) { setStatus({ kind: "err", msg: `Ollama: ${d.error ?? "lookup failed"}` }); return; }
      setOllamaModels(d.models ?? []);
      setStatus({ kind: "ok", msg: `Ollama: found ${d.models?.length ?? 0} model(s).` });
    } catch (e) {
      setStatus({ kind: "err", msg: `Ollama: ${e instanceof Error ? e.message : "lookup failed"}` });
    } finally { setBusy(null); }
  }

  async function save() {
    setBusy("save"); setStatus({ kind: "idle", msg: "" });
    try {
      const body: Record<string, string> = {
        ollamaHost: form.ollamaHost, embedModel: form.embedModel, chatProvider: form.chatProvider,
        embedProvider: form.embedProvider, openrouterEmbedModel: form.openrouterEmbedModel,
        ollamaChatModel: form.ollamaChatModel, openrouterModel: form.openrouterModel,
        chatModel: form.chatModel, briefModel: form.briefModel, translationModel: form.translationModel,
        longContextModel: form.longContextModel, searchModel: form.searchModel
      };
      if (keyInput.trim()) body.openrouterApiKey = keyInput.trim(); // only send when changed
      const res = await fetch("/api/admin/ai-settings", { method: "PUT", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
      if (!res.ok) { setStatus({ kind: "err", msg: (await res.json()).error ?? "save failed" }); return; }
      setKeyInput("");
      await load();
      setStatus({ kind: "ok", msg: "Saved. New requests use these settings within ~10s." });
    } finally { setBusy(null); }
  }

  async function clearKey() {
    if (!confirm("Clear the stored OpenRouter key and fall back to the .env value?")) return;
    setBusy("save");
    await fetch("/api/admin/ai-settings", { method: "PUT", headers: { "content-type": "application/json" }, body: JSON.stringify({ openrouterApiKey: "" }) });
    setKeyInput(""); await load(); setBusy(null);
    setStatus({ kind: "ok", msg: "OpenRouter key cleared (using .env fallback if present)." });
  }

  // Poll GET /api/admin/content/reindex every ~5s while a background rebuild
  // is running, so the admin sees passage/page counts climb without refreshing.
  const pollRebuildStatus = React.useCallback(() => {
    const timer = setInterval(async () => {
      try {
        const res = await fetch("/api/admin/content/reindex");
        if (!res.ok) return;
        const d = (await res.json()) as {
          running?: boolean; pagesDone?: number; chunks?: number; error?: string | null;
        };
        if (d.running) {
          setStatus({ kind: "ok", msg: `Rebuilding… ${d.pagesDone ?? 0} page(s), ${d.chunks ?? 0} passage(s) so far.` });
          return;
        }
        clearInterval(timer);
        setBusy(null);
        await loadStats();
        if (d.error) {
          setStatus({ kind: "err", msg: `Rebuild failed: ${d.error}` });
        } else {
          setStatus({ kind: "ok", msg: `Knowledge rebuilt: ${d.chunks ?? 0} passage(s) from ${d.pagesDone ?? 0} page(s).` });
        }
      } catch {
        // transient network hiccup while polling — try again on the next tick
      }
    }, 5000);
  }, [loadStats]);

  async function reindex() {
    setBusy("reindex"); setStatus({ kind: "idle", msg: "" });
    try {
      const res = await fetch("/api/admin/content/reindex", { method: "POST" });
      const d = (await res.json().catch(() => ({}))) as { ok?: boolean; started?: boolean; alreadyRunning?: boolean; error?: string };
      if (!res.ok || !d.ok) {
        setStatus({ kind: "err", msg: `Rebuild failed: ${d.error ?? "server error"}` });
        setBusy(null);
        return;
      }
      if (d.alreadyRunning) {
        setStatus({ kind: "ok", msg: "A rebuild is already running." });
        pollRebuildStatus();
        return;
      }
      if (d.started) {
        setStatus({ kind: "ok", msg: "Rebuild started — this runs in the background. Refresh in a few minutes to see the passage count climb." });
        pollRebuildStatus();
        return;
      }
      setBusy(null);
    } catch (e) {
      setStatus({ kind: "err", msg: `Rebuild failed: ${e instanceof Error ? e.message : "network error"}` });
      setBusy(null);
    }
  }

  const ollamaConfigured = !!form.ollamaHost.trim();
  const openrouterConfigured = meta.openrouterKeySet;

  return (
    <section className="max-w-3xl space-y-8">
      <div>
        <h2 className="text-lg font-semibold">AI &amp; Models</h2>
        <p className="text-sm text-muted-foreground">Configure the assistant&apos;s knowledge index, provider connections, and which model handles each role. Settings are stored in the database and override <code>.env</code>; changes apply to new requests within ~10 seconds.</p>
      </div>

      {status.kind !== "idle" && (
        <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
          {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
          {status.msg}
        </div>
      )}

      {/* 1. Assistant knowledge */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center gap-2"><Database className="h-4 w-4 text-primary" /><h3 className="font-semibold">Assistant knowledge</h3></div>
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div className="space-y-1">
            <p className="text-sm text-muted-foreground">
              The assistant answers from your published page content, embedded with the locked embedding model below. Rebuild after bulk edits — the rebuild re-embeds every published page.
            </p>
            <div className="pt-1 text-sm">
              <span className="text-muted-foreground">Indexed passages: </span>
              <span className="font-medium">{chunks ?? "—"}</span>
            </div>
          </div>
          <Button type="button" variant="outline" onClick={reindex} disabled={busy === "reindex"}>
            <RefreshCw className={`h-4 w-4 ${busy === "reindex" ? "animate-spin" : ""}`} />
            {busy === "reindex" ? "Rebuilding…" : "Rebuild now"}
          </Button>
        </div>
        <p className="mt-3 text-xs text-muted-foreground">Rebuilding calls the configured embedding backend to re-embed content. If it isn&apos;t reachable from the server, the rebuild reports the error and leaves the existing index untouched.</p>
      </div>

      {/* 2. Provider connections */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center gap-2"><Cloud className="h-4 w-4 text-primary" /><h3 className="font-semibold">Provider connections</h3></div>
        <div className="grid gap-3 sm:grid-cols-2">
          <div className="flex items-start gap-3 rounded-lg border border-border p-3">
            {ollamaConfigured ? <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-primary" /> : <XCircle className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" />}
            <div className="w-full">
              <div className="flex items-center gap-2">
                <Cpu className="h-4 w-4 text-muted-foreground" />
                <span className="font-medium">Ollama (local)</span>
                <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${ollamaConfigured ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>{ollamaConfigured ? "Connected" : "Not set"}</span>
              </div>
              <p className="mt-0.5 text-xs text-muted-foreground">Local generation and embedding fallback. Configured via the Ollama host below.</p>
              <div className="mt-2 flex gap-2">
                <input className={inp} list="ollama-models" value={form.ollamaHost} onChange={(e) => setForm({ ...form, ollamaHost: e.target.value })} placeholder="http://host.docker.internal:11434" />
                <Button type="button" variant="outline" onClick={fetchOllamaModels} disabled={busy === "ollama"} title="Look up installed Ollama models">
                  <RefreshCw className={`h-4 w-4 ${busy === "ollama" ? "animate-spin" : ""}`} />
                </Button>
              </div>
              <div className="mt-2">
                <label className={lbl}>Ollama chat model (shared across all roles)</label>
                <input className={`${inp} mt-1`} list="ollama-models" value={form.ollamaChatModel} onChange={(e) => setForm({ ...form, ollamaChatModel: e.target.value })} placeholder="qwen3.5:9b" />
              </div>
            </div>
          </div>
          <div className="flex items-start gap-3 rounded-lg border border-border p-3">
            {openrouterConfigured ? <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-primary" /> : <XCircle className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" />}
            <div className="w-full">
              <div className="flex items-center gap-2">
                <Cloud className="h-4 w-4 text-muted-foreground" />
                <span className="font-medium">OpenRouter (cloud)</span>
                <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${openrouterConfigured ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>{openrouterConfigured ? "Connected" : "Not set"}</span>
              </div>
              <p className="mt-0.5 text-xs text-muted-foreground">Automatic cloud fallback for generation, and required for the model catalog below (per-role assignments, embeddings, web search).</p>
              <div className="mt-2">
                <label className={lbl}><KeyRound className="mr-1 inline h-3.5 w-3.5" /> OpenRouter API key</label>
                {meta.openrouterKeySet ? (
                  <div className="mt-1 flex items-center gap-2 rounded-md border border-primary/30 bg-primary/5 px-3 py-2 text-sm text-foreground">
                    <CheckCircle2 className="h-4 w-4 text-primary" />
                    <span>Key saved — ••••{meta.openrouterKeyLast4}{meta.openrouterKeyFromEnv ? " (from .env)" : ""}</span>
                  </div>
                ) : (
                  <div className="mt-1 flex items-center gap-2 rounded-md border border-amber-500/30 bg-amber-500/5 px-3 py-2 text-sm text-foreground">
                    <AlertTriangle className="h-4 w-4 text-amber-500" />
                    <span>No key set — the assistant, translation, and embeddings can&apos;t reach OpenRouter until you save one.</span>
                  </div>
                )}
                <input type="password" autoComplete="off" className={`${inp} mt-2`} value={keyInput} onChange={(e) => setKeyInput(e.target.value)}
                  placeholder={meta.openrouterKeySet ? "Enter a new key to replace it, or leave blank to keep" : "sk-or-… paste your OpenRouter key"} />
                <div className="mt-2 flex items-center gap-3 text-xs text-muted-foreground">
                  <span>Stored encrypted in the database (never shown again). Click <strong className="text-foreground">Save settings</strong> below to persist.</span>
                  {meta.openrouterKeySet && !meta.openrouterKeyFromEnv && (
                    <button type="button" onClick={clearKey} className="text-red-500 hover:underline">Clear stored key</button>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="mt-4">
          <label className={lbl}>Primary provider <span className="font-normal normal-case tracking-normal text-muted-foreground">(the other is the automatic fallback for every role)</span></label>
          <select className={`${sel} mt-1 sm:max-w-xs`} value={form.chatProvider} onChange={(e) => setForm({ ...form, chatProvider: e.target.value as "ollama" | "openrouter" })}>
            <option value="ollama">Ollama (local) first</option>
            <option value="openrouter">OpenRouter (cloud) first</option>
          </select>
          {!openrouterConfigured && (
            <p className="mt-2 flex items-start gap-2 text-xs text-muted-foreground">
              <AlertTriangle className="mt-0.5 h-3.5 w-3.5 shrink-0 text-amber-500" />
              No OpenRouter key set — role assignments below still save, but calls that need OpenRouter (web search, and any role while Ollama is unreachable) will fail closed and the agent degrades to a plain no-context answer.
            </p>
          )}
        </div>
        <datalist id="ollama-models">{ollamaModels.map((m) => <option key={m.id} value={m.id}>{m.label}</option>)}</datalist>
      </div>

      {/* 3. Model assignments */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center gap-2"><BrainCircuit className="h-4 w-4 text-primary" /><h3 className="font-semibold">Model assignments</h3></div>
        <p className="mb-4 text-sm text-muted-foreground">Each role picks the OpenRouter model used when a call resolves to OpenRouter. When Ollama is used instead, the single Ollama chat model above is used for every role — there is one local model, not one per role.</p>

        <div className="space-y-4">
          {ROLE_ORDER.map((role) => {
            const field = ROLE_FIELD[role]!;
            const options = modelsForRole(role);
            const selected = form[field];
            const selectedEntry = catalogEntry(selected) ?? options[0];
            return (
              <div key={role}>
                <label className={lbl}>{ROLE_LABELS[role]}</label>
                <select
                  className={`${sel} mt-1`}
                  value={selected}
                  onChange={(e) => setForm({ ...form, [field]: e.target.value })}
                >
                  {options.map((m) => (
                    <option key={m.id} value={m.id}>{m.label} — {m.id}</option>
                  ))}
                </select>
                {selectedEntry && <p className="mt-1 text-xs text-muted-foreground">{selectedEntry.description}</p>}
              </div>
            );
          })}

          {/* Embeddings — model + provider editable; dimension fixed at EMBED_DIM */}
          <div className="rounded-lg border border-border p-3">
            <label className={lbl}>{ROLE_LABELS.embeddings}</label>
            <div className="mt-2 grid gap-3 sm:grid-cols-2">
              <div>
                <label className="text-xs text-muted-foreground">Embedding provider</label>
                <select className={`${sel} mt-1`} value={form.embedProvider} onChange={(e) => setForm({ ...form, embedProvider: e.target.value as "ollama" | "openrouter" })}>
                  <option value="openrouter">OpenRouter (cloud)</option>
                  <option value="ollama">Ollama (local)</option>
                </select>
              </div>
              <div>
                <label className="text-xs text-muted-foreground">Vector dimension (fixed)</label>
                <input className={`${inp} mt-1`} value={`${meta.embedDim || 1536} dims`} disabled />
              </div>
              <div>
                <label className="text-xs text-muted-foreground">OpenRouter embedding model</label>
                <input className={`${inp} mt-1`} value={form.openrouterEmbedModel} onChange={(e) => setForm({ ...form, openrouterEmbedModel: e.target.value })} placeholder="qwen/qwen3-embedding-4b" />
              </div>
              <div>
                <label className="text-xs text-muted-foreground">Ollama embedding model (fallback)</label>
                <input className={`${inp} mt-1`} list="ollama-models" value={form.embedModel} onChange={(e) => setForm({ ...form, embedModel: e.target.value })} placeholder="qwen3-embedding:4b" />
              </div>
            </div>
            <div className="mt-2 flex items-start gap-2 rounded-md border border-amber-500/30 bg-amber-500/5 p-3 text-xs text-muted-foreground">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-amber-500" />
              <span>You can change the embedding model, but the vector dimension <strong className="text-foreground">EMBED_DIM = {meta.embedDim || 1536}</strong> is fixed by the database schema — models that emit more dimensions are truncated to it (qwen3-embedding-4b emits 2560 → truncated to {meta.embedDim || 1536}). Pick a model that emits at least {meta.embedDim || 1536} dims. After changing the model, click <strong className="text-foreground">Rebuild now</strong> above to re-embed all content.</span>
            </div>
          </div>
        </div>

        <div className="mt-6 flex items-center gap-3">
          <Button onClick={save} disabled={busy === "save"}><Save className="h-4 w-4" /> {busy === "save" ? "Saving…" : "Save settings"}</Button>
        </div>
      </div>
    </section>
  );
}
