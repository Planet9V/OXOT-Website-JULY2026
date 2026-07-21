"use client";
// Generic recursive VISUAL form for any JSON-shaped block config.
// Ported from the Celestial-Agent-Nexus admin (artifacts/oxot-web/src/components/
// admin/json-fields.tsx) — the proven editor this project is based on — and
// adapted to this repo's UI primitives. It introspects a config object and
// renders friendly controls (text/textarea auto-switch, number, boolean toggle,
// arrays with Add/Remove, nested objects) so EVERY block edits visually — no
// admin ever writes JSON. `humanizeKey` turns "titleAccent" -> "Title Accent".
import { Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";

type Json = unknown;

export function humanizeKey(key: string): string {
  const spaced = key.replace(/([a-z0-9])([A-Z])/g, "$1 $2").replace(/[_-]+/g, " ").trim();
  return spaced.charAt(0).toUpperCase() + spaced.slice(1);
}

// A blank value matching the shape of an existing one — used when adding array items.
function blankLike(value: Json): Json {
  if (Array.isArray(value)) return value.length ? [blankLike(value[0])] : [];
  if (value && typeof value === "object") {
    const out: Record<string, Json> = {};
    for (const [k, v] of Object.entries(value)) out[k] = blankLike(v);
    return out;
  }
  if (typeof value === "boolean") return false;
  if (typeof value === "number") return 0;
  return "";
}

function FieldLabel({ children }: { children: React.ReactNode }) {
  return <Label className="text-xs font-medium text-muted-foreground">{children}</Label>;
}

function FieldEditor({ label, value, onChange, depth }: { label: string; value: Json; onChange: (n: Json) => void; depth: number }) {
  if (typeof value === "boolean") {
    return (
      <label className="flex items-center justify-between gap-3 py-1">
        <FieldLabel>{label}</FieldLabel>
        <input type="checkbox" checked={value} onChange={(e) => onChange(e.target.checked)} className="h-4 w-4 accent-[hsl(var(--primary))]" />
      </label>
    );
  }
  if (typeof value === "number") {
    return (
      <div className="space-y-1">
        <FieldLabel>{label}</FieldLabel>
        <Input type="number" value={value} onChange={(e) => onChange(e.target.value === "" ? 0 : Number(e.target.value))} />
      </div>
    );
  }
  if (typeof value === "string" || value === null || value === undefined) {
    const str = (value ?? "") as string;
    const multiline = str.length > 60 || str.includes("\n");
    return (
      <div className="space-y-1">
        <FieldLabel>{label}</FieldLabel>
        {multiline
          ? <Textarea rows={3} value={str} onChange={(e) => onChange(e.target.value)} />
          : <Input value={str} onChange={(e) => onChange(e.target.value)} />}
      </div>
    );
  }
  if (Array.isArray(value)) return <ArrayEditor label={label} value={value} onChange={onChange as (n: Json[]) => void} depth={depth} />;
  return (
    <div className="space-y-2">
      <FieldLabel>{label}</FieldLabel>
      <div className="space-y-3 rounded-md border border-dashed border-border p-3">
        <ObjectFields value={value as Record<string, Json>} onChange={onChange} depth={depth + 1} />
      </div>
    </div>
  );
}

function ArrayEditor({ label, value, onChange, depth }: { label: string; value: Json[]; onChange: (n: Json[]) => void; depth: number }) {
  const first = value[0];
  const isObjectArray = first !== null && typeof first === "object";
  const update = (i: number, next: Json) => { const c = value.slice(); c[i] = next; onChange(c); };
  const remove = (i: number) => onChange(value.filter((_, k) => k !== i));
  const move = (i: number, d: number) => { const j = i + d; if (j < 0 || j >= value.length) return; const c = value.slice(); [c[i], c[j]] = [c[j], c[i]]; onChange(c); };
  const add = () => onChange([...value, value.length ? blankLike(value[0]) : ""]);
  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <FieldLabel>{label}</FieldLabel>
        <Button type="button" variant="ghost" size="sm" className="h-7 gap-1 text-xs" onClick={add}><Plus className="h-3 w-3" /> Add</Button>
      </div>
      {value.length === 0 && <p className="text-xs text-muted-foreground">No items yet.</p>}
      <div className="space-y-2">
        {value.map((item, i) => (
          <div key={i} className="rounded-md border border-border bg-muted/20 p-3">
            <div className="mb-2 flex items-center justify-between">
              <span className="text-xs font-medium text-muted-foreground">{isObjectArray ? `Item ${i + 1}` : ""}</span>
              <div className="flex gap-1">
                <Button type="button" variant="ghost" size="sm" className="h-6 px-1.5 text-xs" onClick={() => move(i, -1)}>↑</Button>
                <Button type="button" variant="ghost" size="sm" className="h-6 px-1.5 text-xs" onClick={() => move(i, 1)}>↓</Button>
                <Button type="button" variant="ghost" size="icon" className="h-6 w-6 text-muted-foreground hover:text-destructive" onClick={() => remove(i)}><Trash2 className="h-3.5 w-3.5" /></Button>
              </div>
            </div>
            {isObjectArray
              ? <ObjectFields value={item as Record<string, Json>} onChange={(n) => update(i, n)} depth={depth + 1} />
              : <Input value={(item ?? "") as string} onChange={(e) => update(i, e.target.value)} />}
          </div>
        ))}
      </div>
    </div>
  );
}

export function ObjectFields({ value, onChange, depth = 0 }: { value: Record<string, Json>; onChange: (n: Record<string, Json>) => void; depth?: number }) {
  const entries = Object.entries(value ?? {});
  if (entries.length === 0) return <p className="text-xs text-muted-foreground">This block has no editable fields.</p>;
  return (
    <div className="space-y-3">
      {entries.map(([key, val]) => (
        <FieldEditor key={key} label={humanizeKey(key)} value={val} onChange={(next) => onChange({ ...value, [key]: next })} depth={depth} />
      ))}
    </div>
  );
}
