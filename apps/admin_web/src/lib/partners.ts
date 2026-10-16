/** Labels and colours for partner roles and statuses (ARCHITECTURE §6.3 diagram). */
export const ROLE_LABEL: Record<string, string> = { COMPANION: "Companion", NURSE: "Nurse" };

export const STATUS: Record<string, { label: string; color: string }> = {
  REGISTERING: { label: "Registering", color: "default" },
  REGISTERED: { label: "Registered", color: "default" },
  SUBMITTED: { label: "Submitted", color: "blue" },
  UNDER_REVIEW: { label: "Under review", color: "processing" },
  CHANGES_REQUESTED: { label: "Changes needed", color: "orange" },
  APPROVED: { label: "Approved", color: "success" },
  REJECTED: { label: "Rejected", color: "error" },
  SUSPENDED: { label: "Suspended", color: "warning" },
  DEACTIVATED: { label: "Deactivated", color: "default" },
  // §6.19: a person the admin phoned and ID-checked, for one booking only
  TEMPORARY: { label: "Temporary", color: "purple" },
  TEMP_ENDED: { label: "Temporary (ended)", color: "default" },
  // §6.20: erased after "delete my account" (while it waits, the status stays)
  DELETED: { label: "Deleted", color: "default" },
};

export const DOC_STATUS: Record<string, { label: string; color: string }> = {
  MISSING: { label: "Missing", color: "default" },
  PENDING: { label: "To review", color: "processing" },
  APPROVED: { label: "Approved", color: "success" },
  REJECTED: { label: "Rejected", color: "error" },
  EXPIRED: { label: "Expired", color: "warning" },
};

export const GENDER_LABEL: Record<string, string> = { FEMALE: "Female", MALE: "Male", OTHER: "Other" };

export const LANGUAGES = ["Odia", "Hindi", "English", "Bengali", "Telugu"];
export const SKILLS = [
  "Elderly care",
  "Wheelchair help",
  "Hospital paperwork",
  "Two-wheeler",
  "Car driving",
  "Injections",
  "Wound dressing",
  "IV drip",
  "Post-surgery care",
];

export function age(dob: string | null | undefined): string {
  if (!dob) return "—";
  const birth = new Date(dob);
  const now = new Date();
  let years = now.getFullYear() - birth.getFullYear();
  if (now.getMonth() < birth.getMonth() || (now.getMonth() === birth.getMonth() && now.getDate() < birth.getDate())) {
    years -= 1;
  }
  return `${years} yrs`;
}

/** "+919876543210" → "+91 98765 43210" */
export function phone(e164: string): string {
  const m = /^\+91(\d{5})(\d{5})$/.exec(e164);
  return m ? `+91 ${m[1]} ${m[2]}` : e164;
}
