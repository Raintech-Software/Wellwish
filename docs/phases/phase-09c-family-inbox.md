# Phase 9C — Family inbox · Completion report

| Item | Value |
|---|---|
| Started | 16 Oct 2026 |
| Completed | 16 Oct 2026 |
| Built by | akashto76 with Claude |
| Git | not committed (offered at the close) |
| Architecture version used | v2.32, v2.33 (inbox limit) |

## Summary
Families now see every message about their bookings inside the app. The bell on Home shows how many are unread and updates live. It opens **Notifications (P25)**: booking confirmed, partner assigned, reminders, partner on the way, completed, cancelled, rescheduled, refund done and WellWish's replies, newest first. Tapping one opens that booking. Until now these messages went out only as push notifications, which stay off until the Firebase key is added; this gap was found in the full test of 16 Oct 2026. A second bug from the full test is fixed too: a change made by someone else (an admin's cancel or new time, the unpaid expiry) now reaches the family's open app at once.

## Tasks
- [x] 9C.1 Backend: `GET /v1/patient/notifications`, `GET …/unread-count`, `POST …/read` (only the caller's own, only the family app); socket `notification.new` `{type, unread}` when an inbox message is saved (both apps). Tests.
- [x] 9C.2 Patient app: the bell on Home with the unread count (live), Notifications screen P25 (newest first, unread dot, opening marks read, a booking's message opens it, empty state, pull to refresh), English / Hindi / Odia. Widget tests.
- [x] 9C.3 Live check on the emulator: a booking confirmed and a partner assigned appear in the family's inbox at once.
- [x] 9C.4 *(added after the close, developer, 16 Oct 2026)* Inbox limit: the last 30 days, at most the newest 50; the bell counts those only; nightly delete of family messages older than 30 days (`notifications.delete_old_family_messages`, 03:05 IST). The list ends with "Messages from the last 30 days are kept here." Checked on the emulator: the bell went from 99+ to none (no unread among the newest 50), Load more showed the rest up to 50, then the note (`img-2026-10-16/patient-notifications-30-day-note.png`). Tests: 50 shown of 55 + one 31 days old, the bell 50; the nightly job deletes only family messages older than 30 days; the note at the end of the list.

## What was built
### Backend
- `apps/notifications/api/patient.py`: the family inbox (list, unread count, mark read), the same rules as the partner inbox.
- `notifications.services.notify`: after an inbox message is saved, `notification.new` `{type, unread}` goes to that person's app socket (`user.{app}.{id}`, after commit). Messages that are SMS / email only (visit code, SOS alert, email codes) are never in the inbox and never announced.
- **Fix:** `bookings.services.transition()` and `reschedule()` now send `booking.updated` to the family's app on every status or time change, whoever made it. Before, only partner and visit events did, so an admin's cancel left Home on "Partner assigned" until the app was reopened.
### Patient app
- `features/notifications/notifications_screen.dart`: P25 (newest first, unread dot, a booking's message opens it, empty state, pull to refresh) and `NotificationBell` (badge with the count, "99+"; screen-reader label "Notifications, N unread").
- The bell on Home (it used to say "coming soon"); route `/notifications`.
- Session controller: `notification.new` sets the bell's number and reloads the inbox; after a reconnect the count is loaded again.
- New text `notificationsUnread` in English, Hindi and Odia.

## API changes
| Method | Path | Notes |
|---|---|---|
| GET | `/v1/patient/notifications` | newest first, paged; `data.bookingId` opens the booking |
| GET | `/v1/patient/notifications/unread-count` | `{ unread }` |
| POST | `/v1/patient/notifications/read` | `{ ids? }` (none = all) → `{ unread }` |
| WS | `notification.new` `{ type, unread }` | `/ws/patient/` and `/ws/partner/` |

OpenAPI regenerated: yes (`.\ww.ps1 openapi`, `.\ww.ps1 gen-clients`).

## Database changes
None (the `notifications` table already held the family's messages).

## Tests
| Check | Command | Result |
|---|---|---|
| Everything | `.\ww.ps1 check` | **All passed** after the review fixes: backend 670 (2 skipped), partner app 76, patient app 71, ww_core 30, ww_ui 18, ww_auth 9, ww_l10n 6, admin lint + build |
| New backend tests | family inbox (own messages only, family app only, mark read), `notification.new` (count; never for SMS-only codes), an admin's cancel / new time reach the family's app | pass |
| New widget tests (`patient_app/test/notifications_test.dart`) | bell count → inbox → marked read by id → opens the booking → bell 0; a live message raises the count; Load more + a failed mark-read still shows the list; the next person after logout gets their own count; empty inbox | 5 pass |
| Live check (`infra/livecheck/family_inbox.py`) | booking paid → "Booking confirmed" on the bell in 950 ms; partner accepts → "Partner assigned" in 119 ms; both in the inbox, newest first, linked to the booking | 5 / 5 |

## Exit criteria
| Criterion | How it was verified | Result |
|---|---|---|
| A family sees "booking confirmed" and "partner assigned" in Notifications within seconds; the bell goes up and back to 0 after opening | Live on the emulator: the bell showed 99+ (148 earlier messages that had nowhere to show), Notifications listed "Partner assigned" and "Booking confirmed" for WW-10040 at the top, tapping opened WW-10040, back on Home the bell was gone; then an admin cancel raised it to 1 at once; a new paid booking appeared on Home by itself (bell 2) and disappeared when the admin cancelled it (bell 3). Screens in `docs/testing/img-2026-10-16/`. | ✅ |
| `.\ww.ps1 check` passes | All passed (16 Oct 2026, after the review fixes) | ✅ |

## Independent review (16 Oct 2026)
A separate reviewer read the changes: no serious bugs; 5 smaller problems, all fixed and tested:
- `POST …/notifications/read` with `{"ids": []}` marked **every** message read (also in the partner inbox): an empty list now marks nothing (test).
- Opening the inbox marked everything read, so a message saved between loading and marking was never shown as new: it now marks only the messages it shows, by id (test checks the ids sent).
- A failed "mark read" turned the whole screen into an error, and leaving the inbox quickly could leave the bell stale: the list stays, the bell is updated safely (test).
- After a logout, the next person on the same phone could see the previous person's bell number for a moment: the count is reset at logout and loaded at login (test, checked to fail without the fix).
- Only the newest 50 messages were reachable: pages of 30 with **Load more** (test).
- Asked: a mark-read with someone else's ids is silently ignored (200), as in the partner inbox. Kept: it reads nothing and changes nothing of theirs.

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| P25 built as its own phase 9C before release | Full test: families' messages only went out as push (off until Firebase) | yes ("Ok do", 16 Oct 2026) | v2.32 |
| `notification.new` also goes to the partner app | One place in the server for both apps | — (the partner app doesn't use it yet) | v2.32 §10.4 |

## Known issues and follow-ups
- The partner app's bell still has no number (it ignores `notification.new` for now) → low → when push is set up.
- The dev test account has 148 old messages (every message since Phase 6): expected, dev data only.
- The bell shows "99+" above 99.
- The family inbox fetches 30 messages a page (Load more for the rest, up to 50 in all; v2.33).

## How to run and demo this phase
- `.\ww.ps1 up`; patient app on the emulator or a phone (`build\apk\WellWish-Patient-dev-2026-10-16.apk` talks to `http://172.16.1.2:8000`); log in with `+91 90000 00001`, code `123456`.
- Book and pay (Razorpay test mode: Netbanking → Success), assign a partner in the admin panel: the bell counts up while Home is open; tap it.
- Live check: `Get-Content -Raw -Encoding UTF8 infra\livecheck\family_inbox.py | docker compose -f infra/docker-compose.yml exec -T api python manage.py shell`.

## Next phase
Phase 10 — Release.
