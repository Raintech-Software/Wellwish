# Phase 05 — Discovery and booking · Completion report

| Item | Value |
|---|---|
| Started | 9 Oct 2026 |
| Completed | 9 Oct 2026 (after the deep check, the admin browser check and the developer's confirmation) |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice so far; asked again at the close) |
| Architecture version used | v2.11 → **v2.12** (changes listed below) |

## Summary
A patient can now find hospitals near them (list or OpenStreetMap map, search, speciality filter), open a hospital or a doctor, and book a companion or a nurse for themselves or a family member: service with its price, who it is for, the hospital and doctor (or a hospital typed in), a date from the strip (blocked and full dates greyed out) and a time from the admin's rules, the doctor's appointment time with a suggested pickup, the address (inside a service area), the documents (a prescription for injection and IV), then Review with total / pay now / pay the partner after and the cancellation rule. "Pay ₹X" saves the booking as **Pending payment** (Razorpay arrives in Phase 6); a double tap books once. Home shows the next booking, and a family member's profile lists their bookings and books for them. The admin panel has All bookings (filters, search, detail with the price, member and address as booked, documents and timeline) and the bookings on the patient page.

## Tasks

### Backend
- [x] 5.1 Patient directory endpoints: nearby hospitals (list + map data), hospital detail with doctors, doctors search, doctor profile.
- [x] 5.2 `GET /v1/patient/booking-times?serviceId&date`: booking window, minimum notice, service hours, time step, blocked times and capacity (if on) (§6.17).
- [x] 5.3 `apps/bookings`: `Booking` (price, member and address snapshots, appointment and pickup times, `busy_window`, `version`), `BookingDocument`, `BookingEvent`.
- [x] 5.4 Create booking (`Idempotency-Key`): member is the caller's, address in a service area, time allowed (server re-check), prescription when required. Status `PENDING_PAYMENT`.
- [x] 5.5 `transition()` with the full allowed-transitions table from §6.9 and a `BookingEvent` for each change; every allowed and blocked transition tested.
- [x] 5.6 Patient bookings list (upcoming / ongoing / past) and detail.

### Patient app
- [x] 5.7 Home P05 (mockup 3): tiles Doctors, Book a Companion, Book a Nurse, Medical Reports, Family; next booking card; bell (inbox later).
- [x] 5.8 Nearby hospitals P06 (list + map, search, speciality filter) and hospital detail P07.
- [x] 5.9 Doctors P08 (mockup 4) and doctor profile P09 with "Book a companion for this doctor".
- [x] 5.10 Book a Companion P10 (mockup 6) and Book a Nurse P11: service cards with prices.
- [x] 5.11 Visit details P12: for whom (+ Add member), hospital + doctor (or typed in), date strip + calendar, times from the API, appointment time → suggested pickup, notes.
- [x] 5.12 Address P13 (the member's addresses first) and attach documents P14 (tick saved or upload new).
- [x] 5.13 Review P15: total / pay now / pay partner after, cancellation rule, "Pay ₹X" → `PENDING_PAYMENT` booking (payment in Phase 6).

### Admin panel
- [x] 5.14 Bookings list (filters: status, date, type; Upcoming / Today / Tomorrow / Later / Past; search) and booking detail (read-only: snapshots, documents, timeline).

## What was built

### Backend
- **`bookings`** (new app):
  - `Booking`, `BookingDocument`, `BookingEvent` tables; booking codes from a database sequence (`WW-10001`…); the `no_partner_overlap` exclusion constraint (btree_gist) ready for Phase 7.
  - `times.py`: the dates and times that can be booked (India time, service hours that may run past midnight, notice, window, blocked times per partner type, "max bookings per time" counted per partner type with an advisory lock, unpaid bookings holding their place until their payment time).
  - `services.create_booking`: one booking at a time per account (row lock), the key looked up after the lock, a fingerprint of the request stored with the key, all §6.9 checks by visit type, at most 5 unpaid bookings, the snapshots, the CREATE event.
  - `transition()` over the §6.9 table with optimistic locking; `expire_unpaid` task every 5 minutes (`bookings.expire_unpaid`).
  - Patient endpoints: booking-times, book, my bookings (paged buckets), booking detail. Admin endpoints: bookings list (when/status/type/date/search), detail.
  - Services, hospitals and doctors used in a booking can't be deleted (registered with `common.usage`).
- **`hospitals`**: patient endpoints for nearby hospitals (10 km → 25 km, or every active hospital by name without a location), hospital detail with its active doctors, the doctor directory (paged) and doctor profile; inactive entries are hidden.
- **`patients`**: member detail lists the member's bookings; removing a member or deleting the account is refused while a paid booking is unfinished, their unpaid ones expire; the erase keeps bookings without personal details and waits while a paid booking is open; the admin patient page lists bookings (with `bookings.view`).
- **`addresses`**: `refresh_service_area` (a booking that finds an address outside stores it so).
- **`common`**: `Mapped` pagination helper (rows turned into schemas only for the page returned).

### Patient app
- Directory: Doctors tab (Doctors | Hospitals), doctor cards (mockup 4), speciality chips, search; hospitals list and map (OpenStreetMap), hospital page (map, OPD hours, departments, doctors, call), doctor profile.
- Booking flow (`features/booking`): services (P10/P11) → visit details (P12) → hospital picker → address (P13) → documents (P14) → review (P15) → booking page. Times always shown in India time. One Idempotency-Key per Review screen (new one when the booking changes). Server errors send the patient back to the step to fix.
- Home: next booking card (reloads on pull-down, when the app comes back and when an unpaid booking's time is up). Member profile: bookings list and "Book for them".
- 122 new texts in English, Hindi and Odia.

### Admin panel
- All bookings (`/bookings`), booking detail (`/bookings/[id]`), a placeholder route for the Unassigned queue (Phase 7), bookings on the patient page.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET | `/v1/patient/hospitals/nearby` | lat/lng optional, radiusKm, specialityId, q → { radiusKm, items } |
| GET | `/v1/patient/hospitals/{id}` | with departments and doctors |
| GET | `/v1/patient/doctors`, `/v1/patient/doctors/{id}` | paged directory, profile |
| GET | `/v1/patient/booking-times` | { date, times, days[{date, available}], timeStepMin, travelBufferMin } |
| POST | `/v1/patient/bookings` | `Idempotency-Key` header; 409 TIME_NOT_AVAILABLE, 422 PRESCRIPTION_REQUIRED / OUTSIDE_SERVICE_AREA / INVALID_BOOKING / IDEMPOTENCY_KEY_REUSED, 429 TOO_MANY_UNPAID |
| GET | `/v1/patient/bookings`, `/v1/patient/bookings/{id}` | buckets upcoming / ongoing / past |
| GET | `/v1/patient/members/{id}` | + `bookings` |
| GET | `/v1/admin/bookings`, `/v1/admin/bookings/{id}` | when, status, type, date, q |
| GET | `/v1/admin/patients/{id}` | + `bookingsVisible`, `bookings` |

OpenAPI regenerated: yes (Dart and TypeScript clients too).

## Database changes
| App | Migration | What it does |
|---|---|---|
| bookings | 0001_initial | btree_gist extension, `booking_code_seq`, bookings, booking_documents, booking_events, constraints (no_partner_overlap, one key per account, appointment not before pickup) |
| bookings | 0002_idempotency_hash | fingerprint stored with the key |

## Tests
| Check | Command | Result |
|---|---|---|
| All checks | `.\ww.ps1 check` | **All checks passed** (ruff, format, mypy, pytest, makemigrations --check, flutter analyze/test, admin lint/build), re-run after the deep check |
| Backend tests | (in check) | **430 passed** (+61 this phase, 16 of them from the deep check) |
| Flutter | (in check) | patient app **37** (+14: booking flow, directory, Odia, India-time and draft unit tests, Home reload), partner app 15, ww_core 18, ww_auth 9, ww_ui 15, ww_l10n 6 |
| Admin | `npm run lint`, `npx tsc --noEmit`, build | clean |

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| Book "Doctor visit companion" for Mother, tomorrow, at a nearby hospital with a doctor and her saved prescription. The booking is saved with correct snapshots. | Emulator: WW-10001 for Sabitri, Sat 10 Oct, pickup 9:30 for the 10:30 appointment at Capital Hospital with Dr. Ananya Mishra and her prescription; database row checked (pickup 04:00 UTC, appointment 05:00 UTC, fee 10000 paise, notes, 1 document). Backend test `test_doctor_visit_for_mother_tomorrow`, widget test W-P2. | ✅ |
| Times shown match the settings. A blocked date is greyed out. A time inside the minimum notice is refused by the server. | Emulator: today from 3h after now, tomorrow 7:00 AM–8:30 PM on 30-min steps; 12 Oct blocked → greyed in the strip and the calendar; live API call 1 h ahead → 409 TIME_NOT_AVAILABLE (TOO_SOON); blocked date → BLOCKED. Backend `test_times.py` (14 tests). | ✅ |
| An injection service can't be booked without a prescription. | Emulator: lab report only → "Please attach a prescription."; live API → 422 PRESCRIPTION_REQUIRED (no documents, lab report only). Backend and widget tests. | ✅ |
| A double tap on Book creates only one booking. | Emulator: two taps in one go → 1 booking in the database. Backend: same key → same booking, also when the time became full or it was the 5th unpaid booking (deep check fix); widget test (one request). | ✅ |

## Screens
Screenshots in `docs/phases/img/phase-05/`: Home with the next booking, Book a Companion, Book a Nurse, visit details (date and time pills after the deep check), blocked date in the strip and the calendar, hospital picker list, map and without location ("My hospital isn't listed" always at the bottom), address (Mother's and "Your addresses"), prescription required, review (listed and typed-in hospital), booking saved, Doctors tab, doctor profile, hospital page.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| Service hours limit the start time only; last start before closing; hours may run past midnight | §6.17 said "times offered" without the edge | **yes** (9 Oct) | v2.12 §6.17 |
| Times always shown in India time | a relative abroad would otherwise see their own clock | **yes** (9 Oct) | v2.12 §6.17 |
| "Max bookings per time" counted per partner type; unpaid bookings hold their place until their payment time | companions and nurses are separate pools | **yes** (9 Oct) | v2.12 §6.17 |
| At most 5 unpaid bookings per account | stops someone holding many times without paying | **yes** (9 Oct) | v2.12 §6.9 |
| `expire_unpaid` built in Phase 5 (was 6.4) | otherwise unpaid bookings never leave Upcoming or free their time | **yes** (9 Oct) | v2.12 §10.5 |
| "Pay ₹X" saves the booking and shows "Booking saved" until Phase 6 | payment is Phase 6 | **yes** (9 Oct) | v2.12 |
| Removing a member / deleting the account refused while a paid booking is unfinished; erased accounts keep bookings without personal details | a booking must not lose its member or address while it is going to happen; the law keeps payment records | **yes** (9 Oct) | v2.12 §6.18, §12 |
| Admin list: unpaid and expired hidden unless filtered or found by code; opens on Upcoming with a Past view; notes only for roles with `patients.documents` | nothing for the admin to do on unpaid ones; notes can be medical | **yes** (9 Oct) | v2.12 §9.1, §10.3 |
| Server rules by visit type (home visit: no hospital; doctor must be at the hospital; appointment within the service's duration after pickup; documents of the booked member) | §6.6/§6.17 implied them | **yes** (9 Oct) | v2.12 §6.9 |
| New columns `bookings.idempotency_key`, `idempotency_hash`, `booking_documents.doc_type`, `booking_events.event` | needed for the rules above | — | v2.12 §11 |

## Deep check
Three independent reviews (backend, patient app, admin + API contract) and a live re-test on the emulator. Fixed:

| # | Found | Fix |
|---|---|---|
| 1 | A retried "Book" (double tap on a slow network) could be refused as "full" or "too many unpaid" because of the booking it was retrying | Key looked up after the account lock; tests for both cases |
| 2 | The same key with other details silently returned the old booking | Request fingerprint stored with the key → 422 IDEMPOTENCY_KEY_REUSED |
| 3 | An unpaid booking could be paid after "delete my account" and then be erased while still to happen | Delete request expires unpaid bookings; the erase waits while a paid booking is open |
| 4 | A member could be removed while a booking for them was being made | Removing a member locks the account first (same order as Book) |
| 5 | The appointment had no upper limit (the partner's blocked time didn't cover it) | Appointment within the service's duration after pickup (server and app) |
| 6 | Nearby search with a location matched inactive doctors and not the city | Same filters as without a location |
| 7 | An address found outside a service area kept showing as inside (the app looped back to it) | Stored as outside when a booking finds it; the app reloads the addresses |
| 8 | Admin: "Unassigned queue" opened the booking page and failed | Its own placeholder route |
| 9 | Admin: the list started with the oldest bookings; overdue ones fell out of the When views | Upcoming by default (with unfinished overdue ones), Past view latest first |
| 10 | Admin: a booking code didn't find unpaid/expired bookings; phone search missed the member's phone and 0-prefixed numbers | Code finds any state; member phone; last 10 digits |
| 11 | Admin: patient notes and the patient page's bookings visible to roles without the permission | Notes need `patients.documents`; bookings need `bookings.view` |
| 12 | Admin: erased accounts showed a random "phone" and a broken patient link; N+1 queries on the patient page | "Account deleted"; `select_related` |
| 13 | App: server errors popped a fixed number of screens; a double tap could open a step twice; Review could spin forever | Back to the named step (from `details.field` too); steps open once; Review redirects to the missing step |
| 14 | App: a new hospital could keep a doctor not listed there | The doctor keeps their hospitals; another hospital drops them |
| 15 | App: "You's addresses" / "You has no documents" | Own texts for yourself |
| 16 | App: the date strip disappeared and jumped back on every date tap; fixed heights clipped large text | Strip stays while times load, keeps its position; the ww_ui pills (blocked dates greyed and struck through) |
| 17 | App: Home's next-booking card never refreshed | Pull to refresh, on app resume, after the payment time |
| 18 | App: no pickup before the appointment silently cleared the time; calendar opened on the wrong day; refund rule showed 50% before loading; "My hospital isn't listed" missing in map view or on errors | Message and the time kept; calendar on the shown date; rule shown once loaded; the button always at the bottom |
| 19 | App: Hindi used "साथी" (companion) for "partner" in nurse bookings; doctor languages in English | "पार्टनर"; languages translated |
| 20 | Tests that didn't test what they claimed (a tap on the snack bar, sequential-only double tap, time zone) | Fixed; new unit tests for India time, money and the draft; the date sent on the wire checked |
| 21 | *Found by the re-run of the full check:* Home reloaded the next booking in a tight loop once an unpaid booking's time had passed (the server expires it up to 5 min later) | Reloads at most once a minute; test added |
| 22 | *Found in the admin browser check:* a search still sent the Upcoming view (an old booking's code wouldn't be found); "1 bookings"; the booking page lost the spaces between name, phone and language and ran "Open map" into the address (Ant Design lays item content out as flex); a deprecated Timeline option; booking codes and phones wrapped | A search (or a picked date) looks at every date and clicking a view clears it; "1 booking"; content wrapped in one block; `content`; no wrapping |

**Admin pages in the browser (9 Oct, 5:10 PM)**, signed in as a separate local test admin (`DEV_QA_ADMIN_*` in `backend/.env`, not the developer's account): All bookings at 1366 px; Upcoming (empty: both bookings expired, correct), Status → Unpaid (empty, correct) and Expired (WW-10001, WW-10002 with pickup, appointment, service, member, booked-by phone, hospital, fee); search `10002` finds the expired booking; a name search hides expired ones; Past clears the search; the booking page (status, times, booked by with link to the patient, member with relation/age/phone/language, price split, hospital, doctor, address with map link, notes, documents, timeline with "Not paid in time" by System at 4:00 PM); the Unassigned queue shows its Phase 7 placeholder; the patient page lists both bookings. Screenshots `admin-*.jpg`.

**Live re-test after the fixes (emulator, 9 Oct 4:30 PM):** the date strip stays while times load; dates and times use the ww_ui pills; the appointment field has a clock; booking for yourself with location refused lists every hospital by name with "My hospital isn't listed" at the bottom; a typed-in hospital, "Your addresses" with Mother's address under "Other saved addresses"; Review; a double tap on Pay → one booking (WW-10002, with the request fingerprint). WW-10001 had been expired by the 5-minute task. Live API: injection without a prescription → 422 PRESCRIPTION_REQUIRED; a time 1 h ahead → 409 TIME_NOT_AVAILABLE (TOO_SOON).

## Known issues and follow-ups
- **Phase 6:** refuse or refund a payment that arrives after the payment time (or after the booking expired), and check capacity again when paying. Razorpay order with the booking; the booking page P18 with pay, cancel and change time.
- **Phase 7:** red "close and unassigned" colour in the admin list; the Unassigned queue.
- "Book a companion for this doctor" starts at the doctor's first hospital; the patient can change it (the doctor stays when they work there too).
- The hospital/doctor photos are shown when the admin adds them (seed data has none).

## How to run and demo this phase
- `.\ww.ps1 up`, then `cd apps\patient_app; flutter run --flavor dev -t lib/main_dev.dart`; log in with a test number (`+91 90000 00001`, code `123456`).
- Home → Book a Companion → Doctor visit companion → choose Mother, Choose the hospital, the doctor, Tomorrow, appointment time → Next → address → tick the prescription → Next → Pay.
- Admin: Bookings → All bookings (pick "Unpaid" in Status to see bookings waiting for payment, or search the code).

## Next phase
Phase 6 — Payment, cancel, refund, reschedule. Uses `transition()` (PAY, CANCEL), the booking's `pay_by` and `Idempotency-Key`; the expire task already exists.
