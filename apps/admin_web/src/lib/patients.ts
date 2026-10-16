/** Labels for the patient pages (ARCHITECTURE §6.8, §6.18). */

export const RELATION: Record<string, string> = {
  SELF: "Account owner",
  MOTHER: "Mother",
  FATHER: "Father",
  GRANDMOTHER: "Grandmother",
  GRANDFATHER: "Grandfather",
  SPOUSE: "Spouse",
  CHILD: "Child",
  SIBLING: "Brother / sister",
  OTHER: "Other",
};

export const GENDER: Record<string, string> = { FEMALE: "Female", MALE: "Male", OTHER: "Other" };

export const LANGUAGE: Record<string, string> = { en: "English", hi: "Hindi", or: "Odia" };

export const DOCUMENT_TYPE: Record<string, string> = {
  PRESCRIPTION: "Prescription",
  LAB_REPORT: "Lab report",
  SCAN: "X-ray / scan",
  DISCHARGE: "Discharge summary",
  ID: "ID",
  OTHER: "Other",
};

export const DELETION_STATUS: Record<string, { label: string; color: string }> = {
  PENDING: { label: "Waiting (can still cancel)", color: "orange" },
  CANCELLED: { label: "Cancelled (logged in again)", color: "default" },
  DONE: { label: "Deleted", color: "red" },
};

/** "120 KB", "3.4 MB". */
export function bytes(size: number): string {
  if (size >= 1024 * 1024) return `${(size / (1024 * 1024)).toFixed(1)} MB`;
  return `${Math.ceil(size / 1024)} KB`;
}

/** OpenStreetMap link for a pin (Google Maps once the key arrives, ARCHITECTURE §3.2). */
export function mapLink(lat: string, lng: string): string {
  return `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=17/${lat}/${lng}`;
}
