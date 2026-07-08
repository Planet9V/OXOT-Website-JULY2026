import type { MetadataRoute } from "next";
import { SITE_NAME } from "@/lib/seo";

// Web app manifest — OXOT brand identity for installs / home-screen / PWA.
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: `${SITE_NAME} — OT Cybersecurity Consultancy`,
    short_name: SITE_NAME,
    description: "Operational Excellence in Operational Technology.",
    start_url: "/",
    display: "standalone",
    background_color: "#102030",
    theme_color: "#102030",
    icons: [
      { src: "/icon-192.png", sizes: "192x192", type: "image/png" },
      { src: "/icon-512.png", sizes: "512x512", type: "image/png" },
      { src: "/icon-512-maskable.png", sizes: "512x512", type: "image/png", purpose: "maskable" }
    ]
  };
}
