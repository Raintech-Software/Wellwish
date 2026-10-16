"use client";

import { createContext, useCallback, useContext, useEffect, useSyncExternalStore, type ReactNode } from "react";

import { api } from "@/api/client";
import {
  getSnapshot,
  logout,
  refresh,
  SIGNED_OUT_KEY,
  signedOut,
  subscribe,
  type EndReason,
  type SessionSnapshot,
} from "./session";

/** Signed out after 30 minutes without mouse or keyboard activity in ANY tab (ARCHITECTURE §6.4). */
export const IDLE_LIMIT_MS = 30 * 60 * 1000;
/** While someone is working, tell the server every 5 minutes (it also signs out idle sessions). */
const HEARTBEAT_MS = 5 * 60 * 1000;
const CHECK_EVERY_MS = 60 * 1000;
const ACTIVITY_KEY = "ww.admin.lastActivity";
const HEARTBEAT_KEY = "ww.admin.lastHeartbeat";
const ACTIVITY_EVENTS = ["mousemove", "mousedown", "keydown", "scroll", "touchstart"] as const;

/** localStorage is shared by all tabs of the panel. It can be blocked: then each tab counts alone. */
function readTime(key: string): number {
  try {
    return Number(localStorage.getItem(key)) || 0;
  } catch {
    return 0;
  }
}

function writeTime(key: string, value: number) {
  try {
    localStorage.setItem(key, String(value));
  } catch {
    // ignore
  }
}

const AuthContext = createContext<SessionSnapshot | null>(null);

const SERVER_SNAPSHOT: SessionSnapshot = { status: "unknown", staff: null, endReason: null };

export function AuthProvider({ children }: { children: ReactNode }) {
  const session = useSyncExternalStore(subscribe, getSnapshot, () => SERVER_SNAPSHOT);

  // On first load the access token is gone (memory only): get one from the refresh cookie.
  useEffect(() => {
    if (getSnapshot().status === "unknown") void refresh();
  }, []);

  // Signing out in one tab signs out every tab.
  useEffect(() => {
    const onStorage = (event: StorageEvent) => {
      if (event.key !== SIGNED_OUT_KEY || !event.newValue) return;
      if (getSnapshot().status !== "signedIn") return;
      try {
        const { reason } = JSON.parse(event.newValue) as { reason: EndReason };
        signedOut(reason);
      } catch {
        signedOut("logout");
      }
    };
    window.addEventListener("storage", onStorage);
    return () => window.removeEventListener("storage", onStorage);
  }, []);

  // Idle logout and heartbeat while signed in. Activity in any tab counts for all tabs.
  useEffect(() => {
    if (session.status !== "signedIn") return;
    let lastLocal = Date.now();
    writeTime(ACTIVITY_KEY, lastLocal);
    const onActivity = () => {
      const now = Date.now();
      if (now - lastLocal > 5_000) {
        lastLocal = now;
        writeTime(ACTIVITY_KEY, now);
      }
    };
    const check = () => {
      const now = Date.now();
      const lastActivity = Math.max(lastLocal, readTime(ACTIVITY_KEY));
      if (now - lastActivity >= IDLE_LIMIT_MS) {
        void logout("idle");
        return;
      }
      const recentlyActive = now - lastActivity < HEARTBEAT_MS;
      if (recentlyActive && now - readTime(HEARTBEAT_KEY) >= HEARTBEAT_MS) {
        writeTime(HEARTBEAT_KEY, now);
        void api.GET("/v1/admin/me"); // marks the session as active on the server
      }
    };
    ACTIVITY_EVENTS.forEach((e) => window.addEventListener(e, onActivity, { passive: true }));
    const timer = window.setInterval(check, CHECK_EVERY_MS);
    return () => {
      window.clearInterval(timer);
      ACTIVITY_EVENTS.forEach((e) => window.removeEventListener(e, onActivity));
    };
  }, [session.status]);

  return <AuthContext.Provider value={session}>{children}</AuthContext.Provider>;
}

export function useSession(): SessionSnapshot {
  const session = useContext(AuthContext);
  if (!session) throw new Error("useSession must be used inside <AuthProvider>");
  return session;
}

/** True if the signed-in staff member has `permission` (§9.2). */
/** Stable while the permissions stay the same (token refreshes don't change it), so pages can
 * use it in effects without reloading their data. */
export function useCan(): (permission: string) => boolean {
  const { staff } = useSession();
  const permissions = staff?.permissions.join(" ") ?? "";
  return useCallback((permission: string) => permissions.split(" ").includes(permission), [permissions]);
}
