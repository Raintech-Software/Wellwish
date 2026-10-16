# Keys and accounts still to add

> **Last updated:** 10 Oct 2026

Every outside key, account and secret the project needs, so nothing is forgotten. The plan is to add them **at the end** (Phase 10, or earlier when a phase can't be tested without one). Until then, the app runs with dev stand-ins.

**Never write a key's value in this file or anywhere in Git.**
- On your own PC, values go in `backend/.env` (git-ignored) or `apps/admin_web/.env.local`.
- On the servers, they go in AWS Secrets Manager.

This file lists only **what** is needed and **where** it goes.

Status: ⬜ not started · 🟨 applied / waiting · ✅ added (dev) · 🚀 added (production)

## 1. Vendor keys and accounts

| # | What | Used for | Needed by | Where it goes | Dev stand-in today | Status |
|---|---|---|---|---|---|---|
| 1 | **Google Maps Platform** API keys (Maps SDK Android + iOS, Places Autocomplete, Maps JavaScript) | Address search, hospital map, live tracking, admin map pins | Phase 5 (booking address), Phase 8 (tracking), admin (replaces OpenStreetMap) | Android: `com.google.android.geo.API_KEY` in the manifest (from a build variable). iOS: `AppDelegate`. Admin: `NEXT_PUBLIC_GOOGLE_MAPS_KEY` (name to confirm when added) | OpenStreetMap: admin panel (v2.8) and the patient app's address pin (v2.11). **OpenStreetMap's free tile server is for light use only: replace before launch.** | ⬜ |
| 2 | **Google Sign-In** OAuth client ids (Web, Android, iOS) from Google Cloud Console | "Continue with Google" on the login screen | Optional (button hidden until set) | Backend `GOOGLE_CLIENT_IDS` (comma-separated). Apps `--dart-define=GOOGLE_SERVER_CLIENT_ID=…`. iOS: reversed client id URL scheme in `Info.plist`. Android client needs the **SHA-1** of each signing key | Google button hidden | ⬜ |
| 3 | **MSG91** auth key + **DLT** registration (entity id, sender header, one template id per SMS; the 19 texts to register: [DLT-SMS-TEMPLATES.md](DLT-SMS-TEMPLATES.md), English only, Phase 9) | Real OTP and alert SMS | Before staging (Phase 10); DLT approval takes days to weeks, so **apply early** | `MSG91_AUTH_KEY` and one DLT template id per SMS: `MSG91_TEMPLATE_LOGIN_OTP`, `MSG91_TEMPLATE_PARTNER_ADDED`, `MSG91_TEMPLATE_PARTNER_APPROVED`, `MSG91_TEMPLATE_PARTNER_CHANGES_REQUESTED`, `MSG91_TEMPLATE_PARTNER_SUSPENDED`, `MSG91_TEMPLATE_PARTNER_REINSTATED`, `MSG91_TEMPLATE_DOCUMENT_EXPIRED`, `MSG91_TEMPLATE_BOOKING_CONFIRMED`, `MSG91_TEMPLATE_BOOKING_CANCELLED`, `MSG91_TEMPLATE_BOOKING_RESCHEDULED` (Phase 6), `MSG91_TEMPLATE_BOOKING_ASSIGNED`, `MSG91_TEMPLATE_BOOKING_REMINDER`, `MSG91_TEMPLATE_OFFER_NEW`, `MSG91_TEMPLATE_OFFER_TIME_CHANGED`, `MSG91_TEMPLATE_JOB_CANCELLED` (Phase 7), `MSG91_TEMPLATE_JOB_OTP`, `MSG91_TEMPLATE_SOS_ALERT` (Phase 8), `MSG91_TEMPLATE_SOS_UNACKED` (Phase 9.5: an SOS not acknowledged in 2 minutes, to the support phone), `MSG91_TEMPLATE_TEMP_PARTNER_JOB` (Phase 8B, temporary partner). A test checks every text has its id setting. The texts to register are in `backend/common/sms.py` (`TEMPLATES`). | Console SMS outbox (admin → Settings → Test messages, or `.\ww.ps1 manage sms_outbox <phone>`); test numbers `+91 90000 00001–05` | ⬜ |
| 4 | **AWS SES**: verified domain (SPF, DKIM), production access (out of sandbox) | Partner email verification codes | Phase 3 (dev uses a console adapter), live in Phase 10 | `MAIL_FROM` (e.g. `WellWish <no-reply@…>`, on the verified domain), `MAIL_SES_REGION` (default `ap-south-1`). Servers use `MAIL_BACKEND=common.mail.SESMailBackend` (the default there) and the server's IAM role, no access keys. | Console mail outbox (`.\ww.ps1 manage mail_outbox <email>`) | ⬜ |
| 5 | **Firebase** project: `google-services.json` (Android, each app and flavor: `in.wellwish.patient(.dev/.staging)`, `in.wellwish.partner(.dev/.staging)`), `GoogleService-Info.plist` (iOS), **APNs key (.p8)** uploaded to Firebase, service account for FCM HTTP v1 on the server | Push notifications (new job, status updates) | Phase 3 (notifications app), Phase 7 (job offers; **left for later by the developer, 10 Oct 2026**: the inbox, SMS and live socket carry offers until then) | App config files in each app's `android/app/` and `ios/Runner/` (git-ignored if they hold keys). Server: `FCM_PROJECT_ID`, `FCM_CREDENTIALS_FILE` (path to the service-account JSON from the secret store); servers use `PUSH_BACKEND=common.push.FCMPushBackend` (the default there) | Console push stand-in (logged, nothing sent); the in-app inbox works | ⬜ |
| 6 | **Razorpay** account (business KYC), **test** key id + secret, then **live** keys, **webhook secret** (Razorpay Dashboard → Webhooks: URL = API address + `/v1/webhooks/razorpay`, events `payment.captured`, `payment.failed`, `order.paid`, `refund.processed`, `refund.failed`) | Paying the booking fee, refunds | Phase 6 (test keys, to check the Phase 6 exit criteria), Phase 10 (live) | **Admin panel → Settings → Payment keys** (Super Admin; stored encrypted with `FIELD_ENCRYPTION_KEY`). Fallback only: env `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`, `RAZORPAY_WEBHOOK_SECRET` | None: "Pay" keeps the booking unpaid ("online payment isn't available"); tests use a fake Razorpay | ⬜ |
| 7 | **Sentry** project(s) + DSNs (backend, patient app, partner app, admin) | Error reports | Phase 9 (wired), Phase 10 (live) | Backend `SENTRY_DSN`. Apps: set `SENTRY_DSN_PATIENT` / `SENTRY_DSN_PARTNER` on the PC that builds; `.\ww.ps1 build` passes it as `--dart-define=SENTRY_DSN=…`. Admin: `NEXT_PUBLIC_SENTRY_DSN` at build time (the panel's CSP then allows its host). The obfuscated apps need their symbols (`build\symbols\…`) uploaded to Sentry for readable stack traces (sentry-cli / `sentry_dart_plugin`, with a Sentry auth token kept out of Git). Every report is masked (phones, tokens, codes, 12-digit numbers; no user, cookies, headers or bodies). | Empty = off | ⬜ |

## 2. Hosting (AWS Mumbai, `ap-south-1`)

| # | What | Used for | Needed by | Where it goes | Status |
|---|---|---|---|---|---|
| 8 | **AWS account** + billing alerts | Everything below | Staging (Phase 10, or earlier for a test server) | — | ⬜ |
| 9 | **S3 bucket** (private, KMS encryption) + **IAM role** on the server (no access keys in files) | Partner KYC and patient documents, directory photos | Phase 10 (dev uses a local folder) | `FILE_STORAGE=s3`, `FILE_S3_BUCKET`, `FILE_S3_REGION` (default `ap-south-1`); `FILE_S3_ENDPOINT_URL` stays empty on servers. The bucket needs a **CORS rule** allowing `POST` (and `GET`) from the admin panel's origin (uploads go straight to S3 with a presigned POST, v2.31; the panel's CSP allows `*.s3.amazonaws.com` and `*.s3.ap-south-1.amazonaws.com`). Versioning on, old versions kept 7 days (runbooks/backups.md). | ⬜ |
| 10 | **EC2** server, **RDS** PostgreSQL 16, **ElastiCache** Redis (or Redis on the server), **Secrets Manager**, **CloudWatch** + an **SNS topic** that emails / texts the team | Running the API, workers, database; the §13 alarms | Phase 10 | `DATABASE_URL`, `REDIS_URL`, `CELERY_BROKER_URL`, `CELERY_RESULT_BACKEND`, `CHANNELS_REDIS_URL`, `TRUSTED_PROXY_HOPS`. Alarms (Phase 9.5): `CLOUDWATCH_NAMESPACE` (e.g. `WellWish/production`; empty = metrics only logged), `CLOUDWATCH_REGION` (default `ap-south-1`), the server's IAM role allowed `cloudwatch:PutMetricData`; then `python infra/cloudwatch/create_alarms.py --env … --namespace … --alb … --target-group … --topic-arn …` creates the 8 alarms | ⬜ |
| 11 | **Domain + DNS + TLS** (e.g. `api.`, `admin.` and a short link domain for trip sharing) | HTTPS for the API, admin and share links | Phase 10 | `SHARE_LINK_BASE_URL` (the address trip links start with, e.g. `https://wellwish.in`; dev: `http://localhost:8000`, so a dev link only opens on the PC), `PUBLIC_SITE_URL` (Phase 9B, §6.20: where the legal pages `/legal/…` and the account deletion page `/delete-account` are reached, e.g. `https://wellwish.in`; **required on servers**, empty in dev = the API's own address), `DJANGO_ALLOWED_HOSTS`, Nginx/ALB config, admin `API_PROXY_TARGET` and `NEXT_PUBLIC_WS_BASE_URL` (empty when Nginx forwards `/ws/` on the panel's own host; Phase 7). Set `NEXT_PUBLIC_APP_ENV` to `staging` / `prod` on servers (only `dev` uses the API's port 8000 for the live socket) | ⬜ |

## 3. Secrets we generate ourselves (one set per environment)

| # | Name | What it protects | Notes | Status |
|---|---|---|---|---|
| 12 | `DJANGO_SECRET_KEY` | Django signing | Different on dev, staging and production | ⬜ |
| 13 | `JWT_SIGNING_KEY` | Login tokens | Must differ from the secret key (the server refuses to start otherwise) | ⬜ |
| 14 | `OTP_HMAC_KEY` | Stored OTP hashes | Must differ from the secret key | ⬜ |
| 15 | `FIELD_ENCRYPTION_KEY` (Fernet) | Admin 2FA secrets and the Razorpay key secret + webhook secret entered in the admin panel | **Changing it later makes the saved 2FA secrets and Razorpay secrets unreadable**: every admin must scan a new QR code and the Razorpay secrets must be entered again. Keep it safe. | ⬜ |

Generate them on the server, never on a shared screen:
```
python -c "import secrets; print(secrets.token_urlsafe(50))"                                  # 12, 13, 14
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"     # 15
```

## 4. App stores and signing

| # | What | Needed by | Where it goes | Status |
|---|---|---|---|---|
| 16 | **Android upload keystore** for each app (patient, partner) + its passwords | Phase 10 | `apps/<app>/android/key.properties` (git-ignored) with `storeFile` (path to the `.jks`, relative to `android/app/`), `storePassword`, `keyAlias`, `keyPassword`; the `.jks` file kept in a safe backup. `build.gradle.kts` signs release builds with it (without it: the debug key, and `.\ww.ps1 build` says so). Its SHA-1 also goes into Google Sign-In (#2) and the Maps key restriction (#1). Keep the **crash-report symbols** of each release too (`build\symbols\<app>\<flavor>\<version>`, made by `.\ww.ps1 build`; Phase 9.3): an obfuscated crash can't be read without them. | ⬜ |
| 17 | **Google Play Console** account (one-time fee) and listings `in.wellwish.patient`, `in.wellwish.partner` | Phase 10 | The listings' privacy policy link `{PUBLIC_SITE_URL}/legal/privacy` and account deletion link `{PUBLIC_SITE_URL}/delete-account` (Phase 9B) | ⬜ |
| 18 | **Apple Developer** account (yearly fee), bundle id, App Store app id | Phase 10 (patient app on iOS) | Replace the placeholder `id0000000000` in `APP_STORE_URLS` (`backend/config/settings/base.py`) | ⬜ |

## 5. Real values to type into the admin panel (not secrets)

| # | What | Where | Status |
|---|---|---|---|
| 19 | Real **support phone** and **WhatsApp** numbers (today the placeholder `+91 90000 00000`) | Admin → Settings → Support | ⬜ |
| 20 | Real **prices** (the seeded ones are the examples from §6.6) | Admin → Services & prices | ⬜ |
| 21 | Exact **hospital map pins** (the 5 seeded pins are approximate) | Admin → Directory → Hospitals | ⬜ |
| 22 | Real **service areas** (seed: Bhubaneswar, 25 km) | Admin → Settings → Service areas | ⬜ |
| 23 | **First Super Admin** on each server (`.\ww.ps1 manage create_staff_user … --role SUPER_ADMIN`); the dev admin from `.env` is never used there | Phase 10 | ⬜ |
| 24 | **Partner app store link** sent in the "partner added" SMS (today the expected Play Store URL) | `PARTNER_APP_URL` in `backend/.env` / Secrets Manager, once the listing exists | ⬜ |

## How to add one
1. Put the value in `backend/.env` (dev) or Secrets Manager (servers). Never in a file that Git tracks.
2. Mark the row ✅ or 🚀 here, with the date in the Status column.
3. If a stand-in can be removed (e.g. OpenStreetMap → Google Maps), do it in the phase that adds the key and log it in PROGRESS.md.
