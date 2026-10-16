"""Patient booking endpoints (§10.3): the times that can be booked, "Book" (P15), and the
patient's bookings (P17, P18). Payment comes in Phase 6: a new booking waits as PENDING_PAYMENT."""

import datetime as dt
from typing import Any
from uuid import UUID

from django.http import HttpRequest
from ninja import Header, Query, Router
from ninja.pagination import paginate

from apps.app_config.selectors import get_setting
from apps.bookings import selectors, services, times, visit
from apps.bookings.models import ActorType, Booking, BookingStatus
from apps.bookings.schemas import (
    AssignedPartnerOut,
    BookingAddressOut,
    BookingDayOut,
    BookingDetailOut,
    BookingDocumentOut,
    BookingIn,
    BookingMemberOut,
    BookingRowOut,
    BookingServiceOut,
    BookingTimelineOut,
    BookingTimesOut,
    CancelIn,
    CancelPreviewOut,
    RescheduleIn,
    StepDoneOut,
    VisitOut,
)
from apps.files.services import view_url
from apps.payments import selectors as payment_selectors
from apps.payments import services as payment_services
from apps.payments.schemas import BookingRefundOut
from apps.services.models import Service
from common.auth import get_principal
from common.errors import NotFound
from common.money import percent_of
from common.pagination import Mapped, WWPagination

router = Router(tags=["patient"])

IDEMPOTENCY_KEY = r"^[A-Za-z0-9_-]{8,64}$"


def service_out(snapshot: dict[str, Any]) -> BookingServiceOut:
    return BookingServiceOut(
        name=snapshot["name"],
        name_hi=snapshot.get("name_hi", ""),
        name_or=snapshot.get("name_or", ""),
        partner_type=snapshot["partner_type"],
        visit_type=snapshot["visit_type"],
        duration_min=snapshot["duration_min"],
        docs_required=snapshot.get("docs_required", False),
        price_paise=snapshot["price_paise"],
        booking_fee_paise=snapshot["booking_fee_paise"],
        balance_paise=snapshot["balance_paise"],
    )


def member_out(snapshot: dict[str, Any]) -> BookingMemberOut:
    return BookingMemberOut(
        id=snapshot.get("id"),
        full_name=snapshot.get("full_name", ""),
        relation=snapshot.get("relation", ""),
        gender=snapshot.get("gender", ""),
        age=snapshot.get("age"),
        phone=snapshot.get("phone", ""),
        language=snapshot.get("language", ""),
    )


def address_out(snapshot: dict[str, Any]) -> BookingAddressOut:
    return BookingAddressOut(
        label=snapshot.get("label", ""),
        line1=snapshot.get("line1", ""),
        landmark=snapshot.get("landmark", ""),
        notes=snapshot.get("notes", ""),
        lat=snapshot.get("lat", ""),
        lng=snapshot.get("lng", ""),
    )


def documents_out(booking: Booking, *, titles: bool = True) -> list[BookingDocumentOut]:
    out = []
    for link in booking.documents.all():
        document = link.document
        removed = document is None or document.deleted_at is not None
        out.append(
            BookingDocumentOut(
                id=str(link.pk),
                document_id=None if removed or document is None else str(document.pk),
                type=link.doc_type,
                title="" if removed or document is None or not titles else document.title,
                removed=removed,
            )
        )
    return out


def hospital_name(booking: Booking) -> str:
    return booking.hospital.name if booking.hospital else booking.hospital_text


def payment_time() -> dt.timedelta:
    """Read once per request (a list builds many rows)."""
    return dt.timedelta(minutes=int(get_setting("payment_expiry_min")))


def row_fields(booking: Booking, expiry: dt.timedelta | None = None) -> dict[str, Any]:
    unpaid = booking.status == BookingStatus.PENDING_PAYMENT
    return {
        "id": str(booking.pk),
        "code": booking.code,
        "status": booking.status,
        "service": service_out(booking.price_snapshot),
        "member_name": booking.member_snapshot.get("full_name", ""),
        "pickup_at": booking.pickup_at,
        "appointment_at": booking.appointment_at,
        "hospital_name": hospital_name(booking),
        "created_at": booking.created_at,
        "pay_by": booking.created_at + (expiry or payment_time()) if unpaid else None,
    }


def booking_out(booking: Booking) -> BookingDetailOut:
    problem = services.reschedule_problem(booking)
    left = max(0, int(get_setting("max_reschedules")) - booking.reschedule_count)
    return BookingDetailOut(
        **row_fields(booking),
        member=member_out(booking.member_snapshot),
        address=address_out(booking.address_snapshot),
        hospital_id=str(booking.hospital_id) if booking.hospital_id else None,
        doctor_id=str(booking.doctor_id) if booking.doctor_id else None,
        doctor_name=booking.doctor.full_name if booking.doctor else "",
        notes=booking.notes,
        documents=documents_out(booking),
        timeline=[
            BookingTimelineOut(status=e.to_status, event=e.event, step=e.step, at=e.server_ts)
            for e in booking.events.all()
            if e.event not in HIDDEN_EVENTS
        ],
        paid_paise=payment_selectors.paid_paise(str(booking.pk)),
        refunds=[
            BookingRefundOut(
                amount_paise=r.amount_paise,
                percent=r.percent,
                status=r.status,
                created_at=r.created_at,
                processed_at=r.processed_at,
            )
            for r in payment_selectors.booking_refunds(str(booking.pk))
        ],
        can_cancel=services.can_patient_cancel(booking),
        can_reschedule=problem is None,
        reschedule_problem=problem,
        reschedules_left=left,
        reconfirm_needed=booking.reconfirm_needed,
        payment_pending=booking.status == BookingStatus.PENDING_PAYMENT
        and payment_services.payment_in_progress(str(booking.pk)),
        partner=assigned_partner(booking),
        visit=visit_out(booking),
        job_otp=visit.job_otp(booking),
        **feedback(booking),
    )


def feedback(booking: Booking) -> dict[str, Any]:
    """P20: the rating and the problems reported (the reviews app's records)."""
    from apps.reviews import selectors as review_selectors
    from apps.reviews import services as review_services
    from apps.reviews.api.out import review_out, ticket_out

    review = review_selectors.booking_review(booking)
    return {
        "review": review_out(review) if review else None,
        "can_review": booking.status == BookingStatus.COMPLETED and review is None,
        "can_report": review_services.can_report(booking),
        "tickets": [
            ticket_out(t)
            for t in review_selectors.booking_tickets(booking, str(booking.booked_by_id))
        ],
    }


# The partner's call attempts and the balance they recorded aren't the family's timeline.
HIDDEN_EVENTS = ("CALL", "BALANCE")
VISIT_STATUSES = (
    BookingStatus.ACCEPTED,
    BookingStatus.IN_PROGRESS,
    BookingStatus.COMPLETED,
    BookingStatus.PATIENT_NO_SHOW,
)


def visit_out(booking: Booking) -> VisitOut | None:
    """§6.11: the job's steps (shared by the patient, partner and admin views)."""
    if booking.status not in VISIT_STATUSES:
        return None
    done = [
        StepDoneOut(step=e.step, at=e.server_ts, by=e.actor_type, far=e.far_from_target)
        for e in booking.events.all()
        if e.step and e.event in ("START", "STEP", "COMPLETE")
    ]
    ready = visit.no_show_ready_at(booking)
    return VisitOut(
        steps=list(visit.steps_for(booking)),
        done=done,
        current_step=booking.current_step,
        next_step=visit.next_step(booking),
        otp_step=visit.otp_step(booking),
        otp_retry_at=visit.otp_retry_at(booking),
        no_show_ready_at=ready,
        balance_collected_paise=booking.balance_collected_paise,
        balance_mode=booking.balance_mode,
    )


def assigned_partner(booking: Booking) -> AssignedPartnerOut | None:
    """§6.15: the accepted partner's photo, name, rating and phone (the phone from acceptance
    until 1 hour after completion)."""
    partner = booking.partner
    if partner is None or booking.status not in (
        BookingStatus.ACCEPTED,
        BookingStatus.IN_PROGRESS,
        BookingStatus.COMPLETED,
    ):
        return None
    return AssignedPartnerOut(
        full_name=partner.full_name,
        role=partner.role,
        photo_url=view_url(partner.photo_key) if partner.photo_key else None,
        phone=str(partner.user.phone)
        if selectors.in_job_window(booking, selectors.PHONES_AFTER_JOB)
        else "",
        rating_avg=str(partner.rating_avg) if partner.rating_avg is not None else None,
        rating_count=partner.rating_count,
    )


@router.get(
    "/booking-times", response=BookingTimesOut, by_alias=True, operation_id="patientBookingTimes"
)
def booking_times(
    request: HttpRequest,
    service_id: UUID = Query(..., alias="serviceId"),  # noqa: B008
    date: dt.date | None = None,
) -> BookingTimesOut:
    """The date strip and the time grid (P12, §6.17): every date of the booking window
    (greyed out when nothing is free) and the times that can be picked on `date` (default: the
    first date with a free time). Times are on the admin's step, inside the service hours, after
    the minimum notice, not blocked and not full."""
    service = Service.objects.filter(pk=service_id, is_active=True).first()
    if service is None:
        raise NotFound()
    return _times_out(service.partner_type, date)


def _times_out(
    partner_type: str, date: dt.date | None, leave_out: object = None
) -> BookingTimesOut:
    days = times.available_days(partner_type, leave_out=leave_out)
    if date is None:
        date = next((day for day, free in days if free), days[0][0])
    first, last = days[0][0], days[-1][0]
    picked = (
        times.available_times(partner_type, date, leave_out=leave_out)
        if first <= date <= last
        else []
    )
    return BookingTimesOut(
        date=date,
        times=picked,
        days=[BookingDayOut(date=day, available=free) for day, free in days],
        time_step_min=int(get_setting("time_step_min")),
        travel_buffer_min=int(get_setting("travel_buffer_min")),
    )


@router.get(
    "/bookings/{uuid:booking_id}/reschedule-times",
    response=BookingTimesOut,
    by_alias=True,
    operation_id="patientBookingRescheduleTimes",
)
def reschedule_times(
    request: HttpRequest, booking_id: UUID, date: dt.date | None = None
) -> BookingTimesOut:
    """P30: the dates and times this booking can move to (same rules as booking; its own place
    doesn't count against "max bookings per time")."""
    booking = selectors.own_booking(get_principal(request).subject_id, str(booking_id))
    return _times_out(booking.partner_type, date, leave_out=booking.pk)


@router.post("/bookings", response=BookingDetailOut, by_alias=True, operation_id="patientBook")
def book(
    request: HttpRequest,
    data: BookingIn,
    idempotency_key: str = Header(..., alias="Idempotency-Key", pattern=IDEMPOTENCY_KEY),
) -> BookingDetailOut:
    """ "Book" on Review (P15). Checks the member and address are yours, the address is inside a
    service area, the time is still allowed and a prescription is attached when the service needs
    one. Saved as PENDING_PAYMENT with the price, member and address as they are now.

    `Idempotency-Key` (8 to 64 letters, digits, - or _), made once per Review screen: sending the
    same key again returns the same booking, so a double tap or a retry never books twice.
    Errors: 409 TIME_NOT_AVAILABLE (reload the times), 422 PRESCRIPTION_REQUIRED,
    422 OUTSIDE_SERVICE_AREA, 422 INVALID_BOOKING (`details.field`), 429 TOO_MANY_UNPAID."""
    user_id = get_principal(request).subject_id
    booking, _ = services.create_booking(
        user_id=user_id,
        data=services.BookingInput(
            service_id=str(data.service_id),
            member_id=str(data.member_id),
            address_id=str(data.address_id),
            pickup_at=data.pickup_at,
            appointment_at=data.appointment_at,
            hospital_id=str(data.hospital_id) if data.hospital_id else None,
            hospital_text=data.hospital_text,
            doctor_id=str(data.doctor_id) if data.doctor_id else None,
            document_ids=[str(d) for d in data.document_ids],
            notes=data.notes,
        ),
        idempotency_key=idempotency_key,
    )
    return booking_out(selectors.own_booking(user_id, str(booking.pk)))


@router.get(
    "/bookings", response=list[BookingRowOut], by_alias=True, operation_id="patientBookingList"
)
@paginate(WWPagination)
def list_bookings(
    request: HttpRequest, bucket: selectors.Bucket = "upcoming"
) -> list[BookingRowOut]:
    """P17: `upcoming` (soonest first: waiting for payment, being assigned, assigned),
    `ongoing` (in progress) or `past` (latest first: completed, cancelled, expired)."""
    rows = selectors.patient_bookings(get_principal(request).subject_id, bucket)
    expiry = payment_time()
    return Mapped(rows, lambda b: BookingRowOut(**row_fields(b, expiry)))  # type: ignore[return-value]


@router.get(
    "/bookings/{uuid:booking_id}",
    response=BookingDetailOut,
    by_alias=True,
    operation_id="patientBookingGet",
)
def get_booking(request: HttpRequest, booking_id: UUID) -> BookingDetailOut:
    """P18: the booking with its timeline (the partner, OTP and live map come later)."""
    return booking_out(selectors.own_booking(get_principal(request).subject_id, str(booking_id)))


@router.get(
    "/bookings/{uuid:booking_id}/cancel-preview",
    response=CancelPreviewOut,
    by_alias=True,
    operation_id="patientBookingCancelPreview",
)
def cancel_preview(request: HttpRequest, booking_id: UUID) -> CancelPreviewOut:
    """W-P4: "You'll get back ₹50 (50% of the booking fee)". `allowed` false once the partner is
    on the way (then the patient calls support)."""
    booking = selectors.own_booking(get_principal(request).subject_id, str(booking_id))
    paid = payment_selectors.paid_paise(str(booking.pk))
    percent = int(get_setting("refund_percent"))
    return CancelPreviewOut(
        allowed=services.can_patient_cancel(booking),
        paid_paise=paid,
        refund_percent=percent,
        refund_paise=percent_of(paid, percent),
    )


@router.post(
    "/bookings/{uuid:booking_id}/cancel",
    response=BookingDetailOut,
    by_alias=True,
    operation_id="patientBookingCancel",
)
def cancel(request: HttpRequest, booking_id: UUID, data: CancelIn) -> BookingDetailOut:
    """Cancel before the partner is on the way. The setting's share of the booking fee (50 %) is
    refunded to the original payment method. 409 CANCEL_NOT_ALLOWED after that."""
    user_id = get_principal(request).subject_id
    booking = selectors.own_booking(user_id, str(booking_id))
    services.cancel(
        booking_id=str(booking.pk),
        actor=services.Actor(ActorType.PATIENT, user_id),
        reason=data.reason,
        refund_percent=int(get_setting("refund_percent")),
        by_patient=True,
    )
    return booking_out(selectors.own_booking(user_id, str(booking.pk)))


@router.post(
    "/bookings/{uuid:booking_id}/reschedule",
    response=BookingDetailOut,
    by_alias=True,
    operation_id="patientBookingReschedule",
)
def reschedule(request: HttpRequest, booking_id: UUID, data: RescheduleIn) -> BookingDetailOut:
    """P30: a new date and time, same rules as booking; until the cut-off before pickup (3 h) and
    at most the setting's number of times (2). Price and fee don't change. 409
    RESCHEDULE_NOT_ALLOWED (`details.reason`: STATUS, TOO_LATE, LIMIT), 409 TIME_NOT_AVAILABLE."""
    user_id = get_principal(request).subject_id
    booking = selectors.own_booking(user_id, str(booking_id))
    services.reschedule(
        booking_id=str(booking.pk),
        actor=services.Actor(ActorType.PATIENT, user_id),
        pickup_at=data.pickup_at,
        appointment_at=data.appointment_at,
    )
    return booking_out(selectors.own_booking(user_id, str(booking.pk)))
