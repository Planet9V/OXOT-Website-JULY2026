-- 030_newsletter_social.sql
-- Newsletter campaigns + per-recipient sends + social post outcome log, plus the
-- double opt-in columns the richer subscribe flow needs. Ported from the source
-- Drizzle schema (newsletters, newsletterSends, socialPosts, newsletterSubscribers).
-- Idempotent: CREATE TABLE IF NOT EXISTS + ALTER ... ADD COLUMN IF NOT EXISTS.

-- Newsletter campaigns. Authored as Markdown, rendered to HTML at send time.
-- Lifecycle: draft -> (scheduled) -> sending -> sent | failed.
CREATE TABLE IF NOT EXISTS newsletters (
  id serial primary key,
  subject text not null,
  preheader text,
  content_markdown text not null default '',
  topic text,
  locale text not null default 'en',
  status text not null default 'draft',
  scheduled_at timestamptz,
  sent_at timestamptz,
  recipient_count int not null default 0,
  sent_count int not null default 0,
  failed_count int not null default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Per-recipient delivery record. Unique(newsletter, subscriber) makes a send
-- idempotent — a retried send never double-delivers to the same subscriber.
CREATE TABLE IF NOT EXISTS newsletter_sends (
  id serial primary key,
  newsletter_id int not null references newsletters(id) on delete cascade,
  subscriber_id int not null references newsletter_subscribers(id) on delete cascade,
  status text default 'sent',
  error text,
  opened_at timestamptz,
  sent_at timestamptz default now(),
  unique (newsletter_id, subscriber_id)
);

-- Outcome log for a single social post attempt (LinkedIn or X).
CREATE TABLE IF NOT EXISTS social_posts (
  id serial primary key,
  platform text,
  success boolean not null,
  error text,
  text text not null default '',
  source text not null default 'manual',
  created_at timestamptz default now()
);

-- Richer double opt-in columns on the existing newsletter_subscribers table.
ALTER TABLE newsletter_subscribers ADD COLUMN IF NOT EXISTS confirm_token text;
ALTER TABLE newsletter_subscribers ADD COLUMN IF NOT EXISTS unsubscribe_token text;
ALTER TABLE newsletter_subscribers ADD COLUMN IF NOT EXISTS consent_ip text;
ALTER TABLE newsletter_subscribers ADD COLUMN IF NOT EXISTS unsubscribed_at timestamptz;
ALTER TABLE newsletter_subscribers ADD COLUMN IF NOT EXISTS updated_at timestamptz default now();

-- Backfill an unguessable unsubscribe token for any pre-existing rows.
UPDATE newsletter_subscribers
   SET unsubscribe_token = md5(random()::text || clock_timestamp()::text || id::text)
 WHERE unsubscribe_token IS NULL;

-- Lookups by token during confirm / unsubscribe.
CREATE INDEX IF NOT EXISTS newsletter_subscribers_confirm_token_idx ON newsletter_subscribers (confirm_token);
CREATE INDEX IF NOT EXISTS newsletter_subscribers_unsub_token_idx ON newsletter_subscribers (unsubscribe_token);
