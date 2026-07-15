import crypto from "node:crypto";
import { pool } from "@/lib/db";
import { sendEmail, isMailConfigured } from "@/lib/mailer";

/**
 * Newsletter lib — ported from
 * Celestial-Agent-Nexus/artifacts/api-server/src/lib/newsletter.ts.
 *
 * The send pipeline (claim -> per-recipient idempotent newsletter_sends row ->
 * send -> derive counts from DB truth), the GDPR double opt-in helpers
 * (subscribe/confirm/unsubscribe), and the confirmation/unsubscribe email copy
 * are carried over. Plumbing is adapted to this app: raw pg (pool.query) instead
 * of Drizzle, a dependency-free md->html renderer instead of `marked`, and
 * absolute links built from a request-derived base URL. The AI draft generator
 * and open-tracking pixel from the source are out of scope here.
 */

// --- tokens / helpers ------------------------------------------------------

function newToken(): string {
  return crypto.randomBytes(24).toString("hex");
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
export function isValidEmail(email: string): boolean {
  return EMAIL_RE.test(email);
}

function trimSlash(value: string): string {
  return value.replace(/\/+$/, "");
}

function confirmUrl(baseUrl: string, token: string): string {
  return `${trimSlash(baseUrl)}/api/newsletter/confirm?token=${encodeURIComponent(token)}`;
}

function unsubscribeUrl(baseUrl: string, token: string): string {
  return `${trimSlash(baseUrl)}/api/newsletter/unsubscribe?token=${encodeURIComponent(token)}`;
}

// --- minimal Markdown -> HTML (email bodies) -------------------------------

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

/** Inline: **bold**, *italic*, `code`, [text](url). Input is already escaped. */
function renderInline(text: string): string {
  return text
    .replace(/\[([^\]]+)\]\((https?:[^\s)]+)\)/g, '<a href="$2">$1</a>')
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/(^|[^*])\*([^*]+)\*/g, "$1<em>$2</em>")
    .replace(/`([^`]+)`/g, "<code>$1</code>");
}

/**
 * Dependency-free Markdown renderer sufficient for newsletter bodies: ATX
 * headings (##..####), unordered/ordered lists, blockquotes, horizontal rules,
 * and paragraphs with inline bold/italic/code/links. Everything is HTML-escaped
 * before inline formatting is applied.
 */
export function renderMarkdown(md: string): string {
  const lines = md.replace(/\r\n/g, "\n").split("\n");
  const out: string[] = [];
  let listType: "ul" | "ol" | null = null;

  const closeList = () => {
    if (listType) {
      out.push(`</${listType}>`);
      listType = null;
    }
  };

  for (const raw of lines) {
    const line = raw.replace(/\s+$/, "");
    if (line.trim() === "") {
      closeList();
      continue;
    }
    const heading = /^(#{1,4})\s+(.*)$/.exec(line);
    if (heading) {
      closeList();
      const level = heading[1].length + 1; // ## -> h3-ish; keep >=2
      const h = Math.min(Math.max(level, 2), 5);
      out.push(`<h${h}>${renderInline(escapeHtml(heading[2].trim()))}</h${h}>`);
      continue;
    }
    if (/^(---|\*\*\*|___)\s*$/.test(line)) {
      closeList();
      out.push(`<hr>`);
      continue;
    }
    const ul = /^\s*[-*+]\s+(.*)$/.exec(line);
    if (ul) {
      if (listType !== "ul") {
        closeList();
        out.push("<ul>");
        listType = "ul";
      }
      out.push(`<li>${renderInline(escapeHtml(ul[1].trim()))}</li>`);
      continue;
    }
    const ol = /^\s*\d+\.\s+(.*)$/.exec(line);
    if (ol) {
      if (listType !== "ol") {
        closeList();
        out.push("<ol>");
        listType = "ol";
      }
      out.push(`<li>${renderInline(escapeHtml(ol[1].trim()))}</li>`);
      continue;
    }
    const quote = /^>\s?(.*)$/.exec(line);
    if (quote) {
      closeList();
      out.push(`<blockquote>${renderInline(escapeHtml(quote[1].trim()))}</blockquote>`);
      continue;
    }
    closeList();
    out.push(`<p>${renderInline(escapeHtml(line.trim()))}</p>`);
  }
  closeList();
  return out.join("\n");
}

// --- row types + DTO mappers -----------------------------------------------

interface NewsletterRow {
  id: number;
  subject: string;
  preheader: string | null;
  content_markdown: string;
  topic: string | null;
  locale: string;
  status: string;
  scheduled_at: Date | null;
  sent_at: Date | null;
  recipient_count: number;
  sent_count: number;
  failed_count: number;
  created_at: Date;
  updated_at: Date;
  opened_count?: number | string;
}

interface SubscriberRow {
  id: number;
  email: string;
  status: string;
  locale: string | null;
  source: string | null;
  confirmed_at: Date | null;
  unsubscribed_at: Date | null;
  created_at: Date;
}

function iso(value: Date | null): string | null {
  return value ? new Date(value).toISOString() : null;
}

function toNewsletterDto(r: NewsletterRow) {
  return {
    id: r.id,
    subject: r.subject,
    preheader: r.preheader ?? null,
    contentMarkdown: r.content_markdown,
    topic: r.topic ?? null,
    locale: r.locale,
    status: r.status,
    scheduledAt: iso(r.scheduled_at),
    sentAt: iso(r.sent_at),
    recipientCount: r.recipient_count,
    sentCount: r.sent_count,
    failedCount: r.failed_count,
    openedCount: Number(r.opened_count ?? 0),
    createdAt: new Date(r.created_at).toISOString(),
    updatedAt: new Date(r.updated_at).toISOString()
  };
}

function toSubscriberDto(r: SubscriberRow) {
  return {
    id: r.id,
    email: r.email,
    status: r.status,
    locale: r.locale ?? "en",
    source: r.source ?? null,
    confirmedAt: iso(r.confirmed_at),
    unsubscribedAt: iso(r.unsubscribed_at),
    createdAt: new Date(r.created_at).toISOString()
  };
}

export type NewsletterDto = ReturnType<typeof toNewsletterDto>;
export type SubscriberDto = ReturnType<typeof toSubscriberDto>;

// --- subscribers -----------------------------------------------------------

export async function listSubscribers(opts: { status?: string; q?: string } = {}): Promise<SubscriberDto[]> {
  const conditions: string[] = [];
  const params: unknown[] = [];
  if (opts.status) {
    params.push(opts.status);
    conditions.push(`status = $${params.length}`);
  }
  if (opts.q) {
    params.push(`%${opts.q}%`);
    conditions.push(`email ILIKE $${params.length}`);
  }
  const where = conditions.length ? `WHERE ${conditions.join(" AND ")}` : "";
  const { rows } = await pool.query<SubscriberRow>(
    `SELECT id, email, status, locale, source, confirmed_at, unsubscribed_at, created_at
       FROM newsletter_subscribers ${where}
      ORDER BY created_at DESC`,
    params
  );
  return rows.map(toSubscriberDto);
}

export async function deleteSubscriber(id: number): Promise<boolean> {
  const { rowCount } = await pool.query(`DELETE FROM newsletter_subscribers WHERE id = $1`, [id]);
  return (rowCount ?? 0) > 0;
}

export async function setSubscriberStatus(id: number, status: string): Promise<boolean> {
  const stamp = status === "unsubscribed" ? "unsubscribed_at = now()," : "";
  const { rowCount } = await pool.query(
    `UPDATE newsletter_subscribers SET status = $2, ${stamp} updated_at = now() WHERE id = $1`,
    [id, status]
  );
  return (rowCount ?? 0) > 0;
}

const CONFIRM_SUBJECT = "Please confirm your OXOT newsletter subscription";

function confirmEmailHtml(link: string): string {
  return `<!doctype html><html><body style="font-family:Arial,Helvetica,sans-serif;color:#1a1a1a;line-height:1.6">
  <h2 style="margin:0 0 12px">Confirm your subscription</h2>
  <p>Thanks for signing up for OXOT updates on the EU Cyber Resilience Act, AI Act, Machinery Regulation, NIS2 and more.</p>
  <p>Please confirm your email address to complete your subscription:</p>
  <p><a href="${link}" style="display:inline-block;background:#0b5;color:#fff;padding:12px 20px;border-radius:6px;text-decoration:none;font-weight:bold">Confirm subscription</a></p>
  <p style="color:#666;font-size:13px">If the button doesn't work, paste this link into your browser:<br>${link}</p>
  <p style="color:#999;font-size:12px">You received this because someone entered this address on our site. If it wasn't you, just ignore this email — no subscription is created without confirmation.</p>
  </body></html>`;
}

/**
 * Start (or restart) a double opt-in subscription. Always resolves without
 * revealing whether the address already existed, to avoid enumeration. Sends a
 * confirmation email for pending/new/re-subscribing addresses.
 */
export async function subscribe(input: {
  email: string;
  locale?: string | null;
  source?: string | null;
  baseUrl: string;
}): Promise<{ status: string }> {
  const email = normalizeEmail(input.email);
  const locale = input.locale === "nl" ? "nl" : "en";

  const { rows } = await pool.query<{ id: number; status: string; unsubscribe_token: string | null; source: string | null }>(
    `SELECT id, status, unsubscribe_token, source FROM newsletter_subscribers WHERE email = $1`,
    [email]
  );
  const existing = rows[0];

  if (existing && existing.status === "confirmed") {
    return { status: "confirmed" };
  }

  const confirmToken = newToken();
  if (!existing) {
    await pool.query(
      `INSERT INTO newsletter_subscribers (email, status, locale, source, confirm_token, unsubscribe_token)
       VALUES ($1, 'pending', $2, $3, $4, $5)`,
      [email, locale, input.source ?? null, confirmToken, newToken()]
    );
  } else {
    // pending or previously unsubscribed -> reset to pending with a fresh token.
    await pool.query(
      `UPDATE newsletter_subscribers
          SET status = 'pending',
              locale = $2,
              source = COALESCE($3, source),
              confirm_token = $4,
              unsubscribe_token = COALESCE(unsubscribe_token, $5),
              unsubscribed_at = NULL,
              updated_at = now()
        WHERE id = $1`,
      [existing.id, locale, input.source ?? null, confirmToken, newToken()]
    );
  }

  await sendEmail({
    to: email,
    subject: CONFIRM_SUBJECT,
    html: confirmEmailHtml(confirmUrl(input.baseUrl, confirmToken))
  });
  return { status: "pending" };
}

export async function confirmSubscription(token: string, ip?: string | null): Promise<boolean> {
  const { rows } = await pool.query<{ id: number; status: string }>(
    `SELECT id, status FROM newsletter_subscribers WHERE confirm_token = $1`,
    [token]
  );
  const row = rows[0];
  if (!row) return false;
  if (row.status === "confirmed") return true;
  await pool.query(
    `UPDATE newsletter_subscribers
        SET status = 'confirmed', confirmed_at = now(), consent_ip = $2, confirm_token = NULL, updated_at = now()
      WHERE id = $1`,
    [row.id, ip ?? null]
  );
  return true;
}

export async function unsubscribe(token: string): Promise<boolean> {
  const { rows } = await pool.query<{ id: number; status: string }>(
    `SELECT id, status FROM newsletter_subscribers WHERE unsubscribe_token = $1`,
    [token]
  );
  const row = rows[0];
  if (!row) return false;
  if (row.status !== "unsubscribed") {
    await pool.query(
      `UPDATE newsletter_subscribers SET status = 'unsubscribed', unsubscribed_at = now(), updated_at = now() WHERE id = $1`,
      [row.id]
    );
  }
  return true;
}

// --- newsletters (campaigns) -----------------------------------------------

const OPENED = `(SELECT count(*) FROM newsletter_sends ns WHERE ns.newsletter_id = n.id AND ns.opened_at IS NOT NULL)`;

export async function listNewsletters(): Promise<NewsletterDto[]> {
  const { rows } = await pool.query<NewsletterRow>(
    `SELECT n.*, ${OPENED} AS opened_count FROM newsletters n ORDER BY n.created_at DESC`
  );
  return rows.map(toNewsletterDto);
}

export async function getNewsletter(id: number): Promise<NewsletterDto | null> {
  const { rows } = await pool.query<NewsletterRow>(
    `SELECT n.*, ${OPENED} AS opened_count FROM newsletters n WHERE n.id = $1`,
    [id]
  );
  return rows[0] ? toNewsletterDto(rows[0]) : null;
}

export interface NewsletterInput {
  subject: string;
  preheader?: string | null;
  contentMarkdown: string;
  topic?: string | null;
  locale: string;
}

export async function createNewsletter(input: NewsletterInput): Promise<NewsletterDto> {
  const { rows } = await pool.query<NewsletterRow>(
    `INSERT INTO newsletters (subject, preheader, content_markdown, topic, locale, status)
     VALUES ($1, $2, $3, $4, $5, 'draft')
     RETURNING *, 0 AS opened_count`,
    [
      input.subject,
      input.preheader ?? null,
      input.contentMarkdown,
      input.topic ?? null,
      input.locale === "nl" ? "nl" : "en"
    ]
  );
  return toNewsletterDto(rows[0]);
}

/** Statuses in which a newsletter may still be edited/scheduled/sent/deleted. */
const EDITABLE = ["draft", "scheduled", "failed"];

export class NewsletterStateError extends Error {}

export async function updateNewsletter(id: number, input: NewsletterInput): Promise<NewsletterDto | null> {
  const existing = await getNewsletter(id);
  if (!existing) return null;
  const { rows } = await pool.query<NewsletterRow>(
    `UPDATE newsletters
        SET subject = $2, preheader = $3, content_markdown = $4, topic = $5, locale = $6, updated_at = now()
      WHERE id = $1 AND status = ANY($7::text[])
      RETURNING *, 0 AS opened_count`,
    [
      id,
      input.subject,
      input.preheader ?? null,
      input.contentMarkdown,
      input.topic ?? null,
      input.locale === "nl" ? "nl" : "en",
      EDITABLE
    ]
  );
  if (!rows[0]) {
    throw new NewsletterStateError("A newsletter that is sending or already sent cannot be edited.");
  }
  return toNewsletterDto(rows[0]);
}

export async function deleteNewsletter(id: number): Promise<boolean> {
  const { rowCount } = await pool.query(`DELETE FROM newsletters WHERE id = $1`, [id]);
  return (rowCount ?? 0) > 0;
}

export async function scheduleNewsletter(id: number, scheduledAt: Date): Promise<NewsletterDto | null> {
  const existing = await getNewsletter(id);
  if (!existing) return null;
  const { rows } = await pool.query<NewsletterRow>(
    `UPDATE newsletters SET status = 'scheduled', scheduled_at = $2, updated_at = now()
      WHERE id = $1 AND status = ANY($3::text[])
      RETURNING *, 0 AS opened_count`,
    [id, scheduledAt, EDITABLE]
  );
  if (!rows[0]) {
    throw new NewsletterStateError("Only draft newsletters can be scheduled.");
  }
  return toNewsletterDto(rows[0]);
}

// --- sending ---------------------------------------------------------------

function renderNewsletterHtml(opts: {
  contentHtml: string;
  preheader?: string | null;
  unsubscribeLink: string;
}): string {
  const preheader = opts.preheader
    ? `<div style="display:none;max-height:0;overflow:hidden;opacity:0">${escapeHtml(opts.preheader)}</div>`
    : "";
  return `<!doctype html><html><body style="margin:0;background:#f4f4f5;padding:24px 0">
  ${preheader}
  <div style="max-width:600px;margin:0 auto;background:#fff;border-radius:8px;padding:32px;font-family:Arial,Helvetica,sans-serif;color:#1a1a1a;line-height:1.6">
    ${opts.contentHtml}
    <hr style="border:none;border-top:1px solid #eee;margin:32px 0 16px">
    <p style="color:#999;font-size:12px;margin:0">
      You are receiving this because you confirmed a subscription to OXOT updates.
      <a href="${opts.unsubscribeLink}" style="color:#666">Unsubscribe</a>.
    </p>
  </div>
  </body></html>`;
}

/**
 * Send a newsletter to all confirmed subscribers matching its locale, then
 * return the finalised row. Atomically claims the campaign (status guard inside
 * the UPDATE) so a concurrent send cannot start a second run. Idempotent per
 * (newsletter, subscriber). Runs synchronously and returns the final result.
 */
export async function sendNewsletterNow(id: number, baseUrl: string): Promise<NewsletterDto | null> {
  const existing = await getNewsletter(id);
  if (!existing) return null;
  const { rows: claimedRows } = await pool.query<NewsletterRow>(
    `UPDATE newsletters SET status = 'sending', updated_at = now()
      WHERE id = $1 AND status = ANY($2::text[])
      RETURNING *`,
    [id, EDITABLE]
  );
  const claimed = claimedRows[0];
  if (!claimed) {
    throw new NewsletterStateError("This newsletter has already been sent or is sending.");
  }

  try {
    await processSend(claimed, baseUrl);
  } catch (err) {
    console.error("[newsletter] send failed:", err);
    await pool.query(`UPDATE newsletters SET status = 'failed', updated_at = now() WHERE id = $1`, [id]);
  }
  return getNewsletter(id);
}

async function processSend(newsletter: NewsletterRow, baseUrl: string): Promise<void> {
  const { rows: recipients } = await pool.query<{ id: number; email: string; unsubscribe_token: string | null }>(
    `SELECT id, email, unsubscribe_token FROM newsletter_subscribers
      WHERE status = 'confirmed' AND locale = $1`,
    [newsletter.locale]
  );

  const contentHtml = renderMarkdown(newsletter.content_markdown || "");

  for (const sub of recipients) {
    // Claim a per-recipient row. New recipients insert; previously FAILED rows
    // are re-claimed (retry); already-SENT rows fail the setWhere guard and
    // return nothing -> skipped (idempotent).
    const { rows: reservedRows } = await pool.query<{ id: number }>(
      `INSERT INTO newsletter_sends (newsletter_id, subscriber_id, status)
       VALUES ($1, $2, 'sent')
       ON CONFLICT (newsletter_id, subscriber_id)
       DO UPDATE SET status = 'sent', error = NULL, sent_at = now()
       WHERE newsletter_sends.status = 'failed'
       RETURNING id`,
      [newsletter.id, sub.id]
    );
    const reserved = reservedRows[0];
    if (!reserved) continue;

    const unsub = unsubscribeUrl(baseUrl, sub.unsubscribe_token ?? "");
    const html = renderNewsletterHtml({
      contentHtml,
      preheader: newsletter.preheader,
      unsubscribeLink: unsub
    });
    const result = await sendEmail({
      to: sub.email,
      subject: newsletter.subject,
      html,
      headers: { "List-Unsubscribe": `<${unsub}>` }
    });
    if (!result.delivered) {
      await pool.query(
        `UPDATE newsletter_sends SET status = 'failed', error = $2 WHERE id = $1`,
        [reserved.id, (result.error ?? "unknown").slice(0, 300)]
      );
    }
  }

  // Derive final counts from persisted per-recipient rows (DB truth).
  const { rows: countRows } = await pool.query<{ sent: string; failed: string }>(
    `SELECT
        count(*) FILTER (WHERE status = 'sent')   AS sent,
        count(*) FILTER (WHERE status = 'failed') AS failed
       FROM newsletter_sends WHERE newsletter_id = $1`,
    [newsletter.id]
  );
  const sent = Number(countRows[0]?.sent ?? 0);
  const failed = Number(countRows[0]?.failed ?? 0);
  const status = sent === 0 && failed > 0 ? "failed" : "sent";
  await pool.query(
    `UPDATE newsletters
        SET status = $2, sent_at = now(), recipient_count = $3, sent_count = $4, failed_count = $5, updated_at = now()
      WHERE id = $1`,
    [newsletter.id, status, recipients.length, sent, failed]
  );
}

// --- mail status -----------------------------------------------------------

export async function getMailStatus(): Promise<{ configured: boolean }> {
  return { configured: await isMailConfigured() };
}

// --- scheduled sends (cron) --------------------------------------------------

let scheduledSendsRunning = false;

/**
 * Find every newsletter with status='scheduled' AND scheduled_at <= now(), and
 * send each one via the same sendNewsletterNow() pipeline (which itself
 * atomically claims the row via the status guard, so this is safe to call
 * concurrently with a manual "Send now" click). Single-flight guarded in
 * process — a cron hit that arrives while a previous run is still sending is a
 * no-op rather than a second overlapping pass. Intended to be invoked by
 * GET/POST /api/cron on a schedule (e.g. Railway Cron every 5 minutes).
 */
export async function runDueScheduledSends(baseUrl: string): Promise<{ attempted: number; ids: number[] }> {
  if (scheduledSendsRunning) return { attempted: 0, ids: [] };
  scheduledSendsRunning = true;
  try {
    const { rows } = await pool.query<{ id: number }>(
      `SELECT id FROM newsletters WHERE status = 'scheduled' AND scheduled_at <= now() ORDER BY scheduled_at ASC`
    );
    const ids: number[] = [];
    for (const row of rows) {
      try {
        await sendNewsletterNow(row.id, baseUrl);
        ids.push(row.id);
      } catch (err) {
        // A single newsletter's state-guard/send failure must not stop the
        // rest of the due batch from being attempted.
        console.error(`[newsletter] scheduled send failed for id=${row.id}:`, err);
      }
    }
    return { attempted: rows.length, ids };
  } finally {
    scheduledSendsRunning = false;
  }
}
