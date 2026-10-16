/** Money is integer paise everywhere (ARCHITECTURE §6.6). The panel shows and takes rupees. */
export function rupees(paise: number): string {
  return `₹${(paise / 100).toLocaleString("en-IN", { maximumFractionDigits: 2 })}`;
}

/** Rupees typed in a form → paise for the API. Rounds away float noise (12.3 → 1230). */
export function toPaise(rupeeAmount: number): number {
  return Math.round(rupeeAmount * 100);
}

export function toRupees(paise: number): number {
  return paise / 100;
}

const IST: Intl.DateTimeFormatOptions = { timeZone: "Asia/Kolkata" };

/** Date and time in India time, e.g. "8 Oct 2026, 2:05 pm". */
export function dateTime(iso: string | null | undefined): string {
  if (!iso) return "—";
  return new Date(iso).toLocaleString("en-IN", {
    ...IST,
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

/** A calendar date (no time), e.g. "17 May 1990". Takes "YYYY-MM-DD". */
export function date(isoDate: string | null | undefined): string {
  if (!isoDate) return "—";
  const [y, m, d] = isoDate.split("-").map(Number);
  return new Date(Date.UTC(y, m - 1, d)).toLocaleDateString("en-IN", {
    timeZone: "UTC",
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

export function minutes(total: number): string {
  if (total < 60) return `${total} min`;
  const h = Math.floor(total / 60);
  const m = total % 60;
  return m ? `${h} h ${m} min` : `${h} h`;
}
