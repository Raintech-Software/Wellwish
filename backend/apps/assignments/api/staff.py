"""Admin: the Unassigned queue, the suggestion list, assign / reassign, accepted by phone,
unassign and alerts (§6.10, §9.1 Bookings, §9.3). Viewing needs `bookings.view`; changing
needs `bookings.manage`. Every change is logged."""

import datetime as dt
from typing import Literal
from uuid import UUID

from django.http import HttpRequest, HttpResponse
from django.utils import timezone
from ninja import Query, Router
from ninja.pagination import paginate

from apps.assignments import selectors, services
from apps.assignments.api.out import alert_out, offer_out, phones, queue_row
from apps.assignments.schemas import (
    AdminNoteIn,
    AlertOut,
    AssignedPartnerBriefOut,
    AssignIn,
    AssignmentStateOut,
    CandidateOut,
    FileLinkOut,
    PartnerPerformanceOut,
    PartnerPerformanceRowOut,
    QueueCountsOut,
    QueueRowOut,
    TemporaryAssignIn,
    TemporaryEndIn,
    TemporaryPartnerOut,
)
from apps.audit.services import record
from apps.bookings import selectors as booking_selectors
from apps.bookings.models import BookingStatus
from apps.files.services import view_url
from apps.partners import selectors as partner_selectors
from apps.partners import services as partners
from apps.staff.selectors import acting_staff
from common.auth import staff_any_permission, staff_permission
from common.errors import ApiError, NotFound
from common.pagination import Mapped, WWPagination
from common.reports import CSV_OPENAPI, csv_response, report_range
from common.request import client_ip

router = Router(tags=["admin"])


@router.get(
    "/assignments/queue",
    response=list[QueueRowOut],
    by_alias=True,
    operation_id="adminQueueList",
)
@staff_permission("bookings.view")
@paginate(WWPagination)
def queue(
    request: HttpRequest, when: Literal["all", "today", "tomorrow", "later"] = "all"
) -> Mapped[QueueRowOut]:
    """Paid bookings without a partner yet (NEW, or OFFERED and waiting), soonest first.
    `late` = past the assign deadline (red)."""
    return Mapped(selectors.queue(when), queue_row)


@router.get(
    "/assignments/queue/counts",
    response=QueueCountsOut,
    by_alias=True,
    operation_id="adminQueueCounts",
)
@staff_permission("bookings.view")
def queue_counts(request: HttpRequest) -> QueueCountsOut:
    return QueueCountsOut(**selectors.queue_counts())


@router.get(
    "/bookings/{uuid:booking_id}/candidates",
    response=list[CandidateOut],
    by_alias=True,
    operation_id="adminBookingCandidates",
)
@staff_permission("bookings.manage")
def candidates(request: HttpRequest, booking_id: UUID) -> list[CandidateOut]:
    """§6.10 suggestion list: approved partners of the booking's type who are free then,
    available today first, then nearest. Both phone numbers for the call buttons."""
    booking = booking_selectors.admin_booking(str(booking_id))
    out = []
    for c in selectors.candidates(booking):
        primary, alternate = phones(c.partner)
        out.append(
            CandidateOut(
                partner_id=str(c.partner.pk),
                full_name=c.partner.full_name,
                photo_url=view_url(c.partner.photo_key) if c.partner.photo_key else None,
                gender=c.partner.gender,
                languages=list(c.partner.languages),
                skills=list(c.partner.skills),
                rating_avg=str(c.partner.rating_avg) if c.partner.rating_avg is not None else None,
                rating_count=c.partner.rating_count,
                distance_km=c.distance_km,
                available_today=c.available_today,
                jobs_this_week=c.jobs_this_week,
                phone=primary,
                alternate_phone=alternate,
                offered_now=c.offered_now,
            )
        )
    return out


def _state(booking_id: str) -> AssignmentStateOut:
    booking = booking_selectors.admin_booking(booking_id)
    open_offer = selectors.open_offer(booking_id)
    deadline = services.booking_deadline(booking)
    partner = None
    if booking.partner is not None and booking.status in (
        BookingStatus.ACCEPTED,
        BookingStatus.IN_PROGRESS,
        BookingStatus.COMPLETED,
    ):
        primary, alternate = phones(booking.partner)
        partner = AssignedPartnerBriefOut(
            partner_id=str(booking.partner.pk),
            full_name=booking.partner.full_name,
            phone=primary,
            alternate_phone=alternate,
            photo_url=view_url(booking.partner.photo_key) if booking.partner.photo_key else None,
        )
    unassigned = booking.status in (BookingStatus.NEW, BookingStatus.OFFERED)
    current = services.current_assignment(booking)
    return AssignmentStateOut(
        booking_id=str(booking.pk),
        status=booking.status,
        deadline_at=deadline,
        late=unassigned and timezone.now() >= deadline,
        can_assign=unassigned,
        can_unassign=booking.status in (BookingStatus.OFFERED, BookingStatus.ACCEPTED),
        current_assignment_id=str(current.pk) if current else None,
        open_offer=offer_out(open_offer) if open_offer else None,
        partner=partner,
        reconfirm_needed=booking.reconfirm_needed,
        offers=[offer_out(o) for o in selectors.booking_offers(booking_id)],
        alerts=[alert_out(a) for a in selectors.alerts(booking_id=booking_id)],
    )


@router.get(
    "/bookings/{uuid:booking_id}/assignment",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingAssignment",
)
@staff_permission("bookings.view")
def assignment(request: HttpRequest, booking_id: UUID) -> AssignmentStateOut:
    """The booking page's assignment card (2-minute countdown, partner, offers, alerts)."""
    return _state(str(booking_id))


@router.post(
    "/bookings/{uuid:booking_id}/assign",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingAssign",
)
@staff_permission("bookings.manage")
def assign(request: HttpRequest, booking_id: UUID, data: AssignIn) -> AssignmentStateOut:
    """Offer the booking to a partner (reassigning withdraws the open offer). 409
    PARTNER_BUSY / PARTNER_NOT_ELIGIBLE / NOT_ASSIGNABLE / OFFER_CHANGED (another admin)."""
    services.assign(
        booking_id=str(booking_id),
        partner_id=data.partner_id,
        staff=acting_staff(request),
        ip=client_ip(request),
        expected_assignment_id=data.expected_assignment_id,
    )
    return _state(str(booking_id))


@router.post(
    "/bookings/{uuid:booking_id}/accept-by-phone",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingAcceptByPhone",
)
@staff_permission("bookings.manage")
def accept_by_phone(
    request: HttpRequest, booking_id: UUID, data: AdminNoteIn
) -> AssignmentStateOut:
    """The offered partner agreed on the phone (§6.10). Logged with the note."""
    services.accept_by_phone(
        booking_id=str(booking_id),
        staff=acting_staff(request),
        note=data.reason,
        ip=client_ip(request),
        expected_assignment_id=data.expected_assignment_id,
    )
    return _state(str(booking_id))


@router.post(
    "/bookings/{uuid:booking_id}/temporary-assign",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingTemporaryAssign",
)
@staff_permission("bookings.manage")
def temporary_assign(
    request: HttpRequest, booking_id: UUID, data: TemporaryAssignIn
) -> AssignmentStateOut:
    """Nobody free (§6.19): a person the admin phoned and ID-checked gets this booking, accepted
    at once. 409 PHONE_IS_PARTNER {status} / TEMP_PARTNER_BUSY / TEMP_PARTNER_IS_FAMILY /
    NOT_ASSIGNABLE / OFFER_CHANGED; 422 ID_NOT_CHECKED / INVALID_PHONE / INVALID_ID_LAST4 /
    NURSING_REG_REQUIRED / FILE_NOT_FOUND. Logged with the reason."""
    if not data.id_checked:
        raise ApiError(
            status=422,
            code="ID_NOT_CHECKED",
            message="Call the person and check their ID against the photo first.",
        )
    services.temporary_assign(
        booking_id=str(booking_id),
        details=partners.TemporaryDetails(
            phone=data.phone,
            full_name=data.full_name,
            gender=data.gender,
            id_type=data.id_type,
            id_last4=data.id_last4,
            id_photo_key=data.id_photo_key,
            nursing_reg_no=data.nursing_reg_no,
            reason=data.reason,
        ),
        staff=acting_staff(request),
        ip=client_ip(request),
        expected_assignment_id=data.expected_assignment_id,
    )
    return _state(str(booking_id))


@router.get(
    "/bookings/{uuid:booking_id}/temporary-partner",
    response=TemporaryPartnerOut,
    by_alias=True,
    operation_id="adminBookingTemporaryPartner",
)
@staff_permission("bookings.view")
def temporary_partner(request: HttpRequest, booking_id: UUID) -> TemporaryPartnerOut:
    """The ID card of the booking's temporary partner (§6.19). 404: none."""
    check = partner_selectors.temporary_check(str(booking_id))
    if check is None:
        raise NotFound()
    partner = check.partner
    selfie = partner_selectors.temporary_selfie(check)
    return TemporaryPartnerOut(
        partner_id=str(partner.pk),
        full_name=partner.full_name,
        phone=partner.user.phone,
        status=partner.status,
        id_type=check.id_type,
        id_last4=check.id_last4,
        nursing_reg_no=check.nursing_reg_no,
        reason=check.reason,
        checked_by=check.checked_by.name,
        checked_at=check.checked_at,
        ended_at=check.ended_at,
        end_reason=check.end_reason,
        selfie_url=view_url(selfie.file_key) if selfie else None,
    )


@router.get(
    "/bookings/{uuid:booking_id}/temporary-partner/id-photo",
    response=FileLinkOut,
    by_alias=True,
    operation_id="adminBookingTemporaryIdPhoto",
)
@staff_any_permission("partners.review", "partners.add", "bookings.manage")
def temporary_id_photo(request: HttpRequest, booking_id: UUID) -> FileLinkOut:
    """A 5-minute link to the temporary partner's ID photo, for those who see partner documents
    or assign bookings (not view-only roles). Every view is logged (`temporary.id_viewed`), like
    partner documents (§6.3)."""
    check = partner_selectors.temporary_check(str(booking_id))
    if check is None:
        raise NotFound()
    record(
        acting_staff(request),
        "temporary.id_viewed",
        ("partners.temporaryidcheck", str(check.pk)),
        ip=client_ip(request),
    )
    ext = check.id_photo_key.rsplit(".", 1)[-1].lower()
    mime = ID_PHOTO_MIMES.get(ext, "application/octet-stream")
    return FileLinkOut(url=view_url(check.id_photo_key), mime=mime)


ID_PHOTO_MIMES = {
    "pdf": "application/pdf",
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
    "webp": "image/webp",
}


@router.post(
    "/bookings/{uuid:booking_id}/temporary-partner/end",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingTemporaryEnd",
)
@staff_permission("bookings.manage")
def temporary_end(
    request: HttpRequest, booking_id: UUID, data: TemporaryEndIn
) -> AssignmentStateOut:
    """End the temporary partner's app access now (§6.19), e.g. a problem during the visit.
    Logged out at once; a job not finished is flagged PARTNER_UNAVAILABLE. 409 NOT_TEMPORARY:
    no temporary partner with access on this booking."""
    services.end_temporary_access(
        booking_id=str(booking_id),
        staff=acting_staff(request),
        reason=data.reason,
        ip=client_ip(request),
    )
    return _state(str(booking_id))


@router.post(
    "/bookings/{uuid:booking_id}/unassign",
    response=AssignmentStateOut,
    by_alias=True,
    operation_id="adminBookingUnassign",
)
@staff_permission("bookings.manage")
def unassign(request: HttpRequest, booking_id: UUID, data: AdminNoteIn) -> AssignmentStateOut:
    """Withdraw the offer, or take the job from an accepted partner (they called): back to the
    queue. Logged with the reason."""
    services.unassign(
        booking_id=str(booking_id),
        staff=acting_staff(request),
        reason=data.reason,
        ip=client_ip(request),
        expected_assignment_id=data.expected_assignment_id,
    )
    return _state(str(booking_id))


@router.get("/alerts", response=list[AlertOut], by_alias=True, operation_id="adminAlertsList")
@staff_permission("bookings.view")
@paginate(WWPagination)
def alerts(
    request: HttpRequest,
    open_only: bool = Query(True, alias="open"),
    kind: list[str] | None = Query(None, description="Only these kinds"),  # noqa: B008
) -> Mapped[AlertOut]:
    """2 minutes without an answer, declined, past the deadline, the visit's alerts: newest
    first."""
    return Mapped(selectors.alerts(open_only=open_only, kinds=kind), alert_out)


@router.post(
    "/alerts/{uuid:alert_id}/ack",
    response=AlertOut,
    by_alias=True,
    operation_id="adminAlertAck",
)
@staff_any_permission("bookings.manage", "live.manage")
def acknowledge(request: HttpRequest, alert_id: UUID) -> AlertOut:
    return alert_out(services.acknowledge(alert_id=str(alert_id), staff=acting_staff(request)))


# --- Partner performance report (Phase 9.2, §9.1 Reports) ---


def _performance(start: dt.date, end: dt.date) -> PartnerPerformanceOut:
    rows = [
        PartnerPerformanceRowOut(
            **{**row, "rating_avg": float(row["rating_avg"]) if row["rating_avg"] else None}
        )
        for row in selectors.partner_performance(start, end)
    ]
    return PartnerPerformanceOut(start=start, end=end, rows=rows)


@router.get(
    "/reports/partners",
    response=PartnerPerformanceOut,
    by_alias=True,
    operation_id="adminPartnerPerformanceReport",
)
@staff_permission("partners.view")
def partner_performance(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> PartnerPerformanceOut:
    """Each approved partner (and anyone else with work then): jobs done, patient not available,
    offers received / accepted / declined / not answered, acceptance %, rating. Default: this
    month so far."""
    return _performance(*report_range(start, end))


@router.get(
    "/reports/partners/csv",
    operation_id="adminPartnerPerformanceReportCsv",
    openapi_extra=CSV_OPENAPI,
)
@staff_permission("partners.view")
def partner_performance_csv(
    request: HttpRequest,
    start: dt.date | None = Query(None, alias="from"),  # noqa: B008
    end: dt.date | None = Query(None, alias="to"),  # noqa: B008
) -> HttpResponse:
    """The partner performance report as a CSV file. Logged."""
    report = _performance(*report_range(start, end))
    lines = [
        [
            r.name,
            r.role,
            r.status,
            r.jobs,
            r.no_show,
            r.offers_received,
            r.offers_accepted,
            r.offers_declined,
            r.offers_not_answered,
            "" if r.acceptance_percent is None else r.acceptance_percent,
            "" if r.rating_avg is None else r.rating_avg,
            r.rating_count,
        ]
        for r in report.rows
    ]
    record(
        acting_staff(request),
        "reports.exported",
        ("partners.partnerprofile", ""),
        after={
            "report": "partners",
            "from": report.start.isoformat(),
            "to": report.end.isoformat(),
        },
        ip=client_ip(request),
    )
    return csv_response(
        f"wellwish-partners-{report.start}-to-{report.end}.csv",
        [
            "Partner",
            "Role",
            "Status",
            "Jobs done",
            "Patient not available",
            "Offers",
            "Accepted",
            "Declined",
            "Not answered in 2 min",
            "Acceptance %",
            "Rating",
            "Reviews",
        ],
        lines,
    )
