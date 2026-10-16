"""The visit (ARCHITECTURE §6.11): job steps with GPS, the job OTP, call attempts, patient not
available, the nurse's care note and the balance collected. These are the bookings app's writes
for Phase 8 (`services.py` holds the booking itself: create, pay, cancel, reschedule).

- Steps follow the service's visit type, one after the other. "On the way" starts the job
  (ACCEPTED → IN_PROGRESS) and "Completed" ends it (→ COMPLETED); the steps between are
  timeline rows (`event="STEP"`) and `bookings.current_step`.
- A step sent twice (the app retrying after a network drop) is accepted once and ignored after.
- Arriving more than 300 m from the place still saves, flagged for the admin (indoor GPS).
- The job OTP is created when the partner accepts: 4 digits, stored as a hash (to check) and
  encrypted (to show the owner); never logged. After 4 wrong tries the partner waits before the
  next one (5, 10, 20, 40, at most 60 min) and the admin is alerted; the admin can mark the step
  any time after confirming by phone (logged).
"""

import datetime as dt
import hashlib
import hmac
import logging
import secrets
from dataclasses import dataclass
from typing import Any

from django.conf import settings
from django.db import transaction
from django.db.models import F
from django.utils import timezone

from apps.bookings.models import ActorType, Booking, BookingEvent, BookingStatus
from apps.bookings.services import SYSTEM, Actor, transition
from apps.services.models import VisitType
from common import crypto, events, realtime
from common.errors import ApiError, Conflict, NotFound
from common.geo import haversine_km
from common.ids import uid

logger = logging.getLogger(__name__)

S = BookingStatus


class Step:
    ON_THE_WAY = "ON_THE_WAY"
    REACHED_PATIENT = "REACHED_PATIENT"
    PICKED_UP = "PICKED_UP"
    REACHED_HOSPITAL = "REACHED_HOSPITAL"
    VISIT_DONE = "VISIT_DONE"
    DROPPED_HOME = "DROPPED_HOME"
    REACHED_HOME = "REACHED_HOME"
    STARTED = "STARTED"
    CARE_DONE = "CARE_DONE"
    AT_PLACE = "AT_PLACE"  # at the hospital / pharmacy (errand)
    TASK_DONE = "TASK_DONE"
    DELIVERED = "DELIVERED"
    COMPLETED = "COMPLETED"


# §6.11: the steps of each visit type, in order, and the one that needs the job OTP.
STEPS: dict[str, tuple[str, ...]] = {
    VisitType.HOSPITAL_VISIT: (
        Step.ON_THE_WAY,
        Step.REACHED_PATIENT,
        Step.PICKED_UP,
        Step.REACHED_HOSPITAL,
        Step.VISIT_DONE,
        Step.DROPPED_HOME,
        Step.COMPLETED,
    ),
    VisitType.HOME_VISIT: (
        Step.ON_THE_WAY,
        Step.REACHED_HOME,
        Step.STARTED,
        Step.CARE_DONE,
        Step.COMPLETED,
    ),
    VisitType.ERRAND: (
        Step.ON_THE_WAY,
        Step.AT_PLACE,
        Step.TASK_DONE,
        Step.DELIVERED,
        Step.COMPLETED,
    ),
}
OTP_STEP = {
    VisitType.HOSPITAL_VISIT: Step.PICKED_UP,
    VisitType.HOME_VISIT: Step.STARTED,
    VisitType.ERRAND: Step.DELIVERED,
}
# Arriving somewhere: checked against the place (more than 300 m away = flagged, not refused).
ARRIVALS = {
    Step.REACHED_PATIENT: "home",
    Step.REACHED_HOME: "home",
    Step.REACHED_HOSPITAL: "hospital",
    Step.AT_PLACE: "hospital",
}
# After these, "patient not available" becomes possible (15 minutes and a call attempt).
WAIT_STEPS = (Step.REACHED_PATIENT, Step.REACHED_HOME)
FAR_METRES = 300
# Wrong job codes (§6.11, developer decision 12 Oct 2026): 4 tries, then a wait before the next
# one that doubles with each further wrong code (5, 10, 20, 40 min, at most 60). Never a hard
# lock: the admin can mark the step after a call at any time.
OTP_FREE_TRIES = 4
OTP_FIRST_WAIT = dt.timedelta(minutes=5)
OTP_MAX_WAIT = dt.timedelta(minutes=60)
WAIT_MINUTES = 15


class StepOutOfOrder(Conflict):
    code = "STEP_OUT_OF_ORDER"
    message = "Please do the steps in order."


class WrongOtp(ApiError):
    status = 422
    code = "WRONG_OTP"
    message = "That code isn't right. Ask the patient for the code in their WellWish app or SMS."


class OtpWait(Conflict):
    code = "OTP_WAIT"
    message = "Too many wrong codes. Try again later, or call WellWish to confirm with the family."


class OtpRequired(ApiError):
    status = 422
    code = "OTP_REQUIRED"
    message = "Enter the 4-digit code from the patient."


class CareNoteRequired(ApiError):
    status = 422
    code = "CARE_NOTE_REQUIRED"
    message = "Please write a short care note."


class TooEarly(Conflict):
    code = "TOO_EARLY"
    message = "Wait 15 minutes after arriving and try calling the patient first."


class TooEarlyToStart(Conflict):
    code = "TOO_EARLY_TO_START"
    message = "It's too early to start this job."


def start_from(booking: Booking) -> dt.datetime:
    """The earliest "On the way" (§6.11): a few hours before the pickup time."""
    return booking.pickup_at - dt.timedelta(hours=settings.JOB_START_BEFORE_HOURS)


class NotYourJob(NotFound):
    pass


class SelfieRequired(Conflict):
    code = "SELFIE_REQUIRED"
    message = "Take today's selfie before you start."


def _temporary_without_selfie(booking: Booking) -> bool:
    """§6.19: a temporary partner takes a live selfie on the day before "On the way"."""
    from apps.partners import selectors as partners

    partner = booking.partner
    return (
        partner is not None
        and partner.status == "TEMPORARY"
        and partners.selfie_today(str(partner.pk)) is None
    )


@dataclass(frozen=True)
class Place:
    """Where the partner says they are (from the phone's GPS)."""

    lat: float | None = None
    lng: float | None = None
    accuracy: float | None = None
    client_ts: dt.datetime | None = None
    mock: bool = False  # a fake location (§12): its position is never kept, the admin is told


def steps_for(booking: Booking) -> tuple[str, ...]:
    return STEPS.get(booking.price_snapshot.get("visit_type", ""), STEPS[VisitType.HOME_VISIT])


def otp_step(booking: Booking) -> str:
    return OTP_STEP.get(booking.price_snapshot.get("visit_type", ""), Step.STARTED)


def next_step(booking: Booking) -> str | None:
    """The step the partner taps next (None when the job is over or not theirs yet)."""
    if booking.status not in (S.ACCEPTED, S.IN_PROGRESS):
        return None
    steps = steps_for(booking)
    if not booking.current_step:
        return steps[0]
    index = steps.index(booking.current_step) if booking.current_step in steps else -1
    return steps[index + 1] if 0 <= index < len(steps) - 1 else None


def done_steps(booking: Booking) -> tuple[str, ...]:
    steps = steps_for(booking)
    if booking.current_step not in steps:
        return ()
    return steps[: steps.index(booking.current_step) + 1]


# --- Job OTP ---


def _otp_hash(booking: Booking, otp: str) -> str:
    message = f"job-otp:{booking.pk}:{otp}".encode()
    return hmac.new(settings.OTP_HMAC_KEY.encode(), message, hashlib.sha256).hexdigest()


def issue_job_otp(booking: Booking) -> None:
    """When the partner accepts (§6.11): a new 4-digit code. The owner sees it in the app; the
    member's own phone gets it by SMS (the notifications app decrypts it there)."""
    otp = f"{secrets.randbelow(10000):04d}"
    Booking.objects.filter(pk=booking.pk).update(
        otp_hash=_otp_hash(booking, otp), otp_enc=crypto.encrypt(otp), otp_attempts=0
    )
    booking.otp_hash, booking.otp_attempts = _otp_hash(booking, otp), 0
    events.publish("booking.otp", {"booking_id": str(booking.pk)})


def job_otp(booking: Booking) -> str | None:
    """For the owner's app: until the OTP step is done."""
    if booking.status not in (S.ACCEPTED, S.IN_PROGRESS) or not booking.otp_enc:
        return None
    if otp_step(booking) in done_steps(booking):
        return None
    try:
        return crypto.decrypt(booking.otp_enc)
    except Exception:  # a changed encryption key: no code to show
        logger.warning("Job OTP could not be decrypted for a booking")
        return None


def otp_retry_at(booking: Booking) -> dt.datetime | None:
    """While the partner must wait after wrong codes: when they can try again."""
    retry = booking.otp_retry_at
    return retry if retry is not None and retry > timezone.now() else None


def _otp_wait(wrong_tries: int) -> dt.timedelta | None:
    """The wait after this many wrong codes (none for the first 3)."""
    if wrong_tries < OTP_FREE_TRIES:
        return None
    # capped before multiplying: a huge power of two would overflow timedelta (a 500 that rolls
    # back the counter, so the wait would stop working)
    doublings = min(wrong_tries - OTP_FREE_TRIES, 4)
    return min(OTP_FIRST_WAIT * 2**doublings, OTP_MAX_WAIT)


def _otp_ok(booking: Booking, otp: str) -> bool:
    return bool(booking.otp_hash) and hmac.compare_digest(
        _otp_hash(booking, otp.strip()), booking.otp_hash
    )


def _wrong_try(booking: Booking) -> ApiError:
    """One more wrong try, saved under the booking's row lock (so guesses sent in parallel wait
    and see the new count). From the 4th, a wait before the next try (5, 10, 20 min…); the first
    wait alerts the admin. Returns the error to raise once the transaction has committed."""
    Booking.objects.filter(pk=booking.pk).update(otp_attempts=F("otp_attempts") + 1)
    booking.refresh_from_db(fields=["otp_attempts"])
    wait = _otp_wait(booking.otp_attempts)
    if wait is None:
        return WrongOtp(details={"triesLeft": OTP_FREE_TRIES - booking.otp_attempts})
    booking.otp_retry_at = timezone.now() + wait
    booking.save(update_fields=["otp_retry_at", "updated_at"])
    from apps.assignments import services as assignments

    assignments.raise_alert(  # once while open
        booking,
        "OTP_LOCKED",
        {"partner": booking.partner.full_name if booking.partner else ""},
    )
    return WrongOtp(details={"triesLeft": 0, "retryAt": booking.otp_retry_at.isoformat()})


# --- Steps ---


def _lock_own(booking_id: str, partner_user_id: str) -> Booking:
    booking = (
        Booking.objects.select_for_update(of=("self",))
        .select_related("partner")
        .filter(pk=uid(booking_id), partner__user_id=uid(partner_user_id))
        .first()
    )
    if booking is None:
        raise NotYourJob()
    return booking


def _target(booking: Booking, kind: str) -> tuple[float, float] | None:
    if kind == "home":
        lat, lng = booking.address_snapshot.get("lat"), booking.address_snapshot.get("lng")
    else:
        hospital = booking.hospital
        if hospital is None:
            return None
        lat, lng = hospital.lat, hospital.lng
    try:
        return (float(lat), float(lng)) if lat not in (None, "") and lng not in (None, "") else None
    except (TypeError, ValueError):
        return None


def _far(booking: Booking, step: str, place: Place) -> float | None:
    """Metres from the place for an arrival step (None: not an arrival, or unknown)."""
    kind = ARRIVALS.get(step)
    if kind is None or place.lat is None or place.lng is None:
        return None
    target = _target(booking, kind)
    if target is None:
        return None
    return haversine_km(place.lat, place.lng, target[0], target[1]) * 1000


def _event_fields(step: str, place: Place, far: bool) -> dict[str, Any]:
    """The timeline row's place and time. Vitals go only into the care note (a document the
    family can delete), never on the timeline."""
    return {
        "step": step,
        "lat": round(place.lat, 6) if place.lat is not None else None,
        "lng": round(place.lng, 6) if place.lng is not None else None,
        "accuracy": place.accuracy,
        "client_ts": place.client_ts,
        "far_from_target": far,
    }


def _announce(booking: Booking, step: str, *, by_staff: bool = False) -> None:
    """The family's app and the admins' live map hear about the step (after commit); and the
    partner's app when an admin marked it (it reloads the job, and stops sharing at the end)."""
    patient_group = realtime.user_group("patient", str(booking.booked_by_id))
    data = {"bookingId": str(booking.pk), "status": booking.status, "step": step}
    staff = {"bookingId": str(booking.pk), "code": booking.code, "step": step}
    partner_user = (
        str(booking.partner.user_id) if by_staff and booking.partner is not None else None
    )

    def send() -> None:
        realtime.send_to_group(patient_group, "booking.updated", data)
        realtime.send_to_group("staff.ops", "job.step", staff)
        if partner_user:
            realtime.send_to_group(
                realtime.user_group("partner", partner_user), "booking.updated", data
            )

    transaction.on_commit(send, robust=True)
    events.publish("booking.step_changed", {"booking_id": str(booking.pk), "step": step})


def _flag_mock(booking: Booking) -> None:
    from apps.tracking import services as tracking

    tracking.flag_mock(booking)


def _apply_step(
    booking: Booking,
    step: str,
    actor: Actor,
    place: Place,
    *,
    note: str = "",
) -> Booking:
    metres = _far(booking, step, place)
    # An arrival marked by the partner without a position is flagged too (§6.11).
    unplaced = (
        actor.type == ActorType.PARTNER
        and step in ARRIVALS
        and (place.lat is None or place.lng is None)
    )
    far = (metres is not None and metres > FAR_METRES) or unplaced
    fields = _event_fields(step, place, far)
    if step == Step.ON_THE_WAY:
        transition(
            booking,
            "START",
            actor,
            note=note,
            extra_updates={"current_step": step},
            event_fields=fields,
        )
    elif step == Step.COMPLETED:
        transition(
            booking,
            "COMPLETE",
            actor,
            note=note,
            extra_updates={"current_step": step},
            event_fields=fields,
        )
        events.publish("booking.completed", {"booking_id": str(booking.pk)})
    else:
        Booking.objects.filter(pk=booking.pk).update(
            current_step=step, version=F("version") + 1, updated_at=timezone.now()
        )
        BookingEvent.objects.create(
            booking=booking,
            from_status=booking.status,
            to_status=booking.status,
            event="STEP",
            actor_type=actor.type,
            actor_id=uid(actor.id) if actor.id else None,
            server_ts=timezone.now(),
            note=note[:300],
            **fields,
        )
    booking.refresh_from_db()
    if place.mock and actor.type == ActorType.PARTNER:
        _flag_mock(booking)
    if far:
        from apps.assignments import services as assignments

        assignments.raise_alert(
            booking,
            "FAR_STEP",
            {"step": step, "metres": round(metres) if metres is not None else None},
            once=False,
        )
    if step == Step.ON_THE_WAY:
        from apps.assignments import services as assignments

        assignments.close_alerts(booking, "NOT_STARTED")  # late, but on the way now
    if step == otp_step(booking):
        from apps.assignments import services as assignments

        assignments.close_alerts(booking, "OTP_LOCKED")  # the code step is done (or marked)
    _announce(booking, step, by_staff=actor.type == ActorType.STAFF)
    return booking


def record_step(
    *,
    booking_id: str,
    partner_user_id: str,
    step: str,
    place: Place,
    otp: str = "",
    note: str = "",
    vitals: dict[str, Any] | None = None,
) -> Booking:
    """R12: the partner taps the next step (§6.11). Same step again (an offline retry): no-op."""
    wrong: ApiError | None = None
    with transaction.atomic():
        booking = _lock_own(booking_id, partner_user_id)
        if step in done_steps(booking):
            return booking  # already saved (the app sent it twice)
        if step != next_step(booking):
            raise StepOutOfOrder(details={"expected": next_step(booking) or ""})
        if step == Step.ON_THE_WAY and timezone.now() < start_from(booking):
            raise TooEarlyToStart(details={"from": start_from(booking).isoformat()})
        if step == Step.ON_THE_WAY and _temporary_without_selfie(booking):
            raise SelfieRequired()
        if step == otp_step(booking):
            retry = otp_retry_at(booking)
            if retry is not None:
                raise OtpWait(details={"retryAt": retry.isoformat()})
            if len(otp.strip()) != 4:
                raise OtpRequired()  # a missing code is a client mistake, not a wrong try
            if not _otp_ok(booking, otp):
                wrong = _wrong_try(booking)  # saved with this transaction, raised after it
        if wrong is None:
            care_note = ""
            if step == Step.CARE_DONE:
                care_note = note.strip()
                nurse = booking.partner is not None and booking.partner.role == "NURSE"
                if nurse and len(care_note) < 3:
                    raise CareNoteRequired()
            actor = Actor(ActorType.PARTNER, str(partner_user_id))
            booking = _apply_step(
                booking, step, actor, place, note="" if step == Step.CARE_DONE else note
            )
            if step == Step.CARE_DONE and (care_note or vitals) and booking.member_id:
                from apps.documents import services as documents

                documents.add_care_note(
                    member_id=str(booking.member_id),
                    booking_code=booking.code,
                    text=care_note,
                    vitals=vitals,
                    written_by=str(partner_user_id),
                )
    if wrong is not None:
        raise wrong
    return booking


def admin_step(*, booking_id: str, staff: Any, step: str, note: str, ip: str | None) -> Booking:
    """The admin marks the next step for the partner (§6.11: no network at the door, the OTP
    locked, the phone died), after confirming by phone. No OTP, no GPS. Logged."""
    from apps.audit.services import record

    with transaction.atomic():
        booking = (
            Booking.objects.select_for_update(of=("self",))
            .select_related("partner")
            .filter(pk=uid(booking_id))
            .first()
        )
        if booking is None:
            raise NotFound()
        if step != next_step(booking):
            raise StepOutOfOrder(details={"expected": next_step(booking) or ""})
        booking = _apply_step(
            booking, step, Actor(ActorType.STAFF, str(staff.pk)), Place(), note=note
        )
        record(
            staff,
            "booking.step_marked",
            ("bookings.booking", str(booking.pk)),
            after={"step": step},
            reason=note,
            ip=ip,
        )
        return booking


# --- Patient not available (§6.11) ---


def log_call(*, booking_id: str, partner_user_id: str, to: str) -> None:
    """The partner tapped Call (the member or the person who booked): kept on the timeline;
    "patient not available" needs one after arriving."""
    with transaction.atomic():
        booking = _lock_own(booking_id, partner_user_id)
        if booking.status not in (S.ACCEPTED, S.IN_PROGRESS):
            raise StepOutOfOrder()
        BookingEvent.objects.create(
            booking=booking,
            from_status=booking.status,
            to_status=booking.status,
            event="CALL",
            note=to[:20],
            actor_type=ActorType.PARTNER,
            actor_id=uid(partner_user_id),
            server_ts=timezone.now(),
        )


def _arrived_at(booking: Booking) -> dt.datetime | None:
    return (
        BookingEvent.objects.filter(booking=booking, step__in=WAIT_STEPS)
        .order_by("-server_ts")
        .values_list("server_ts", flat=True)
        .first()
    )


def no_show_ready_at(booking: Booking) -> dt.datetime | None:
    """When "patient not available" becomes possible (15 minutes after arriving)."""
    if booking.status != S.IN_PROGRESS or booking.current_step not in WAIT_STEPS:
        return None
    arrived = _arrived_at(booking)
    return arrived + dt.timedelta(minutes=WAIT_MINUTES) if arrived else None


def mark_no_show(
    *, booking_id: str, partner_user_id: str, place: Place, now: dt.datetime | None = None
) -> Booking:
    """The patient isn't there 15 minutes after arriving and didn't answer the call: the job
    ends as PATIENT_NO_SHOW (no refund) and the admin reviews it."""
    now = now or timezone.now()
    with transaction.atomic():
        booking = _lock_own(booking_id, partner_user_id)
        ready = no_show_ready_at(booking)
        if ready is None:
            raise StepOutOfOrder()
        called = BookingEvent.objects.filter(
            booking=booking, event="CALL", server_ts__gte=_arrived_at(booking)
        ).exists()
        if now < ready or not called:
            raise TooEarly(details={"readyAt": ready.isoformat(), "called": called})
        transition(
            booking,
            "NO_SHOW",
            Actor(ActorType.PARTNER, str(partner_user_id)),
            event_fields=_event_fields(booking.current_step, place, False),
        )
        booking.refresh_from_db()
        if place.mock:
            _flag_mock(booking)
        from apps.assignments import services as assignments

        assignments.raise_alert(
            booking,
            "NO_SHOW",
            {"partner": booking.partner.full_name if booking.partner else ""},
        )
        _announce(booking, "PATIENT_NO_SHOW")
        events.publish("booking.no_show", {"booking_id": str(booking.pk)})
        return booking


# --- Balance collected (§6.11, §6.13) ---


class BalanceNotNow(Conflict):
    code = "BALANCE_NOT_NOW"
    message = "The balance is recorded after the job is completed."


class BalanceNotDue(Conflict):
    code = "BALANCE_NOT_DUE"
    message = "Nothing is due: the family paid the full price in the app."


class BalanceTooHigh(ApiError):
    status = 422
    code = "BALANCE_TOO_HIGH"
    message = "That's more than the balance due."


BALANCE_EDIT_HOURS = 24


def record_balance(
    *, booking_id: str, partner_user_id: str, amount_paise: int, mode: str, note: str
) -> Booking:
    """R14: what the partner collected (cash / UPI), only a record: WellWish doesn't handle this
    money. Can be corrected for 24 hours after the job."""
    with transaction.atomic():
        booking = _lock_own(booking_id, partner_user_id)
        if booking.status != S.COMPLETED:
            raise BalanceNotNow()
        due = int(booking.price_snapshot.get("balance_paise", 0))
        if due <= 0:
            raise BalanceNotDue()
        if amount_paise > due:
            raise BalanceTooHigh(details={"duePaise": due})
        completed = (
            BookingEvent.objects.filter(booking=booking, to_status=S.COMPLETED)
            .order_by("-server_ts")
            .values_list("server_ts", flat=True)
            .first()
        )
        if completed and timezone.now() - completed > dt.timedelta(hours=BALANCE_EDIT_HOURS):
            raise BalanceNotNow(message="The balance can't be changed 24 hours after the job.")
        Booking.objects.filter(pk=booking.pk).update(
            balance_collected_paise=amount_paise, balance_mode=mode, updated_at=timezone.now()
        )
        BookingEvent.objects.create(
            booking=booking,
            from_status=booking.status,
            to_status=booking.status,
            event="BALANCE",
            note=f"{mode} {amount_paise}{(': ' + note) if note else ''}"[:300],
            actor_type=ActorType.PARTNER,
            actor_id=uid(partner_user_id),
            server_ts=timezone.now(),
        )
        booking.refresh_from_db()
        return booking


# --- Watch (§10.5) ---

NOT_COMPLETED_AFTER = dt.timedelta(hours=1)


def not_completed_sweep(*, now: dt.datetime | None = None) -> int:
    """Every 10 minutes: the last step before "Completed" was done an hour ago and the job
    isn't completed → admin alert (once while it's open)."""
    from apps.assignments import services as assignments

    now = now or timezone.now()
    count = 0
    for booking in Booking.objects.select_related("partner").filter(status=S.IN_PROGRESS):
        steps = steps_for(booking)
        if booking.current_step != steps[-2]:
            continue
        done_at = (
            BookingEvent.objects.filter(booking=booking, step=booking.current_step)
            .order_by("-server_ts")
            .values_list("server_ts", flat=True)
            .first()
        )
        if done_at is None or now - done_at < NOT_COMPLETED_AFTER:
            continue
        with transaction.atomic():
            alert = assignments.raise_alert(
                booking,
                "NOT_COMPLETED",
                {
                    "partner": booking.partner.full_name if booking.partner else "",
                    "step": booking.current_step,
                },
            )
        count += 1 if alert else 0
    return count


NOT_STARTED_AFTER = dt.timedelta(minutes=30)
# also one stuck as "accepted" for days (found in the live check): a month back
NOT_STARTED_LOOKBACK = dt.timedelta(days=30)


def not_started_sweep(*, now: dt.datetime | None = None) -> int:
    """Every 10 minutes (PHASES 9.11): an accepted booking whose partner hasn't tapped "On the
    way" 30 minutes after pickup → admin alert (once): call the partner, mark the steps, or
    cancel. Nothing changes by itself (a paid booking's money is the admin's call)."""
    from apps.assignments import services as assignments

    now = now or timezone.now()
    count = 0
    late = Booking.objects.select_related("partner").filter(
        status=S.ACCEPTED,
        pickup_at__lte=now - NOT_STARTED_AFTER,
        pickup_at__gt=now - NOT_STARTED_LOOKBACK,
    )
    for booking in late:
        with transaction.atomic():
            alert = assignments.raise_alert(
                booking,
                "NOT_STARTED",
                {"partner": booking.partner.full_name if booking.partner else ""},
                not_since=booking.pickup_at,  # once per booking time
            )
        count += 1 if alert else 0
    return count


__all__ = [
    "SYSTEM",
    "Place",
    "Step",
    "admin_step",
    "issue_job_otp",
    "job_otp",
    "log_call",
    "mark_no_show",
    "next_step",
    "record_balance",
    "record_step",
]
