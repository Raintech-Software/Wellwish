/**
 * The API's error format (ARCHITECTURE §10.3): {"error": {"code", "message", "details"}}.
 * Validation errors (422 VALIDATION_ERROR) list each bad field in details.errors[].loc.
 */
interface ErrorBody {
  error?: {
    code?: string;
    message?: string;
    details?: {
      errors?: { loc?: string[]; msg?: string }[];
      fields?: Record<string, string>;
      [key: string]: unknown;
    };
  };
}

const FALLBACK = "Something went wrong. Please try again.";

export function errorCode(err: unknown): string | undefined {
  return (err as ErrorBody | undefined)?.error?.code;
}

/** One line for a message toast. Validation errors name the first bad field. */
export function errorMessage(err: unknown, fallback = FALLBACK): string {
  const body = (err as ErrorBody | undefined)?.error;
  if (!body) return fallback;
  const first = body.details?.errors?.[0];
  if (body.code === "VALIDATION_ERROR" && first) {
    const field = first.loc?.[first.loc.length - 1];
    const msg = (first.msg ?? "").replace(/^Value error, /, "");
    // "body"/"data" = a rule about the whole form (e.g. fee above price), not one field
    const named = field && !["body", "data", "query", "path"].includes(field);
    return named ? `${field}: ${msg}` : msg || body.message || fallback;
  }
  return body.message || fallback;
}

/** A field error for `form.setFields` (the name comes from the server, so it isn't typed). */
export interface FieldError {
  name: never;
  errors: string[];
}

/** Field errors for an antd Form from either error shape. */
export function formErrors(err: unknown): FieldError[] {
  const details = (err as ErrorBody | undefined)?.error?.details;
  if (details?.fields) {
    return Object.entries(details.fields).map(([name, message]) => ({ name: name as never, errors: [message] }));
  }
  return (details?.errors ?? [])
    .filter((e) => e.loc && e.loc.length > 0)
    .map((e) => ({
      name: String(e.loc![e.loc!.length - 1]) as never,
      errors: [(e.msg ?? "").replace(/^Value error, /, "")],
    }));
}
