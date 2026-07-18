#!/usr/bin/env node
/**
 * Static check for db/migrations/*.sql — catches the class of bug that failed the
 * 2026-07-18 pre-deploy migrate step.
 *
 * `next build` never parses SQL and `tsc` never sees it, so a malformed migration
 * sails through CI and only explodes in Railway's preDeployCommand — after a green
 * build, which makes it look like a build failure. This runs in milliseconds.
 *
 * Checks:
 *  1. Dollar-quote balance, lexed the way Postgres lexes it: outside a dollar
 *     string `$tag$` opens, and ONLY the identical `$tag$` closes it. Single-quoted
 *     strings (with '' escapes) and -- comments are skipped so their contents
 *     don't produce phantom tags.
 *  2. `DO $$ … END $$` bodies that are terminated early by an inner bare `$$`
 *     literal. This is the actual 041 bug: a Dutch description containing an
 *     apostrophe was written as $$thema's$$ inside a $$-tagged DO body, so the
 *     inner $$ closed the block and the rest became a syntax error. Fix by
 *     tagging the block ($mig041$ … END $mig041$), not by rewriting the literal.
 */
import fs from "node:fs";
import path from "node:path";

const DIR = path.join(process.cwd(), "db", "migrations");
const TAG = /^\$([A-Za-z_][A-Za-z0-9_]*)?\$/;

/** @returns {string[]} unclosed-tag problems */
function lex(sql) {
  let i = 0, line = 1, open = null, openAt = 0;
  const issues = [];
  while (i < sql.length) {
    const c = sql[i];
    if (c === "\n") { line++; i++; continue; }
    if (!open && c === "-" && sql[i + 1] === "-") {
      while (i < sql.length && sql[i] !== "\n") i++;
      continue;
    }
    if (!open && c === "'") {
      i++;
      while (i < sql.length) {
        if (sql[i] === "\n") line++;
        if (sql[i] === "'") { if (sql[i + 1] === "'") { i += 2; continue; } i++; break; }
        i++;
      }
      continue;
    }
    if (c === "$") {
      const m = TAG.exec(sql.slice(i));
      if (m) {
        const tag = m[0];
        if (!open) { open = tag; openAt = line; i += tag.length; continue; }
        if (open === tag) { open = null; i += tag.length; continue; }
        i += tag.length; continue; // a different tag inside a body is literal text
      }
    }
    i++;
  }
  if (open) issues.push(`unclosed dollar quote ${open} opened at line ${openAt}`);
  return issues;
}

/** @returns {string[]} DO-body problems */
function checkDoBlocks(sql) {
  const issues = [];
  const re = /\bDO\s+\$\$([\s\S]*?)\$\$/g;
  let m;
  while ((m = re.exec(sql))) {
    // A well-formed `DO $$ … END $$` body ends with END. If it doesn't, the
    // closing $$ we matched was an inner literal, not the real terminator.
    if (!/\bEND\s*$/.test(m[1].trimEnd())) {
      const line = sql.slice(0, m.index).split("\n").length;
      issues.push(
        `DO $$ block at line ${line} is terminated early by an inner $$ literal — ` +
          `tag the block instead (DO $mig$ … END $mig$)`
      );
    }
  }
  return issues;
}

let failed = 0;
const files = fs.readdirSync(DIR).filter((f) => f.endsWith(".sql")).sort();
for (const f of files) {
  const sql = fs.readFileSync(path.join(DIR, f), "utf8");
  const issues = [...lex(sql), ...checkDoBlocks(sql)];
  if (issues.length) {
    failed++;
    console.error(`✗ ${f}`);
    for (const i of issues) console.error(`    ${i}`);
  }
}

if (failed) {
  console.error(`\n${failed} of ${files.length} migration(s) failed the SQL check.`);
  process.exit(1);
}
console.log(`✓ ${files.length} migrations: dollar-quoting balanced, no DO block terminated early.`);
