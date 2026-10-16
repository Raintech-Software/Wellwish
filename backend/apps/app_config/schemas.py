"""Schemas for app settings, service areas and blocked times."""

from datetime import datetime
from decimal import Decimal
from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, Latitude, Longitude, RadiusKm, StrictIn


class AppVersionsOut(CamelSchema):
    patient_android: str
    patient_ios: str
    partner_android: str


class LegalUrlsOut(CamelSchema):
    """Public pages (§6.20), opened in the browser in the app's language (`?l=hi|or`)."""

    terms: str
    privacy: str
    refunds: str
    partner_terms: str
    delete_account: str


class AppConfigOut(CamelSchema):
    min_versions: AppVersionsOut = Field(
        ..., description="An app older than this shows the force-update screen"
    )
    store_urls: AppVersionsOut
    support_phone: str
    refund_percent: int
    account_deletion_days: int = Field(
        ..., description="Days before a 'delete my account' request is carried out"
    )
    legal_urls: LegalUrlsOut


# --- Admin settings page ---


class SettingOut(CamelSchema):
    key: str
    label: str
    kind: str = Field(..., description="int · choice · time · phone · version")
    value: str = Field(..., description="Always text; kind says how to read it")
    default: str
    help: str
    min: int | None = None
    max: int | None = None
    choices: list[str]
    unit: str


class SettingsGroupOut(CamelSchema):
    name: str
    settings: list[SettingOut]


class SettingsOut(CamelSchema):
    groups: list[SettingsGroupOut]


class SettingsIn(StrictIn):
    values: dict[str, str] = Field(..., description="Only the keys to change, as text")


# --- Service areas ---


class ServiceAreaIn(StrictIn):
    city: str = Field(..., min_length=2, max_length=60)
    name: str = Field(..., min_length=2, max_length=80)
    lat: Latitude
    lng: Longitude
    radius_km: RadiusKm


class ServiceAreaOut(CamelSchema):
    id: str
    city: str
    name: str
    lat: Decimal
    lng: Decimal
    radius_km: Decimal
    is_active: bool


class InsideAreaOut(CamelSchema):
    inside: bool


# --- Test messages (local development only) ---


class DevSmsOut(CamelSchema):
    at: datetime
    phone: str
    template: str = Field(..., description="e.g. LOGIN_OTP, JOB_OTP, SOS_ALERT")
    text: str


class DevMailOut(CamelSchema):
    at: datetime
    to: str
    subject: str
    text: str


class DevOutboxOut(CamelSchema):
    """What the dev SMS and email backends 'sent' (nothing leaves the PC in development)."""

    sms: list[DevSmsOut]
    email: list[DevMailOut]


# --- Blocked times ---


class BlockedTimeIn(StrictIn):
    from_ts: datetime
    to_ts: datetime
    reason: str = Field(..., min_length=2, max_length=200)
    service_type: Literal["COMPANION", "NURSE"] | None = Field(
        None, description="Empty = all services"
    )


class AffectedBookingOut(CamelSchema):
    id: str
    code: str
    pickup_at: datetime
    status: str


class BlockedTimeOut(CamelSchema):
    id: str
    from_ts: datetime
    to_ts: datetime
    reason: str
    service_type: str | None
    created_by: str | None = Field(None, description="Staff name")
    affected_bookings: list[AffectedBookingOut] = Field(
        default_factory=list, description="Bookings inside this range (from Phase 5)"
    )
