/** Labels for the visit, the live map, SOS and support (ARCHITECTURE §6.11, §6.15, §9.1). */

export const STEP: Record<string, string> = {
  ON_THE_WAY: "On the way",
  REACHED_PATIENT: "Reached the patient",
  PICKED_UP: "Picked up (visit code)",
  REACHED_HOSPITAL: "At the hospital",
  VISIT_DONE: "Visit done",
  DROPPED_HOME: "Dropped home",
  REACHED_HOME: "Reached the home",
  STARTED: "Started (visit code)",
  CARE_DONE: "Care done",
  AT_PLACE: "At the place",
  TASK_DONE: "Task done",
  DELIVERED: "Delivered",
  COMPLETED: "Completed",
};

export function stepLabel(step: string | null | undefined): string {
  if (!step) return "—";
  return STEP[step] ?? step;
}

export const SOS_STATUS: Record<string, { label: string; color: string }> = {
  OPEN: { label: "Open", color: "red" },
  ACKNOWLEDGED: { label: "Acknowledged", color: "orange" },
  RESOLVED: { label: "Resolved", color: "green" },
};

export const SOS_SIDE: Record<string, string> = {
  PARTNER: "Partner",
  PATIENT: "Family",
};

export const TICKET_STATUS: Record<string, { label: string; color: string }> = {
  OPEN: { label: "Open", color: "orange" },
  CLOSED: { label: "Closed", color: "default" },
};

export const REVIEW_STATUS: Record<string, { label: string; color: string }> = {
  VISIBLE: { label: "Visible", color: "green" },
  HIDDEN: { label: "Hidden", color: "default" },
};

export const REVIEW_TAG: Record<string, string> = {
  ON_TIME: "On time",
  KIND: "Kind",
  HELPFUL: "Helpful",
  PROFESSIONAL: "Professional",
  GOOD_COMMUNICATION: "Explained well",
  LATE: "Late",
  RUDE: "Rude",
  UNHELPFUL: "Not helpful",
};

export const BALANCE_MODE: Record<string, string> = {
  CASH: "Cash",
  UPI: "UPI",
};

/** "★★★★☆" */
export function stars(count: number): string {
  return "★".repeat(count) + "☆".repeat(Math.max(0, 5 - count));
}

/** Google Maps at a point (a new tab). */
export function pointLink(lat: string | number, lng: string | number): string {
  return `https://www.google.com/maps/search/?api=1&query=${lat},${lng}`;
}

/** A far step's note: "Reached the patient: 1.5 km from the place" (or "no position sent"). */
export function farStepNote(details: Record<string, unknown>): string {
  const m = details.metres == null ? null : Number(details.metres);
  const away =
    m == null || Number.isNaN(m)
      ? "no position sent"
      : m < 1000
        ? `${Math.round(m)} m from the place`
        : `${(m / 1000).toLocaleString("en-IN", { maximumFractionDigits: m < 100000 ? 1 : 0 })} km from the place`;
  return `${stepLabel(String(details.step ?? ""))}: ${away}`;
}

/** "12 min" or "2 h 5 min". */
export function eta(minutes: number | null | undefined): string {
  if (minutes == null) return "—";
  return minutes < 60 ? `${minutes} min` : `${Math.floor(minutes / 60)} h ${minutes % 60} min`;
}
