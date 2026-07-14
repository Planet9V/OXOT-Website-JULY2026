-- 025_newsletter_subscribers.sql
-- Footer newsletter signups. Records intent only; double opt-in delivery is a later phase.
-- Idempotent: CREATE TABLE IF NOT EXISTS, unique(email) so re-subscribes are a no-op.

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id serial primary key,
  email text not null,
  locale text,
  status text not null default 'pending',
  source text,
  token text,
  created_at timestamptz default now(),
  confirmed_at timestamptz,
  unique(email)
);
