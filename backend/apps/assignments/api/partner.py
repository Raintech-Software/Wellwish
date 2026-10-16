"""Partner app: Home R08, offer R09 (accept / decline), My bookings R10 and booking detail R11
(§6.10, §8.1). Approved partners only (the partner router's gate). The full address, phones,
health notes and documents are shown only for a job the partner accepted: phones until 1 hour
after completion, health notes and documents until 24 hours after (§6.14, §6.15, §12)."""

from typing import Literal
from uuid import UUID

from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.assignments import selectors, services
from apps.assignments.api.out import job_row, offer_summary
from apps.assignments.schemas import (
    DeclineIn,
    DocumentLinkOut,
    JobMemberOut,
    OfferSummaryOut,
    PartnerHomeOut,
    PartnerJobOut,
    PartnerJobRowOut,
    PartnerStatsOut,
    PartnerTotalsOut,
)
from apps.audit.services import record
from apps.bookings import selectors as booking_selectors
from apps.bookings.api.patient import address_out, documents_out, visit_out
from apps.bookings.models import Booking
from apps.files.services import view_url
from apps.partners import selectors as partner_selectors
from common.auth import get_principal
from common.errors import NotFound
from common.pagination import Mapped, WWPagination
from common.request import client_ip

router = Router(tags=["partner"])


@router.get("/home", response=PartnerHomeOut, by_alias=True, operation_id="partnerHome")
def home(request: HttpRequest) -> PartnerHomeOut:
    """R08: Available today, open offers (countdown from `timeoutAt`), today's jobs, totals."""
    user_id = get_principal(request).subject_id
    partner = selectors.partner_of(user_id)
    totals = selectors.partner_totals(user_id)
    return PartnerHomeOut(
        available_today=partner_selectors.is_available_today(partner),
        selfie_today=partner_selectors.selfie_today(str(partner.pk)) is not None,
        offers=[offer_summary(o) for o in selectors.partner_open_offers(user_id)],
        today=[job_row(b) for b in selectors.partner_today(user_id)],
        totals=PartnerTotalsOut(
            today=totals["today"], this_week=totals["this_week"], upcoming=totals["upcoming"]
        ),
    )


@router.get("/totals", response=PartnerStatsOut, by_alias=True, operation_id="partnerTotals")
def totals(request: HttpRequest) -> PartnerStatsOut:
    """R15 Totals (§6.13): jobs, balance collected, acceptance, rating and recent reviews."""
    from apps.reviews import selectors as review_selectors
    from apps.reviews.api.out import partner_review_out

    user_id = get_principal(request).subject_id
    stats = selectors.partner_stats(user_id)
    partner = selectors.partner_of(user_id)
    avg = stats.pop("rating_avg")
    return PartnerStatsOut(
        **stats,
        rating_avg=f"{avg:.1f}" if avg is not None else None,
        recent_reviews=[
            partner_review_out(r) for r in review_selectors.partner_reviews(str(partner.pk), 5)
        ],
    )


@router.get(
    "/offers", response=list[OfferSummaryOut], by_alias=True, operation_id="partnerOffersList"
)
def offers(request: HttpRequest) -> list[OfferSummaryOut]:
    """R10 "New": the open offers, soonest visit first."""
    return [
        offer_summary(o) for o in selectors.partner_open_offers(get_principal(request).subject_id)
    ]


@router.get(
    "/offers/{uuid:assignment_id}",
    response=OfferSummaryOut,
    by_alias=True,
    operation_id="partnerOfferGet",
)
def offer(request: HttpRequest, assignment_id: UUID) -> OfferSummaryOut:
    """R09 summary. 409 OFFER_NOT_OPEN on accept/decline once it was withdrawn."""
    return offer_summary(selectors.own_offer(get_principal(request).subject_id, str(assignment_id)))


@router.post(
    "/offers/{uuid:assignment_id}/accept",
    response=PartnerJobOut,
    by_alias=True,
    operation_id="partnerOfferAccept",
)
def accept(request: HttpRequest, assignment_id: UUID) -> PartnerJobOut:
    """Accept: the job is yours; the full details open (R11). 409 OFFER_NOT_OPEN ("no longer
    yours"), PARTNER_BUSY (another job then)."""
    user_id = get_principal(request).subject_id
    offer = services.accept(assignment_id=str(assignment_id), user_id=user_id)
    return job_out(selectors.own_job(user_id, str(offer.booking_id)))


@router.post(
    "/offers/{uuid:assignment_id}/decline",
    response=list[OfferSummaryOut],
    by_alias=True,
    operation_id="partnerOfferDecline",
)
def decline(request: HttpRequest, assignment_id: UUID, data: DeclineIn) -> list[OfferSummaryOut]:
    """Decline with a reason: the booking goes back to the admin. Returns the open offers left."""
    user_id = get_principal(request).subject_id
    services.decline(
        assignment_id=str(assignment_id), user_id=user_id, reason=data.reason, note=data.note
    )
    return [offer_summary(o) for o in selectors.partner_open_offers(user_id)]


@router.get("/jobs", response=list[PartnerJobRowOut], by_alias=True, operation_id="partnerJobsList")
@paginate(WWPagination)
def jobs(
    request: HttpRequest, bucket: Literal["upcoming", "completed"] = "upcoming"
) -> Mapped[PartnerJobRowOut]:
    """R10 Upcoming (accepted, soonest first) · Completed (latest first)."""
    return Mapped(selectors.partner_bookings(get_principal(request).subject_id, bucket), job_row)


def job_out(booking: Booking) -> PartnerJobOut:
    member = booking.member
    snapshot = booking.member_snapshot
    booker = booking.booked_by
    profile = getattr(booker, "patient_profile", None)
    row = job_row(booking)
    phones = booking_selectors.in_job_window(booking, booking_selectors.PHONES_AFTER_JOB)
    health = booking_selectors.in_job_window(booking, booking_selectors.DOCUMENTS_AFTER_JOB)
    return PartnerJobOut(
        **row.model_dump(),
        member=JobMemberOut(
            full_name=snapshot.get("full_name", ""),
            relation=snapshot.get("relation", ""),
            gender=snapshot.get("gender", ""),
            age=snapshot.get("age"),
            language=snapshot.get("language", ""),
            phone=snapshot.get("phone", "") if phones else "",
            photo_url=view_url(member.photo_key) if member and member.photo_key else None,
            mobility=member.mobility if member and health else "",
            conditions=member.conditions if member and health else "",
            allergies=member.allergies if member and health else "",
            sensory_notes=member.sensory_notes if member and health else "",
        ),
        booker_name=profile.full_name if profile else "",
        booker_phone=str(booker.phone) if phones and booker and booker.phone else "",
        address=address_out(booking.address_snapshot),
        hospital_text=booking.hospital_text,
        doctor_name=booking.doctor.full_name if booking.doctor else "",
        notes=booking.notes if health else "",
        documents=documents_out(booking) if health else [],
        balance_paise=int(booking.price_snapshot.get("balance_paise", 0)),
        visit=visit_out(booking),
    )


@router.get(
    "/jobs/{uuid:booking_id}", response=PartnerJobOut, by_alias=True, operation_id="partnerJobGet"
)
def job(request: HttpRequest, booking_id: UUID) -> PartnerJobOut:
    """R11: full details of a job the partner accepted (others are 404)."""
    return job_out(selectors.own_job(get_principal(request).subject_id, str(booking_id)))


@router.get(
    "/jobs/{uuid:booking_id}/documents/{uuid:link_id}/view-url",
    response=DocumentLinkOut,
    by_alias=True,
    operation_id="partnerJobDocumentUrl",
)
def job_document(request: HttpRequest, booking_id: UUID, link_id: UUID) -> DocumentLinkOut:
    """A 5-minute link to an attached document, from acceptance until 24 hours after completion
    (§6.8, §12). Every view is logged."""
    user_id = get_principal(request).subject_id
    booking = selectors.own_job(user_id, str(booking_id))
    if not booking_selectors.in_job_window(booking, booking_selectors.DOCUMENTS_AFTER_JOB):
        raise NotFound()
    link = booking.documents.select_related("document").filter(pk=link_id).first()
    document = link.document if link else None
    if link is None or document is None or document.deleted_at is not None or not document.file_key:
        raise NotFound()
    record(
        None,
        "partner.document_viewed",
        link,
        after={"partnerUserId": user_id, "bookingId": str(booking.pk)},
        ip=client_ip(request),
    )
    return DocumentLinkOut(url=view_url(document.file_key), mime=document.mime)
