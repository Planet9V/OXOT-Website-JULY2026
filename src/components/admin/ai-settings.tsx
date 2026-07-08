"use client";
import * as React from "react";
import { Button } from "@/components/ui/button";
import { RefreshCw, Save, Cpu, Cloud, KeyRound, AlertTriangle, CheckCircle2, XCircle } from "lucide-react";

type Model = { id: string; label: string };
type Masked = {
  ollamaHost: string; embedModel: string; embedDim: number;
  chatProvider: "ollama" | "openrouter";
  ollamaChatModel: string; openrouterModel: string;
  openrouterKeySet: boolean; openrouterKeyLast4: string | null; openrouterKeyFromEnv: boolean;
};

const inp = "w-full rounded-md border border-border bg-background px-3 py-2 text-sm";
const lbl = "text-xs font-semibold uppercase tracking-[0.15em] text-muted-foreground";

export function AiSettings() {
  const [form, setForm] = React.useState({
    ollamaHost: "", embedModel: "", chatProvider: "openrouter" as "ollama" | "openrouter",
    ollamaChatModel: "", openrouterModel: ""
  });
  const [meta, setMeta] = React.useState<Pick<Masked, "embedDim" | "openrouterKeySet" | "openrouterKeyLast4" | "openrouterKeyFromEnv">>({
    embedDim: 0, openrouterKeySet: false, openrouterKeyLast4: null, openrouterKeyFromEnv: false
  });
  const [keyInput, setKeyInput] = React.useState("");
  const [ollamaModels, setOllamaModels] = React.useState<Model[]>([]);
  const [orModels, setOrModels] = React.useState<Model[]>([]);
  const [orFilter, setOrFilter] = React.useState("");
  const [status, setStatus] = React.useState<{ kind: "idle" | "ok" | "err"; msg: string }>({ kind: "idle", msg: "" });
  const [busy, setBusy] = React.useState<string | null>(null);

  const load = React.useCallback(async () => {
    const res = await fetch("/api/admin/ai-settings");
    if (!res.ok) return;
    const d = (await res.json()) as Masked;
    setForm({
      ollamaHost: d.ollamaHost, embedModel: d.embedModel, chatProvider: d.chatProvider,
      ollamaChatModel: d.ollamaChatModel, openrouterModel: d.openrouterModel
    });
    setMeta({ embedDim: d.embedDim, openrouterKeySet: d.openrouterKeySet, openrouterKeyLast4: d.openrouterKeyLast4, openrouterKeyFromEnv: d.openrouterKeyFromEnv });
  }, []);
  React.useEffect(() => { void load(); }, [load]);

  async function fetchModels(provider: "ollama" | "openrouter") {
    setBusy(provider); setStatus({ kind: "idle", msg: "" });
    try {
      const q = provider === "ollama" ? `provider=ollama&host=${encodeURIComponent(form.ollamaHost)}` : "provider=openrouter";
      const res = await fetch(`/api/admin/ai-settings/models?${q}`);
      const d = (await res.json()) as { ok: boolean; models?: Model[]; error?: string };
      if (!d.ok) { setStatus({ kind: "err", msg: `${provider}: ${d.error ?? "lookup failed"}` }); return; }
      if (provider === "ollama") setOllamaModels(d.models ?? []); else setOrModels(d.models ?? []);
      setStatus({ kind: "ok", msg: `${provider}: found ${d.models?.length ?? 0} model(s).` });
    } catch (e) {
      setStatus({ kind: "err", msg: `${provider}: ${e instanceof Error ? e.message : "lookup failed"}` });
    } finally { setBusy(null); }
  }

  async function save() {
    setBusy("save"); setStatus({ kind: "idle", msg: "" });
    try {
      const body: Record<string, string> = {
        ollamaHost: form.ollamaHost, embedModel: form.embedModel, chatProvider: form.chatProvider,
        ollamaChatModel: form.ollamaChatModel, openrouterModel: form.openrouterModel
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

  const orFiltered = orFilter ? orModels.filter((m) => m.id.toLowerCase().includes(orFilter.toLowerCase())) : orModels;

  return (
    <section className="max-w-3xl space-y-8">
      <div>
        <h2 className="text-lg font-semibold">AI &amp; Models</h2>
        <p className="text-sm text-muted-foreground">Configure the embedding (vector) and generation providers. Settings are stored in the database and override <code>.env</code>; changes apply to new requests within ~10 seconds.</p>
      </div>

      {status.kind !== "idle" && (
        <div className={`flex items-center gap-2 rounded-lg border p-3 text-sm ${status.kind === "ok" ? "border-primary/30 bg-primary/5 text-foreground" : "border-red-500/30 bg-red-500/5 text-foreground"}`}>
          {status.kind === "ok" ? <CheckCircle2 className="h-4 w-4 text-primary" /> : <XCircle className="h-4 w-4 text-red-500" />}
          {status.msg}
        </div>
      )}

      {/* Embedding / vector */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center gap-2"><Cpu className="h-4 w-4 text-primary" /><h3 className="font-semibold">Embeddings (vector store)</h3></div>
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className={lbl}>Ollama host</label>
            <input className={`${inp} mt-1`} value={form.ollamaHost} onChange={(e) => setForm({ ...form, ollamaHost: e.target.value })} placeholder="http://host.docker.internal:11434" />
          </div>
          <div className="sm:col-span-2">
            <label className={lbl}>Embedding model</label>
            <div className="mt-1 flex gap-2">
              <input className={inp} list="ollama-models" value={form.embedModel} onChange={(e) => setForm({ ...form, embedModel: e.target.value })} placeholder="qwen3-embedding:4b" />
              <Button type="button" variant="outline" onClick={() => fetchModels("ollama")} disabled={busy === "ollama"}>
                <RefreshCw className={`h-4 w-4 ${busy === "ollama" ? "animate-spin" : ""}`} /> Lookup
              </Button>
            </div>
          </div>
        </div>
        <div className="mt-4 flex items-start gap-2 rounded-md border border-amber-500/30 bg-amber-500/5 p-3 text-xs text-muted-foreground">
          <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-amber-500" />
          <span>Vector dimension <strong className="text-foreground">EMBED_DIM = {meta.embedDim}</strong> is fixed by the database schema. Choosing a model with a different native dimension requires a new migration and a full re-index, so it isn&apos;t editable here.</span>
        </div>
      </div>

      {/* Generation */}
      <div className="rounded-xl border border-border p-5">
        <div className="mb-4 flex items-center gap-2"><Cloud className="h-4 w-4 text-primary" /><h3 className="font-semibold">Generation (AI agent)</h3></div>
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className={lbl}>Primary provider <span className="font-normal normal-case tracking-normal text-muted-foreground">(the other is the automatic fallback)</span></label>
            <select className={`${inp} mt-1`} value={form.chatProvider} onChange={(e) => setForm({ ...form, chatProvider: e.target.value as "ollama" | "openrouter" })}>
              <option value="ollama">Ollama (local) first</option>
              <option value="openrouter">OpenRouter (cloud) first</option>
            </select>
          </div>

          <div>
            <label className={lbl}>Ollama chat model</label>
            <div className="mt-1 flex gap-2">
              <input className={inp} list="ollama-models" value={form.ollamaChatModel} onChange={(e) => setForm({ ...form, ollamaChatModel: e.target.value })} placeholder="qwen3.5:9b" />
              <Button type="button" variant="outline" onClick={() => fetchModels("ollama")} disabled={busy === "ollama"} title="Uses the Ollama host above">
                <RefreshCw className={`h-4 w-4 ${busy === "ollama" ? "animate-spin" : ""}`} />
              </Button>
            </div>
          </div>

          <div>
            <label className={lbl}>OpenRouter model</label>
            <div className="mt-1 flex gap-2">
              <input className={inp} list="or-models" value={form.openrouterModel} onChange={(e) => setForm({ ...form, openrouterModel: e.target.value })} placeholder="openai/gpt-4o-mini" />
              <Button type="button" variant="outline" onClick={() => fetchModels("openrouter")} disabled={busy === "openrouter"}>
                <RefreshCw className={`h-4 w-4 ${busy === "openrouter" ? "animate-spin" : ""}`} />
              </Button>
            </div>
            {orModels.length > 0 && (
              <input className={`${inp} mt-2`} value={orFilter} onChange={(e) => setOrFilter(e.target.value)} placeholder={`Filter ${orModels.length} models…`} />
            )}
          </div>

          <div className="sm:col-span-2">
            <label className={lbl}><KeyRound className="mr-1 inline h-3.5 w-3.5" /> OpenRouter API key</label>
            <input type="password" autoComplete="off" className={`${inp} mt-1`} value={keyInput} onChange={(e) => setKeyInput(e.target.value)}
              placeholder={meta.openrouterKeySet ? `Key set ••••${meta.openrouterKeyLast4}${meta.openrouterKeyFromEnv ? " (from .env)" : ""} — leave blank to keep` : "sk-or-… (not set)"} />
            <div className="mt-2 flex items-center gap-3 text-xs text-muted-foreground">
              <span>Stored in the database (never shown again). Secure your DB at rest.</span>
              {meta.openrouterKeySet && !meta.openrouterKeyFromEnv && (
                <button type="button" onClick={clearKey} className="text-red-500 hover:underline">Clear stored key</button>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* datalists populated by lookups */}
      <datalist id="ollama-models">{ollamaModels.map((m) => <option key={m.id} value={m.id}>{m.label}</option>)}</datalist>
      <datalist id="or-models">{orFiltered.slice(0, 200).map((m) => <option key={m.id} value={m.id}>{m.label}</option>)}</datalist>

      <div className="flex items-center gap-3">
        <Button onClick={save} disabled={busy === "save"}><Save className="h-4 w-4" /> {busy === "save" ? "Saving…" : "Save settings"}</Button>
      </div>
    </section>
  );
}
