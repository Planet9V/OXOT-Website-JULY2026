#!/usr/bin/env node
// Fails if nl and en dictionaries don't have identical key sets. Enforces "both locales, always".
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const load = (l) =>
  JSON.parse(readFileSync(join(root, `src/i18n/dictionaries/${l}.json`), "utf8"));

const flatten = (obj, prefix = "") =>
  Object.entries(obj).flatMap(([k, v]) =>
    v && typeof v === "object" ? flatten(v, `${prefix}${k}.`) : [`${prefix}${k}`]
  );

const en = new Set(flatten(load("en")));
const nl = new Set(flatten(load("nl")));
const missingInNl = [...en].filter((k) => !nl.has(k));
const missingInEn = [...nl].filter((k) => !en.has(k));

if (missingInNl.length || missingInEn.length) {
  if (missingInNl.length) console.error("Missing in nl:", missingInNl);
  if (missingInEn.length) console.error("Missing in en:", missingInEn);
  process.exit(1);
}
console.log(`i18n OK — ${en.size} keys present in both nl and en.`);
