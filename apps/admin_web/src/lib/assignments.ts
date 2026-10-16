"use client";

import { useEffect, useState } from "react";

import { serverNow } from "@/lib/serverClock";

/** Labels for assignment (ARCHITECTURE §6.10, §9.3). */

/** The booking moved on while a dialog was open (§6.16), said from the admin's side. */
export const BOOKING_CHANGED =
  "The booking changed meanwhile (answered, withdrawn or reassigned). It's up to date now: check and try again.";

export const ALERT_KIND: Record<string, { label: string; color: string }> = {
  OFFER_TIMEOUT: { label: "Not accepted in 2 minutes", color: "orange" },
  DECLINED: { label: "Declined", color: "volcano" },
  ESCALATION: { label: "Past the assign deadline", color: "red" },
  PARTNER_UNAVAILABLE: { label: "Partner unavailable: reassign", color: "red" },
  NEW_APPLICATION: { label: "New partner application", color: "blue" },
  // During the visit (§6.11, Phase 8)
  NO_LOCATION: { label: "No location for 2 minutes", color: "orange" },
  FAR_STEP: { label: "Step marked far from the place", color: "gold" },
  MOCK_GPS: { label: "Fake GPS app", color: "red" },
  OTP_LOCKED: { label: "Visit code wrong 4 times (partner waiting)", color: "red" },
  NO_SHOW: { label: "Patient not available: check", color: "volcano" },
  NOT_COMPLETED: { label: "Not completed 1 hour after the end", color: "orange" },
  NOT_STARTED: { label: "Not on the way 30 min after pickup", color: "red" },
};

export const OFFER_RESPONSE: Record<string, { label: string; color: string }> = {
  OPEN: { label: "Waiting", color: "gold" },
  ACCEPTED: { label: "Accepted", color: "green" },
  ACCEPTED_BY_PHONE: { label: "Accepted by phone", color: "green" },
  DECLINED: { label: "Declined", color: "volcano" },
  WITHDRAWN: { label: "Withdrawn", color: "default" },
};

export const OFFER_KIND: Record<string, string> = {
  NEW: "Offer",
  RECONFIRM: "Confirm the new time",
  TEMPORARY: "Temporary partner", // §6.19: accepted at once
};

export const DECLINE_REASON: Record<string, string> = {
  NOT_AVAILABLE: "Not available",
  TOO_FAR: "Too far",
  OTHER: "Other",
};

/** Seconds left until `until` (negative once past), ticking every second. */
export function useSecondsLeft(until: string | null | undefined): number | null {
  const [now, setNow] = useState(() => serverNow());
  useEffect(() => {
    if (!until) return;
    const tick = () => setNow(serverNow());
    const first = setTimeout(tick, 0); // a card mounted long ago starts from the real time
    const id = setInterval(tick, 1000);
    return () => {
      clearTimeout(first);
      clearInterval(id);
    };
  }, [until]);
  if (!until) return null;
  return Math.round((Date.parse(until) - now) / 1000);
}

/** "1:42" (or "+0:35" once past). */
export function clock(seconds: number): string {
  const sign = seconds < 0 ? "+" : "";
  const s = Math.abs(seconds);
  return `${sign}${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

/** "Call" link for a phone number (shown as-is). */
export function tel(phone: string): string {
  return `tel:${phone.replace(/\s/g, "")}`;
}
