# WellWish — instructions for Claude

WellWish is an app for booking **verified companions and home nurses** in Odisha, India.
- **Patient app** (Flutter): book for yourself or family members, pay the booking fee.
- **Partner app** (Flutter): companions and nurses register, get verified and do the jobs.
- **Admin panel** (Next.js): staff verify partners, set prices and **assign every booking by hand**.
- **Backend:** Django 5.2 + Django Ninja, PostgreSQL 16, Redis, Celery, Channels.
- **Local dev:** Docker Desktop (WSL 2) runs PostgreSQL, Redis, the Django API and Celery from `infra/docker-compose.yml`. The Flutter apps and the admin panel run directly on Windows. Production runs on a Linux server.

One developer builds this with Claude, **phase by phase**, and every phase is documented.

## Source of truth (read before any work)
| File | Use |
|---|---|
| `docs/ARCHITECTURE.md` | What to build and how: logic, data, APIs, security. Section numbers like §6.10 point here. |
| `docs/PHASES.md` | The task list and exit criteria for each phase |
| `docs/PROGRESS.md` | Which phase is done, current or next, plus the decisions log |
| `docs/ui-reference/wellwish-patient-app-mockup.jpg` | UI style every screen must follow |
| `docs/phases/_TEMPLATE.md` | Completion report template |
| `docs/KEYS-AND-ACCOUNTS.md` | Every outside key/account still to add (Maps, MSG91, Razorpay, Firebase, AWS…). Names and where they go, **never values**. Add a row whenever a phase needs a new key. |
| `docs/PROMPTS.md` + `.claude/commands/` | The developer's slash commands: `/setup-check`, `/phase-start`, `/phase-continue`, `/phone-test`, `/client-change`, `/phase-status` |

## Phase workflow (follow every time)
1. **Read `docs/PROGRESS.md`.** Work only on the current phase. If none is in progress, the next phase is the one listed there.
2. **Before starting a new phase**, tell the developer its goal and main tasks in a few lines. Start when they say go.
3. **Mark it started:** 🟨 *In progress* + start date in PROGRESS.md.
4. **Build the tasks in PHASES.md in order.** Tick each one (`- [x]`) as soon as it's done **and tested**. Don't tick ahead.
5. **Follow ARCHITECTURE.md exactly.** If something can't or shouldn't be done as written, stop and ask the developer. Then update ARCHITECTURE.md (bump the version, add a "Changed in" line) in the same change and add a row to the PROGRESS.md decisions log.
6. **Test.** Run the automated checks (`.\ww.ps1 check` once phase 0 exists) and verify **every exit criterion** of the phase. Ask the developer to try on-device criteria if you can't run them.
7. **Write the report:** `docs/phases/phase-NN-<name>.md` from `_TEMPLATE.md`. Be honest. List anything not done, every deviation and known issues.
8. **Close the phase** in PROGRESS.md: ✅ *Done*, completed date, report link, next phase. Update *Last updated*.
9. **Offer a git commit** with the message `Phase NN: <name> — <one-line summary>`. Commit only if the developer agrees.

**Never mark a phase done if** a test fails, an exit criterion fails or wasn't checked, or the report isn't written.

## Code rules
**Backend**
- Every Django app has the same layout: `models.py`, `schemas.py`, `api/{patient,partner,staff}.py`, `services.py` (all writes), `selectors.py` (reads, filtered by the caller), `tasks.py`, `events.py`, `tests/`.
- Each app owns its tables. Other apps use its services or events.
- Every status change goes through `transition()`.
- Events are published with `on_commit`.
- Input schemas extend `StrictIn`.
- Ownership failures return **404**.

**Money and secrets**
- Money is always integer paise, never floats.
- Prices always come from the server's booking snapshot, never from the app.
- Never store plain OTPs or full Aadhaar numbers. Never log tokens, OTPs, full phone numbers or medical text. Never commit secrets.

**Apps and admin**
- **Flutter:** widgets from `packages/ww_ui`, text from `packages/ww_l10n` (English, Hindi, Odia; no hard-coded strings), Riverpod, go_router, and the API client generated from `docs/api/openapi.json`. Screens must match the mockup style.
- **Admin:** Next.js + Ant Design, generated TypeScript client, menu items shown according to permissions.

**Contract first:** add or change the schemas and endpoint, run `.\ww.ps1 openapi` and `.\ww.ps1 gen-clients`, then build the screen.

## Commands
Filled in during phase 0. Keep this list correct.
Run from the project root in PowerShell. `ww.ps1` wraps `docker compose`; there's no `make`. Docker Desktop must be running.
- Start everything: `.\ww.ps1 up` · Stop: `.\ww.ps1 down`
- All checks: `.\ww.ps1 check` (ruff, mypy, pytest, makemigrations --check, flutter analyze/test, admin lint/build)
- Migrations: `.\ww.ps1 migrate` · Seed data: `.\ww.ps1 seed` (creates the dev admin from `DEV_ADMIN_*` in `backend/.env`)
- Dev login: test numbers `+91 90000 00001`–`05` accept OTP `123456` (no SMS). Other numbers: admin panel → Settings → Test messages (local dev only), or `.\ww.ps1 manage sms_outbox <number>`.
- Dev emails (partner email codes, notices): `.\ww.ps1 manage mail_outbox <email>`. The API, Celery worker and beat all reload on code changes.
- First admin on a server: `.\ww.ps1 manage create_staff_user --email … --name … --role SUPER_ADMIN`
- Admin locked out (lost phone + recovery codes, no other Super Admin): `.\ww.ps1 manage reset_staff_2fa --email …`. With a new password it must ask in a terminal: `docker compose -f infra/docker-compose.yml exec api python manage.py reset_staff_2fa --email … --new-password`
- API contract: `.\ww.ps1 openapi` then `.\ww.ps1 gen-clients`
- Logs: `.\ww.ps1 logs` · Django shell: `.\ww.ps1 shell` · Every command: `.\ww.ps1 help`
- The Android emulator reaches the API at `http://10.0.2.2:8000`
- Run an app: `cd apps\patient_app; flutter run --flavor dev -t lib/main_dev.dart` (same for `partner_app`)
- Global Dart tools (installed once, not workspace dependencies): `melos` (run via `dart pub global run melos`)
  and `flutter_launcher_icons` (app icons: `dart pub global run flutter_launcher_icons -f flutter_launcher_icons.yaml` in an app folder)
- `packages/ww_api` is generated by `.\ww.ps1 gen-clients` (needs Docker). Never edit it by hand. Apps call it with the Dio from `ww_core` (`PatientApi(ref.watch(apiClientProvider))`), which adds the token and refreshes it.
- Login screens shared by both apps: `packages/ww_auth`. The admin panel calls the API on its own origin: Next.js forwards `/v1/*` to `API_PROXY_TARGET`.
- Endpoint checks: `@staff_permission("…")` (codes in `apps/staff/permissions.py`), `@partner_status("APPROVED")`. Admin actions call `apps.audit.services.record(...)`.
- After APK builds, `cd apps\patient_app\android; .\gradlew --stop` frees memory for the emulator (the dev PC is tight on RAM). gradlew needs `$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"` when JAVA_HOME isn't set.
- Backups (Phase 9.6): `.\ww.ps1 backup` (to `backups\`, git-ignored) and `.\ww.ps1 restore-test [file]` (restores into a separate database and checks every table). Server backups and the monthly restore test: `docs/runbooks/backups.md`.
- Load test (Phase 9.4): `.\ww.ps1 loadtest [minutes] [API processes]` (default 5, 1). Own database, your dev data isn't touched; report in `infra\loadtest\results\report.html`.
- Upload limits on a real S3 API (Phase 9B.5): `.\ww.ps1 s3-test` (a throwaway SeaweedFS store in Docker, removed afterwards). Public pages in dev: `http://localhost:8000/legal/privacy` (`?l=hi|or`) and `http://localhost:8000/delete-account`.
- Store builds (obfuscated, ARCHITECTURE §12): `.\ww.ps1 build patient|partner [prod|staging|dev] [apk|appbundle]`. Keep the crash symbols it leaves in `build\symbols\…`; the release key comes from `android\key.properties` (debug key without it).
- Brand: official logo `docs/ui-reference/wellwish-logo.jpg`; exact colours only in `packages/ww_ui/lib/src/tokens.dart`
