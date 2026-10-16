"""Seed the five admin roles and their permissions (ARCHITECTURE §9.2).

A data migration (not dev seed data) because production needs the roles too. The table is a
copy of apps/staff/permissions.py at the time of writing: migrations must not change later.
"""

from django.db import migrations

ROLES = {
    "SUPER_ADMIN": "Super Admin",
    "OPERATIONS": "Operations",
    "VERIFICATION": "Verification",
    "FINANCE": "Finance",
    "SUPPORT": "Support",
}

ALL = [
    "dashboard.view", "bookings.view", "bookings.manage", "live.view", "live.manage",
    "partners.view", "partners.review", "partners.add", "partners.suspend",
    "services.view", "services.manage", "directory.view", "directory.manage",
    "patients.view", "patients.manage", "patients.documents", "payments.view",
    "refunds.request", "refunds.approve", "support.manage", "settings.manage",
    "staff.manage", "audit.view",
]

ROLE_PERMISSIONS = {
    "SUPER_ADMIN": ALL,
    "OPERATIONS": [
        "dashboard.view", "bookings.view", "bookings.manage", "live.view", "live.manage",
        "partners.view", "partners.add", "partners.suspend", "services.view",
        "directory.view", "directory.manage", "patients.view", "patients.documents",
        "refunds.request", "support.manage",
    ],
    "VERIFICATION": [
        "dashboard.view", "partners.view", "partners.review", "partners.add", "partners.suspend",
    ],
    "FINANCE": [
        "dashboard.view", "services.view", "services.manage", "patients.view", "payments.view",
        "refunds.request", "refunds.approve",
    ],
    "SUPPORT": [
        "dashboard.view", "bookings.view", "live.view", "services.view", "directory.view",
        "patients.view", "refunds.request", "support.manage",
    ],
}


def seed(apps, schema_editor):
    StaffRole = apps.get_model("staff", "StaffRole")
    StaffRolePermission = apps.get_model("staff", "StaffRolePermission")
    for code, name in ROLES.items():
        role, _ = StaffRole.objects.get_or_create(code=code, defaults={"name": name})
        for permission in ROLE_PERMISSIONS[code]:
            StaffRolePermission.objects.get_or_create(role=role, permission=permission)


def unseed(apps, schema_editor):
    apps.get_model("staff", "StaffRole").objects.filter(code__in=ROLES, users__isnull=True).delete()


class Migration(migrations.Migration):
    dependencies = [("staff", "0001_initial")]

    operations = [migrations.RunPython(seed, unseed)]
