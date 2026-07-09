-- Repoint the Services dropdown items from /services#anchor to their own pages,
-- now that each service has a dedicated page in both locales.
DO $$
DECLARE m_id BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key='main';
  IF m_id IS NULL THEN RETURN; END IF;

  UPDATE menu_items SET href='/en/ot-security-assessments'  WHERE menu_id=m_id AND locale='en' AND label='OT Security Assessments';
  UPDATE menu_items SET href='/en/ot-security-programmes'   WHERE menu_id=m_id AND locale='en' AND label='OT Security Programmes';
  UPDATE menu_items SET href='/en/architecture-segmentation' WHERE menu_id=m_id AND locale='en' AND label='Architecture & Segmentation';
  UPDATE menu_items SET href='/en/secure-remote-access'     WHERE menu_id=m_id AND locale='en' AND label='Secure Remote Access';
  UPDATE menu_items SET href='/en/ot-security-baseline'     WHERE menu_id=m_id AND locale='en' AND label='OT Security Baseline';
  UPDATE menu_items SET href='/en/capability-transfer'      WHERE menu_id=m_id AND locale='en' AND label='Capability Transfer';

  UPDATE menu_items SET href='/nl/ot-security-assessments'  WHERE menu_id=m_id AND locale='nl' AND label='OT-securityassessments';
  UPDATE menu_items SET href='/nl/ot-security-programmes'   WHERE menu_id=m_id AND locale='nl' AND label='OT-securityprogramma’s';
  UPDATE menu_items SET href='/nl/architecture-segmentation' WHERE menu_id=m_id AND locale='nl' AND label='Architectuur & segmentatie';
  UPDATE menu_items SET href='/nl/secure-remote-access'     WHERE menu_id=m_id AND locale='nl' AND label='Veilige externe toegang';
  UPDATE menu_items SET href='/nl/ot-security-baseline'     WHERE menu_id=m_id AND locale='nl' AND label='OT-securitybaseline';
  UPDATE menu_items SET href='/nl/capability-transfer'      WHERE menu_id=m_id AND locale='nl' AND label='Kennisoverdracht';
END $$;
