import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { SITE_URL, SITE_NAME, DEFAULT_OG_IMAGE, organizationJsonLd, websiteJsonLd, jsonLdScript } from "@/lib/seo";
import { getPublicSocials } from "@/lib/socials";

const DESCRIPTION =
  "OXOT is an operational-technology (OT) cybersecurity consultancy. We turn IEC 62443, NIS2, the EU Cyber Resilience Act, the AI Act and the Machinery Regulation into defensible security for industrial and critical-infrastructure systems.";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: `${SITE_NAME} — OT Cybersecurity Consultancy`, template: `%s | ${SITE_NAME}` },
  description: DESCRIPTION,
  applicationName: SITE_NAME,
  openGraph: {
    type: "website",
    siteName: SITE_NAME,
    title: `${SITE_NAME} — OT Cybersecurity Consultancy`,
    description: DESCRIPTION,
    images: [{ url: DEFAULT_OG_IMAGE, width: 1200, height: 630, alt: SITE_NAME }]
  },
  twitter: {
    card: "summary_large_image",
    title: `${SITE_NAME} — OT Cybersecurity Consultancy`,
    description: DESCRIPTION,
    images: [DEFAULT_OG_IMAGE]
  },
  robots: { index: true, follow: true }
};

// Browser UI / address-bar tint — OXOT navy in dark, paper in light.
export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#faf9f5" },
    { media: "(prefers-color-scheme: dark)", color: "#102030" }
  ]
};

export default async function RootLayout({ children }: { children: ReactNode }) {
  const socials = await getPublicSocials();
  const orgJsonLd = organizationJsonLd({ sameAs: socials.map((s) => s.url) });
  const siteJsonLd = websiteJsonLd();
  return (
    <html suppressHydrationWarning>
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        {/* Editorial type: Newsreader (serif), Instrument Sans (UI), IBM Plex Mono (labels) */}
        <link
          href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;700&family=Instrument+Sans:wght@400;500;600&family=Newsreader:opsz,wght@6..72,300;6..72,400;6..72,500&display=swap"
          rel="stylesheet"
        />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdScript(orgJsonLd) }} />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdScript(siteJsonLd) }} />
      </head>
      <body>
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  );
}
