import type { Breadcrumb, ErrorEvent } from "@sentry/browser";

/**
 * Error reports to Sentry (ARCHITECTURE §12, §13; PHASES 9.5). Off unless the panel is built with
 * NEXT_PUBLIC_SENTRY_DSN. Errors only, nothing about the admin (no user, cookies, headers, query
 * strings or bodies), and every text is masked like the server's logs: phone numbers, tokens,
 * codes, 12-digit (Aadhaar) numbers.
 */
export const SENTRY_DSN = process.env.NEXT_PUBLIC_SENTRY_DSN ?? "";

const TOKEN = /eyJ[\w-]{4,}\.[\w-]{4,}\.[\w-]{4,}/g;
const BEARER = /bearer\s+[\w.~+/=-]{8,}/gi;
const CODE = /\b(otp|code|pin)(\W{0,3})\d{4,8}\b/gi;
const PHONE = /(?<![\w-])(?:\+?91[\s-]?|0)?[6-9]\d{4}[\s-]?\d{5}(?![\w-])/g;
const AADHAAR = /(?<![\d-])\d{4}[ -]?\d{4}[ -]?\d{4}(?![\d-])/g;

/** The same mask as the server's `common/redact.py`. */
export function redact(text: string): string {
  return (
    text
      .replace(TOKEN, "[token]")
      .replace(BEARER, "[token]")
      .replace(CODE, (_, word: string, gap: string) => `${word}${gap}[code]`)
      // phones first: "+91 98765 43210" is 12 digits too
      .replace(PHONE, (match) => `[phone …${match.replace(/\D/g, "").slice(-4)}]`)
      .replace(AADHAAR, "[number]")
  );
}

/** Every text inside, however deep (e.g. a console breadcrumb's `arguments`). */
function redactAll(value: unknown): unknown {
  if (typeof value === "string") return redact(value);
  if (Array.isArray(value)) return value.map(redactAll);
  if (value && typeof value === "object") {
    return Object.fromEntries(Object.entries(value).map(([k, v]) => [k, redactAll(v)]));
  }
  return value;
}

function redactValues(data: Record<string, unknown> | undefined): Record<string, unknown> | undefined {
  return data ? (redactAll(data) as Record<string, unknown>) : data;
}

export function scrubBreadcrumb(crumb: Breadcrumb): Breadcrumb {
  return {
    ...crumb,
    message: crumb.message ? redact(crumb.message) : crumb.message,
    data: redactValues(crumb.data),
  };
}

export function scrubEvent(event: ErrorEvent): ErrorEvent {
  const out: ErrorEvent = { ...event, user: undefined };
  if (out.request) out.request = { url: out.request.url?.split("?")[0] };
  if (typeof out.message === "string") out.message = redact(out.message);
  for (const exception of out.exception?.values ?? []) {
    if (exception.value) exception.value = redact(exception.value);
  }
  out.breadcrumbs = out.breadcrumbs?.map(scrubBreadcrumb);
  return out;
}
