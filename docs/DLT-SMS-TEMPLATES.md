# DLT SMS templates (final list, Phase 9.1; SOS_UNACKED added in 9.5)

Generated from `backend/common/sms.py` (`TEMPLATES`) — change the code first, then this list.

- **19 templates, English only** (developer decision, 13 Oct 2026: the apps, inbox, push and
  email are in Hindi and Odia; SMS stay English: cheaper and one DLT registration each).
- **Category:** Service Implicit (messages to our own users about their account, bookings
  and visits). Header (sender id): `WELWSH` or the one approved for WellWish.
- **On DLT** each `{name}` below is a `{#var#}` (in this order); a value is at most
  30 characters (`send_sms` shortens longer ones). `link` and `map` are `{#url#}`
  variables: whitelist `play.google.com` and `maps.google.com` (and the WellWish domain) on the
  DLT portal (TRAI's URL whitelisting).
- **In MSG91** create one Flow per template with the same text, writing each variable as
  `##name##` (the names below), link it to the DLT template id, and put the Flow's template id
  in the setting (`MSG91_TEMPLATE_<NAME>`, see KEYS-AND-ACCOUNTS #3).
- `LOGIN_OTP` starts with `<#>` and ends with the app hash (Android reads the code itself).

| # | Template (setting `MSG91_TEMPLATE_…`) | Sent | DLT text | Variables (in order) |
|---|---|---|---|---|
| 1 | `LOGIN_OTP` | Login code (patient and partner apps) | <#> {#var#} is your WellWish verification code. It expires in 5 minutes. Do not share it with anyone. {#var#} | `otp`, `app_hash` |
| 2 | `PARTNER_ADDED` | A partner added by an admin | Welcome to WellWish, {#var#}. You are now a WellWish partner. Install the partner app and log in with this number: {#url#} | `name`, `link` (url) |
| 3 | `PARTNER_APPROVED` | Partner application approved | Congratulations {#var#}, your WellWish partner account is approved. Open the WellWish Partner app to start. | `name` |
| 4 | `PARTNER_CHANGES_REQUESTED` | Partner documents need a change | Some documents in your WellWish partner application need a change. Open the WellWish Partner app to see why and upload them again. | — |
| 5 | `PARTNER_SUSPENDED` | Partner account paused | Your WellWish partner account is paused: {#var#}. Please call WellWish support on {#var#}. | `reason`, `support` |
| 6 | `PARTNER_REINSTATED` | Partner account active again | Your WellWish partner account is active again. Thank you. | — |
| 7 | `DOCUMENT_EXPIRED` | A partner document expired | Your {#var#} has expired. Upload a new one in the WellWish Partner app to keep getting jobs. | `document` |
| 8 | `BOOKING_CONFIRMED` | To the family member's phone: booking paid | WellWish: {#var#} for {#var#} on {#var#} is booked (ref {#var#}). We will send the partner's name and phone soon. | `service`, `name`, `when`, `code` |
| 9 | `BOOKING_CANCELLED` | To the family member's phone: booking cancelled | WellWish: booking {#var#} for {#var#} on {#var#} is cancelled. | `code`, `name`, `when` |
| 10 | `BOOKING_RESCHEDULED` | To the family member's phone: new time | WellWish: booking {#var#} for {#var#} is moved to {#var#}. | `code`, `name`, `when` |
| 11 | `BOOKING_ASSIGNED` | To the family member's phone: partner assigned | WellWish: {#var#} ({#var#}) will help {#var#} on {#var#} (ref {#var#}). | `partner`, `partner_phone`, `name`, `when`, `code` |
| 12 | `BOOKING_REMINDER` | To the family member's phone: 24 h / 2 h reminder | WellWish reminder: {#var#} for {#var#} on {#var#} (ref {#var#}). | `service`, `name`, `when`, `code` |
| 13 | `OFFER_NEW` | To a partner: new booking offer | WellWish: new booking {#var#} on {#var#}. Open the WellWish Partner app to accept or decline. | `code`, `when` |
| 14 | `OFFER_TIME_CHANGED` | To a partner: the booking's time changed | WellWish: booking {#var#} is now on {#var#}. Please confirm the new time in the Partner app. | `code`, `when` |
| 15 | `JOB_CANCELLED` | To a partner: the job is cancelled | WellWish: booking {#var#} on {#var#} is cancelled. You don't need to go. | `code`, `when` |
| 16 | `JOB_OTP` | To the family member's phone: the visit code | WellWish visit code for {#var#}: {#var#}. Give it to {#var#} only when they arrive (ref {#var#}). | `name`, `otp`, `partner`, `code` |
| 17 | `SOS_ALERT` | To emergency contacts: SOS during a visit | WellWish SOS: {#var#} pressed SOS during visit {#var#}. Location: {#url#}. Please call them now, or 112. | `who`, `code`, `map` (url) |
| 18 | `SOS_UNACKED` | To WellWish's support phone: an SOS not acknowledged in 2 minutes | WellWish: SOS on visit {#var#} not acknowledged for 2 minutes. Open the admin panel Live page and call now. | `code` |
| 19 | `TEMP_PARTNER_JOB` | To a temporary partner: the job and the app link | WellWish: {#var#}, your WellWish job {#var#} is on {#var#}. Install the WellWish Partner app and log in with this number: {#url#} | `name`, `code`, `when`, `link` (url) |

## MSG91 Flow texts (variable names)

| Template | Flow text |
|---|---|
| `LOGIN_OTP` | <#> ##otp## is your WellWish verification code. It expires in 5 minutes. Do not share it with anyone. ##app_hash## |
| `PARTNER_ADDED` | Welcome to WellWish, ##name##. You are now a WellWish partner. Install the partner app and log in with this number: ##link## |
| `PARTNER_APPROVED` | Congratulations ##name##, your WellWish partner account is approved. Open the WellWish Partner app to start. |
| `PARTNER_CHANGES_REQUESTED` | Some documents in your WellWish partner application need a change. Open the WellWish Partner app to see why and upload them again. |
| `PARTNER_SUSPENDED` | Your WellWish partner account is paused: ##reason##. Please call WellWish support on ##support##. |
| `PARTNER_REINSTATED` | Your WellWish partner account is active again. Thank you. |
| `DOCUMENT_EXPIRED` | Your ##document## has expired. Upload a new one in the WellWish Partner app to keep getting jobs. |
| `BOOKING_CONFIRMED` | WellWish: ##service## for ##name## on ##when## is booked (ref ##code##). We will send the partner's name and phone soon. |
| `BOOKING_CANCELLED` | WellWish: booking ##code## for ##name## on ##when## is cancelled. |
| `BOOKING_RESCHEDULED` | WellWish: booking ##code## for ##name## is moved to ##when##. |
| `BOOKING_ASSIGNED` | WellWish: ##partner## (##partner_phone##) will help ##name## on ##when## (ref ##code##). |
| `BOOKING_REMINDER` | WellWish reminder: ##service## for ##name## on ##when## (ref ##code##). |
| `OFFER_NEW` | WellWish: new booking ##code## on ##when##. Open the WellWish Partner app to accept or decline. |
| `OFFER_TIME_CHANGED` | WellWish: booking ##code## is now on ##when##. Please confirm the new time in the Partner app. |
| `JOB_CANCELLED` | WellWish: booking ##code## on ##when## is cancelled. You don't need to go. |
| `JOB_OTP` | WellWish visit code for ##name##: ##otp##. Give it to ##partner## only when they arrive (ref ##code##). |
| `SOS_ALERT` | WellWish SOS: ##who## pressed SOS during visit ##code##. Location: ##map##. Please call them now, or 112. |
| `SOS_UNACKED` | WellWish: SOS on visit ##code## not acknowledged for 2 minutes. Open the admin panel Live page and call now. |
| `TEMP_PARTNER_JOB` | WellWish: ##name##, your WellWish job ##code## is on ##when##. Install the WellWish Partner app and log in with this number: ##link## |
