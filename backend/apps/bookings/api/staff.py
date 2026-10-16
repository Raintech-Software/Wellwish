"""Admin: bookings list and detail (§9.1 Bookings, PHASES 5.14, 6.6, 6.7). Needs `bookings.view`;
cancel and reschedule need `bookings.manage` (assign arrives in Phase 7). Document titles
(medical information) only for roles with `patients.documents` (§9.2); the types are always
shown, so everyone can see whether a prescription is attached."""

import datetime as dt
from typing import Literal
from uuid import UUID

from django.db import transaction
from django.http import HttpRequest, HttpResponse
from ninja import Query, Router
from ninja.pagination import paginate

from apps.accounts.models import User
from apps.app_config.selectors import get_setting
from apps.audit.services import record
from apps.bookings import selectors, services, visit
from apps.bookings.api.patient import (
    address_out,
    documents_out,
    hospital_name,
    member_out,
    service_out,
    visit_out,
)
from apps.bookings.models import ActorType, Booking, BookingStatus
from apps.bookings.schemas import (
    AdminBookingDetailOut,
    AdminBookingEventOut,
    AdminBookingPatientOut,
    AdminBookingRowOut,
    AdminCancelIn,
    AdminStepIn,
    BookingsByServiceOut,
    BookingsReportOut,
    BookingsReportRowOut,
    RescheduleIn,
)
from apps.payments import selectors as payment_selectors
from apps.payments.api.staff import payment_out, refund_out
from apps.payments.models import Payment
from apps.payments.schemas import AdminPaymentOut
from apps.staff.selectors import acting_staff
from common.auth import get_principal, staff_permission
from common.pagination import Mapped, WWPagination
from common.reports import CSV_OPENAPI, csv_response, report_range
from common.request import client_ip

router = Router(tags=["admin"])

StatusIn = Literal[
    "PENDING_PAYMENT",
    "NEW",
    "OFFERED",
    "ACCEPTED",
    "IN_PROGRESS",
    "COMPLETED",
    "PATIENT_NO_SHOW",
    "CANCELLED",
    "EXPIRED",
]
assert set(StatusIn.__args__) == set(BookingStatus.values)  # type: ignore[attr-defined]  # noqa: S101


def admin_row_fields(booking: Booking) -> dict[str, object]:
    snapshot = booking.price_snapshot
    return {
        "id": str(booking.pk),
        "code": booking.code,
        "status": booking.status,
        "patient_deleted": booking.booked_by.status == User.Status.DELETED,
        "service_name": snapshot["name"],
        "partner_type": snapshot["partner_type"],
        "visit_type": snapshot["visit_type"],
        "pickup_at": booking.pickup_at,
        "appointment_at": booking.appointment_at,
        "member_name": booking.member_snapshot.get("full_name", ""),
        "patient_phone": ""
        if booking.booked_by.status == User.Status.DELETED
        else booking.booked_by.phone,
        "hospital_name": hospital_name(booking),
        "booking_fee_paise": snapshot["booking_fee_paise"],
        "created_at": booking.created_at,
        "temporary_partner": bool(getattr(booking, "temporary_partner", False)),
    }


def admin_row(booking: Booking) -> AdminBookingRowOut:
    return AdminBookingRowOut(**admin_row_fields(booking))  # type: ignore[arg-type]


@router.get(
    "/bookings", response=list[AdminBookingRowOut], by_alias=True, operation_id="adminBookingList"
)
@staff_permission("bookings.view")
@paginate(WWPagination)
def list_bookings(
    request: HttpRequest,
    status: StatusIn | None = None,
    date: dt.date | None = None,
    type: Literal["COMPANION", "NURSE"] | None = None,
    when: selectors.When | None = None,  # default: upcoming
    q: str = Query("", max_length=40),
    temporary: bool | None = None,
) -> list[AdminBookingRowOut]:
    """`when`: upcoming (default: from today on and unfinished ones, soonest first), today,
    tomorrow, later, past (latest first), India dates. Without `status`, unpaid and expired
    bookings are left out (a booking code finds them). `date`: one pickup date. `type`: companion
    or nurse services. `q`: booking code (WW-10001), a phone (the patient's or the member's,
    4+ digits) or the member's name. `temporary`: only bookings with (or without) a temporary
    partner (§6.19)."""
    rows = selectors.admin_bookings(
        status=status or "",
        day=date,
        partner_type=type or "",
        when=when or "",
        q=q,
        temporary=temporary,
    )
    return Mapped(rows, admin_row)  # type: ignore[return-value]


@router.get(
    "/bookings/{uuid:booking_id}",
    response=AdminBookingDetailOut,
    by_alias=True,
    operation_id="adminBookingGet",
)
@staff_permission("bookings.view")
def get_booking(request: HttpRequest, booking_id: UUID) -> AdminBookingDetailOut:
    """Patient, member, service and price snapshot, hospital and doctor, address, documents
    and the timeline. Opening a document: the patient page (needs a reason, logged)."""
    booking = selectors.admin_booking(str(booking_id))
    titles = "patients.documents" in get_principal(request).permissions
    profile = getattr(booking.booked_by, "patient_profile", None)
    return AdminBookingDetailOut(
        **admin_row_fields(booking),  # type: ignore[arg-type]
        service=service_out(booking.price_snapshot),
        patient=AdminBookingPatientOut(
            id=str(booking.booked_by_id),
            full_name=profile.full_name if profile else "",
            phone=admin_row_fields(booking)["patient_phone"],  # type: ignore[arg-type]
        ),
        member=member_out(booking.member_snapshot),
        address=address_out(booking.address_snapshot),
        hospital_id=str(booking.hospital_id) if booking.hospital_id else None,
        hospital_text=booking.hospital_text,
        doctor_id=str(booking.doctor_id) if booking.doctor_id else None,
        doctor_name=booking.doctor.full_name if booking.doctor else "",
        notes=booking.notes if titles else "",
        notes_visible=titles,
        reschedule_count=booking.reschedule_count,
        documents_visible=titles,
        documents=documents_out(booking, titles=titles),
        reconfirm_needed=booking.reconfirm_needed,
        payments=[
            payment_out_for(p, booking) for p in payment_selectors.booking_payments(str(booking.pk))
        ],
        refunds=[refund_out(r) for r in payment_selectors.booking_refunds(str(booking.pk))],
        can_cancel=booking.status in services.STAFF_CANCELLABLE,
        can_reschedule=services.reschedule_problem(booking, by_staff=True) is None,
        time_step_min=int(get_setting("time_step_min")),
        visit=visit_out(booking),
        paid_paise=payment_selectors.paid_paise(str(booking.pk)),
        timeline=[
            AdminBookingEventOut(
                from_status=e.from_status,
                status=e.to_status,
                event=e.event,
                step=e.step,
                actor_type=e.actor_type,
                note=e.note,
                at=e.server_ts,
            )
            for e in booking.events.all()
        ],
    )


def payment_out_for(payment: Payment, booking: Booking) -> AdminPaymentOut:
    payment.booking = booking  # already loaded
    return payment_out(payment)


@router.post(
    "/bookings/{uuid:booking_id}/cancel",
    response=AdminBookingDetailOut,
    by_alias=True,
    operation_id="adminBookingCancel",
)
@staff_permission("bookings.manage")
def cancel_booking(
    request: HttpRequest, booking_id: UUID, data: AdminCancelIn
) -> AdminBookingDetailOut:
    """Cancel with a reason and a refund % of the booking fee (patient asked: 50 by default; no
    partner available or WellWish's side: 100). Refunds above the approval limit (setting
    `refund_approval_above_paise`) wait for Finance. Logged."""
    staff = acting_staff(request)
    booking = selectors.admin_booking(str(booking_id))
    with transaction.atomic():  # no change without its audit record
        services.cancel(
            booking_id=str(booking.pk),
            actor=services.Actor(ActorType.STAFF, str(staff.pk)),
            reason=data.reason,
            refund_percent=data.refund_percent,
            by_patient=False,
        )
        record(
            staff,
            "booking.cancelled",
            ("bookings.booking", str(booking.pk)),
            before={"status": booking.status},
            after={"status": "CANCELLED", "refund_percent": data.refund_percent},
            reason=data.reason,
            ip=client_ip(request),
        )
    return get_booking(request, booking_id)


@router.post(
    "/bookings/{uuid:booking_id}/reschedule",
    response=AdminBookingDetailOut,
    by_alias=True,
    operation_id="adminBookingReschedule",
)
@staff_permission("bookings.manage")
def reschedule_booking(
    request: HttpRequest, booking_id: UUID, data: RescheduleIn
) -> AdminBookingDetailOut:
    """Change the date or time for the patient (any time before the job starts, also inside the
    minimum notice; not counted against the patient's changes). Logged."""
    staff = acting_staff(request)
    booking = selectors.admin_booking(str(booking_id))
    with transaction.atomic():  # no change without its audit record
        services.reschedule(
            booking_id=str(booking.pk),
            actor=services.Actor(ActorType.STAFF, str(staff.pk)),
            pickup_at=data.pickup_at,
            appointment_at=data.appointment_at,
            by_staff=True,
        )
        record(
            staff,
            "booking.rescheduled",
            ("bookings.booking", str(booking.pk)),
            before={"pickup_at": booking.pickup_at.isoformat()},
            after={"pickup_at": data.pickup_at.isoformat()},
            ip=client_ip(request),
        )
    return get_booking(request, booking_id)


@router.post(
    "/bookings/{uuid:booking_id}/steps",
    response=AdminBookingDetailOut,
    by_alias=True,
    operation_id="adminBookingStep",
)
@staff_permission("bookings.manage")
def mark_step(request: HttpRequest, booking_id: UUID, data: AdminStepIn) -> AdminBookingDetailOut:
    """Mark the next step for the partner (§6.11: no network at the door, wrong visit codes, the
    phone died), after confirming by phone. No OTP needed. Logged with the reason."""
    visit.admin_step(
        booking_id=str(booking_id),
        staff=acting_staff(request),
        step=data.step,
        note=data.reason,
        ip=client_ip(request),
    )
    return get_booking(request, booking_id)


# --- Bookings report (Phase 9.2, §9.1 Reports) ---

_COUNTS = ("booked", "completed", "cancelled", "no_show", "open")


def _bookings_report(start: dt.date, end: dt.date) -> BookingsReportOut:
    data = selectors.bookings_report(start, end)
    days = [BookingsReportRowOut(**row) for row in data["days"]]
    return BookingsReportOut(
        start=start,
        end=end,
        days=days,
        services=[BookingsByServiceOut(**row) for row in data["services"]],
        total=BookingsReportRowOut(
            date=None, **{k: sum(getattr(d, k) for d in days) for k in _COUNTS}
        ),
    )


@router.get(
    "/reports/bookings",
    response=BookingsReportOut,
    by_alias=True,
    operation_id="adminBookingsReport",
)
@staff_permission("bookings.view")
def bookings_report(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> BookingsReportOut:
    """Paid bookings by visit date (India) and by service: booked, completed, cancelled,
    patient not available, not finished. Default: this month so far."""
    return _bookings_report(*report_range(start, end))


@router.get(
    "/reports/bookings/csv", operation_id="adminBookingsReportCsv", openapi_extra=CSV_OPENAPI
)
@staff_permission("bookings.view")
def bookings_report_csv(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> HttpResponse:
    """The bookings report as a CSV file (by date, then by service). Logged."""
    report = _bookings_report(*report_range(start, end))
    head = ["Booked", "Completed", "Cancelled", "Patient not available", "Not finished"]
    lines: list[list[object]] = [
        [d.date.isoformat() if d.date else "", *(getattr(d, k) for k in _COUNTS)]
        for d in report.days
    ]
    lines.append(["Total", *(getattr(report.total, k) for k in _COUNTS)])
    lines += [[], ["Service", *head]]
    lines += [[s.service, *(getattr(s, k) for k in _COUNTS)] for s in report.services]
    record(
        acting_staff(request),
        "reports.exported",
        ("bookings.booking", ""),
        after={
            "report": "bookings",
            "from": report.start.isoformat(),
            "to": report.end.isoformat(),
        },
        ip=client_ip(request),
    )
    return csv_response(
        f"wellwish-bookings-{report.start}-to-{report.end}.csv", ["Date (IST)", *head], lines
    )
