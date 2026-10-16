"""Read queries for partners, always filtered by the caller."""

import datetime as dt
from dataclasses import dataclass
from datetime import date
from typing import Any
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db.models import Exists, F, OuterRef, Q, QuerySet

from apps.partners.models import (
    PartnerDeletion,
    PartnerPhone,
    PartnerProfile,
    SelfieCheck,
    TemporaryIdCheck,
)
from common.dates import today_ist
from common.errors import NotFound
from common.ids import uid


def is_available_today(partner: PartnerProfile) -> bool:
    """ "Available today" is switched on for today's India date only: it resets every day."""
    return partner.available_today and partner.available_on == today_ist()


def _ist_day(day: date) -> tuple[dt.datetime, dt.datetime]:
    start = dt.datetime.combine(day, dt.time(0, 0), tzinfo=ZoneInfo(settings.DISPLAY_TIME_ZONE))
    return start, start + dt.timedelta(days=1)


def selfie_today(partner_id: str) -> SelfieCheck | None:
    """Today's selfie (India date), if taken."""
    start, end = _ist_day(today_ist())
    return (
        SelfieCheck.objects.filter(partner_id=uid(partner_id), at__gte=start, at__lt=end)
        .order_by("-at")
        .first()
    )


def selfies(*, day: date | None = None, partner_id: str = "") -> QuerySet[SelfieCheck]:
    """Admin spot checks: selfies of a day (newest first), with the partner."""
    qs = SelfieCheck.objects.select_related("partner").order_by("-at")
    if day is not None:
        start, end = _ist_day(day)
        qs = qs.filter(at__gte=start, at__lt=end)
    if partner_id:
        qs = qs.filter(partner_id=uid(partner_id))
    return qs


def partner_status_of(user_id: str) -> str | None:
    """For the auth layer: None = not registered as a partner."""
    return PartnerProfile.objects.filter(pk=uid(user_id)).values_list("status", flat=True).first()


def partner_role_of(user_id: str) -> str | None:
    return PartnerProfile.objects.filter(pk=uid(user_id)).values_list("role", flat=True).first()


def find_partner(user_id: str) -> PartnerProfile | None:
    return PartnerProfile.objects.select_related("user").filter(pk=uid(user_id)).first()


def get_partner(partner_id: str) -> PartnerProfile:
    partner = find_partner(partner_id)
    if partner is None:
        raise NotFound()
    return partner


def phones_of(partner_id: str) -> dict[str, PartnerPhone]:
    return {p.kind: p for p in PartnerPhone.objects.filter(partner_id=uid(partner_id))}


@dataclass(frozen=True)
class Contact:
    name: str
    email: str  # empty until verified
    phone: str  # primary (login) number
    language: str


def contact(partner_id: str) -> Contact:
    """Where to send a partner's messages (verified email only)."""
    p = get_partner(partner_id)
    return Contact(
        name=p.full_name or "Partner",
        email=p.email if p.email_verified_at else "",
        phone=p.user.phone,
        language=p.user.language,
    )


def partners(
    *,
    role: str = "",
    status: str = "",
    available: bool | None = None,
    q: str = "",
    ids: list[str] | None = None,
) -> QuerySet[PartnerProfile]:
    qs = PartnerProfile.objects.select_related("user").order_by("-created_at")
    if role:
        qs = qs.filter(role=role)
    if status:
        qs = qs.filter(status=status)
    if available is not None:
        on_today = Q(available_today=True, available_on=today_ist())
        qs = qs.filter(on_today) if available else qs.exclude(on_today)
    if q:
        qs = qs.filter(
            Q(full_name__icontains=q) | Q(user__phone__contains=q) | Q(phones__phone__contains=q)
        ).distinct()
    if ids is not None:
        qs = qs.filter(pk__in=ids)
    return qs


def temporary_check(booking_id: str) -> TemporaryIdCheck | None:
    """The ID check of the booking's temporary partner (§6.19): the booking's own partner, as
    the admin list's flag (`had_temporary_partner`). None once someone else has the booking or
    nobody does."""
    return (
        TemporaryIdCheck.objects.select_related("partner__user", "checked_by")
        .filter(booking_id=uid(booking_id), partner_id=F("booking__partner_id"))
        .order_by("-checked_at")
        .first()
    )


def temporary_selfie(check: TemporaryIdCheck) -> SelfieCheck | None:
    """The selfie of this temporary job for the admin's ID card (§6.19): the newest one from the
    day of the assign until access ended. It stays on the card after the visit day."""
    start, _ = _ist_day(check.checked_at.astimezone(ZoneInfo(settings.DISPLAY_TIME_ZONE)).date())
    qs = SelfieCheck.objects.filter(partner_id=check.partner_id, at__gte=start)
    if check.ended_at is not None:
        qs = qs.filter(at__lte=check.ended_at)
    return qs.order_by("-at").first()


def open_temporary_booking_id(partner_id: str) -> str | None:
    """The one booking a TEMPORARY partner may open (§6.19), or None."""
    booking_id = (
        TemporaryIdCheck.objects.filter(partner_id=uid(partner_id), ended_at__isnull=True)
        .values_list("booking_id", flat=True)
        .first()
    )
    return str(booking_id) if booking_id else None


def had_temporary_partner() -> Exists:
    """For admin booking lists (§6.19): the booking's partner is (or was, for that booking) a
    temporary one. Admins only; the patient side never shows it."""
    return Exists(
        TemporaryIdCheck.objects.filter(
            booking_id=OuterRef("pk"), partner_id=OuterRef("partner_id")
        )
    )


def deleting_partner_ids() -> QuerySet[PartnerDeletion, Any]:
    """Partners whose "delete my account" is waiting (§6.20): no offers, not reviewed."""
    return PartnerDeletion.objects.filter(status=PartnerDeletion.Status.PENDING).values("user_id")


def is_deleting(partner_id: str) -> bool:
    return PartnerDeletion.objects.filter(
        user_id=uid(partner_id), status=PartnerDeletion.Status.PENDING
    ).exists()
