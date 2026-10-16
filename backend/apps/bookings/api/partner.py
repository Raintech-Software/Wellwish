"""Partner endpoints for the visit (R12-R14, §6.11, §10.3): the next step with GPS (and the job
OTP or the care note), call attempts, "patient not available", the balance collected. Approved
partners only (the partner router's gate); another partner's booking is "not found"."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router, Status

from apps.assignments import selectors as assignment_selectors
from apps.assignments.api.partner import job_out
from apps.assignments.schemas import PartnerJobOut
from apps.bookings import visit
from apps.bookings.schemas import BalanceIn, CallIn, PlaceIn, StepIn
from common.auth import get_principal

router = Router(tags=["partner"])


def _place(data: PlaceIn) -> visit.Place:
    if data.mock:  # a fake location is never kept (§12); the step saves as "no position"
        return visit.Place(client_ts=data.client_ts, mock=True)
    return visit.Place(
        lat=float(data.lat) if data.lat else None,
        lng=float(data.lng) if data.lng else None,
        accuracy=data.accuracy,
        client_ts=data.client_ts,
    )


def _job(request: HttpRequest, booking_id: UUID) -> PartnerJobOut:
    user_id = get_principal(request).subject_id
    return job_out(assignment_selectors.own_job(user_id, str(booking_id)))


@router.post(
    "/bookings/{uuid:booking_id}/steps",
    response=PartnerJobOut,
    by_alias=True,
    operation_id="partnerJobStep",
)
def step(request: HttpRequest, booking_id: UUID, data: StepIn) -> PartnerJobOut:
    """R12: the next step. 409 STEP_OUT_OF_ORDER, 422 WRONG_OTP {triesLeft, retryAt?},
    409 OTP_WAIT {retryAt} (after 4 wrong codes: 5, 10, 20 min…), 409 TOO_EARLY_TO_START,
    422 CARE_NOTE_REQUIRED (nurses at CARE_DONE). Sending a step again does nothing."""
    visit.record_step(
        booking_id=str(booking_id),
        partner_user_id=get_principal(request).subject_id,
        step=data.step,
        place=_place(data),
        otp=data.otp,
        note=data.note,
        vitals=data.vitals.model_dump(exclude_defaults=True) if data.vitals else None,
    )
    return _job(request, booking_id)


@router.post(
    "/bookings/{uuid:booking_id}/calls",
    response={204: None},
    operation_id="partnerJobCall",
)
def call(request: HttpRequest, booking_id: UUID, data: CallIn) -> Status:
    """The partner tapped Call (kept on the timeline; needed before "patient not available")."""
    visit.log_call(
        booking_id=str(booking_id), partner_user_id=get_principal(request).subject_id, to=data.to
    )
    return Status(204, None)


@router.post(
    "/bookings/{uuid:booking_id}/patient-not-available",
    response=PartnerJobOut,
    by_alias=True,
    operation_id="partnerJobNoShow",
)
def patient_not_available(request: HttpRequest, booking_id: UUID, data: PlaceIn) -> PartnerJobOut:
    """15 minutes after arriving and after a call attempt (409 TOO_EARLY {readyAt, called}).
    The job ends; the admin reviews it."""
    visit.mark_no_show(
        booking_id=str(booking_id),
        partner_user_id=get_principal(request).subject_id,
        place=_place(data),
    )
    return _job(request, booking_id)


@router.post(
    "/bookings/{uuid:booking_id}/balance",
    response=PartnerJobOut,
    by_alias=True,
    operation_id="partnerJobBalance",
)
def balance(request: HttpRequest, booking_id: UUID, data: BalanceIn) -> PartnerJobOut:
    """R14: the balance collected (cash / UPI), after Completed; can be corrected for 24 h."""
    visit.record_balance(
        booking_id=str(booking_id),
        partner_user_id=get_principal(request).subject_id,
        amount_paise=data.amount_paise,
        mode=data.mode,
        note=data.note,
    )
    return _job(request, booking_id)
