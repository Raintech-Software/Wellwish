# Phase 9B — Store requirements · Completion report

| Item | Value |
|---|---|
| Started | 14 Oct 2026 |
| Completed | 14 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice) |
| Architecture version used | v2.30 at the start → v2.31 |

## Summary
What the stores and the DPDP Act need before release is built. **Legal pages**: Terms of Use, Privacy Policy, Refund Policy and Partner Terms. A Super Admin edits and versions them, people read them on public pages in three languages and from the apps, and an admin can ask everyone to accept again. **Partners accept their terms.** **Partners delete their own account** in the app, or anyone deletes theirs on the **web page `/delete-account`** with an SMS code. **The storage itself enforces the upload limits** through a presigned POST, proven against a real S3 API. A deep check by three reviewers found 22 issues. All are fixed, including a redesign of the deletion wait so sanctions keep working. Every exit criterion was checked live: admin panel in the browser, both apps on the emulator, the S3 test store in Docker.

## Tasks
| # | Task | Status |
|---|---|---|
| 9B.1 | `apps/legal`: versioned legal documents, admin endpoints, public pages, links in the app-config | ✅ |
| 9B.2 | Consent versions from the published documents; Partner consents | ✅ |
| 9B.3 | Partner account deletion (wait, cancel on login, daily erase) | ✅ |
| 9B.4 | Web page `/delete-account` for both apps | ✅ |
| 9B.5 | Uploads as a presigned POST with a size range; `.\ww.ps1 s3-test` | ✅ |
| 9B.6 | Admin: Legal pages, deletion tag and notice, `DELETED`, uploads with the POST | ✅ |
| 9B.7 | Patient app: Read links, Terms / Privacy / Refund rows, uploads with the POST | ✅ |
| 9B.8 | Partner app: consent screen, Delete my account, texts in 3 languages | ✅ |

## What was built
### Backend
- **Legal pages** (new app `apps/legal`, table `legal_documents`, §6.20):
  - Terms of Use, Privacy Policy, Refund Policy and Partner Terms; each publish is a new version (rows are never changed), in English, Hindi and Odia (Hindi / Odia may stay empty: the English is shown with a note).
  - First drafts seeded (migration `legal/0002`) from what the app really does; the parts only the client knows are in [square brackets] (company name, address, grievance officer, support email, court city). Version 1's consent version is `2026-10`, the one patients had already accepted, so nobody is asked again by the drafts.
  - Admin endpoints (`legal.manage`, Super Admin; migration `staff/0005`): list, the newest version, the history, an old version, publish. Publishing checks `expectedVersion` (409 `LEGAL_VERSION_CHANGED` if someone published meanwhile), refuses an unchanged text (422 `NOTHING_CHANGED`) and a half-written language (422 `INCOMPLETE_LANGUAGE`); audit `legal.published` lists which fields changed. "Ask everyone again" makes the version the new consent version.
  - Public pages `/legal/terms|privacy|refunds|partner-terms` (`?l=hi|or`, else the browser's language): Django templates, everything escaped (the text format allows headings, bullets, paragraphs and `**bold**` only), CSP `default-src 'none'` (no script at all), `Referrer-Policy: same-origin`, `no-store`. Their full links are in the app-config (`legalUrls`), from `PUBLIC_SITE_URL` (empty = the address the request came in on).
- **Consents**: the server refuses `register/start` until the Partner Terms and Privacy Policy are accepted (409 `CONSENT_NEEDED`, deep check). The Terms, Privacy and Partner Terms versions now come from the published pages (health data keeps `CONSENT_VERSION_HEALTH_DATA`); each app accepts only its own consents (a partner can't accept health data, a patient can't accept the Partner Terms). Partners: `consentsNeeded` in `GET /v1/partner/me`, `POST /v1/partner/me/consents` (open at every status). The Privacy Policy is shared: accepted once, for both apps.
- **Partner account deletion**: `POST /v1/partner/me/delete` (any status; 409 `ACTIVE_JOBS` while an accepted or ongoing job is theirs, or during a temporary job). At once: "available today" off, logged out everywhere, open offers withdrawn (event `partner.deletion_requested` → the assignment app's "partner unavailable"), audit `partner.deletion_requested`. **While it waits the status stays as it is** (the deep check's design: suspending, deactivating, a document expiry, a rejection and the fake-GPS count all keep working), but the partner gets no offers, isn't in the suggestions, can't be assigned or accepted by phone, and leaves the applications queue (opening the application: 409 `PARTNER_DELETING`). A Partner app login before the date cancels it (nothing else changes). A daily task (`partners.process_account_deletions`, 02:25 IST; it locks the user row first, as a login does) erases after `account_deletion_days`: name → "Former partner" (also in the bookings' offer events and the admins' alerts), every personal field, both phones, KYC documents and the application, selfies, a temporary ID photo, the inbox, phones and sessions, with the files deleted after the commit; status `DELETED`. Kept: bookings, fees, reviews, routes of finished visits, SOS records, the audit log, consents. The user row is anonymised unless the person is still a patient; someone who never chose a role is deleted at once. An admin can't edit a deleting or deleted partner (409 `PARTNER_DELETED`). A `DELETED` partner who is still a patient registers again as a new application. Table `partner_deletions`; `source` (APP / WEB / ADMIN) on both deletion tables.
- **Web page `/delete-account`** for both apps (English, Hindi, Odia): phone → SMS code (the login's code rules and limits, its own purpose, the per-device limit per IP) → the accounts on that number → "Delete" with a required tick → done with the date. No login, no scripts; server-rendered forms with Django's CSRF check; between steps a short-lived signed token carries the number (10 min) and then the verified user (15 min). The page never says whether a number has an account before the code is right.
- **Uploads**: a presigned **POST** (S3 `generate_presigned_post`): the key and type are fixed and a `content-length-range` of 1 byte to the purpose's limit, so S3 itself refuses a bigger file, another type or another key. Every upload ticket has `uploadFields`; the local stand-in takes the same multipart POST and answers 204 like S3. `FILE_S3_ENDPOINT_URL` points the S3 code at an S3-compatible store; `.\ww.ps1 s3-test` runs `apps/files/tests/test_s3_storage.py` against one in Docker.
### Patient app
- Consent screen (P04): "Read the Terms of Use / Privacy Policy" under each line (health data opens the Privacy Policy), in the app's language.
- Settings (P27): "Terms and policies" with the Terms of Use, Privacy Policy and Refund Policy.
- Uploads (documents, member photos) send the POST.
### Partner app
- New consent screen before anything else (Partner Terms + Privacy Policy, each readable), for new partners and, at their next app open, partners who registered earlier.
- "Delete my account" with the Partner Terms and Privacy Policy links on the Profile tab, the registration hub, the status screen and the role choice; the confirm text gives the admin's waiting time; `ACTIVE_JOBS` is said in the partner's language; afterwards the login screen says the account will be deleted soon.
- Uploads (photo, documents, selfie) send the POST.
### Admin panel
- Settings → **Legal pages** (only with `legal.manage`): the 4 pages with version, languages and who published; the editor with a tab per language and a live preview, "Publish small fix" / "Publish and ask everyone again" (each asks first; the Refund Policy, not a consent, has one "Publish"), the version history with each old version readable.
- Partners: a "Deletion requested" tag next to the status in the list, the `Deleted` status (also in the status filter); the partner page says when the data is erased and hides Edit (after the erase: a "deleted their account" notice and no actions).
- Uploads (directory photos, partner documents, temporary ID photo) send the POST through one shared function.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET | `/v1/public/app-config` | + `legalUrls` |
| GET | `/v1/partner/me` | + `consentsNeeded` |
| POST | `/v1/partner/me/consents` | new (any status) |
| POST | `/v1/partner/me/delete` | new (any status) → `{ dueAt, done }` |
| GET | `/v1/admin/legal`, `/v1/admin/legal/{kind}`, `/v1/admin/legal/{kind}/versions`, `/v1/admin/legal/{kind}/versions/{version}` | new (`legal.manage`) |
| POST | `/v1/admin/legal/{kind}` | new: publish |
| GET / PUT | `/v1/admin/partners/{id}` | + `partner.deletionDueAt`; PUT 409 `PARTNER_DELETED` |
| POST | every `…/upload-url` | + `uploadFields`; the file is POSTed (was PUT) |
| GET | `/legal/{slug}`, `/delete-account` (+ POST) | public HTML pages |

OpenAPI regenerated: yes (Dart and TypeScript clients too).

## Database changes
| App | Migration | What it does |
|---|---|---|
| legal | `0001_initial`, `0002_first_drafts` | `legal_documents`; the 4 first drafts |
| staff | `0005_legal_manage` | Super Admins get `legal.manage` |
| accounts | `0005_alter_consent_type` | consent type `PARTNER_TERMS` |
| partners | `0005_alter_partnerprofile_status_partnerdeletion`, `0006_remove_partnerdeletion_previous_status_and_more` | status `DELETED`; `partner_deletions` (0006: the deep check's redesign, the waiting status removed; a dev row in it gets its status back) |
| patients | `0004_accountdeletion_source` | `account_deletions.source` |

## Tests
| Check | Command | Result |
|---|---|---|
| Everything | `.\ww.ps1 check` (after the deep-check fixes, and again at the close after the live checks) | all 11 steps pass |
| S3 test store | `.\ww.ps1 s3-test` (SeaweedFS 3.97) | 2 passed: one byte over the limit refused (`EntityTooLarge`), another type and another key refused with nothing stored, exactly the limit stored, the API checks the stored file and serves it, delete works |
| Backend | pytest | 667 passed, 2 skipped (the S3-store tests: they run with `.\ww.ps1 s3-test`) |
| Flutter | `melos run test` | Partner app 76, Patient app 66, packages 63 (ww_core 30 with the new `uploads_test.dart`) |
| Large text | `flutter test --dart-define=WW_TEXT_SCALE=2` in both apps | 0 overflows (3 found and fixed: the booking timeline and "Visit completed" card from Phase 9.11, the Partner app's document list) |
| Admin | lint, build | clean |
| New backend tests | `apps/legal/tests` (10: format and escaping, public pages, permissions, publishing, the deletion page with CSRF), `apps/partners/tests/test_account_deletion.py` (10), `apps/accounts/tests/test_partner_consents.py` (2) | pass |

## Live checks (14 Oct 2026, local: Docker API, admin panel in the browser, both apps on the Android emulator)
| What | Result |
|---|---|
| Admin → Settings → Legal pages: list, editor with preview, version history, old version opened | ok |
| Two admins editing at once: the second publish gets the conflict warning and keeps its text | ok |
| Privacy Policy published "asking everyone again" (v3) | the public page shows it; `consentsNeeded` lists Privacy 3 |
| Partner app (Rina) at the next open | consent screen with Partner Terms + Privacy Policy and Read links ([screenshot](img/phase-09b/partner-consent.png)); stored PARTNER_TERMS 2026-10 and PRIVACY 3 |
| Partner app Profile tab | Partner Terms / Privacy rows and "Delete my account" ([screenshot](img/phase-09b/partner-profile-links.png)); the dialog gives the 7 days ([screenshot](img/phase-09b/partner-delete-dialog.png)), cancelled |
| Patient app at the next open | only the Privacy Policy asked again ([screenshot](img/phase-09b/patient-asked-again.png)); after agreeing straight to Home, no location step; stored PRIVACY 3, nothing else needed |
| A small fix (v4: a test sentence removed) | consent version stays 3, nobody asked again |
| Web page `/delete-account` | a partner (Live Check Partner) and a throwaway patient deleted with an SMS code in the browser; both rows `PENDING` / `WEB`, due 21 Oct, sessions gone; the page in Hindi and Odia; no console or CSP errors |
| Admin partners list / partner page while waiting | "Approved" + "Deletion requested" tag; the "erased on 21 Oct 2026" notice, Edit hidden |
| Daily erase, clock moved 8 days (`process_due_deletions`) | Live Check Partner: status `Deleted`, "Former partner", email, 5 documents, both phones and sessions gone, the number off the user row; the admin page says the account was deleted, no actions; History "Approved → Deleted" |
| Admin uploads with the POST, from the panel's page | normal file 204; 6 MB for a 5 MB purpose 413 `FILE_TOO_LARGE`; a changed `Content-Type` field 422; a changed ticket 403 |
| App uploads with the POST, on the emulator | Patient app: Medical Reports → a gallery photo → `POST /v1/files/upload/… 204` → listed; Partner app (Rina): the optional training document → 204 → "Being checked" |
| `.\ww.ps1 s3-test` | passes (see Tests) |

Dev data left by these checks: Privacy Policy v4 in the dev database; "Former partner" (erased); the throwaway patient +91 70000 00201 with a pending web deletion; "Upload check" in Priyansu's medical reports; a First-aid training document of Rina's waiting for review. The partner page's History of Live Check Partner also shows one "Approved → DELETION_PENDING" row written before the deep check's redesign (dev only: the status never existed outside this database, and the audit log is never rewritten).

## Exit criteria
| Criterion | Result | How checked |
|---|---|---|
| Privacy Policy published "asking everyone again": public page, patient and partner asked at the next open and stored with the new version, a small fix asks nobody, old versions readable | ✅ | live (admin panel, both apps on the emulator, the database) and `apps/legal/tests` |
| A new partner can't register before accepting; an existing partner is asked at the next open | ✅ | `test_registering_needs_the_partner_terms_first`; live with Rina |
| Partner deletion in the app: logged out, refused with an active job, a login keeps the account, erased after the wait ("Former partner"; fees and audit kept) | ✅ | `test_account_deletion.py` (10); live: the dialog, and the daily erase with the clock moved |
| The web page deletes a patient and a partner account with an SMS code, same rules, 3 languages | ✅ | `test_delete_account_page.py` (4); live: one partner, one patient, the page in Hindi and Odia |
| Against the S3 test store the storage refuses a bigger file, another type or key; uploads work in both apps and the admin panel | ✅ | `.\ww.ps1 s3-test`; live uploads in the Patient app, the Partner app and the admin panel (local stand-in) |
| `.\ww.ps1 check` passes | ✅ | at the close, 14 Oct 2026 |

## Deep check (14 Oct 2026)
Three independent reviewers read the server, the apps, and the admin panel with the docs and the legal drafts. All findings below are fixed and re-tested, except where noted.

**Server**
1. **A waiting deletion froze the partner's status** (`DELETION_PENDING`): suspend, deactivate, reject and the document-expiry suspension were refused meanwhile, and a login restored the old status, so deleting and logging in again was a way out of a sanction (and reset the fake-GPS count). → Redesigned: the status never changes while it waits; a pending `partner_deletions` row keeps them out of offers, suggestions, assigning, phone acceptance and the review queue. Tests: `test_sanctions_keep_working_while_a_deletion_waits`, `test_a_deleting_partner_gets_no_offers_and_is_not_reviewed`.
2. **The erased partner's name stayed** in the bookings' offer events and the admins' alerts. → Replaced with "Former partner". Test: `test_the_erase_takes_the_name_out_of_timelines_and_alerts`.
3. **A deleting applicant stayed in the review queue.** → Out of it and of the dashboard count; opening it is refused (409 `PARTNER_DELETING`).
4. **The nightly erase and a login took the locks in opposite orders** (possible deadlock). → Both lock the user row first.
5. **Two admins publishing at once got a 500.** → 409 `LEGAL_VERSION_CHANGED` (not reproducible in a test; the unique key catches it).
6. **The Partner Terms were only asked by the app.** → `register/start` is refused without them (409 `CONSENT_NEEDED`). Test: `test_registering_needs_the_partner_terms_first`.
7. **A re-registration kept the old account's approval date and "added by admin".** → Cleared.
8. **`PUBLIC_SITE_URL` empty on a server would give the admin panel a wrong "Public page" link.** → Required in the server settings (test of the server settings updated).

**Apps**
1. **The consent screen could replace the job screen (and its SOS) when the app came back mid-visit.** → It never replaces the job, care-note or balance screens; asked once the visit is left. Test: `the consent screen never replaces a visit in progress`.
2. **A login with nothing saved was erased at once, but the apps said "deleted after 7 days".** → The dialog says it's deleted now; the login screen "Your account is deleted." (new end reason `accountErased`). Test in `account_test.dart`.
3. **New terms published while the consent screen was open** left the person stuck ("Something went wrong"), and old ticks carried over. → Reloaded, asked again, nothing pre-ticked (ticks belong to a version). Test: `terms changed while the screen was open`.
4. **The Partner consent screen had no way out** (Log out, Delete my account). → Added.
5. **A patient re-accepting changed terms was asked about location again.** → Only at sign-up.
6. **Opening a legal page used the screen's state after waiting**, and a phone without a browser failed silently. → Fixed; "Something went wrong" then.
7. **S3's XML refusals showed "Something went wrong".** → "The file is too large" / "The upload took too long. Please try again." (new text). Tests in `packages/ww_core/test/uploads_test.dart`, which also checks the exact multipart body (fields first, `file` last, no login header).
8. **Tests that didn't prove their claim**: a ticket whose type didn't match its field, the waiting time equal to the app's default (now 10 days), the health-data link and Hindi links never tapped. → Fixed and added.

**Admin panel, docs and legal drafts**
1. **The legal drafts stated four things the app doesn't do** (only the last 4 Aadhaar digits stored; every partner checked before any booking; the address seen only for 24 hours with every view logged; deleted data out of the backups within 7 days). → Rewritten to match the app (uploaded documents are kept as uploaded; temporary partners for one booking; documents limited and logged; a pre-release backup kept until the release works). Also added: location, IP addresses, member photos, the Google email, providers outside India, what a deletion keeps. The drafts were corrected in their migration (never deployed) and in the dev database.
2. **A publish conflict wiped the admin's text.** → The text stays, with a warning naming the new version; the browser asks before closing a page with unsaved text.
3. **The Refund Policy states settings an admin can change** (refund %, cut-off, payment time). → Its editor shows the current values; those settings' help says to republish it.
4. **Validation and old-version errors were silent** in the editor. → Messages, and the tab with the problem opens.
5. **The S3 exit criterion promised more than `s3-test` can show** (the browser and app path to real S3 needs the bucket's CORS and a real address). → Reworded: the storage's own refusals are proven by `s3-test`; the apps' and panel's path is seen at the deploy.
6. **Docs gaps**: the new job and event, `uploadFields` in the API map, MinIO and v2.30 left in PROGRESS. → Fixed.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| The S3 test store is SeaweedFS's S3 gateway, not MinIO | MinIO no longer publishes images (Docker Hub refuses them, quay.io has none) | yes, 14 Oct 2026 (and the image download) | PHASES 9B.5 |
| A partner's status doesn't change while their deletion waits (the first build had a `DELETION_PENDING` status) | the deep check: a waiting status blocked suspensions and a login restored the old status, a way out of a sanction | yes, 14 Oct 2026 | v2.31 §6.20, §11 (written before the close, in the same version) |

## Known issues and follow-ups
- **The legal drafts need the client and a lawyer before release.** They are English only. Each has 2–5 [square bracket] gaps: company name, address, grievance officer, support email and court city. Hindi and Odia can be added in the admin panel; until then the English is shown with a note. Publish the real text "asking everyone again" (Phase 10).
- **The browser and app path to real S3** can only be seen at the deploy (Phase 10). The bucket needs a CORS rule allowing POST from the panel (`KEYS-AND-ACCOUNTS.md` #9). The panel's CSP already allows the S3 hosts. `.\ww.ps1 s3-test` proves what the storage itself refuses, not this path.
- SeaweedFS answers a broken policy condition with `307` back to the bucket, where AWS answers `403 AccessDenied`. The S3 test accepts both and checks that nothing was stored. The apps and panel don't need this, because they talk to AWS.
- Two old messages in the panel's browser console came from React's development-only double-run of the Leaflet map ("Map container is being reused"). They don't happen in a production build, didn't come back after a reload, and aren't from this phase.
- New texts in Hindi and Odia (apps and the deletion page) are in `docs/translations/wellwish-texts-for-review.csv` for a native speaker's review, as for the earlier phases.
- `PUBLIC_SITE_URL` must be set on servers (`KEYS-AND-ACCOUNTS.md` #11). The store listings' links to the legal pages and `/delete-account` are #17.

## How to run and demo this phase
- Legal pages: <http://localhost:8000/legal/privacy> (`?l=hi`, `?l=or`); admin panel → Settings → Legal pages.
- Account deletion page: <http://localhost:8000/delete-account>; codes for numbers that aren't test numbers: `.\ww.ps1 manage sms_outbox <number>`.
- S3 upload limits: `.\ww.ps1 s3-test`.

## Next phase
Phase 10 — Release.
