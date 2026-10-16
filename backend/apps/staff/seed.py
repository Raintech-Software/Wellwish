"""Dev seed: one Super Admin from DEV_ADMIN_EMAIL / DEV_ADMIN_PASSWORD (backend/.env).

The 2FA app is set up on the first sign-in (QR code). Never runs in production.
"""

import os

from apps.staff.models import StaffUser
from apps.staff.services import create_staff_user


def seed_dev_admin() -> None:
    email = os.environ.get("DEV_ADMIN_EMAIL", "").strip().lower()
    password = os.environ.get("DEV_ADMIN_PASSWORD", "")
    if not email or not password:
        print("  DEV_ADMIN_EMAIL / DEV_ADMIN_PASSWORD not set: no dev admin created")
        return
    if StaffUser.objects.filter(email=email).exists():
        return
    create_staff_user(
        name="Dev Super Admin",
        email=email,
        password=password,
        role_code="SUPER_ADMIN",
        actor=None,
        ip=None,
    )
