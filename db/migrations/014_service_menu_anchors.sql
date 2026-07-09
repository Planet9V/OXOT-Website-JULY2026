-- Point the Services dropdown items at their card anchors on /services so
-- selecting a different service navigates (scrolls) even when already on the page.
-- Anchor ids match slugify(card title) rendered by the cards block.
DO $$
DECLARE m_id BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key='main';
  IF m_id IS NULL THEN RETURN; END IF;

  -- English
  UPDATE menu_items SET href='/en/services#ot-security-assessments'  WHERE menu_id=m_id AND locale='en' AND label='OT Security Assessments';
  UPDATE menu_items SET href='/en/services#ot-security-programmes'   WHERE menu_id=m_id AND locale='en' AND label='OT Security Programmes';
  UPDATE menu_items SET href='/en/services#architecture-segmentation' WHERE menu_id=m_id AND locale='en' AND label='Architecture & Segmentation';
  UPDATE menu_items SET href='/en/services#secure-remote-access'     WHERE menu_id=m_id AND locale='en' AND label='Secure Remote Access';
  UPDATE menu_items SET href='/en/services#ot-security-baseline'     WHERE menu_id=m_id AND locale='en' AND label='OT Security Baseline';
  UPDATE menu_items SET href='/en/services#capability-transfer'      WHERE menu_id=m_id AND locale='en' AND label='Capability Transfer';

  -- Dutch (card titles slugify identically whether the apostrophe is straight or curly)
  UPDATE menu_items SET href='/nl/services#ot-securityassessments'   WHERE menu_id=m_id AND locale='nl' AND label='OT-securityassessments';
  UPDATE menu_items SET href='/nl/services#ot-securityprogrammas'    WHERE menu_id=m_id AND locale='nl' AND label='OT-securityprogramma’s';
  UPDATE menu_items SET href='/nl/services#architectuur-segmentatie' WHERE menu_id=m_id AND locale='nl' AND label='Architectuur & segmentatie';
  UPDATE menu_items SET href='/nl/services#veilige-externe-toegang'  WHERE menu_id=m_id AND locale='nl' AND label='Veilige externe toegang';
  UPDATE menu_items SET href='/nl/services#ot-securitybaseline'      WHERE menu_id=m_id AND locale='nl' AND label='OT-securitybaseline';
  UPDATE menu_items SET href='/nl/services#kennisoverdracht'         WHERE menu_id=m_id AND locale='nl' AND label='Kennisoverdracht';
END $$;
