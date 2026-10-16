"""Production. Behind Nginx with TLS (ARCHITECTURE §3.2, §12)."""

from django.core.exceptions import ImproperlyConfigured

from .deployed import *  # noqa: F403
from .deployed import OTP_TEST_CODE, OTP_TEST_NUMBERS, env

API_DOCS_ENABLED = env.bool("API_DOCS_ENABLED", default=False)

# Production allows only one store-review test number, with its own code (ARCHITECTURE §6.2).
if len(OTP_TEST_NUMBERS) > 1:
    raise ImproperlyConfigured("Production allows at most one OTP test number (store review).")
if OTP_TEST_NUMBERS and OTP_TEST_CODE == "123456":
    raise ImproperlyConfigured("Set a private OTP_TEST_CODE for the store-review number.")
