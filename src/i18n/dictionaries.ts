import type { Locale } from "./config";
import en from "./dictionaries/en.json";
import nl from "./dictionaries/nl.json";

const dictionaries = { en, nl } as const;
export type Dictionary = typeof en;

export function getDictionary(locale: Locale): Dictionary {
  return dictionaries[locale];
}
