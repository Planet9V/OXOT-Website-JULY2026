-- 041_conformity_fixes.sql
-- Conformity Platform conformity audit fixes. Four independent, idempotent
-- sections. Pure SQL, no __EMBED_DIM__ placeholder, no content deleted.
--
-- A) conformity_sources has no *_nl columns at all (021 gave every other
--    conformity_* table title_nl/description_nl/name_nl siblings; sources was
--    missed), so the ~25 source titles/descriptions shown on
--    /nl/conformity-platform/sources (src/lib/conformity.ts getSources(),
--    src/app/[locale]/conformity-platform/sources/page.tsx) always render
--    English — a bilingual-rule violation per CLAUDE.md §3. Adds title_nl and
--    description_nl (the only two user-facing prose columns getSources()
--    selects; filename/url/kind/regulation_key are not prose and are left
--    alone) and backfills professional Dutch translations for all 25 seeded
--    rows, keyed by the UNIQUE `title` column. Standards/institution names
--    (CRA, SBOM, IEC 62443, ENISA, EUCC, TIA-942, TR-42, Siemens SIMATIC S7,
--    the IR (EU) 2025/2392 citation, etc.) are left untranslated, matching the
--    convention in 024_conformity_nl.sql.
--    NOTE: getSources() in src/lib/conformity.ts does not yet apply the
--    COALESCE(NULLIF(x_nl,''), x) locale pattern used by the other conformity
--    getters — wiring that read is out of scope for this migration (src/ is
--    owned by a parallel change) but the columns/data are now in place for it.
--
-- B) conformity_meta.mapping_count was hardcoded to the literal 61, which
--    matches nothing real: conformity_mappings has 75 rows (15 themes x 5
--    regulations), 47 of which have requirement_count > 0, and
--    SUM(requirement_count) across all rows is 78 (= the total requirement
--    count, since every requirement belongs to exactly one theme x regulation
--    cell). Replaces the stored value with an aggregate computed from
--    conformity_mappings itself (COUNT(*) FILTER (WHERE requirement_count > 0)
--    = 47, i.e. "how many matrix cells actually have coverage" — the number
--    the coverage-matrix UI cares about) via UPDATE ... (SELECT ...), so
--    re-running this migration after future seed changes recomputes rather
--    than reintroducing a magic number.
--
-- C) conformity_* tables have zero indexes beyond what their UNIQUE
--    constraints already provide. Cross-referenced against every SQL query in
--    src/lib/conformity.ts (the only file in src/ that touches these tables):
--      - getRequirements() LEFT JOINs conformity_themes t ON t.key = r.theme_key
--        — conformity_requirements.theme_key has no supporting index at all,
--        so it gets one.
--      - getThemes() LEFT JOINs conformity_mappings m ON m.theme_key = t.key
--        — already covered by the leftmost column of the existing
--        UNIQUE(theme_key, regulation_key) index on conformity_mappings, so
--        skipped.
--      - conformity_requirements.regulation_key (used in getRequirements()'s
--        join to conformity_regulations) is already covered by the leftmost
--        column of the existing UNIQUE(regulation_key, ref_code) index, so
--        skipped.
--      - conformity_mappings.regulation_key has no supporting index (the
--        UNIQUE(theme_key, regulation_key) index does not help a
--        regulation_key-only lookup) — added, since the matrix/regulation
--        views group by regulation as well as theme.
--      - Slug/key lookups (conformity_regulations.key,
--        conformity_themes.key, conformity_sources.title) are already UNIQUE
--        NOT NULL from migration 021, which Postgres backs with a unique
--        btree index automatically — skipped, no duplicates to worry about.
--    Foreign keys: SKIPPED for all of regulation_key/theme_key on
--    conformity_requirements/conformity_mappings/conformity_sources/
--    conformity_timeline. The seed data in 021 is internally consistent (every
--    regulation_key/theme_key value used matches a row in
--    conformity_regulations/conformity_themes), and no write path exists in
--    src/ for these tables (grep confirms conformity_*.sql migrations are the
--    only writers), but this migration has no live database access to
--    positively confirm the *current* production tables have zero orphan rows
--    after 021/024/038 have already run there. Per the "do not risk a failing
--    migration" guidance, FKs are left out; the indexes above give the same
--    query-plan benefit without the risk of an ALTER TABLE ... ADD CONSTRAINT
--    failing on unverified live data.
--
-- D) Migration 038 removed the top-level "Conformity Platform" /
--    "Conformiteitsplatform" nav parent (and its "Overview"/"Regulations"
--    children) when the coverage-tool views (matrix/requirements/themes/
--    sources) were re-parented under Frameworks. That dropped the only nav
--    links to two still-live, unrelated views: the Overview dashboard
--    (/{locale}/conformity-platform) and Regulations
--    (/{locale}/conformity-platform/regulations) — orphaned but still
--    rendering, just unreachable from the menu. Re-adds them as children of
--    the existing Frameworks parent (same discovery pattern as 038:
--    href LIKE '%/frameworks' AND parent_id IS NULL), at positions 11/12
--    (038's four re-parented children occupy 7-10), idempotent via
--    WHERE NOT EXISTS on (locale, href, parent_id).
--
-- REVERSAL:
--   A) ALTER TABLE conformity_sources DROP COLUMN IF EXISTS title_nl, DROP
--      COLUMN IF EXISTS description_nl; (data loss on the Dutch translations
--      only — English rows untouched).
--   B) UPDATE conformity_meta SET value_int = 61 WHERE key = 'mapping_count';
--   C) DROP INDEX IF EXISTS idx_conformity_requirements_theme_key;
--      DROP INDEX IF EXISTS idx_conformity_mappings_regulation_key;
--   D) DELETE FROM menu_items WHERE href IN
--        ('/en/conformity-platform','/nl/conformity-platform')
--        AND parent_id IN (SELECT id FROM menu_items WHERE href LIKE '%/frameworks' AND parent_id IS NULL);

BEGIN;

-- ============================================================================
-- A) Dutch columns for conformity_sources + translated seed data
-- ============================================================================

ALTER TABLE conformity_sources ADD COLUMN IF NOT EXISTS title_nl text;
ALTER TABLE conformity_sources ADD COLUMN IF NOT EXISTS description_nl text;

UPDATE conformity_sources SET
  title_nl=$$CRA-verplichtingen — Product- en leveranciersmatrix$$,
  description_nl=$$Diepgaand onderzoek dat CRA-productcategorieën koppelt aan reële commerciële producten, leveranciers en herkomstlanden, met aantekeningen over klasse I/II/kritiek.$$
WHERE title=$$CRA Obligations — Product & Vendor Matrix$$;

UPDATE conformity_sources SET
  title_nl=$$CRA-verplichtingen (deel 2)$$,
  description_nl=$$Vervolg op het onderzoek naar CRA-verplichtingen en de productclassificatie-analyse.$$
WHERE title=$$CRA Obligations (Part 2)$$;

UPDATE conformity_sources SET
  title_nl=$$CRA-beveiligingsattestatie (sectie 7)$$,
  description_nl=$$Werknotities over CRA-beveiligingsattestatie en de verplichtingen uit sectie 7.$$
WHERE title=$$CRA Security Attestation (Section 7)$$;

UPDATE conformity_sources SET
  title_nl=$$CRA en SBOM — Onderzoek naar productstromen$$,
  description_nl=$$Onderzoek naar CRA-relevante productstromen naar en binnen de EU, SBOM-gereedheid en het knelpunt bij aangemelde instanties.$$
WHERE title=$$CRA & SBOM — Product Flows Research$$;

UPDATE conformity_sources SET
  title_nl=$$CRA hyperscale energiesysteem — P&ID-specificatie$$,
  description_nl=$$Uitgewerkt productvoorbeeld: een P&ID-specificatie voor een hyperscale energiesysteem, gebruikt om de CRA-scoping te illustreren.$$
WHERE title=$$CRA Hyperscale Power System — P&ID Spec$$;

UPDATE conformity_sources SET
  title_nl=$$CRA-koelgereedheid van leveranciers$$,
  description_nl=$$Beoordeling van de koelgereedheid van leveranciers, gebruikt als uitgewerkte referentie voor de CRA-toeleveringsketen en -gereedheid.$$
WHERE title=$$CRA Supplier Cooling Readiness$$;

UPDATE conformity_sources SET
  title_nl=$$PRD — CRA-conformiteitsapplicatie$$,
  description_nl=$$Productvereistendocument voor de CRA-conformiteitsapplicatie: scope, persona's en de kennis- en mappingengine voor regelgeving.$$
WHERE title=$$PRD — CRA Conformity Application$$;

UPDATE conformity_sources SET
  title_nl=$$AI Act — Onderzoek naar conformiteit over meerdere kaders$$,
  description_nl=$$Onderzoek naar het gezamenlijk bedienen van de AI Act naast CRA, de Machineverordening en IEC 62443: een gedeeld bewijsmodel, de keuze van het conformiteitstraject en de coördinatie met aangemelde instanties.$$
WHERE title=$$AI Act — Multi-Regulation Conformity Research$$;

UPDATE conformity_sources SET
  title_nl=$$IEC 62443 — Datacenterzones en -tiers$$,
  description_nl=$$IEC 62443-zones, conduits en het tiermodel toegepast op datacenteromgevingen.$$
WHERE title=$$IEC 62443 — Data Center Zones & Tiers$$;

UPDATE conformity_sources SET
  title_nl=$$IEC 62443 — Compliance-workshop$$,
  description_nl=$$Workshopmateriaal dat stapsgewijs door IEC 62443-compliance voor industriële automatiserings- en besturingssystemen leidt.$$
WHERE title=$$IEC 62443 — Compliance Workshop$$;

UPDATE conformity_sources SET
  title_nl=$$IEC 62443 — Diepgaand onderzoek$$,
  description_nl=$$Diepgaand onderzoek naar de IEC 62443-serie (4-1 beveiligde ontwikkellevenscyclus, 4-2 componentvereisten).$$
WHERE title=$$IEC 62443 — Deep Research$$;

UPDATE conformity_sources SET
  title_nl=$$PRD — Digital twin-rapport en funnel$$,
  description_nl=$$Vereisten voor het digital twin-conformiteitsrapport en het leadfunnelconcept.$$
WHERE title=$$PRD — Digital Twin Report & Funnel$$;

UPDATE conformity_sources SET
  title_nl=$$CRA — Veldgids$$,
  description_nl=$$Uitgebreide veldgids voor de Cyberweerbaarheidsverordening: scope, productklassen, verplichtingen, conformiteitstrajecten en termijnen.$$
WHERE title=$$CRA — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$IEC 62443 — Veldgids$$,
  description_nl=$$Veldgids voor de IEC 62443-serie: beveiligingsniveaus, zones en conduits, en de vereistenfamilies 4-1/4-2.$$
WHERE title=$$IEC 62443 — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$EU AI Act — Veldgids$$,
  description_nl=$$Veldgids voor de EU AI Act: risicoklassen, verplichtingen voor hoog risico, conformiteitsbeoordeling en de samenhang met productregelgeving.$$
WHERE title=$$EU AI Act — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$Machineverordening — Veldgids$$,
  description_nl=$$Veldgids voor de EU-machineverordening: essentiële gezondheids- en veiligheidseisen, conformiteitsprocedures en digitale documentatie.$$
WHERE title=$$Machinery Regulation — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$NIS2 — Veldgids$$,
  description_nl=$$Veldgids voor de NIS2-richtlijn: gedekte entiteiten, risicobeheersmaatregelen, incidentmelding en verantwoordingsplicht van het bestuur.$$
WHERE title=$$NIS2 — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$TS 50701 — Veldgids$$,
  description_nl=$$Veldgids voor CLC/TS 50701 voor spoorwegcyberbeveiliging: de toepassing van IEC 62443-concepten op het spoorwegdomein.$$
WHERE title=$$TS 50701 — Field Guide$$;

UPDATE conformity_sources SET
  title_nl=$$CRA CE-markeringstrajecten — Diepgaande referentie conformiteitsbeoordeling$$,
  description_nl=$$Diepgaande referentie over CRA-conformiteitsbeoordeling: de trajecten Module A / B+C / H en EUCC, betrokkenheid van de aangemelde instantie, het technisch dossier van bijlage VII, de conformiteitsverklaring van bijlage V en de capaciteitscrisis bij aangemelde instanties.$$
WHERE title=$$CRA CE Marking Pathways — Conformity Assessment Deep Reference$$;

UPDATE conformity_sources SET
  title_nl=$$CRA ↔ NIS2 klasseaanwijzing-koppeling$$,
  description_nl=$$Hoe de status van essentiële entiteit onder NIS2 de CRA-productclassificatie stuurt (IR (EU) 2025/2392): de trigger 'bedoeld voor gebruik door', klasse I versus klasse II, de meldingskoppeling via ENISA, en een uitgewerkt voorbeeld van Siemens SIMATIC S7.$$
WHERE title=$$CRA ↔ NIS2 Class-Designation Interlock$$;

UPDATE conformity_sources SET
  title_nl=$$CRA-klantreizen$$,
  description_nl=$$Toegangspunten, blootstelling en betrokkenheidsvolgordes voor OT-productleveranciers (OEM's), systeemintegrators en asset owners / operators van kritieke infrastructuur die CRA-conformiteit benaderen.$$
WHERE title=$$CRA Customer Journeys$$;

UPDATE conformity_sources SET
  title_nl=$$CRA-voorbereidingsdienst — Doorloop van Module A$$,
  description_nl=$$OXOT CRA-dienstendeck: een tweeledige CRA-gereedheids- en IEC 62443-baselinebeoordeling voor apparatuur en OEM-producten — van operationele IACS tot een verzendbare productbaseline die voldoet aan de 13 criteria en 8 processen van de CRA.$$
WHERE title=$$CRA Preparation Service — Module A Walkthrough$$;

UPDATE conformity_sources SET
  title_nl=$$Datacenter — TIA-942-raamwerk$$,
  description_nl=$$De TIA-942-infrastructuurstandaard voor datacenters: de vier veerkrachttiers, de revisiegeschiedenis 2005→2022, en de site-, stroom-, koel-, bekabelings-, brand- en fysieke-beveiligingselementen van compliance.$$
WHERE title=$$Data Center — TIA-942 Framework$$;

UPDATE conformity_sources SET
  title_nl=$$TIA-normenfamilie$$,
  description_nl=$$De TIA TR-42-hiërarchie van telecommunicatiebekabelingsnormen voor gebouwen, datacenters en industriële gebouwen — de 568-serie, 569, 942-C, 1005-A, 862-C en gerelateerde bulletins.$$
WHERE title=$$TIA Family of Standards$$;

UPDATE conformity_sources SET
  title_nl=$$Status van datacenterleveranciers ten opzichte van SL-3 en SL-4$$,
  description_nl=$$Onderzoek naar het certificeringslandschap: geen enkel datacenter-natief OT-product bezit IEC 62443-4-2 SL-3 (en SL-4 bestaat nergens), de vijf mondiale SL-3-componenten, de SL-2-grens, en een categoriegewijze gap-analyse.$$
WHERE title=$$Datacenter Supplier Status to SL-3 and SL-4$$;

-- ============================================================================
-- B) Recompute conformity_meta.mapping_count from conformity_mappings itself
--    (was the literal 61; now COUNT(*) FILTER (WHERE requirement_count > 0),
--    i.e. the number of theme x regulation cells with actual coverage — 47
--    against today's seed data, 75 total rows, SUM(requirement_count) = 78).
-- ============================================================================

UPDATE conformity_meta
   SET value_int = (
     SELECT COUNT(*) FILTER (WHERE requirement_count > 0)
       FROM conformity_mappings
   )
 WHERE key = 'mapping_count';

-- ============================================================================
-- C) Indexes supporting the real query patterns in src/lib/conformity.ts
-- ============================================================================

-- getRequirements() LEFT JOINs conformity_themes ON key = r.theme_key; no
-- existing index (UNIQUE(regulation_key, ref_code) doesn't help theme_key).
CREATE INDEX IF NOT EXISTS idx_conformity_requirements_theme_key
  ON conformity_requirements (theme_key);

-- Matrix/regulation-scoped reads over conformity_mappings by regulation_key
-- alone; the existing UNIQUE(theme_key, regulation_key) index only serves
-- theme_key-leading lookups.
CREATE INDEX IF NOT EXISTS idx_conformity_mappings_regulation_key
  ON conformity_mappings (regulation_key);

-- Skipped as redundant (already covered by an existing index):
--   conformity_mappings(theme_key)          -- leftmost of UNIQUE(theme_key, regulation_key)
--   conformity_requirements(regulation_key) -- leftmost of UNIQUE(regulation_key, ref_code)
--   conformity_regulations(key), conformity_themes(key), conformity_sources(title)
--     -- each already UNIQUE NOT NULL (021), Postgres auto-indexes those.

COMMIT;

-- ============================================================================
-- D) Restore nav reachability: re-add "Overview" and "Regulations" under the
--    Frameworks parent (both locales), orphaned by migration 038.
-- ============================================================================
-- NOTE: this block is tagged $mig041$, NOT the bare $$, because the Dutch
-- description below is itself dollar-quoted (it contains an apostrophe in
-- "thema's"). A bare $$ DO body would be terminated early by that inner $$,
-- which is exactly what failed the 2026-07-18 pre-deploy migrate step.
DO $mig041$
DECLARE
  m_id BIGINT;
  fw_en BIGINT;
  fw_nl BIGINT;
BEGIN
  SELECT id INTO m_id FROM menus WHERE key = 'main';
  IF m_id IS NULL THEN RETURN; END IF;

  SELECT id INTO fw_en FROM menu_items
    WHERE menu_id = m_id AND locale = 'en' AND href LIKE '%/frameworks' AND parent_id IS NULL
    ORDER BY position LIMIT 1;
  SELECT id INTO fw_nl FROM menu_items
    WHERE menu_id = m_id AND locale = 'nl' AND href LIKE '%/frameworks' AND parent_id IS NULL
    ORDER BY position LIMIT 1;

  IF fw_en IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'en', v.label, v.href, v.pos, fw_en, v.descr
    FROM (VALUES
      ('Conformity overview', '/en/conformity-platform',             11, 'Dashboard: regulations, requirements, themes and the implementation timeline.'),
      ('Regulations',         '/en/conformity-platform/regulations', 12, 'The five frameworks in scope, with official texts and requirement counts.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (
      SELECT 1 FROM menu_items x
       WHERE x.menu_id = m_id AND x.locale = 'en' AND x.href = v.href AND x.parent_id = fw_en
    );
  END IF;

  IF fw_nl IS NOT NULL THEN
    INSERT INTO menu_items (menu_id, locale, label, href, position, parent_id, description)
    SELECT m_id, 'nl', v.label, v.href, v.pos, fw_nl, v.descr
    FROM (VALUES
      ('Conformiteitsoverzicht', '/nl/conformity-platform',             11, $$Dashboard: regelgeving, vereisten, thema's en de implementatietijdlijn.$$),
      ('Regelgeving',            '/nl/conformity-platform/regulations', 12, 'De vijf kaders binnen scope, met officiële teksten en aantallen vereisten.')
    ) AS v(label, href, pos, descr)
    WHERE NOT EXISTS (
      SELECT 1 FROM menu_items x
       WHERE x.menu_id = m_id AND x.locale = 'nl' AND x.href = v.href AND x.parent_id = fw_nl
    );
  END IF;
END $mig041$;
