"""Writes for settings, service areas and blocked times. Every change is in the audit log."""

from collections.abc import Callable
from datetime import datetime
from typing import Any

from django.core.cache import cache
from django.db import transaction

from apps.app_config.models import AppSetting, BlockedTime, ServiceArea
from apps.app_config.registry import InvalidSetting, clean
from apps.app_config.selectors import CACHE_KEY, all_settings
from apps.audit.services import record
from apps.staff.models import StaffUser
from common.errors import ApiError, NotFound


class InvalidSettings(ApiError):
    status = 422
    code = "INVALID_SETTINGS"
    message = "Some settings are not valid."


@transaction.atomic
def update_settings(*, actor: StaffUser, values: dict[str, Any], ip: str) -> dict[str, Any]:
    """Validate everything first, then save the changed keys (one audit row for the change)."""
    errors: dict[str, str] = {}
    cleaned: dict[str, Any] = {}
    for key, value in values.items():
        try:
            cleaned[key] = clean(key, value)
        except InvalidSetting as exc:
            errors[key] = str(exc)
    if errors:
        raise InvalidSettings(details={"fields": errors})
    current = all_settings()
    changed = {k: v for k, v in cleaned.items() if current.get(k) != v}
    for key, value in changed.items():
        AppSetting.objects.update_or_create(key=key, defaults={"value": value, "updated_by": actor})
    if changed:
        record(
            actor,
            "settings.updated",
            ("app_config.appsetting", ",".join(sorted(changed))),
            before={k: current.get(k) for k in changed},
            after=changed,
            ip=ip,
        )
        transaction.on_commit(lambda: cache.delete(CACHE_KEY))
    cache.delete(CACHE_KEY)
    return all_settings()


# --- Service areas ---

AREA_FIELDS = ("city", "name", "lat", "lng", "radius_km")


@transaction.atomic
def save_service_area(
    *, actor: StaffUser, data: dict[str, Any], ip: str, area_id: str | None = None
) -> ServiceArea:
    if area_id:
        area = ServiceArea.objects.select_for_update().filter(pk=area_id).first()
        if area is None:
            raise NotFound()
        before = {f: str(getattr(area, f)) for f in AREA_FIELDS}
    else:
        area, before = ServiceArea(), {}
    for field in AREA_FIELDS:
        setattr(area, field, data[field])
    area.save()
    area.refresh_from_db()  # decimals as stored (25 becomes 25.0)
    after = {f: str(getattr(area, f)) for f in AREA_FIELDS}
    changed = [k for k in after if before.get(k) != after[k]]
    if changed:
        record(
            actor,
            "service_area.updated" if area_id else "service_area.created",
            area,
            before={k: before.get(k) for k in changed} if area_id else None,
            after={k: after[k] for k in changed},
            ip=ip,
        )
    return area


@transaction.atomic
def set_service_area_active(
    *, actor: StaffUser, area_id: str, active: bool, ip: str
) -> ServiceArea:
    area = ServiceArea.objects.select_for_update().filter(pk=area_id).first()
    if area is None:
        raise NotFound()
    if area.is_active != active:
        area.is_active = active
        area.save(update_fields=["is_active", "updated_at"])
        record(
            actor,
            "service_area.activated" if active else "service_area.deactivated",
            area,
            before={"is_active": not active},
            after={"is_active": active},
            ip=ip,
        )
    return area


@transaction.atomic
def delete_service_area(*, actor: StaffUser, area_id: str, ip: str) -> None:
    area = ServiceArea.objects.select_for_update().filter(pk=area_id).first()
    if area is None:
        raise NotFound()
    record(
        actor,
        "service_area.deleted",
        ("app_config.servicearea", area_id),
        before={"name": area.name},
        ip=ip,
    )
    area.delete()


# --- Blocked times ---

# (from, to, service type or None) → bookings inside that range. The bookings app (Phase 5)
# plugs its finder in here, so the admin sees which bookings a new block affects.
AffectedFinder = Callable[[datetime, datetime, str | None], list[dict[str, Any]]]
_affected_finders: list[AffectedFinder] = []


def register_affected_bookings_finder(finder: AffectedFinder) -> None:
    if finder not in _affected_finders:
        _affected_finders.append(finder)


def affected_bookings(blocked: BlockedTime) -> list[dict[str, Any]]:
    found: list[dict[str, Any]] = []
    for finder in _affected_finders:
        found.extend(finder(blocked.from_ts, blocked.to_ts, blocked.service_type or None))
    return found


class InvalidBlockedTime(ApiError):
    status = 422
    code = "INVALID_RANGE"
    message = "The end must be after the start."


@transaction.atomic
def save_blocked_time(
    *, actor: StaffUser, data: dict[str, Any], ip: str, blocked_id: str | None = None
) -> BlockedTime:
    if data["to_ts"] <= data["from_ts"]:
        raise InvalidBlockedTime()
    if blocked_id:
        blocked = BlockedTime.objects.select_for_update().filter(pk=blocked_id).first()
        if blocked is None:
            raise NotFound()
    else:
        blocked = BlockedTime(created_by=actor)
    before = (
        {
            "from": blocked.from_ts.isoformat(),
            "to": blocked.to_ts.isoformat(),
            "reason": blocked.reason,
            "service_type": blocked.service_type,
        }
        if blocked_id
        else None
    )
    blocked.from_ts = data["from_ts"]
    blocked.to_ts = data["to_ts"]
    blocked.reason = data["reason"]
    blocked.service_type = data.get("service_type") or ""
    blocked.save()
    record(
        actor,
        "blocked_time.updated" if blocked_id else "blocked_time.created",
        blocked,
        before=before,
        after={
            "from": blocked.from_ts.isoformat(),
            "to": blocked.to_ts.isoformat(),
            "reason": blocked.reason,
            "service_type": blocked.service_type,
        },
        ip=ip,
    )
    return blocked


@transaction.atomic
def delete_blocked_time(*, actor: StaffUser, blocked_id: str, ip: str) -> None:
    blocked = BlockedTime.objects.select_for_update().filter(pk=blocked_id).first()
    if blocked is None:
        raise NotFound()
    record(
        actor,
        "blocked_time.deleted",
        ("app_config.blockedtime", blocked_id),
        before={
            "from": blocked.from_ts.isoformat(),
            "to": blocked.to_ts.isoformat(),
            "reason": blocked.reason,
        },
        ip=ip,
    )
    blocked.delete()
