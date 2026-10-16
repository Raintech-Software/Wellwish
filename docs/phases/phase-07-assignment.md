# Phase 07 — Assignment · Completion report

| Item | Value |
|---|---|
| Started | 10 Oct 2026 |
| Completed | 10 Oct 2026 (after the deep check, the live checks and the developer's confirmation) |
| Built by | akashto76 with Claude |
| Git | not committed (offered at the close) |
| Architecture version used | v2.14 |

## Summary
Admins now assign every paid booking by hand from a live **Unassigned queue** (Today / Tomorrow / Later, red past the deadline, sound on new bookings). The partner gets the offer on their phone within seconds with a **2-minute countdown**, sees only a summary, and accepts or declines with a reason; after accepting, the full address, phones, health notes and documents open. With no answer at 2 minutes the admin gets an alert with **Call primary / Call alternate / Accepted by phone / Reassign**; a busy partner is refused; bookings still unassigned at **6 PM the evening before** (or 3 h before pickup) turn red and the Super Admins are emailed. The patient sees their partner (photo, name, role, rating, Call) on the booking, live. Partners take a **daily selfie** before going available, and admins spot-check them. Reminders go out 24 h and 2 h before.

## Tasks
### Backend
- [x] 7.1 `apps/assignments`: `BookingAssignment` model with one open offer per booking. Assign, reassign (withdraws the old offer), unassign, decline with a reason.
- [x] 7.2 Accept is atomic and sets `busy_window`. The **exclusion constraint `no_partner_overlap`** stops double-booking a partner, with a migration adding `btree_gist`.
- [x] 7.3 **Accepted by phone** (admin, logged).
- [x] 7.4 Candidates endpoint: approved partners of the right type, free at that time, distance from their base, available today, rating, jobs this week, both phones.
- [x] 7.5 2-minute timer: Celery countdown 120 s → admin alert + partner reminder if the offer is still open. The offer stays open.
- [x] 7.6 Escalation sweep: unassigned at 6 PM the day before or 3 h before pickup → red alert + Super Admin notified.
- [x] 7.7 Reminders sweep: T−24 h and T−2 h to the owner, the member (SMS) and the partner.
- [x] 7.8 Reschedule with an assigned partner sends a re-confirm offer (finishes 6.7).
- [x] 7.9 Channels: `/ws/staff/` (`queue.changed`, `alert`, incl. "new partner application"), `/ws/partner/` (`offer.new`, `offer.withdrawn`, `booking.updated`, `session.revoked`), JWT as the first message.
- [x] 7.10 Partner "Available today" switch and daily selfie check: `POST /v1/partner/me/selfie`, the selfie screen before switching on, admin spot-check view.
### Admin panel
- [x] 7.11 Unassigned queue (Today / Tomorrow / Later, soonest first, red when past the deadline) with a sound on new bookings.
- [x] 7.12 Assign dialog with the candidates list and call buttons, plus a live 2-minute countdown on the booking.
- [x] 7.13 Alert banner: "Not accepted — Call primary / Call alternate / Accepted by phone / Reassign". Decline alerts include the reason.
### Partner app
- [x] 7.14 Home R08: Available switch, offer card with a countdown, today's bookings, quick totals.
- [x] 7.15 Offer screen R09: summary only (area, distance, time, needs, balance). Accept, or Decline with a reason.
- [x] 7.16 My bookings R10 and booking detail R11. Full address, both phones, health notes and documents appear only after accepting.
### Patient app
- [x] 7.17 Booking detail shows the assigned partner (photo, name, phone, rating). Push + member SMS on acceptance. *(Push is built and switches on with the Firebase key, which the developer adds later; the inbox message and the member SMS work now.)*

## What was built
### Backend
- **`apps/assignments`** (new app): `BookingAssignment` (offer kind NEW / RECONFIRM, response OPEN / ACCEPTED / ACCEPTED_BY_PHONE / DECLINED / WITHDRAWN, decline reason + note, `reminded_at`; one open offer per booking) and `StaffAlert` (OFFER_TIMEOUT, DECLINED, ESCALATION, PARTNER_UNAVAILABLE; acknowledged by an admin).
- Services: assign / reassign (withdraws the open offer), accepted by phone, unassign, partner accept / decline, the 2-minute timer (`assignments.offer_timeout`, Celery countdown), the escalation sweep (`assignments.escalation_sweep`, every 5 min, email to the Super Admins), hooks for cancel and reschedule (RECONFIRM offer, fresh offer, release of a busy partner), suspended / deactivated partners (offers back to the queue, jobs flagged). Locks are always booking → offer. Every admin action is in the audit log.
- Selectors: the queue (Today / Tomorrow / Later, India time; NEW, OFFERED, an unconfirmed new time, a suspended partner's job), counts, candidates (approved, right role, free at that time, "available today" first, then nearest), the partner's home, offers, jobs and one job.
- **Bookings:** `confirm_new_time`, `partner_busy`, reschedule releases a busy partner, `register_reschedule_hook`, `in_job_window` (phones 1 h, health notes and documents 24 h after completion), reminders (`BookingReminder`, `bookings.reminder_sweep` every minute: 24 h and 2 h before; none for bookings booked, paid or moved inside the window).
- **Partners:** `available_on` (Available today resets daily), today's selfie required to switch on (`SELFIE_REQUIRED`), `POST /me/selfie`, admin selfie list.
- **Notifications:** inbox / SMS for OFFER_NEW, OFFER_TIME_CHANGED, OFFER_REMINDER, OFFER_WITHDRAWN, JOB_CANCELLED, JOB_REMINDER, BOOKING_ASSIGNED, BOOKING_REMINDER (en / hi / or); new DLT texts in `common/sms.py`; MSG91 template-id settings for every SMS.
- **Realtime:** `/ws/staff/` (groups by permission, `queue.changed`, `alert`, `session.revoked`, `socket.rejoin`), `offer.*` and `booking.updated` to partners, `booking.updated` to patients; staff sockets close when the admin's session ends.
### Partner app
- R08 Home: Available today (selfie first), new offers with a countdown (server clock), today's jobs, totals.
- Selfie screen (front camera → upload → available).
- R09 Offer: summary only; Accept / Decline with a reason; shows "This job is yours / Open the job" when it was accepted by phone, "no longer yours" when withdrawn.
- R10 Jobs: New / Upcoming / Completed. R11 Job: member, health notes, full address with Navigate, call the member / the person who booked, documents (one download at a time), the balance.
- Live socket: offers arrive and disappear without a refresh; reconnects with a fresh token; stops when the session ends.
### Patient app
- P18 Booking: "Your partner" card (photo, name, role, rating, Call). Updates live over `/ws/patient/` (new patient socket).
- Doctor photos now load in local development too (`fileUrl`; a Phase 5 bug).
### Admin panel
- Bookings → **Unassigned queue** (Today / Tomorrow / Later with counts, red past the deadline, sound on new bookings, live).
- Booking page **Partner card**: assign dialog (candidates, both phones), 2-minute countdown, "not answered" banner (Call primary / Call alternate / Accepted by phone / Reassign), decline reasons, unassign, all offers, alerts.
- **Live alerts** across the panel (2 minutes, declined, past the deadline, partner suspended, new application), "Live updates offline" indicator.
- Partners → **Selfie checks**.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET | `/v1/admin/assignments/queue?when=` ; `/queue/counts` | Unassigned queue (`late`, `problem`) |
| GET | `/v1/admin/bookings/:id/candidates` | Free partners, available today first, distance, phones |
| GET | `/v1/admin/bookings/:id/assignment` | Open offer, partner, offers, alerts, `currentAssignmentId` |
| POST | `/v1/admin/bookings/:id/assign` | `{ partnerId, expectedAssignmentId }` |
| POST | `/v1/admin/bookings/:id/accept-by-phone` | `{ reason, expectedAssignmentId }` |
| POST | `/v1/admin/bookings/:id/unassign` | `{ reason, expectedAssignmentId }` |
| GET / POST | `/v1/admin/alerts?open=` ; `/v1/admin/alerts/:id/ack` | ack needs `bookings.manage` |
| GET | `/v1/admin/selfies?date=&partnerId=` | `partners.review` |
| GET | `/v1/partner/home` | R08 |
| GET / PATCH | `/v1/partner/me/availability` | 409 `SELFIE_REQUIRED` |
| POST | `/v1/partner/me/selfie` | `{ fileKey }` (purpose `partner_selfie`) |
| GET | `/v1/partner/offers` ; `/v1/partner/offers/:id` | summary with `response`, `timeoutAt` |
| POST | `/v1/partner/offers/:id/accept` ; `/decline` | 409 `OFFER_NOT_OPEN`, `PARTNER_BUSY` |
| GET | `/v1/partner/jobs?bucket=` ; `/v1/partner/jobs/:id` ; `/documents/:linkId/view-url` | after accepting; document views logged |
| — | `BookingDetailOut.partner` (patient) | the accepted partner |

OpenAPI regenerated: yes (`.\ww.ps1 openapi`, `.\ww.ps1 gen-clients`).

## Database changes
| App | Migration | What it does |
|---|---|---|
| assignments | 0001_initial | `booking_assignments`, `staff_alerts` (constraints: one open offer per booking, one timeout alert per offer, one escalation per booking time) |
| assignments | 0002_partner_unavailable_alert | alert kind PARTNER_UNAVAILABLE |
| bookings | 0004_booking_reminders | `booking_reminders` (one per booking, kind and time) |
| partners | 0002_partner_available_on | `partner_profiles.available_on` |
| notifications | 0004_assignment_templates | Phase 7 message texts (en / hi / or) |

## Tests
| Check | Command | Result |
|---|---|---|
| Backend tests | `.\ww.ps1 test` | 495 passed (28 in `apps/assignments`, incl. 8 added by the deep check) |
| Lint / types | `.\ww.ps1 lint` | ruff, format, mypy clean |
| Flutter | `.\ww.ps1 check` (analyze + test) | partner 24, patient 52, ww_core 20, ww_ui 15, ww_auth 9, ww_l10n 6: all pass |
| Admin | `npm run lint`, `npm run build` | clean |
| Everything | `.\ww.ps1 check` | **All checks passed** (re-run after the deep-check fixes) |

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| Assign → the partner sees the offer on their phone within seconds → accepts → the patient sees the partner | Live: admin assigned WW-10008 to Asha (test partner) on the emulator; the offer appeared in about 2 s with the countdown; R09 showed the summary only; Accept opened R11 with the full address; the patient app showed "Your partner: Asha Behera" with Call (and the photo after the fix). The patient screen also updated by itself when WW-10005 was accepted. Test `test_assign_accept_and_the_patient_sees_the_partner`. | ✅ |
| With no answer, the admin alert appears at 2 minutes with call buttons. "Accepted by phone" works and is logged | Live twice (Rina, then Asha after the fixes): at 2:00 the toast and the banner with Call primary / Call alternate / Accepted by phone / Reassign; the partner's card turned to "WellWish is waiting" and the reminder reached the inbox; Accepted by phone recorded with the note in the audit log. | ✅ |
| A decline returns the booking to the queue with the reason | Live: Asha declined "Too far: Bus strike today"; the booking went back to New with the reason on the booking and in the alert. | ✅ |
| Assigning a partner who is busy at that time is refused | Live: WW-10005 moved onto Asha's 11 Oct job time; assigning her from an already-open dialog answered 409 `PARTNER_BUSY` ("This partner has another job at that time") and a fresh list no longer offers her. Test `test_a_busy_partner_is_refused`. | ✅ |
| An unassigned booking for tomorrow morning turns red at 6 PM today | The escalation sweep run against the dev database with the clock at 5:59 PM (nothing) and 6:00 PM IST today (WW-10005 escalated: red banner live in the panel, email to both Super Admins in the dev outbox, a second run sent nothing). The queue's red flag uses the same deadline and was seen live on an overdue booking. Tests `test_unassigned_tomorrow_morning_turns_red_at_6pm_today`, `test_three_hours_before_comes_first…`. *Not watched at the real 6 PM.* | ✅ |

## Screens
Screenshots in `docs/phases/img/phase-07/`:
- Partner: `r08-selfie-needed`, `r08-available-after-selfie`, `r08-offer-arrived`, `r08-waiting-after-2-minutes`, `r09-offer-summary`, `r09-decline-reason`, `r09-accepted-by-phone-is-yours`, `r10-upcoming`, `r11-job-after-accept`.
- Patient: `p18-your-partner-asha`, `p18-live-update-rina`, `p18-partner-photo`.
- Admin: `admin-queue-red-past-deadline`, `admin-queue-tomorrow`, `admin-assign-dialog`, `admin-queue-waiting-countdown`, `admin-2-minute-alert`, `admin-accepted-by-phone`, `admin-audit-log`, `admin-declined-with-reason`, `admin-partner-busy-refused`, `admin-escalation-6pm`, `admin-selfie-checks`.

## Deep check (10 Oct 2026)
Three independent reviews (backend, admin panel, Flutter apps) found **36 issues**; 33 are fixed, tested and re-checked live; the 3 low ones are under *Known issues* (the admin countdown, since fixed; the partner's bell badge; the partner reminder window). The main ones:
- **Backend (12):** a deadlock when a partner accepts while an admin reassigns / cancels / moves the time (reproduced; fixed by always locking booking → offer); a partner who declined a new time still got "job cancelled" later; double JOB_CANCELLED / OFFER_WITHDRAWN messages; suspended partners kept offers and jobs (and could be "accepted by phone"); an unconfirmed new time never escalated; two admins could overwrite each other (§6.16 → `OFFER_CHANGED`); the 2-minute reminder reached nobody without Firebase (now inbox + socket); reminders for bookings made inside the window; SUPPORT could silence alerts; `reconfirm_needed` left set; a failing socket send could skip SMS / timers / emails (robust on-commit); extra queries.
- **Admin (13):** duplicate / orphaned staff sockets (React strict mode); sockets reconnecting forever with an expired token; nothing reloaded after a reconnect; staff sockets not closed when an admin's session ends; the socket URL on https; "Reassign" on a new-time offer; Support acknowledging alerts; the chime blocked silently; a countdown flash; partner-facing wording shown to admins; the queue not turning red by itself or regrouping at midnight, and rows past 50 hidden; a button inside a link; acknowledge without error handling; Selfie checks using the PC's date; the old 2-minute alert left open after a reassign.
- **Flutter (11):** app sockets retrying an expired token forever (offers stopped arriving after 15 minutes); "no longer yours" shown after the admin recorded the acceptance by phone; the countdown freezing after a new time and trusting the phone's clock; documents hidden after the job / failed PDF opens silent / parallel downloads; `SELFIE_REQUIRED` after midnight leading nowhere; selfie retry taking another photo; "logout" shown as "session expired"; a vanished job showing a generic error; ratings like "4.80"; the Available switch read without its label.
- Found during the live checks: partner and doctor photos not loading in dev (relative URLs), the MSG91 template-id settings missing for Phase 6–7 SMS, the "Assign by" date not refreshing after a time change, the 2-minute toast staying after the answer, "1 jobs", a console warning, and the "(booked)" call label.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| Push (Firebase) left for later; inbox, SMS and the live socket carry the messages | Developer decision ("I will add it later") | yes (10 Oct 2026) | v2.14 header |
| New tables `staff_alerts`, `booking_reminders`; `partner_profiles.available_on` | Alerts must be acknowledged; reminders once per time; "Available today" resets daily | yes (10 Oct 2026) | v2.14 §10.1, §11 |
| The offered partner is set on the booking at OFFER; an offer has a kind (NEW / RECONFIRM) | Busy checks and the partner's view need it; re-confirming a new time | yes (10 Oct 2026) | v2.14 |
| A new time that clashes with the accepted partner's other job releases them (back to the queue) instead of failing; an offered booking moved gets a fresh offer | The reschedule must not fail for the patient; a new time needs a new 2-minute rule | yes (10 Oct 2026) | v2.14 §6.17 |
| A suspended / deactivated partner's open offers go back to the queue; their jobs are **flagged** (not unassigned automatically) | §6.16 says "flagged to the admin for reassignment" | yes (10 Oct 2026) | v2.14 §10.2 |
| Two admins at once: `expectedAssignmentId`, 409 `OFFER_CHANGED` | §6.16 optimistic lock | yes (10 Oct 2026) | v2.14 §10.3 |
| Reminders 22–24 h and 1–2 h before; none if booked, paid or moved inside the window; the 2-minute reminder also in the inbox | Exact windows weren't specified | yes (10 Oct 2026) | v2.14 §10.5 |
| Escalation emails the Super Admins | "Super Admin notified" without a channel; push not available yet | yes (10 Oct 2026) | v2.14 |
| Offer "area" = the address without its first part | No area field exists yet | yes (10 Oct 2026) | v2.14 |
| After the job: phones 1 h, health notes and documents 24 h; partner document views logged | §6.15, §12, open point 8 | follows the document | v2.14 |
| Staff socket groups by permission; dev socket `ws://<host>:8000` | Next.js doesn't forward WebSockets in dev | yes (10 Oct 2026) | v2.14 §10.4 |
| Document opener moved to `ww_core` (shared by both apps); `ServerClock` in `ww_core` | Reuse; countdowns need the server's time | yes (10 Oct 2026) | — (code structure) |

## Known issues and follow-ups
- **Push notifications** wait for the Firebase key (KEYS-AND-ACCOUNTS row 5) → when the developer adds it.
- The partner app's bell badge doesn't refresh when a reminder arrives over the socket (the message is in the inbox) → low → **on hold until Firebase** (developer, 10 Oct 2026).
- A partner who accepts after the 24-hour reminder window gets only the 2-hour reminder → low → by design for now.
- ~~The admin countdown uses the PC's clock~~ → **fixed after the close (10 Oct 2026, developer's request)**: the panel now follows the server's clock automatically (from each API answer's `Date` header) for the 2-minute countdowns and the red "past the deadline" rows; no setting needed.
- Dev data: WW-10006 (paid, time 9 Oct) was cancelled by the developer from the admin panel (10 Oct 2026). Its 50% refund shows FAILED (REFUSED_BY_RAZORPAY) because that booking was paid with a simulated dev payment (`pay_devsim_…`), not a real Razorpay test payment → expected, dev data only.
- The 6 PM escalation was checked by running the sweep with the clock set, not by waiting for the real 6 PM.

## How to run and demo this phase
- `.\ww.ps1 up`; admin: `npm --prefix apps/admin_web run dev` (sign in with `DEV_QA_ADMIN_*` from `backend/.env`); apps: `flutter run --flavor dev -t lib/main_dev.dart` in `apps/partner_app` and `apps/patient_app`.
- Test accounts: patient `+91 90000 00001`, partners Asha `+91 90000 00003` and Rina `+91 90000 00005` (OTP `123456`).
- Demo: Unassigned queue → Assign → the partner's Home shows the offer → Accept → the patient's booking shows the partner. Wait 2 minutes without answering for the alert. `.\ww.ps1 manage mail_outbox <email>` shows escalation emails; `.\ww.ps1 manage sms_outbox <phone>` the SMS.

## Next phase
Phase 8 — The visit. Notes: R11 is where the job steps go; `in_job_window` reads the COMPLETED event's time, so Phase 8's completion must go through `transition()` (it does by rule); the partner reminder for a job (JOB_REMINDER) is already sent; Live map and SOS build on the staff socket groups.
