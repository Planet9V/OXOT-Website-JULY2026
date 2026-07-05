-- Admin users (small team) + CMS: pages and menus, stored per locale.
CREATE TABLE IF NOT EXISTS admin_users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,        -- scrypt: salt:hash (hex)
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- One row per (slug, locale). Both nl + en must exist to publish (enforced in app).
CREATE TABLE IF NOT EXISTS pages (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug        TEXT NOT NULL,
  locale      TEXT NOT NULL CHECK (locale IN ('nl','en')),
  title       TEXT NOT NULL,
  body        TEXT NOT NULL DEFAULT '',
  published   BOOLEAN NOT NULL DEFAULT false,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (slug, locale)
);

CREATE TABLE IF NOT EXISTS menus (
  id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  key  TEXT NOT NULL UNIQUE           -- e.g. 'main', 'footer'
);

CREATE TABLE IF NOT EXISTS menu_items (
  id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  menu_id   BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  locale    TEXT NOT NULL CHECK (locale IN ('nl','en')),
  label     TEXT NOT NULL,
  href      TEXT NOT NULL,
  position  INT NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS menu_items_menu_idx ON menu_items (menu_id, locale, position);
