# Hindi and Odia texts: review by the client

`wellwish-texts-for-review.csv` holds every text people see, in English, Hindi and Odia (Phase 9.1, 13 Oct 2026). Open it in Excel or Google Sheets (it is UTF-8).

| Area | What it is | Where a correction goes |
|---|---|---|
| App screens | Every word in the patient and partner apps (720 texts) | `packages/ww_l10n/lib/l10n/app_hi.arb` / `app_or.arb` (by **Key**) |
| Inbox / push, Email | Messages the apps and emails send (title/subject and body) | A new migration in `backend/apps/notifications/migrations/` (by code and language) |
| Partner documents | Document names, hints and "when it's needed" | Admin panel → Partners → Required documents (no release needed) |
| Services | Service names | Admin panel → Services & prices (no release needed) |

**How to review:** for each row, write `yes` in "Hindi correct?" / "Odia correct?", or `no` and the better wording in "Better Hindi" / "Better Odia". Keep the words in `{braces}` (they are filled in, e.g. `{name}`) and brand words (WellWish, OTP, SMS, UPI) as they are.

SMS stay in English (developer decision, 13 Oct 2026); their texts are in [DLT-SMS-TEMPLATES.md](../DLT-SMS-TEMPLATES.md).

To rebuild the sheet after changes, see the Phase 9 report (`docs/phases/phase-09-hardening.md`, 9.1).
