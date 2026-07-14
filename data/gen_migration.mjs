import fs from 'node:fs';
const d = JSON.parse(fs.readFileSync('data/conformity_source.json','utf8'));
const q = s => s===null||s===undefined ? 'NULL' : "'"+String(s).replace(/'/g,"''")+"'";
const arr = a => a && a.length ? "ARRAY[" + a.map(x=>q(x)).join(",") + "]::text[]" : "'{}'::text[]";
let out = `-- 021_conformity_platform.sql
-- Conformity Platform data layer: schema + idempotent seed from the OXOT
-- multi-regulation dataset (5 regulations, 78 requirements, 15 themes,
-- theme x regulation mappings, implementation timeline, source corpus).
-- Seeded via db:migrate (Railway pre-deploy runs migrations, not seed:*).
-- NL translation columns are added by a later migration.

CREATE TABLE IF NOT EXISTS conformity_regulations (
  id serial PRIMARY KEY,
  key text UNIQUE NOT NULL,
  name text NOT NULL,
  short_name text NOT NULL,
  full_title text NOT NULL,
  jurisdiction text,
  summary text,
  in_force_date date,
  source_url text,
  requirement_count int DEFAULT 0,
  sort_order int DEFAULT 0,
  name_nl text, short_name_nl text, full_title_nl text, summary_nl text,
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS conformity_themes (
  id serial PRIMARY KEY,
  key text UNIQUE NOT NULL,
  name text NOT NULL,
  description text,
  sort_order int DEFAULT 0,
  name_nl text, description_nl text
);

CREATE TABLE IF NOT EXISTS conformity_requirements (
  id serial PRIMARY KEY,
  regulation_key text NOT NULL,
  theme_key text,
  ref_code text NOT NULL,
  title text NOT NULL,
  description text,
  obligation_type text,
  applies_to text[] DEFAULT '{}',
  mapping_count int DEFAULT 0,
  sort_order int DEFAULT 0,
  title_nl text, description_nl text,
  UNIQUE (regulation_key, ref_code)
);

CREATE TABLE IF NOT EXISTS conformity_mappings (
  id serial PRIMARY KEY,
  theme_key text NOT NULL,
  regulation_key text NOT NULL,
  requirement_count int DEFAULT 0,
  requirement_refs text[] DEFAULT '{}',
  UNIQUE (theme_key, regulation_key)
);

CREATE TABLE IF NOT EXISTS conformity_timeline (
  id serial PRIMARY KEY,
  regulation_key text,
  event_date date NOT NULL,
  label text NOT NULL,
  label_nl text,
  sort_order int DEFAULT 0,
  UNIQUE (regulation_key, event_date, label)
);

CREATE TABLE IF NOT EXISTS conformity_sources (
  id serial PRIMARY KEY,
  title text NOT NULL UNIQUE,
  filename text,
  url text,
  kind text,
  description text,
  regulation_key text,
  sort_order int DEFAULT 0
);

CREATE TABLE IF NOT EXISTS conformity_meta (
  key text PRIMARY KEY,
  value_int int,
  value_text text
);

`;

// regulations
out += "-- Regulations\n";
for (const r of d.regulations) {
  out += `INSERT INTO conformity_regulations (key,name,short_name,full_title,jurisdiction,summary,in_force_date,source_url,requirement_count,sort_order) VALUES (`+
    [r.key,r.name,r.shortName,r.fullTitle,r.jurisdiction,r.summary,r.inForceDate,r.sourceUrl].map(q).join(",")+`,${r.requirementCount},${r.sortOrder}) `+
    `ON CONFLICT (key) DO UPDATE SET name=EXCLUDED.name,short_name=EXCLUDED.short_name,full_title=EXCLUDED.full_title,jurisdiction=EXCLUDED.jurisdiction,summary=EXCLUDED.summary,in_force_date=EXCLUDED.in_force_date,source_url=EXCLUDED.source_url,requirement_count=EXCLUDED.requirement_count,sort_order=EXCLUDED.sort_order,updated_at=now();\n`;
}

// themes (from mappings.themes which has definitions)
out += "\n-- Themes\n";
for (const t of d.mappings.themes) {
  out += `INSERT INTO conformity_themes (key,name,description,sort_order) VALUES (`+
    [t.key,t.name,t.description].map(q).join(",")+`,${t.sortOrder}) `+
    `ON CONFLICT (key) DO UPDATE SET name=EXCLUDED.name,description=EXCLUDED.description,sort_order=EXCLUDED.sort_order;\n`;
}

// requirements
out += "\n-- Requirements\n";
for (const r of d.requirements) {
  out += `INSERT INTO conformity_requirements (regulation_key,theme_key,ref_code,title,description,obligation_type,applies_to,mapping_count,sort_order) VALUES (`+
    [r.regulationKey,r.themeKey,r.refCode,r.title,r.description,r.obligationType].map(q).join(",")+`,${arr(r.appliesTo)},${r.mappingCount||0},${r.sortOrder||0}) `+
    `ON CONFLICT (regulation_key,ref_code) DO UPDATE SET theme_key=EXCLUDED.theme_key,title=EXCLUDED.title,description=EXCLUDED.description,obligation_type=EXCLUDED.obligation_type,applies_to=EXCLUDED.applies_to,mapping_count=EXCLUDED.mapping_count,sort_order=EXCLUDED.sort_order;\n`;
}

// mappings
out += "\n-- Theme x Regulation mappings (matrix cells)\n";
for (const c of d.mappings.cells) {
  out += `INSERT INTO conformity_mappings (theme_key,regulation_key,requirement_count,requirement_refs) VALUES (`+
    [c.themeKey,c.regulationKey].map(q).join(",")+`,${c.requirementCount||0},${arr(c.requirementRefs)}) `+
    `ON CONFLICT (theme_key,regulation_key) DO UPDATE SET requirement_count=EXCLUDED.requirement_count,requirement_refs=EXCLUDED.requirement_refs;\n`;
}

// timeline
out += "\n-- Implementation timeline\n";
let ti=0;
for (const k of d.summary.keyDates) {
  out += `INSERT INTO conformity_timeline (regulation_key,event_date,label,sort_order) VALUES (`+
    [k.regulationKey,k.date,k.label].map(q).join(",")+`,${ti++}) `+
    `ON CONFLICT (regulation_key,event_date,label) DO UPDATE SET sort_order=EXCLUDED.sort_order;\n`;
}

// sources
out += "\n-- Source corpus\n";
let si=0;
for (const s of d.sources) {
  out += `INSERT INTO conformity_sources (title,filename,url,kind,description,regulation_key,sort_order) VALUES (`+
    [s.title,s.filename,s.url,s.kind,s.description,s.regulationKey].map(q).join(",")+`,${si++}) `+
    `ON CONFLICT (title) DO UPDATE SET filename=EXCLUDED.filename,url=EXCLUDED.url,kind=EXCLUDED.kind,description=EXCLUDED.description,regulation_key=EXCLUDED.regulation_key,sort_order=EXCLUDED.sort_order;\n`;
}

// meta (KPI figures from source summary, verbatim)
out += "\n-- KPI figures (source summary, stored verbatim for the dashboard)\n";
const meta=[["regulation_count",d.summary.regulationCount],["requirement_count",d.summary.requirementCount],["theme_count",d.summary.themeCount],["mapping_count",d.summary.mappingCount]];
for (const [k,v] of meta) {
  out += `INSERT INTO conformity_meta (key,value_int) VALUES ('${k}',${v}) ON CONFLICT (key) DO UPDATE SET value_int=EXCLUDED.value_int;\n`;
}

fs.writeFileSync('db/migrations/021_conformity_platform.sql', out);
console.log("wrote db/migrations/021_conformity_platform.sql", out.length, "bytes");
console.log("regs",d.regulations.length,"themes",d.mappings.themes.length,"reqs",d.requirements.length,"cells",d.mappings.cells.length,"dates",d.summary.keyDates.length,"sources",d.sources.length);
