# WellWish

Book a verified companion or home nurse, for yourself or your family (Odisha, India).

| Part | Folder | Tech |
|---|---|---|
| Patient app | `apps/patient_app` | Flutter |
| Partner app (companions, nurses) | `apps/partner_app` | Flutter (Android) |
| Admin panel | `apps/admin_web` | Next.js + Ant Design |
| Backend API | `backend` | Django 5.2 + Django Ninja, PostgreSQL 16, Redis, Celery, Channels |
| Shared Flutter code | `packages/ww_ui`, `ww_core`, `ww_auth` (login screens), `ww_l10n`, `ww_api` (generated) | |

**Read first:**
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): what we build and how
- [docs/PHASES.md](docs/PHASES.md): the task list
- [docs/PROGRESS.md](docs/PROGRESS.md): where we are
- [CLAUDE.md](CLAUDE.md): working rules

## One-time setup (Windows)

1. **Docker Desktop** on WSL 2.
   - Optional: cap WSL memory so the Android emulator has room. Put this in `%USERPROFILE%\.wslconfig`, then run `wsl --shutdown`:
     ```
     [wsl2]
     memory=4GB
     ```
2. **Android Studio**: Android SDK (with the NDK the build asks for), command-line tools, and an emulator.
3. **Flutter** stable and **Node.js** LTS.
4. **melos** (Flutter workspace tool): `dart pub global activate melos`
5. In the project folder: `flutter pub get` (resolves every Flutter app and package at once).

## Everyday commands (PowerShell, project root)

```powershell
.\ww.ps1 up            # backend containers (db, redis, api, worker, beat) + admin panel window
.\ww.ps1 down          # stop everything
.\ww.ps1 check         # ALL checks: backend lint/types/tests/migrations, Flutter analyze/test, admin lint/build
.\ww.ps1 test          # backend tests only
.\ww.ps1 logs api      # follow a container's logs
.\ww.ps1 shell         # Django shell
.\ww.ps1 openapi       # export docs/api/openapi.json
.\ww.ps1 gen-clients   # regenerate the Dart client (packages/ww_api) + admin TypeScript types
.\ww.ps1 seed          # dev data: the dev admin user (DEV_ADMIN_EMAIL / DEV_ADMIN_PASSWORD in backend/.env)
.\ww.ps1 manage sms_outbox 9876543210   # the SMS (OTP) the dev SMS backend "sent" to that number
.\ww.ps1 help          # every command
```

| What | Where |
|---|---|
| API health | http://localhost:8000/v1/health |
| API docs (Swagger) | http://localhost:8000/v1/docs |
| Admin panel | http://localhost:3000 |
| Django admin (developers only) | http://localhost:8000/django-admin/ |

## Running the apps

```powershell
cd apps\patient_app
flutter run --flavor dev -t lib/main_dev.dart      # emulator → API at http://10.0.2.2:8000
```

- **Partner app:** the same command from `apps\partner_app`.
- **Flavors:** `dev`, `staging` and `prod` have different app IDs, so all three can be installed together.
- **Real phone on your Wi-Fi:**
  1. Copy `apps/dart-defines.example.json` to `apps/dart-defines.json` and put your PC's IP in it.
  2. Add `--dart-define-from-file=../dart-defines.json` to the run command.

## Logging in (dev)

- **Test numbers:** +91 90000 00001 to 00005 accept the OTP `123456`, and no SMS is sent (`OTP_TEST_NUMBERS` in `backend/.env`).
- **Other numbers:** read the code with `.\ww.ps1 manage sms_outbox <number>`. On the emulator, `adb emu sms send 9000012345 "<sms text>"` lets the app read it by itself.
- **Admin panel:** run `.\ww.ps1 seed`, then sign in with the dev admin from `backend/.env`. The first sign-in shows a QR code for Google Authenticator (2FA).
- **Google sign-in** is hidden until `GOOGLE_CLIENT_IDS` (backend) and `--dart-define=GOOGLE_SERVER_CLIENT_ID=…` (app) are set.
- After an APK build, `cd apps\patient_app\android; .\gradlew --stop` frees about 1.5 GB of memory for the emulator.

## Settings files

| File | Copy to | Used by |
|---|---|---|
| `backend/.env.example` | `backend/.env` (done automatically by `ww.ps1`) | Django, Celery |
| `apps/admin_web/.env.example` | `apps/admin_web/.env.local` | Admin panel |
| `apps/dart-defines.example.json` | `apps/dart-defines.json` | Flutter apps (optional API address) |

Never commit the copies: they're git-ignored.
