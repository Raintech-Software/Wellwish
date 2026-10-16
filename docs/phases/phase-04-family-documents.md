# Phase 04 — Patient profile, family and documents · Completion report

| Item | Value |
|---|---|
| Started | 9 Oct 2026 |
| Completed | 9 Oct 2026 (after the deep check and the developer's confirmation) |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice so far; asked again at the close) |
| Architecture version used | v2.10 → **v2.11** (changes listed below) |

## Summary
A patient can now add parents and relatives (up to 10) with their details, health notes and consent, save addresses for each one with a map pin (OpenStreetMap until the Google key arrives) and keep medical documents per person: upload from the camera, gallery or a PDF, view, delete, with a 200 MB limit per account. Other accounts can never see any of it (404). The patient can ask to delete their account (logged out at once, data erased after 7 days unless they log in again). The admin panel has a Patients page (family without health notes, addresses, documents opened only with a logged reason) and the list of deletion requests.

## Tasks

### Backend
- [x] 4.1 `Member` with all §6.18 fields, consent time, max members setting (10), deactivate instead of delete.
- [x] 4.2 `apps/addresses`: addresses linked to the user and a member, map pin, service-area check result stored.
- [x] 4.3 `apps/documents`: upload URL, attach, list (by member, type and tab), view URL, delete; 200 MB per account.
- [x] 4.4 Ownership: every selector filtered by the owner, others get 404. IDOR tests for members, addresses and documents.
- [x] 4.5 Account deletion request: data removed after a 7-day grace period by a daily task (within the 30 days of §12), admin view, payment records kept.

### Patient app
- [x] 4.6 Family P22 (mockup 8 style): members list, + Add member.
- [x] 4.7 Add/edit member P28: all fields + consent tick (editing yourself updates your profile).
- [x] 4.8 Member profile P29: details, health notes, addresses, documents, bookings (empty until Phase 5), Book for them (coming soon), Remove.
- [x] 4.9 Addresses P24: OpenStreetMap pin (drag the map), "use my current location", label/address/landmark/notes, warning outside a service area, edit and remove.
- [x] 4.10 Medical documents P21 (mockup 7): tabs All / Reports / Prescriptions, member filter, upload from camera, gallery or PDF with progress, photo viewer, PDF opens in the phone's PDF app, delete, storage line.
- [x] 4.11 Profile P23 (mockup 10, rows now open their screens) and Settings P27 (language, notifications → phone settings, delete account).

### Admin panel
- [x] 4.12 *(added in Phase 4)* Patients list and profile, Account deletion requests.

## What was built

### Backend
- **`patients`**: member add/edit/remove (limit from the `max_members` setting, consent required for everyone but yourself, phones in E.164, emergency contact both-or-none, photo upload), `account_deletions` table, request → logout everywhere, daily erase (`patients.process_account_deletions`, 02:15 IST): documents and files, addresses, members and their photos, profile, app inbox, patient phones; the user row is anonymised (phone freed) unless the person is also a partner; consents stay. Logging in again cancels.
- **`addresses`** (new app): per member, up to 10 each, `in_service_area` computed when saved, hide on remove.
- **`documents`** (new app): types, Reports/Prescriptions groups, 200 MB checked at upload URL and at save, same file can't be saved twice, delete removes the file at once (row kept as deleted), documents of removed members hidden; admin view with reason, audit-logged.
- **`files`**: `member_photo` and `patient_document` purposes (owner-scoped keys; patient documents also allow HEIC), `confirm_upload_details` (size for the quota), `delete_file`.
- **`accounts`**: `revoke_user_sessions(app=…)` (patient app only), `erase_patient_account`, revoke reason `ACCOUNT_DELETED`.
- **Contract hygiene**: patient document schemas renamed (`PatientDocumentOut`…), one shared `ViewUrlOut`, and a test that fails if two schema classes share a name (they silently overwrote each other in the OpenAPI).

### Shared packages
- `ww_core`: camera/gallery/PDF picking, the upload PUT (with progress) and "use my current location" (phone GPS) moved here from the partner app; both apps use them.
- `ww_ui`: `WWAvatar` shows a photo; `WWTextField` supports several lines and a length counter.
- `ww_core` session end reason `accountDeleted` (login screen explains the 7 days).
- `ww_l10n`: about 120 new texts in English, Hindi and Odia.

### Patient app (ARCHITECTURE §7.1)
- P21 Medical documents (Reports tab), upload sheet, photo viewer · P22 Family (Family tab) · P23 Profile (rows open their screens, settings icon) · P24 Address with map · P27 Settings · P28 Add/edit member · P29 Member profile. Home tiles for Medical Reports and Family no longer say "Coming soon".

### Admin panel
- Patients → Patients (search by name or phone digits, family count, deletion date) → patient profile (account, family without health notes, addresses with map link and service-area tag, documents; Open asks for a reason) · Patients → Account deletions.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET / POST | `/v1/patient/members` | list (yourself first), add |
| GET / PUT / DELETE | `/v1/patient/members/:id` | detail with addresses and latest documents; edit; remove (hidden) |
| POST | `/v1/patient/members/photo-upload-url` | member photo |
| GET / POST / PUT / DELETE | `/v1/patient/addresses` (`?memberId=`) | per member |
| GET | `/v1/patient/documents?memberId=&type=&group=&page=&pageSize=` | paginated |
| GET | `/v1/patient/documents/storage` | used / 200 MB |
| POST | `/v1/patient/documents/upload-url`, `/v1/patient/documents` | upload, save |
| GET / DELETE | `/v1/patient/documents/:id/view-url`, `/v1/patient/documents/:id` | view (5 min), delete |
| POST | `/v1/patient/me/delete-request` | → `dueAt`; logged out everywhere |
| GET | `/v1/admin/patients?q=`, `/v1/admin/patients/:id` | `patients.view` |
| POST | `/v1/admin/patients/:id/documents/:docId/view-url` | `{ reason }`, `patients.documents`, logged |
| GET | `/v1/admin/account-deletions?status=` | `patients.manage` |

OpenAPI regenerated: yes (Dart and TypeScript clients regenerated, `dart analyze` clean).

## Database changes
| App | Migration | What it does |
|---|---|---|
| patients | 0002_accountdeletion | `account_deletions` (one pending per user) |
| addresses | 0001_initial | `addresses` |
| documents | 0001_initial | `patient_documents` |
| accounts | 0003_alter_session_revoke_reason | revoke reason `ACCOUNT_DELETED` |

## Tests
| Check | Command | Result |
|---|---|---|
| All checks | `.\ww.ps1 check` | **All checks passed** (ruff, format, mypy, pytest, makemigrations --check, flutter pub get/analyze/test, admin lint/build) — re-run after the deep check |
| Backend tests | (in check) | **369 passed** (+59 this phase, 14 from the deep check and the waiting-time setting) |
| Flutter | (in check) | patient app 23 (+11), partner app 15, ww_core 18, ww_auth 9, ww_ui 15, ww_l10n 6 — all passed |
| Admin | `npm run lint` / `npm run build` | clean / built |

New backend tests: add Mother with consent; bad details (consent, relation, phone, date, name, emergency, unknown field); family limit from the setting; edit and photo; editing yourself updates the profile; remove hides but keeps the row; **IDOR** for members, member photos, addresses (read, edit, remove, add to someone else's member, move an address to someone else's member) and documents (list, view, delete, file under someone else's member, attach someone else's upload); addresses inside/outside the service area, limits, hidden with a removed member; documents per member and tab, real file type, 200 MB quota, same file twice, delete removes the file; account deletion (logout at once, grace period, cancel by logging in, erase everything incl. files, anonymise, number reusable, partner kept); admin patients (list, search, no health notes, reason required and logged, permissions); unique schema names.
New widget tests: add Mother (validation, consent), member profile and remove, address with map pin and current location, documents tabs/upload from camera/delete, delete account → login with the 7-day message, family screens in Hindi.

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| Add "Mother" with her phone, address (pinned, inside the service area), health notes and consent. Upload 2 documents for her. | Emulator (+91 90000 00001): added Sabitri Gouda (Mother) with her phone, Odia, BP/diabetes, needs support, hard of hearing, consent. Added her "Home" address by dragging the OpenStreetMap pin in Bhubaneswar (saved inside the service area). Uploaded a lab report from the camera and a prescription from the gallery. Also checked in the admin panel. | ✅ |
| Mother's documents appear only under Mother. Another patient account can't read them (tests). | Emulator: Reports → "You" shows none, "Sabitri" shows both. Backend IDOR tests (`test_other_patients_cannot_read_or_use_your_documents` and the member/address ones) pass. | ✅ |
| Removing a member hides them but keeps their history. | Emulator: removed "Bikram Gouda (Father)" — gone from the app; the row is kept (`is_active = false`) and the admin profile lists him as "Removed". Backend test too. Mother kept for the developer's own check. | ✅ |
| Hindi and Odia text shows on these screens (translations may be placeholders until phase 9). | Emulator: switched to Odia (Family) and Hindi (Medical Reports) in Settings; widget test for Hindi. All new texts have Hindi and Odia translations (not placeholders; to be reviewed in Phase 9). | ✅ |

## Screens
Screenshots in `docs/phases/img/phase-04/`: p22-family-empty, p22-family, p22-family-odia, p28-add-member, p29-member-profile (before the full-width and "Odia" label fixes), p24-address-map, p21-upload-sheet, p21-image-viewer, p21-documents, p21-documents-hindi, p23-profile, p27-settings.
Admin pages were checked through the page text in the built-in browser (the pane was hidden, so no admin screenshots).

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| OpenStreetMap map in the patient app | No Google key yet; "current location" can't place a relative's home | **yes** (chose OpenStreetMap) | v2.11 §3.2 |
| Account deletion: waiting time (default 7 days, **admin setting 1–30**, developer's choice), logout at once, cancel by logging in; user row anonymised unless also a partner | §12 said "within 30 days" without the how | **yes** (9 Oct) | v2.11 §12, §9.1 |
| Admin Patients page + deletion list built now (task 4.12 added) | PHASES had no task; admin menu and Phase 1 code planned it for Phase 4; 4.5 needs an admin view | **yes** (9 Oct) | v2.11 §9.1, PHASES 4.12 |
| Admin sees members **without** health notes | §6.18 says only the assigned partner sees them | follows ARCHITECTURE | v2.11 §9.1 |
| PDFs open in the phone's PDF app (photos in-app) | An in-app PDF viewer adds a large native library | **yes** (9 Oct) | v2.11 §6.8 |
| Member language stored as the partners' words ("Odia") | So the admin can match patient and partner languages | **yes** (9 Oct) | v2.11 §6.18 |
| Up to 10 addresses per member | A sane limit; not in ARCHITECTURE before | **yes** (9 Oct) | v2.11 §6.18 |
| *(deep check)* Removing a member: optional "also delete their documents"; kept ones stop counting towards 200 MB | §6.18 says "deleted only if the owner asks" but gave no way to ask; hidden files filled the quota | **yes** (9 Oct) | v2.11 §6.8 |
| *(deep check)* PDFs open from the app's private cache in the phone's PDF app (not the browser) | The browser saved medical PDFs to the shared Downloads folder | **yes** (9 Oct) | v2.11 §6.8 |
| *(deep check)* At most 30 unsaved uploads per person per day | Stops one account parking files in storage | **yes** (9 Oct) | v2.11 §6.8 |
| *(deep check)* Admin sees no "getting around" (mobility) and no document list without `patients.documents` | §6.18 counts mobility as a health note; §9.2 gives Support/Finance no document access | follows ARCHITECTURE | v2.11 §9.1 |

## Deep check
Done after the developer asked "everything done? any bug?" (the phase had been closed without it, against the project rule; it was set back to 🟨). Three independent reviews (backend/security, patient app, admin + API contract + docs) plus live checks: staging/production settings load (`check --deploy`: only the known HSTS-preload note), Celery tasks registered and beat times right (02:00, 02:15, 07:00 IST), logs free of phone numbers, OTPs and medical text, OpenAPI identical to a fresh export and the generated Dart/TypeScript clients identical to a fresh generation.

**Found and fixed (with tests):**
| # | Problem | Fix |
|---|---|---|
| 1 | **Map blank on the 2nd visit** to the address screen (the tile layer was kept and closes its downloader) | Layer built fresh each visit; checked on the emulator (3 visits) |
| 2 | **Editing yourself was undone by a language change**, and the greeting/profile kept the old name | Profile reloaded after a SELF edit; language change reads the latest profile first; checked on the emulator |
| 3 | Any profile/language change rebuilt the open screen and **crashed an open edit form** (found while testing #2) | Router re-routes only when the screen-deciding fields change |
| 4 | Removed member's documents **kept filling the 200 MB** with no way to delete them | "Also delete their documents" when removing; kept ones don't count |
| 5 | **One photo could be shared by two members**; changing one deleted the other's | A file can be attached to one record only |
| 6 | Admin "reason" of only spaces was accepted (empty reason in the audit log); same in Phase 3 suspend/reject reasons | Spaces removed before the length check, everywhere |
| 7 | A malformed id (`?memberId=abc`) gave a **500** error | Malformed ids are "not found" (404) |
| 8 | If the storage failed to delete a file, the **medical file stayed with no record** | Marked for the daily cleanup to retry |
| 9 | "Today" was the UTC date: before 05:30 IST a document dated today was refused, ages one day late (also partner DOB/expiry checks) | India's date everywhere |
| 10 | Address limit could be passed by two quick saves or by moving an address | Member row locked; limit checked on a move too |
| 11 | Account erase left the patient's session rows and, for non-partners, the partner app's sessions/phones; a login during the nightly erase could get tokens for the erased user | Erase removes them; login waits for the erase and then makes a fresh account |
| 12 | No unique index on document file keys (slow duplicate check) | Unique index (migration `documents.0002`) |
| 13 | Unlimited unsaved uploads per person | 30 per day |
| 14 | Admin saw document titles without document permission, saw mobility, got raw dates, no "Removed" marker; the document opened in a pop-up the browser could block | Fixed; document opens inside the page |
| 15 | PDFs opened in Chrome, which can save them to the shared Downloads folder | Opened from the app's private cache in the PDF app; checked on the emulator |
| 16 | Upload sheet: closing it during an upload lost the refresh; progress jumped to 100% at once; a >10 MB file was read and sent before being refused | Refresh survives closing; back/tap-outside blocked while sending; real progress; size checked first |
| 17 | Previous account's family could show after logout/login while loading | Old data never shown while the new account loads |
| 18 | iOS camera/photo permission texts missing (would crash on iOS) | Added to Info.plist |
| 19 | Smaller: "See all" broke Back; notifications row opened a settings page with nothing to switch on; name/label lengths not limited like the server; hard-coded colours; unused code and partner-app dependencies; open_filex's extra media permissions | All fixed |

**Not fixed, tracked:** S3 uploads should use a presigned POST with a size range (PHASES 10.2); admin edit/block/delete-on-request for patients (PHASES 9.10); member photos come from 5-minute links, so after 5 minutes a photo falls back to the initials until the list is refreshed (pull to refresh).

## Known issues and follow-ups
- **Phase 5:** bookings will point to members; the account erase hard-deletes members, so the booking → member link must be `SET_NULL`/`PROTECT` and keep the snapshot.
- **OpenStreetMap's free tile server is for light use only** → fine for development and testing; must be replaced by Google Maps (or a paid tile provider) before launch → when the Maps key is added (KEYS-AND-ACCOUNTS #1).
- "Book for Sabitri" and member bookings show "coming soon" / empty → Phase 5.
- Partners don't see member details or documents yet (only during their job) → Phase 7–8.
- The admin can't edit a patient's data on request, block a patient or start "delete account" for a phone caller (§9.1) → PHASES 9.10.
- "Delete my account" was tested by backend and widget tests, not on the emulator (kept the test account for the developer). The daily job runs at 02:15 IST; in dev it can be run with `.\ww.ps1 shell` → `from apps.patients.services import process_due_deletions`.
- Searching patients by phone matches any 4+ digits anywhere in the number (fine for staff; no rate limit needed as it's admin-only).
- Earlier test data still in dev: Asha (+91 90000 00003) is both a partner and, from Phase 1 tests, a patient named "Asha Das"; Mother's phone in this test is the same test number. Harmless in dev.

## How to run and demo this phase
- `.\ww.ps1 up`; admin `cd apps\admin_web; npm run dev`; patient app `cd apps\patient_app; flutter run --flavor dev -t lib/main_dev.dart`.
- Log in with `+91 90000 00001` (dev OTP). Family tab → Sabitri (Mother) with her address and 2 documents; Reports tab with filters; Profile → Settings for language and delete account.
- Admin → Patients → Priyansu Gouda → Documents → Open (asks for a reason, then logged in System → Audit log).

## Next phase
Phase 5 — Discovery and booking. Reuse: members and their addresses (pickup address and "For whom"), documents to attach (`documentIds`), `in_service_area` (recheck at booking), the shared upload flow in `ww_core`, and the OpenStreetMap map for hospitals until the Google key arrives.
