"""Settings shared by the real servers (staging and production): TLS behind Nginx, real SMS,
separate keys. Not used directly: staging.py and prod.py import it."""

from django.core.exceptions import ImproperlyConfigured

from .base import *  # noqa: F403
from .base import SECRET_KEY, env

DEBUG = False
ENABLE_DJANGO_ADMIN = False

SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
STAFF_COOKIE_SECURE = True
TRUST_X_FORWARDED_FOR = env.bool("TRUST_X_FORWARDED_FOR", default=True)

# Real SMS through MSG91 (DLT templates). The console backend keeps codes in Redis: dev only.
SMS_BACKEND = env("SMS_BACKEND", default="common.sms.MSG91SMSBackend")
if SMS_BACKEND.endswith("ConsoleSMSBackend"):
    raise ImproperlyConfigured("The console SMS backend is for local development only.")

# Real email through SES. The console backend is for local development only.
MAIL_BACKEND = env("MAIL_BACKEND", default="common.mail.SESMailBackend")
if MAIL_BACKEND.endswith("ConsoleMailBackend"):
    raise ImproperlyConfigured("The console mail backend is for local development only.")
PUSH_BACKEND = env("PUSH_BACKEND", default="common.push.FCMPushBackend")

# Separate keys for tokens, OTP hashes and encrypted fields (never the Django secret key)
JWT_SIGNING_KEY = env("JWT_SIGNING_KEY")
OTP_HMAC_KEY = env("OTP_HMAC_KEY")
FIELD_ENCRYPTION_KEY = env("FIELD_ENCRYPTION_KEY")
if SECRET_KEY in (JWT_SIGNING_KEY, OTP_HMAC_KEY):
    raise ImproperlyConfigured("JWT_SIGNING_KEY and OTP_HMAC_KEY must differ from the secret key.")

# Uploads go to the private S3 bucket (Mumbai), never to the server's disk.
FILE_STORAGE = env("FILE_STORAGE", default="s3")
FILE_S3_BUCKET = env("FILE_S3_BUCKET")

# §6.20: the legal pages and the account deletion page (the store listings link to them). Required:
# behind the admin panel's proxy the request's own address would be the admin domain.
PUBLIC_SITE_URL = env("PUBLIC_SITE_URL")
