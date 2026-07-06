-- 005_menu_insights.sql — re-seed the main menu to include the Insights (blog) link. Idempotent.
INSERT INTO menus (key) VALUES ('main') ON CONFLICT (key) DO NOTHING;
DELETE FROM menu_items WHERE menu_id = (SELECT id FROM menus WHERE key = 'main');
INSERT INTO menu_items (menu_id, locale, label, href, position)
SELECT (SELECT id FROM menus WHERE key = 'main'), v.locale, v.label, v.href, v.position
FROM (VALUES
  ('en', 'Home',               '/en',                    0),
  ('en', 'Services',           '/en/services',           1),
  ('en', 'Cyber Digital Twin', '/en/cyber-digital-twin', 2),
  ('en', 'Frameworks',         '/en/frameworks',         3),
  ('en', 'Insights',           '/en/blog',               4),
  ('en', 'About',              '/en/about',              5),
  ('en', 'Contact',            '/en/contact',            6),
  ('nl', 'Home',               '/nl',                    0),
  ('nl', 'Diensten',           '/nl/services',           1),
  ('nl', 'Cyber Digital Twin', '/nl/cyber-digital-twin', 2),
  ('nl', 'Kaders',             '/nl/frameworks',         3),
  ('nl', 'Kennisbank',         '/nl/blog',               4),
  ('nl', 'Over ons',           '/nl/about',              5),
  ('nl', 'Contact',            '/nl/contact',            6)
) AS v(locale, label, href, position);
