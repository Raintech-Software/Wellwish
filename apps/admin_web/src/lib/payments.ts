import dayjs, { type Dayjs } from "dayjs";

/** Labels for the payments pages (ARCHITECTURE §6.12, §9.5). */

export const PAYMENT_STATUS: Record<string, { label: string; color: string }> = {
  CREATED: { label: "Started", color: "default" },
  AUTHORIZED: { label: "Authorised", color: "gold" },
  CAPTURED: { label: "Paid", color: "green" },
  FAILED: { label: "Failed", color: "red" },
};

export const REFUND_STATUS: Record<string, { label: string; color: string }> = {
  AWAITING_APPROVAL: { label: "Waiting for Finance", color: "gold" },
  PENDING: { label: "Sent to Razorpay", color: "blue" },
  PROCESSED: { label: "Refunded", color: "green" },
  FAILED: { label: "Failed", color: "red" },
  REJECTED: { label: "Rejected", color: "default" },
};

export const METHOD: Record<string, string> = {
  upi: "UPI",
  card: "Card",
  netbanking: "Netbanking",
  wallet: "Wallet",
  emi: "EMI",
};

export const REQUESTED_BY: Record<string, string> = {
  PATIENT: "Patient (cancelled in the app)",
  STAFF: "Admin",
  SYSTEM: "System (paid late or twice)",
};

/** The patient app sends its cancel reasons as codes ("PLANS_CHANGED: typed note"). */
const CANCEL_REASON: Record<string, string> = {
  PLANS_CHANGED: "Plans changed",
  BOOKED_BY_MISTAKE: "Booked by mistake",
  OTHER: "Another reason",
};

/** A cancel or refund reason with the app's codes in words. */
export function reasonText(reason: string): string {
  return reason.replace(/\b(PLANS_CHANGED|BOOKED_BY_MISTAKE|OTHER)\b/g, (code) => CANCEL_REASON[code] ?? code);
}

/** A refund's status; a PENDING one Razorpay hasn't got yet (keys missing or Razorpay down)
 * is sent again by the 30-minute check. */
export function refundStatus(refund: { status: string; razorpayRefundId: string }): { label: string; color: string } {
  if (refund.status === "PENDING" && !refund.razorpayRefundId) return { label: "Waiting to be sent", color: "gold" };
  return REFUND_STATUS[refund.status] ?? { label: refund.status, color: "default" };
}

/** Why a payment or refund didn't go through, in words (codes from the server; Razorpay's own
 * error codes are shown as they are). */
export const FAILURE: Record<string, string> = {
  REFUSED_BY_RAZORPAY: "Razorpay refused it",
  REFUND_FAILED: "Failed at Razorpay",
  GATEWAY_ERROR: "Razorpay didn't answer (tried again automatically)",
  AMOUNT_MISMATCH: "Wrong amount: given back",
  NOT_PAID: "Not paid in time",
  NOT_CAPTURED: "Razorpay didn't confirm it",
  NOT_FOUND_AT_RAZORPAY: "Not found at Razorpay",
};

export function failureText(code: string): string {
  return FAILURE[code] ?? code;
}

/** `percent` of `paise`, rounded half up like the server (common.money.percent_of). */
export function percentOf(paise: number, percent: number): number {
  return Math.floor((paise * percent + 50) / 100);
}

const IST_MINUTES = 330;

/** An instant as India wall-clock time for a picker (whatever the browser's time zone, also on
 * a daylight-saving change day): the India date and time fields, read as local fields. */
export function toIstPicker(iso: string): Dayjs {
  const ist = new Date(Date.parse(iso) + IST_MINUTES * 60_000);
  return dayjs(
    new Date(ist.getUTCFullYear(), ist.getUTCMonth(), ist.getUTCDate(), ist.getUTCHours(), ist.getUTCMinutes()),
  );
}

/** A picker's wall-clock value read as India time → ISO instant for the API. */
export function fromIstPicker(value: Dayjs): string {
  return `${value.format("YYYY-MM-DDTHH:mm")}:00+05:30`;
}

/** Saves a downloaded file (the fee report CSV). */
export function saveFile(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}
