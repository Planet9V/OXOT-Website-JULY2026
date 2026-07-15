// Single source of truth for OXOT's social profiles — used by the footer's "Connect"
// column and the "Follow Along" social feed so the handles never drift apart.
// TODO: confirm the real OXOT LinkedIn/X handles.
export const SOCIALS = [
  { platform: "LinkedIn", label: "LinkedIn", url: "https://www.linkedin.com/company/oxot" },
  { platform: "X", label: "X", url: "https://x.com/oxot" }
] as const;
