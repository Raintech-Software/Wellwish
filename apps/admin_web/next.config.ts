import type { NextConfig } from "next";

/** Where the Django API runs. The panel forwards /v1/* there, so the browser only ever talks to
 * the panel's own origin and the staff refresh cookie stays first-party (ARCHITECTURE §6.4).
 * In production Nginx does the same forwarding. */
const API_PROXY_TARGET = process.env.API_PROXY_TARGET ?? "http://localhost:8000";

/** Sent with every response (ARCHITECTURE §12). The Content Security Policy, with its per-page
 * nonce, is set in src/proxy.ts. HSTS only for a production build (served over HTTPS). */
const SECURITY_HEADERS = [
  { key: "X-Frame-Options", value: "DENY" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  // only the origin leaves the site (OpenStreetMap's tile servers refuse requests without one)
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  // location: "Use my current location" on the hospital, service area and partner forms
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=(self), payment=(), usb=()" },
  { key: "Cross-Origin-Opener-Policy", value: "same-origin" },
  ...(process.env.NODE_ENV === "production"
    ? [{ key: "Strict-Transport-Security", value: "max-age=31536000; includeSubDomains" }]
    : []),
];

const nextConfig: NextConfig = {
  // The admin panel is a signed-in, client-heavy app (Ant Design), so Next 16's
  // Cache Components / Partial Prefetching prerendering is switched off.
  cacheComponents: false,
  poweredByHeader: false,
  reactStrictMode: true,
  async headers() {
    return [{ source: "/:path*", headers: SECURITY_HEADERS }];
  },
  async rewrites() {
    return [{ source: "/v1/:path*", destination: `${API_PROXY_TARGET}/v1/:path*` }];
  },
};

export default nextConfig;
