"""Admin: the staff users page (/v1/admin/staff-users, §9.1). Needs staff.manage (Super Admin).

Every admin signs in with their own email, password and authenticator; a Super Admin adds
them and picks a role. Staff are disabled, never deleted (the audit log points to them).
"""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.staff import selectors, services
from apps.staff.models import StaffUser
from apps.staff.schemas import (
    ForceLogoutOut,
    StaffPasswordIn,
    StaffRoleOut,
    StaffUserCreateIn,
    StaffUserOut,
    StaffUserUpdateIn,
)
from apps.staff.selectors import acting_staff
from common.auth import get_principal, staff_permission
from common.request import client_ip
from common.schemas import OkOut

router = Router(tags=["admin"])


def staff_user_out(staff: StaffUser, me: str) -> StaffUserOut:
    return StaffUserOut(
        id=str(staff.pk),
        name=staff.name,
        email=staff.email,
        role=StaffRoleOut(code=staff.role.code, name=staff.role.name),
        status=staff.status,  # type: ignore[arg-type]
        two_factor_set=staff.totp_confirmed_at is not None,
        last_login_at=staff.last_login_at,
        created_at=staff.created_at,
        active_sessions=getattr(staff, "active_sessions", 0),
        is_you=str(staff.pk) == me,
    )


def _fresh(request: HttpRequest, staff_id: str) -> StaffUserOut:
    return staff_user_out(selectors.get_staff_user(staff_id), get_principal(request).subject_id)


@router.get(
    "/staff-users", response=list[StaffUserOut], by_alias=True, operation_id="adminStaffUsersList"
)
@staff_permission("staff.manage")
def list_staff_users(request: HttpRequest) -> list[StaffUserOut]:
    me = get_principal(request).subject_id
    return [staff_user_out(s, me) for s in selectors.staff_users()]


@router.post(
    "/staff-users", response=StaffUserOut, by_alias=True, operation_id="adminStaffUsersCreate"
)
@staff_permission("staff.manage")
def create_staff_user(request: HttpRequest, data: StaffUserCreateIn) -> StaffUserOut:
    """They set up the authenticator at their first sign-in."""
    staff = services.create_staff_user(
        name=data.name,
        email=data.email,
        password=data.password,
        role_code=data.role,
        actor=acting_staff(request),
        ip=client_ip(request),
    )
    return _fresh(request, str(staff.pk))


@router.put(
    "/staff-users/{uuid:staff_id}",
    response=StaffUserOut,
    by_alias=True,
    operation_id="adminStaffUsersUpdate",
)
@staff_permission("staff.manage")
def update_staff_user(
    request: HttpRequest, staff_id: UUID, data: StaffUserUpdateIn
) -> StaffUserOut:
    """Name and role. You can't change your own role; one active Super Admin must remain."""
    services.update_staff_user(
        actor=acting_staff(request),
        staff_id=str(staff_id),
        name=data.name,
        role_code=data.role,
        ip=client_ip(request),
    )
    return _fresh(request, str(staff_id))


@router.post(
    "/staff-users/{uuid:staff_id}/disable",
    response=StaffUserOut,
    by_alias=True,
    operation_id="adminStaffUsersDisable",
)
@staff_permission("staff.manage")
def disable_staff_user(request: HttpRequest, staff_id: UUID) -> StaffUserOut:
    """Signs them out at once. Not yourself, and not the last Super Admin."""
    services.set_staff_active(
        actor=acting_staff(request), staff_id=str(staff_id), active=False, ip=client_ip(request)
    )
    return _fresh(request, str(staff_id))


@router.post(
    "/staff-users/{uuid:staff_id}/enable",
    response=StaffUserOut,
    by_alias=True,
    operation_id="adminStaffUsersEnable",
)
@staff_permission("staff.manage")
def enable_staff_user(request: HttpRequest, staff_id: UUID) -> StaffUserOut:
    services.set_staff_active(
        actor=acting_staff(request), staff_id=str(staff_id), active=True, ip=client_ip(request)
    )
    return _fresh(request, str(staff_id))


@router.post(
    "/staff-users/{uuid:staff_id}/reset-2fa",
    response=StaffUserOut,
    by_alias=True,
    operation_id="adminStaffUsersReset2fa",
)
@staff_permission("staff.manage")
def reset_2fa(request: HttpRequest, staff_id: UUID) -> StaffUserOut:
    """Lost phone: they scan a new QR code at the next sign-in. Signs them out."""
    services.reset_staff_2fa(
        actor=acting_staff(request), staff_id=str(staff_id), ip=client_ip(request)
    )
    return _fresh(request, str(staff_id))


@router.post(
    "/staff-users/{uuid:staff_id}/password",
    response=OkOut,
    by_alias=True,
    operation_id="adminStaffUsersSetPassword",
)
@staff_permission("staff.manage")
def set_password(request: HttpRequest, staff_id: UUID, data: StaffPasswordIn) -> OkOut:
    """Forgotten password: set a new one (min 12 characters). Signs them out."""
    services.set_staff_password(
        actor=acting_staff(request),
        staff_id=str(staff_id),
        password=data.password,
        ip=client_ip(request),
    )
    return OkOut()


@router.post(
    "/staff-users/{uuid:staff_id}/logout",
    response=ForceLogoutOut,
    by_alias=True,
    operation_id="adminStaffUsersForceLogout",
)
@staff_permission("staff.manage")
def force_logout(request: HttpRequest, staff_id: UUID) -> ForceLogoutOut:
    """Sign them out on every device."""
    ended = services.force_logout(
        actor=acting_staff(request), staff_id=str(staff_id), ip=client_ip(request)
    )
    return ForceLogoutOut(sessions_ended=ended)
