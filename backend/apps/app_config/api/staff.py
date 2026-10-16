"""Admin: settings, service areas, blocked dates (/v1/admin/...). All need settings.manage."""

from uuid import UUID

from django.http import HttpRequest
from django.utils import timezone
from ninja import Router

from apps.app_config import selectors, services
from apps.app_config.models import BlockedTime, ServiceArea
from apps.app_config.registry import GROUPS, SETTINGS
from apps.app_config.schemas import (
    AffectedBookingOut,
    BlockedTimeIn,
    BlockedTimeOut,
    DevMailOut,
    DevOutboxOut,
    DevSmsOut,
    InsideAreaOut,
    ServiceAreaIn,
    ServiceAreaOut,
    SettingOut,
    SettingsGroupOut,
    SettingsIn,
    SettingsOut,
)
from apps.staff.selectors import acting_staff
from common import mail, sms
from common.auth import staff_permission
from common.errors import NotFound
from common.request import client_ip
from common.schemas import OkOut

router = Router(tags=["admin"])


def _settings_out() -> SettingsOut:
    values = selectors.all_settings()
    return SettingsOut(
        groups=[
            SettingsGroupOut(
                name=group,
                settings=[
                    SettingOut(
                        key=s.key,
                        label=s.label,
                        kind=s.kind,
                        value=str(values[s.key]),
                        default=str(s.default),
                        help=s.help,
                        min=s.min,
                        max=s.max,
                        choices=list(s.choices),
                        unit=s.unit,
                    )
                    for s in SETTINGS
                    if s.group == group
                ],
            )
            for group in GROUPS
        ]
    )


@router.get("/settings", response=SettingsOut, by_alias=True, operation_id="adminSettingsGet")
@staff_permission("settings.manage")
def get_settings(request: HttpRequest) -> SettingsOut:
    return _settings_out()


@router.put("/settings", response=SettingsOut, by_alias=True, operation_id="adminSettingsUpdate")
@staff_permission("settings.manage")
def update_settings(request: HttpRequest, data: SettingsIn) -> SettingsOut:
    """Only the keys sent are changed. 422 INVALID_SETTINGS lists the bad fields."""
    services.update_settings(actor=acting_staff(request), values=data.values, ip=client_ip(request))
    return _settings_out()


# --- Test messages (local development only) ---


@router.get("/dev/outbox", response=DevOutboxOut, by_alias=True, operation_id="adminDevOutbox")
@staff_permission("settings.manage")
def dev_outbox(request: HttpRequest) -> DevOutboxOut:
    """The last 50 SMS (login codes, visit codes, SOS…) and emails of the last hour, newest
    first, as the dev backends kept them: MSG91 and SES aren't used on a developer's PC. 404 on
    any real server (they send for real and keep nothing)."""
    if not sms.uses_dev_outbox():
        raise NotFound()
    return DevOutboxOut(
        sms=[DevSmsOut(**m) for m in sms.read_dev_outbox_all()],
        email=[DevMailOut(**m) for m in mail.read_dev_outbox_all()],
    )


# --- Service areas ---


def area_out(a: ServiceArea) -> ServiceAreaOut:
    return ServiceAreaOut(
        id=str(a.pk),
        city=a.city,
        name=a.name,
        lat=a.lat,
        lng=a.lng,
        radius_km=a.radius_km,
        is_active=a.is_active,
    )


@router.get(
    "/service-areas",
    response=list[ServiceAreaOut],
    by_alias=True,
    operation_id="adminServiceAreasList",
)
@staff_permission("settings.manage")
def list_areas(request: HttpRequest) -> list[ServiceAreaOut]:
    return [area_out(a) for a in selectors.service_areas()]


@router.post(
    "/service-areas", response=ServiceAreaOut, by_alias=True, operation_id="adminServiceAreasCreate"
)
@staff_permission("settings.manage")
def create_area(request: HttpRequest, data: ServiceAreaIn) -> ServiceAreaOut:
    return area_out(
        services.save_service_area(
            actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
        )
    )


@router.put(
    "/service-areas/{uuid:area_id}",
    response=ServiceAreaOut,
    by_alias=True,
    operation_id="adminServiceAreasUpdate",
)
@staff_permission("settings.manage")
def update_area(request: HttpRequest, area_id: UUID, data: ServiceAreaIn) -> ServiceAreaOut:
    return area_out(
        services.save_service_area(
            actor=acting_staff(request),
            data=data.model_dump(),
            ip=client_ip(request),
            area_id=str(area_id),
        )
    )


@router.post(
    "/service-areas/{uuid:area_id}/deactivate",
    response=ServiceAreaOut,
    by_alias=True,
    operation_id="adminServiceAreasDeactivate",
)
@staff_permission("settings.manage")
def deactivate_area(request: HttpRequest, area_id: UUID) -> ServiceAreaOut:
    return area_out(
        services.set_service_area_active(
            actor=acting_staff(request), area_id=str(area_id), active=False, ip=client_ip(request)
        )
    )


@router.post(
    "/service-areas/{uuid:area_id}/activate",
    response=ServiceAreaOut,
    by_alias=True,
    operation_id="adminServiceAreasActivate",
)
@staff_permission("settings.manage")
def activate_area(request: HttpRequest, area_id: UUID) -> ServiceAreaOut:
    return area_out(
        services.set_service_area_active(
            actor=acting_staff(request), area_id=str(area_id), active=True, ip=client_ip(request)
        )
    )


@router.delete(
    "/service-areas/{uuid:area_id}",
    response=OkOut,
    by_alias=True,
    operation_id="adminServiceAreasDelete",
)
@staff_permission("settings.manage")
def delete_area(request: HttpRequest, area_id: UUID) -> OkOut:
    services.delete_service_area(
        actor=acting_staff(request), area_id=str(area_id), ip=client_ip(request)
    )
    return OkOut()


@router.get(
    "/service-areas/check",
    response=InsideAreaOut,
    by_alias=True,
    operation_id="adminServiceAreasCheck",
)
@staff_permission("settings.manage")
def check_point(request: HttpRequest, lat: float, lng: float) -> InsideAreaOut:
    """Is this point inside an active service area? (bookings outside are refused)"""
    return InsideAreaOut(inside=selectors.is_inside_service_area(lat, lng))


# --- Blocked times ---


def blocked_out(b: BlockedTime, *, with_affected: bool = False) -> BlockedTimeOut:
    affected = services.affected_bookings(b) if with_affected else []
    return BlockedTimeOut(
        id=str(b.pk),
        from_ts=b.from_ts,
        to_ts=b.to_ts,
        reason=b.reason,
        service_type=b.service_type or None,
        created_by=b.created_by.name if b.created_by else None,
        affected_bookings=[AffectedBookingOut(**a) for a in affected],
    )


@router.get(
    "/blocked-times",
    response=list[BlockedTimeOut],
    by_alias=True,
    operation_id="adminBlockedTimesList",
)
@staff_permission("settings.manage")
def list_blocked(request: HttpRequest, upcoming: bool = False) -> list[BlockedTimeOut]:
    return [
        blocked_out(b) for b in selectors.blocked_times(upcoming_only=upcoming, now=timezone.now())
    ]


@router.post(
    "/blocked-times", response=BlockedTimeOut, by_alias=True, operation_id="adminBlockedTimesCreate"
)
@staff_permission("settings.manage")
def create_blocked(request: HttpRequest, data: BlockedTimeIn) -> BlockedTimeOut:
    """The answer lists the existing bookings inside the range, so the admin can move them."""
    blocked = services.save_blocked_time(
        actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
    )
    return blocked_out(blocked, with_affected=True)


@router.put(
    "/blocked-times/{uuid:blocked_id}",
    response=BlockedTimeOut,
    by_alias=True,
    operation_id="adminBlockedTimesUpdate",
)
@staff_permission("settings.manage")
def update_blocked(request: HttpRequest, blocked_id: UUID, data: BlockedTimeIn) -> BlockedTimeOut:
    blocked = services.save_blocked_time(
        actor=acting_staff(request),
        data=data.model_dump(),
        ip=client_ip(request),
        blocked_id=str(blocked_id),
    )
    return blocked_out(blocked, with_affected=True)


@router.delete(
    "/blocked-times/{uuid:blocked_id}",
    response=OkOut,
    by_alias=True,
    operation_id="adminBlockedTimesDelete",
)
@staff_permission("settings.manage")
def delete_blocked(request: HttpRequest, blocked_id: UUID) -> OkOut:
    services.delete_blocked_time(
        actor=acting_staff(request), blocked_id=str(blocked_id), ip=client_ip(request)
    )
    return OkOut()
