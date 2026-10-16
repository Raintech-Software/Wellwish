/**
 * The server's time as best the panel knows it (§6.10): the 2-minute countdowns and the
 * "red past the deadline" check use this, not the PC's own clock, which may be minutes off.
 * Every API answer's `Date` header updates the offset (whole seconds, good enough here).
 */
let offset = 0;

export function syncServerClock(dateHeader: string | null): void {
  if (!dateHeader) return;
  const server = Date.parse(dateHeader);
  if (Number.isNaN(server)) return;
  offset = server - Date.now();
}

/** Now (milliseconds), corrected for the PC's clock being fast or slow. */
export const serverNow = (): number => Date.now() + offset;
