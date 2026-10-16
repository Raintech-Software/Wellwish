# Phase 2 — Admin master data · Completion report

| Item | Value |
|---|---|
| Started | 8 Oct 2026 |
| Completed | 8 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | **Not committed** (developer's choice: "don't commit now"). Phases 0–2 are all untracked. |
| Architecture version used | v2.7 → **v2.9** (v2.8: maps and admin logins, decided by the developer; v2.9: contract details found while building) |

## Summary
The admin panel can now set up everything the apps need: the service catalogue with prices (booking fee online, balance calculated), hospitals with a map pin, doctors, specialities, every setting from §11, service areas and blocked dates. The patient and partner apps can read the catalogue and specialities from public endpoints.

Several admins can work at once, each with their own login and role. A Super Admin adds them, changes roles, disables them, resets 2FA, sets a new password or signs them out everywhere. Every change lands in the audit log, which has its own page with filters and a CSV export.

There is no Google Maps key yet, so the admin uses a free OpenStreetMap map (Leaflet) with latitude/longitude fields and a "use my current location" button (developer decision, ARCHITECTURE v2.8).

## Tasks
### Backend
- [x] 2.1 `apps/services`: `Service` model (§6.6: names in 3 languages, partner type, visit type, price + booking fee in paise, duration, docs required, active, sort).
  - Balance is calculated (never typed).
  - Deactivate instead of delete when the service has been used.
- [x] 2.2 `GET /v1/public/services`. Admin CRUD with validation (booking fee ≤ price). Audit-log every price change.
- [x] 2.3 `apps/hospitals`: `Hospital` (with location), `Speciality`, `Doctor`, `DoctorHospital`.
  - Admin CRUD, deactivate rules.
  - Nearby selector (10 km, widened to 25 km if fewer than 5) with tests (§6.7).
- [x] 2.4 `apps/app_config`: typed `AppSetting` keys from §11 with defaults. `GET /v1/public/app-config`.
- [x] 2.5 `service_areas` (city, centre, radius) with an `is_inside_service_area(point)` helper.
- [x] 2.6 `blocked_times` CRUD. Saving one lists the existing bookings it affects (empty until phase 5).
- [x] 2.7 Staff users: add, edit role, disable, reset 2FA. Audit log list API with filters.
- [x] 2.8 Seed: the sample services from §6.6, 5 Bhubaneswar hospitals, 10 doctors, specialities, 1 service area, the default settings.

### Admin panel
- [x] 2.9 Services page: table, add/edit form (shows the calculated balance), deactivate, reorder.
- [x] 2.10 Hospitals page: table, form with a map pin picker (OpenStreetMap until the Google key arrives), latitude/longitude fields, "use my current location", OPD hours, departments, photo upload.
- [x] 2.11 Doctors and Specialities pages.
- [x] 2.12 Settings page (all keys, grouped) and Service areas (map with a radius circle).
- [x] 2.13 Blocked dates/times page (calendar).
- [x] 2.14 Admin users and roles page. Audit log page (read-only, export CSV).

## What was built

### Backend (`backend/`)
- **apps/services**
  - `Service` model. Database checks: price > 0, 0 ≤ fee ≤ price. `balance_paise` is a property, never stored.
  - Services layer: create, update, activate/deactivate, delete, reorder.
    - An update that touches a price is audited as `service.price_changed`; anything else is `service.updated`. Both keep only the changed fields, before and after.
    - Delete is refused with `409 IN_USE` when `common.usage.is_used("service", id)` says so. The bookings app (Phase 5) registers that check.
  - Public `GET /v1/public/services?partnerType=` and the admin endpoints.
  - Seed: the 10 sample services from §6.6, with Hindi and Odia names.
- **apps/hospitals**
  - Models: `Speciality`, `Hospital` (lat/lng decimals with an index), `Doctor`, and `DoctorHospital` (unique pair).
  - `nearby_hospitals(lat, lng)`: active hospitals within 10 km, closest first, widened to 25 km if fewer than 5. Also filters by speciality and by hospital or doctor name.
  - Delete rules:
    - A speciality can't be deleted while a doctor has it.
    - A hospital can't be deleted while doctors are listed there or a booking uses it.
    - A doctor can't be deleted once a booking uses them.
  - Every change is audited.
  - Seed: 10 specialities, 5 Bhubaneswar hospitals (approximate pins) and 10 made-up doctors.
- **apps/files** (upload flow §6.8)
  - `POST /v1/admin/files/upload-url` returns a file key and a short-lived upload URL.
  - On save, the owning app calls `confirm_upload`, which checks the size and the real type from the magic bytes.
  - `view_url` gives a 5-minute link.
  - Local dev storage stands in for S3 with signed `/v1/files/upload/{token}` (PUT) and `/v1/files/view/{token}` (GET) views. Staging/prod use presigned S3 URLs; `FILE_S3_BUCKET` is now required there.
- **apps/app_config**
  - `registry.py`: every §11 setting with its type, limits and default, in 7 groups.
  - `AppSetting` stores the changed values. Reads are cached for 60 s, and the cache is cleared on save.
  - `PUT /v1/admin/settings` checks every value before saving any; a bad value returns `422 INVALID_SETTINGS` with an error per field.
  - `ServiceArea` (city, name, centre, radius) with `is_inside_service_area()`.
  - `BlockedTime` (from, to, reason, all or one service type) with `is_blocked()`.
  - Saving a block returns the bookings inside it. The bookings app plugs its finder in, so the list stays empty until Phase 5.
  - `GET /v1/public/app-config` now reads the settings.
- **apps/staff**: admin user management.
  - List with open-session counts, add, edit name/role, disable/enable, reset 2FA, set a new password, sign out everywhere.
  - You can't disable yourself or change your own role.
  - The last active Super Admin can't be disabled or demoted (rows are locked, so two admins can't do it to each other at the same moment).
  - Disabling, resetting 2FA or setting a password ends the person's sessions at once.
- **apps/audit**: the audit log page API.
  - `GET /v1/admin/audit-log` filters by staff, action prefix, entity type/id and IST date range, newest first, 20 a page.
  - `GET /v1/admin/audit-log/filters` gives the values for the filter menus.
  - `GET /v1/admin/audit-log/export` returns a CSV of up to 10,000 rows. The export is itself audited, and formula-like cells are escaped.
- **common**
  - `usage.py`: the "is this row used?" registry.
  - `schemas.py`: the `Latitude`, `Longitude` and `RadiusKm` text-decimal types.
  - Seeders added to `manage.py seed`.

### Admin panel (`apps/admin_web/`)
- Shared pieces:
  - `Page` wrapper, which shows "No access" without the permission.
  - `useLoad` data hook.
  - Money and IST date formatting.
  - API error → toast and form-field errors.
  - `PhotoUpload` (upload-URL flow).
  - `map/MapView` (Leaflet + OpenStreetMap tiles, draggable pin, click to pick, radius circle).
  - `map/LocationFields` (lat/lng fields with checks, "use my current location", the map).
- Pages:
  - **Services & prices**: filter by companion or nurse, order arrows, add/edit drawer with prices in rupees and a live balance, deactivate/activate, delete (refused when used).
  - **Hospitals**: search, OpenStreetMap link per row, drawer with address, city, phone, map pin picker, OPD hours, departments (tags) and photo.
  - **Doctors**: search and filters by speciality or hospital, drawer with speciality, hospitals, OPD, languages and photo.
  - **Specialities**: table and modal with names in 3 languages and an icon key. Delete is disabled while doctors have the speciality.
  - **Settings**: 7 grouped cards. Each field is typed (numbers with units, rupees for paise, choices, HH:MM, phone, version) and shows its default. Only changed keys are sent, and server errors appear on the field.
  - **Service areas**: table, warning when no area is active, drawer with the map and radius circle.
  - **Blocked dates**: month calendar with the blocks marked; click a day to block it. Upcoming list with edit/remove. Affected bookings are shown after saving.
  - **Admin users**: table (role, status, 2FA, last sign-in, open sessions). Add with a password generator, edit name/role. Actions menu: new password, reset 2FA, sign out everywhere, disable/enable.
  - **Audit log**: filters (who, action, what, record id, dates), before/after shown on expand, server-side paging, CSV export.
- `useCan()` is now stable across token refreshes, so pages don't reload their data every 15 minutes.
- The antd `App` provider was added for themed messages and dialogs.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET | `/v1/public/services?partnerType=` | Active services with `pricePaise`, `bookingFeePaise`, `balancePaise` |
| GET | `/v1/public/specialities` | For the filter chips |
| GET/POST | `/v1/admin/services` | `services.view` / `services.manage` |
| PUT/DELETE | `/v1/admin/services/{id}` | Delete refused with 409 `IN_USE` once booked |
| POST | `/v1/admin/services/{id}/activate`, `/deactivate`, `/v1/admin/services/reorder` | |
| CRUD | `/v1/admin/specialities`, `/v1/admin/hospitals`, `/v1/admin/doctors` (+ activate/deactivate) | `directory.view` / `directory.manage`; filters `q`, `specialityId`, `hospitalId` |
| POST | `/v1/admin/files/upload-url` | `{ purpose, mime, sizeBytes }` → `{ fileKey, uploadUrl, mime, maxBytes }` |
| GET/PUT | `/v1/admin/settings` | Grouped; values are text; PUT only the changed keys |
| CRUD | `/v1/admin/service-areas` (+ activate/deactivate), GET `/v1/admin/service-areas/check` | `settings.manage` |
| CRUD | `/v1/admin/blocked-times` | Create/update answer includes `affectedBookings` |
| GET/POST | `/v1/admin/staff-users`; PUT `/{id}`; POST `/{id}/disable`, `/enable`, `/reset-2fa`, `/password`, `/logout` | `staff.manage` |
| GET | `/v1/admin/audit-log`, `/filters`, `/export` | `audit.view`; export is `text/csv` |

OpenAPI regenerated: **yes**, and the Dart and TypeScript clients too.

## Database changes
| App | Migration | What it does |
|---|---|---|
| services | `0001_initial` | `services` table with the price checks |
| hospitals | `0001_initial` | `specialities`, `hospitals` (lat/lng index), `doctors`, `doctor_hospitals` (unique pair) |
| app_config | `0001_initial` | `app_settings`, `service_areas`, `blocked_times` (end after start) |

## Tests
| Check | Command | Result |
|---|---|---|
| Backend tests | `.\ww.ps1 test` | **250 passed** (176 before; 74 new) |
| Lint / format / types | ruff, ruff format, mypy | clean |
| Migrations | `makemigrations --check` | no changes |
| Flutter | `melos run analyze` / `melos run test` | clean / **65 passed** (no app changes; the regenerated `ww_api` compiles) |
| Admin | `npm run lint`, `npm run build` | clean; 9 new pages built |

New test files:
- `apps/services/tests/test_services.py`
- `apps/hospitals/tests/test_directory.py`
- `apps/app_config/tests/test_settings.py`
- `apps/files/tests/test_uploads.py`
- `apps/staff/tests/test_staff_users.py`
- `apps/audit/tests/test_audit_page.py`

They cover:
- CRUD for every entity, and that the balance can't be typed.
- Fee above price refused; delete refused when used.
- Price changes audited with before/after.
- The public list shows the seeded prices and balances.
- Nearby search: sorted by distance, stays at 10 km with 5 results, widens to 25 km, skips inactive hospitals, filters by speciality and name.
- Settings: every bad value refused with nothing saved, the phone number normalised.
- Service areas: inside/outside, inactive areas ignored.
- Blocked dates: end of the range not included, per-service blocks, the affected-bookings hook.
- Uploads: wrong type or size, fake image, missing upload, forged links, path tricks, magic bytes.
- Admin users: role change takes effect on the next request; disable and reset-2FA sign the person out; not yourself; the last Super Admin stays.
- Audit log: paging, filters, IST date filter, CSV formula escaping, export logged.
- Permissions for every page.

Full check (`.\ww.ps1 check`): **all 10 checks pass**: ruff, format, mypy, pytest (250), migrations, flutter pub get, flutter analyze, flutter test (65), admin lint, admin build.

The first full run failed: the Dart generator wrote code that doesn't compile for two schema defaults (`HospitalIn.type = "HOSPITAL"` and `SettingOut.choices = []`). Both fields are now required. `.\ww.ps1 gen-clients` now runs `dart analyze` on `packages/ww_api` after generating, so a bad schema shape fails there instead of in the apps' tests.

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| The admin can add, edit and deactivate services, hospitals and doctors. Deleting one that has been used is refused. | Tests (`test_services`, `test_directory`). In the browser: edited a service price, edited a hospital pin (moved the pin by typing), attached and removed a photo, deactivate buttons. Delete when used: 409 `IN_USE` in tests (usage check registered), and the Specialities page disables Delete while doctors exist. | ✅ |
| `GET /v1/public/services` returns the seeded prices with the calculated balance. | `test_public_list_has_the_seeded_prices_and_balance`, plus a live call on the dev API after `manage.py seed` (10 services, e.g. Doctor visit companion ₹500 / ₹100 / ₹400). | ✅ |
| The nearby-hospitals test returns seeded hospitals sorted by distance. | `test_nearby_is_sorted_by_distance_from_the_seed` checks the order against a Python haversine sort (Apollo is closest to the centre at ~1.6 km). | ✅ |
| Each price change appears in the audit log with before and after values. | `test_price_change_is_audited_with_before_and_after`. In the browser: changed ₹500 → ₹550 on the Services page, and the Audit log page showed `service.price_changed` with `{"price_paise": 50000}` → `{"price_paise": 55000}`. Then set it back to ₹500. | ✅ |

## Screens
The built-in browser pane was hidden for most of this session, so screenshots timed out. The pages were checked through the page's DOM instead: data loaded, drawers and forms opened, saves worked, the map drew OpenStreetMap tiles with the pin and radius circle, and the calendar marked a blocked day. **Please open each page once** (Services, Hospitals, Doctors, Specialities, Settings, Service areas, Blocked dates, Admin users, Audit log) to check the look against the mockup style.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| OpenStreetMap (Leaflet) map with lat/lng fields and "use my current location" instead of a Google Maps pin picker | No Google Maps key yet | yes ("use any free map … latitude and longitude … address field needed") | v2.8 §3.2 |
| Several admins, each with their own login and role | Developer asked for more than one admin; shared logins would break the audit trail | yes (interpreted; shared login rejected for the audit log) | v2.8 §9.2 |
| Latitude, longitude and radius are text in the API (`"20.296100"`) | The generated Dart client broke on number-or-text fields; text also keeps every digit | no (technical, logged) | v2.9 §10.3 |
| Super Admin can set a new password for another admin | Staff have no self-service password reset; without it a forgotten password needs the server command | no (small addition, logged) | v2.9 §9.1 |
| Audit export: max 10,000 rows, the export is audited, formula cells escaped | Security for CSVs opened in spreadsheets | no (security, logged) | v2.9 §12 |
| `blocked_times.service_type` empty (not null) means all services | Django rule: no null on text fields | no (technical) | v2.9 §11 |

## Known issues and follow-ups
- **Hospital pins are approximate.** Check the 5 seeded pins on the Hospitals page before going live. Severity: low. When: before launch.
- **Address search on the map** (type an address, get the pin) isn't built. Admins click the map, drag the pin, type the numbers or use their current location. Google Places arrives with the Maps key. Severity: low. When: when the key arrives.
- **OpenStreetMap tile policy:** the public tile server is fine for a few admins. If usage grows, switch to Google Maps (planned) or a paid tile provider. Severity: low.
- **An upload link works for 10 minutes and can be used again** to replace the same file key. Staff-only, and the type is checked on save. A cleanup of unused uploads is planned for Phase 4. Severity: low.
- **`partnerType` / `specialityId` / `hospitalId` query names are camelCase**, matching the JSON. The old `partner_type` name was never used by an app.
- **Not committed to git**, as the developer asked.
- `common.usage` checks for services, hospitals and doctors only start returning true when the bookings app registers them (Phase 5). Until then nothing counts as used.

## How to run and demo this phase
```
.\ww.ps1 up
.\ww.ps1 manage seed          # services, directory, service area, settings (safe to run again)
cd apps\admin_web; npm run dev
```
- Admin: http://localhost:3000. The dev Super Admin is `DEV_ADMIN_EMAIL` / `DEV_ADMIN_PASSWORD` in `backend/.env`, with the authenticator set up at the first sign-in.
- Public API: http://localhost:8000/v1/public/services and `/v1/public/specialities`.

## Next phase
Phase 3 — Partner registration and verification. Notes for it:
- Uploads go through `apps/files` (add purposes for the KYC documents, e.g. PDF/HEIC for ID proofs).
- The admin Applications pages can reuse `Page`, `useLoad`, `PhotoUpload` and the error helpers.
- `required_documents` CRUD belongs to Phase 3 (listed under admin CRUD in §10.3).
