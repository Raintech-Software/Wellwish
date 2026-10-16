# WellWish — Phase Plan

> **What this file is:** the complete task list for building WellWish, phase by phase. Tick a task (`- [x]`) as soon as it's done and tested.
> **What to build and how:** [ARCHITECTURE.md](ARCHITECTURE.md) (section numbers like §6.10 point there).
> **Which phase is current:** [PROGRESS.md](PROGRESS.md).
> **How to work through a phase:** [CLAUDE.md](../CLAUDE.md).

**Rules for every phase**
- Do the tasks in order unless a task says otherwise.
- A phase is **done only when every exit criterion passes** and the completion report `docs/phases/phase-NN-<name>.md` is written.
- If something must change from ARCHITECTURE.md, agree it with the developer, update ARCHITECTURE.md, and note it in the report under "Deviations".
- Every phase must leave the apps runnable. No half-broken screens: hide unfinished ones behind a feature flag.

| Phase | Name | Depends on |
|---|---|---|
| [0](#phase-0--project-setup) | Project setup | — |
| [1](#phase-1--login-and-security) | Login and security | 0 |
| [2](#phase-2--admin-master-data) | Admin master data | 1 |
| [3](#phase-3--partner-registration-and-verification) | Partner registration and verification | 2 |
| [4](#phase-4--patient-profile-family-and-documents) | Patient profile, family and documents | 2 |
| [5](#phase-5--discovery-and-booking) | Discovery and booking | 4 |
| [6](#phase-6--payment-cancel-refund-reschedule) | Payment, cancel, refund, reschedule | 5 |
| [7](#phase-7--assignment) | Assignment | 3, 6 |
| [8](#phase-8--the-visit) | The visit | 7 |
| [9](#phase-9--polish-and-hardening) | Polish and hardening | 8 |
| [10](#phase-10--release) | Release | 9 |

Phases 3 and 4 both depend only on phase 2, so they can be done in either order.

---

## Phase 0 — Project setup

**Goal:** an empty but working system. All four parts start on the developer's machine, and the quality checks run.
**Architecture:** §3, §4, §5, §13
**Report:** `docs/phases/phase-00-setup.md`

### Repository and tooling
- [x] 0.1 `git init`. Add `.gitignore` (Python, Flutter, Node, `.env*`), `.editorconfig`, and a root `README.md` with how to run everything.
- [x] 0.2 Create the folder layout from §4: `apps/`, `packages/`, `backend/`, `infra/`, `docs/`.
- [x] 0.3 `infra/docker-compose.yml` for local development (Docker Desktop on WSL 2):
  - `db`: postgres:16 with a named volume, plus an init script that creates the `wellwish` database and enables `btree_gist`
  - `redis`: redis:7
  - `api`: Django on Uvicorn with auto-reload, `backend/` mounted, port 8000
  - `worker` and `beat`: Celery, from the same image
  - health checks, and `depends_on` so the api waits for db and redis
  - README: WSL memory cap (`.wslconfig`, e.g. 4 GB) so the Android emulator still has room
- [x] 0.4 An `.env.example` for backend, admin and the Flutter flavors. Real `.env` files are git-ignored.
- [x] 0.5 A PowerShell script **`ww.ps1`** at the root, wrapping `docker compose`, with one command per job:
  - `up`: `docker compose up -d` + the admin dev server on Windows
  - `down`, `logs`, `shell` (Django shell in the api container)
  - `test`, `lint`, `check`, `migrate`, `seed`, `openapi` (run inside the api container)
  - `gen-clients`

### Backend
- [x] 0.6 `backend/Dockerfile` on `python:3.13-slim` (every package we use officially supports 3.13). Django 5.2 project in `backend/config/`. Settings split into `base/dev/staging/prod` using `django-environ`. Time zone UTC, display IST.
- [x] 0.7 Install and configure, with pinned versions in `requirements/`:
  - django-ninja, psycopg (PostgreSQL)
  - celery + django-celery-beat, channels + channels-redis
  - django-storages + boto3, PyJWT, pyotp, argon2-cffi
  - sentry-sdk
  - ruff, mypy + django-stubs, pytest-django, factory_boy
- [x] 0.8 `common/`:
  - error format `{error:{code,message,details}}` and exception handlers
  - pagination
  - money helpers (paise, ₹ formatting)
  - `StrictIn` schema base (`extra="forbid"`)
  - state-machine helper (`transition()` + allowed-transitions table)
  - `events.publish()` (runs `on_commit`, then a Celery task)
  - `geo.py`: bounding box + haversine distance helper (§6.7), with tests
- [x] 0.9 `apps/accounts` with the **custom `User` model** (phone as the username field) in the **first migration**. Set `AUTH_USER_MODEL`.
- [x] 0.10 Ninja API at `/v1`:
  - three routers (patient / partner / admin)
  - `GET /v1/health` (checks DB + Redis)
  - Swagger at `/v1/docs` (dev and staging only)
  - `.\ww.ps1 openapi` writes `docs/api/openapi.json`
- [x] 0.11 ASGI app serving HTTP and `/ws/` (Channels), with a test echo consumer.
- [x] 0.12 Celery app with queues `default`, `notify`, `money`, plus a test task.
- [x] 0.13 `python manage.py seed` command skeleton.

### Flutter
- [x] 0.14 melos workspace at the root, with `apps/patient_app`, `apps/partner_app`, `packages/ww_ui`, `packages/ww_core`, `packages/ww_l10n`.
- [x] 0.15 `ww_ui`:
  - design tokens from §5 (colours, radius, spacing, fonts)
  - theme
  - base widgets: primary/secondary button, text field, phone field (+91), OTP field, card, list tile, bottom nav, loading/empty/error states
- [x] 0.16 `ww_core`:
  - Dio client with a base URL per flavor
  - secure token storage
  - error mapping from the API error format
  - socket client stub
- [x] 0.17 `ww_l10n`: ARB files for English, Hindi and Odia, wired into both apps.
- [x] 0.18 Both apps:
  - flavors `dev / staging / prod` (different app IDs)
  - Riverpod, go_router
  - **Splash screen matching mockup 1** (Partner app: "Partner" under the logo)
- [x] 0.19 `.\ww.ps1 gen-clients`: OpenAPI → Dart client (in `packages/ww_api`, see ARCHITECTURE v2.5 §4) and TypeScript client (in `admin_web`).

### Admin panel
- [x] 0.20 `apps/admin_web`: Next.js + TypeScript + Ant Design, using the WellWish colours.
- [x] 0.21 Layout: sidebar with the menu from §9.1 (empty pages), header, login page shell.

### Checks
- [x] 0.22 `.\ww.ps1 check` runs:
  - backend (inside the api container): ruff, mypy, pytest, `makemigrations --check`
  - Flutter: `melos run analyze` + tests
  - admin: lint + build
- [ ] 0.23 If the code is hosted on GitHub: a GitHub Actions workflow running the same checks. *(Skipped in Phase 0: hosting not decided yet. Add when the repo goes to GitHub.)*

### Exit criteria
- [x] `.\ww.ps1 up` starts all containers (db, redis, api, worker, beat) healthy, plus the admin dev server. `GET http://localhost:8000/v1/health` returns `ok` for DB and Redis.
- [x] Both Flutter apps run on an Android emulator and show the WellWish splash.
- [x] The admin panel opens at `localhost:3000` with the sidebar.
- [x] `.\ww.ps1 check` passes.
- [x] `docs/api/openapi.json` is generated.

---

## Phase 1 — Login and security

**Goal:** patients and partners log in with a phone OTP. Admin staff log in with a password + 2FA. Every request is checked for app, role and ownership.
**Architecture:** §6.1, §6.2, §6.4, §6.5, §9.2, §12
**Report:** `docs/phases/phase-01-login-security.md`

### Backend
- [x] 1.1 OTP service (§6.2):
  - 6 digits from `secrets`, HMAC stored in Redis with a 5-min TTL
  - 5 tries
  - resend after 30/60/120 s
  - limits per phone, IP and device, plus lockout
  - Indian numbers only
  - test numbers by environment
- [x] 1.2 SMS adapter interface with **MSG91** (DLT template IDs from settings) and a **console adapter** for dev.
- [x] 1.3 Sessions (§6.4):
  - JWT access token (15 min) with `aud`, `pid`, `role`, `sid`
  - refresh tokens stored as hashes, rotated, with reuse detection that revokes the session family
  - logout and logout-all
- [x] 1.4 Partner rule: **one active device**. A new login revokes the old sessions and sends `session.revoked`.
- [x] 1.5 `SessionJWTAuth(audience)` on each router, plus the `@partner_status("APPROVED")` and `@staff_permission("…")` decorators (§6.5).
- [x] 1.6 `apps/patients` (minimal): create `PatientProfile` and the `SELF` member on the first patient login.
- [x] 1.7 Google sign-in endpoint: verify the Google ID token, then require a phone OTP if no phone is linked.
- [x] 1.8 Devices: register and update the FCM token for each app and device.
- [x] 1.9 `apps/staff`:
  - `StaffUser` with an Argon2 password and TOTP setup/verify (pyotp)
  - roles and permissions seeded from §9.2
  - 12 h session, 30-min idle logout
- [x] 1.10 `apps/audit`: `audit.record(actor, action, entity, before, after, reason)` helper and model.
- [x] 1.11 Consents: store terms/privacy/health-data consent with version, time and IP.

### Patient app
- [x] 1.12 Login screen (mockup 2): phone + Send OTP, Google button, "Create account".
- [x] 1.13 OTP screen: 6-digit field, resend timer, Android SMS auto-read.
- [x] 1.14 Profile setup (name, DOB, gender, language) → consent screen → Home shell with bottom nav (Home · Doctors · Reports · Family · Profile).
- [x] 1.15 Token refresh interceptor, logout, force-update screen (from `app-config`).

### Partner app
- [x] 1.16 Login + OTP screens (same style). After login: "Register" path placeholder for phase 3.

### Admin panel
- [x] 1.17 Login (email + password) → first-time TOTP setup (QR) → TOTP verify. Logout and idle timeout.
- [x] 1.18 Menu items shown according to permissions.

### Tests
- [x] 1.19 OTP: expiry, 5-try limit, resend wait, rate limits, lockout, non-Indian number rejected.
- [x] 1.20 Tokens: refresh rotation, reuse revokes the family, a partner token on a patient route is rejected, staff permission denied without the permission.

### Exit criteria
- [x] A patient logs in on the emulator with the dev OTP and reaches Home. The profile and `SELF` member exist.
- [x] A partner logs in. A second device login logs the first one out.
- [x] Admin logs in with password + TOTP. The menu respects the role.
- [x] All tests pass. No OTP or token appears in the logs.

---

## Phase 2 — Admin master data

**Goal:** the admin can set up everything the apps need: services and prices, hospitals, doctors, settings, service areas and blocked dates.
**Architecture:** §6.6, §6.7, §6.17 (settings), §9.1, §11
**Report:** `docs/phases/phase-02-master-data.md`

### Backend
- [x] 2.1 `apps/services`: `Service` model (§6.6: names in 3 languages, partner type, visit type, price + booking fee in paise, duration, docs required, active, sort).
  - Balance is calculated (never typed).
  - Deactivate instead of delete when the service has been used.
- [x] 2.2 `GET /v1/public/services`. Admin CRUD with validation (booking fee ≤ price). Audit-log every price change.
- [x] 2.3 `apps/hospitals`: `Hospital` (with location), `Speciality`, `Doctor`, `DoctorHospital`.
  - Admin CRUD, deactivate rules.
  - Nearby selector (10 km, widened to 25 km if fewer than 5) with tests (§6.7).
- [x] 2.4 `apps/app_config`: typed `AppSetting` keys from §11 (refund %, timeouts, booking window, minimum notice, service hours, time step, travel buffer, max reschedules, max members, support numbers, min versions) with defaults. `GET /v1/public/app-config`.
- [x] 2.5 `service_areas` (city, centre, radius) with an `is_inside_service_area(point)` helper.
- [x] 2.6 `blocked_times` CRUD. Saving one lists the existing bookings it affects (empty until phase 5).
- [x] 2.7 Staff users: add, edit role, disable, reset 2FA. Audit log list API with filters.
- [x] 2.8 Seed: the sample services from §6.6, 5 Bhubaneswar hospitals, 10 doctors, specialities, 1 service area, the default settings.

### Admin panel
- [x] 2.9 Services page: table, add/edit form (shows the calculated balance), deactivate, reorder.
- [x] 2.10 Hospitals page: table, form with a **map pin picker** (OpenStreetMap until the Google key arrives, ARCHITECTURE v2.8), latitude/longitude fields, "use my current location", OPD hours, departments, photo upload.
- [x] 2.11 Doctors and Specialities pages.
- [x] 2.12 Settings page (all keys, grouped) and Service areas (map with a radius circle).
- [x] 2.13 Blocked dates/times page (calendar).
- [x] 2.14 Admin users and roles page. Audit log page (read-only, export CSV).

### Exit criteria
- [x] The admin can add, edit and deactivate services, hospitals and doctors. Deleting one that has been used is refused.
- [x] `GET /v1/public/services` returns the seeded prices with the calculated balance.
- [x] The nearby-hospitals test returns seeded hospitals sorted by distance.
- [x] Each price change appears in the audit log with before and after values.

---

## Phase 3 — Partner registration and verification

**Goal:** companions and nurses register with 2 phones, an email and documents. The admin reviews and approves them, or adds them by hand. Only approved partners get into the app.
**Architecture:** §6.3, §6.5, §8.1–8.2, §9.1, §9.4
**Report:** `docs/phases/phase-03-partners.md`

### Backend
- [x] 3.1 `apps/partners`: `PartnerProfile`, `PartnerPhone` (PRIMARY / ALTERNATE, verified_at), `SelfieCheck`.
- [x] 3.2 `apps/kyc`: `PartnerApplication`, `PartnerDocument`, `RequiredDocument` (seeded per role from §6.3), and the status state machine from the §6.3 diagram.
- [x] 3.3 Registration endpoints (§10.3):
  - start with a role
  - alternate phone OTP (must differ from the primary)
  - email code via an **AWS SES adapter** (console adapter in dev)
  - profile with a base-location pin
- [x] 3.4 `apps/files`:
  - presigned PUT and GET (5-min expiry): S3 in staging/production, and in local dev a **local-folder backend** behind a dev-only signed upload URL (same flow for the apps)
  - magic-byte type check and size limits
  - delete unattached uploads after 24 h
- [x] 3.5 KYC endpoints: required list, upload URL, attach document (masked number, expiry date), submit, status.
- [x] 3.6 Gate: every partner endpoint except register/KYC requires `APPROVED`.
- [x] 3.7 Admin APIs:
  - applications list, **claim (30-min lock)**
  - document view URL (audit-logged)
  - approve or reject each document with a reason
  - approve / request changes / reject the application
- [x] 3.8 **Manual add partner** (admin): same fields + documents, created as `APPROVED` with `added_by_admin`, SMS with the app link.
- [x] 3.9 Suspend / reinstate / deactivate. Suspending revokes sessions and disconnects the socket.
- [x] 3.10 Daily document-expiry task: reminder 30 days before, then expire and suspend.
- [x] 3.11 `apps/notifications`:
  - push (FCM), SMS and email adapters
  - templates table
  - in-app inbox
  - partner-status messages

### Partner app
- [x] 3.12 Registration screens R03–R05:
  - role
  - primary phone (already verified at login)
  - alternate phone OTP
  - email code
  - profile with map pin, languages, skills, emergency contact
- [x] 3.13 Documents screen R06: checklist per role, camera or file, expiry date, status chip per document.
- [x] 3.14 Verification status screen R07, including "Changes needed" with the reason for each document. Only approved partners see the bookings tabs.
- [x] 3.15 Profile and documents screen R16 (re-upload expiring documents).

### Admin panel
- [x] 3.16 Applications queue (oldest first, SLA badge) and review page (document viewer side by side, approve/reject each with a reason).
- [x] 3.17 Partners list (filters: role, status, available) and partner profile (both phones with call buttons, email, documents, status history).
- [x] 3.18 Add partner form. Required-documents settings page.

### Tests
- [x] 3.19 Status transitions. Non-approved partner gets 403 on booking routes. Alternate phone can't equal the primary. Document view is audit-logged. Suspend revokes sessions.

### Exit criteria
- [x] A companion and a nurse each register end to end on the emulator (2 phones + email verified, documents uploaded) and get approved by the admin.
- [x] A rejected document shows its reason in the app, can be re-uploaded, and the application can be approved.
- [x] A partner added by the admin logs in with OTP and goes straight to the approved app.
- [x] A suspended partner is logged out immediately.

---

## Phase 4 — Patient profile, family and documents

**Goal:** a patient can add parents and relatives with their details, addresses and health notes, and keep documents for each person.
**Architecture:** §6.1, §6.8, §6.18, §7.1 (P21–P24, P27–P29)
**Report:** `docs/phases/phase-04-family-documents.md`

### Backend
- [x] 4.1 `Member` model with all §6.18 fields, consent time, max members setting (10), deactivate instead of delete.
- [x] 4.2 `apps/addresses`:
  - addresses linked to the user **and a member**
  - map pin
  - service-area check result stored
- [x] 4.3 `apps/documents`:
  - upload URL, attach, list (by member and type), view URL, delete
  - 200 MB quota per account
- [x] 4.4 Ownership: every selector is filtered by the owner, and other users get 404. Write IDOR tests for members, addresses and documents.
- [x] 4.5 Account deletion request: personal data removed or anonymised within 30 days (task + admin view). Payment records kept.

### Patient app
- [x] 4.6 Family screen P22 (mockup 8 style): members list, **+ Add member**.
- [x] 4.7 Add/edit member P28: all fields + consent tick.
- [x] 4.8 Member profile P29: details, health notes, addresses, documents, bookings (empty for now).
- [x] 4.9 Addresses P24: add/edit with a map pin and notes, per member. Shows a warning when outside a service area.
- [x] 4.10 Medical documents P21 (mockup 7):
  - tabs All / Reports / Prescriptions
  - member filter
  - upload from camera or file, with progress
  - viewer for PDFs and images
- [x] 4.11 Profile P23 (mockup 10) and Settings P27 (language, notifications, delete account).

### Admin panel
- [x] 4.12 *(added in Phase 4)* Patients list and profile (members without health notes, addresses, documents; opening a document needs a reason, logged) and Account deletion requests.

### Exit criteria
- [x] Add "Mother" with her phone, address (pinned, inside the service area), health notes and consent. Upload 2 documents for her.
- [x] Mother's documents appear only under Mother. Another patient account can't read them (tests).
- [x] Removing a member hides them but keeps their history.
- [x] Hindi and Odia text shows on these screens (translations may be placeholders until phase 9).

---

## Phase 5 — Discovery and booking

**Goal:** a patient finds a hospital and doctor, picks a service, chooses who it's for, picks a date and time, attaches documents and reaches the review screen. The booking is saved as *Pending payment*.
**Architecture:** §6.6, §6.7, §6.9, §6.17, §7.1 (P05–P15), §7.2 W-P2, W-P3
**Report:** `docs/phases/phase-05-booking.md`

### Backend
- [x] 5.1 Patient directory endpoints: nearby hospitals (list + map data), hospital detail with doctors, doctors search, doctor profile.
- [x] 5.2 `GET /v1/patient/booking-times?serviceId&date`. It applies the booking window, minimum notice, service hours, time step, blocked times and capacity (if on) (§6.17).
- [x] 5.3 `apps/bookings`:
  - `Booking` model (§11) with price, member and address snapshots, appointment and pickup times, `busy_window`, `version`
  - `BookingDocument`, `BookingEvent`
- [x] 5.4 Create booking (`Idempotency-Key`). It validates:
  - the member belongs to the caller
  - the address is in a service area
  - the time is allowed (server re-check)
  - a prescription is attached when the service requires one

  Status `PENDING_PAYMENT`.
- [x] 5.5 `transition()` with the full allowed-transitions table from §6.9 and a `BookingEvent` for each change. Tests for every allowed and blocked transition.
- [x] 5.6 Patient bookings list (upcoming / ongoing / past) and detail.

### Patient app
- [x] 5.7 Home P05 (mockup 3): tiles Doctors, Book a Companion, Book a Nurse, Medical Reports, Family. Next booking card. Bell.
- [x] 5.8 Nearby hospitals P06 (list + map, search, speciality filter) and hospital detail P07.
- [x] 5.9 Doctors P08 (mockup 4, directory) and doctor profile P09, with "Book a companion for this doctor".
- [x] 5.10 Book a Companion P10 (mockup 6) and Book a Nurse P11: service cards with prices.
- [x] 5.11 Visit details P12 (mockup 5 style):
  - **For whom** (+ Add member)
  - hospital + doctor (or type a hospital)
  - **date strip** + calendar, time grid from the API
  - appointment time → suggested pickup time
  - notes
- [x] 5.12 Address P13 (the chosen member's addresses first) and attach documents P14 (tick saved ones or upload new).
- [x] 5.13 Review P15: total / **pay now** / **pay partner after**, cancellation rule, "Pay ₹X" button. Payment itself comes in phase 6, so this screen creates a `PENDING_PAYMENT` booking.

### Admin panel
- [x] 5.14 Bookings list (filters: status, date, type; Today / Tomorrow / Later) and booking detail (read-only: snapshots, documents, timeline).

### Exit criteria
- [ ] Book "Doctor visit companion" for **Mother, tomorrow**, at a nearby hospital with a doctor and her saved prescription. The booking is saved with correct snapshots.
- [ ] Times shown match the settings. A blocked date is greyed out. A time inside the minimum notice is refused by the server.
- [ ] An injection service can't be booked without a prescription.
- [ ] A double tap on Book creates only one booking.

---

## Phase 6 — Payment, cancel, refund, reschedule

**Goal:** the booking fee is paid with Razorpay and the booking becomes NEW. Cancel refunds 50%. Reschedule works.
**Architecture:** §1.2, §6.12, §6.17 (reschedule), §9.5, §12 (payments)
**Report:** `docs/phases/phase-06-payments.md`

### Backend
- [x] 6.1 `apps/payments`: create a Razorpay order for the booking fee (amount from the **server snapshot only**) and return it with the booking. *(Built as its own call `POST /v1/patient/bookings/:id/checkout`, ARCHITECTURE v2.13.)*
- [x] 6.2 `POST /v1/patient/payments/verify` (client callback → "processing").
- [x] 6.3 `POST /v1/webhooks/razorpay`:
  - check the signature
  - store `webhook_events` and ignore duplicates
  - `payment.captured` → booking **NEW** → events (patient push + member SMS, admin queue)
- [x] 6.4 Reconcile task (every 10 min) and expire-unpaid task (30 min).
- [x] 6.5 Cancel:
  - preview (refund amount) + cancel before "On the way"
  - refund % from settings (50)
  - Razorpay refund
  - refund status sweep
- [x] 6.6 Admin cancel with refund % (0–100) and a reason. Refunds above ₹500 need Finance approval.
- [x] 6.7 Reschedule (§6.17): until 3 h before pickup, at most 2 times, same time rules. If a partner had accepted, they re-confirm (wired up in phase 7, stored as a flag now).

### Patient app
- [x] 6.8 Razorpay checkout (`razorpay_flutter`) from Review and pay. Payment result screen P16 (success / failure + retry).
- [x] 6.9 My bookings P17 and booking detail P18 with status timeline, **Cancel** (shows the refund amount first) and **Change date/time** (P30).

### Admin panel
- [x] 6.10 Payments page, Refunds page (approve), fee report (CSV), Cancel + refund dialog on the booking, Reschedule on the booking.

### Tests
- [x] 6.11 Webhook signature fail is rejected. A duplicate webhook is ignored. Amount tampering from the app has no effect. Refund = exactly 50% of the paise amount. Reschedule limits work.

### Exit criteria
- [x] In **Razorpay test mode**, paying moves the booking to NEW and it appears in the admin bookings list.
- [x] Closing the app during payment still ends with a confirmed booking (webhook path).
- [x] Cancelling a ₹100 booking fee refunds ₹50 (shown in the Razorpay test dashboard).
- [x] A reschedule within 3 h of pickup is refused. A 3rd reschedule is refused.

---

## Phase 7 — Assignment

**Goal:** the admin assigns each booking to a partner, who accepts or declines. The 2-minute rule, escalation and reminders work.
**Architecture:** §6.10, §6.14, §6.17 (assign deadline), §8.3, §9.3, §10.4
**Report:** `docs/phases/phase-07-assignment.md`

### Backend
- [x] 7.1 `apps/assignments`: `BookingAssignment` model with one open offer per booking. Assign, reassign (withdraws the old offer), unassign, decline with a reason.
- [x] 7.2 Accept is atomic and sets `busy_window`. The **exclusion constraint `no_partner_overlap`** stops double-booking a partner, with a migration adding `btree_gist`.
- [x] 7.3 **Accepted by phone** (admin, logged).
- [x] 7.4 Candidates endpoint: approved partners of the right type, free at that time, distance from their base, available today, rating, jobs this week, both phones.
- [x] 7.5 2-minute timer: Celery countdown 120 s → admin alert + partner reminder if the offer is still open. The offer stays open.
- [x] 7.6 Escalation sweep: unassigned at 6 PM the day before or 3 h before pickup → red alert + Super Admin notified.
- [x] 7.7 Reminders sweep: T−24 h and T−2 h to the owner, the member (SMS) and the partner.
- [x] 7.8 Reschedule with an assigned partner sends a re-confirm offer (finishes 6.7).
- [x] 7.9 Channels:
  - `/ws/staff/` with `queue.changed` and `alert`, including the **"new partner application" alert** (§6.14; moved here from Phase 3, the queue shows them until then)
  - `/ws/partner/` with `offer.new`, `offer.withdrawn`, `booking.updated`, `session.revoked`
  - JWT sent as the first message
- [x] 7.10 Partner "Available today" switch and daily selfie check (§6.15): `POST /v1/partner/me/selfie`, the selfie screen before switching on, admin spot-check view. The switch and the `selfie_checks` table were built in Phase 3; the selfie endpoint and screens were moved here.

### Admin panel
- [x] 7.11 Unassigned queue (Today / Tomorrow / Later, soonest first, red when past the deadline) with a **sound** on new bookings.
- [x] 7.12 Assign dialog with the candidates list and call buttons, plus a live **2-minute countdown** on the booking.
- [x] 7.13 Alert banner: "Not accepted — Call primary / Call alternate / Accepted by phone / Reassign". Decline alerts include the reason.

### Partner app
- [x] 7.14 Home R08: Available switch, **offer card with a countdown**, today's bookings, quick totals.
- [x] 7.15 Offer screen R09: summary only (area, distance, time, needs, balance). Accept, or Decline with a reason.
- [x] 7.16 My bookings R10 and booking detail R11. Full address, both phones, health notes and documents appear **only after accepting**.

### Patient app
- [x] 7.17 Booking detail shows the assigned partner (photo, name, phone, rating). Push + member SMS on acceptance.

### Exit criteria
- [x] Assign → the partner sees the offer on their phone within seconds → accepts → the patient sees the partner.
- [x] With no answer, the admin alert appears at **2 minutes** with call buttons. "Accepted by phone" works and is logged.
- [x] A decline returns the booking to the queue with the reason.
- [x] Assigning a partner who is busy at that time is refused.
- [x] An unassigned booking for tomorrow morning turns red at 6 PM today.

---

## Phase 8 — The visit

**Goal:** the partner does the job step by step with the OTP and live location. The family watches live. The balance is recorded, totals update, and SOS works.
**Architecture:** §6.11, §6.13, §6.15, §8.3–8.4, §9.1 (Live), §10.4
**Report:** `docs/phases/phase-08-visit.md`

### Backend
- [x] 8.1 Steps per visit type (§6.11 table), recorded through `transition()` with GPS. "Far from target" (> 300 m) flags the step but doesn't block it.
- [x] 8.2 Job OTP:
  - created when the partner accepts, stored as a hash
  - shown to the owner
  - **SMS to the member's phone**
  - 4 wrong tries, then a growing wait (5, 10, 20 min…) + admin alert (developer decision 12 Oct 2026; was "5 tries then lock")
  - admin can mark the step on the partner's behalf (logged)
- [x] 8.3 `apps/tracking`:
  - `location.update` consumer
  - checks: accuracy, mock location, impossible speed
  - Redis latest point
  - `booking.location` to the patient, `job.location` to staff
  - track saved when the job ends
  - offline batch endpoint
- [x] 8.4 No-location watch: 2 min without a point during a job → admin alert.
- [x] 8.5 Patient not available: 15-min timer after arrival, then the partner can mark it (needs a logged call attempt). Admin reviews.
- [x] 8.6 Care note (nurse): required at "Care done", with optional vitals. Saved to the member's documents.
- [x] 8.7 Balance collected (amount + cash/UPI) and partner totals endpoint (§6.13).
- [x] 8.8 `apps/safety`: SOS (admin alarm + SMS to the emergency contacts) and trip share link (token, expires at the end of the job).
- [x] 8.9 `apps/reviews`: rating after completion, report a problem (support ticket), admin replies.

### Partner app
- [x] 8.10 Active job R12:
  - big step button
  - OTP entry
  - navigate (Google Maps)
  - call member / owner
  - wait timer
  - SOS
- [x] 8.11 Android **foreground location service** running only from "On the way" to "Completed", with a visible notification. Offline queue for steps and points.
- [x] 8.12 Care note R13 (nurse), Collect balance R14, Totals R15.

### Patient app
- [x] 8.13 Live tracking P19: map, partner marker, ETA, current step, OTP display, call, SOS, share link.
- [x] 8.14 Completed P20: "Pay ₹X to your companion", rating, report a problem.

### Admin panel
- [x] 8.15 Live map of jobs in progress. Alerts list (no location, far step, mock GPS, OTP locked). SOS console (acknowledge / resolve). Support tickets and reviews moderation.

### Added during the phase (developer decision, 12 Oct 2026)
- [x] 8.16 Admin sign-in recovery (§6.4, v2.16, v2.18): "Trust this browser for 30 days", "No phone? Email me a code" (v2.18), 10 one-time recovery codes (use one → set up a new authenticator; Super Admins emailed), help text "a Super Admin can reset your 2FA", warning while only one Super Admin is active, server command `reset_staff_2fa`.

### Exit criteria
- [x] **On a real Android phone (partner app) with the patient app on the emulator** (developer decision, 10 Oct 2026; was "two real phones"): a full hospital visit (On the way → … → Completed) and a nurse home visit with a care note.
- [x] The family's live map moves during the trip and stops at Completed.
- [x] Wrong visit codes: after 4, the partner waits 5 min (then 10, 20…) and the admin is alerted (developer decision 12 Oct 2026; was "5 wrong codes lock the step").
- [x] The partner's totals show the job and the balance recorded.
- [x] SOS shows the alarm in the admin panel within seconds.
- [x] With the network off for a few steps, they sync correctly when it comes back.

---

## Phase 8B — Temporary partner

**Goal:** when every partner is busy, an admin can bring in a person they phoned and whose ID they checked for **one booking**. The person uses the normal Partner app for that job only, and their access ends with it (developer request, 12 Oct 2026).
**Architecture:** §6.19 (and §6.3, §6.10, §6.12, §6.14, §9.1, §10, §11; v2.17, deep check v2.19)
**Report:** `docs/phases/phase-08b-temporary-partner.md`

### Backend
- [x] 8B.1 Partner statuses `TEMPORARY` and `TEMP_ENDED` (through `transition()`), table `temporary_id_checks`, assignment kind TEMPORARY, upload purpose for the ID photo, migrations.
- [x] 8B.2 `POST /v1/admin/bookings/:id/temporary-assign` (`bookings.manage`): the number rules of §6.19 (new / patient allowed; family, partner or applicant, busy temporary refused; ended temporary reused), under the booking lock with `expectedAssignmentId` (an open offer withdrawn), accepted at once, job OTP made, SMS TEMP_PARTNER_JOB after commit, audit `booking.temp_assigned`. `GET …/temporary-partner` (ID photo view logged).
- [x] 8B.3 Access: a `TEMPORARY` partner's routes open only for their booking (job, steps, calls, location, SOS, care note, balance, today's selfie); offers, availability, totals and registration stay closed; 409 `SELFIE_REQUIRED` at "On the way" without today's selfie.
- [x] 8B.4 End of access: at once on cancel, unassign, reassign or a time change (back to the queue); 1 h after Completed (Celery). Status `TEMP_ENDED`, sessions revoked, socket closed. Choosing a role later moves `TEMP_ENDED` → `REGISTERING`.
- [x] 8B.5 Admin booking outputs say the partner is temporary; the **patient API never does** (a test checks it); admin bookings filter `temporary`; temporary partners never in the candidates. Normal cancel rules.
### Admin panel
- [x] 8B.6 "Temporary assign" next to Assign (booking page and queue): the form of §6.19 with the ID photo upload and the "ID checked" tick, clear messages for each 409; "Temporary partner" tag and ID card on the booking page; bookings filter; Partners list tag and filter.
### Partner app
- [x] 8B.7 `TEMPORARY` home shows only the job (selfie first, then the normal job screen); `TEMP_ENDED` shows the "not registered" start; logged out at once when access ends. Texts in English, Hindi and Odia.
### Patient app
- [x] 8B.8 No new screen: a temporary partner shows like any partner (name, the day's selfie as the photo, Call). Checked on the emulator.

### Exit criteria
- [x] An admin temporary-assigns a booking to a new number; that person logs in to the Partner app with the SMS code, takes the selfie and does the whole visit (visit code, live map) to Completed.
- [x] An approved partner's number, a rejected applicant's number and the booking family's number are refused with a clear message; a patient's number works.
- [x] 1 hour after Completed (clock moved in the test), and at once after an unassign, the person is logged out and the app shows the "not registered" start; the job no longer opens.
- [x] The family's app shows the temporary partner like any partner, with nothing saying "temporary"; the admin panel shows the "Temporary partner" tag and the ID card.
- [x] `.\ww.ps1 check` passes.

---

## Phase 9 — Polish and hardening

**Goal:** fully translated, measured, secured and load-tested.
**Architecture:** §5 (languages), §9.1 (Dashboard, reports), §12, §13
**Report:** `docs/phases/phase-09-hardening.md`

- [x] 9.1 Hindi and Odia translations for every screen and notification template. Final list of DLT SMS templates.
- [x] 9.2 Admin dashboard (today's numbers, alerts) and reports (bookings, fees collected, cancellations/refunds, partner performance), with CSV export.
- [x] 9.3 Go through the security checklist §12 item by item:
  - IDOR test for **every** endpoint
  - rate limits on all write endpoints
  - log redaction check
  - `--obfuscate` builds
  - root warning on the Partner app
- [x] 9.4 Load test (k6 or Locust): 100 partners sending location every 10 s + 30 bookings/min. Target p95 < 300 ms. Fix the slow parts.
- [x] 9.5 Monitoring: Sentry in all apps, CloudWatch alarms from §13.
- [x] 9.6 Backups: daily snapshot + a restore test on staging. *(Developer decision 14 Oct 2026: tested locally, `.\ww.ps1 backup` / `restore-test` and the runbook `docs/runbooks/backups.md`; the developer deploys to a server by hand once every phase is done, so the server's backup set-up and first restore test moved to 10.1.)*
- [ ] 9.7 Optional features **only if the client confirmed them** (§17): admin books for a phone caller, announcements. *(13 Oct 2026: not confirmed by the client → not built in this phase.)*
- [x] 9.8 Accessibility: works with large system text and has big tap targets on key screens.
- [ ] 9.9 *Only if the developer asks after testing:* hard delete of a partner who never had a booking (§9.1). Until then **Deactivate** covers it (built in Phase 3).
- [x] 9.10 *(from the Phase 4 deep check)* Admin actions on a patient account (§9.1): change details only on the patient's request (logged), block / unblock (abuse), and start "delete account" for a patient who asks by phone (`patients.manage`).
- [x] 9.11 *(carried over from the Phase 1, 3, 8 and 8B reports; developer OK 13 Oct 2026)* Small fixes:
  - old accepted bookings never close by themselves (auto-close / no-show sweep); Home and Upcoming show past ones
  - the family's booking still says "Pay ₹X to …" after the partner recorded the balance; the payment result keeps "We're assigning your partner" after an accept
  - the balance only in whole rupees; the partner's review card without the tags
  - live location: a point and a catch-up batch at the same moment can lose a point; a socket that died silently loses up to ~50 s; a night job crossing midnight resumes sharing only from its job screen
  - rate-limit keys hold the full phone number (hash them); old session rows never cleaned (daily cleanup)
  - view links show the file's place (opaque ids); `ww_core` session end reason "job over"; "Approve partner" without an "are you sure" step

### Exit criteria
- [x] Every item in §12 is ticked with evidence in the report. *(Parts that only exist on a server: at the deploy, 10.1.)*
- [x] Load test meets the target.
- [x] No hard-coded text left (lint check).
- [x] Staging restore test succeeded. *(Developer decision 14 Oct 2026: a local restore test instead, passed; on the server at the deploy, 10.1.)*

---

## Phase 9B — Store requirements

**Goal:** what Google Play, the App Store and the DPDP Act need before release: legal pages people can read and admins can edit, partners accepting their terms, partners deleting their own account, a web page to delete an account, and an upload size limit enforced by the storage itself (developer request, 14 Oct 2026).
**Architecture:** §6.20 (and §6.3, §6.8, §9.1, §9.2, §10, §11, §12; v2.31)
**Report:** `docs/phases/phase-09b-store-requirements.md`

### Backend
- [x] 9B.1 `apps/legal`: table `legal_documents` (Terms of Use, Privacy Policy, Refund Policy, Partner Terms; versions kept; English, Hindi, Odia), first drafts seeded. Admin endpoints (`legal.manage`, Super Admin): list, history, publish as a small fix or asking everyone again (audit `legal.published`). Public pages `/legal/terms`, `/legal/privacy`, `/legal/refunds`, `/legal/partner-terms` (`?l=hi|or`, escaped). Links in the app-config (`PUBLIC_SITE_URL`).
- [x] 9B.2 Consent versions of Terms, Privacy and Partner Terms come from the published documents (health data keeps its setting). Partners: `consentsNeeded` in `GET /partner/me`, `POST /v1/partner/me/consents` (Partner Terms + Privacy Policy).
- [x] 9B.3 Partner account deletion: `POST /v1/partner/me/delete` (refused with `ACTIVE_JOBS` while an accepted or in-progress job is theirs), while it waits the status stays (sanctions keep working; no offers, out of the review queue), open offers withdrawn, logged out; a Partner app login cancels it; the daily task erases after `account_deletion_days` (status `DELETED`, personal data and files gone, bookings show "Former partner"). Table `partner_deletions`; `source` (APP / WEB / ADMIN) on both deletion tables.
- [x] 9B.4 Web page `/delete-account` for both apps (English, Hindi, Odia): phone → SMS code (OTP rules and limits) → the accounts on that number → delete each with the app's rules → done with the date.
- [x] 9B.5 Uploads: presigned **POST** with `content-length-range` (the storage refuses a file over the limit), `uploadFields` in the upload ticket, the local stand-in takes the same POST. `FILE_S3_ENDPOINT_URL` for an S3-compatible test store; `.\ww.ps1 s3-test` proves it against a real S3 API (SeaweedFS's S3 gateway in Docker: MinIO no longer publishes images).
### Admin panel
- [x] 9B.6 Settings → **Legal pages** (only with `legal.manage`): the 4 documents, an editor per language with a preview, "Publish small fix" / "Publish and ask everyone again" (with a confirm), the version history. The `DELETED` status, a "Deletion requested" tag in the partners list and the "erased on" notice on the partner page. Uploads with the POST.
### Patient and Partner apps
- [x] 9B.7 "Read" on each consent line and Terms / Privacy / Refund rows in Settings (opened in the browser, in the app's language). Uploads with the POST (`ww_core`).
- [x] 9B.8 Partner app: the consent screen (Partner Terms + Privacy Policy) before anything else, for new and existing partners; "Delete my account" on the Profile tab and the registration and status screens, the `ACTIVE_JOBS` message, the "deletion requested" login message; Partner Terms and Privacy rows on the Profile tab. Texts in English, Hindi and Odia.

### Exit criteria
- [x] An admin publishes the Privacy Policy "asking everyone again": the public page shows the new text; a patient and a partner get the consent screen at their next open and their acceptance is stored with the new version; a small fix asks nobody; old versions can be read in the admin panel.
- [x] A new partner can't start registering before accepting the Partner Terms and Privacy Policy; an existing partner is asked at the next open.
- [x] A partner deletes their account in the app: logged out at once; refused while they have an accepted or in-progress job; a login before the date keeps the account with its old status; after the waiting time (clock moved in the test) their personal data and files are gone, their bookings show "Former partner", fees and the audit log stay.
- [x] The web page deletes a patient account and a partner account with an SMS code, with the same rules, in English, Hindi and Odia.
- [x] Against the S3 test store (`.\ww.ps1 s3-test`), a file over the limit, of another type or under another key is refused by the storage itself; uploads work in both apps and the admin panel with the new flow (against the local stand-in; the browser path to real S3, CORS and CSP, is seen at the deploy).
- [x] `.\ww.ps1 check` passes.

---

## Phase 9C — Family inbox

**Goal:** families see every message about their bookings in the app, without waiting for Firebase push (developer decision after the full test, 16 Oct 2026).
**Architecture:** §6.14, §7.1 P25, §10.3, §10.4 (v2.32)
**Report:** `docs/phases/phase-09c-family-inbox.md`

- [x] 9C.1 Backend: `GET /v1/patient/notifications`, `GET …/unread-count`, `POST …/read` (only the caller's own, only the family app); socket `notification.new` `{type, unread}` when an inbox message is saved (both apps). Tests.
- [x] 9C.2 Patient app: the bell on Home with the unread count (live), Notifications screen P25 (newest first, unread dot, opening marks read, a booking's message opens it, empty state, pull to refresh), English / Hindi / Odia. Widget tests.
- [x] 9C.3 Live check on the emulator: a booking confirmed and a partner assigned appear in the family's inbox at once.
- [x] 9C.4 Inbox limit (developer, 16 Oct 2026, after the close): the family inbox shows the last 30 days, at most the newest 50; the bell counts those only; nightly delete of family messages older than 30 days.

### Exit criteria
- [x] A family sees "booking confirmed" and "partner assigned" in the app's Notifications within seconds, and the bell's number goes up and back to 0 after opening.
- [x] `.\ww.ps1 check` passes.

---

## Phase 10 — Release

**Goal:** production is live and the first real booking is completed.
**Architecture:** §3.2 (hosting), §12, §13
**Report:** `docs/phases/phase-10-release.md`

- [ ] 10.1 AWS production in Mumbai:
  - RDS PostgreSQL 16, ElastiCache Redis (or Redis on the server), S3 with KMS
  - an EC2 Ubuntu server (no Docker): Nginx + systemd services `api`, `ws`, `celery-worker`, `celery-beat`
  - deploy script in `infra/`: pull, install, migrate, collect static, restart services
  - ALB + domain + TLS
  - Secrets Manager
  - CloudWatch alarms, Sentry
  - backups as in `docs/runbooks/backups.md` (RDS 7 days with point-in-time restore, S3 versioning) and the first restore test on the server *(moved from 9.6, developer decision 14 Oct 2026)*
- [ ] 10.2 Live services: Razorpay live keys + webhook, MSG91 DLT templates live, SES production access, FCM production, Google Maps keys restricted to the app signatures and admin domain.
  - ~~S3 uploads: a presigned POST with a `content-length-range`~~ → moved to 9B.5 (developer, 14 Oct 2026).
- [ ] 10.3 Admin panel deployed (HTTPS, admin domain only in CORS). First Super Admin created. Roles assigned.
- [ ] 10.4 Play Console:
  - WellWish + WellWish Partner listings
  - data-safety form
  - **background-location declaration + video** (Partner app)
  - internal → closed testing
- [ ] 10.5 App Store: Patient app listing and review.
- [ ] 10.6 Privacy policy, terms and refund policy published and linked in the apps and stores.
- [ ] 10.7 Ops runbook: assigning, calling partners, refunds, SOS drill, partner verification. Train the client's team.
- [ ] 10.8 Go-live checklist and pilot with real partners.

### Exit criteria
- [ ] Both apps are available to testers from the stores (or live).
- [ ] The first real booking goes paid → assigned → completed in production.
- [ ] The client signs off the go-live checklist.
