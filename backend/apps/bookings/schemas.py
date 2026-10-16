"""Request/response schemas for bookings."""

import datetime as dt
from typing import Annotated, Literal
from uuid import UUID

from pydantic import AwareDatetime, Field, StringConstraints

from apps.payments.schemas import AdminPaymentOut, AdminRefundOut, BookingRefundOut
from apps.reviews.schemas import ReviewOut, TicketOut
from common.schemas import CamelSchema, Reason, StrictIn

HospitalText = Annotated[str, StringConstraints(strip_whitespace=True, max_length=200)]
Notes = Annotated[str, StringConstraints(strip_whitespace=True, max_length=500)]


# --- Booking times (§6.17) ---


class BookingDayOut(CamelSchema):
    date: dt.date
    available: bool = Field(..., description="False: blocked, full or no time left (greyed out)")


class BookingTimesOut(CamelSchema):
    date: dt.date = Field(..., description="The date the times are for")
    times: list[dt.datetime] = Field(..., description="Times that can be picked, soonest first")
    days: list[BookingDayOut] = Field(..., description="Every date in the booking window")
    time_step_min: int
    travel_buffer_min: int = Field(
        ..., description="Suggested pickup = doctor appointment minus this"
    )


# --- Create (P15) ---


class BookingIn(StrictIn):
    service_id: UUID
    member_id: UUID = Field(..., description="Who the booking is for")
    address_id: UUID = Field(..., description="Pickup or home address (inside a service area)")
    pickup_at: AwareDatetime = Field(..., description="One of the times from booking-times")
    appointment_at: AwareDatetime | None = Field(
        None, description="Hospital visits: the doctor appointment (same day, after pickup)"
    )
    hospital_id: UUID | None = None
    hospital_text: HospitalText = Field(
        "", description="Hospital not in the list: its name and area, typed in"
    )
    doctor_id: UUID | None = Field(None, description="A doctor at the chosen hospital")
    document_ids: list[UUID] = Field(default_factory=list, max_length=20)
    notes: Notes = ""


# --- Booking out (P15, P17, P18) ---


class BookingServiceOut(CamelSchema):
    """The price snapshot: what was booked and for how much, never changed afterwards."""

    name: str
    name_hi: str
    name_or: str
    partner_type: str
    visit_type: str
    duration_min: int
    docs_required: bool
    price_paise: int
    booking_fee_paise: int = Field(..., description="Paid online")
    balance_paise: int = Field(..., description="Paid to the partner after the visit")


class BookingMemberOut(CamelSchema):
    id: str | None = Field(None, description="Empty once the member is gone")
    full_name: str
    relation: str
    gender: str
    age: int | None
    phone: str
    language: str


class BookingAddressOut(CamelSchema):
    label: str
    line1: str
    landmark: str
    notes: str
    lat: str
    lng: str


class BookingDocumentOut(CamelSchema):
    id: str = Field(..., description="The attachment (stays when the document is deleted)")
    document_id: str | None
    type: str
    title: str
    removed: bool = Field(..., description="The patient deleted it after booking")


class BookingTimelineOut(CamelSchema):
    status: str
    event: str
    step: str = Field("", description="The job step (event START, STEP, COMPLETE)")
    at: dt.datetime


class BookingRowOut(CamelSchema):
    id: str
    code: str
    status: str
    service: BookingServiceOut
    member_name: str
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None
    hospital_name: str
    created_at: dt.datetime
    pay_by: dt.datetime | None = Field(None, description="Unpaid bookings expire at this time")


class AssignedPartnerOut(CamelSchema):
    """The partner who accepted (§6.15: name, photo, rating; the phone until the job ends)."""

    full_name: str
    role: str
    photo_url: str | None
    phone: str
    rating_avg: str | None
    rating_count: int


StepName = Literal[
    "ON_THE_WAY",
    "REACHED_PATIENT",
    "PICKED_UP",
    "REACHED_HOSPITAL",
    "VISIT_DONE",
    "DROPPED_HOME",
    "REACHED_HOME",
    "STARTED",
    "CARE_DONE",
    "AT_PLACE",
    "TASK_DONE",
    "DELIVERED",
    "COMPLETED",
]
Coordinate = Annotated[str, StringConstraints(pattern=r"^-?\d{1,3}(\.\d{1,8})?$")]


class StepDoneOut(CamelSchema):
    step: str
    at: dt.datetime
    by: str = Field(..., description="PARTNER, or STAFF when an admin marked it")
    far: bool = Field(..., description="Marked more than 300 m from the place")


class VisitOut(CamelSchema):
    """The job's steps (§6.11) for the partner's active job, the family and the admin."""

    steps: list[str] = Field(..., description="Every step of this visit type, in order")
    done: list[StepDoneOut]
    current_step: str
    next_step: str | None
    otp_step: str = Field(..., description="The step that needs the job OTP")
    otp_retry_at: dt.datetime | None = Field(
        None, description="After 4 wrong codes: the next try from then (5, 10, 20 min…)"
    )
    no_show_ready_at: dt.datetime | None = Field(
        None, description="From then, 'patient not available' (after a call attempt)"
    )
    balance_collected_paise: int | None
    balance_mode: str


class PlaceIn(StrictIn):
    """The phone's GPS when the partner taps (exact decimals travel as text, §10.3)."""

    lat: Coordinate | None = None
    lng: Coordinate | None = None
    accuracy: float | None = Field(None, ge=0, le=100000, description="Metres")
    client_ts: dt.datetime | None = Field(None, description="When it was tapped on the phone")
    mock: bool = Field(
        False, description="Android said it is a fake (mock) location: not kept, admin told"
    )


class VitalsIn(StrictIn):
    """Optional at "Care done" (§6.11)."""

    bp: str = Field("", max_length=7, pattern=r"^(\d{2,3}/\d{2,3})?$", description="e.g. 120/80")
    pulse: int | None = Field(None, ge=20, le=250)
    temperature_f: float | None = Field(None, ge=90, le=110, description="°F")
    spo2: int | None = Field(None, ge=50, le=100)
    sugar: int | None = Field(None, ge=20, le=700, description="mg/dL")


class StepIn(PlaceIn):
    step: StepName
    otp: str = Field("", max_length=4, pattern=r"^\d{0,4}$", description="At the OTP step")
    note: str = Field("", max_length=1000, description="The care note at CARE_DONE (nurses)")
    vitals: VitalsIn | None = None


class CallIn(StrictIn):
    to: Literal["MEMBER", "BOOKER"]


class BalanceIn(StrictIn):
    amount_paise: int = Field(..., ge=0, le=10_000_000)
    mode: Literal["CASH", "UPI"]
    note: str = Field("", max_length=200)


class AdminStepIn(StrictIn):
    step: StepName
    reason: Reason


class BookingDetailOut(BookingRowOut):
    member: BookingMemberOut
    address: BookingAddressOut
    hospital_id: str | None
    doctor_id: str | None
    doctor_name: str
    notes: str
    documents: list[BookingDocumentOut]
    timeline: list[BookingTimelineOut]
    paid_paise: int = Field(..., description="The booking fee captured (0 until paid)")
    refunds: list[BookingRefundOut]
    can_cancel: bool = Field(..., description="The patient can still cancel in the app")
    can_reschedule: bool
    reschedule_problem: str | None = Field(
        None, description="Why the time can't be changed: STATUS, TOO_LATE or LIMIT"
    )
    reschedules_left: int
    reconfirm_needed: bool = Field(..., description="The partner must confirm the new time")
    payment_pending: bool = Field(
        False, description="A payment is being confirmed with Razorpay (don't offer Pay)"
    )
    partner: AssignedPartnerOut | None = Field(
        None, description="Once a partner accepted (shown until the job is over)"
    )
    visit: VisitOut | None = Field(None, description="From acceptance: the job's steps")
    review: ReviewOut | None = Field(None, description="Your rating of the visit")
    can_review: bool = Field(False, description="Completed and not rated yet")
    can_report: bool = Field(False, description="Within 24 h after the visit")
    tickets: list[TicketOut] = Field(default_factory=list, description="Problems you reported")
    job_otp: str | None = Field(
        None, description="Give it to the partner when they arrive (until that step is done)"
    )


class CancelPreviewOut(CamelSchema):
    """Shown before cancelling (W-P4): what comes back."""

    allowed: bool
    paid_paise: int
    refund_percent: int
    refund_paise: int


class CancelIn(StrictIn):
    reason: Reason


class RescheduleIn(StrictIn):
    pickup_at: AwareDatetime
    appointment_at: AwareDatetime | None = None


class AdminCancelIn(StrictIn):
    reason: Reason
    refund_percent: int = Field(..., ge=0, le=100, description="Of the booking fee")


# --- Admin (§9.1 Bookings) ---


class AdminBookingRowOut(CamelSchema):
    id: str
    code: str
    status: str
    patient_deleted: bool = Field(..., description="The account was erased (§12)")
    service_name: str
    partner_type: str
    visit_type: str
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None
    member_name: str
    patient_phone: str
    hospital_name: str
    booking_fee_paise: int
    created_at: dt.datetime
    temporary_partner: bool = Field(
        False, description="§6.19: the partner is a temporary one (admin panel only)"
    )


class AdminBookingPatientOut(CamelSchema):
    id: str
    full_name: str
    phone: str


class AdminBookingEventOut(CamelSchema):
    from_status: str
    status: str
    event: str
    step: str = Field("", description="The job step (event START, STEP, COMPLETE)")
    actor_type: str
    note: str
    at: dt.datetime


class AdminBookingDetailOut(AdminBookingRowOut):
    service: BookingServiceOut
    patient: AdminBookingPatientOut
    member: BookingMemberOut
    address: BookingAddressOut
    hospital_id: str | None
    hospital_text: str
    doctor_id: str | None
    doctor_name: str
    notes: str = Field(..., description="Empty when notes_visible is false")
    notes_visible: bool = Field(
        ..., description="The patient's notes can be medical: only roles with patients.documents"
    )
    reschedule_count: int
    documents_visible: bool = Field(
        ..., description="False: the role can't see patient documents (titles hidden)"
    )
    documents: list[BookingDocumentOut]
    timeline: list[AdminBookingEventOut]
    reconfirm_needed: bool
    payments: list[AdminPaymentOut]
    refunds: list[AdminRefundOut]
    can_cancel: bool
    can_reschedule: bool
    time_step_min: int = Field(..., description="Pickup times are on this step (reschedule picker)")
    visit: VisitOut | None = Field(None, description="From acceptance: the job's steps")
    paid_paise: int = Field(..., description="The fee that paid for the booking")


# --- Reports (Phase 9.2) ---


class BookingsReportRowOut(CamelSchema):
    date: dt.date | None = Field(None, description="India date of the visit; null on the total")
    booked: int = Field(..., description="Paid bookings")
    completed: int
    cancelled: int
    no_show: int = Field(..., description="Patient not available")
    open: int = Field(..., description="Not finished yet")


class BookingsByServiceOut(CamelSchema):
    service: str
    booked: int
    completed: int
    cancelled: int
    no_show: int
    open: int


class BookingsReportOut(CamelSchema):
    """Bookings report (§9.1 Reports): paid bookings by visit date and by service."""

    start: dt.date
    end: dt.date
    days: list[BookingsReportRowOut]
    services: list[BookingsByServiceOut]
    total: BookingsReportRowOut
