import { getLinkedInConfig, getXConfig } from "@/lib/integration-settings";

// Public social links for the footer's "Connect" column and the "Follow Along"
// social feed. Admin-managed via the Integrations settings — no hardcoded
// handles. Only platforms the admin has actually configured are returned.
export interface SocialLink {
  platform: string;
  label: string;
  url: string;
}

/** Never throws — callers (server components) can await this without a try/catch. */
export async function getPublicSocials(): Promise<SocialLink[]> {
  try {
    const [linkedin, x] = await Promise.all([getLinkedInConfig(), getXConfig()]);
    const links: SocialLink[] = [];
    if (linkedin.profileUrl.trim()) {
      links.push({ platform: "LinkedIn", label: "LinkedIn", url: linkedin.profileUrl.trim() });
    }
    if (x.username.trim()) {
      const handle = x.username.trim().replace(/^@/, "");
      links.push({ platform: "X", label: "X", url: `https://x.com/${handle}` });
    }
    return links;
  } catch {
    return [];
  }
}
