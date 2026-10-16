"""Booking writes (ARCHITECTURE §6.9, §6.17, §6.18).

- `create_booking`: the patient's "Book" (P15). Saved as PENDING_PAYMENT with snapshots of the
  price, the member and the address. A retry with the same `Idempotency-Key` returns the same
  booking, so a double tap never books twice.
- `transition`: the one gate for every status change (allowed-transitions table below).
"""

import datetime as dt
import hashlib
import json
import logging
from collections.abc import Callable
from dataclasses import dataclass, field
from typing import Any

from django.db import IntegrityError, connection, transaction
from django.db.models import Max, Q
from django.utils import timezone
from psycopg.types.range import Range

from apps.accounts.models import User
from apps.addresses import selectors as address_selectors
from apps.app_config.selectors import get_setting, is_inside_service_area
from apps.bookings import times
from apps.bookings.models import (
    ActorType,
    Booking,
    BookingDocument,
    BookingEvent,
    BookingReminder,
    BookingStatus,
)
from apps.documents.models import PatientDocument
from apps.hospitals import selectors as directory
from apps.patients import selectors as patient_selectors
from apps.patients.models import Member
from apps.services.models import Service, VisitType
from common import events, realtime, state_machine
from common.errors import ApiError, Conflict, NotFound
from common.ids import uid

logger = logging.getLogger(__name__)

S = BookingStatus

# §6.9: (current status, event) → new status. Anything else is 409 INVALID_TRANSITION.
MACHINE = state_machine.StateMachine(
    "booking",
    {
        (S.PENDING_PAYMENT, "PAY"): S.NEW,  # booking fee captured (Phase 6)
        (S.PENDING_PAYMENT, "EXPIRE"): S.EXPIRED,  # not paid in time
        (S.NEW, "OFFER"): S.OFFERED,  # admin assigns a partner (Phase 7)
        (S.OFFERED, "ACCEPT"): S.ACCEPTED,  # partner accepts (or accepted by phone)
        (S.OFFERED, "DECLINE"): S.NEW,  # partner declines
        (S.OFFERED, "WITHDRAW"): S.NEW,  # admin withdraws the offer (reassign)
        (S.ACCEPTED, "UNASSIGN"): S.NEW,  # partner drops out, admin unassigns
        (S.ACCEPTED, "START"): S.IN_PROGRESS,  # partner taps On the way (Phase 8)
        (S.IN_PROGRESS, "COMPLETE"): S.COMPLETED,
        (S.IN_PROGRESS, "NO_SHOW"): S.PATIENT_NO_SHOW,  # patient not available after 15 min
        (S.NEW, "CANCEL"): S.CANCELLED,
        (S.OFFERED, "CANCEL"): S.CANCELLED,
        (S.ACCEPTED, "CANCEL"): S.CANCELLED,
    },
)

# Statuses of a booking that is still going to happen (or is happening).
ACTIVE = (S.PENDING_PAYMENT, S.NEW, S.OFFERED, S.ACCEPTED, S.IN_PROGRESS)

MAX_DOCUMENTS = 20
MAX_UNPAID = 5  # open "Pending payment" bookings per account


@dataclass(frozen=True)
class Actor:
    type: str
    id: str | None = None


SYSTEM = Actor(ActorType.SYSTEM)


def _record_event(
    booking: Booking,
    old: str,
    new: str,
    event: str,
    actor: Actor,
    note: str = "",
    **fields: Any,
) -> None:
    """One timeline row. `fields`: the job step's details (step, lat, lng, accuracy, client_ts,
    far_from_target, vitals) from Phase 8."""
    BookingEvent.objects.create(
        booking=booking,
        from_status=old,
        to_status=new,
        event=event,
        actor_type=actor.type,
        actor_id=uid(actor.id) if actor.id else None,
        server_ts=timezone.now(),
        note=note,
        **fields,
    )


def transition(
    booking: Booking,
    event: str,
    actor: Actor,
    *,
    note: str = "",
    extra_updates: dict[str, Any] | None = None,
    event_fields: dict[str, Any] | None = None,
) -> str:
    """Move the booking to its next status for `event` and add it to the timeline. Raises 409
    INVALID_TRANSITION (not allowed from this status) or 409 CONFLICT (changed meanwhile).
    `event_fields`: a job step's GPS and details for the timeline row."""

    def record(obj: Any, old: str, new: str, ev: str, who: Any) -> None:
        _record_event(obj, old, new, ev, who, note, **(event_fields or {}))

    status = state_machine.transition(
        booking,
        event,
        machine=MACHINE,
        actor=actor,
        extra_updates=extra_updates,
        on_transition=record,
    )
    tell_family(booking, status)
    return status


def tell_family(booking: Booking, status: str) -> None:
    """`booking.updated` to the family's open app (§10.4) after any status or time change,
    whoever made it (an admin's cancel, the unpaid expiry, …): the Home card, the booking and
    My bookings reload at once (full test, 16 Oct 2026: an admin's cancel stayed "Partner
    assigned" on Home)."""
    group = realtime.user_group("patient", str(booking.booked_by_id))
    data = {"bookingId": str(booking.pk), "status": status}
    transaction.on_commit(
        lambda: realtime.send_to_group(group, "booking.updated", data), robust=True
    )


# --- Create (P12-P15) ---


class InvalidBooking(ApiError):
    status = 422
    code = "INVALID_BOOKING"
    message = "Please check the booking details."


class PrescriptionRequired(ApiError):
    status = 422
    code = "PRESCRIPTION_REQUIRED"
    message = "This service needs a prescription. Please attach one."


class OutsideServiceArea(ApiError):
    status = 422
    code = "OUTSIDE_SERVICE_AREA"
    message = "We don't serve this address yet. Please choose another address."


class IdempotencyKeyReused(ApiError):
    status = 422
    code = "IDEMPOTENCY_KEY_REUSED"
    message = "This booking was already sent with other details. Please review it again."


class TooManyUnpaid(ApiError):
    status = 429
    code = "TOO_MANY_UNPAID"
    message = "You have several bookings waiting for payment. Pay or wait for them to expire."


@dataclass(frozen=True)
class BookingInput:
    service_id: str
    member_id: str
    address_id: str
    pickup_at: dt.datetime
    appointment_at: dt.datetime | None = None
    hospital_id: str | None = None
    hospital_text: str = ""
    doctor_id: str | None = None
    document_ids: list[str] = field(default_factory=list)
    notes: str = ""


def _invalid(message: str, field_name: str) -> InvalidBooking:
    return InvalidBooking(message, details={"field": field_name})


def _place(service: Service, data: BookingInput) -> tuple[Any, Any, str]:
    """Hospital (from the directory or typed in) and doctor, by visit type (§6.6, §6.7)."""
    visit = service.visit_type
    text = data.hospital_text.strip()
    if visit == VisitType.HOME_VISIT:
        if data.hospital_id or text or data.doctor_id:
            raise _invalid("A home visit has no hospital or doctor.", "hospitalId")
        return None, None, ""
    if data.hospital_id and text:
        raise _invalid("Pick a hospital from the list or type one in, not both.", "hospitalText")
    if visit == VisitType.HOSPITAL_VISIT and not (data.hospital_id or text):
        raise _invalid("Please choose the hospital.", "hospitalId")
    hospital = directory.patient_hospital(data.hospital_id) if data.hospital_id else None
    doctor = None
    if data.doctor_id:
        if visit != VisitType.HOSPITAL_VISIT or hospital is None:
            raise _invalid("Pick the doctor's hospital from the list.", "doctorId")
        doctor = directory.patient_doctor(data.doctor_id)
        if hospital.pk not in {h.pk for h in doctor.active_hospitals}:  # type: ignore[attr-defined]
            raise _invalid("This doctor isn't listed at this hospital.", "doctorId")
    return hospital, doctor, text


def _check_appointment(
    visit_type: str, duration_min: int, pickup_at: dt.datetime, appointment_at: dt.datetime | None
) -> None:
    if appointment_at is None:
        return
    if visit_type != VisitType.HOSPITAL_VISIT:
        raise _invalid("Only hospital visits have a doctor appointment time.", "appointmentAt")
    pickup = pickup_at.astimezone(times.IST)
    appointment = appointment_at.astimezone(times.IST)
    if appointment < pickup or appointment.date() != pickup.date():
        raise _invalid(
            "The pickup must be before the appointment, on the same day.", "appointmentAt"
        )
    # The partner's blocked time (busy_window) must cover the appointment.
    if appointment - pickup > dt.timedelta(minutes=duration_min):
        raise _invalid("The pickup is too early for this appointment.", "appointmentAt")


def _documents(user_id: str, member: Member, ids: list[str]) -> list[PatientDocument]:
    unique = list(dict.fromkeys(str(i) for i in ids))
    if len(unique) > MAX_DOCUMENTS:
        raise _invalid(f"Attach at most {MAX_DOCUMENTS} documents.", "documentIds")
    rows = {
        str(d.pk): d
        for d in PatientDocument.objects.filter(
            pk__in=[uid(i) for i in unique],
            owner_id=uid(user_id),
            deleted_at__isnull=True,
            member__is_active=True,
        )
    }
    documents = []
    for doc_id in unique:
        document = rows.get(doc_id)
        if document is None:
            raise NotFound()
        if document.member_id != member.pk:
            raise _invalid("Attach documents of the person the booking is for.", "documentIds")
        documents.append(document)
    return documents


def _member_snapshot(member: Member) -> dict[str, Any]:
    return {
        "id": str(member.pk),
        "full_name": member.full_name,
        "relation": member.relation,
        "gender": member.gender,
        "age": patient_selectors.age(member.dob),
        "phone": member.phone,
        "language": member.language,
    }


def _price_snapshot(service: Service) -> dict[str, Any]:
    return {
        "name": service.name,
        "name_hi": service.name_hi,
        "name_or": service.name_or,
        "partner_type": service.partner_type,
        "visit_type": service.visit_type,
        "duration_min": service.duration_min,
        "docs_required": service.docs_required,
        "price_paise": service.price_paise,
        "booking_fee_paise": service.booking_fee_paise,
        "balance_paise": service.balance_paise,
    }


def busy_window(pickup_at: dt.datetime, duration_min: int) -> Range[dt.datetime]:
    """The partner's blocked time: pickup - 1 h → pickup + duration + 30 min (§6.9)."""
    return Range(
        pickup_at - dt.timedelta(hours=1),
        pickup_at + dt.timedelta(minutes=duration_min + 30),
    )


def next_code() -> str:
    with connection.cursor() as cursor:
        cursor.execute("SELECT nextval('booking_code_seq')")
        (number,) = cursor.fetchone()
    return f"WW-{number}"


def request_hash(data: BookingInput) -> str:
    """Fingerprint of what was sent, stored with the Idempotency-Key."""

    def instant(value: dt.datetime | None) -> str | None:
        return value.astimezone(dt.UTC).isoformat() if value else None

    fields = {
        "service": str(data.service_id),
        "member": str(data.member_id),
        "address": str(data.address_id),
        "pickup": instant(data.pickup_at),
        "appointment": instant(data.appointment_at),
        "hospital": str(data.hospital_id or ""),
        "hospital_text": data.hospital_text.strip(),
        "doctor": str(data.doctor_id or ""),
        "documents": sorted({str(d) for d in data.document_ids}),
        "notes": data.notes.strip(),
    }
    return hashlib.sha256(json.dumps(fields, sort_keys=True).encode()).hexdigest()


def _create(user: User, data: BookingInput, key: str, digest: str, now: dt.datetime) -> Booking:
    user_id = str(user.pk)
    service = Service.objects.filter(pk=uid(data.service_id), is_active=True).first()
    if service is None:
        raise NotFound()
    member = patient_selectors.own_member(user_id, data.member_id)
    address = address_selectors.own_address(user_id, data.address_id)
    if not is_inside_service_area(float(address.lat), float(address.lng)):
        raise OutsideServiceArea(details={"field": "addressId"})
    hospital, doctor, hospital_text = _place(service, data)
    _check_appointment(
        service.visit_type, service.duration_min, data.pickup_at, data.appointment_at
    )
    documents = _documents(user_id, member, data.document_ids)
    if service.docs_required and not any(
        d.type == PatientDocument.Type.PRESCRIPTION for d in documents
    ):
        raise PrescriptionRequired(details={"field": "documentIds"})

    expiry = dt.timedelta(minutes=int(get_setting("payment_expiry_min")))
    unpaid = Booking.objects.filter(
        booked_by=user, status=S.PENDING_PAYMENT, created_at__gt=now - expiry
    ).count()
    if unpaid >= MAX_UNPAID:
        raise TooManyUnpaid()
    times.check_time(service, data.pickup_at, now)

    booking = Booking.objects.create(
        code=next_code(),
        booked_by=user,
        member=member,
        service=service,
        price_snapshot=_price_snapshot(service),
        hospital=hospital,
        hospital_text=hospital_text,
        doctor=doctor,
        appointment_at=data.appointment_at,
        pickup_at=data.pickup_at,
        address=address,
        address_snapshot={
            "label": address.label,
            "line1": address.line1,
            "landmark": address.landmark,
            "notes": address.notes,
            "lat": str(address.lat),
            "lng": str(address.lng),
        },
        member_snapshot=_member_snapshot(member),
        notes=data.notes.strip(),
        busy_window=busy_window(data.pickup_at, service.duration_min),
        idempotency_key=key,
        idempotency_hash=digest,
    )
    BookingDocument.objects.bulk_create(
        [BookingDocument(booking=booking, document=d, doc_type=d.type) for d in documents]
    )
    _record_event(booking, "", S.PENDING_PAYMENT, "CREATE", Actor(ActorType.PATIENT, user_id))
    return booking


def create_booking(
    *, user_id: str, data: BookingInput, idempotency_key: str, now: dt.datetime | None = None
) -> tuple[Booking, bool]:
    """Returns (booking, created). The same key again returns the first booking unchanged
    (422 IDEMPOTENCY_KEY_REUSED if it comes with other details). The key is looked up after the
    account is locked: a retry that waited for the first request finds its booking instead of
    being checked again (that check could say "full" or "too many unpaid" because of the very
    booking it is retrying)."""
    owner = uid(user_id)
    digest = request_hash(data)

    def same(existing: Booking) -> Booking:
        if existing.idempotency_hash and existing.idempotency_hash != digest:
            raise IdempotencyKeyReused()
        return existing

    try:
        with transaction.atomic():
            user = User.objects.select_for_update().get(pk=owner)  # one booking at a time
            existing = Booking.objects.filter(
                booked_by_id=owner, idempotency_key=idempotency_key
            ).first()
            if existing is not None:
                return same(existing), False
            return _create(user, data, idempotency_key, digest, now or timezone.now()), True
    except OutsideServiceArea:
        # Saved inside an area that has since changed: the app must show it as outside now.
        from apps.addresses.services import refresh_service_area

        refresh_service_area(address_id=data.address_id)
        raise
    except IntegrityError:
        existing = Booking.objects.filter(
            booked_by_id=owner, idempotency_key=idempotency_key
        ).first()
        if existing is None:
            raise
        return same(existing), False


# --- Unpaid bookings (§6.12: expire after `payment_expiry_min`) ---


# A payment being confirmed keeps its booking from expiring (the payments app registers the
# check: the patient paid, Razorpay hasn't told us it was captured yet).
_expiry_guards: list[Callable[[str], bool]] = []


def register_expiry_guard(guard: Callable[[str], bool]) -> None:
    if guard not in _expiry_guards:
        _expiry_guards.append(guard)


def expire_unpaid(*, now: dt.datetime | None = None) -> int:
    """Every 5 minutes: unpaid bookings past their payment time become EXPIRED (their time is
    free again), unless a payment for them is being confirmed. Safe to run twice."""
    expiry = dt.timedelta(minutes=int(get_setting("payment_expiry_min")))
    cutoff = (now or timezone.now()) - expiry
    expired = 0
    due = Booking.objects.filter(status=S.PENDING_PAYMENT, created_at__lte=cutoff).order_by(
        "created_at"
    )
    for booking in list(due[:500]):
        if any(guard(str(booking.pk)) for guard in _expiry_guards):
            continue
        try:
            transition(booking, "EXPIRE", SYSTEM)
            expired += 1
        except (state_machine.InvalidTransition, state_machine.ConcurrentUpdate):
            continue  # paid or changed meanwhile
    return expired


# --- Other apps (account deletion, removing a member) ---


def has_active_bookings(*, user_id: str, member_id: str | None = None) -> bool:
    """Paid bookings that haven't finished (unpaid ones expire on their own)."""
    rows = Booking.objects.filter(booked_by_id=uid(user_id), status__in=ACTIVE[1:])
    if member_id:
        rows = rows.filter(member_id=uid(member_id))
    return rows.exists()


def partner_has_open_jobs(partner_id: str) -> bool:
    """An accepted job (also a later one) or one in progress is theirs: they can't delete their
    account until WellWish moves it (§6.20)."""
    return Booking.objects.filter(
        partner_id=uid(partner_id), status__in=(S.ACCEPTED, S.IN_PROGRESS)
    ).exists()


def forget_partner_name(*, booking_ids: list[Any], name: str, replacement: str) -> int:
    """§6.20: events that noted a deleted partner's name (offers) say `replacement` instead."""
    return BookingEvent.objects.filter(booking_id__in=booking_ids, note=name).update(
        note=replacement
    )


def expire_unpaid_of(*, user_id: str, member_id: str | None = None, note: str = "") -> None:
    """The account (or one member) is going: their unpaid bookings expire now."""
    rows = Booking.objects.filter(booked_by_id=uid(user_id), status=S.PENDING_PAYMENT)
    if member_id:
        rows = rows.filter(member_id=uid(member_id))
    for booking in rows:
        try:
            transition(booking, "EXPIRE", SYSTEM, note=note)
        except (state_machine.InvalidTransition, state_machine.ConcurrentUpdate):
            logger.warning("Booking %s changed while it was being expired", booking.pk)


def erase_for_owner(*, user_id: str) -> int:
    """Account deletion (§12): bookings and payments are kept (the law needs them), but the
    personal details in them go: the member's name and phone, the address and the notes, and
    the visit's positions (the home's GPS fix), vitals and step notes on the timeline.
    Unpaid bookings are expired."""
    expire_unpaid_of(user_id=user_id, note="Account deleted")
    BookingEvent.objects.filter(booking__booked_by_id=uid(user_id)).update(
        lat=None, lng=None, accuracy=None, vitals=None
    )
    BookingEvent.objects.filter(booking__booked_by_id=uid(user_id), event="STEP").update(note="")
    return Booking.objects.filter(booked_by_id=uid(user_id)).update(
        member_snapshot={"erased": True},
        address_snapshot={"erased": True},
        notes="",
        idempotency_key="",
        idempotency_hash="",
        updated_at=timezone.now(),
    )


# --- Paid (Phase 6: called by the payments app when Razorpay captured the fee) ---


def mark_paid(*, booking_id: str) -> str:
    """The booking fee was captured. Returns PAID (now NEW), ALREADY_PAID, TIME_TAKEN (paid after
    its payment time and someone else took the last place: it expires, the fee is refunded) or
    TOO_LATE (expired or cancelled before the money arrived: the fee is refunded)."""
    with transaction.atomic():
        booking = Booking.objects.select_for_update().get(pk=uid(booking_id))
        if booking.status != S.PENDING_PAYMENT:
            paid = booking.status in (S.NEW, S.OFFERED, S.ACCEPTED, S.IN_PROGRESS, S.COMPLETED)
            return "ALREADY_PAID" if paid else "TOO_LATE"
        if not times.place_still_free(booking):
            transition(booking, "EXPIRE", SYSTEM, note="The time was taken while paying")
            return "TIME_TAKEN"
        transition(booking, "PAY", SYSTEM)
        events.publish("booking.paid", {"booking_id": str(booking.pk)})
        return "PAID"


# --- Cancel (§6.12, W-P4) ---

# The patient can cancel until the partner is on the way (setting cancel_cutoff_step; the steps
# arrive in Phase 8, so for now "on the way" = IN_PROGRESS).
PATIENT_CANCELLABLE = (S.NEW, S.OFFERED, S.ACCEPTED)
STAFF_CANCELLABLE = (S.NEW, S.OFFERED, S.ACCEPTED)


# Called inside the cancel, in the same transaction: the payments app registers the refund, so
# the answer already shows it.
_cancel_hooks: list[Callable[..., Any]] = []


def register_cancel_hook(hook: Callable[..., Any]) -> None:
    if hook not in _cancel_hooks:
        _cancel_hooks.append(hook)


class CancelNotAllowed(Conflict):
    code = "CANCEL_NOT_ALLOWED"
    message = "This booking can't be cancelled in the app any more. Please call WellWish support."


def can_patient_cancel(booking: Booking) -> bool:
    return booking.status in PATIENT_CANCELLABLE


def cancel(
    *,
    booking_id: str,
    actor: Actor,
    reason: str,
    refund_percent: int,
    by_patient: bool,
) -> Booking:
    """Cancel a paid booking. The payments app refunds `refund_percent` of the fee (its cancel
    hook, in this transaction). The patient: before "on the way", the setting's % (§6.12).
    The admin: any time before the job starts, 0-100 % with a reason (§9.5)."""
    with transaction.atomic():
        booking = Booking.objects.select_for_update().get(pk=uid(booking_id))
        allowed = PATIENT_CANCELLABLE if by_patient else STAFF_CANCELLABLE
        if booking.status not in allowed:
            raise CancelNotAllowed(details={"status": booking.status})
        transition(
            booking,
            "CANCEL",
            actor,
            note=reason,
            extra_updates={
                "cancelled_by": actor.type,
                "cancel_reason": reason,
                "refund_percent": refund_percent,
            },
        )
        for hook in _cancel_hooks:
            hook(
                booking_id=str(booking.pk),
                percent=refund_percent,
                by=actor.type,
                staff_id=actor.id if actor.type == ActorType.STAFF else None,
                reason=reason,
            )
        events.publish(
            "booking.cancelled",
            {"booking_id": str(booking.pk), "refund_percent": refund_percent, "by": actor.type},
        )
        return booking


# --- Reschedule (§6.17, W-P7) ---

RESCHEDULABLE = (S.NEW, S.OFFERED, S.ACCEPTED)


class RescheduleNotAllowed(Conflict):
    code = "RESCHEDULE_NOT_ALLOWED"
    message = "The time can't be changed in the app any more. Please call WellWish support."


def reschedule_problem(
    booking: Booking, *, by_staff: bool = False, now: dt.datetime | None = None
) -> str | None:
    """Why the time can't be changed now: STATUS, TOO_LATE (within the cut-off before pickup),
    LIMIT (changed too often). The admin is not held to the cut-off or the limit."""
    if booking.status not in RESCHEDULABLE:
        return "STATUS"
    if by_staff:
        return None
    now = now or timezone.now()
    cutoff = dt.timedelta(hours=int(get_setting("reschedule_cutoff_hours")))
    if now > booking.pickup_at - cutoff:
        return "TOO_LATE"
    if booking.reschedule_count >= int(get_setting("max_reschedules")):
        return "LIMIT"
    return None


def _ist(at: dt.datetime) -> str:
    return at.astimezone(times.IST).strftime("%d %b %H:%M")


def confirm_new_time(booking: Booking, actor: Actor) -> None:
    """The partner confirmed a booking's new time (re-confirm offer, §6.17)."""
    changed = Booking.objects.filter(pk=booking.pk, version=booking.version).update(
        reconfirm_needed=False, version=booking.version + 1, updated_at=timezone.now()
    )
    if changed != 1:
        raise state_machine.ConcurrentUpdate()
    _record_event(booking, booking.status, booking.status, "RECONFIRM", actor)


_reschedule_hooks: list[Callable[..., Any]] = []


def register_reschedule_hook(hook: Callable[..., Any]) -> None:
    """Called inside the reschedule's transaction as `hook(booking=…, released_partner_id=…)`:
    the assignments app re-confirms the new time with the partner (or closes their offer)."""
    if hook not in _reschedule_hooks:
        _reschedule_hooks.append(hook)


def partner_busy(partner_id: str, window: Range[dt.datetime], *, leave_out: Any = None) -> bool:
    """The partner has another accepted or started job overlapping `window` (§6.9)."""
    qs = Booking.objects.filter(
        partner_id=uid(partner_id),
        status__in=(S.ACCEPTED, S.IN_PROGRESS),
        busy_window__overlap=window,
    )
    if leave_out is not None:
        qs = qs.exclude(pk=leave_out)
    return qs.exists()


def reschedule(
    *,
    booking_id: str,
    actor: Actor,
    pickup_at: dt.datetime,
    appointment_at: dt.datetime | None,
    by_staff: bool = False,
    now: dt.datetime | None = None,
) -> Booking:
    """Move a booking to another date or time with the same rules as booking (the admin may
    choose a time inside the minimum notice). Price and fee stay (price snapshot). If a partner
    had the offer or had accepted, they must confirm the new time (`reconfirm_needed`; the
    assignments app sends a re-confirm offer). A partner who is busy at the new time is
    released: the booking goes back to the admin's queue."""
    now = now or timezone.now()
    with transaction.atomic():
        booking = Booking.objects.select_for_update().get(pk=uid(booking_id))
        problem = reschedule_problem(booking, by_staff=by_staff, now=now)
        if problem:
            raise RescheduleNotAllowed(details={"reason": problem})
        if pickup_at == booking.pickup_at and appointment_at == booking.appointment_at:
            raise _invalid("Pick a different date or time.", "pickupAt")
        snapshot = booking.price_snapshot
        _check_appointment(
            snapshot["visit_type"], int(snapshot["duration_min"]), pickup_at, appointment_at
        )
        times.check_time(
            snapshot["partner_type"], pickup_at, now, leave_out=booking.pk, notice=not by_staff
        )
        old = booking.pickup_at
        window = busy_window(pickup_at, int(snapshot["duration_min"]))
        released: str | None = None
        # §6.19: a temporary partner is for the booked time only (no "confirm the new time")
        temporary = booking.partner is not None and booking.partner.status == "TEMPORARY"
        if (
            booking.status == S.ACCEPTED
            and booking.partner_id
            and (temporary or partner_busy(str(booking.partner_id), window, leave_out=booking.pk))
        ):
            # The partner has another job then: back to the queue (they hear it's withdrawn).
            released = str(booking.partner_id)
            transition(
                booking,
                "UNASSIGN",
                actor,
                note="A temporary partner is for the booked time only"
                if temporary
                else "The partner is busy at the new time",
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
            booking.refresh_from_db()
        needs_partner = booking.status in (S.OFFERED, S.ACCEPTED)
        changed = Booking.objects.filter(pk=booking.pk, version=booking.version).update(
            pickup_at=pickup_at,
            appointment_at=appointment_at,
            busy_window=window,
            reschedule_count=booking.reschedule_count + (0 if by_staff else 1),
            reconfirm_needed=booking.reconfirm_needed or needs_partner,
            version=booking.version + 1,
            updated_at=timezone.now(),
        )
        if changed != 1:
            raise state_machine.ConcurrentUpdate()
        booking.refresh_from_db()
        BookingEvent.objects.create(
            booking=booking,
            from_status=booking.status,
            to_status=booking.status,
            event="RESCHEDULE",
            actor_type=actor.type,
            actor_id=uid(actor.id) if actor.id else None,
            server_ts=timezone.now(),
            note=f"{_ist(old)} → {_ist(pickup_at)} IST",
        )
        for hook in _reschedule_hooks:
            hook(booking=booking, released_partner_id=released)
        events.publish("booking.rescheduled", {"booking_id": str(booking.pk), "by": actor.type})
        tell_family(booking, booking.status)
        return booking


# --- Reminders (§6.17) ---

# Sent once inside each window (a booking made later than the window starts gets no reminder).
REMINDERS = {
    BookingReminder.Kind.DAY_BEFORE: (dt.timedelta(hours=22), dt.timedelta(hours=24)),
    BookingReminder.Kind.TWO_HOURS: (dt.timedelta(hours=1), dt.timedelta(hours=2)),
}


def reminder_sweep(*, now: dt.datetime | None = None) -> int:
    """Every minute: paid bookings that are 24 h or 2 h away → `booking.reminder` (the
    notifications app tells the owner, the member by SMS and an assigned partner)."""
    now = now or timezone.now()
    sent = 0
    for kind, (soonest, latest) in REMINDERS.items():
        due = Booking.objects.filter(
            status__in=(S.NEW, S.OFFERED, S.ACCEPTED),
            pickup_at__gt=now + soonest,
            pickup_at__lte=now + latest,
        ).annotate(
            # booked, paid or moved inside the window: the confirmation said it all already
            settled_at=Max("events__server_ts", filter=Q(events__event__in=("PAY", "RESCHEDULE")))
        )
        for booking in due:
            settled = max(booking.created_at, booking.settled_at or booking.created_at)
            if settled > booking.pickup_at - latest:
                continue
            try:
                with transaction.atomic():
                    BookingReminder.objects.create(
                        booking=booking, kind=kind, pickup_at=booking.pickup_at
                    )
                    events.publish(
                        "booking.reminder", {"booking_id": str(booking.pk), "kind": kind}
                    )
            except IntegrityError:
                continue  # already reminded for this time
            sent += 1
    return sent
