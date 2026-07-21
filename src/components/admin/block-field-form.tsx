"use client";
// Schema-driven form for one block's config (docs/BLOCK-CMS-PLAN.md Phase 3).
// Renders friendly controls from a block's field schema; repeatable lists get
// add / remove / reorder. Deep/complex blocks (fields: []) fall back to the JSON
// power-editor in the parent builder.
import { Plus, Trash2, ChevronUp, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import type { Field } from "@/lib/blocks/schema";

type Obj = Record<string, unknown>;

function get(obj: Obj, key: string): unknown {
  return obj?.[key];
}

export function BlockFieldForm({
  fields,
  value,
  onChange
}: {
  fields: Field[];
  value: Obj;
  onChange: (next: Obj) => void;
}) {
  const set = (key: string, v: unknown) => onChange({ ...value, [key]: v });

  return (
    <div className="space-y-4">
      {fields.map((f) => (
        <FieldControl key={f.key} field={f} value={get(value, f.key)} onChange={(v) => set(f.key, v)} />
      ))}
    </div>
  );
}

function FieldControl({ field, value, onChange }: { field: Field; value: unknown; onChange: (v: unknown) => void }) {
  const label = (
    <Label className="text-xs font-medium text-muted-foreground">
      {field.label}
      {"help" in field && field.help ? <span className="ml-2 font-normal opacity-70">{field.help}</span> : null}
    </Label>
  );

  switch (field.type) {
    case "text":
    case "image":
    case "icon":
      return (
        <div className="space-y-1.5">
          {label}
          <Input
            value={(value as string) ?? ""}
            placeholder={"placeholder" in field ? field.placeholder : undefined}
            onChange={(e) => onChange(e.target.value)}
          />
        </div>
      );
    case "number":
      return (
        <div className="space-y-1.5">
          {label}
          <Input type="number" value={(value as number) ?? ""} onChange={(e) => onChange(e.target.value === "" ? "" : Number(e.target.value))} />
        </div>
      );
    case "textarea":
    case "markdown":
      return (
        <div className="space-y-1.5">
          {label}
          <Textarea
            className={field.type === "markdown" ? "min-h-[160px] font-mono text-sm" : "min-h-[80px]"}
            value={(value as string) ?? ""}
            onChange={(e) => onChange(e.target.value)}
          />
        </div>
      );
    case "boolean":
      return (
        <label className="flex items-center gap-2 text-sm text-foreground">
          <input type="checkbox" checked={Boolean(value)} onChange={(e) => onChange(e.target.checked)} />
          {field.label}
        </label>
      );
    case "select":
      return (
        <div className="space-y-1.5">
          {label}
          <select
            className="h-9 w-full rounded-md border border-border bg-background px-3 text-sm text-foreground"
            value={(value as string) ?? field.options[0]?.value}
            onChange={(e) => onChange(e.target.value)}
          >
            {field.options.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
          </select>
        </div>
      );
    case "link": {
      const v = (value as { label?: string; href?: string }) ?? {};
      return (
        <div className="space-y-1.5">
          {label}
          <div className="grid grid-cols-2 gap-2">
            <Input placeholder="Button label" value={v.label ?? ""} onChange={(e) => onChange({ ...v, label: e.target.value })} />
            <Input placeholder="/contact or https://…" value={v.href ?? ""} onChange={(e) => onChange({ ...v, href: e.target.value })} />
          </div>
        </div>
      );
    }
    case "list": {
      const items = Array.isArray(value) ? (value as Obj[]) : [];
      const update = (next: Obj[]) => onChange(next);
      const blank = () => Object.fromEntries(field.fields.map((sf) => [sf.key, sf.type === "link" ? {} : ""]));
      const move = (i: number, d: number) => {
        const j = i + d;
        if (j < 0 || j >= items.length) return;
        const next = items.slice();
        [next[i], next[j]] = [next[j], next[i]];
        update(next);
      };
      return (
        <div className="space-y-2 rounded-md border border-border p-3">
          <div className="flex items-center justify-between">
            {label}
            <Button type="button" size="sm" variant="outline" onClick={() => update([...items, blank()])}>
              <Plus className="h-3.5 w-3.5" /> Add
            </Button>
          </div>
          {items.map((item, i) => (
            <div key={i} className="rounded-md border border-border bg-muted/30 p-3">
              <div className="mb-2 flex items-center justify-between">
                <span className="text-xs font-medium text-muted-foreground">{field.itemLabel ?? "Item"} {i + 1}</span>
                <div className="flex gap-1">
                  <Button type="button" size="icon" variant="ghost" className="h-6 w-6" onClick={() => move(i, -1)}><ChevronUp className="h-3.5 w-3.5" /></Button>
                  <Button type="button" size="icon" variant="ghost" className="h-6 w-6" onClick={() => move(i, 1)}><ChevronDown className="h-3.5 w-3.5" /></Button>
                  <Button type="button" size="icon" variant="ghost" className="h-6 w-6 text-destructive" onClick={() => update(items.filter((_, k) => k !== i))}><Trash2 className="h-3.5 w-3.5" /></Button>
                </div>
              </div>
              <BlockFieldForm
                fields={field.fields}
                value={item}
                onChange={(next) => update(items.map((it, k) => (k === i ? next : it)))}
              />
            </div>
          ))}
          {items.length === 0 ? <p className="text-xs text-muted-foreground">No items yet.</p> : null}
        </div>
      );
    }
    default:
      return null;
  }
}
