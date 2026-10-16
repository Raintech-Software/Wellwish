# Live checks (local development only)

End-to-end tests that drive the **running** local stack (`.\ww.ps1 up`) over real HTTP and live
sockets, as the apps and the admin panel do. They complement the unit tests in `.\ww.ps1 check`.

| Script | What it checks |
|---|---|
| `visit_flow.py` | Patient: profile, family member / address / document add-edit-delete. Booking → payment → admin queue (live) → offer → decline → offer → accept (live) → every visit step with the visit code, live location, share link, SOS (ack / resolve) → Completed → rating, problem report + reply, review hide / show. Cancel with 50% refund (family-member SMS), reschedule, temporary partner (login code from Test messages, access ends at cancel). Admin: hospital and service add-edit-deactivate-delete, every admin page's data. Prints how fast offers, accepts, locations and SOS arrive. |
| `partner_signup.py` | A new companion: login code, consents, role, alternate phone and email codes, profile photo, every required KYC document → admin claims, opens and approves each document, approves the partner (SMS, email, inbox) → first offer live → accept → account deletion refused during a job, allowed after. |
| `family_inbox.py` | The family's inbox (Phase 9C): a paid booking and an accepted partner reach the family's bell live (`notification.new`) and the inbox, newest first, linked to the booking. Leaves one test booking ACCEPTED with Asha. |
| `offer_timeout.py` | An offer nobody answers: the admin's "not accepted in 2 minutes" alert and the partner's reminder, then "Accepted by phone". Takes about 2½ minutes. |

Run one (PowerShell, from the project root):

```powershell
Get-Content -Raw -Encoding UTF8 infra\livecheck\visit_flow.py | docker compose -f infra/docker-compose.yml exec -T api python manage.py shell
```

- They sign in as the QA admin from `backend/.env` (`DEV_QA_ADMIN_*`) and the test numbers `+91 90000 00001` (patient), `…03` Asha and `…05` Rina (partners); new numbers get their codes from Settings → Test messages. Nothing secret is printed.
- **One shortcut:** the Razorpay TEST payment is marked captured on the server (`payments.services.captured`), because paying needs the Checkout screen. Refunds of these simulated payments show FAILED (Razorpay doesn't know them): expected, dev data only. Pay once in the patient app with Razorpay test mode to check refunds for real.
- Login codes are limited to 5 an hour per number. Before running several times in a row, clear the dev counters: `docker compose -f infra/docker-compose.yml exec -T redis sh -c 'redis-cli --scan --pattern ":1:rl:otp:*" | xargs -r redis-cli del'`.
- They leave test data behind (bookings named E2E, cancelled; E2E partners waiting for deletion).
