"""Turning assignments, bookings and partners into API shapes."""

from typing import Any

from django.utils import timezone

from apps.assignments import services
from apps.assignments.models import BookingAssignment, StaffAlert
from apps.assignments.schemas import (
    AlertOut,
    OfferBriefOut,
    OfferOut,
    OfferSummaryOut,
    PartnerJobRowOut,
    QueueRowOut,
)
from apps.assignments.selectors import ACTIVE_PARTNER
from apps.bookings.api.patient import service_out
from apps.bookings.models import Booking, BookingStatus
from apps.partners.models import PartnerProfile
from common.geo import haversine_km


def phones(partner: PartnerProfile | None) -> tuple[str, str]:
    """(primary, alternate)."""
    if partner is None:
        return "", ""
    alternate = next((p.phone for p in partner.phones.all() if p.kind == "ALTERNATE"), "")
    return str(partner.user.phone), alternate


def area_of(booking: Booking) -> str:
    """The locality without the house / plot part: "Plot 12, Saheed Nagar, Bhubaneswar 751007"
    → "Saheed Nagar, Bhubaneswar 751007" (the full address opens after accepting)."""
    line1 = str(booking.address_snapshot.get("line1", ""))
    parts = [p.strip() for p in line1.split(",") if p.strip()]
    return ", ".join(parts[1:]) if len(parts) > 1 else ""


def hospital_name(booking: Booking) -> str:
    return booking.hospital.name if booking.hospital else booking.hospital_text


def offer_brief(offer: BookingAssignment) -> OfferBriefOut:
    return OfferBriefOut(
        assignment_id=str(offer.pk),
        kind=offer.kind,
        partner_id=str(offer.partner_id),
        partner_name=offer.partner.full_name,
        sent_at=offer.sent_at,
        timeout_at=offer.timeout_at,
    )


def queue_row(booking: Booking) -> QueueRowOut:
    offers: list[BookingAssignment] = getattr(booking, "open_offers", [])
    deadline = services.booking_deadline(booking)
    return QueueRowOut(
        id=str(booking.pk),
        code=booking.code,
        status=booking.status,
        pickup_at=booking.pickup_at,
        appointment_at=booking.appointment_at,
        service_name=booking.price_snapshot.get("name", ""),
        partner_type=booking.price_snapshot.get("partner_type", ""),
        visit_type=booking.price_snapshot.get("visit_type", ""),
        member_name=booking.member_snapshot.get("full_name", ""),
        hospital_name=hospital_name(booking),
        deadline_at=deadline,
        late=timezone.now() >= deadline,
        offer=offer_brief(offers[0]) if offers else None,
        open_alerts=int(getattr(booking, "open_alerts", 0)),
        problem=_problem(booking),
    )


def _problem(booking: Booking) -> str:
    if booking.status != BookingStatus.ACCEPTED:
        return ""
    if booking.partner is not None and booking.partner.status not in ACTIVE_PARTNER:
        return "PARTNER_UNAVAILABLE"
    return "RECONFIRM" if booking.reconfirm_needed else ""


def offer_out(offer: BookingAssignment) -> OfferOut:
    primary, alternate = phones(offer.partner)
    return OfferOut(
        id=str(offer.pk),
        kind=offer.kind,
        partner_id=str(offer.partner_id),
        partner_name=offer.partner.full_name,
        phone=primary,
        alternate_phone=alternate,
        assigned_by=offer.assigned_by.name if offer.assigned_by else "",
        sent_at=offer.sent_at,
        timeout_at=offer.timeout_at,
        response=offer.response,
        responded_at=offer.responded_at,
        decline_reason=offer.decline_reason,
        decline_note=offer.decline_note,
    )


def alert_out(alert: StaffAlert) -> AlertOut:
    # an offer's alert: that offer's partner; a visit's alert: the booking's partner
    partner = alert.assignment.partner if alert.assignment else alert.booking.partner
    primary, alternate = phones(partner)
    return AlertOut(
        id=str(alert.pk),
        kind=alert.kind,
        booking_id=str(alert.booking_id),
        booking_code=alert.booking.code,
        pickup_at=alert.pickup_at,
        details=dict(alert.details),
        created_at=alert.created_at,
        acknowledged_at=alert.acknowledged_at,
        partner_name=partner.full_name if partner else "",
        phone=primary,
        alternate_phone=alternate,
    )


def distance_to(booking: Booking, partner: PartnerProfile) -> float | None:
    lat, lng = booking.address_snapshot.get("lat"), booking.address_snapshot.get("lng")
    if not (lat and lng) or partner.lat is None or partner.lng is None:
        return None
    return round(haversine_km(float(lat), float(lng), float(partner.lat), float(partner.lng)), 1)


def _needs(booking: Booking) -> dict[str, Any]:
    member = booking.member
    return {"mobility": member.mobility if member else ""}


def offer_summary(offer: BookingAssignment) -> OfferSummaryOut:
    booking = offer.booking
    snapshot = booking.member_snapshot
    documents = list(booking.documents.all())
    return OfferSummaryOut(
        assignment_id=str(offer.pk),
        kind=offer.kind,
        response=offer.response,
        booking_id=str(booking.pk),
        code=booking.code,
        service=service_out(booking.price_snapshot),
        pickup_at=booking.pickup_at,
        appointment_at=booking.appointment_at,
        area=area_of(booking),
        distance_km=distance_to(booking, offer.partner),
        hospital_name=hospital_name(booking),
        member_age=snapshot.get("age"),
        member_gender=snapshot.get("gender", ""),
        language=snapshot.get("language", ""),
        mobility=_needs(booking)["mobility"],
        documents_attached=len(documents),
        has_prescription=any(d.doc_type == "PRESCRIPTION" for d in documents),
        balance_paise=int(booking.price_snapshot.get("balance_paise", 0)),
        sent_at=offer.sent_at,
        timeout_at=offer.timeout_at,
    )


def job_row(booking: Booking) -> PartnerJobRowOut:
    return PartnerJobRowOut(
        id=str(booking.pk),
        code=booking.code,
        status=booking.status,
        service=service_out(booking.price_snapshot),
        pickup_at=booking.pickup_at,
        appointment_at=booking.appointment_at,
        member_name=booking.member_snapshot.get("full_name", ""),
        hospital_name=hospital_name(booking),
        area=area_of(booking),
        reconfirm_needed=booking.reconfirm_needed,
    )
