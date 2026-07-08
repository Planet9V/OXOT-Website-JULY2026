-- Menu nesting for mega-menu dropdowns: a self-referencing parent + an optional
-- short description shown under each child link in the mega-menu panel.
ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS parent_id  BIGINT REFERENCES menu_items(id) ON DELETE CASCADE;
ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS description TEXT;
CREATE INDEX IF NOT EXISTS menu_items_parent_idx ON menu_items(parent_id);
