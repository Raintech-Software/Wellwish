"""Local development (docker compose on the developer's PC)."""

from .base import *  # noqa: F403
from .base import env

DEBUG = True
# The Android emulator calls the API as 10.0.2.2, a real phone uses the PC's LAN IP.
ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=["*"])
API_DOCS_ENABLED = env.bool("API_DOCS_ENABLED", default=True)
ENABLE_DJANGO_ADMIN = env.bool("ENABLE_DJANGO_ADMIN", default=True)

# The admin panel runs on http://localhost:3000, so its refresh cookie can't be Secure-only.
STAFF_COOKIE_SECURE = env.bool("STAFF_COOKIE_SECURE", default=False)
