"use client";
import * as React from "react";
import { useEditor, EditorContent, type Editor } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import Link from "@tiptap/extension-link";
import Placeholder from "@tiptap/extension-placeholder";
import Table from "@tiptap/extension-table";
import TableRow from "@tiptap/extension-table-row";
import TableHeader from "@tiptap/extension-table-header";
import TableCell from "@tiptap/extension-table-cell";
import { Markdown } from "tiptap-markdown";
import {
  Bold, Italic, Strikethrough, Code, Code2, Heading1, Heading2, Heading3,
  List, ListOrdered, Quote, Minus, Link2, Table as TableIcon, Undo2, Redo2
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

function Tb({ icon: Icon, label, active, disabled, onClick }: {
  icon: React.ElementType; label: string; active?: boolean; disabled?: boolean; onClick: () => void;
}) {
  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <Button type="button" variant="ghost" size="icon"
          className={cn("h-8 w-8", active && "bg-accent text-accent-foreground")}
          disabled={disabled} onClick={onClick} aria-label={label}>
          <Icon className="h-4 w-4" />
        </Button>
      </TooltipTrigger>
      <TooltipContent>{label}</TooltipContent>
    </Tooltip>
  );
}

function Toolbar({ editor }: { editor: Editor }) {
  const [, force] = React.useReducer((x) => x + 1, 0);
  React.useEffect(() => {
    editor.on("transaction", force);
    return () => { editor.off("transaction", force); };
  }, [editor]);

  const addLink = () => {
    const prev = editor.getAttributes("link").href as string | undefined;
    const url = window.prompt("Link URL (leave empty to remove)", prev ?? "https://");
    if (url === null) return;
    if (url === "") editor.chain().focus().extendMarkRange("link").unsetLink().run();
    else editor.chain().focus().extendMarkRange("link").setLink({ href: url }).run();
  };

  return (
    <TooltipProvider delayDuration={300}>
      <div className="flex flex-wrap items-center gap-0.5 border-b border-border bg-muted/40 p-1.5">
        <Tb icon={Undo2} label="Undo" disabled={!editor.can().undo()} onClick={() => editor.chain().focus().undo().run()} />
        <Tb icon={Redo2} label="Redo" disabled={!editor.can().redo()} onClick={() => editor.chain().focus().redo().run()} />
        <Separator orientation="vertical" className="mx-1 h-6" />
        <Tb icon={Heading1} label="Heading 1" active={editor.isActive("heading", { level: 1 })} onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()} />
        <Tb icon={Heading2} label="Heading 2" active={editor.isActive("heading", { level: 2 })} onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} />
        <Tb icon={Heading3} label="Heading 3" active={editor.isActive("heading", { level: 3 })} onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} />
        <Separator orientation="vertical" className="mx-1 h-6" />
        <Tb icon={Bold} label="Bold" active={editor.isActive("bold")} onClick={() => editor.chain().focus().toggleBold().run()} />
        <Tb icon={Italic} label="Italic" active={editor.isActive("italic")} onClick={() => editor.chain().focus().toggleItalic().run()} />
        <Tb icon={Strikethrough} label="Strikethrough" active={editor.isActive("strike")} onClick={() => editor.chain().focus().toggleStrike().run()} />
        <Tb icon={Code} label="Inline code" active={editor.isActive("code")} onClick={() => editor.chain().focus().toggleCode().run()} />
        <Tb icon={Link2} label="Link" active={editor.isActive("link")} onClick={addLink} />
        <Separator orientation="vertical" className="mx-1 h-6" />
        <Tb icon={List} label="Bullet list" active={editor.isActive("bulletList")} onClick={() => editor.chain().focus().toggleBulletList().run()} />
        <Tb icon={ListOrdered} label="Numbered list" active={editor.isActive("orderedList")} onClick={() => editor.chain().focus().toggleOrderedList().run()} />
        <Tb icon={Quote} label="Quote / callout" active={editor.isActive("blockquote")} onClick={() => editor.chain().focus().toggleBlockquote().run()} />
        <Tb icon={Code2} label="Code block (svg / carousel / html)" active={editor.isActive("codeBlock")} onClick={() => editor.chain().focus().toggleCodeBlock().run()} />
        <Tb icon={TableIcon} label="Insert table" onClick={() => editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run()} />
        <Tb icon={Minus} label="Divider" onClick={() => editor.chain().focus().setHorizontalRule().run()} />
      </div>
    </TooltipProvider>
  );
}

export function RichEditor({
  value,
  onChange,
  placeholder = "Write the page content…"
}: {
  value: string;
  onChange: (markdown: string) => void;
  placeholder?: string;
}) {
  const editor = useEditor({
    immediatelyRender: false, // required for Next.js SSR
    extensions: [
      StarterKit,
      Link.configure({ openOnClick: false, autolink: true }),
      Placeholder.configure({ placeholder }),
      Table.configure({ resizable: false }),
      TableRow,
      TableHeader,
      TableCell,
      Markdown.configure({
        html: true,
        tightLists: true,
        bulletListMarker: "-",
        transformPastedText: true,
        transformCopiedText: true
      })
    ],
    content: value || "",
    editorProps: {
      attributes: { class: "oxot-editor min-h-[320px] px-4 py-3 focus:outline-none" }
    },
    onUpdate: ({ editor }) => onChange(editor.storage.markdown.getMarkdown())
  });

  if (!editor) {
    return <div className="min-h-[380px] rounded-lg border border-border bg-muted/20 animate-pulse" />;
  }

  return (
    <div className="overflow-hidden rounded-lg border border-border bg-background">
      <Toolbar editor={editor} />
      <EditorContent editor={editor} />
    </div>
  );
}
