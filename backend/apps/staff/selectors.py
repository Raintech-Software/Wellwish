"""Read queries for staff."""

from django.db.models import Count, Q, QuerySet
from django.http import HttpRequest
from django.utils import timezone

from apps.staff.models import StaffRecoveryCode, StaffRole, StaffRolePermission, StaffUser
from common.auth import get_principal
from common.errors import NotFound


def permissions_for(staff_id: str) -> frozenset[str]:
    return frozenset(
        StaffRolePermission.objects.filter(
            role__users__pk=staff_id, role__users__status=StaffUser.Status.ACTIVE
        ).values_list("permission", flat=True)
    )


def get_staff(staff_id: str) -> StaffUser:
    return StaffUser.objects.select_related("role").get(pk=staff_id)


def recovery_codes_left(staff_id: str) -> int:
    """Unused recovery codes (§6.4, v2.16): the panel asks for new ones at 0."""
    return StaffRecoveryCode.objects.filter(staff__pk=staff_id, used_at__isnull=True).count()


def super_admin_emails() -> list[str]:
    """Where urgent emails go (an SOS not acknowledged, a booking past its deadline)."""
    return list(
        StaffUser.objects.filter(
            role__code="SUPER_ADMIN", status=StaffUser.Status.ACTIVE
        ).values_list("email", flat=True)
    )


def only_super_admin(staff: StaffUser) -> bool:
    """True for a Super Admin who is the only active one: nobody could reset their 2FA."""
    if staff.role.code != "SUPER_ADMIN" or staff.status != StaffUser.Status.ACTIVE:
        return False
    return not (
        StaffUser.objects.filter(role__code="SUPER_ADMIN", status=StaffUser.Status.ACTIVE)
        .exclude(pk=staff.pk)
        .exists()
    )


def roles_with_permissions() -> list[tuple[StaffRole, list[str], int]]:
    roles = StaffRole.objects.annotate(
        user_count=Count("users", filter=Q(users__status=StaffUser.Status.ACTIVE))
    ).order_by("created_at", "code")
    perms: dict[str, list[str]] = {}
    for role_id, permission in StaffRolePermission.objects.values_list("role_id", "permission"):
        perms.setdefault(str(role_id), []).append(permission)
    return [(role, sorted(perms.get(str(role.pk), [])), role.user_count) for role in roles]


def acting_staff(request: HttpRequest) -> StaffUser:
    """The signed-in staff member making this admin request (for audit records)."""
    return get_staff(get_principal(request).subject_id)


def staff_users() -> QuerySet[StaffUser]:
    """Everyone, active first, with how many sessions are open now (`active_sessions`)."""
    now = timezone.now()
    return (
        StaffUser.objects.select_related("role")
        .annotate(
            active_sessions=Count(
                "sessions",
                filter=Q(
                    sessions__revoked_at__isnull=True,
                    sessions__rotated_at__isnull=True,
                    sessions__expires_at__gt=now,
                ),
            )
        )
        .order_by("status", "name")
    )


def get_staff_user(staff_id: str) -> StaffUser:
    staff = staff_users().filter(pk=staff_id).first()
    if staff is None:
        raise NotFound()
    return staff
