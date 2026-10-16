"""Event handlers that message partners (ARCHITECTURE §10.2). Each runs as its own Celery task
after the publishing transaction commits; they're safe to run twice (a duplicate message at
worst, never a wrong one)."""

import logging
from typing import Any

from django.conf import settings

from apps.app_config.selectors import get_setting
from apps.kyc.models import RequiredDocument
from apps.notifications import text
from apps.notifications.services import notify
from apps.notifications.text import Localized
from apps.partners.selectors import contact
from common import events
from common.money import format_inr

logger = logging.getLogger(__name__)

PARTNER = "partner"


def _doc_label(partner_id: str, doc_type: str, language: str) -> str:
    from apps.partners.selectors import get_partner

    rule = RequiredDocument.objects.filter(
        role=get_partner(partner_id).role, doc_type=doc_type
    ).first()
    if rule is None:
        return doc_type.replace("_", " ").title()
    return {"hi": rule.label_hi, "or": rule.label_or}.get(language) or rule.label


def _send(partner_id: str, code: str, /, **variables: str | Localized) -> None:
    who = contact(partner_id)
    notify(
        user_id=partner_id,
        app=PARTNER,
        code=code,
        variables={"name": who.name, **variables},
        email=who.email,
        phone=who.phone,
    )


@events.subscribe("partner.submitted")
def on_submitted(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_SUBMITTED")


@events.subscribe("partner.approved")
def on_approved(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_APPROVED")


@events.subscribe("partner.changes_requested")
def on_changes_requested(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_CHANGES_REQUESTED")


@events.subscribe("partner.rejected")
def on_rejected(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_REJECTED", reason=payload.get("reason", ""))


@events.subscribe("partner.suspended")
def on_suspended(name: str, payload: dict[str, Any]) -> None:
    _send(
        payload["partner_id"],
        "PARTNER_SUSPENDED",
        reason=str(payload.get("reason", ""))[:30],  # DLT variables are short
        support=str(get_setting("support_phone")),
    )


@events.subscribe("partner.reinstated")
def on_reinstated(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_REINSTATED")


@events.subscribe("partner.deactivated")
def on_deactivated(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_DEACTIVATED", reason=payload.get("reason", ""))


@events.subscribe("partner.added")
def on_added(name: str, payload: dict[str, Any]) -> None:
    _send(payload["partner_id"], "PARTNER_ADDED", link=settings.PARTNER_APP_URL)


@events.subscribe("partner.temp_assigned")
def on_temp_assigned(name: str, payload: dict[str, Any]) -> None:
    """§6.19: the temporary partner gets the app link with their one job."""
    from apps.bookings.models import Booking

    booking = Booking.objects.filter(pk=payload["booking_id"]).first()
    if booking is None:
        return
    _send(
        payload["partner_id"],
        "TEMP_PARTNER_JOB",
        code=booking.code,
        when=text.when(booking.pickup_at),
        link=settings.PARTNER_APP_URL,
    )


@events.subscribe("document.expiring")
def on_document_expiring(name: str, payload: dict[str, Any]) -> None:
    who = contact(payload["partner_id"])
    _send(
        payload["partner_id"],
        "DOCUMENT_EXPIRING",
        document=_doc_label(payload["partner_id"], payload["doc_type"], who.language),
        date=payload["expires_on"],
    )


@events.subscribe("document.expired")
def on_document_expired(name: str, payload: dict[str, Any]) -> None:
    who = contact(payload["partner_id"])
    _send(
        payload["partner_id"],
        "DOCUMENT_EXPIRED",
        document=_doc_label(payload["partner_id"], payload["doc_type"], who.language),
    )


@events.subscribe("document.rejected")
def on_document_rejected(name: str, payload: dict[str, Any]) -> None:
    who = contact(payload["partner_id"])
    _send(
        payload["partner_id"],
        "DOCUMENT_REJECTED",
        document=_doc_label(payload["partner_id"], payload["doc_type"], who.language),
        reason=payload.get("reason", ""),
    )


# --- Patient bookings (Phase 6, §6.14) ---


def _booking_message(booking_id: str, code: str, **extra: str) -> None:
    from apps.bookings.models import Booking
    from apps.patients.models import Member

    booking = Booking.objects.filter(pk=booking_id).first()
    if booking is None:
        return
    member = booking.member_snapshot
    variables: dict[str, str | Localized] = {
        "code": booking.code,
        "name": str(member.get("full_name", "")),
        "service": text.service(booking.price_snapshot),
        "when": text.when(booking.pickup_at),
        **extra,
    }
    # The family member gets the SMS on their own phone; you get it in the app.
    phone = "" if member.get("relation") == Member.Relation.SELF else str(member.get("phone", ""))
    notify(
        user_id=str(booking.booked_by_id),
        app="patient",
        code=code,
        variables=variables,
        phone=phone,
        data={"bookingId": str(booking.pk)},
    )


@events.subscribe("booking.paid")
def on_booking_paid(name: str, payload: dict[str, Any]) -> None:
    _booking_message(payload["booking_id"], "BOOKING_CONFIRMED")


@events.subscribe("booking.cancelled")
def on_booking_cancelled(name: str, payload: dict[str, Any]) -> None:
    _booking_message(payload["booking_id"], "BOOKING_CANCELLED")


@events.subscribe("booking.rescheduled")
def on_booking_rescheduled(name: str, payload: dict[str, Any]) -> None:
    _booking_message(payload["booking_id"], "BOOKING_RESCHEDULED")


# --- Offers, assignment and reminders (Phase 7, §6.14) ---


def _when(booking: Any) -> Localized:
    return text.when(booking.pickup_at)


def _offer_message(assignment_id: str, code: str) -> None:
    from apps.assignments.api.out import area_of
    from apps.assignments.models import BookingAssignment

    offer = (
        BookingAssignment.objects.select_related("booking", "partner")
        .filter(pk=assignment_id)
        .first()
    )
    if offer is None:
        return
    booking = offer.booking
    _send(
        str(offer.partner_id),
        code,
        code=booking.code,
        service=text.service(booking.price_snapshot),
        when=_when(booking),
        area=area_of(booking),
    )


@events.subscribe("offer.sent")
def on_offer_sent(name: str, payload: dict[str, Any]) -> None:
    from apps.assignments.models import BookingAssignment, OfferKind

    offer = BookingAssignment.objects.filter(pk=payload["assignment_id"]).first()
    if offer is None:
        return
    code = "OFFER_TIME_CHANGED" if offer.kind == OfferKind.RECONFIRM else "OFFER_NEW"
    _offer_message(payload["assignment_id"], code)


@events.subscribe("offer.reminder")
def on_offer_reminder(name: str, payload: dict[str, Any]) -> None:
    _offer_message(payload["assignment_id"], "OFFER_REMINDER")


@events.subscribe("offer.withdrawn")
def on_offer_withdrawn(name: str, payload: dict[str, Any]) -> None:
    code = "JOB_CANCELLED" if payload.get("why") == "CANCELLED" else "OFFER_WITHDRAWN"
    _offer_message(payload["assignment_id"], code)


@events.subscribe("booking.assigned")
def on_booking_assigned(name: str, payload: dict[str, Any]) -> None:
    """The partner accepted: the owner (push) and the member (SMS) get their name and phone."""
    from apps.bookings.models import Booking

    booking = (
        Booking.objects.select_related("partner__user").filter(pk=payload["booking_id"]).first()
    )
    if booking is None or booking.partner is None:
        return
    _booking_message(
        str(booking.pk),
        "BOOKING_ASSIGNED",
        partner=booking.partner.full_name,
        partner_phone=str(booking.partner.user.phone),
    )


@events.subscribe("booking.reminder")
def on_booking_reminder(name: str, payload: dict[str, Any]) -> None:
    """T-24 h and T-2 h: the owner (push) and the member (SMS); the partner if assigned."""
    from apps.bookings.models import Booking, BookingStatus

    booking = Booking.objects.filter(pk=payload["booking_id"]).first()
    if booking is None:
        return
    _booking_message(str(booking.pk), "BOOKING_REMINDER")
    if booking.partner_id and booking.status == BookingStatus.ACCEPTED:
        _send(
            str(booking.partner_id),
            "JOB_REMINDER",
            code=booking.code,
            service=text.service(booking.price_snapshot),
            when=_when(booking),
            name=str(booking.member_snapshot.get("full_name", "")),
        )


# --- The visit (Phase 8) ---


def _partner_name(booking: Any) -> str:
    return booking.partner.full_name if booking.partner else ""


@events.subscribe("booking.otp")
def on_job_otp(name: str, payload: dict[str, Any]) -> None:
    """§6.11: the job OTP by SMS to the family member's own phone (the owner sees it in the
    app). Decrypted here, in the worker: the code itself never travels in the queue."""
    from apps.bookings import visit
    from apps.bookings.models import Booking
    from apps.patients.models import Member

    booking = Booking.objects.select_related("partner").filter(pk=payload["booking_id"]).first()
    if booking is None:
        return
    member = booking.member_snapshot
    phone = "" if member.get("relation") == Member.Relation.SELF else str(member.get("phone", ""))
    otp = visit.job_otp(booking)
    if not phone or not otp:
        return
    notify(
        user_id=str(booking.booked_by_id),
        app="patient",
        code="JOB_OTP",
        variables={
            "code": booking.code,
            "name": str(member.get("full_name", "")),
            "partner": _partner_name(booking).split(" ")[0],
            "otp": otp,
        },
        phone=phone,
    )


@events.subscribe("booking.step_changed")
def on_step_changed(name: str, payload: dict[str, Any]) -> None:
    """ "On the way": the owner can watch live (the other steps go by the live socket)."""
    from apps.bookings.models import Booking

    if payload.get("step") != "ON_THE_WAY":
        return
    booking = Booking.objects.select_related("partner").filter(pk=payload["booking_id"]).first()
    if booking is not None:
        _owner_message(booking, "PARTNER_ON_THE_WAY")


@events.subscribe("booking.completed")
def on_job_completed(name: str, payload: dict[str, Any]) -> None:
    from apps.bookings.models import Booking

    booking = Booking.objects.select_related("partner").filter(pk=payload["booking_id"]).first()
    if booking is not None:
        due = int(booking.price_snapshot.get("balance_paise", 0))
        _owner_message(booking, "JOB_COMPLETED" if due > 0 else "JOB_COMPLETED_PAID")


@events.subscribe("booking.no_show")
def on_no_show(name: str, payload: dict[str, Any]) -> None:
    from apps.bookings.models import Booking

    booking = Booking.objects.select_related("partner").filter(pk=payload["booking_id"]).first()
    if booking is not None:
        _owner_message(booking, "PATIENT_NOT_AVAILABLE")


@events.subscribe("ticket.replied")
def on_ticket_replied(name: str, payload: dict[str, Any]) -> None:
    """WellWish answered a reported problem: a message in the patient's inbox."""
    from apps.reviews.models import SupportTicket

    ticket = SupportTicket.objects.select_related("booking").filter(pk=payload["ticket_id"]).first()
    if ticket is None:
        return
    code = ticket.booking.code if ticket.booking else ""
    notify(
        user_id=str(ticket.user_id),
        app="patient",
        code="TICKET_REPLY",
        variables={"code": code},
        data={"bookingId": str(ticket.booking_id) if ticket.booking_id else ""},
    )


@events.subscribe("sos.raised")
def on_sos(name: str, payload: dict[str, Any]) -> None:
    """§6.15: an SMS with the location to the emergency contacts of whoever pressed SOS (the
    partner's; or the account owner's and the family member's)."""
    from apps.patients.models import Member, PatientProfile
    from apps.safety.models import SosEvent

    sos = (
        SosEvent.objects.select_related("booking", "booking__partner", "raised_by")
        .filter(pk=payload["sos_id"])
        .first()
    )
    if sos is None or sos.raised_by_id is None:
        return
    booking = sos.booking
    phones: list[str] = []
    if sos.raised_by_type == "PARTNER" and booking.partner is not None:
        who = booking.partner.full_name
        phones.append(booking.partner.emergency_phone)
    else:
        profile = PatientProfile.objects.filter(user_id=booking.booked_by_id).first()
        who = str(booking.member_snapshot.get("full_name", "")) or (
            profile.full_name if profile else ""
        )
        phones.append(profile.emergency_phone if profile else "")
        member = Member.objects.filter(pk=booking.member_id).first() if booking.member_id else None
        phones.append(member.emergency_phone if member else "")
    # a position the phone itself called fake is not sent (people would go to the wrong place)
    where = (
        f"https://maps.google.com/?q={sos.lat},{sos.lng}"
        if sos.lat is not None and not sos.mock_location
        else "not shared"
    )
    for phone in dict.fromkeys(p for p in phones if p):
        notify(
            user_id=str(sos.raised_by_id),
            app="partner" if sos.raised_by_type == "PARTNER" else "patient",
            code="SOS_ALERT",
            variables={"who": who, "code": booking.code, "map": where},
            phone=phone,
        )


def _unacknowledged_sos(payload: dict[str, Any]) -> Any:
    """The SOS, while still not acknowledged (a retry after someone acknowledged stops)."""
    from apps.safety.models import SosEvent

    sos = SosEvent.objects.select_related("booking").filter(pk=payload["sos_id"]).first()
    return None if sos is None or sos.ack_at is not None else sos


@events.subscribe("sos.unacknowledged")
def sos_unacknowledged_email(name: str, payload: dict[str, Any]) -> None:
    """§13: nobody acknowledged an SOS within 2 minutes (the admin panel's alarm may be closed,
    e.g. at night): an email to the Super Admins. A failure raises, so the task is retried."""
    from apps.staff.selectors import super_admin_emails
    from common.mail import send_mail

    sos = _unacknowledged_sos(payload)
    if sos is None:
        return
    code = sos.booking.code
    who = "the partner" if sos.raised_by_type == "PARTNER" else "the family"
    subject = f"WellWish SOS on {code}: not acknowledged for 2 minutes"
    body = (
        f"SOS pressed by {who} during visit {code} has not been acknowledged for 2 minutes. "
        "Open the admin panel (Live), acknowledge it and call them now."
    )
    for email in super_admin_emails():
        send_mail(email, subject, body)


@events.subscribe("sos.unacknowledged")
def sos_unacknowledged_sms(name: str, payload: dict[str, Any]) -> None:
    """§13: the same, as an SMS to WellWish's support phone (Settings → Support). A failure
    raises, so the task is retried."""
    from common.phone import normalize_indian_mobile
    from common.sms import send_sms

    sos = _unacknowledged_sos(payload)
    if sos is None:
        return
    support = normalize_indian_mobile(str(get_setting("support_phone")))
    send_sms(support, "SOS_UNACKED", {"code": sos.booking.code})


def _owner_message(booking: Any, code: str) -> None:
    """The visit's messages go to the owner's app (push + inbox), no SMS."""

    balance = int(booking.price_snapshot.get("balance_paise", 0))
    notify(
        user_id=str(booking.booked_by_id),
        app="patient",
        code=code,
        variables={
            "code": booking.code,
            "name": str(booking.member_snapshot.get("full_name", "")),
            "service": text.service(booking.price_snapshot),
            "partner": _partner_name(booking),
            "balance": format_inr(balance),
            "when": text.when(booking.pickup_at),
        },
        data={"bookingId": str(booking.pk)},
    )


@events.subscribe("refund.processed")
def on_refund_processed(name: str, payload: dict[str, Any]) -> None:
    from apps.payments.models import Refund

    refund = Refund.objects.select_related("payment").filter(pk=payload["refund_id"]).first()
    if refund is None:
        return
    amount = format_inr(refund.amount_paise).removeprefix("₹")
    _booking_message(str(refund.payment.booking_id), "REFUND_PROCESSED", amount=amount)
