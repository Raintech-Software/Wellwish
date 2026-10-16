# Phase 08 — The visit · Completion report

| Item | Value |
|---|---|
| Started | 10 Oct 2026 |
| Completed | 12 Oct 2026, 18:45 (after two deep checks, the live checks and the admin-panel checks in the browser) |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice at the close, 12 Oct 2026; nothing is committed yet for phases 0–8) |
| Architecture version used | v2.15, v2.16 (admin sign-in recovery), v2.17 (second deep check fixes; also the Temporary partner design for Phase 8B), v2.18 (an emailed code instead of the authenticator) |

## Summary
The partner now does the job step by step in the app. They tap **On the way** from 2 h before pickup, then each step of the visit type, and get the family's **4-digit visit code** at the pickup / start / handover step. A wrong code is never a hard lock: after 4 wrong codes there's a growing wait, and the admin is alerted. From On the way to Completed the phone **shares its location** as an Android foreground service. The family watches the partner on a **live map** with an ETA, can **share the trip** with someone without the app, and has **SOS** (as does the partner). Steps tapped without network are kept and sent in order later. Nurses write a **care note** with vitals that lands in the family's Reports. After the visit the partner records the **balance collected**, sees their **totals**, and the family **rates** the visit or **reports a problem**. Admins get the **Live map** with SOS console and visit alerts, the **Visit card** on the booking (mark a step for the partner), and **Support → Tickets / Reviews**.

## Tasks
### Backend
- [x] 8.1 Steps per visit type (§6.11 table), recorded through `transition()` with GPS. "Far from target" (> 300 m) flags the step but doesn't block it.
- [x] 8.2 Job OTP: created when the partner accepts, stored as a hash (plus an encrypted copy, v2.15), shown to the owner, SMS to the member's phone, 4 wrong tries then a growing wait (5, 10, 20 min…) + admin alert (developer decision 12 Oct 2026; was "5 tries then lock"), admin can mark the step on the partner's behalf (logged).
- [x] 8.3 `apps/tracking`: `location.update` consumer; checks (accuracy, mock location, impossible speed); Redis latest point; `booking.location` to the patient, `job.location` to staff; track saved when the job ends; offline batch endpoint.
- [x] 8.4 No-location watch: 2 min without a point during a job → admin alert.
- [x] 8.5 Patient not available: 15-min timer after arrival, then the partner can mark it (needs a logged call attempt). Admin reviews.
- [x] 8.6 Care note (nurse): required at "Care done", with optional vitals. Saved to the member's documents.
- [x] 8.7 Balance collected (amount + cash/UPI) and partner totals endpoint (§6.13).
- [x] 8.8 `apps/safety`: SOS (admin alarm + SMS to the emergency contacts) and trip share link (token, expires at the end of the job).
- [x] 8.9 `apps/reviews`: rating after completion, report a problem (support ticket), admin replies.
### Partner app
- [x] 8.10 Active job R12: big step button, OTP entry, navigate (Google Maps), call member / owner, wait timer, SOS.
- [x] 8.11 Android foreground location service running only from "On the way" to "Completed", with a visible notification. Offline queue for steps and points.
- [x] 8.12 Care note R13 (nurse), Collect balance R14, Totals R15.
### Patient app
- [x] 8.13 Live tracking P19: map, partner marker, ETA, current step, OTP display, call, SOS, share link.
- [x] 8.14 Completed P20: "Pay ₹X to your companion", rating, report a problem.
### Added during the phase (developer decision, 12 Oct 2026)
- [x] 8.16 Admin sign-in recovery (§6.4, v2.16, v2.18): "Trust this browser for 30 days", "No phone? Email me a code" (v2.18), 10 one-time recovery codes (use one → set up a new authenticator; Super Admins emailed), help text "a Super Admin can reset your 2FA", warning while only one Super Admin is active, server command `reset_staff_2fa`.
### Admin panel
- [x] 8.15 Live map of jobs in progress. Alerts list (no location, far step, mock GPS, OTP locked). SOS console (acknowledge / resolve). Support tickets and reviews moderation. *(Checked in the browser on 12 Oct: see "Admin panel checked in the browser" below.)*

## What was built
### Backend
- **Bookings / visit (`apps/bookings/visit.py`):** the steps per visit type (hospital visit, home visit, errand), the OTP step of each, `record_step` under the booking row lock, "On the way" only from `JOB_START_BEFORE_HOURS` (2) before pickup (409 `TOO_EARLY_TO_START`), arrivals checked against the place (> 300 m or no position → flagged, FAR_STEP alert), the job OTP (HMAC hash + Fernet copy, SMS JOB_OTP to the member), wrong codes → `otp_retry_at` wait (4 free tries, then 5 / 10 / 20 / 40 / 60 min, OTP_LOCKED alert at the first wait), patient not available (15 min + a logged call → NO_SHOW alert), care note with vitals (a CARE_NOTE document, vitals never on the timeline), balance collected (cash / UPI, correctable for 24 h), admin "mark a step" (reason, audit log), partner totals.
- **`apps/tracking` (new):** socket `location.update` and `track-batch` (offline points with the phone's time), checks (invalid, accuracy > 50 m, mock → MOCK_GPS, > 120 km/h), latest point / track / "alive" in Redis, `booking.location` to the family (every point) and `job.location` to admins (at most every 15 s), straight-line ETA at 20 km/h, route saved 2 min after Completed as an encoded polyline with km (`booking_tracks`), NO_LOCATION watch (2 min, rough points count as "phone on"), NOT_COMPLETED alert.
- **`apps/safety` (new):** SOS from either side (one open per booking and side, location updated on a second press, SMS SOS_ALERT to the emergency contacts, `sos.new` / `sos.updated` to `staff.ops`, acknowledge / resolve with a note, 409 `SOS_ALREADY_RESOLVED`), trip share link (`/t/#<token>`, token hashed, `GET /v1/public/track` with `X-Share-Token`, ends with the visit, 12 h at most).
- **`apps/reviews` (new):** one review per completed booking (stars, tags, comment), hide / show with a reason (never deleted; hidden ones leave the partner's average), report a problem within 24 h (support ticket), admin reply → family inbox (TICKET_REPLY), close.
- **Assignments:** new alert kinds (NO_LOCATION, FAR_STEP, MOCK_GPS, OTP_LOCKED, NO_SHOW, NOT_COMPLETED), acknowledged with `bookings.manage` or `live.manage`, `alert.acked` closes the banner everywhere; **assign deadline** for late bookings: at least 30 min after payment (developer decision 12 Oct 2026).
- **Staff (v2.16, admin sign-in recovery):** `staff_trusted_browsers` + httpOnly cookie `ww_staff_trust` (30 days; the password alone signs in; forgotten on 2FA reset, new password, disable, sign out everywhere); `staff_recovery_codes` (10 per admin, HMAC, one-time; `POST /v1/admin/auth/recovery` → new QR code at once; the admin and the other Super Admins emailed; new codes with the password); `/me` has `recoveryCodesLeft`, `onlySuperAdmin`; command `reset_staff_2fa --email … [--new-password]` (audit `staff.emergency_reset`, email). **v2.18 (developer decision while closing):** "No phone? Email me a code": `POST /v1/admin/auth/email-code` emails a 6-digit code to the admin's work email with a new 10-minute sign-in step; typed in the same box (`/auth/totp`), HMAC only, once, resend 30 / 60 / 120 s, 5 an hour, wrong ones count toward the 2FA lock; not before 2FA is set up.
- **Account erasure** also clears the visit's positions, vitals, step notes, routes, SOS positions, share links, review comments and problem texts.
### Partner app
- R12 Active job on the job screen: big step button, visit-code sheet (tries left, last-try warning, "try again at …" wait), Navigate (to the hospital after pickup), call the member / the person who booked, the 15-minute wait timer and "Patient not available", SOS (with the error shown in the sheet), "Too early to start. You can tap On the way from …".
- Location sharing (`ww_core` `DeviceLocationTracker`: fused location with GPS-only fallback, foreground service with its notification) only while a job runs; stops at Completed, logout, when an admin ends the job, on `location.rejected` NOT_IN_PROGRESS; never switches jobs by itself; "Try sharing again" after a GPS problem.
- `VisitOutbox` (a file on the phone): steps tapped offline keep their tap time and position and go in order when back online (retried every 30 s, after a restart too); points kept offline go in a batch; steps the server refuses are shown, not lost.
- R13 Care note (text + BP / pulse / SpO₂ / temperature / sugar), R14 Collect balance (cash / UPI, hidden when the balance is ₹0), R15 Totals.
### Patient app
- P18 booking: the visit code card (until that step is done), current step, "Track live".
- P19 Live visit: OpenStreetMap with the partner's marker and the home / hospital, ETA (minutes or hours), current step, call, Share trip (copies the link), SOS.
- P20 Completed: "Pay ₹X to your companion / nurse" (hidden when paid in full), rating with tags, report a problem and WellWish's replies.
- Reports: care notes open as a sheet with the vitals.
### Admin panel
- **Live map** (`/live`): jobs in progress on a map (both partner numbers), the SOS console (acknowledge / resolve with a note; the alarm repeats on every admin page until acknowledged), the visit alerts with acknowledge.
- **Booking page → Visit card:** steps with times and flags, the visit-code wait banner, **Mark step** for the partner (reason), balance collected, the saved route on a map; updates live.
- **Support → Tickets** (reply, close) and **Support → Reviews** (hide / show with a reason).
- Live alerts across the panel: SOS alarm, ticket.new, visit alerts (FAR_STEP not sticky); far-step distances in km.
- **Sign-in:** "Trust this browser for 30 days" box, "No phone? Email me a code" (v2.18, with the address it went to and a resend countdown) or "use a recovery code" (then the new QR code), the 10 codes shown once after 2FA setup (copy / download, "I've saved them"), header menu **Recovery codes (n left)** (new codes with the password), warnings when an admin has no codes or is the only Super Admin.
- **Settings → Test messages** (developer request, 12 Oct 2026; local development only): the last 50 SMS and emails of the hour that the dev backends kept (login and visit codes big and copyable, SOS alerts, partner email codes), refreshed every 5 s.

## API changes
| Method | Path | Notes |
|---|---|---|
| POST | `/v1/partner/bookings/:id/steps` | `{ step, lat?, lng?, accuracy?, at?, otp?, note?, vitals? }`; 422 `WRONG_OTP` {triesLeft, retryAt?}, 409 `OTP_WAIT` {retryAt}, 409 `TOO_EARLY_TO_START` {from} |
| POST | `/v1/partner/bookings/:id/calls` | logged call attempt (needed for "Patient not available") |
| POST | `/v1/partner/bookings/:id/balance` | `{ amountPaise, method: CASH \| UPI }` |
| POST | `/v1/partner/bookings/:id/track-batch` | offline points (phone time) |
| POST | `/v1/partner/bookings/:id/sos` ; `/v1/patient/bookings/:id/sos` | SOS with position |
| GET | `/v1/partner/totals` ; `/v1/partner/reviews` | §6.13 |
| GET | `/v1/patient/bookings/:id/live` | latest point, ETA, step |
| POST | `/v1/patient/bookings/:id/share-link` | `{ url, expiresAt }` |
| GET | `/v1/public/track` | header `X-Share-Token` |
| POST | `/v1/patient/bookings/:id/review` ; `/report-problem` | |
| POST | `/v1/admin/bookings/:id/steps` | mark a step for the partner (reason, logged) |
| GET | `/v1/admin/live` ; `/v1/admin/bookings/:id/track` | live jobs; saved route |
| GET / POST | `/v1/admin/sos` ; `/sos/:id/ack` ; `/sos/:id/resolve` | |
| GET / POST | `/v1/admin/tickets` ; `/tickets/:id/reply` ; `/tickets/:id/close` | |
| GET / POST | `/v1/admin/reviews` ; `/reviews/:id/hide` ; `/reviews/:id/show` | |
| GET | `/v1/admin/dev/outbox` | local development only (404 elsewhere), `settings.manage` |
| POST | `/v1/admin/auth/email-code` | v2.18: `{ challengeToken }` → `{ challengeToken, emailMasked, resendAfterSeconds }`; 429 `EMAIL_CODE_TOO_SOON` / `EMAIL_CODE_RATE_LIMITED` |
| POST | `/v1/admin/me/recovery-codes/saved` | v2.17: "I've saved them" → the staff member; `StaffMeOut.recoveryCodesSaved` |
| — | errors `OTP_REQUIRED` (422), `BALANCE_NOT_DUE` (409), `BALANCE_TOO_HIGH` (422, `duePaise`); `track-batch` for another partner's booking 404 | v2.17, second deep check |
| POST | `/v1/admin/auth/login` | v2.16: `step: SIGNED_IN` + `signedIn` tokens in a trusted browser |
| POST | `/v1/admin/auth/totp` | v2.16: `trustBrowser`; `recoveryCodes` right after 2FA setup |
| POST | `/v1/admin/auth/recovery` | v2.16: recovery code → TOTP_SETUP; 401 `RECOVERY_CODE_INVALID` |
| POST | `/v1/admin/me/recovery-codes` | v2.16: `{ password }` → 10 new codes; 422 `WRONG_PASSWORD` |
| — | `StaffMeOut.recoveryCodesLeft`, `onlySuperAdmin` | v2.16 |
| — | `VisitOut` (`otpRetryAt` replaces `otpLocked`), `BookingDetailOut.jobOtp`, `review`, `tickets`, `AdminBookingEventOut.step` | |
| WS | `location.update` / `location.rejected` (partner); `booking.location` (patient); `job.location`, `job.step`, `sos.new`, `sos.updated`, `ticket.new`, `alert.acked` (staff) | |

OpenAPI regenerated: yes (`.\ww.ps1 openapi`, `.\ww.ps1 gen-clients`).

## Database changes
| App | Migration | What it does |
|---|---|---|
| bookings | 0005_job_otp_enc | `bookings.otp_enc` (encrypted copy of the visit code) |
| bookings | 0006_otp_retry_at | `bookings.otp_retry_at` (wrong-code wait) |
| assignments | 0003_visit_alerts | alert kinds NO_LOCATION, FAR_STEP, MOCK_GPS, OTP_LOCKED, NO_SHOW, NOT_COMPLETED |
| documents | 0003_care_notes | `patient_documents.text`, `vitals`; type CARE_NOTE; file optional |
| tracking | 0001_initial | `booking_tracks` (polyline, points, km, start / end) |
| safety | 0001_initial | `sos_events`, `share_links` |
| reviews | 0001_initial | `reviews`, `support_tickets` |
| notifications | 0005_visit_templates, 0006_ticket_reply_template | Phase 8 message texts (en / hi / or) |
| assignments | 0004_otp_wait_label | alert label "Visit code wrong 4 times (partner waiting)" |
| staff | 0003_signin_recovery | `staff_recovery_codes`, `staff_trusted_browsers` (v2.16) |
| staff | 0004_recovery_codes_saved | `staff_users.recovery_codes_saved_at` (v2.17) |
| notifications | 0007_job_completed_paid_template | "Visit completed" without "Pay ₹0" (en / hi / or) |

## Tests
| Check | Command | Result |
|---|---|---|
| Backend tests | `.\ww.ps1 test` | **569 passed** (Phase 8: visit 16 + checks, tracking 12, safety 3, reviews 4, assignments deadline / alerts, sign-in recovery 22 incl. the emailed code, second deep check 10, companion journey 1) |
| Lint / types | `.\ww.ps1 lint` | ruff, format, mypy clean |
| Flutter | `.\ww.ps1 check` (analyze + test) | partner **45**, patient 57, ww_core **22**, ww_ui 15, ww_auth 9, ww_l10n 6: all pass |
| Admin | `npm run lint`, `npm run build` | clean |
| Everything | `.\ww.ps1 check` | **All checks passed** (12 Oct 2026, ~18:20, after the second deep check and the emailed code: ruff, format, mypy, pytest, migrations, flutter analyze + test, admin lint + build; then only the dev-only sign-in hint changed: type-check and lint clean) |

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| On a real Android phone (partner) with the patient app on the emulator: a full hospital visit and a nurse home visit with a care note | **Hospital visit WW-10009** on the developer's Samsung M31 (Rina): On the way → Reached → Picked up (code from the family's app) → At the hospital → Visit done → Dropped home → Completed, ₹400 UPI recorded, all steps with GPS. **Nurse visit WW-10013** (Priya): On the way → Reached home → visit code → care note "Injection given in left arm…" with BP 130/85, pulse 78, SpO₂ 97 → Care done → Completed, ₹240 UPI; the care note shows in the family's Reports with the vitals. *Deviation: the nurse visit ran on the emulator, because the phone was disconnected by then.* | ✅ |
| The family's live map moves during the trip and stops at Completed | WW-10009: the family's map on the emulator followed the phone (21 points, route saved) and stopped at Completed. | ✅ |
| Wrong visit codes: after 4, the partner waits 5 min (then 10, 20…) and the admin is alerted | Live on the emulator (Asha, WW-10005 at "Delivered", 12 Oct): codes 1–3 showed "3 / 2 tries left", then "One more wrong code and you'll have to wait 5 minutes"; the 4th wrong code gave "Try again at 12:39 PM" and the OTP_LOCKED alert at the same second; a try during the wait was refused with the same time; the 5th wrong code after 12:39 gave "Try again at 12:49 PM" (10 min). Tests `test_wrong_codes_bring_a_growing_wait…`, partner `visit_test`. | ✅ |
| The partner's totals show the job and the balance recorded | Phone (Rina) after WW-10009: Totals showed the job and ₹400 (UPI); WW-10010 ₹400 cash and WW-10013 ₹240 UPI recorded. | ✅ |
| SOS shows the alarm in the admin panel within seconds | WW-10010: SOS pressed in the partner app (emulator) at 12:17:00 → SOS OPEN with position, SOS_ALERT SMS to the emergency contact in the dev outbox; the developer's admin panel had it and acknowledged it at 12:22:28 (audit log `sos.acknowledged`); resolved with a note on the Live map at 17:31. | ✅ |
| With the network off for a few steps, they sync correctly when it comes back | WW-10010 on the emulator (the API stopped to cut the network, since the device's settings aren't changed by Claude): "At the hospital" and "Visit done" tapped at 12:07:37 and 12:08:23 → "Waiting for network: 2 steps to send" → API back → both arrived in order at 12:09:56–57 with their original tap times and positions. | ✅ |

## Admin panel checked in the browser (12 Oct 2026, 17:20–18:41)
In the browser pane signed in as the dev Super Admin (the developer gave the dev admin's password in chat; they will change it), each result checked in the database and the audit log:
- **Trust this browser**: signed in with the box ticked (`staff.browser_trusted`); after the 30-minute idle sign-out, the password alone signed in (`staff.login` `via_trusted_browser`).
- **Settings → Test messages**: a login code sent to an unused number appeared by itself within seconds ("SMS (1)", Login code).
- **Live map → SOS WW-10010 → Resolve** with a note: RESOLVED at 17:31; the SOS box went away.
- **WW-10005 → Visit card → Mark "Delivered", then "Completed"** with reasons: COMPLETED, both steps by staff on the timeline.
- **Support → Reviews → WW-10009 → Hide, then Show again** (reasons): VISIBLE, `review.hidden` + `review.shown`.
- **Support → Tickets → WW-10009 → Reply, then Close**: 1 reply, the family's inbox got TICKET_REPLY, CLOSED at 17:35.
- **Recovery codes**: 10 made (password asked); the dialog can't be closed until "I've saved them"; the developer saved them and ticked it (`staff.recovery_codes_saved`, 17:48).
- **"No phone? Email me a code"** (v2.18), by the developer in their own Chrome: the code emailed at 18:40:09 (read with `.\ww.ps1 manage mail_outbox …`, since this PC sends no email), signed in at 18:40:44 (`staff.login` `email_code`).
- Found on the way and fixed: a console warning from the new codes dialog (antd `maskClosable` → `mask.closable`); a dev-only note on the sign-in page with the command that prints the emailed code (this PC sends no email; the code isn't readable from the panel when signed out). WW-10005's saved route answers 404 because it never had a location point (expected).

## Regression run on the emulator after the second deep check (12 Oct 2026, 18:50–19:01)
The live exit-criteria runs above used the partner app from before the second deep check, so a fresh partner build (every fix) was installed on the emulator and run again. Test bookings **WW-10014** and **WW-10015** were made through the patient API (test patient), paid with the test payment stand-in (the same fake Razorpay as the automated tests; their order ids look like `order_000001` / `order_000006`, dev data only) and assigned to Asha by the admin service (the browser pane couldn't be clicked while hidden).
- Opening the new build: still signed in as Asha (session restored with the per-partner queue); the offer showed with its timer; accept opened the full job.
- On the way → "Sharing your location"; Reached → the 15-minute timer.
- Wrong visit codes: "3 tries left" … the 4th → "Try again at 6:58 PM, or call WellWish"; **after closing the sheet the job panel showed the wait and "Call WellWish"** instead of the step button (fix). OTP_LOCKED alert raised once.
- The admin marked "Picked up": the partner app moved on by itself and **the OTP_LOCKED alert closed by itself** (fix).
- **Offline**: with the API stopped, "At the hospital" and "Visit done" → "Saved on your phone", "Waiting for network: 2 steps to send"; API back at 18:55:25 → both arrived in order with their tap times 18:54:38 / 18:54:57 (per-partner queue).
- Dropped home → Completed: **no "Collect balance" screen** at ₹0 (fix); the location notification went away; the family got **"…is done (WW-10014). How was Asha Behera? Rate the visit."** with no "Pay ₹0" (JOB_COMPLETED_PAID, fix).
- **Hindi**: with Asha's language set to Hindi, the app and **the location notification were in Hindi** ("इस विज़िट के लिए आपकी लोकेशन मरीज़ के साथ शेयर हो रही है") (fix).
- **Logout during a job**: the notification and the foreground service went, and the app made **no calls in the next 45 s** (no retry loop) (fix). Signing in again (test code) worked.
- Test data put back: Asha's language English, WW-10015 finished by the admin.
Not run here: the GPS-only fallback (needs a real phone that refuses "Location Accuracy"), the admin booking page's live wrong-code banner (the browser pane was hidden), a second partner on the same phone and the nurse's empty care note (both covered by the new automated tests).

## Screens
Screenshots in `docs/phases/img/phase-08/`: `r12-wrong-code-wait-10-min`, `p19-live-visit-waiting-for-location`, `p20-completed-rated`, `p20-problem-reported`, `p-reports-care-note-with-vitals`. (The phone-test screens were watched live and not saved.)

## Deep check (10 Oct 2026)
Three independent reviews (backend, admin panel, Flutter apps) found **35 problems**; **29 are fixed with tests**, the rest are under *Known issues*. The main ones:
- **Family live map** ignored the partner's live points (it moved only every 30 s): the server now sends positions in the shape the app reads.
- **Location sharing** now stops at logout, when WellWish ends the job and when the job is over; never switches jobs by itself; "Try sharing again" after a GPS problem.
- **Offline steps:** new taps wait behind the kept ones, in order; kept steps survive a restart and are retried every 30 s; refused steps are shown, not lost silently.
- **Wrong codes sent at the same moment** could get past the limit: counted under the booking's row lock.
- **SOS:** a double press no longer sends a second alarm and SMS; resolving twice no longer overwrites the first admin's note; the admin alarm repeats until acknowledged, also for an SOS raised while the panel was closed.
- **Admin:** alert banners close everywhere once acknowledged; visit alerts and the map show both partner numbers; the Visit card updates live.
- **Privacy:** account erasure now also clears positions, vitals, routes, SOS positions, share links and review comments; the share link's secret no longer appears in server logs.
- **Points and timestamps:** bad positions, wrong phone clocks and points for jobs that are over are refused.
- **"On the way" days early** stopped the family cancelling or moving the booking → developer decision: only from 2 h before pickup.

### Found during the live checks (11–12 Oct) and fixed
- GPS-only gave no points indoors (2.5 min silence at a hospital) → Android's fused location with GPS-only as the fallback.
- Indoor points too rough to use (~300 m) raised a false "No location" → they now count as "the phone is on".
- Long ETAs showed as "245 min" → hours and minutes.
- Five wrong codes locked the step for good → growing wait (developer decision).
- Same-day bookings were "past the deadline" the moment they were paid → 30 minutes after payment (developer decision).
- Families paid only a booking fee → full price in the app (developer decision; services' booking fee = total price; "pay your companion after" and "collect balance" hidden at ₹0).
- The partner app crashed into an unhandled socket error when the API was down → handled.
- A step tap waited 10–15 s for a fresh GPS fix indoors → reuses the last shared point (≤ 5 min old) while sharing.
- The job screen's status badge overflowed next to long names → moved under the name.

## Second deep check (12 Oct 2026, afternoon)
Asked by the developer before closing ("hard check deeply"). The code changed after the first deep check (11–12 Oct: growing wait, full price, assign deadline, fused location, sign-in recovery, Test messages) was reviewed again by three independent reviewers (backend security, backend visit logic, admin panel + apps). Each finding was checked against the code before fixing; tests were added for every backend fix (`apps/bookings/tests/test_visit_second_check.py`, `apps/staff/tests/test_signin_recovery.py`).

**Admin sign-in recovery (8.16)**: no way past the password or the 2FA was found. Fixed:
- After a recovery code the new secret was saved on the account as "first setup", so **someone with the password could take over the half-done setup**, and a setup left half-done made the account password-only → the new secret now lives only in the setup step (encrypted) until a code from it is confirmed; the old authenticator stops at once.
- 2FA and recovery tries sent at the same moment could get past the 5-try limit → checked and counted under the admin's row lock.
- Recovery codes could be lost unseen (page reloaded on the codes screen, or the new-codes dialog closed with ✕) → codes count as saved only after "I've saved them"; otherwise a warning with "Make new codes"; the dialog can't be closed before.
- "Trust this browser" sat below the 6-digit code, which is sent at the 6th digit, so it was never ticked in time → moved above the code.
- A wrong recovery code made the panel refresh the session (and could count twice) → the recovery call is a sign-in call like the others.
- Two "new codes" requests at once could leave 20 valid codes → row lock.
- The audit log couldn't tell a code sign-in from a trusted-browser one → `two_factor` / `via_trusted_browser` + `staff.browser_trusted`.
- `reset_staff_2fa --new-password` through `ww.ps1` has no terminal for the hidden prompt → it refuses and prints the command to run (CLAUDE.md updated).

**The visit (backend)**. Fixed:
- From the **43rd wrong visit code** the wait calculation overflowed: an error that rolled the count back, so the wait stopped working → capped before calculating.
- A missing or short code counted as a wrong try → 422 `OTP_REQUIRED`, not counted.
- The balance could be recorded when nothing was due (full price) or above what was due, and added to the totals → 409 `BALANCE_NOT_DUE`, 422 `BALANCE_TOO_HIGH`.
- Every full-price visit ended with **"Pay ₹0 to Rina…"** → its own message (JOB_COMPLETED_PAID, en / hi / or); amounts in Indian format.
- An acknowledged "No location" came back every minute → not again for the same silence.
- "Past the deadline" stayed open after a partner accepted or the time changed, and "wrong codes" after the step was done → they close by themselves (and the banners close on every admin screen).
- Points for another partner's booking answered 200 → 404.
- The test "an unconfirmed new time escalates at the deadline" failed when run around 6 PM IST (it used the plain "6 PM the evening before", not the 30 minutes after a time change that the sweep adds) → it uses the sweep's own deadline. The app was right; only the test depended on the hour.

**Admin panel**. Fixed: the booking page shows the wrong-code wait live (reloads on its alerts, after a reconnect, and every 30 s while at the door); SOS / visit banners no longer stay on the sign-in screen after sign-out; the dev-only Test messages page and menu fail closed on a server build without `NEXT_PUBLIC_APP_ENV`, and stop polling after a 404 or in a hidden tab.

**Partner app and location**. All 9 confirmed and fixed, each with a test that failed on the old code:
- **GPS-only fallback never really switched** (the plugin handed back the same failed fused stream when asked from inside its error), so a partner who said no to Google's "Location Accuracy" shared nothing while the app said "Sharing" → the fused stream is let go first, then GPS-only is asked once (never back and forth). *Needs a real phone to see: refuse "Location Accuracy" during a job and check points keep coming.*
- Stopping during the location-permission dialog (e.g. an admin ended the job) left the foreground service running → nothing starts once stopped.
- After a wrong visit code the panel didn't show "Try again at…" until reopened → the job reloads.
- A nurse's empty care note could be kept offline and refused later → checked in the app too.
- After logout the offline queue retried every 30 s for ever, and a second partner on the same phone could send or see the first one's kept steps → one queue per partner, nothing sent or retried after logout; the first partner's steps wait for their next login.
- A step tap could reuse another job's (or a fake / rough) last position → only this job's real points.
- Points kept during an upload were deleted with the uploaded ones → only the uploaded ones go.
- The location notification could show English to a Hindi or Odia partner → set in the partner's language wherever sharing starts.
- "Collect balance" opened after a Completed kept offline → only once sent; the new refusals (nothing due / more than due) have their own messages in en / hi / or.

**Companion sign-up to first job (asked by the developer)**: a new test `apps/kyc/tests/test_partner_journey.py` runs the whole path with no shortcuts: a new number logs in with its SMS code, chooses Companion, verifies the second phone and the email, fills the profile, uploads every document and submits; a Verification admin claims the application, opens and approves each document and approves the partner; the partner takes the selfie and turns on "Available today"; an Operations admin sees them in the suggestions and assigns a paid booking; the partner accepts and the family sees their companion. **Passes.** (Phase 3's own tests and its live checks cover the screens.)

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| Tested with one real phone (partner) + the emulator (patient) instead of two phones | Only one phone available | yes (10 Oct 2026) | PHASES 8 exit criteria |
| "On the way" only from 2 h before pickup | A partner could start days early and block cancel / reschedule | yes (10 Oct 2026) | v2.15 §6.11 |
| Wrong visit codes: growing wait (5, 10, 20, 40, max 60 min) instead of a lock after 5 | "If it locks, it's difficult for the companion and the user" | yes (12 Oct 2026; the 60-min cap confirmed the same day) | v2.15 §6.11 |
| Full price paid in the app; partners paid outside the app until a payout feature | Developer: "patient pays 500 to book; on cancel we refund 50%" | yes (12 Oct 2026) | v2.15 §1.2 |
| Late bookings get 30 min after payment before "past the deadline" | Same-day bookings were red at once | yes (12 Oct 2026) | v2.15 §6.17 |
| Job OTP kept as hash **plus an encrypted copy** | The family's app must show it (a hash can't be shown) | yes (confirmed 12 Oct 2026) | v2.15 §6.11 |
| OTP step and care note with vitals need the network; other steps work offline | The code is checked by the server; vitals are medical data | yes (confirmed 12 Oct 2026) | v2.15 §6.11 |
| Care note = a CARE_NOTE document (text + vitals, no file) | Reuses Reports; vitals kept only there | yes (confirmed 12 Oct 2026) | v2.15 |
| ETA = straight line at 20 km/h | No routing key yet | yes (confirmed 12 Oct 2026) | v2.15 |
| New alert kinds (NO_LOCATION, FAR_STEP, MOCK_GPS, OTP_LOCKED, NO_SHOW, NOT_COMPLETED), ack with `bookings.manage` or `live.manage` | Exact kinds weren't specified | yes (confirmed 12 Oct 2026) | v2.15 |
| Share link = a small Django page `{SHARE_LINK_BASE_URL}/t/#token`, 12 h max, copied to the clipboard | No web app for families | yes (confirmed 12 Oct 2026) | v2.15 §6.15 |
| Review tags (5 good, 3 bad), one review per booking, hidden never deleted; balance correctable 24 h; report a problem within 24 h; one open SOS per booking and side | Details weren't specified | yes (confirmed 12 Oct 2026) | v2.15 |
| Fused location (GPS + Wi-Fi + towers) with GPS-only fallback; rough points count as "phone on" | Phone test indoors | yes (phone test, 12 Oct 2026) | v2.15 |

## Known issues and follow-ups
- **Emulator only:** the Android emulator's Google location service never delivers the continuous location stream to the partner app ("location delivery blocked"); one-shot positions for steps work. The real phone delivers points → none (emulator limitation).
- **Old bookings never close by themselves:** WW-10005 / WW-10008 (accepted on 10 Oct, before visit codes existed) have no visit code and stay "Partner assigned / In progress"; Home's "Next booking" and Upcoming still show past ACCEPTED bookings → medium → Phase 9 (auto-close / no-show sweep). Dev data: finish WW-10005 by "Mark step" in the admin panel.
- An app build older than the API it talks to can fail to read a changed response (seen: the 09:56 patient build stuck on a booking after `otpLocked` became `otpRetryAt`) → before launch nothing to do; after launch, use the existing "app min versions" setting whenever a response field is removed → Phase 10 release checklist.
- P20 still says "Pay ₹X to Rina" after the partner recorded the balance → low → Phase 9.
- The payment result screen keeps "We're assigning your partner" after a partner accepted → low → Phase 9.
- The partner's review card doesn't show the tags → low → Phase 9.
- The balance can be entered in whole rupees only → low → Phase 9.
- A live point and a catch-up batch arriving at the same moment could rarely lose a point (Redis track write race) → low → Phase 9.
- A socket that died silently can lose up to ~50 s of points before the app notices → low → Phase 9.
- A night job that crosses midnight resumes sharing only when its job screen is opened (Home lists today's jobs) → low → Phase 9.
- Redis rate-limit keys contain the full phone number (storage, not logs) → low → Phase 9 (hash them).
- Push notifications still wait for the Firebase key; MSG91 templates JOB_OTP and SOS_ALERT need DLT approval (KEYS-AND-ACCOUNTS).
- **Second deep check, still to see on a real phone:** the fused → GPS-only switch, and no location service after a stop during the permission dialog (fake location platform in tests only) → next phone test. (The Hindi notification was seen on the emulator, 12 Oct.)
- **Hindi / Odia gaps seen in the emulator run:** the hints of the optional documents ("If you will drive the patient", "If you have one") come from `required_documents.help`, which has no Hindi / Odia column; a member's language shows as the stored word ("Odia") → Phase 9 (9.1 translations).
- Wrong visit codes raise the admin alert at the first wait only; the later waits (10, 20… min) show on the booking page (it looks again every 30 s at the door) without a new banner → low, by design for now.
- Steps kept offline by builds before 12 Oct sit in the old shared file, which is no longer read (dev phones only) → none.

## How to run and demo this phase
- `.\ww.ps1 up`; admin: `npm --prefix apps/admin_web run dev` (sign in with `DEV_QA_ADMIN_*` from `backend/.env`).
- Apps: `flutter run --flavor dev -t lib/main_dev.dart` in `apps/partner_app` and `apps/patient_app`. For a phone over Wi-Fi: `flutter build apk --debug --flavor dev -t lib/main_dev.dart --dart-define=API_BASE_URL=http://<PC Wi-Fi IP>:8000`.
- Test accounts: patient `+91 90000 00001`, partners Asha `+91 90000 00003` and Rina `+91 90000 00005` (OTP `123456`); any other number (e.g. Priya, nurse): admin → Settings → **Test messages** shows the code (or `.\ww.ps1 manage sms_outbox <number>`).
- Demo: book for within 2 h (Admin → Settings → Minimum notice 0 while testing) → assign → partner accepts → On the way → family taps Track live → steps (visit code from the family's booking screen) → Completed → record the balance → family rates. SMS (JOB_OTP, SOS_ALERT): admin → Settings → Test messages.

## Next phase
**Phase 8B — Temporary partner** (designed and confirmed: ARCHITECTURE v2.17 §6.19, PHASES 8B; the family isn't told, normal cancel rules), then Phase 9 — Polish and hardening, which picks up the known issues above. A partner earnings / payout feature is to be planned as its own phase.
