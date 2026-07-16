import type { Segment } from "@/lib/segments";

/**
 * CRA intake funnel email copy (EN transcribed verbatim from
 * "CRA Email + Intake Copy EN.dc.html"; NL authored in the same voice as
 * "CRA Retainer Slick NL.dc.html"). Email 0 fires instantly on submission;
 * Emails 1-5 are the per-segment follow-ups sent (personally, or via
 * auto-send if enabled) within 2 business days.
 */

export interface IntakeEmail {
  subject: string;
  preview: string;
  html: string;
  text: string;
}

/** segment -> which of Emails 1-5 it maps to (for reference/labeling). */
export const SEGMENT_EMAIL: Record<Segment, number> = {
  manufacturer: 1,
  oem: 2,
  integrator: 3,
  reseller: 4,
  operator: 5
};

const BRAND_NAVY = "#14233B";
const BRAND_ORANGE = "#FF7900";
const BRAND_MUTED = "#5A6473";

function stripHtml(html: string): string {
  return html
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, "")
    .replace(/<br\s*\/?>/gi, "\n")
    .replace(/<\/p>/gi, "\n\n")
    .replace(/<[^>]+>/g, "")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

/** Simple inline-styled email shell shared by every intake email. */
function shell(bodyHtml: string): string {
  return `<!doctype html><html><body style="margin:0;background:#E9ECF1;padding:24px 0;font-family:Arial,Helvetica,sans-serif">
  <div style="max-width:600px;margin:0 auto;background:#fff;border-radius:8px;padding:32px;color:#3C4757;line-height:1.6">
    ${bodyHtml}
    <hr style="border:none;border-top:1px solid #eee;margin:28px 0 16px">
    <p style="color:${BRAND_MUTED};font-size:12px;margin:0">OXOT · Operational Excellence in Operational Technology &middot; <a href="mailto:vincent@oxot.nl" style="color:${BRAND_MUTED}">vincent@oxot.nl</a> &middot; <a href="https://oxot.nl" style="color:${BRAND_MUTED}">oxot.nl</a></p>
  </div>
  </body></html>`;
}

function cta(label: string): string {
  return `<div style="background:${BRAND_ORANGE};color:${BRAND_NAVY};font-weight:bold;text-align:center;padding:11px;font-size:13px;margin:16px 0">${label}</div>`;
}

function firstName(name: string): string {
  return name.trim().split(/\s+/)[0] || name;
}

function formatDate(date: Date, locale: string): string {
  return date.toLocaleDateString(locale === "nl" ? "nl-NL" : "en-GB", {
    year: "numeric",
    month: "long",
    day: "numeric"
  });
}

// --- Email 0: instant auto-confirmation, all segments -----------------------

export function email0(locale: string, opts: { firstName: string; date: Date | string }): IntakeEmail {
  const fn = firstName(opts.firstName);
  const date = typeof opts.date === "string" ? opts.date : formatDate(opts.date, locale);

  if (locale === "nl") {
    const html = shell(`
      <p style="margin:0 0 10px">${fn},</p>
      <p style="margin:0 0 10px">Dank u — uw aanvraag is binnen, met tijdstempel ${date}.</p>
      <p style="margin:0 0 10px"><strong style="color:${BRAND_NAVY}">Wat er nu gebeurt:</strong> Vincent van OXOT neemt binnen 2 werkdagen persoonlijk contact met u op om uw gratis intake van 45 minuten in te plannen. Zijn bericht bevat een kort voorbereidingsformulier, zodat die 45 minuten optimaal worden benut.</p>
      <p style="margin:0 0 10px">U verlaat dat gesprek met uw waarschijnlijke productclassificatie, uw route naar de CE-markering, en een inschatting van de benodigde inspanning.</p>
      <p style="margin:0">De deadline staat vast: <strong style="color:${BRAND_NAVY}">11 december 2027</strong>. De wachtrij niet.</p>
    `);
    return {
      subject: "U staat in de wachtrij — volgende stap binnen 2 werkdagen",
      preview: "Uw intake van 45 minuten, en wat u kunt voorbereiden.",
      html,
      text: stripHtml(html)
    };
  }

  const html = shell(`
    <p style="margin:0 0 10px">${fn},</p>
    <p style="margin:0 0 10px">Thank you — your request is in, timestamped ${date}.</p>
    <p style="margin:0 0 10px"><strong style="color:${BRAND_NAVY}">What happens next:</strong> Vincent van OXOT will contact you personally within 2 business days to schedule your free 45-minute intake. His note will include a short preparation sheet so the 45 minutes count.</p>
    <p style="margin:0 0 10px">You'll leave that call with your likely product classification, your road to the CE mark, and a level-of-effort estimate.</p>
    <p style="margin:0">The deadline is fixed: <strong style="color:${BRAND_NAVY}">11 December 2027</strong>. The queue is not.</p>
  `);
  return {
    subject: "You're in the queue — next step within 2 business days",
    preview: "Your 45-minute CRA intake, and what to have ready.",
    html,
    text: stripHtml(html)
  };
}

// --- Emails 1-5: per-segment follow-up ---------------------------------------

interface SegmentCopy {
  subjectEn: string;
  previewEn: string;
  bodyEn: string;
  subjectNl: string;
  previewNl: string;
  bodyNl: string;
}

const SEGMENT_COPY: Record<Segment, SegmentCopy> = {
  manufacturer: {
    subjectEn: "Which of your product lines can still be sold in the EU after Dec 2027?",
    previewEn: "Class I self-assessment is closed until ~Q2 2027. Your road map, attached.",
    bodyEn: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Vincent here, from OXOT. You told us you manufacture products — so before we speak, one fact that changes most manufacturers' plans: there are no harmonised CRA standards cited yet, which means Class I self-assessment is closed until roughly Q2 2027, and every third-party route runs through a Conformity Body queue that hasn't opened its doors.</p>
      <p style="margin:0 0 10px">Attached is a 2-pager built for your seat: the pain points we hear from product-security and compliance leads, what we deliver against each — and on the back, the pathway map: three roads to the CE mark, with the wrong turns marked.</p>
      <p style="margin:0 0 10px"><strong style="color:${BRAND_NAVY}">The 45 minutes:</strong> we'll classify your headline products live, pick the likely road, and size the effort. You keep all three answers whether or not we work together.</p>
      <p style="margin:0 0 12px">Also attached: a one-page preparation sheet — 10 minutes to fill in, it doubles the value of the call.</p>
      ${cta("PICK A SLOT FOR THE 45-MINUTE INTAKE →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `,
    subjectNl: "Welke van uw productlijnen mag na december 2027 nog in de EU worden verkocht?",
    previewNl: "Klasse I-zelfbeoordeling is gesloten tot ~Q2 2027. Uw routekaart, bijgevoegd.",
    bodyNl: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Dit is Vincent, van OXOT. U gaf aan dat u producten fabriceert — dus vóór we spreken, één feit dat de plannen van de meeste fabrikanten verandert: er zijn nog geen geharmoniseerde CRA-normen gepubliceerd, wat betekent dat Klasse I-zelfbeoordeling gesloten blijft tot ongeveer Q2 2027, en elke route via een derde partij loopt via een wachtrij bij een Conformiteitsinstantie die nog niet is geopend.</p>
      <p style="margin:0 0 10px">Bijgevoegd vindt u een 2-pager op maat van uw rol: de knelpunten die we horen van product-security- en compliance-verantwoordelijken, wat wij daartegenover leveren — en op de achterzijde de routekaart: drie wegen naar de CE-markering, met de verkeerde afslagen aangegeven.</p>
      <p style="margin:0 0 10px"><strong style="color:${BRAND_NAVY}">De 45 minuten:</strong> we classificeren live uw belangrijkste producten, kiezen de waarschijnlijke route en schatten de inspanning in. U behoudt alle drie de antwoorden, of we nu samenwerken of niet.</p>
      <p style="margin:0 0 12px">Ook bijgevoegd: een voorbereidingsformulier van één pagina — 10 minuten invullen verdubbelt de waarde van het gesprek.</p>
      ${cta("PLAN EEN SLOT VOOR DE INTAKE VAN 45 MINUTEN →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `
  },
  oem: {
    subjectEn: "{company}'s portfolio vs. 16–24 weeks per product — the maths",
    previewEn: "One QMS audit can replace a hundred examinations. If it starts now.",
    bodyEn: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">A 100-product portfolio at 16–24 weeks per type-examination does not fit between now and 11 December 2027 — that's arithmetic, not opinion. The way out is sequencing: batch shared platforms, route product groups down <strong style="color:${BRAND_NAVY}">Module H</strong> (one audited QMS, new products added in 4–8 weeks), and reserve Conformity Body capacity before demand peaks.</p>
      <p style="margin:0 0 10px">Module H takes 8–14 months to build. The window to start is this quarter — after that, the option quietly expires.</p>
      <p style="margin:0 0 10px">Attached: a 2-pager for the multi-product seat — including the white-label trap (anything under your brand makes you its manufacturer) — and the pathway map on the back.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">The 45 minutes:</strong> a first B+C-vs-Module-H read on your portfolio and the board-ready exposure number you're being asked for.</p>
      ${cta("PICK A SLOT FOR THE 45-MINUTE INTAKE →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `,
    subjectNl: "{company}'s portfolio vs. 16–24 weken per product — de rekensom",
    previewNl: "Eén QMS-audit kan honderd examinaties vervangen. Als het nu start.",
    bodyNl: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Een portfolio van 100 producten aan 16–24 weken per typeonderzoek past niet meer tussen nu en 11 december 2027 — dat is rekenkunde, geen mening. De uitweg is volgorde: bundel gedeelde platforms, route productgroepen via <strong style="color:${BRAND_NAVY}">Module H</strong> (één geauditeerd kwaliteitssysteem, nieuwe producten toegevoegd in 4–8 weken), en reserveer capaciteit bij een Conformiteitsinstantie vóór de vraag piekt.</p>
      <p style="margin:0 0 10px">Module H bouwen duurt 8–14 maanden. Het venster om te starten is dit kwartaal — daarna vervalt de optie stilletjes.</p>
      <p style="margin:0 0 10px">Bijgevoegd: een 2-pager voor de multi-productrol — inclusief de white-label-valkuil (alles onder uw merk maakt u de fabrikant ervan) — en de routekaart op de achterzijde.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">De 45 minuten:</strong> een eerste inschatting van B+C versus Module H voor uw portfolio, en het board-klare blootstellingscijfer waar u om wordt gevraagd.</p>
      ${cta("PLAN EEN SLOT VOOR DE INTAKE VAN 45 MINUTEN →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `
  },
  integrator: {
    subjectEn: "Did your last project customisation make you a manufacturer?",
    previewEn: "Art. 22, the 62443-2-4 tender wave, and where your boundary sits.",
    bodyEn: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Two things are hitting integrators at once: IEC 62443-2-4 clauses are already live in tenders, and under the CRA a <strong style="color:${BRAND_NAVY}">substantial modification</strong> — custom firmware, changed security properties — makes you the manufacturer of the product you modified (Article 22). Configuration is fine. Custom builds are not. Most integrators can't say today which side of that line their projects sit on.</p>
      <p style="margin:0 0 10px">Attached: a 2-pager for your seat — the modification boundary, the bid-qualifier shift, what evidence your flagship system needs before the next major bid — plus the pathway map.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">The 45 minutes:</strong> a first read of your Art. 22 boundary and what your next tender will demand.</p>
      ${cta("PICK A SLOT FOR THE 45-MINUTE INTAKE →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `,
    subjectNl: "Maakte uw laatste projectaanpassing u tot fabrikant?",
    previewNl: "Art. 22, de 62443-2-4-aanbestedingsgolf, en waar uw grens ligt.",
    bodyNl: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Twee dingen raken integrators tegelijk: IEC 62443-2-4-clausules staan al in aanbestedingen, en onder de CRA maakt een <strong style="color:${BRAND_NAVY}">substantiële wijziging</strong> — aangepaste firmware, gewijzigde beveiligingseigenschappen — u de fabrikant van het product dat u heeft aangepast (Artikel 22). Configuratie is prima. Maatwerk niet. De meeste integrators kunnen vandaag niet zeggen aan welke kant van die grens hun projecten vallen.</p>
      <p style="margin:0 0 10px">Bijgevoegd: een 2-pager voor uw rol — de wijzigingsgrens, de verschuiving in aanbestedingscriteria, welk bewijs uw vlaggenschipsysteem nodig heeft vóór de volgende grote aanbesteding — plus de routekaart.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">De 45 minuten:</strong> een eerste beoordeling van uw Art. 22-grens en wat uw volgende aanbesteding zal eisen.</p>
      ${cta("PLAN EEN SLOT VOOR DE INTAKE VAN 45 MINUTEN →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `
  },
  reseller: {
    subjectEn: "After Dec 2027, which of your SKUs are legal to sell?",
    previewEn: "And which own-brand lines quietly made you a manufacturer.",
    bodyEn: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">From 11 December 2027 you may only make CRA-conforming products available — and you carry the duty to verify the CE mark and Declaration of Conformity on every one. Your exposure is the sum of your suppliers' readiness, and 2026 is the year to test them, while you can still switch.</p>
      <p style="margin:0 0 10px">Sharper still: any line you rebrand or substantially modify makes you its <strong style="color:${BRAND_NAVY}">manufacturer under Article 21</strong> — full technical file, PSIRT, penalties and all.</p>
      <p style="margin:0 0 10px">Attached: a 2-pager for the distribution seat — the line-card review, the rebrand-exposure register, supplier evidence gates — plus the pathway map.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">The 45 minutes:</strong> your Art. 21 exposure read and a first cut of your line-card risk.</p>
      ${cta("PICK A SLOT FOR THE 45-MINUTE INTAKE →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `,
    subjectNl: "Welke van uw SKU's mag u na december 2027 nog legaal verkopen?",
    previewNl: "En welke eigen-merklijnen maakten u stilletjes tot fabrikant.",
    bodyNl: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">Vanaf 11 december 2027 mag u alleen nog CRA-conforme producten op de markt brengen — en draagt u de plicht om de CE-markering en de conformiteitsverklaring van elk product te verifiëren. Uw blootstelling is de optelsom van de gereedheid van uw leveranciers, en 2026 is het jaar om hen te toetsen, terwijl u nog kunt wisselen.</p>
      <p style="margin:0 0 10px">Scherper nog: elke lijn die u herbrandt of substantieel wijzigt, maakt u tot <strong style="color:${BRAND_NAVY}">fabrikant onder Artikel 21</strong> — volledig technisch dossier, PSIRT, en boetes incluis.</p>
      <p style="margin:0 0 10px">Bijgevoegd: een 2-pager voor de distributierol — de assortimentsreview, het herbrand-blootstellingsregister, leveranciersbewijs-poorten — plus de routekaart.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">De 45 minuten:</strong> uw Art. 21-blootstelling in kaart en een eerste inschatting van uw assortimentsrisico.</p>
      ${cta("PLAN EEN SLOT VOOR DE INTAKE VAN 45 MINUTEN →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `
  },
  operator: {
    subjectEn: "Which of your OT suppliers will actually clear the CRA?",
    previewEn: "The board number, the insurer question, and the supplier scan.",
    bodyEn: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">NIS2 already asks your estate for state-of-the-art; from December 2027 the CRA raises the bar on every product entering it. The practical question isn't your compliance — it's your <strong style="color:${BRAND_NAVY}">suppliers'</strong>: who clears, who fails, who to press or replace, and what CRA language belongs in the next tender cycle.</p>
      <p style="margin:0 0 10px">Attached: a 2-pager for the procurement &amp; legal seat — the green/amber/red supplier scan, contract clauses that hold up, evidence fit for the board, the regulator and the insurer — plus the pathway map your suppliers are (or aren't) following.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">The 45 minutes:</strong> a first read of your supplier exposure and the board number you're being asked for.</p>
      ${cta("PICK A SLOT FOR THE 45-MINUTE INTAKE →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `,
    subjectNl: "Welke van uw OT-leveranciers doorstaan de CRA daadwerkelijk?",
    previewNl: "Het bestuurscijfer, de vraag van de verzekeraar, en de leveranciersscan.",
    bodyNl: `
      <p style="margin:0 0 10px">{fn},</p>
      <p style="margin:0 0 10px">NIS2 vraagt uw omgeving nu al om state-of-the-art beveiliging; vanaf december 2027 legt de CRA de lat hoger voor elk product dat binnenkomt. De praktische vraag is niet uw eigen conformiteit — het is die van uw <strong style="color:${BRAND_NAVY}">leveranciers</strong>: wie slaagt, wie niet, wie u moet aansporen of vervangen, en welke CRA-taal in de volgende aanbestedingsronde thuishoort.</p>
      <p style="margin:0 0 10px">Bijgevoegd: een 2-pager voor de inkoop- en juridische rol — de groen/oranje/rood-leveranciersscan, contractclausules die standhouden, bewijs geschikt voor het bestuur, de toezichthouder en de verzekeraar — plus de routekaart die uw leveranciers wel (of niet) volgen.</p>
      <p style="margin:0 0 12px"><strong style="color:${BRAND_NAVY}">De 45 minuten:</strong> een eerste beoordeling van uw leveranciersblootstelling en het bestuurscijfer waar u om wordt gevraagd.</p>
      ${cta("PLAN EEN SLOT VOOR DE INTAKE VAN 45 MINUTEN →")}
      <p style="margin:0">— Vincent · vincent@oxot.nl · oxot.nl</p>
    `
  }
};

export function segmentEmail(
  segment: Segment,
  locale: string,
  opts: { firstName: string; company?: string | null }
): IntakeEmail {
  const fn = firstName(opts.firstName);
  const company = (opts.company ?? "").trim() || (locale === "nl" ? "uw organisatie" : "your organisation");
  const copy = SEGMENT_COPY[segment];
  const isNl = locale === "nl";

  const subjectTemplate = isNl ? copy.subjectNl : copy.subjectEn;
  const previewTemplate = isNl ? copy.previewNl : copy.previewEn;
  const bodyTemplate = isNl ? copy.bodyNl : copy.bodyEn;

  const fill = (s: string) => s.replace(/\{fn\}/g, fn).replace(/\{company\}/g, company);

  const html = shell(fill(bodyTemplate));
  return {
    subject: fill(subjectTemplate),
    preview: fill(previewTemplate),
    html,
    text: stripHtml(html)
  };
}
