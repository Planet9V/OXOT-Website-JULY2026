/**
 * Minimal, dependency-free sanitizer for CMS-authored embedded HTML/SVG that is
 * injected via dangerouslySetInnerHTML. It is NOT a general-purpose sanitizer —
 * it strips the highest-risk vectors (inline scripts, event handlers, javascript:
 * URLs) from trusted-but-fallible admin content, while leaving markup (incl. svg,
 * iframe/video embeds) intact. Runs server-side in the markdown renderer.
 */
export function sanitizeEmbeddedHtml(html: string): string {
  return html
    // <script>…</script> and self-closing <script …/>
    .replace(/<script[\s\S]*?<\/script\s*>/gi, "")
    .replace(/<script\b[^>]*\/?>/gi, "")
    // inline event handlers: onclick=, onerror=, … (quoted or unquoted)
    .replace(/\son\w+\s*=\s*"[^"]*"/gi, "")
    .replace(/\son\w+\s*=\s*'[^']*'/gi, "")
    .replace(/\son\w+\s*=\s*[^\s>]+/gi, "")
    // javascript: URLs in href/src/xlink:href
    .replace(/(href|src|xlink:href)\s*=\s*"(?:\s*)javascript:[^"]*"/gi, '$1="#"')
    .replace(/(href|src|xlink:href)\s*=\s*'(?:\s*)javascript:[^']*'/gi, "$1='#'");
}
