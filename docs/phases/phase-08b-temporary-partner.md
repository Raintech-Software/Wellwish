# Phase 08B — Temporary partner · Completion report

| Item | Value |
|---|---|
| Started | 12 Oct 2026 |
| Completed | 13 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice) |
| Architecture version used | v2.17 (§6.19), v2.18, v2.19 (deep check) |

## Summary
When every partner is busy, an admin can now **temporary-assign** a booking to a person they phoned and whose ID they checked. The booking is accepted at once; the person gets an SMS with the app link, logs in to the normal Partner app with an SMS code, sees **only that job**, takes a selfie before "On the way" and does the visit like any partner. Their access ends at once if the booking is cancelled, unassigned or moved, when an admin ends it, otherwise 1 hour after Completed. The family sees them like any partner; only the admin panel says "Temporary partner".

## Tasks
### Backend
- [x] 8B.1 Partner statuses `TEMPORARY` and `TEMP_ENDED` (through `transition()`), table `temporary_id_checks`, assignment kind TEMPORARY, upload purpose for the ID photo, migrations.
- [x] 8B.2 `POST /v1/admin/bookings/:id/temporary-assign` and the ID card / ID photo endpoints.
- [x] 8B.3 Access: only their booking; selfie before "On the way".
- [x] 8B.4 End of access (cancel, unassign, time change at once; 1 h after Completed); registering for real later.
- [x] 8B.5 "Temporary" only on the admin side; bookings filter; never in the candidates; normal cancel rules.
### Admin panel
- [x] 8B.6 Temporary assign form, tag, ID card, filters. Used in the browser (a real submit with the ID photo upload, the photo view, end access, "changed meanwhile").
### Partner app
- [x] 8B.7 Temporary home (today's selfie asked first, above the job), TEMP_ENDED = not registered, JOB_OVER message; English, Hindi and Odia. Done on the emulator.
### Patient app
- [x] 8B.8 No new screen: a temporary partner shows like any partner. Checked on the emulator.

## What was built
### Backend
- **partners:** statuses `TEMPORARY`, `TEMP_ENDED` with the moves `temp_end`, `temp_assign`, `register` (TEMP_ENDED → REGISTERING); table `temporary_id_checks` (ID type, last 4 only, ID photo key, nursing registration number, reason, who checked and when, ended at / why; one open check per partner); `make_temporary` (the number rules; the user row locked so two admins typing the same new number are served one after the other; a person whose job is over is reused at once, even within the hour after Completed; a selfie from an earlier day is no longer their photo, today's stays); `end_temporary(partner, booking, reason)` (only that booking's access; partner-app sessions revoked with the new reason `JOB_OVER`; a patient account on the same number keeps working); `end_temporary_sweep` (beat, every 5 min: 1 h after Completed or patient-not-available; safety net for cancel / unassign; one failing row doesn't stop the others); a selfie of a temporary partner becomes their photo.
- **assignments:** offer kind `TEMPORARY`, accepted at once (response "accepted by phone", no 2-minute timer, no offer message); `temporary_assign` under the booking lock with `expectedAssignmentId` (an open offer is withdrawn); hooks: unassign, cancel and a time change end the access; `end_temporary_access` (an admin ends it now; a booking not finished gets a PARTNER_UNAVAILABLE alert); a booking with a temporary partner counts as having its partner (queue, problem tag, escalation); `partner.temp_ended` refreshes open booking pages (`queue.changed`).
- **bookings:** a time change always releases a temporary partner (no "confirm the new time"); "On the way" needs today's selfie for a temporary partner (409 `SELFIE_REQUIRED`); admin booking list and detail carry `temporaryPartner`, list filter `temporary`.
- **API gate (`common/auth.py`):** a `TEMPORARY` partner opens only `/me/selfie`, `/jobs/{their booking}` (+ documents) and `/bookings/{their booking}/steps|calls|balance|track-batch|sos|patient-not-available`; another booking answers **404**, everything else 403 `PARTNER_NOT_APPROVED` (registration routes answer 409 `ROLE_LOCKED` / `NOT_EDITABLE`). `/partner/me` has `temporaryBookingId` and `selfieToday`.
- **notifications:** SMS `TEMP_PARTNER_JOB` (app link, booking code, date and time); DLT template id setting `MSG91_TEMPLATE_TEMP_PARTNER_JOB` (KEYS-AND-ACCOUNTS, `backend/.env.example`).
- **files:** upload purpose `temp_partner_id` (photo or PDF, 10 MB, admin with `bookings.manage`).
### Admin panel
- **Temporary assign** dialog (booking page next to Assign, and the queue): mobile number (+91, 91 or 0 in front accepted like the server), name, gender, ID type, last 4 (a pasted full number keeps only its last 4), ID photo upload, nursing registration number for a nurse booking, reason, the "I've called this person and checked their ID against the photo" tick; a clear message for each refusal (partner or applicant number with its status, busy on another booking, the family's own number, who has the booking now). It sends the offer the admin saw when opening it; if the booking changes meanwhile it says so and won't submit (the same fix for the Phase 7 Assign dialog).
- Booking page: "Temporary partner" tag and the **ID card** (ID type and last 4, nursing registration, who checked and when, why, app access and when it ended, the selfie of this job, **View ID photo** for `bookings.manage` / `partners.review` / `partners.add`: each view logged, opened so pop-up blockers allow it; **End app access now** with a reason). The card updates live.
- Bookings list: filter "Temporary partner / No temporary partner" and a tag; Partners list: statuses Temporary / Temporary (ended) in the filter and tags; the alert and queue tag now say "Partner unavailable: reassign" (suspended, deactivated or temporary access ended).
### Partner app
- **Router:** `TEMPORARY` opens the new **Your WellWish job** home (`/my-job`); only their own booking's job and visit screens open (any other job id goes back home). `TEMP_ENDED` gets the "Become a WellWish partner" role choice, like anyone not registered; choosing a role starts a real registration. Given a temporary job again while the app is open, the live message (or a `ROLE_LOCKED` answer on the role choice) reloads `/me` and the job opens by itself.
- **Temporary home** (`features/temporary/temporary_home.dart`): logo bar with notifications and logout (asks first: it stops the live location mid-visit), "Your WellWish job" with a short explanation, then the normal job screen (steps, visit code, calls, health notes, live location, SOS, balance) with **today's selfie asked first, above the job** on the visit day (one selfie screen however fast the taps). The job screen was split so both homes use the same `JobDetails`. `selfieToday` from `/partner/me` means a restart doesn't ask for the selfie again.
- **"On the way" without a selfie** (409 `SELFIE_REQUIRED`): opens the selfie, then back to the job; a double tap sends the step once. Sent offline and refused later for the selfie: location sharing stops and the selfie is asked again.
- **End of access:** a revoked session with reason `JOB_OVER` (on the socket, or found by the next call) logs out at once and the login screen says "Your WellWish job is over. Thank you!"; location sharing stops and can't restart after logout. Other revokes still say "your session ended".
- **Texts:** `tempHomeTitle`, `tempHomeBody`, `tempSelfieBody`, `tempSelfieSaved`, `tempJobOver` in English, Hindi and Odia.
### Patient app
- No change (a temporary partner comes in the same `partner` block as any partner).

## API changes
| Method | Path | Notes |
|---|---|---|
| POST | `/v1/admin/bookings/:id/temporary-assign` | `TemporaryAssignIn` → `AssignmentStateOut`; 409 `PHONE_IS_PARTNER` {status} / `TEMP_PARTNER_BUSY` / `TEMP_PARTNER_IS_FAMILY` / `OFFER_CHANGED` / `NOT_ASSIGNABLE`; 422 `ID_NOT_CHECKED` / `INVALID_PHONE` / `INVALID_ID_LAST4` / `NURSING_REG_REQUIRED` / `FILE_NOT_FOUND` |
| GET | `/v1/admin/bookings/:id/temporary-partner` | the ID card (`bookings.view`), the booking's own partner only; 404 none |
| GET | `/v1/admin/bookings/:id/temporary-partner/id-photo` | a 5-minute link (`bookings.manage`, `partners.review` or `partners.add`); logged `temporary.id_viewed`; the real file type |
| POST | `/v1/admin/bookings/:id/temporary-partner/end` | `{ reason }` (`bookings.manage`): their app access ends now; PARTNER_UNAVAILABLE alert if not finished; logged `temporary.access_ended`; 409 `NOT_TEMPORARY` |
| GET | `/v1/admin/bookings?temporary=true\|false` | filter; rows and detail have `temporaryPartner` |
| POST | `/v1/admin/files/upload-url` | purpose `temp_partner_id` |
| GET | `/v1/partner/me` | `temporaryBookingId`, `selfieToday`; `partnerStatus` TEMPORARY / TEMP_ENDED |
| POST | `/v1/partner/bookings/:id/steps` | 409 `SELFIE_REQUIRED` for a temporary partner at "On the way" |

OpenAPI regenerated: yes (`.\ww.ps1 openapi`, `.\ww.ps1 gen-clients`).

## Database changes
| App | Migration | What it does |
|---|---|---|
| partners | 0003_temporary_partner | statuses TEMPORARY / TEMP_ENDED; table `temporary_id_checks` |
| partners | 0004_temporary_end_by_admin | end reason BY_ADMIN |
| assignments | 0005_temporary_partner | offer kind TEMPORARY |
| accounts | 0004_job_over_revoke_reason | session revoke reason JOB_OVER |

## Tests
| Check | Command | Result |
|---|---|---|
| All checks | `.\ww.ps1 check` | all 10 steps pass (run again after the deep-check fixes) |
| Backend tests | (in check) | 593 passed in the full check after the deep-check fixes; 594 after one last fix (the same-day selfie stays the photo), with ruff, format, mypy and the migrations check again (587 before the deep check) |
| Lint / types / migrations | (in check) | ruff, format, mypy clean; no missing migrations |
| Flutter | (in check) | analyze clean; tests: partner app 57, patient app 57, ww_auth 9, ww_core 22, ww_l10n 6, ww_ui 15 |
| Admin | (in check) | lint clean, build OK |
| Contract | `.\ww.ps1 openapi`, `.\ww.ps1 gen-clients` | OpenAPI and both generated clients identical to a fresh export (before the deep-check fixes); regenerated after them |

New: `apps/partners/tests/test_temporary.py` (25 tests: statuses, the ID check, the assign and every number rule incl. a rejected applicant, the open offer withdrawn, a nurse booking, the ID card and photo (not for view-only roles), what a temporary partner can open, the selfie, cancel / unassign / time change / 1 h after Completed, after the end, a patient on the same number, the admin-only flag and filter; deep check: the queue and escalation, an admin ending access mid-visit, reuse right after Completed and a late end never ending the new job, the selfie of this job on the card, a failing row in the sweep, the same new number from two admins, a reused person never showing an old selfie) and `apps/partner_app/test/temporary_test.dart` (12: one job with the selfie asked first, `SELFIE_REQUIRED`, the server's `selfieToday`, a double tap on the selfie, logout asks first, a new temporary job reaching the role choice, TEMP_ENDED start, JOB_OVER on the socket and on the next call, another revoke, the router rules, the Hindi and Odia texts).

## Exit criteria
Checked live on 12 Oct 2026 against the running stack (Docker), the emulator (`Medium_Phone_API_37.0`, partner and patient dev apps) and the admin panel in the browser, plus the automated tests.

| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| An admin temporary-assigns a booking to a new number; that person logs in to the Partner app with the SMS code, takes the selfie and does the whole visit (visit code, live map) to Completed | **WW-10016** temporary-assigned to a new number (+91 98111 00071, "Test Temp"): accepted at once, SMS `TEMP_PARTNER_JOB` in the dev outbox, audit `booking.temp_assigned`. On the emulator (app data cleared): logged in with the SMS code → "Your WellWish job" → selfie → On the way (notification + location permission) → Reached → Picked up with the family's visit code → At the hospital → Visit done → Dropped home → **Completed**; the server got the live location (11 points, route saved at Completed; 0 km as the emulator stood still. The family's map itself was not watched for this visit; it is the same Phase 8 live view). The admin dialog itself was then used in the browser on **WW-10017** (number, name, gender, ID type, last 4, ID photo upload, reason, tick → "Test Temp has WW-10017"), and "View ID photo" opened the photo and logged `temporary.id_viewed`. | ✅ |
| An approved partner's number, a rejected applicant's number and the booking family's number are refused with a clear message; a patient's number works | Live: Rina's number → 409 `PHONE_IS_PARTNER` (APPROVED); Asha's **alternate** number → `PHONE_IS_PARTNER` (APPROVED); the patient's own number (Sabitri, +91 90000 00003) → `TEMP_PARTNER_IS_FAMILY`; the form without the tick → 422 `ID_NOT_CHECKED`. A patient-only number (+91 98765 43210, "Meera Das") → accepted; she logged in to the partner side, her patient login kept working, and after the unassign her partner token got 401 while her patient token still got 200. A rejected applicant: the dev data has none, so only by `test_numbers_that_are_refused` (REJECTED → `PHONE_IS_PARTNER` {status: REJECTED}). | ✅ |
| 1 hour after Completed (clock moved in the test), and at once after an unassign, the person is logged out and the app shows the "not registered" start; the job no longer opens | **1 h:** after WW-10016 was Completed the sweep changed nothing; with the clock 61 minutes later it ended the access (TEMP_ENDED, check ended COMPLETED); the app logged out with "Your WellWish job is over. Thank you!" and logging in again showed "Become a WellWish partner". **Unassign:** the same person was temporary-assigned again to WW-10017 (an ended temporary partner is reused; returning to the app switched it from the role choice to the job), then unassigned: the app was on the login screen with the thank-you within 3 s; TEMP_ENDED, check ended UNASSIGNED, no open partner sessions; logged in again: `/partner/jobs/WW-10017` and `/partner/offers` → 403 `PARTNER_NOT_APPROVED` (TEMP_ENDED), `temporaryBookingId` empty. Also `test_unassign_ends_access_at_once`, `test_a_cancel_ends_access_at_once`, `test_a_new_time_releases_a_temporary_partner`, `test_an_hour_after_completed_access_ends`. | ✅ |
| The family's app shows the temporary partner like any partner, with nothing saying "temporary"; the admin panel shows the "Temporary partner" tag and the ID card | Patient app on the emulator, WW-10017 with Meera Das: "Your partner — Meera Das, Companion, New partner", "Call Meera", the visit code; the family's booking JSON has no "temporary" anywhere except the booking notes the tester typed. The photo is her selfie. Admin: the tag and the ID card on the booking page, the bookings list tag and filter, the Partners list statuses Temporary / Temporary (ended) and the filter (both people listed as TEMP_ENDED). Also `test_only_the_admin_side_says_temporary`. | ✅ |
| `.\ww.ps1 check` passes | See *Tests* | ✅ |

## Screens
Screenshots in `docs/phases/img/phase-08b/`: `temp-home-one-job` (partner app, the one job), `temp-logged-out-job-over` (right after the unassign), `temp-ended-not-registered-start` (logging in again after the job), `family-sees-a-normal-partner` (patient app, WW-10017). Those four were taken before the deep check. After it: `temp-visit-day-selfie-above-the-job` (the visit-day selfie card above the job; WW-10017's time was moved to that evening in the dev database for this picture only, then put back).

## Deep check (12 Oct 2026)
Three independent read-only reviews (backend and security; Partner app; admin panel, API contract and docs) plus live checks. They found **29 problems** (a few reported by two reviews); **26 are fixed**: with new tests in the backend and the Partner app, and checked in the browser for the admin panel. The other 3 are under *Known issues* (one is intended). The main ones:
- **A temporary-assigned booking still looked unassigned** (high): it stayed in the Unassigned queue as "partner unavailable" and, past the assign deadline, raised an ESCALATION and emailed the Super Admins "still no partner" (it did so for WW-10017 at 8:48 pm). A temporary partner now counts as the booking's partner; once their access ends it shows as "Partner unavailable: reassign". Seen live: WW-10017 left the queue after the fix.
- **The Assign and Temporary assign dialogs sent the live offer id, not the one the admin saw** (high, also in Phase 7's Assign): an offer made by another admin while the dialog was open was silently withdrawn. The dialogs now keep the id from when they opened and say "The booking changed meanwhile" with the button off. Seen live: offering WW-10017 to Rina from another session turned the open dialog's warning on.
- **No way to cut a temporary partner off once the visit had started** (unassign and cancel refuse, suspend doesn't apply): new **End app access now** (logged out at once, PARTNER_UNAVAILABLE alert, audit). Used live in the browser.
- **Ending access wasn't tied to the booking**: a slow sweep for an old booking could end the person's newer job. Now only that booking's access ends.
- **The same person couldn't be reused within the hour after Completed** (409 "busy"): the finished job's access ends and they are reused; a selfie from an earlier day is no longer the photo the new family sees (today's stays, since it counts for "On the way"; found while re-checking on the emulator).
- **The ID photo opened for view-only roles** (Support): now only for those who see partner documents or assign bookings. A PNG was labelled JPEG: the real type now.
- **The ID card lost the selfie the next day** ("today's selfie"): now the selfie of this job. The card also refreshes live when the sweep ends access.
- **A pasted full ID number stored its first 4 digits** as "last 4": now its last 4. Name and reason lengths count trimmed text and phone numbers with 91 / 0 in front are accepted, like the server.
- **Two admins typing the same new number at once got a 500**: now one after the other (the second gets "busy").
- **One failing row stopped the sweep run**: now logged and the others go on.
- **Partner app:** a new temporary job while the app sat on the role choice was missed (now opens by itself); a double tap could open two selfie screens or send "On the way" twice; on the visit day the selfie hid the whole job (address, notes, calls), now it sits above it; an offline "On the way" refused for the selfie kept sharing the location; sharing could restart after logout; logging out mid-visit took one tap (now asks). Re-checked on the emulator with the rebuilt app: assigned while on the role choice, the job opened by itself; the logout question; the visit-day selfie card above the job; a double tap then Back returned straight to the job; the unassign logged the person out with the thank-you.
- **Docs and setup:** ARCHITECTURE §6.19 named the field `idPhotoUploadId` (it is `idPhotoKey`), missed codes and patient-not-available in the sweep; `backend/.env.example` lacked `MSG91_TEMPLATE_TEMP_PARTNER_JOB` (a server built from it would never send the app link).
- Also checked: staging and production settings load (`check --deploy`: only the dev secret key and the known HSTS-preload note), the sweep task registered in the worker (31 runs in 3 h), logs free of phone numbers, OTPs, ID numbers and tokens (file links in the dev log are local stand-ins for S3), the OpenAPI and both generated clients identical to a fresh export, the access gate (anchored paths, other bookings 404, registration closed), sessions revoked at once (no cache) and patient sessions kept.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| The family isn't told the partner is temporary; normal cancel rules | "It's from the company sending them; the company verifies" | yes (12 Oct 2026, confirmed twice) | v2.17 §6.19 |
| The ID photo opens with a logged link (no reason asked), like partner documents | Same rule as KYC documents (§6.3) | yes (13 Oct 2026) | v2.17 §10.3 |
| Session revoke reason `JOB_OVER` (not "account blocked") | The app should say the job is over, not that the account is blocked | yes (13 Oct 2026) | v2.17 §6.19 |
| **End app access now** for an admin (new endpoint and button) | The deep check found no way to stop a temporary partner once the visit has started | yes (13 Oct 2026) | v2.19 §6.19 |
| The ID photo only for `bookings.manage`, `partners.review` or `partners.add` (was `bookings.view`) | "Viewed like partner documents" (§6.19); Support only sees the card | yes (13 Oct 2026) | v2.19 §6.19 |
| Reused within the hour after Completed (that job's access ends then) | §6.19 reuses one "whose job has ended"; it said busy for up to 65 minutes | yes (13 Oct 2026) | v2.19 §6.19 |

## Known issues and follow-ups
- **The family's photo link carries the file's place**: a temporary partner's photo is a selfie (`partners/selfies/…`), a regular partner's is `partners/photos/…`. Only someone decoding the signed link could tell. Low → Phase 9 (opaque file ids in view links).
- **An admin can still mark "On the way" for a temporary partner without the selfie** (the admin step override, logged). Intended; noted for the developer.
- **The app asks for the selfie on the visit's India date**; a visit at 00:30–01:59 can start the evening before (2 h rule) without the card, and then the 409 opens the selfie. A screen left open past midnight shows the card only after a reload. Low (UX only).
- **`ww_core`'s `SessionEndReason` has no "job over"**: the partner app reads the server's revoke reason itself. Low → Phase 9 tidy-up.
- **The rejected-applicant refusal was checked by test only** (no rejected applicant in the dev data).
- **Real SMS**: the TEMP_PARTNER_JOB DLT template must be registered with MSG91, and the Play Store link in it works once the Partner app is published (Phase 10).
- Carried from Phase 8: the GPS-only fallback still to try on a real phone.

## How to run and demo this phase
- Start: `.\ww.ps1 up`, admin panel `npm --prefix apps/admin_web run dev`, emulator `Medium_Phone_API_37.0` with the partner and patient dev apps (`flutter run --flavor dev -t lib/main_dev.dart`).
- Admin: sign in with the dev admin (`DEV_ADMIN_*` in `backend/.env`; "No phone? Email me a code" and `.\ww.ps1 manage mail_outbox <email>` in dev). Open a paid booking that is New (e.g. **WW-10017**) → **Temporary assign** → a new number (e.g. 98111 00071, reused) → fill in, upload any photo as the ID, tick → "Give them this booking".
- The person: Partner app → log in with that number; the SMS code is in admin → Settings → Test messages, or `.\ww.ps1 manage sms_outbox +91…`. "Your WellWish job" opens; on the visit day the selfie is asked first.
- The family: patient app with `+91 90000 00001` (OTP `123456`) → My bookings → the booking shows the partner like any other.
- End: admin booking page → ID card → **End app access now**, or unassign / cancel; or complete the visit and run the sweep an hour later.

## Next phase
Phase 9 — Polish and hardening.
