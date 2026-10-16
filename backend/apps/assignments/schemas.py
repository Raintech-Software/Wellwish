"""API shapes for assignments (§6.10, §8.1 R08-R11, §9.1 Bookings)."""

import datetime as dt
from typing import Any, Literal

from pydantic import Field

from apps.bookings.schemas import (
    BookingAddressOut,
    BookingDocumentOut,
    BookingServiceOut,
    VisitOut,
)
from apps.reviews.schemas import PartnerReviewOut
from common.schemas import CamelSchema, Reason, StrictIn

# --- Admin ---


class OfferBriefOut(CamelSchema):
    assignment_id: str
    kind: str
    partner_id: str
    partner_name: str
    sent_at: dt.datetime
    timeout_at: dt.datetime


class QueueRowOut(CamelSchema):
    """A row of the Unassigned queue (§6.17): red when past the assign deadline."""

    id: str
    code: str
    status: str
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None
    service_name: str
    partner_type: str
    visit_type: str
    member_name: str
    hospital_name: str
    deadline_at: dt.datetime
    late: bool = Field(..., description="Past the assign deadline")
    offer: OfferBriefOut | None
    open_alerts: int
    problem: str = Field(
        "",
        description="Why an ACCEPTED booking is here: RECONFIRM (new time not confirmed) or "
        "PARTNER_UNAVAILABLE (the partner was suspended)",
    )


class QueueCountsOut(CamelSchema):
    today: int
    tomorrow: int
    later: int


class CandidateOut(CamelSchema):
    """The assign dialog's suggestion list (§6.10): free partners of the right type."""

    partner_id: str
    full_name: str
    photo_url: str | None
    gender: str
    languages: list[str]
    skills: list[str]
    rating_avg: str | None
    rating_count: int
    distance_km: float | None
    available_today: bool
    jobs_this_week: int
    phone: str
    alternate_phone: str
    offered_now: bool


class AssignIn(StrictIn):
    partner_id: str = Field(..., max_length=40)
    expected_assignment_id: str | None = Field(
        ...,
        max_length=40,
        description="The open offer the admin saw (null: none). Another admin changed it: 409 "
        "OFFER_CHANGED (§6.16)",
    )


class TemporaryAssignIn(StrictIn):
    """§6.19 (v2.17): nobody free; the admin phoned this person and checked their ID."""

    phone: str = Field(..., max_length=20, description="Their mobile: the partner app login")
    full_name: str = Field(..., min_length=2, max_length=80)
    gender: Literal["FEMALE", "MALE", "OTHER"]
    id_type: Literal["AADHAAR", "DRIVING_LICENCE", "VOTER_ID", "PAN"]
    id_last4: str = Field(
        ..., pattern=r"^[0-9A-Za-z]{4}$", description="The last 4 characters only, never more"
    )
    id_photo_key: str = Field(
        ..., max_length=255, description="From /admin/files/upload-url, purpose temp_partner_id"
    )
    nursing_reg_no: str = Field("", max_length=40, description="Nurse bookings: as printed")
    reason: Reason = Field(..., description="Why no regular partner could take it")
    id_checked: bool = Field(
        ..., description='"I\'ve called this person and checked their ID against the photo"'
    )
    expected_assignment_id: str | None = Field(
        ..., max_length=40, description="The open offer the admin saw (null: none)"
    )


class TemporaryEndIn(StrictIn):
    reason: Reason = Field(..., description="Why the access ends now (logged)")


class TemporaryPartnerOut(CamelSchema):
    """The ID card on the booking page (§6.19): admins only."""

    partner_id: str
    full_name: str
    phone: str
    status: str = Field(..., description="TEMPORARY while the job runs, then TEMP_ENDED")
    id_type: str
    id_last4: str
    nursing_reg_no: str
    reason: str
    checked_by: str
    checked_at: dt.datetime
    ended_at: dt.datetime | None
    end_reason: str
    selfie_url: str | None = Field(
        None, description="Their selfie for this job (taken on the visit day), once taken"
    )


class FileLinkOut(CamelSchema):
    url: str
    mime: str


class AdminNoteIn(StrictIn):
    reason: Reason
    expected_assignment_id: str | None = Field(
        ...,
        max_length=40,
        description="The offer or accepted job the admin saw (`currentAssignmentId`). Changed "
        "meanwhile: 409 OFFER_CHANGED",
    )


class OfferOut(CamelSchema):
    id: str
    kind: str
    partner_id: str
    partner_name: str
    phone: str
    alternate_phone: str
    assigned_by: str
    sent_at: dt.datetime
    timeout_at: dt.datetime
    response: str
    responded_at: dt.datetime | None
    decline_reason: str
    decline_note: str


class AlertOut(CamelSchema):
    id: str
    kind: str
    booking_id: str
    booking_code: str
    pickup_at: dt.datetime
    details: dict[str, Any]
    created_at: dt.datetime
    acknowledged_at: dt.datetime | None
    partner_name: str
    phone: str = Field(..., description="The offered partner's primary phone (call button)")
    alternate_phone: str


class AssignedPartnerBriefOut(CamelSchema):
    partner_id: str
    full_name: str
    phone: str
    alternate_phone: str
    photo_url: str | None


class AssignmentStateOut(CamelSchema):
    """The booking page's assignment card: deadline, the open offer (2-minute countdown), the
    accepted partner, every offer so far and the open alerts."""

    booking_id: str
    status: str
    deadline_at: dt.datetime
    late: bool
    can_assign: bool
    can_unassign: bool
    current_assignment_id: str | None = Field(
        ..., description="Send back as `expectedAssignmentId` (assign, accepted by phone, unassign)"
    )
    open_offer: OfferOut | None
    partner: AssignedPartnerBriefOut | None
    reconfirm_needed: bool
    offers: list[OfferOut]
    alerts: list[AlertOut]


# --- Partner app ---


class OfferSummaryOut(CamelSchema):
    """R09: what the partner sees before accepting (no full address, no phones, no health
    notes or documents: those open after accepting)."""

    assignment_id: str
    kind: str = Field(..., description="NEW, or RECONFIRM: confirm the new time")
    response: str = Field(
        ...,
        description="OPEN (answer it), ACCEPTED / ACCEPTED_BY_PHONE (the job is theirs), "
        "DECLINED or WITHDRAWN (no longer theirs)",
    )
    booking_id: str
    code: str
    service: BookingServiceOut
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None
    area: str = Field(..., description="Locality only (no house number)")
    distance_km: float | None
    hospital_name: str
    member_age: int | None
    member_gender: str
    language: str
    mobility: str
    documents_attached: int
    has_prescription: bool
    balance_paise: int
    sent_at: dt.datetime
    timeout_at: dt.datetime


class PartnerJobRowOut(CamelSchema):
    id: str
    code: str
    status: str
    service: BookingServiceOut
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None
    member_name: str
    hospital_name: str
    area: str
    reconfirm_needed: bool


class PartnerTotalsOut(CamelSchema):
    today: int
    this_week: int
    upcoming: int


class JobCountsOut(CamelSchema):
    today: int
    this_week: int
    this_month: int
    all_time: int


class BalanceSumOut(CamelSchema):
    cash_paise: int
    upi_paise: int


class PartnerStatsOut(CamelSchema):
    """R15 Totals (§6.13). The balance is what the partner recorded (WellWish doesn't handle it)."""

    jobs: JobCountsOut
    balance_week: BalanceSumOut
    balance_month: BalanceSumOut
    balance_all: BalanceSumOut
    offers_received: int
    offers_accepted: int
    offers_declined: int
    offers_not_answered: int = Field(..., description="Not answered within 2 minutes")
    rating_avg: str | None
    rating_count: int
    recent_reviews: list[PartnerReviewOut]
    upcoming: int


class PartnerHomeOut(CamelSchema):
    """R08 Home: availability, open offers (with the countdown), today's jobs, quick totals."""

    available_today: bool
    selfie_today: bool
    offers: list[OfferSummaryOut]
    today: list[PartnerJobRowOut]
    totals: PartnerTotalsOut


class JobMemberOut(CamelSchema):
    full_name: str
    relation: str
    gender: str
    age: int | None
    language: str
    phone: str
    photo_url: str | None
    mobility: str
    conditions: str = Field(..., description="Health notes: only the assigned partner sees them")
    allergies: str
    sensory_notes: str


class PartnerJobOut(PartnerJobRowOut):
    """R11 Booking detail, for the partner who accepted it."""

    member: JobMemberOut
    booker_name: str
    booker_phone: str
    address: BookingAddressOut
    hospital_text: str
    doctor_name: str
    notes: str
    documents: list[BookingDocumentOut]
    balance_paise: int
    visit: VisitOut | None = Field(None, description="R12: the job's steps")


class DeclineIn(StrictIn):
    reason: Literal["NOT_AVAILABLE", "TOO_FAR", "OTHER"]
    note: str = Field("", max_length=200)


class DocumentLinkOut(CamelSchema):
    url: str
    mime: str


class PartnerPerformanceRowOut(CamelSchema):
    partner_id: str
    name: str
    role: str
    status: str
    jobs: int = Field(..., description="Visits completed on these dates")
    no_show: int = Field(..., description="Patient not available")
    offers_received: int
    offers_accepted: int
    offers_declined: int
    offers_not_answered: int = Field(..., description="Not answered within 2 minutes")
    acceptance_percent: int | None = Field(None, description="Accepted / received; none: no offers")
    rating_avg: float | None = None
    rating_count: int


class PartnerPerformanceOut(CamelSchema):
    """Partner performance report (§9.1 Reports)."""

    start: dt.date
    end: dt.date
    rows: list[PartnerPerformanceRowOut]
