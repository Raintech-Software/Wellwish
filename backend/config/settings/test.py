"""Settings for pytest (runs inside the api container, against the real PostgreSQL)."""

from .dev import *  # noqa: F403

# Fast, deterministic tests
PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]
CELERY_TASK_ALWAYS_EAGER = True
CELERY_TASK_EAGER_PROPAGATES = True
CACHES = {"default": {"BACKEND": "django.core.cache.backends.locmem.LocMemCache"}}
CHANNEL_LAYERS = {"default": {"BACKEND": "channels.layers.InMemoryChannelLayer"}}
API_DOCS_ENABLED = True

# Login (fixed values so tests don't depend on backend/.env)
SMS_BACKEND = "common.sms.ConsoleSMSBackend"
OTP_TEST_NUMBERS = ["+919000000001", "+919000000002"]
OTP_TEST_CODE = "123456"
GOOGLE_CLIENT_IDS = ["test-client-id.apps.googleusercontent.com"]
TRUST_X_FORWARDED_FOR = False
# The test bookings are for tomorrow: the visit tests start them now (one test checks the rule)
JOB_START_BEFORE_HOURS = 72
# Tests make many writes quickly: the write limit is off, except in its own test.
WRITE_RATE_LIMIT_PER_MINUTE = 0
WRITE_RATE_LIMIT_PER_IP_MINUTE = 0
