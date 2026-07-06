import type { Metadata } from "next";
import type { ReactNode } from "react";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { SITE_URL, SITE_NAME, DEFAULT_OG_IMAGE } from "@/lib/seo";

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

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html suppressHydrationWarning>
      <body>
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  );
}
