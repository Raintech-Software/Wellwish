"""Super Admins get `legal.manage` (Settings → Legal pages, ARCHITECTURE §6.20, Phase 9B)."""

from django.db import migrations

PERMISSION = "legal.manage"


def grant(apps, schema_editor):
    StaffRole = apps.get_model("staff", "StaffRole")
    StaffRolePermission = apps.get_model("staff", "StaffRolePermission")
    for role in StaffRole.objects.filter(code="SUPER_ADMIN"):
        StaffRolePermission.objects.get_or_create(role=role, permission=PERMISSION)


def revoke(apps, schema_editor):
    apps.get_model("staff", "StaffRolePermission").objects.filter(permission=PERMISSION).delete()


class Migration(migrations.Migration):
    dependencies = [("staff", "0004_recovery_codes_saved")]

    operations = [migrations.RunPython(grant, revoke)]
