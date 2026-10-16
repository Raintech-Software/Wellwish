# Phase 06 — Payment, cancel, refund, reschedule · Completion report

| Item | Value |
|---|---|
| Started | 9 Oct 2026 |
| Completed | 10 Oct 2026 (after the deep check, the Razorpay test-mode checks and the developer's confirmation) |
| Built by | akashto76 with Claude |
| Git | not committed (developer's choice so far; offered at the close) |
| Architecture version used | v2.12 → **v2.13** (changes listed below) |

## Summary
A patient can now pay the booking fee with Razorpay Checkout (UPI, card, netbanking) from Review or from the booking page; the booking becomes **New** only when Razorpay confirms the money (the app's answer is checked, the webhook and a 10-minute check confirm it too). The patient sees My bookings (Upcoming / Ongoing / Past) and a full booking page with the timeline, refunds, **Cancel** (refund shown first, 50% by default) and **Change date or time** (same times as booking, until 3 h before, at most 2 times). The admin has Payments, Refunds (Finance approves big refunds), a fee report (CSV), **Cancel and refund** (0–100%) and **Change date or time** on the booking page, and enters the **Razorpay keys in Settings → Payment keys** (stored encrypted). Without keys, "Pay" keeps the booking unpaid and says online payment isn't available yet.

## Tasks

### Backend
- [x] 6.1 `apps/payments`: create a Razorpay order for the booking fee (amount from the **server snapshot only**) and return it with the booking. *(As its own call `POST /bookings/:id/checkout`, see deviations.)*
- [x] 6.2 `POST /v1/patient/payments/verify` (client callback → "processing").
- [x] 6.3 `POST /v1/webhooks/razorpay`: check the signature; store `webhook_events` and ignore duplicates; `payment.captured` → booking **NEW** → events (patient push + member SMS, admin queue).
- [x] 6.4 Reconcile task (every 10 min) and expire-unpaid task (30 min).
- [x] 6.5 Cancel: preview (refund amount) + cancel before "On the way"; refund % from settings (50); Razorpay refund; refund status sweep.
- [x] 6.6 Admin cancel with refund % (0–100) and a reason. Refunds above ₹500 need Finance approval.
- [x] 6.7 Reschedule (§6.17): until 3 h before pickup, at most 2 times, same time rules. If a partner had accepted, they re-confirm (wired up in phase 7, stored as a flag now).

### Patient app
- [x] 6.8 Razorpay checkout (`razorpay_flutter`) from Review and pay. Payment result screen P16 (success / failure + retry).
- [x] 6.9 My bookings P17 and booking detail P18 with status timeline, **Cancel** (shows the refund amount first) and **Change date/time** (P30).

### Admin panel
- [x] 6.10 Payments page, Refunds page (approve), fee report (CSV), Cancel + refund dialog on the booking, Reschedule on the booking.

### Tests
- [x] 6.11 Webhook signature fail is rejected. A duplicate webhook is ignored. Amount tampering from the app has no effect. Refund = exactly 50% of the paise amount. Reschedule limits work.

## What was built

### Backend
- **`payments`** (new app):
  - Tables `payments` (order, payment id, status CREATED / AUTHORIZED / CAPTURED / FAILED, method, TEST/LIVE mode, failure reason), `refunds` (percent, amount, reason, status AWAITING_APPROVAL / PENDING / PROCESSED / FAILED / REJECTED, who asked, who approved), `webhook_events` (event id unique), `gateway_keys` (key id + encrypted secrets, one row).
  - `gateway.py`: Razorpay Orders / Payments / Refunds over HTTPS with basic auth (no SDK), Checkout and webhook signature checks (HMAC-SHA256, constant-time compare), keys from the admin panel first, then the environment; a fake Razorpay for tests.
  - `services.py`: checkout (creates or reuses the order; only while the booking is unpaid and its payment time lasts), verify, `captured()` (amount must equal the fee; the booking becomes NEW via `mark_paid`; money for an expired / taken / already paid booking is refunded in full), webhook handling (duplicates ignored, only ids and statuses kept), reconcile, refund for a cancel (approval above the limit), send refund, refund status sweep (also sends again refunds Razorpay couldn't take), Finance approve / reject.
  - Patient API: checkout, verify. Admin API: payments, refunds, approve / reject, fee report CSV (logged), payment keys GET / PUT (logged without values). Webhook endpoint without login.
  - Tasks: `payments.reconcile` (10 min), `payments.refund_status_sweep` (30 min), `payments.send_refund` (retries while Razorpay is down; waits quietly while no keys).
- **`bookings`**:
  - `mark_paid` (PAY transition; refuses a booking whose time was taken or that expired), expiry guard (an unpaid booking whose payment is being confirmed isn't expired), `cancel` with a cancel hook (the payments app creates the refund in the same transaction), `reschedule` with `reschedule_problem` (STATUS / TOO_LATE / LIMIT), `reconfirm_needed` flag, RESCHEDULE timeline event with old → new time.
  - Times: `check_time` / `available_times` / `available_days` can leave the booking's own place out (it counts as free when moving it) and skip the minimum notice for the admin.
  - Patient API: cancel-preview, cancel, reschedule-times, reschedule; booking detail now has paid amount, refunds, can cancel / can reschedule (+ why not), changes left, reconfirm flag. Admin API: cancel (0–100%, reason, logged), reschedule (logged); admin detail has payments and refunds.
  - New setting `reschedule_cutoff_hours` (3).
- **`notifications`**: app messages (English, Hindi, Odia) and SMS for booking confirmed, cancelled, time changed, refund processed (to the account; SMS also to the family member's phone).

### Patient app
- **Pay** (6.8): "Pay ₹X" on Review saves the booking (same `Idempotency-Key` on a retry) and opens Razorpay Checkout; the booking page has "Pay ₹X" while the payment time lasts. `features/payments/payment_checkout.dart` wraps `razorpay_flutter` (a fake in tests).
- **P16 Payment result**: confirmed; "Confirming your payment…" (checks every 3 s for about a minute, then "we'll send you a message"); failed / cancelled with "Pay ₹X" again until the pay-by time; "Booking saved — online payment isn't available right now" when no keys are set. Back goes Home.
- **P17 My bookings**: Upcoming / Ongoing / Past tabs, 20 at a time with "Load more", pull to refresh; from Profile → My Bookings and Home's "See all".
- **P18 Booking detail**: status (paid amount, pay-by time), Pay, details, **Change date or time** (changes left, or why not), documents, price, **Refunds** (amount, date, status), timeline (booked, fee paid, time changed, cancelled), **Cancel booking** sheet (refund from the server's preview, reason pills + optional note).
- **P30 Change date or time**: the same date strip and times as booking (shared `date_strip.dart`), the doctor's time for hospital visits (moves with the date; the pickup is suggested again), "Your partner will confirm the new time" when assigned, "Confirm new time" only when something changed.
- Error texts for the new server codes; 51 new texts in English, Hindi and Odia.

### Admin panel
- **Payments** (`/payments`): status filter, search by booking code / order / payment id, TEST tag.
- **Refunds** (`/payments/refunds`): status filter; reason in words; "Waiting to be sent" for a refund Razorpay hasn't got yet; **Approve / Reject** with a note for `refunds.approve`.
- **Fee report** (`/payments/fees-report`): date range (this month by default, at most a year) → CSV download.
- **Settings → Payment keys** (`/settings/payment-keys`, `settings.manage`): keys in use (source, TEST/LIVE, last 4 characters only), the webhook URL and events to set in Razorpay, form to change them (blank secret = keep).
- **Booking page**: Payments and Refunds tables, "Partner must confirm the new time" tag, **Change date or time** (India time, also inside the notice) and **Cancel and refund** (refund % with the amount, reason) for `bookings.manage`.

## API changes
| Method | Path | Notes |
|---|---|---|
| POST | `/v1/patient/bookings/{id}/checkout` | Razorpay order for the fee (503 `PAYMENTS_NOT_SET_UP`, 409 `BOOKING_NOT_PAYABLE`) |
| POST | `/v1/patient/payments/verify` | Checkout result → booking (422 `INVALID_SIGNATURE`) |
| GET | `/v1/patient/bookings/{id}/cancel-preview` | allowed, paid, refund % and amount |
| POST | `/v1/patient/bookings/{id}/cancel` | `{ reason }` (409 `CANCEL_NOT_ALLOWED`) |
| GET | `/v1/patient/bookings/{id}/reschedule-times?date=` | like booking-times, own place free |
| POST | `/v1/patient/bookings/{id}/reschedule` | `{ pickupAt, appointmentAt? }` (409 `RESCHEDULE_NOT_ALLOWED` + reason) |
| POST | `/v1/admin/bookings/{id}/cancel` | `{ reason, refundPercent }` (`bookings.manage`, logged) |
| POST | `/v1/admin/bookings/{id}/reschedule` | `{ pickupAt, appointmentAt? }` (`bookings.manage`, logged) |
| GET | `/v1/admin/payments` | `payments.view` |
| GET | `/v1/admin/refunds` | `refunds.request` |
| POST | `/v1/admin/refunds/{id}/approve` · `/reject` | `{ reason }` (`refunds.approve`, logged) |
| GET | `/v1/admin/reports/fees?from=&to=` | CSV (`payments.view`, logged) |
| GET · PUT | `/v1/admin/payment-keys` | `settings.manage`; secrets never returned |
| POST | `/v1/webhooks/razorpay` | no login; signature checked |

Booking detail (patient and admin) gained payment, refund and reschedule fields. OpenAPI regenerated: yes (`.\ww.ps1 openapi`, `.\ww.ps1 gen-clients`).

## Database changes
| App | Migration | What it does |
|---|---|---|
| payments | 0001_initial | `payments`, `refunds`, `webhook_events`, `gateway_keys` |
| bookings | 0003_booking_reconfirm_needed | `bookings.reconfirm_needed` |
| notifications | 0003_booking_templates | app message texts (en / hi / or) for confirmed, cancelled, rescheduled, refund processed |

## Tests
| Check | Command | Result |
|---|---|---|
| Full check | `.\ww.ps1 check` | all passed (after the deep-check fixes) |
| Backend tests | (in check) | 464 passed (new: `apps/payments/tests/test_payments.py`, `apps/bookings/tests/test_cancel_reschedule.py`) |
| Lint / types | ruff, mypy | clean |
| Patient app | `flutter test` | 50 passed (new `test/payments_test.dart`: not set up, cancelled then paid, processing then confirmed, verify failed → no second payment, paid too late → not booked, payment being confirmed → no Pay, already paid, cancel with refund, no cancel on the way, reschedule, too late, My bookings, Hindi) |
| Admin | `tsc`, `npm run lint`, `npm run build` | clean |

## Exit criteria
| Criterion (from PHASES.md) | How it was verified | Result |
|---|---|---|
| In **Razorpay test mode**, paying moves the booking to NEW and it appears in the admin bookings list | 10 Oct 2026, the developer's Razorpay **test** keys (entered in Settings → Payment keys): on the emulator WW-10007 (Doctor visit companion, fee ₹100) → Pay ₹100 → Razorpay Checkout → test Netbanking → demo bank "Success" → app "Booking confirmed, Paid ₹100"; database: booking NEW, payment CAPTURED, TEST, netbanking; admin All bookings: WW-10007 "New (to assign)" | ✅ |
| Closing the app during payment still ends with a confirmed booking (webhook path) | WW-10008 (fee ₹50): demo bank "Success", then the app was force-closed 1.5 s later (the app never reported the payment). Razorpay had the money (captured); our booking stayed unpaid until the scheduled 10-minute reconcile asked Razorpay and confirmed it at 9:50 (NEW, CAPTURED); the reopened app shows it booked. **No webhook yet** (no public URL in dev): the path that confirmed it is reconcile, not the webhook; the webhook path itself is covered by tests (signed event confirms, bad signature refused, duplicate ignored) | ✅ (reconcile; webhook when a public URL exists) |
| Cancelling a ₹100 booking fee refunds ₹50 (shown in the Razorpay test dashboard) | Cancelling WW-10007 in the app: "You'll get back ₹50 (50% of the booking fee)" → refund of ₹50 sent to Razorpay (Razorpay refund id stored); Razorpay's API answers **processed**; the app shows the ₹50 refund. Confirmed by the developer in the Razorpay test dashboard | ✅ (API; seen in the Razorpay test dashboard by the developer) |
| A reschedule within 3 h of pickup is refused. A 3rd reschedule is refused | Tests, plus a live API check: WW-10005 moved twice, the 3rd refused (`LIMIT`); WW-10006 with pickup 2 h away refused (`TOO_LATE`); the app greys out "Change date or time" and says why | ✅ |

## Screens
In `docs/phases/img/phase-06/`: `p16-not-set-up.jpg`, `p18-unpaid-pay.jpg`, `p18-paid.jpg`, `p30-reschedule.jpg`, `p18-time-changed.jpg`, `cancel-sheet.jpg`, `p18-cancelled-refund.jpg`, `p17-my-bookings-past.jpg`, `admin-rescheduled.jpg`, `admin-cancel-dialog.jpg`, `admin-refunds-approve.jpg`, and from Razorpay test mode: `razorpay-test-checkout.jpg`, `p16-confirmed-razorpay-test.jpg`, `cancel-sheet-100-fee.jpg`, `p18-refund-50-of-100.jpg`, `p17-closed-app-payment-confirmed.jpg`. Same style as the mockup (cards, pills, green pay button).

## Deviations from ARCHITECTURE.md
| What changed | Why | Agreed with developer | ARCHITECTURE.md updated |
|---|---|---|---|
| Razorpay keys are entered in the admin panel (Settings → Payment keys), stored encrypted; env only as fallback | Developer: "key id and secret I will add later from UI of admin" | yes | v2.13 §6.12, §9.1, §11, §12 |
| The Razorpay order is created by its own call `POST /bookings/:id/checkout`, not returned by "Book" | "Pay" again on the booking page needs an order without booking again; Book stays the same with or without keys | yes (10 Oct 2026) | v2.13 §6.12, §10.3 |
| Money arriving after the booking expired, after its time was taken, or a second payment is refunded in full automatically (no approval) | The patient must never pay for nothing (Phase 5 follow-up) | yes (10 Oct 2026) | v2.13 §6.12 |
| An unpaid booking whose payment is being confirmed is not expired | A slow confirmation must not lose a paid booking | yes (10 Oct 2026) | v2.13 §6.12 |
| The refund is created in the cancel's own transaction (cancel hook), not by the `booking.cancelled` event | The cancel answer and the booking page show the refund at once; no refund is lost if the worker is down | yes (10 Oct 2026) | v2.13 §10.2 |
| New setting `reschedule_cutoff_hours` (3) instead of a fixed 3 h; the admin may reschedule inside the notice, cut-off and limit without using the patient's changes | Same pattern as the other time rules; the admin fixes problems for patients | yes (10 Oct 2026) | v2.13 §6.17 |
| The patient can cancel while NEW, OFFERED or ACCEPTED (not an unpaid booking: it simply expires) | Unpaid bookings have nothing to refund and expire in 30 min | yes (10 Oct 2026) | v2.13 §6.12 |
| Cancel reasons from the app are sent as codes (`PLANS_CHANGED`, `BOOKED_BY_MISTAKE`, `OTHER` + optional note); the admin shows them in words | Language-independent for staff | yes (10 Oct 2026) | — |
| A booking fee is at least ₹1 (services) | Razorpay can't take less; a ₹0 fee booking could never be paid | yes (10 Oct 2026) | v2.13 (deep check) |
| While a payment is being confirmed (up to 2 h) the booking can't be paid again (409 `PAYMENT_IN_PROGRESS`) and doesn't expire | A second order could charge twice | yes (10 Oct 2026) | v2.13 (deep check) |
| Reconcile closes orders nobody paid 1 h after the payment time; money arriving later is refunded in full | Abandoned orders were checked for 3 days | yes (10 Oct 2026) | v2.13 (deep check) |
| Finance can send a failed refund again (`POST /v1/admin/refunds/:id/retry`) | A failed refund had no way forward | yes (10 Oct 2026) | v2.13 §9.1, §10.3 |

## Deep check
Three independent reviews (backend; patient app; admin panel + docs) after the build, then fixes with tests, then live checks again (emulator, admin in the browser, API). 31 problems were found and fixed:

**Backend**
1. **A refund could be paid twice** (high): if Razorpay made the refund but its answer was lost, the retry and the 30-minute sweep sent it again. Now Razorpay is first asked for a refund carrying our refund id; only if there is none is a new one made. The failure reason is kept (it was rolled back).
2. A failed try closed the whole order, so a later successful try in the same Checkout whose webhook was missed was never confirmed (and never refunded). A failed try now only records the reason; the order stays open.
3. Abandoned orders were asked about every 10 min for 3 days (oldest first, 200 at a time), and a stuck "being confirmed" payment could keep a booking unpaid for ever. Reconcile now checks the newest orders of the current keys first and closes orders nobody paid an hour after the payment time; "being confirmed" holds a booking at most 2 hours.
4. Reconcile's 1-hour rule could overwrite a payment a webhook had just captured. It now changes only the status it saw.
5. A ₹0 booking fee couldn't be paid (500). A booking fee is now at least ₹1 (Razorpay's minimum).
6. A webhook was recorded before it was handled: if handling failed, Razorpay's retry was taken for a duplicate. Now one transaction; an event id over 64 characters is refused (was a 500).
7. The cancel refund could be taken from a payment the system had already given back in full ("paid twice"). It now uses the payment that paid for the booking and never refunds more than is left of it.
8. A capture of a wrong amount could overwrite a confirmed payment, and that money was never returned. It is now refunded in full and logged as an error.
9. A failed refund was a dead end. Finance can **send it again** (Payments → Refunds, logged).
10. Admin cancel / reschedule and their audit records are now one transaction.
11. Money in the refund SMS and the fee CSV was formatted with floats. Now whole-number arithmetic.
12. Test gap: the admin skipping the minimum notice and the cut-off is now tested.

**Patient app**
13. **A booking that expired while the patient paid was shown as "Booking confirmed"** (high). It now shows "Booking not made — your money is returned in full".
14. If Checkout said paid but the confirmation call failed, the app offered "Pay" again (a second charge). It now shows "Confirming your payment" and asks the server; the booking page hides "Pay" while a payment is being confirmed (`paymentPending`), and the server refuses a new order then (409 `PAYMENT_IN_PROGRESS`).
15. Checkout's answer could never come (phone closed it): the Review spinner stayed for ever. Now it gives up after Checkout's own timeout plus 2 minutes and asks the server; an answer for another order is ignored.
16. Paying from an old booking page of an already paid booking said "Payment didn't go through"; it now shows it confirmed.
17. An outside wallet counted as "being confirmed"; Razorpay doesn't take that money for us, so it is "not paid".
18. The "being confirmed" checks could overlap on a slow network; now one at a time.
19. My bookings could show a booking twice when the list shifted between pages, and "Try again" reloaded the wrong page.
20. Double taps on Pay, Pay again and "Yes, cancel" are now ignored.
21. The cancel sheet had no "Try again" when the refund preview failed to load.
22. Checkout's colour was typed in; it now comes from the brand tokens.
23. Changing the doctor's time to one no pickup fits kept the old pickup; it is now cleared.

**Admin panel**
24. Payment keys: "leave empty to keep" was shown for keys from the environment, and saving then lost the webhook secret (every webhook refused). The hint is shown only for keys saved in the panel, a warning appears when the key id changes (other account or test/live), and the server keeps the environment's webhook secret for the same key id.
25. The cancel message named the oldest refund, not the new one; the paid amount now comes from the server (the payment that paid).
26. The India-time picker was an hour off on daylight-saving days for admins abroad.
27. The reschedule picker offered :15 / :45 times the server refuses; it now uses the Settings time step, hides past days, and the "too soon" text is right for admins.
28. Admins saw the patient's "call support" texts when a booking had moved on; now admin wording, and the booking reloads.
29. Double submits, and buttons stuck loading after a network error (all payment dialogs and the CSV download).
30. Secret fields cut at 100 characters (the server allows 128); password managers kept out of them.
31. Wording: the approve hint only for Finance, failure reasons in words, the fee report is per day, a reason of spaces is refused.

**Docs:** ARCHITECTURE §6.12 (admin cancel before the job; after the job comes with support tickets in Phase 8), §9.1, §10.3 (retry), the 2.13 line; PHASES 6.1 note; PROGRESS row; stale docstrings.

**Not changed:** rescheduling an *assigned* booking into a time that clashes with the same partner's other job would hit the database overlap rule (500 instead of 409). No booking can be assigned before Phase 7; noted for Phase 7.

## Known issues and follow-ups
- **Webhook secret not set yet:** Razorpay can't reach a dev PC. Add it (Settings → Payment keys) when there is a public URL (a tunnel or staging); until then payments confirm through the app and the 10-minute reconcile, refund statuses through the 30-minute sweep.
- **Phase 7:** the partner's re-confirm offer after a reschedule (`reconfirm_needed`), the admin queue alert for a newly paid booking, withdrawing an offer on cancel, the partner's "Booking cancelled" message.
- **Phase 9:** push notifications (the texts exist; Firebase key later).
- **Phase 7:** rescheduling an assigned booking into a time that clashes with the same partner's other job must answer 409 (now it would be a 500; no booking can be assigned yet).
- `razorpay_flutter` can lose Checkout's answer when Android recreates the screen; the app then gives up after the timeout and asks the server (the money is never lost: the webhook / reconcile confirm or refund it).
- Dev data: WW-10003 … WW-10006 were paid with a simulated capture before the keys existed; once the keys were entered, Razorpay refused their refunds (the payments don't exist there), so they show as failed refunds in the admin. Harmless test data.

## How to run and demo this phase
- `.\ww.ps1 up`; admin `cd apps\admin_web; npm run dev`; app `cd apps\patient_app; flutter run --flavor dev -t lib/main_dev.dart`; test number `+91 90000 00001`, code `123456`.
- Enter Razorpay **test** keys: Admin → Settings → Payment keys (Super Admin). Razorpay test UPI `success@razorpay` or a test card from Razorpay's docs.
- Book (Home → Book a Companion → … → Pay ₹X) → Checkout → result → My bookings → the booking → Change date or time / Cancel booking.
- Admin: Payments, Refunds (approve above ₹500), Fee report; a booking → Cancel and refund / Change date or time.

## Next phase
Phase 7 — Assignment. Uses `reconfirm_needed`, the `booking.paid` event (admin queue alert) and the cancel hook (withdraw the offer).
