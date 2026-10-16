import { NextRequest, NextResponse } from "next/server";

/**
 * Content Security Policy for every page of the panel (ARCHITECTURE §12, PHASES 9.3).
 *
 * A fresh nonce per page view: only the panel's own scripts run, so injected text can never
 * run as script. Pages are rendered per request for this (the root layout waits for the
 * request). Styles stay inline-allowed (Ant Design writes its CSS at runtime).
 * - images: the panel, OpenStreetMap tiles (Live map) and the private S3 view links
 * - frames (PDF preview): the panel and S3; no site may frame the panel itself
 * - connections: the panel's origin (API through /v1, staff socket through /ws), S3 (uploads go
 *   straight to the bucket with a presigned POST); in local dev the socket goes straight to
 *   Django on :8000
 */
const FILES = "https://*.s3.amazonaws.com https://*.s3.ap-south-1.amazonaws.com";

function originOf(url: string | undefined): string {
  try {
    return url ? new URL(url).origin : "";
  } catch {
    return "";
  }
}

export function contentSecurityPolicy(nonce: string, isDev: boolean): string {
  const connect = [
    "'self'",
    originOf(process.env.NEXT_PUBLIC_API_BASE_URL),
    originOf(process.env.NEXT_PUBLIC_WS_BASE_URL),
    originOf(process.env.NEXT_PUBLIC_SENTRY_DSN), // error reports (PHASES 9.5), when set
    FILES, // uploads POST straight to S3 (FileUpload, PhotoUpload)
    isDev ? "ws: http://localhost:8000" : "",
  ];
  return [
    "default-src 'self'",
    `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'${isDev ? " 'unsafe-eval'" : ""}`,
    "style-src 'self' 'unsafe-inline'",
    `img-src 'self' blob: data: https://tile.openstreetmap.org ${FILES}`,
    "font-src 'self'",
    `connect-src ${connect.filter(Boolean).join(" ")}`,
    `frame-src 'self' blob: ${FILES}`,
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
  ].join("; ");
}

export function proxy(request: NextRequest) {
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");
  const csp = contentSecurityPolicy(nonce, process.env.NODE_ENV === "development");
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce);
  requestHeaders.set("Content-Security-Policy", csp);
  const response = NextResponse.next({ request: { headers: requestHeaders } });
  response.headers.set("Content-Security-Policy", csp);
  return response;
}

export const config = {
  matcher: [
    // pages only: not the API forwarded to Django, static files or link prefetches
    {
      source: "/((?!v1/|ws/|_next/static|_next/image|favicon.ico|.*\\.png$).*)",
      missing: [
        { type: "header", key: "next-router-prefetch" },
        { type: "header", key: "purpose", value: "prefetch" },
      ],
    },
  ],
};
