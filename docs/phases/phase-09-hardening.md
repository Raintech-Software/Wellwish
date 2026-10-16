# Phase 09 — Polish and hardening · Completion report

| Item | Value |
|---|---|
| Started | 13 Oct 2026 |
| Completed | 14 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice) |
| Architecture version used | v2.19 at the start → v2.30 |

## Summary
WellWish is now translated, measured and hardened. Every screen and message is in English, Hindi and Odia (SMS stay English, 19 DLT templates), with a check that fails on hard-coded text. Admins have a dashboard and four reports with CSV. The §12 security checklist was gone through item by item with evidence: an IDOR test that covers every endpoint, limits on every write, masked logs everywhere, obfuscated builds, a root warning, the fake-GPS rules and the admin panel's security headers. The load test met its target (p95 61 ms against 300 ms). Sentry is ready in every app (off until a DSN is added), the CloudWatch alarms are files ready for the server, and an SOS nobody acknowledges in 2 minutes now reaches the Super Admins and the support phone. Backups and a restore test run on the PC. Admins can edit, block and start the deletion of a patient account, and large text and tap targets were fixed.

A deep check by three reviewers (30 issues) and a live check in the browser (4 more) found problems before the close; all are fixed and re-tested. Parts that only exist on a server (backups on RDS / S3 and their restore test, TLS, Secrets Manager, the S3 upload path) come with the developer's deploy (10.1). 9.7 wasn't built (the client hasn't confirmed it) and 9.9 wasn't asked for.

## Plan (from the inventory of 13 Oct 2026)
Three read-only inventories (translations; security and monitoring; dashboard, reports, accessibility, patient admin) found what each task still needs:

- **9.1 Translations.** The 720 app texts are complete in Hindi and Odia and the inbox/push templates too. Still to do:
  - Odia letters: Poppins has none (the phone's font was used) → bundle Noto Sans Oriya / Devanagari as the fallback. *(done)*
  - Partners can't choose a language (always English) → a language choice in the Partner app and an endpoint.
  - Partner emails (approved, changes requested, rejected, suspended, deactivated, document expiring) are English only.
  - English values inside translated texts: dates ("Tue 13 Oct, 10:00 AM"), service names (the Hindi / Odia names exist in the price snapshot), "not shared", "there".
  - Server texts without Hindi / Odia: required-document hints and conditions; the member's language word in the Partner app; the service name on the partner's reviews.
  - A check that fails on hard-coded text (exit criterion), in `.\ww.ps1 check`.
  - The final DLT SMS list (18 templates, English, `{#var#}` format).
  - A review sheet for the client (the Hindi / Odia texts are drafts until they check them).
- **9.2 Dashboard and reports.** No dashboard endpoint or page yet (a placeholder). Fee report CSV and audit-log CSV exist. To build: `GET /v1/admin/dashboard` (widgets by permission), reports for bookings, cancellations and refunds, partner performance (fees collected exists), a shared CSV helper with the formula guard, every export logged.
- **9.3 Security checklist (§12).** Mostly in place. To do:
  - an IDOR test for **every** endpoint (211 HTTP endpoints; missing for offers, cancel / reschedule, balance, SOS, patient-not-available, several admin routes), with a test that fails when a new endpoint isn't covered;
  - rate limits on all write endpoints (11 of 131 have one);
  - log redaction (no logging filter; query strings with phone searches in the access log; Sentry breadcrumbs);
  - `--obfuscate` builds and a root warning in the Partner app (neither exists);
  - fake-GPS flag for step and SOS positions; security headers in the admin panel.
- **9.4 Load test.** Nothing yet: Locust (in Docker) against a production-like API.
- **9.5 Monitoring.** Sentry in the backend only → add to both apps and the admin panel (off until a DSN is added); CloudWatch alarms as files (no AWS yet); "SOS not acknowledged in 2 minutes" has no escalation.
- **9.6 Backups.** Nothing yet → backup and restore commands, a runbook, a local restore test; the staging test waits for the server.
- **9.7** Not built: the client hasn't confirmed the optional features (developer, 13 Oct 2026).
- **9.8 Accessibility.** No text-size handling or tests; a few small tap targets (link buttons, the consent checkbox).
- **9.9** Only if the developer asks.
- **9.10 Patient admin actions.** Read-only today → block / unblock (patient app only), edit on the patient's request (logged), start deletion for a caller.
- **9.11 Carried over** (see PHASES).

## Tasks
- [x] 9.1 Hindi and Odia for every screen and notification template; the final list of DLT SMS templates (19, English).
- [x] 9.2 Admin dashboard and reports (bookings, fees collected, cancellations and refunds, partner performance), with CSV.
- [x] 9.3 The §12 checklist item by item (IDOR for every endpoint, write limits, log masking, obfuscated builds, root warning; also fake GPS and the admin panel's headers). The admin panel's signed-in pages were checked live on 14 Oct 2026.
- [x] 9.4 Load test with Locust: 100 partners every 10 s + 30 bookings a minute, p95 61 ms (target 300 ms).
- [x] 9.5 Monitoring: Sentry in all apps (off until a DSN), CloudWatch alarms from §13 as files, SOS escalation.
- [x] 9.6 Backups: tested locally (developer decision 14 Oct 2026); the server part moved to 10.1.
- [ ] 9.7 Optional features: not built, the client hasn't confirmed them.
- [x] 9.8 Accessibility: 200 % text and 48 dp tap targets on the key screens.
- [ ] 9.9 Hard delete of a partner: not asked for (Deactivate covers it).
- [x] 9.10 Admin actions on a patient account (edit on request, block / unblock, start deletion).
- [x] 9.11 The small fixes carried over from phases 1, 3, 8 and 8B.

### Exit criteria
- [x] Every item in §12 is ticked with evidence (the table under 9.3; parts that need a server are marked for the deploy).
- [x] Load test meets the target.
- [x] No hard-coded text left (`flutter: no hard-coded text` in `.\ww.ps1 check`).
- [x] Restore test: on the PC, passed 14 Oct 2026; the developer decided it replaces the staging one, and the server's comes with the deploy (10.1).

## What was built
### 9.1 Translations (13 Oct 2026)
- **Odia letters on every phone:** Poppins has none, so Noto Sans Oriya (Regular, Bold) and Noto Sans Devanagari (4 weights) are bundled in `ww_ui` (OFL, `fonts/OFL-NotoSans*.txt`; downloaded from the Noto project with the developer's OK) and set as the fallback of every text style (`WWFont.fallback`). Seen on the emulator: the whole Partner app in Odia, bold headings included.
- **Partners choose their language:** a translate button in every Partner app bar (approved home, registration hub and status, role choice, temporary home) opens English / हिन्दी / ଓଡ଼ିଆ; the app switches at once and the server keeps it (`PUT /v1/partner/me/language`, open at every status). A **new account starts in the phone's language** (the login sends `language`; an existing account keeps its choice). Before, every partner was English after login.
- **Messages in the person's language, values too:** `notify()` resolves values per language — the visit's date with the apps' own Hindi / Odia day and month names (`notifications/text.py`, from Intl/CLDR), the service's Hindi / Odia name from the booking — for push, inbox and email; SMS get the English values. The six partner emails (approved, changes requested, rejected, suspended, closed, document expiring) now exist in Hindi and Odia (migration `notifications/0008`). "Hello there" became a polite word per language.
- **Server texts the apps showed in English:** required documents got `help_hi/help_or` and `condition_hi/condition_or` (filled for the seeded ones, editable on the admin's Required documents page); the partner's reviews carry the service name in Hindi / Odia; the member's language word ("Odia") is shown in the app's language; the **share page** relatives open (`/t/`) follows the sharer's language (`?l=hi|or`, else the phone's) with the apps' step names.
- **SMS stay English** (developer decision): the final list of the **18 DLT templates** with their `{#var#}` / `{#url#}` form and MSG91 flow texts is `docs/DLT-SMS-TEMPLATES.md` (generated from the code; KEYS-AND-ACCOUNTS #3 links it). A DLT variable is at most 30 characters, so `send_sms` shortens longer values (a long reason no longer gets the SMS dropped); links are `{#url#}` with whitelisted domains.
- **No hard-coded text:** `tool/check_texts.dart` (in `.\ww.ps1 check`, "flutter: no hard-coded text") fails on a string with letters given to a widget that shows it; proven on a throwaway file (it caught `Text('Hello world')` and a tooltip, let the brand and interpolations through). The code passes.
- **For the client:** `docs/translations/wellwish-texts-for-review.csv` — all 825 texts (720 app texts, inbox/push/email templates, document names and hints, service names) in English, Hindi and Odia with "correct? / better wording" columns, and a README saying where each correction goes.
- Also: the Dart width (120) recorded in each package's `analysis_options.yaml` so `dart format` keeps the project's style; the Partner app's logo title shrinks instead of overflowing when the app bar has three icons.

### 9.2 Dashboard and reports (13 Oct 2026)
- **Dashboard** (`/`, was a placeholder): `GET /v1/admin/dashboard` (`dashboard.view`, new `apps/dashboard`, no tables: it reads the owning apps' selectors). Today's visits by status (not assigned, waiting for an answer, partner assigned, in progress, completed, patient not available, cancelled) and the Unassigned queue (today, later, past the assign deadline) for `bookings.view`; fees today and this month for `payments.view`; applications waiting and the oldest for `partners.review`; alerts not seen by kind and open SOS for `bookings.view` / `live.view`. A part a role can't see is null and not shown (Finance sees fees, Verification applications, Support bookings and alerts). Updates on live messages and every minute. Seen in the browser with the dev data.
- **Reports** (new menu section): **Bookings** (by visit date and by service), **Fees collected** (the fee report moved here from Payments, now also on screen; the old address redirects), **Cancellations and refunds** (each cancelled booking: by whom, why, refund %, fee paid, refunded, refund status; and refunds after a visit), **Partner performance** (jobs done, patient not available, offers received / accepted / declined / not answered in 2 minutes, acceptance %, rating; a temporary assign isn't an offer). Each has a date range (this month by default, at most a year) and "Download CSV". Permissions: the one the data already needs (`bookings.view`, `payments.view`, `partners.view`), no new permission.
- **One CSV helper** (`common/reports.py`): UTF-8 with a BOM, `no-store`, a text cell starting with `=`, `+`, `-`, `@`, a tab or a line break gets a leading `'` (a reason like `=HYPERLINK(…)` stays text), amounts are numbers; the fee and audit-log exports use it too. Every CSV is audit-logged (`reports.exported` with the report and dates).
- Endpoints: `/v1/admin/dashboard`, `/v1/admin/reports/{bookings,cancellations,partners}` (+ `/csv`), `/v1/admin/reports/fees/days`; selectors `bookings.day_counts / bookings_report / cancelled_between`, `payments.cancellations_report`, `assignments.partner_performance / open_alert_counts`, `kyc.applications_waiting`, `safety.sos_open_count`.
- Tests: `apps/dashboard/tests` (8: each role's parts, today's numbers, each report on screen and as CSV with the BOM, the formula guard and the audit entry, the range limit, the permissions, temporary assigns not counted as offers).

### 9.3 Security checklist §12 (13 Oct 2026)
- **IDOR test for every endpoint** (`backend/common/tests/test_idor.py`, 6 tests). The test walks the API's routers, so it sees every endpoint:
  - every patient endpoint that takes an id (18) is called by another patient with the first one's real booking, address, member and document ids and a valid body: all answer 404 and nothing of the first patient changed;
  - every partner endpoint with an id (11: offers, accept / decline, job, steps, calls, patient not available, balance, SOS, track batch, document view) is called by another approved partner: all 404, the offer is still the first partner's;
  - every admin endpoint needs a permission (`staff_permission` / `staff_any_permission` now mark the view with it); the 10 that don't (sign-in steps, the admin's own account, the upload link that checks each file purpose) are listed with their reason;
  - **a new endpoint fails the test** until it is added to one of those lists;
  - every request body is a schema with `extra="forbid"` (90 bodies).
- **Rate limits on all writes** (`common/middleware.py`): every POST / PUT / PATCH / DELETE under `/v1/` counts per caller (60 a minute, by access token) and per IP (300, for a hospital's shared Wi-Fi); over it 429 `TOO_MANY_REQUESTS` with `Retry-After`, and the apps say "Too many changes in a minute…" in their language. Reading isn't limited. Left out: sign-in and token refresh (OTP, admin sign-in and email codes keep their own stricter limits) and the dev file stand-ins; Razorpay's signed webhook counts per IP only (both after the deep check). **Rate-limit keys are now hashed** (they held the full phone number: a 9.11 item). Settings `WRITE_RATE_LIMIT_PER_MINUTE`, `WRITE_RATE_LIMIT_PER_IP_MINUTE` (0 = off; the load test turns the IP one off). Tests: `common/tests/test_rate_limit.py` (3).
- **Log redaction** (`common/redact.py`): a filter on the console handler masks every log line, the web server's access log included (an admin's phone search was in its query string): phone numbers → `[phone …3210]`, tokens, a code next to "otp" / "code" / "pin", 12-digit numbers. Sentry gets the same mask on messages, exception texts and breadcrumbs (a database breadcrumb can hold a phone number). Tests in `common/tests/test_hardening.py`: the mask itself (7 cases), the configured handlers of the app and the web server, Sentry events and breadcrumbs.
- **Fake GPS**:
  - a step's or "patient not available" position marked `mock` (Android's flag, now sent by the Partner app with each step) is not kept: the step still saves (the visit goes on); an arrival is then flagged as "no position", and the admin gets MOCK_GPS;
  - live points were already refused;
  - **fake GPS on 3 different jobs suspends the partner for review**: §6.16 said so and it wasn't built. The rule after the deep check:
    - it counts different jobs flagged since the partner was last approved or reinstated;
    - it never suspends in the middle of a visit: it waits until that job ends (`partners.suspend_for_fake_gps`, run again on `booking.completed` / `booking.no_show`);
    - the partner's row is locked, so two flags at once can't break a step.
    The suspension is the admin's own: logged out, open offers back to the queue, the "suspended" SMS with the reason "Fake GPS location on 3 jobs".
  - **An SOS with a fake position** still goes (never refused). It's flagged for the admins ("Fake location app: call them" on the Live page), and the emergency SMS leaves the place out (deep check).
  - Tests: `test_a_fake_location_on_a_step_is_not_kept_and_the_admin_is_told`, `test_fake_gps_on_three_jobs_suspends_the_partner_once_the_visit_is_over`, `test_an_sos_from_a_fake_location_still_goes_but_is_flagged`, and the Partner app's `a fake (mock) location goes up marked as fake`.
- **Obfuscated builds**: `.\ww.ps1 build patient|partner [prod|staging|dev] [apk|appbundle]` runs `flutter build … --release --obfuscate --split-debug-info=build\symbols\<app>\<flavor>\<version>`. Release builds are signed with the upload key from `android/key.properties`, or the debug key with a note when there's no key yet (KEYS-AND-ACCOUNTS #16).
  - Built the Partner app (dev flavor, 57 MB): no class or API method names left in its `libapp.so`, which has no debug sections (the symbols are on the PC).
  - Installed on the emulator: it signs in and loads Home (screenshot `img/phase-09/partner-release-obfuscated-home.png`).
  - The build left the Gradle daemon running when JAVA_HOME wasn't set; the command now uses Android Studio's Java for `gradlew --stop`.
- **Root warning (Partner app)**:
  - `MainActivity.kt` answers `looksRooted` on the channel `in.wellwish.partner/device`: a test-keys build, an `su` binary or Magisk's folders.
  - Home (and the temporary partner's Home) then shows a red notice: "This phone looks rooted…", in English, Hindi and Odia. It never blocks.
  - The emulator isn't rooted (release-keys, no `su`), so on it the check answers "no" and nothing shows. The rooted case is a widget test (`test/rooted_warning_test.dart`, 2 tests).
  - The release APK's code contains the check (R8 kept it).
- **Admin panel headers** (not in the original list; found in the inventory):
  - Content Security Policy with a fresh nonce per page (`src/proxy.ts`): only the panel's scripts run; images and frames only from the panel, OpenStreetMap tiles and S3. The root layout renders per request for this.
  - Also X-Frame-Options DENY, nosniff, `Referrer-Policy: strict-origin-when-cross-origin` (OpenStreetMap needs the origin), Permissions-Policy (no camera or microphone; location only for the panel itself, for "Use my current location"), COOP, and HSTS in production (`next.config.ts`). The referrer and location values were corrected in the deep check.
  - Seen in the browser: the login page loads with every script carrying the nonce and no CSP error; the signed-in pages in the live check (below): map tiles, the staff socket, an upload and its preview, the PDF preview, 13 pages with no CSP refusal.
- `.\ww.ps1 check` after 9.3: all 11 steps pass (backend 627 tests, Partner app 63, Patient app 57, packages 52; admin lint and build).

#### §12 item by item, with evidence
| §12 item | Status | Evidence |
|---|---|---|
| Transport: HTTPS only, TLS 1.2+, HSTS | ✅ in code · TLS itself in Phase 10 | `config/settings/deployed.py` (SSL redirect, HSTS 1 year with subdomains, secure cookies, nosniff); admin HSTS in `next.config.ts`. The TLS version is set on the load balancer / Nginx when the server exists (Phase 10). |
| OTP | ✅ | `apps/accounts/tests/test_otp.py`: Indian numbers only, only an HMAC stored, 5-minute codes, 5 wrong tries, resend waits, per phone / IP / device limits, 10 wrong codes lock for an hour, no OTP / token / full phone in logs |
| Partner contacts | ✅ | Phase 3 (`apps/partners/tests`): both phones by OTP, email by code |
| Tokens | ✅ | `apps/accounts/tests/test_sessions.py`: rotation, reuse revokes the family, refresh stored only as hashes, tokens of one app refused by the other and by the admin, tampered / expired tokens; `common/tests/test_auth.py::test_wrong_audience_never_reaches_the_decorators` |
| Admin | ✅ | `apps/staff/tests/test_staff_login.py`: TOTP set-up, wrong / reused codes, lockouts, 30 minutes idle signs out, strong password; audit rows can't be changed even with SQL (`apps/audit/tests`) |
| Authorization | ✅ (9.3) | `common/tests/test_idor.py` (above) |
| Input | ✅ (9.3) | `StrictIn` (`extra="forbid"`); `test_every_request_body_refuses_unknown_fields` |
| SQL | ✅ | Django ORM; the only raw SQL (booking code sequence, the time lock, the health check) has no user text or uses `%s` parameters |
| Files | ✅ · S3/KMS in Phase 10 | `apps/files/tests`: type and size checked up front, magic bytes and extra bytes refused, signed short links; `test_after_the_job_phones_last_1_hour_and_documents_24_hours`; the bucket's KMS key is set when it is created (KEYS #9) |
| Aadhaar | ✅ | `apps/kyc/tests/test_review.py::test_aadhaar_is_stored_masked`, `test_document_numbers_are_masked_or_kept_as_printed`; the log mask catches a 12-digit number anyway |
| Location | ✅ (9.3) | `apps/tracking/tests` (only in an in-progress job; mock, inaccurate and too-fast points refused; fake GPS on 3 jobs suspends after the visit), `apps/bookings/tests/test_visit.py` (a mock step position is not kept), `apps/safety/tests` (an SOS from a fake position is flagged) |
| Payments | ✅ | `apps/payments/tests/test_payments.py`: bad signatures refused, duplicate webhook ignored, amount tampering has no effect, the snapshot price, secrets encrypted and never shown |
| Logs | ✅ (9.3) | `common/redact.py` + tests; Sentry `scrub_event` / `scrub_breadcrumb` tests |
| Rate limits (new row) | ✅ (9.3) | `common/tests/test_rate_limit.py` |
| Admin panel (new row) | ✅ (9.3, live check 14 Oct 2026) | `src/proxy.ts`, `next.config.ts`. In the browser: the login page (nonce on every script); signed in, the Live map's tiles and the staff socket (an alert arrived without a reload), an admin upload and its `blob:` preview, a patient's PDF in the viewer, and 13 pages with no CSP refusal. The deep check had found three breakages first; all fixed: uploads to S3, map tiles (referrer), "Use my current location". The S3 upload itself is seen on staging (Phase 10): in dev the files go to the API. |
| Client IP | ✅ | `common/tests/test_hardening.py::test_client_ip_*` (3) |
| CSV exports | ✅ (9.2) | `apps/dashboard/tests/test_reports.py`: the formula guard and the audit entry for each export |
| Secrets | ✅ in code · Secrets Manager in Phase 10 | Nothing in Git (`.gitignore`: `.env`, keys, keystores, `key.properties`); servers refuse to start with dev values (`test_servers_start_with_real_sms`, `test_servers_refuse_the_dev_console_sms`) or with a JWT / OTP key equal to the secret key (`config/settings/deployed.py`). Secrets Manager and the Maps key restriction come with the server and the keys (KEYS #1, #10). |
| Mobile | ✅ (9.3) | Secure storage (`SecureTokenStorage`, Phase 1); obfuscated builds and the root warning (above) |
| Privacy | ✅ | Consents with version, time and IP (`test_consents_are_recorded_with_version_time_and_ip`); deletion tests in `apps/patients/tests` (erasure after the waiting time, sessions, photos) |
| Backups | ✅ local (9.6) · server in Phase 10 | `.\ww.ps1 backup` / `restore-test` tried here (below), runbook `docs/runbooks/backups.md`; RDS / S3 settings and the restore test on the server come with the deploy (10.1) |

### 9.4 Load test (13 Oct 2026)
- **`.\ww.ps1 loadtest [minutes] [API processes]`** (default 5 minutes, 1 process). Your dev data is never touched:
  1. a fresh database `wellwish_loadtest` and its own Redis numbers;
  2. the API as on a server: `config.settings.loadtest` = the dev settings without DEBUG or auto-reload, the per-IP write limit off because every simulated phone comes from one container (the per-person limit stays on); plus a Celery worker;
  3. `manage.py loadtest_data`: 100 approved partners, each on a job already in progress with the family that booked it, and 100 more patients with a family member and an address. Their tokens go to the git-ignored `backend/.loadtest/users.json`;
  4. Locust (`infra/loadtest/`, image `locustio/locust:2.32.0` + `websocket-client`), headless; the report goes to `infra/loadtest/results/report.html` (git-ignored).
- **What Locust does** (`infra/loadtest/locustfile.py`):
  - each of the 100 partners sends `location.update` every 10 s over the partner socket, as the app does. Phones aren't in step: each starts at a random moment.
  - Each job's family listens on the patient socket. **"WS location → family"** is the time from the partner sending a point to the family getting `booking.location`, so the whole chain is measured: socket, checks, Redis, and passing it on to the family's socket.
  - Each partner opens Home every minute.
  - Patients book 30 times a minute: the services, the times of the first free date, the times of a picked date, the booking, the booking page.
  - The first 15 s after everyone started don't count (warm-up).
  - The run fails if any request type has p95 ≥ 300 ms or anything failed.
- **Results**: target met, nothing failed.

  | Request | 1 API process (5 min): median / p95 ms | 2 API processes (3 min): median / p95 ms |
  |---|---|---|
  | WS location → family (10 a second) | 9 / 27 | 9 / 17 |
  | GET partner Home | 51 / 110 | 40 / 59 |
  | GET booking times | 28 / 49 | 25 / 35 |
  | GET booking times of a date | 27 / 47 | 24 / 33 |
  | POST booking (30 a minute) | 59 / 85 | 55 / 69 |
  | GET the booking | 38 / 55 | 34 / 42 |
  | GET services | 19 / 39 | 19 / 27 |
  | **All** | **12 / 61** (3,894 requests) | **10 / 50** (2,180 requests) |

  The numbers are in `img/phase-09/loadtest-1-process.csv` and `loadtest-2-processes.csv`. The PC also ran the dev stack and the emulator; a server does better.
- **The slow part found and fixed**:
  - a first 1-minute trial was much slower (p95 730 ms, Partner Home 420 ms median). Measured alone, Partner Home takes 16 ms and a location point 3–22 ms; the cost was a fresh API process.
  - Its first request loaded every API module (1.9 s), and the trial had restarted the API just before 100 partners all called at the same second.
  - Fixed: each server process now loads the API when it starts (`config/asgi.py`; the first request now takes 17 ms), so with several processes no user waits for it.
  - The test no longer restarts the API (the Locust image is built first and run without its dependencies), and partners start at random moments as real phones do.
- With two processes, the family still gets every point at once although the partner's socket and the family's are in different processes (through Redis).
- After the deep-check fixes (the image built first, 3-hour test tokens, the verdict also failing on errors in the test itself or lost live points): a 1-minute run, 496 requests, nothing failed, no point lost, p95 46 ms.

### 9.5 Monitoring (13 Oct 2026)
- **SOS not acknowledged within 2 minutes** (§13; nothing did this before):
  - a check every minute (`safety.escalate_unacknowledged_sos`) finds an SOS still open after 2 minutes;
  - the Super Admins get an email and WellWish's support phone (Settings → Support) an SMS, the new DLT template `SOS_UNACKED` (now 19 templates; `docs/DLT-SMS-TEMPLATES.md`, KEYS #3);
  - once per SOS (`sos_events.escalated_at`, migration `safety/0002`); an SOS acknowledged in time is left alone. The panel's alarm keeps ringing as before.
  - Test: `test_an_sos_nobody_acknowledges_in_2_minutes_reaches_the_super_admins`.
- **The numbers behind the alarms** (`common/metrics.py`):
  - SMS failures, email failures, Razorpay webhook failures, bad webhook signatures (their own number since the deep check) and offer timeouts are counted where they happen, in Redis.
  - Every minute (`common.publish_metrics`) they're taken, along with two measurements: bookings still unassigned 30 minutes after payment, and SOS waiting more than 2 minutes.
  - They go to CloudWatch when `CLOUDWATCH_NAMESPACE` is set (the server's IAM role, no keys); otherwise they're only logged. A failing metric never breaks the request it's in.
  - Tests: `common/tests/test_metrics.py` (4).
- **CloudWatch alarms as files** (no AWS account yet, developer decision):
  - `infra/cloudwatch/alarms.json` holds the alarms of §13 (8 here; 10 after the deep check added bad webhook signatures and "metrics missing"): 5xx and p95 latency (load balancer metrics, p95 > 300 ms = the 9.4 target), unassigned over 30 minutes, offer timeouts, SOS not acknowledged, webhook failures, SMS failures and email failures. Each has a plain description of what to do.
  - `infra/cloudwatch/create_alarms.py` creates or updates them for an environment through the AWS CLI. Its `--dry-run` was run here: 8 alarms, and every metric the backend sends has one.
- **Sentry in all apps**, off until a DSN is added:
  - **Patient and Partner apps**: Sentry's pure-Dart package `sentry` 10.0 in `ww_core` (`runMonitored`, used by both apps' `bootstrap`; it catches Flutter errors and uncaught Dart errors). `sentry_flutter` was tried first: 8.14's Android part doesn't compile with this project's Kotlin (language version 1.6 refused), and 10.0 needs **Android 8+** (minSdk 26) while the apps support **Android 7+** (minSdk 24). Raising it would drop phones, so that's left for the developer to decide (it would add native-crash reports). On only with `--dart-define=SENTRY_DSN` (`.\ww.ps1 build` adds `SENTRY_DSN_PATIENT` / `SENTRY_DSN_PARTNER` when they're set on the PC). Errors only: no tracing, no user or device ids. Messages, exceptions and breadcrumbs pass the same mask as the server (a Dart copy of `common/redact.py`). Tests: `packages/ww_core/test/monitoring_test.dart` (3). The Partner app with it built and ran on the emulator.
  - **Admin panel**: `@sentry/browser` 11.7, started by `components/Monitoring.tsx` only when built with `NEXT_PUBLIC_SENTRY_DSN`. It collects no user, cookies, headers, query strings or bodies, uses the same mask, and the CSP allows the DSN's host only then. The mask was checked against the server's cases (compiled and run in Node); the panel loads with no CSP violation or error.
  - Obfuscated app builds need their symbols uploaded to Sentry for readable stack traces (Phase 10, KEYS #7).
- `.\ww.ps1 check` after 9.5: all 11 steps pass (backend 632 tests, Partner app 63, Patient app 57, packages 55; admin lint and build).

### 9.6 Backups (13–14 Oct 2026)
- **`.\ww.ps1 backup`**:
  - `pg_dump` (custom format) of the dev database into `backups\wellwish-<date>.dump` (git-ignored);
  - the exact row count of every table in `.counts.txt`, counted before and after the copy (a change meanwhile means another try, so the counts belong to the copy);
  - the uploads (`backend\media`) in `-media.zip`.
- **`.\ww.ps1 restore-test [file]`** (default: the newest backup):
  - restores into a separate database `wellwish_restore`, so the dev database is never touched;
  - passes when every table has the rows it had at backup time and the app finds every migration applied (`manage.py migrate --check` against it);
  - then removes `wellwish_restore` again. A failed test keeps it for a look.
- **Tested here:**
  - backup: 64 tables, 0.3 MB database plus 6 MB of uploads;
  - restore test: all 64 tables match, every migration applied;
  - a backup whose counts file was changed (audit_log 215 → 9999) made the test fail with the difference shown.
- **Runbook** `docs/runbooks/backups.md`:
  - what's backed up where: RDS automated backups 7 days with point-in-time restore, a manual snapshot before each release, S3 versioning with old versions kept 7 days, nothing for Redis;
  - a deleted account leaves the backups 7 days after it is erased, so at most the waiting time + 7 days after the request (corrected in the deep check);
  - the server set-up, the monthly restore test into a temporary RDS instance (AWS CLI commands, the same row-count query `infra/postgres/row_counts.sql`, `migrate --check`, a file restored from S3 versions);
  - a real restore after an incident;
  - local restore into the dev database;
  - a log of the restore tests (the local one is the first row).
- **The server part** (RDS and S3 settings, the restore test on the server): the developer deploys to a server by hand once every phase is done, so it moved to 10.1 (developer decision, 14 Oct 2026).
- **Tested again at the close (14 Oct 2026):** a fresh backup (`wellwish-20261014-110001.dump`, 64 tables) restored with every table's rows matching and every migration applied; its uploads zip opens and holds exactly the 21,267 files on disk.

### 9.10 The admin's actions on a patient account (13 Oct 2026)
- **Block / unblock** (abuse; `patients.manage`, a reason, logged as `patient.blocked` / `patient.unblocked`):
  - the patient app only (`patient_profiles.blocked_at`, `blocked_reason`, migration `patients/0003`);
  - logged out on every phone at once; OTP login, Google sign-in and token refresh are refused with 403 `ACCOUNT_BLOCKED`, and the app says "This account is blocked. Please contact WellWish support.";
  - the partner app of someone who is also a partner keeps working; bookings stay as they are (the admin cancels any that must go);
  - the patient page shows a red notice with the date and reason.
- **Edit on the patient's request** (`PUT /v1/admin/patients/:id`):
  - name, date of birth, gender, app language: the profile screen's details, through the same service (the SELF member follows);
  - the phone number can't change (it's the login);
  - a reason is required, and the audit row (`patient.updated`) lists which details changed, not their values (audit rows outlive an erasure; deep check).
- **Start account deletion for a caller** (`POST …/deletion`): the app's own "delete my account" (409 `ACTIVE_BOOKINGS` while a paid booking isn't finished, logged out at once, erased after the waiting time unless they log in again), logged as `patient.deletion_requested`.
- **Admin panel**: Edit details, Block / Unblock and Start account deletion on the patient page (`components/patients/PatientActions.tsx`, only with `patients.manage`), each explaining what happens and asking for the reason.
- **Why a session ended, in both apps** (also the 9.11 item "`ww_core` session end reason 'job over'"):
  - `SessionEndReason` gained `accountBlocked` and `jobOver`, read from the socket's `session.revoked` or a refused refresh (403 ACCOUNT_BLOCKED, 401 SESSION_REVOKED {reason});
  - the login screen says "This account is blocked…" or "Your WellWish job is over. Thank you!";
  - the Partner app's own workaround (a Dio interceptor remembering the server's reason) is gone.
- **Tests**:
  - backend `apps/patients/tests/test_admin_patients.py` (3 more): block keeps them out of the patient app but not the partner app, unblock lets them back, only `patients.manage`; the edit needs a reason and logs only the change; deletion for a caller;
  - the every-endpoint test covers the 4 new endpoints;
  - `ww_core` `core_test.dart` (the reasons from the socket and from a refused refresh) and the Patient app's `blocked by WellWish: the login screen says so`.
  - Seen in the browser (live check, 14 Oct 2026) on the test patient Asha Das: each action asks for a reason (an empty one is refused); Edit is logged as `{"changed": ["full_name"]}`; Block shows the red notice, her app's session ends at once (401, then the refresh is refused with ACCOUNT_BLOCKED) and a new login is refused; Unblock lets her log in; Start deletion shows "removed on 21 Oct 2026" and ends her session; an admin edit meanwhile keeps the deletion pending; her login then cancels it.

### 9.8 Accessibility (13 Oct 2026)
- **Large text: every screen the tests visit, at 200 %.**
  - Both test harnesses take `--dart-define=WW_TEXT_SCALE=2`, so every widget test (the whole flows) runs with Android's largest text. Nothing in the apps caps the text size.
  - Patient app: no layout overflowed.
  - Partner app: 4 overflows, all in two bottom sheets, the **visit-code entry** and the **SOS sheet**. With large text their buttons were cut off below the screen, and for SOS that means the emergency buttons. Five sheets that didn't scroll now do: those two, the language choice, the patient's SOS, the booking-type choice. 0 overflows after.
  - The other failures in those runs were tests looking for widgets that large text had pushed below the screen (lists build lazily), not problems a person would see.
- **Tap targets and names** (Flutter's `androidTapTargetGuideline`, 48 × 48 dp, and `labeledTapTargetGuideline`, both in `accessibility_test.dart` of each app, at 100 % and 200 %):
  - Patient app: login and code screens, Home, the services, visit details, a booking in progress, live tracking, the SOS sheet.
  - Partner app: Home with an offer, the offer, the job in progress, the visit-code sheet, the SOS sheet. Login is shared and checked in the patient test.
  - Found and fixed:
    - the **"Create Account" / "Resend code" link** was 32 dp tall (now 48);
    - the **date, time and choice pills** were 42 dp (now at least 48);
    - Home's **notifications bell** had no name (now "Notifications");
    - the **code boxes** were a nameless tap area over a hidden field (now one field TalkBack calls "The 6-digit code", new text in English, Hindi and Odia, in the review sheet);
    - the **hospital card** on visit details was a nameless tap area around its own tappable row;
    - the **consent tile** had a small, nameless checkbox inside: now the whole tile is one control read as the title, the detail and ticked / not ticked (a ww_ui test checks it).
- **Tests:** patient `accessibility_test.dart` (6), partner `accessibility_test.dart` (4), ww_ui `widgets_test.dart` (+1). Four older tests now scroll to a button before tapping it (the 48 dp pills moved it lower on the test's screen).

### 9.11 Small fixes carried over (13 Oct 2026)
- **Old bookings that never happened** (Phase 8):
  - a booking still waiting (unpaid, unassigned, accepted but never started) whose pickup was more than 12 hours ago now shows under **Past** with its status, not as Home's "Next booking" or under Upcoming;
  - an accepted booking not "On the way" 30 minutes after pickup raises a new **NOT_STARTED** alert for the admins, once (`bookings.not_started_sweep`, every 10 minutes, migration `assignments/0006`);
  - nothing closes by itself: a paid booking's money (refund or not) is the admin's call, so they call the partner, mark the steps or cancel;
  - the live check found two gaps, both fixed: the check only looked 2 days back (a booking stuck since 11 Oct raised nothing; now a month), and the Live page didn't list NOT_STARTED (now with the other visit alerts). Test: `test_a_booking_stuck_for_days_is_still_flagged_up_to_a_month_back`.
- **"Pay ₹400 to Rashmita" after the partner recorded it** (Phase 8): now "Paid ₹400.50 to Rashmita" (new text `paidPartner` in English, Hindi and Odia).
- **The payment result kept "We're assigning your partner"** (Phase 8): it follows the booking, so "Partner assigned" once someone accepts while it's open.
- **The balance in whole rupees only** (Phase 8): rupees with paise (`450.50`), turned into whole paise without a float (`rupeesToPaise`).
- **The partner's review card without tags** (Phase 8): the family's tags as badges, good ones green and bad ones red.
- **Live location** (Phase 8):
  - a live point and a catch-up batch arriving together could each read the route and overwrite the other: both now take the booking's row lock while they add to it (not reproducible in a test; the tracking tests pass);
  - a socket that died silently went unnoticed for up to ~50 s: the apps ping every 10 s (~20 s);
  - a night job crossing midnight resumed sharing only from its job screen: Partner Home lists a job still in progress from an earlier day, so the app resumes from Home.
- **Rate-limit keys held the phone number** (Phase 1): hashed (9.3). **Old session rows never cleaned**: deleted every night 30 days after they were revoked or expired (`accounts.delete_old_sessions`).
- **View links showed the file's place** (Phase 8B):
  - new keys are opaque (`f/<random>.<ext>`), so a family can't tell a temporary partner's selfie from a profile photo;
  - attaching a file now checks its upload row (purpose and owner) rather than the folder in the key: just as strict, and older folder-style keys keep working.
- **`ww_core`'s session end reason "job over"** (Phase 8B): done with 9.10 (`SessionEndReason.jobOver`; the Partner app's own workaround is gone).
- **"Approve partner" without "are you sure"** (Phase 3): it now asks, as reject and request changes do. Seen in the browser (live check) on a real application: "Approve this partner?" with what happens next; "Not yet" leaves it under review; "Approve" approves it, and the SMS, the welcome email and the audit row follow.
- **Tests**:
  - backend `apps/bookings/tests/test_old_bookings.py` (3), `test_old_session_rows_are_deleted_every_night`, `test_a_file_is_attached_only_for_its_purpose_and_owner`;
  - Patient app `P20 once the partner recorded the balance`, `paid, then a partner accepts while the result is open`;
  - Partner app: the balance with paise, the review tags.

- `.\ww.ps1 check` after 9.5–9.11: all 11 steps pass (backend 640 tests, Partner app 68, Patient app 66, packages 57; admin lint and build).

## Deep check (13 Oct 2026)
Three independent reviewers each read one part of the code: the server, the apps, and the admin panel with the tooling and docs. They found 30 issues. All are fixed and re-tested below except where noted.

**Server**
1. **Fake-GPS suspension** counted flags forever (one job could count 3 times) and could log a partner out mid-visit; two flags at once could break a step. → Now 3 *different jobs* since the last approval or reinstatement, applied only once no visit is in progress, under the partner's row lock. Tests: `test_fake_gps_on_three_jobs_suspends_the_partner_once_the_visit_is_over`.
2. **Tracebacks weren't masked** (a database error quotes the phone number). → `RedactFilter` masks the traceback and stack. Test: `test_tracebacks_and_url_encoded_numbers_are_masked_too`.
3. **Celery replaced the masked handlers**. → `setup_logging` applies Django's LOGGING in the worker and beat. Test: `test_the_celery_worker_logs_through_the_same_mask`.
4. **URL-encoded phone numbers** in the access log slipped through. → Text is `%`-decoded before masking, and the access log has no query strings at all.
5. **An admin's edit cancelled a pending deletion** (through `ensure_profile`). → The admin path updates the profile without it.
6. **A failed SOS escalation was never retried**. → Email and SMS are separate handlers that raise on failure (the event task retries); a retry stops once someone acknowledged.
7. **Anyone could set off the webhook alarm** with bad signatures. → Bad signatures are their own metric (alarm at 20 in 5 minutes); webhooks now count against the per-IP limit.
8. **Rate-limit hashes could be reversed** (a phone number is only 10 digits). → HMAC with the server's secret key.
9. **`patients.manage` description** still said "later". → Describes edit, block and deletion.
10. **SOS positions weren't checked for fake GPS**. → Flagged, never refused (see 9.3).
11. **NOT_STARTED alerts stayed open**. → Closed when the partner taps "On the way".
12. **Two overlapping metric runs** could send negative counts. → One publisher at a time.
13. **Audit rows kept a patient's old and new name and birth date**, and audit rows outlive an erasure. → They list which details changed. **Sentry's `extra`** (Celery task arguments) is masked. Not changed: the per-IP limit of 300 writes a minute may be low for mobile networks that share one IP (CGNAT) at scale; it's a setting (`WRITE_RATE_LIMIT_PER_IP_MINUTE`) to watch once live.

**Apps**
1. **The code field was invisible to TalkBack** (inside `Opacity(0)`, and 9.8 had hidden its tap area). → `alwaysIncludeSemantics`. Test: `TalkBack finds the code field by its name`.
2. **Every pill in a wrapping row stretched to the full width** (the 9.8 height change). → Centred without widening. Test: `pills in a wrapping row stay as wide as their label`.
3. **A 429 (or timeout) on token refresh logged people out**, and the write limit covered refresh. → The apps keep the session; sign-in and refresh are left out of the write limit. Tests: `too many requests or a timeout on refresh keeps the session`, `test_writes_per_ip_and_sign_in_is_left_out`.
4. **SOS**: no fake-GPS flag, and the partner's SOS waited for a fresh fix (often none indoors). → Flag sent; the partner's SOS uses the point just shared when there is one. Test: `SOS sends the point just shared`.
5. **A malformed Sentry DSN stopped the app starting**. → Caught; the app runs without error reports.
6. **The hard-coded text check missed strings on the next line** and `TextSpan(text:)`, `hint:`, `prefixText:`… → Reads whole files; proved on a throwaway file (it caught three cases).
7. **Balance entry**: "450." was refused; a decimal comma was dropped. → Both work. Tests in `visit_test.dart`.

**Admin panel, tooling, docs**
1. **The CSP blocked uploads to S3** (staging and production). → S3 allowed in `connect-src`. KEYS #9 notes the bucket's CORS rule.
2. **Map tiles**: OpenStreetMap refuses requests without a referrer. → `strict-origin-when-cross-origin`.
3. **"Use my current location"** was blocked by `geolocation=()`. → `geolocation=(self)`.
4. **9.3 and 9.11 were ticked before their live admin check**, the §12 table claimed the signed-in pages were checked, and this table was empty. → Unticked until the live check; the §12 row and this table are corrected.
5. **A load test over ~12 minutes would fail** (15-minute tokens made before the image build). → The image is built first, and load-test tokens last 3 hours.
6. **The Locust verdict ignored errors in its own code and lost points**. → Both fail the run.
7. **The CloudWatch alarms stayed silent if the metrics stopped** (the SOS escalation stops with them). → A "metrics missing" alarm (10 alarms now).
8. **backup / restore-test could pass with nothing compared** (`Compare-Object` with an empty list). → They fail on empty counts. Tried: an empty counts file is refused. restore-test also applies newer migrations to an older backup now, as a real restore would; tried on this morning's backup: 3 migrations applied, passed.
9. **The backups wording**: a deleted account leaves the backups 7 days after the erase, which comes after the waiting time. → Runbook and §12 corrected.
10. **A network error left the patient-action button spinning**. → `finally`.
11. **Nested Sentry breadcrumb data** wasn't masked. → Masked however deep (admin panel, apps, server).

- `.\ww.ps1 check` after the deep-check fixes: all 11 steps pass (backend 644 tests, Partner app 69, Patient app 66, packages 60; admin lint and build).

## Live check (14 Oct 2026)
The developer signed in to the admin panel; everything below was done in the browser against the dev stack, with test accounts.

- **9.10** on the test patient Asha Das: all of it passed (details under 9.10).
- **9.11 "Approve partner"**: a new application sent through the API as the Partner app sends it (fresh numbers, codes from the dev outbox), its 5 documents approved, then the question, "Not yet", and "Approve" (details under 9.11).
- **9.3 admin panel under the CSP**: the Live map's tiles; the staff socket (the NOT_STARTED alert arrived without a reload, 13 → 14 alerts); an upload from the hospital form (upload link and file PUT 200, the photo preview shown; not saved); a partner's documents (Aadhaar and PAN masked); a patient's PDF in the viewer after a reason, logged as `patient_document.viewed` with the reason and no content; the dashboard, the fee report, bookings, the queue, services, settings, patients, partners: no CSP refusal, no failed request.
- **Found and fixed** (each re-checked in the browser):
  1. NOT_STARTED looked only 2 days back, so the booking WW-10008, accepted for 11 Oct and never started, raised nothing → a month (ARCHITECTURE v2.30, new test).
  2. The Live page didn't list NOT_STARTED alerts → listed with the other visit alerts.
  3. The patient-action dialogs warned that their form wasn't connected (antd) → the dialogs render their form up front (`forceRender`); the fields come pre-filled.
  4. The partner summary's two-column rows warned at narrow widths (antd Descriptions) → those rows fill their line (`span: "filled"`), same look.
- **Seen but not app problems**: a Leaflet "map container is being reused" error once, right after the Live page's code was edited (the dev server's hot reload); it doesn't come back on a fresh load or when leaving and returning. One old 500 in the console history isn't in the API's logs and didn't come back.
- `.\ww.ps1 check` after the live-check fixes: all 11 steps pass (backend 645 tests, Partner app 69, Patient app 66, packages 60; admin lint and build).
- **Test data left in the dev database**: the partner "Live Check Partner" (+91 70000 00101, approved) and a lab report in Asha Das's documents. Harmless; the partner can be deactivated from the admin panel if it gets in the way.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| SMS stay English (18 → 19 DLT templates); apps, inbox, push and email in Hindi / Odia | Cheaper, one DLT registration each | yes (13 Oct 2026) | v2.20 |
| Sentry in the apps is the pure-Dart package: no native Android crash reports | `sentry_flutter` needs Android 8+; the apps support Android 7+ | yes (14 Oct 2026): keep Android 7+ | v2.24 |
| Old bookings: a NOT_STARTED alert and "past" in the patient's lists, not an automatic close | Closing a paid booking decides money (refund or not) | yes (14 Oct 2026) | v2.28 |
| Fake GPS: 3 different jobs since the last approval, applied after the visit | The literal "3 flags → suspended" logged partners out mid-visit and counted one job three times | yes (14 Oct 2026) | v2.29 |
| Write limit 60 / 300 a minute; sign-in and refresh left out; webhook per IP | §12 asked for limits on all writes; no numbers given | yes (14 Oct 2026) | v2.22, v2.29 |
| SOS not acknowledged in 2 min: email to Super Admins + SMS to the support phone (new DLT template) | §13 named the alert, not who gets it | yes (14 Oct 2026) | v2.24 |
| Admin edit of a patient logged as "which details changed", not the values | Audit rows can't be erased with the account (§12 Privacy) | yes (14 Oct 2026) | v2.29 |
| The staging restore test (exit criterion) → a local restore test; the server's comes with the deploy (10.1) | No server until the developer deploys, by hand, after every phase | yes (14 Oct 2026) | runbook, PHASES 10.1 |

## Known issues and follow-ups
- **The S3 upload path** (presigned PUT to the bucket, the CSP's S3 entry, the bucket's CORS rule) can only be seen on the server (at the developer's deploy, 10.1); in dev the files go to the API.
- **At the developer's deploy (10.1)**: RDS / S3 backup settings and the first restore test there; TLS, Secrets Manager and the S3 key (KEYS #8–#10).
- **Not seen on a rooted phone**: the root warning's positive case is a widget test (the emulator isn't rooted).
- The live-location race fix (the booking's row lock) is not reproducible in a test.
- The per-IP write limit (300 a minute) may be low behind a mobile network that shares one IP (CGNAT); watch it once live.
- Obfuscated app builds need their symbols uploaded to Sentry for readable stack traces (Phase 10, KEYS #7).

## Next phase
Phase 10 — Release.
