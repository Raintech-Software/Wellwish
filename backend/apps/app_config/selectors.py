"""Reading settings, service areas and blocked times."""

from dataclasses import dataclass
from datetime import datetime
from typing import Any

from django.conf import settings
from django.core.cache import cache
from django.db.models import Q, QuerySet

from apps.app_config.models import AppSetting, BlockedTime, ServiceArea
from apps.app_config.registry import BY_KEY, SETTINGS
from common.errors import NotFound
from common.geo import haversine_km

CACHE_KEY = "app_settings:v1"
CACHE_SECONDS = 60


def all_settings() -> dict[str, Any]:
    """Every setting's current value (saved value or default). Cached for a minute."""
    values = cache.get(CACHE_KEY)
    if values is None:
        saved = dict(AppSetting.objects.values_list("key", "value"))
        values = {s.key: saved.get(s.key, s.default) for s in SETTINGS}
        cache.set(CACHE_KEY, values, CACHE_SECONDS)
    return dict(values)


def get_setting(key: str) -> Any:
    if key not in BY_KEY:
        raise KeyError(key)
    return all_settings()[key]


@dataclass(frozen=True)
class AppConfigValues:
    min_versions: dict[str, str]
    store_urls: dict[str, str]
    support_phone: str
    refund_percent: int
    account_deletion_days: int


def get_app_config() -> AppConfigValues:
    values = all_settings()
    return AppConfigValues(
        min_versions={
            "patient_android": values["min_version_patient_android"],
            "patient_ios": values["min_version_patient_ios"],
            "partner_android": values["min_version_partner_android"],
        },
        store_urls=dict(settings.APP_STORE_URLS),
        support_phone=values["support_phone"],
        refund_percent=values["refund_percent"],
        account_deletion_days=values["account_deletion_days"],
    )


# --- Service areas ---


def service_areas() -> QuerySet[ServiceArea]:
    return ServiceArea.objects.order_by("city", "name")


def get_service_area(area_id: str) -> ServiceArea:
    area = ServiceArea.objects.filter(pk=area_id).first()
    if area is None:
        raise NotFound()
    return area


def is_inside_service_area(lat: float, lng: float) -> bool:
    """True if the point is within an active service area (bookings are refused outside)."""
    return any(
        haversine_km(float(a.lat), float(a.lng), lat, lng) <= float(a.radius_km)
        for a in ServiceArea.objects.filter(is_active=True)
    )


# --- Blocked times ---


def blocked_times(
    *, upcoming_only: bool = False, now: datetime | None = None
) -> QuerySet[BlockedTime]:
    qs = BlockedTime.objects.select_related("created_by").order_by("from_ts")
    if upcoming_only and now is not None:
        qs = qs.filter(to_ts__gt=now)
    return qs


def get_blocked_time(blocked_id: str) -> BlockedTime:
    blocked = BlockedTime.objects.filter(pk=blocked_id).first()
    if blocked is None:
        raise NotFound()
    return blocked


def is_blocked(at: datetime, service_type: str | None = None) -> bool:
    """For booking times (Phase 5): is `at` inside a block for all services or this type?"""
    return BlockedTime.objects.filter(
        Q(service_type="") | Q(service_type=service_type or ""),
        from_ts__lte=at,
        to_ts__gt=at,
    ).exists()
