-- Make the alternative home ("Secure industrial operations…", now at
-- /industrial-operations) reachable from the main nav. Idempotent: inserts the
-- top-level item only if its href isn't already present. Positioned just before
-- the About/Contact tail.
DO $$
DECLARE
  m_id BIGINT;
  pos_en INT;
  pos_nl INT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  SELECT COALESCE(MAX(position), 0) + 1 INTO pos_en
    FROM menu_items WHERE menu_id = m_id AND parent_id IS NULL AND locale = 'en';
  SELECT COALESCE(MAX(position), 0) + 1 INTO pos_nl
    FROM menu_items WHERE menu_id = m_id AND parent_id IS NULL AND locale = 'nl';

  INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
  SELECT m_id, 'en', 'Approach', '/en/industrial-operations', pos_en, NULL,
         'Our OT-security consulting: turning regulation into defensible security.'
  WHERE NOT EXISTS (
    SELECT 1 FROM menu_items x
     WHERE x.menu_id = m_id AND x.locale = 'en' AND x.href = '/en/industrial-operations' AND x.parent_id IS NULL);

  INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
  SELECT m_id, 'nl', 'Onze aanpak', '/nl/industrial-operations', pos_nl, NULL,
         'Ons OT-beveiligingsadvies: regelgeving omzetten in verdedigbare beveiliging.'
  WHERE NOT EXISTS (
    SELECT 1 FROM menu_items x
     WHERE x.menu_id = m_id AND x.locale = 'nl' AND x.href = '/nl/industrial-operations' AND x.parent_id IS NULL);
END $$;
