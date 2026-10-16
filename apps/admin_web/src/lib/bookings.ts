/** Labels for the booking pages (ARCHITECTURE §6.9, §6.6). */

export const BOOKING_STATUS: Record<string, { label: string; color: string }> = {
  PENDING_PAYMENT: { label: "Unpaid", color: "gold" },
  NEW: { label: "New (to assign)", color: "cyan" }, // red is kept for "close and unassigned" (Phase 7)
  OFFERED: { label: "Offered", color: "orange" },
  ACCEPTED: { label: "Assigned", color: "blue" },
  IN_PROGRESS: { label: "In progress", color: "geekblue" },
  COMPLETED: { label: "Completed", color: "green" },
  PATIENT_NO_SHOW: { label: "Patient not available", color: "volcano" },
  CANCELLED: { label: "Cancelled", color: "default" },
  EXPIRED: { label: "Expired (not paid)", color: "default" },
};

export type BookingStatus = keyof typeof BOOKING_STATUS;

export const PARTNER_TYPE: Record<string, string> = {
  COMPANION: "Companion",
  NURSE: "Nurse",
};

export const VISIT_TYPE: Record<string, string> = {
  HOSPITAL_VISIT: "Hospital visit",
  HOME_VISIT: "Home visit",
  ERRAND: "Errand",
};

export const EVENT: Record<string, string> = {
  CREATE: "Booked by the patient",
  PAY: "Booking fee paid",
  EXPIRE: "Not paid in time",
  OFFER: "Offered to a partner",
  ACCEPT: "Partner accepted",
  DECLINE: "Partner declined",
  WITHDRAW: "Offer withdrawn",
  UNASSIGN: "Partner unassigned",
  START: "Partner on the way",
  COMPLETE: "Completed",
  NO_SHOW: "Patient not available",
  CANCEL: "Cancelled",
  RESCHEDULE: "Date or time changed",
  RECONFIRM: "Partner confirmed the new time",
  STEP: "Visit step",
  CALL: "Partner called",
  BALANCE: "Balance recorded",
};

export const ACTOR: Record<string, string> = {
  PATIENT: "Patient",
  PARTNER: "Partner",
  STAFF: "Admin",
  SYSTEM: "System",
};

/** Why the server refused a time (TIME_NOT_AVAILABLE details.reason, §6.17). */
export const TIME_REFUSED: Record<string, string> = {
  OUTSIDE_WINDOW: "That date is outside the booking window (Settings → how far ahead).",
  TOO_SOON: "That time has already passed.",
  OUTSIDE_HOURS: "That time is outside service hours.",
  BLOCKED: "That time is blocked (Settings → Blocked dates).",
  FULL: "Every place at that time is taken.",
  NOT_ON_STEP: "Pick a time on the time step (Settings, e.g. :00 or :30).",
};
