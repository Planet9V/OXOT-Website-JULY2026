import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { alternates } from "@/lib/seo";
import { getSources, type SourceDoc } from "@/lib/conformity";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Reveal, Stagger , StaggerItem} from "@/components/motion/fx";

export const dynamic = "force-dynamic";

// Kind grouping order → dictionary slug.
const KIND_ORDER = ["research", "reference", "field_guide", "prd", "example", "other"] as const;
type KindSlug = (typeof KIND_ORDER)[number];

const kindSlug = (kind: string | null): KindSlug => {
  const s = (kind ?? "").toLowerCase().replace(/\s+/g, "_");
  return (KIND_ORDER as readonly string[]).includes(s) ? (s as KindSlug) : "other";
};

export async function generateMetadata({
  params
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  if (!isLocale(locale)) return {};
  const t = getDictionary(locale).conformity;
  return {
    title: `${t.tabs.sources} — ${t.breadcrumb.platform} | OXOT`,
    description: t.sources.intro,
    alternates: alternates(locale, "/conformity-platform/sources")
  };
}

export default async function SourcesPage({
  params
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();
  const t = getDictionary(locale).conformity;
  const sources = await getSources();

  const groups = new Map<KindSlug, SourceDoc[]>();
  for (const s of sources) {
    const slug = kindSlug(s.kind);
    const list = groups.get(slug) ?? [];
    list.push(s);
    groups.set(slug, list);
  }

  return (
    <div className="space-y-8">
      <Reveal>
        <p className="text-sm text-muted-foreground">{t.sources.intro}</p>
      </Reveal>

      {KIND_ORDER.filter((slug) => groups.has(slug)).map((slug) => (
        <section key={slug}>
          <h2 className="mb-3 text-lg font-semibold tracking-tight text-foreground">
            {t.sources.kinds[slug]}
          </h2>
          <Stagger className="grid gap-4 md:grid-cols-2">
            {(groups.get(slug) ?? []).map((s) => (
              <StaggerItem key={s.title}>
                <Card className="flex h-full flex-col p-5">
                  <div className="flex items-start justify-between gap-3">
                    <h3 className="font-medium text-foreground">{s.title}</h3>
                    {s.regulationKey && (
                      <Badge variant="secondary" className="shrink-0">
                        {s.regulationKey}
                      </Badge>
                    )}
                  </div>
                  {s.description && (
                    <p className="mt-2 flex-1 text-sm leading-relaxed text-muted-foreground">
                      {s.description}
                    </p>
                  )}
                  {s.filename && (
                    <div className="mt-4">
                      <span className="inline-block rounded-md border border-border bg-muted px-2 py-1 font-mono text-xs text-muted-foreground">
                        {s.filename}
                      </span>
                    </div>
                  )}
                </Card>
              </StaggerItem>
            ))}
          </Stagger>
        </section>
      ))}
    </div>
  );
}
