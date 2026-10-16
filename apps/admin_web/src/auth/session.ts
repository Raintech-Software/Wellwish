import type { components } from "@/api/schema";
import { syncServerClock } from "@/lib/serverClock";

/**
 * Staff session in the browser (ARCHITECTURE §6.4):
 * - the access token (15 min) lives only in memory, never in localStorage;
 * - the refresh token is an httpOnly cookie the page can't read; POST /v1/admin/auth/refresh
 *   swaps it for a new access token (12 h from sign-in, signed out after 30 min idle);
 * - every API call goes through `authFetch`, which adds the token and refreshes once on 401.
 */
export type Staff = components["schemas"]["StaffMeOut"];
export type StaffTokens = components["schemas"]["StaffTokenOut"];

export type EndReason = "logout" | "expired" | "idle";

export interface SessionSnapshot {
  status: "unknown" | "signedOut" | "signedIn";
  staff: Staff | null;
  endReason: EndReason | null;
}

/** Sent on refresh and logout; a cross-site form can't add custom headers. */
export const CLIENT_HEADERS = { "X-WW-Client": "admin" };

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? "";

let accessToken: string | null = null;
let snapshot: SessionSnapshot = { status: "unknown", staff: null, endReason: null };
const listeners = new Set<() => void>();
let refreshing: Promise<boolean> | null = null;

function emit(next: SessionSnapshot) {
  snapshot = next;
  listeners.forEach((listener) => listener());
}

export function subscribe(listener: () => void): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export const getSnapshot = (): SessionSnapshot => snapshot;

/** For the live socket's first message (the token is never put in a URL). */
export const currentAccessToken = (): string | null => accessToken;

export function signedIn(tokens: StaffTokens) {
  accessToken = tokens.accessToken;
  emit({ status: "signedIn", staff: tokens.staff, endReason: null });
}

/** The signed-in staff member changed (e.g. new recovery codes): same session, new details. */
export function staffUpdated(staff: Staff) {
  if (snapshot.status === "signedIn") emit({ ...snapshot, staff });
}

export function signedOut(reason: EndReason | null) {
  accessToken = null;
  emit({ status: "signedOut", staff: null, endReason: reason });
}

async function readError(response: Response): Promise<string | undefined> {
  try {
    const body = (await response.clone().json()) as { error?: { code?: string } };
    return body.error?.code;
  } catch {
    return undefined;
  }
}

/** Tabs share one refresh cookie: run one refresh at a time across all tabs (Web Locks), so
 * a second tab never sends the cookie the first one just used. */
async function acrossTabs(task: () => Promise<boolean>): Promise<boolean> {
  const locks = typeof navigator !== "undefined" ? navigator.locks : undefined;
  if (!locks) return task();
  return await locks.request("ww-admin-refresh", task);
}

/** New access token from the refresh cookie. One refresh at a time. */
export function refresh(): Promise<boolean> {
  refreshing ??= acrossTabs(async () => {
    try {
      const response = await fetch(`${BASE}/v1/admin/auth/refresh`, {
        method: "POST",
        headers: CLIENT_HEADERS,
        credentials: "include",
      });
      if (response.ok) {
        signedIn((await response.json()) as StaffTokens);
        return true;
      }
      const code = await readError(response);
      signedOut(code === "SESSION_IDLE" ? "idle" : snapshot.status === "unknown" ? null : "expired");
      return false;
    } catch {
      // Network problem: keep what we have; the next call will try again.
      if (snapshot.status === "unknown") signedOut(null);
      return false;
    }
  }).finally(() => {
    refreshing = null;
  });
  return refreshing;
}

/** Other tabs of the panel hear about a sign-out through this localStorage key. */
export const SIGNED_OUT_KEY = "ww.admin.signedOut";

export async function logout(reason: EndReason = "logout"): Promise<void> {
  try {
    await fetch(`${BASE}/v1/admin/auth/logout`, {
      method: "POST",
      headers: CLIENT_HEADERS,
      credentials: "include",
    });
  } finally {
    signedOut(reason);
    try {
      localStorage.setItem(SIGNED_OUT_KEY, JSON.stringify({ reason, at: Date.now() }));
    } catch {
      // Storage blocked: the other tabs find out at their next API call.
    }
  }
}

// sign-in calls: a 401 here is a wrong password / code, never a reason to refresh (a refresh
// would sign out, or send a recovery code twice and count two wrong tries)
const PUBLIC_PATHS = [
  "/v1/admin/auth/login",
  "/v1/admin/auth/totp",
  "/v1/admin/auth/recovery",
  "/v1/admin/auth/email-code",
  "/v1/health",
];

/** `fetch` for the generated client: adds the access token, refreshes once on 401. */
export async function authFetch(request: Request): Promise<Response> {
  const isPublic = PUBLIC_PATHS.some((p) => new URL(request.url).pathname.endsWith(p));
  const retry = request.clone();
  const send = (req: Request) => {
    const headers = new Headers(req.headers);
    if (accessToken && !isPublic) headers.set("Authorization", `Bearer ${accessToken}`);
    return fetch(new Request(req, { headers, credentials: "include" })).then((response) => {
      syncServerClock(response.headers.get("date")); // countdowns follow the server's clock
      return response;
    });
  };
  const response = await send(request);
  if (response.status !== 401 || isPublic) return response;
  if (!(await refresh())) return response;
  return send(retry);
}
