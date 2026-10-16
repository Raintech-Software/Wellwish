"""Settings shared by every environment. Environment files (dev/test/staging/prod) override these.

All values that differ per machine or contain secrets come from environment variables.
"""

from pathlib import Path
from typing import Any

import environ
from celery.schedules import crontab

BASE_DIR = Path(__file__).resolve().parent.parent.parent

env = environ.Env()

APP_ENV = env("APP_ENV", default="dev")
SECRET_KEY = env("DJANGO_SECRET_KEY")
DEBUG = False
ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=[])

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django.contrib.postgres",
    # third party
    "ninja",
    "channels",
    "django_celery_beat",
    # WellWish
    "common",
    "apps.accounts",
    "apps.patients",
    "apps.staff",
    "apps.audit",
    "apps.app_config",
    "apps.services",
    "apps.hospitals",
    "apps.files",
    "apps.notifications",
    "apps.partners",
    "apps.kyc",
    "apps.addresses",
    "apps.documents",
    "apps.bookings",
    "apps.payments",
    "apps.assignments",
    "apps.tracking",
    "apps.safety",
    "apps.reviews",
    "apps.dashboard",
    "apps.legal",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "common.middleware.WriteRateLimitMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

# §12 / PHASES 9.3: every write to the API per minute, per caller (token) and per IP (0 = off)
WRITE_RATE_LIMIT_PER_MINUTE = env.int("WRITE_RATE_LIMIT_PER_MINUTE", default=60)
WRITE_RATE_LIMIT_PER_IP_MINUTE = env.int("WRITE_RATE_LIMIT_PER_IP_MINUTE", default=300)

ROOT_URLCONF = "config.urls"
ASGI_APPLICATION = "config.asgi.application"
WSGI_APPLICATION = "config.wsgi.application"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

# --- Database (PostgreSQL 16; locations are plain lat/lng, no PostGIS — ARCHITECTURE §3.2) ---
DATABASES = {"default": env.db("DATABASE_URL")}
DATABASES["default"]["CONN_MAX_AGE"] = env.int("DB_CONN_MAX_AGE", default=60)
DATABASES["default"]["CONN_HEALTH_CHECKS"] = True
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# --- Users and passwords ---
AUTH_USER_MODEL = "accounts.User"
PASSWORD_HASHERS = [
    "django.contrib.auth.hashers.Argon2PasswordHasher",
    "django.contrib.auth.hashers.PBKDF2PasswordHasher",
]
AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
        "OPTIONS": {"min_length": 12},
    },
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# --- Time: store UTC, show IST (ARCHITECTURE §11) ---
LANGUAGE_CODE = "en"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True
DISPLAY_TIME_ZONE = "Asia/Kolkata"

# --- Static and uploaded files ---
STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
MEDIA_URL = "media/"
MEDIA_ROOT = BASE_DIR / "media"

# Uploads (ARCHITECTURE §6.8): "local" = MEDIA_ROOT behind signed URLs on this API (dev);
# "s3" = private bucket with presigned URLs (staging/prod).
FILE_STORAGE = env("FILE_STORAGE", default="local")
FILE_S3_BUCKET = env("FILE_S3_BUCKET", default="")
FILE_S3_REGION = env("FILE_S3_REGION", default="ap-south-1")
# An S3-compatible store instead of AWS (the `ww.ps1 s3-test` store); empty on servers.
FILE_S3_ENDPOINT_URL = env("FILE_S3_ENDPOINT_URL", default="")
FILE_UPLOAD_URL_TTL_SECONDS = 10 * 60
FILE_VIEW_URL_TTL_SECONDS = 5 * 60

# --- Redis: cache, Celery, Channels (separate DB numbers) ---
REDIS_URL = env("REDIS_URL", default="redis://redis:6379/0")
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": REDIS_URL,
    }
}
# channels_redis waits up to 5 s on Redis for each socket message; redis-py's default read
# timeout is also 5 s, which killed idle sockets. Give the read more time than the wait.
CHANNELS_REDIS_SOCKET_TIMEOUT = 30
CHANNEL_LAYERS: dict[str, Any] = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [
                {
                    "address": env("CHANNELS_REDIS_URL", default="redis://redis:6379/3"),
                    "socket_timeout": CHANNELS_REDIS_SOCKET_TIMEOUT,
                    "socket_connect_timeout": 5,
                }
            ]
        },
    }
}

# --- Celery (queues are declared in config/celery.py) ---
CELERY_BROKER_URL = env("CELERY_BROKER_URL", default="redis://redis:6379/1")
CELERY_RESULT_BACKEND = env("CELERY_RESULT_BACKEND", default="redis://redis:6379/2")
CELERY_RESULT_EXPIRES = 3600
CELERY_TASK_DEFAULT_QUEUE = "default"
CELERY_TASK_ACKS_LATE = True
CELERY_WORKER_PREFETCH_MULTIPLIER = 1
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"
CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TIMEZONE = "UTC"
CELERY_BEAT_SCHEDULER = "django_celery_beat.schedulers:DatabaseScheduler"
# Fixed jobs (the database scheduler loads them at start). Times are UTC (IST = UTC + 5:30).
CELERY_BEAT_SCHEDULE = {
    # 07:00 IST: reminders and expiry SMS go out in the morning, not at night (§10.5)
    "kyc-document-expiry": {
        "task": "kyc.check_document_expiry",
        "schedule": crontab(hour=1, minute=30),
    },
    # 02:15 IST: "delete my account" requests whose waiting time is over (§12)
    "patients-account-deletions": {
        "task": "patients.process_account_deletions",
        "schedule": crontab(hour=20, minute=45),
    },
    # 03:05 IST: the family's messages older than 30 days (v2.33)
    "notifications-family-inbox": {
        "task": "notifications.delete_old_family_messages",
        "schedule": crontab(hour=21, minute=35),
    },
    # 02:25 IST: the same for partners (§6.20)
    "partners-account-deletions": {
        "task": "partners.process_account_deletions",
        "schedule": crontab(hour=20, minute=55),
    },
    # payments we didn't hear back about (§6.12, §10.5)
    "payments-reconcile": {
        "task": "payments.reconcile",
        "schedule": crontab(minute="*/10"),
    },
    # refunds sent to Razorpay but not reported back
    "payments-refund-status": {
        "task": "payments.refund_status_sweep",
        "schedule": crontab(minute="*/30"),
    },
    # unpaid bookings past their payment time (§6.12, §10.5)
    "bookings-expire-unpaid": {
        "task": "bookings.expire_unpaid",
        "schedule": crontab(minute="*/5"),
    },
    # unassigned past the deadline (6 PM the day before / 3 h before) → red, Super Admins told
    "assignments-escalation": {
        "task": "assignments.escalation_sweep",
        "schedule": crontab(minute="*/5"),
    },
    # T-24 h and T-2 h reminders to the owner, the member (SMS) and the partner
    "bookings-reminders": {
        "task": "bookings.reminder_sweep",
        "schedule": crontab(minute="*"),
    },
    # the numbers behind the CloudWatch alarms (§13): failures, unassigned, SOS waiting
    "monitoring-publish-metrics": {
        "task": "common.publish_metrics",
        "schedule": crontab(minute="*"),
    },
    # an SOS nobody acknowledged within 2 minutes → Super Admins' email + support phone SMS
    "safety-sos-unacknowledged": {
        "task": "safety.escalate_unacknowledged_sos",
        "schedule": crontab(minute="*"),
    },
    # a job in progress with no location for 2 minutes → admin alert
    "tracking-no-location": {
        "task": "tracking.no_location_watch",
        "schedule": crontab(minute="*"),
    },
    # last step done an hour ago, not completed → admin alert
    "bookings-not-completed": {
        "task": "bookings.not_completed_sweep",
        "schedule": crontab(minute="*/10"),
    },
    # temporary partners: access ends 1 h after their one job (§6.19)
    "partners-end-temporary": {
        "task": "partners.end_temporary_sweep",
        "schedule": crontab(minute="*/5"),
    },
    # accepted, but not on the way 30 minutes after pickup → admin alert (PHASES 9.11)
    "bookings-not-started": {
        "task": "bookings.not_started_sweep",
        "schedule": crontab(minute="*/10"),
    },
    # 02:45 IST: login session rows revoked or expired a month ago (PHASES 9.11)
    "accounts-delete-old-sessions": {
        "task": "accounts.delete_old_sessions",
        "schedule": crontab(hour=21, minute=15),
    },
    # 02:00 IST, a quiet hour
    "files-cleanup-unattached": {
        "task": "files.cleanup_unattached",
        "schedule": crontab(hour=20, minute=30),
    },
}

# --- API ---
API_DOCS_ENABLED = env.bool("API_DOCS_ENABLED", default=False)
ENABLE_DJANGO_ADMIN = env.bool("ENABLE_DJANGO_ADMIN", default=False)
API_PAGE_SIZE_DEFAULT = 20
API_PAGE_SIZE_MAX = 100

# --- Client IP: only trust X-Forwarded-For behind our own proxy (Nginx in staging/prod) ---
TRUST_X_FORWARDED_FOR = env.bool("TRUST_X_FORWARDED_FOR", default=False)
# How many of our own proxies append to X-Forwarded-For (Nginx = 1; ALB + Nginx = 2).
TRUSTED_PROXY_HOPS = env.int("TRUSTED_PROXY_HOPS", default=1)

# --- Tokens and sessions (ARCHITECTURE §6.4) ---
JWT_SIGNING_KEY = env("JWT_SIGNING_KEY", default="") or SECRET_KEY
JWT_ISSUER = "wellwish"
ACCESS_TOKEN_TTL_SECONDS = 15 * 60
REFRESH_TOKEN_TTL_DAYS = 30
# A spent refresh token used again within this many seconds is a retry (lost answer, two tabs),
# not theft. Later reuse revokes the whole session.
REFRESH_REUSE_GRACE_SECONDS = 30
STAFF_SESSION_HOURS = 12
STAFF_IDLE_MINUTES = 30
STAFF_REFRESH_COOKIE = "ww_staff_refresh"
STAFF_REFRESH_COOKIE_PATH = "/v1/admin/auth"
STAFF_COOKIE_SECURE = env.bool("STAFF_COOKIE_SECURE", default=True)
STAFF_LOGIN_MAX_FAILURES = 5  # wrong passwords per email per 15 min
STAFF_TOTP_MAX_FAILURES = 5  # wrong codes per login attempt
# "Trust this browser" (§6.4, v2.16): the password alone signs in there for 30 days
STAFF_TRUST_COOKIE = "ww_staff_trust"
STAFF_TRUST_DAYS = 30
# Fernet key for staff TOTP secrets and the Razorpay keys entered in the admin panel.
# Empty = derived from SECRET_KEY (dev only; prod requires it).
FIELD_ENCRYPTION_KEY = env("FIELD_ENCRYPTION_KEY", default="")

# --- Razorpay (ARCHITECTURE §6.12). Normally entered in the admin panel (Settings → Payments,
# kept encrypted); these are only used when nothing was entered there. ---
RAZORPAY_KEY_ID = env("RAZORPAY_KEY_ID", default="")
RAZORPAY_KEY_SECRET = env("RAZORPAY_KEY_SECRET", default="")
RAZORPAY_WEBHOOK_SECRET = env("RAZORPAY_WEBHOOK_SECRET", default="")

# --- Phone OTP (ARCHITECTURE §6.2). Only an HMAC of the code is stored, never the code. ---
OTP_HMAC_KEY = env("OTP_HMAC_KEY", default="") or SECRET_KEY
OTP_LENGTH = 6
OTP_TTL_SECONDS = 5 * 60
OTP_MAX_ATTEMPTS = 5
OTP_RESEND_WAITS_SECONDS = [30, 60, 120]  # wait before the 2nd, 3rd, 4th+ send
OTP_LIMIT_PER_PHONE_HOUR = 5
OTP_LIMIT_PER_PHONE_DAY = 10
OTP_LIMIT_PER_IP_HOUR = 20
OTP_LIMIT_PER_DEVICE_HOUR = 10
OTP_LOCK_FAILURES = 10  # wrong codes for one phone within an hour …
OTP_LOCK_SECONDS = 60 * 60  # … lock that phone for an hour
# Numbers that accept OTP_TEST_CODE without an SMS. Dev/staging: the seeded test numbers.
# Production: at most ONE store-review number, logged on every use (checked in prod.py).
OTP_TEST_NUMBERS = [n for n in env.list("OTP_TEST_NUMBERS", default=[]) if n]
OTP_TEST_CODE = env("OTP_TEST_CODE", default="123456")

# --- SMS (ARCHITECTURE §3.2). Dev: console outbox. Staging/prod: MSG91 with DLT templates. ---
SMS_BACKEND = env("SMS_BACKEND", default="common.sms.ConsoleSMSBackend")
MSG91_AUTH_KEY = env("MSG91_AUTH_KEY", default="")
MSG91_FLOW_URL = env("MSG91_FLOW_URL", default="https://control.msg91.com/api/v5/flow")
MSG91_TEMPLATES = {
    # template code → MSG91 template id (registered on DLT)
    "LOGIN_OTP": env("MSG91_TEMPLATE_LOGIN_OTP", default=""),
    "PARTNER_ADDED": env("MSG91_TEMPLATE_PARTNER_ADDED", default=""),
    "PARTNER_APPROVED": env("MSG91_TEMPLATE_PARTNER_APPROVED", default=""),
    "PARTNER_CHANGES_REQUESTED": env("MSG91_TEMPLATE_PARTNER_CHANGES_REQUESTED", default=""),
    "PARTNER_SUSPENDED": env("MSG91_TEMPLATE_PARTNER_SUSPENDED", default=""),
    "PARTNER_REINSTATED": env("MSG91_TEMPLATE_PARTNER_REINSTATED", default=""),
    "DOCUMENT_EXPIRED": env("MSG91_TEMPLATE_DOCUMENT_EXPIRED", default=""),
    "BOOKING_CONFIRMED": env("MSG91_TEMPLATE_BOOKING_CONFIRMED", default=""),
    "BOOKING_CANCELLED": env("MSG91_TEMPLATE_BOOKING_CANCELLED", default=""),
    "BOOKING_RESCHEDULED": env("MSG91_TEMPLATE_BOOKING_RESCHEDULED", default=""),
    "BOOKING_ASSIGNED": env("MSG91_TEMPLATE_BOOKING_ASSIGNED", default=""),
    "BOOKING_REMINDER": env("MSG91_TEMPLATE_BOOKING_REMINDER", default=""),
    "OFFER_NEW": env("MSG91_TEMPLATE_OFFER_NEW", default=""),
    "OFFER_TIME_CHANGED": env("MSG91_TEMPLATE_OFFER_TIME_CHANGED", default=""),
    "JOB_CANCELLED": env("MSG91_TEMPLATE_JOB_CANCELLED", default=""),
    "JOB_OTP": env("MSG91_TEMPLATE_JOB_OTP", default=""),
    "SOS_ALERT": env("MSG91_TEMPLATE_SOS_ALERT", default=""),
    "SOS_UNACKED": env("MSG91_TEMPLATE_SOS_UNACKED", default=""),
    "TEMP_PARTNER_JOB": env("MSG91_TEMPLATE_TEMP_PARTNER_JOB", default=""),
}

# "On the way" is taken from this many hours before the pickup time (§6.11, developer decision
# 10 Oct 2026: earlier taps would stop the family cancelling or moving the booking).
JOB_START_BEFORE_HOURS = env.int("JOB_START_BEFORE_HOURS", default=2)

# Public pages served by the API (§6.20): /legal/… and /delete-account. Empty = the address
# the request came in on (dev, the emulator's 10.0.2.2); set it on servers (the store listings
# link to these pages).
PUBLIC_SITE_URL = env("PUBLIC_SITE_URL", default="")

# The trip share link (§6.15): links look like {SHARE_LINK_BASE_URL}/t/#<token>.
SHARE_LINK_BASE_URL = env("SHARE_LINK_BASE_URL", default="http://localhost:8000")

# --- Email (ARCHITECTURE §3.2). Dev: console outbox. Staging/prod: AWS SES. ---
MAIL_BACKEND = env("MAIL_BACKEND", default="common.mail.ConsoleMailBackend")
MAIL_FROM = env("MAIL_FROM", default="WellWish <no-reply@wellwish.in>")
MAIL_SES_REGION = env("MAIL_SES_REGION", default="ap-south-1")

# --- Push (FCM HTTP v1). Console until the Firebase project exists (KEYS-AND-ACCOUNTS.md). ---
PUSH_BACKEND = env("PUSH_BACKEND", default="common.push.ConsolePushBackend")
FCM_PROJECT_ID = env("FCM_PROJECT_ID", default="")
FCM_CREDENTIALS_FILE = env("FCM_CREDENTIALS_FILE", default="")

# Link in the "you were added as a partner" SMS (Play Store page of the partner app)
PARTNER_APP_URL = env(
    "PARTNER_APP_URL", default="https://play.google.com/store/apps/details?id=in.wellwish.partner"
)

# --- Google sign-in (patient app). OAuth client ids whose ID tokens we accept. ---
GOOGLE_CLIENT_IDS = [c for c in env.list("GOOGLE_CLIENT_IDS", default=[]) if c]

# --- Consent versions (ARCHITECTURE §12, §6.20). The Terms, Privacy Policy and Partner Terms
# versions come from the published legal pages (admin panel); health data's is this setting.
# Change it to ask every patient again. ---
CONSENT_VERSION_HEALTH_DATA = env("CONSENT_VERSION_HEALTH_DATA", default="2026-10")

# --- App config served to the apps (moves to the app_settings table in Phase 2) ---
APP_MIN_VERSIONS = {
    "patient_android": env("APP_MIN_VERSION_PATIENT_ANDROID", default="0.1.0"),
    "patient_ios": env("APP_MIN_VERSION_PATIENT_IOS", default="0.1.0"),
    "partner_android": env("APP_MIN_VERSION_PARTNER_ANDROID", default="0.1.0"),
}
APP_STORE_URLS = {
    "patient_android": "https://play.google.com/store/apps/details?id=in.wellwish.patient",
    "patient_ios": "https://apps.apple.com/in/app/wellwish/id0000000000",
    "partner_android": "https://play.google.com/store/apps/details?id=in.wellwish.partner",
}
SUPPORT_PHONE = env("SUPPORT_PHONE", default="+919000000000")
REFUND_PERCENT_ON_PATIENT_CANCEL = 50

# --- Logging (never log OTPs, tokens, full phone numbers or medical text — CLAUDE.md) ---
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "plain": {"format": "%(asctime)s %(levelname)s %(name)s %(message)s"},
    },
    # §12 Logs (Phase 9.3): phones, tokens, codes and Aadhaar numbers are masked on the way out
    "filters": {
        "redact": {"()": "common.redact.RedactFilter"},
        "no_query": {"()": "common.redact.AccessLogFilter"},
    },
    "handlers": {
        "console": {"class": "logging.StreamHandler", "formatter": "plain", "filters": ["redact"]},
        "access": {
            "class": "logging.StreamHandler",
            "formatter": "plain",
            "filters": ["no_query", "redact"],
        },
    },
    "root": {"handlers": ["console"], "level": "INFO"},
    "loggers": {
        "django.db.backends": {"level": "WARNING"},
        # the web server's own lines, without query strings (an admin's phone search)
        "uvicorn.access": {"handlers": ["access"], "level": "INFO", "propagate": False},
        "uvicorn.error": {"handlers": ["console"], "level": "INFO", "propagate": False},
    },
}

# --- Monitoring ---
# CloudWatch metrics for the alarms (§13, common/metrics.py): sent only when the namespace is
# set (servers, e.g. "WellWish/production"), with the server's IAM role.
CLOUDWATCH_NAMESPACE = env("CLOUDWATCH_NAMESPACE", default="")
CLOUDWATCH_REGION = env("CLOUDWATCH_REGION", default="ap-south-1")

SENTRY_DSN = env("SENTRY_DSN", default="")
if SENTRY_DSN:
    from common.monitoring import init_sentry  # no request bodies, variables or headers

    init_sentry(SENTRY_DSN, APP_ENV)
