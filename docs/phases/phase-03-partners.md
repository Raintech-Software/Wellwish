# Phase 03 — Partner registration and verification · Completion report

| Item | Value |
|---|---|
| Started | 8 Oct 2026 |
| Completed | 8 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice so far; asked again at the close) |
| Architecture version used | v2.9 → **v2.10** (changes listed below) |

## Summary
Companions and nurses can now register in the Partner app with two verified phones, a verified email, a profile with a home pin and their documents, and send the application. Admins review each document side by side, approve, ask for changes with reasons, or reject; they can also add a partner by hand, edit, suspend (logs the partner out at once), reinstate and deactivate. Only approved partners reach the work screens; everyone else sees their registration steps or status. Partners get inbox, email and SMS messages for every status change, and expiring documents are reminded, expired and renewed.

## Tasks

### Backend
- [x] 3.1 `apps/partners`: `PartnerProfile`, `PartnerPhone` (PRIMARY / ALTERNATE, verified_at), `SelfieCheck`.
- [x] 3.2 `apps/kyc`: `PartnerApplication`, `PartnerDocument`, `RequiredDocument` (seeded per role from §6.3), and the status state machine.
- [x] 3.3 Registration endpoints: start with a role, alternate phone OTP (must differ), email code (SES adapter, console in dev), profile with a base-location pin.
- [x] 3.4 `apps/files`: presigned PUT/GET (5 min), local-folder backend in dev, magic-byte check and size limits, unattached uploads deleted after 24 h.
- [x] 3.5 KYC endpoints: required list, upload URL, attach document (masked number, expiry date), submit, status.
- [x] 3.6 Gate: every partner endpoint except register/KYC (and `/me`, `/me/device`, the inbox) requires `APPROVED`.
- [x] 3.7 Admin APIs: applications list, claim (30-min lock) and release, document view URL (audit-logged), approve/reject each document with a reason, approve / request changes / reject.
- [x] 3.8 Manual add partner: same fields + documents, created `APPROVED` with `added_by_admin`, SMS with the app link.
- [x] 3.9 Suspend / reinstate / deactivate (+ force logout). Suspending revokes sessions and disconnects the socket.
- [x] 3.10 Daily document-expiry task: reminder 30 days before, then expire and suspend.
- [x] 3.11 `apps/notifications`: push (FCM), SMS and email adapters, templates table, in-app inbox, partner-status messages.

### Partner app
- [x] 3.12 Registration screens R03–R05 (role, primary phone shown as verified, alternate phone OTP, email code, profile with location, languages, skills, emergency contact).
- [x] 3.13 Documents screen R06: checklist per role, camera / gallery / PDF, number, expiry date, status chip per document.
- [x] 3.14 Verification status screen R07, including "Changes needed" with the reason per document and the admin's note. Only approved partners see the Jobs tab.
- [x] 3.15 Profile and documents R16 (both phones, email, documents, re-upload/renew, logout).

### Admin panel
- [x] 3.16 Applications queue (oldest first, waiting time, re-submitted flag) and review page (document viewer side by side, approve/reject each with a reason, lock banner).
- [x] 3.17 Partners list (filters: role, status, available today, documents to review) and partner profile (both phones with call buttons, email, documents incl. renewals, readable status history, edit, suspend/reinstate/deactivate/log out).
- [x] 3.18 Add partner form. Required-documents settings page.

### Tests
- [x] 3.19 Status transitions. Non-approved partner gets 403 on work routes. Alternate phone can't equal the primary. Document view is audit-logged. Suspend revokes sessions.

## What was built

### Backend
- **`partners`**: profile, phones, selfie checks; `PARTNER_MACHINE` with `REGISTERING ⇄ REGISTERED → SUBMITTED → UNDER_REVIEW → APPROVED / CHANGES_REQUESTED / REJECTED`, `APPROVED ⇄ SUSPENDED`, `DEACTIVATED`; every move audited (`partner.status_changed`). Email codes (HMAC, 10 min, 5 tries, resend 30/60/120 s, 5 per hour). Admin edit, suspend (with cause), reinstate, deactivate, force logout.
- **`kyc`**: required documents per role (seeded, editable), documents with masked numbers, current/renewal handling, applications with a 30-minute claim, approve / request changes / reject, manual add, daily expiry check (`kyc.check_document_expiry`, 07:00 IST).
- **`files`**: `uploads` table, owner-scoped keys, KYC purpose (JPG/PNG/WEBP/PDF, 10 MB), daily cleanup (`files.cleanup_unattached`, 02:00 IST), same-origin framing for the admin viewer.
- **`notifications`**: message registry (push / inbox / email / SMS per code), templates in en/hi/or (seeded), inbox API, event handlers for every partner and document event, console + FCM push, console + SES mail.
- **Common**: default-deny `ApprovedPartnerAuth`, `staff_any_permission`, mail/push backends, `mail_outbox` dev command, SMS templates for the partner messages.

### Partner app (ARCHITECTURE §8.1)
- R03 role, registration hub (steps with Done/To do, Send for review, logout), R04 phones and email (code boxes, resend countdown, change), R05 profile (photo, DOB, gender, address, "use my current location", language and skill pills, emergency contact), R06 documents (upload sheet: camera / gallery / PDF, number, valid-till), R07 status (Submitted → Under review → Approved / Changes needed with reasons / Rejected / Account paused with support call), R16 approved shell (Home with Available today, Jobs placeholder, Profile with phones, email, documents and renewals), notifications inbox.

### Admin panel
- Partners → Applications (queue), Review (claim banner, checklist, viewer, approve / request changes / reject), All partners (filters), Partner profile (summary, documents, history, edit drawer, actions), Add partner, Required documents.

## API changes
| Method | Path | Notes |
|---|---|---|
| POST | `/v1/partner/register/start` | role |
| POST | `/v1/partner/register/alternate-phone` (+ `/verify`) | OTP to the second number |
| POST | `/v1/partner/register/email` (+ `/verify`) | email code |
| PUT | `/v1/partner/register/profile` | profile + location |
| PATCH | `/v1/partner/me/availability` | approved only |
| GET / POST | `/v1/partner/kyc/required`, `/upload-url`, `/documents`, `/submit`, `/status` | documents and submit |
| GET / POST | `/v1/partner/notifications`, `/unread-count`, `/read` | inbox, any status |
| GET / POST | `/v1/admin/applications` (+ `/:id`, `claim`, `release`, `approve`, `request-changes`, `reject`) | review |
| GET / POST | `/v1/admin/partner-documents/:id/view-url`, `approve`, `reject` | per document |
| CRUD | `/v1/admin/required-documents` | settings |
| GET / POST / PUT | `/v1/admin/partners` (+ `/:id`, `suspend`, `reinstate`, `deactivate`, `logout`) | list, manual add, edit, actions |
| POST | `/v1/admin/files/upload-url` | + `partner_photo`, `kyc_document` purposes |

OpenAPI regenerated: yes (`docs/api/openapi.json`, Dart and TypeScript clients regenerated).

## Database changes
| App | Migration | What it does |
|---|---|---|
| partners | 0001_initial | partner_profiles, partner_phones, selfie_checks |
| kyc | 0001_initial, 0002_initial | partner_applications, partner_documents (one current per type), required_documents |
| kyc | 0003_seed_required_documents | §6.3 document list for companion and nurse |
| notifications | 0001_initial | notifications, notification_templates |
| notifications | 0002_seed_templates | app and email texts in English, Hindi, Odia |
| files | 0001_initial | uploads |

## Tests
| Check | Command | Result |
|---|---|---|
| All checks | `.\ww.ps1 check` | **All checks passed** (ruff, format, mypy, pytest, makemigrations --check, flutter pub get/analyze/test, admin lint/build) |
| Backend tests | (in check) | **310 passed** |
| Flutter | (in check) | partner app 15, patient app 12, ww_core 18, ww_auth 9, ww_ui 15, ww_l10n 6 — all passed |
| Admin | `npm run lint` / `npm run build` | clean / built |

New tests this phase include registration and status transitions, the partner gate, alternate ≠ primary, email-code limits, document checks and masking (Aadhaar, PAN, licence kept as printed), claim lock, request changes (inbox + email + SMS), reject is final, manual add, suspend logs out, renewals and auto-reinstate, expiry reminders/suspension, upload cleanup, inbox; partner-app widget tests for role choice, upload from camera, submit, changes needed, approved home and availability, admin-added contact prefill, suspended screen, save-profile returns to the steps, incomplete profile message, and typing into the code boxes after "Send code".

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| A companion and a nurse each register end to end on the emulator (2 phones + email verified, documents uploaded) and get approved by the admin. | Emulator: companion Asha (+91 90000 00003, alt 00004, email code) and nurse Priya (+91 94370 00011, alt 00012) did every step on screen: role, OTPs, email code, profile with location, all required documents (5 and 7), Send for review. Approved in the admin panel; both apps then showed the approved home. | ✅ |
| A rejected document shows its reason in the app, can be re-uploaded, and the application can be approved. | Admin rejected Asha's PAN ("Photo is blurred, upload a clear one") and requested changes with a note; the app showed "Changes needed", the reason and the note (screenshot `r07-changes-needed.png`). PAN re-taken with the camera, sent again, approved; app moved to the approved home. Inbox, email and SMS checked. | ✅ |
| A partner added by the admin logs in with OTP and goes straight to the approved app. | Added "Rina Das" (+91 90000 00005) in Admin → Add partner with 5 documents; SMS with the app link in the dev outbox. Logged in on the emulator → approved home with "Verify your contact details"; verified the pre-filled alternate number and email with codes. | ✅ |
| A suspended partner is logged out immediately. | Suspended Asha in the admin while her app was open: the app went to the login screen at once with "Your session ended" (`suspended-logged-out.png`). Logging in again showed "Account paused" with a support call; reinstating brought back the approved home. | ✅ |

## Screens
Screenshots in `docs/phases/img/phase-03/`: r03-role, hub, r04-contact, r05-profile, hub-done, r06-documents, r06-upload-sheet, r06-after-upload, hub-ready, r07-submitted, r07-changes-needed, notifications, r16-approved-home (taken before the header fix), r16-home-verified (fixed header), r16-profile, admin-added-home, suspended-logged-out, nurse-approved.
Admin pages were checked through the page text and actions in the built-in browser; no admin screenshots (the browser pane was hidden, so screenshots weren't possible).

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| New status `REGISTERING` before `REGISTERED` | Tell "started" from "details done" (hub and admin list) | Not asked (clarification) — please confirm | v2.10 §6.3 |
| Partner API closed by default; open list includes `/me`, `/me/device`, `/notifications*` | Safer than opening routes one by one; the app needs `/me` and the inbox at every status | Not asked — please confirm | v2.10 §6.3 |
| Renewals wait beside the current document; approving the renewal of an expired document reinstates | §6.3 said only "suspended until a new document is approved" | Not asked — please confirm | v2.10 §6.3 |
| Licence/registration numbers kept as printed | Admin compares them with the certificate | Not asked | v2.10 §6.3 |
| `uploads` table in `files` (§10.1 said files owns no table) | Needed for the 24 h cleanup of unattached files | Not asked | v2.10 §6.8, §10.1, §11 |
| SMS texts fixed in code, not in `notification_templates` | Each SMS must match a registered DLT template | Not asked | v2.10 §6.14, §11 |
| Location from the phone's GPS (LocationManager) | Google's fused provider failed when the user declined "Location Accuracy" | Not asked | v2.10 §6.3 |
| "Changes requested" also by SMS (was missing in code) | §6.14 lists SMS for it | follows ARCHITECTURE | v2.10 §6.14 |

## Known issues and follow-ups
- **Push notifications aren't really sent yet** (console stand-in) until the Firebase key and app config are added → low (inbox, email and SMS outbox work) → the developer adds the Firebase key later (KEYS-AND-ACCOUNTS #5).
- **Admin live alert for new applications** comes with the staff socket → Phase 7, task 7.9 (the queue shows them meanwhile).
- **Daily selfie** (`POST /v1/partner/me/selfie`, §6.15) — only the `selfie_checks` table exists → Phase 7, task 7.10 (with the "Available today" switch).
- **Hard delete of a partner who never had a booking** (§9.1) not built; deactivate is → Phase 9, task 9.9, only if the developer asks for it after testing.
- The profile "save doesn't go back" bug seen on the emulator was fixed in the router (re-route only when the allowed screens change) and confirmed on the emulator; a widget test guards it, but that test also passed before the fix, so the exact cause on the device wasn't proven → low.
- The Celery worker in dev had been running old code (no reload), so the first notifications of the test run failed; worker and beat now restart on code changes. The two lost messages of that run were re-sent by hand in dev.
- "Approve partner" has no "are you sure" step (reject and request changes do) → low, can add in Phase 9 polish.
- Dev data left in the database for the developer's own checks: Asha (companion, approved), Rina (added by admin, approved), Priya (nurse, approved). Priya's nursing-registration number was saved before the "keep as printed" fix (`ORNC20194471`).
- While testing on the emulator, location permission was granted to the dev partner app ("While using the app"); no system settings were changed.

## How to run and demo this phase
- `.\ww.ps1 up`, admin panel `cd apps\admin_web; npm run dev` (http://localhost:3000, dev admin from `backend/.env`).
- Partner app: `cd apps\partner_app; flutter run --flavor dev -t lib/main_dev.dart`.
- Test numbers `+91 90000 00001`–`05` take the dev OTP; for other numbers read the code with `.\ww.ps1 manage sms_outbox <number>`. Email codes: `.\ww.ps1 manage mail_outbox <email>`.
- Demo: register → Admin → Partners → Applications → Review → approve/reject documents → Approve / Request changes; Partners → Add partner; partner profile → Suspend (app logs out) → Reinstate.

## Next phase
Phase 4 — Patient profile, family and documents. Reuse: `files` upload flow and `uploads` cleanup (add a `patient_document` purpose), the `notifications` inbox pattern for patients, owner-scoped keys, and the masked-number helper style for any ID numbers.
