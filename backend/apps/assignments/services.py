"""Manual assignment with the 2-minute rule (ARCHITECTURE §6.10, §6.17, §9.3).

- The admin offers a NEW booking to a partner (OFFERED). Assigning someone else withdraws the
  open offer. At most one open offer per booking (database constraint).
- The partner accepts (ACCEPTED, the database refuses a second job overlapping their time) or
  declines with a reason (back to NEW, the admin is alerted). The admin can record
  "accepted by phone" or unassign an accepted partner (logged).
- After `accept_timeout_seconds` an open offer alerts the admin and reminds the partner; the
  offer stays open, so a partner who accepts at 3 minutes still gets the job.
- A booking still unassigned at the assign deadline (6 PM the day before, or 3 h before pickup)
  escalates: red in the queue, the Super Admins get an email.
- A rescheduled accepted booking gets a RECONFIRM offer to the same partner (declining it puts
  the booking back in the queue). A rescheduled offered booking gets a fresh offer.
- A suspended or deactivated partner loses their open offers; their upcoming jobs are flagged
  to the admins (PARTNER_UNAVAILABLE) and stay in the queue until reassigned.

Locks are always taken booking first, then its offers (the same order everywhere, so two
admins and a partner acting at once wait for each other instead of deadlocking).

Live messages go out after commit (`common.realtime`); push / SMS / inbox through events
handled by the notifications app.
"""

import datetime as dt
import logging
from typing import Any
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db import IntegrityError, transaction
from django.db.models import Max, Q
from django.utils import timezone

from apps.app_config.selectors import get_setting
from apps.assignments.models import (
    AlertKind,
    BookingAssignment,
    OfferKind,
    OfferResponse,
    StaffAlert,
)
from apps.audit.services import record
from apps.bookings import services as bookings
from apps.bookings.models import ActorType, Booking, BookingStatus
from apps.partners import services as partners
from apps.partners.models import PartnerProfile, PartnerStatus
from apps.partners.selectors import is_deleting
from apps.staff.models import StaffUser
from common import events, metrics, realtime
from common.errors import Conflict, NotFound
from common.ids import uid
from common.mail import send_mail

logger = logging.getLogger(__name__)

S = BookingStatus
STAFF_OPS = "staff.ops"  # admins who see bookings (queue, alerts)
STAFF_PARTNERS = "staff.partners"  # admins who review partner applications


class NotAssignable(Conflict):
    code = "NOT_ASSIGNABLE"
    message = "This booking can't be assigned now."


class PartnerNotEligible(Conflict):
    code = "PARTNER_NOT_ELIGIBLE"
    message = "This partner can't take this booking (not approved, or another role)."


class PartnerBusy(Conflict):
    code = "PARTNER_BUSY"
    message = "This partner has another job at that time."


class OfferNotOpen(Conflict):
    code = "OFFER_NOT_OPEN"
    message = "This booking is no longer offered to you."


class NothingOffered(Conflict):
    code = "NO_OPEN_OFFER"
    message = "This booking has no open offer."


class OfferChanged(Conflict):
    """§6.16: two admins at once. The page the admin acted on is out of date."""

    code = "OFFER_CHANGED"
    message = "Someone else changed this booking just now. Check it and try again."


# --- Small helpers ---


def _timeout() -> dt.timedelta:
    return dt.timedelta(seconds=int(get_setting("accept_timeout_seconds")))


SETTLED_AT = Max("events__server_ts", filter=Q(events__event__in=("PAY", "RESCHEDULE")))

# A booking paid late (the same day, or after 6 PM the evening before) gets this long before it
# counts as late (developer decision 12 Oct 2026: same-day bookings were red the moment they
# were paid).
LATE_BOOKING_GRACE = dt.timedelta(minutes=30)


def assign_deadline(pickup_at: dt.datetime, settled_at: dt.datetime | None = None) -> dt.datetime:
    """§6.17: 6 PM (setting) the evening before, or 3 h (setting) before pickup, whichever
    comes first; but never earlier than 30 minutes after the booking was paid or moved
    (`settled_at`), and never after the pickup itself."""
    ist = ZoneInfo(settings.DISPLAY_TIME_ZONE)
    day_before = pickup_at.astimezone(ist).date() - dt.timedelta(days=1)
    evening = dt.datetime.combine(
        day_before, dt.time(int(get_setting("assign_deadline_evening_hour")), 0), tzinfo=ist
    )
    hours_before = pickup_at - dt.timedelta(hours=int(get_setting("assign_deadline_hours_before")))
    deadline = min(evening, hours_before)
    if settled_at is not None:
        deadline = min(max(deadline, settled_at + LATE_BOOKING_GRACE), pickup_at)
    return deadline


def settled_at(booking: Booking) -> dt.datetime | None:
    """When the booking was paid or last moved (a queue row carries it already)."""
    if hasattr(booking, "settled_at"):
        return booking.settled_at
    return (
        booking.events.filter(event__in=("PAY", "RESCHEDULE"))
        .order_by("-server_ts")
        .values_list("server_ts", flat=True)
        .first()
    )


def booking_deadline(booking: Booking) -> dt.datetime:
    return assign_deadline(booking.pickup_at, settled_at(booking))


def _staff_actor(staff: StaffUser) -> bookings.Actor:
    return bookings.Actor(ActorType.STAFF, str(staff.pk))


def _partner_actor(partner: PartnerProfile) -> bookings.Actor:
    return bookings.Actor(ActorType.PARTNER, str(partner.user_id))


def _lock_booking(booking_id: str) -> Booking:
    booking = Booking.objects.select_for_update(of=("self",)).filter(pk=uid(booking_id)).first()
    if booking is None:
        raise NotFound()
    return booking


LIVE = (OfferResponse.OPEN, OfferResponse.ACCEPTED, OfferResponse.ACCEPTED_BY_PHONE)
ACCEPTED_RESPONSES = (OfferResponse.ACCEPTED, OfferResponse.ACCEPTED_BY_PHONE)


def _open_offer(booking: Booking) -> BookingAssignment | None:
    return (
        BookingAssignment.objects.select_for_update(of=("self",))
        .select_related("partner")
        .filter(booking=booking, response=OfferResponse.OPEN)
        .first()
    )


def current_assignment(booking: Booking) -> BookingAssignment | None:
    """What the admin is looking at: the open offer, else the accepted partner's job."""
    rows = BookingAssignment.objects.filter(booking=booking)
    open_offer = rows.filter(response=OfferResponse.OPEN).first()
    if open_offer is not None or booking.partner_id is None:
        return open_offer
    return (
        rows.filter(partner_id=booking.partner_id, response__in=ACCEPTED_RESPONSES)
        .order_by("-sent_at")
        .first()
    )


def _expect(booking: Booking, expected_assignment_id: str | None) -> None:
    """The admin acted on what they saw: refuse if another admin or the partner changed it."""
    current = current_assignment(booking)
    if (str(current.pk) if current else None) != (expected_assignment_id or None):
        who = ""
        if current is not None:
            current = BookingAssignment.objects.select_related("partner", "assigned_by").get(
                pk=current.pk
            )
            by = f" by {current.assigned_by.name}" if current.assigned_by else ""
            who = f" It's now with {current.partner.full_name}{by}."
        raise OfferChanged(message=f"{OfferChanged.message}{who}")


def _after_commit(func: Any) -> None:
    # robust: one failing live message must not stop the SMS, timers and emails after it
    transaction.on_commit(func, robust=True)


def _to_partner(partner: PartnerProfile, kind: str, data: dict[str, Any]) -> None:
    group = realtime.user_group("partner", str(partner.user_id))
    _after_commit(lambda: realtime.send_to_group(group, kind, data))


def _to_patient(booking: Booking) -> None:
    group = realtime.user_group("patient", str(booking.booked_by_id))
    data = {"bookingId": str(booking.pk), "status": booking.status}
    _after_commit(lambda: realtime.send_to_group(group, "booking.updated", data))


def queue_changed(booking: Booking, reason: str) -> None:
    """The admins' unassigned queue moved (new booking, offered, declined, accepted, ...)."""
    data = {"bookingId": str(booking.pk), "code": booking.code, "reason": reason}
    _after_commit(lambda: realtime.send_to_group(STAFF_OPS, "queue.changed", data))


def _alert(alert: StaffAlert, booking: Booking) -> None:
    data = {
        "id": str(alert.pk),
        "kind": alert.kind,
        "bookingId": str(booking.pk),
        "code": booking.code,
        "details": alert.details,
    }
    _after_commit(lambda: realtime.send_to_group(STAFF_OPS, "alert", data))


def _resolve_alerts(booking: Booking, *kinds: str) -> None:
    """The problem behind these open alerts is solved (no one needs to act any more): they are
    closed, and their banners close on every admin screen."""
    open_alerts = StaffAlert.objects.filter(
        booking=booking, kind__in=kinds, acknowledged_at__isnull=True
    )
    ids = [str(pk) for pk in open_alerts.values_list("pk", flat=True)]
    if not ids:
        return
    open_alerts.update(acknowledged_at=timezone.now())
    for alert_id in ids:
        data = {"id": alert_id, "bookingId": str(booking.pk)}
        _after_commit(lambda data=data: realtime.send_to_group(STAFF_OPS, "alert.acked", data))


def close_alerts(booking: Booking, *kinds: str) -> None:
    """For other apps: e.g. the visit code step is done, so its OTP_LOCKED alert is over."""
    _resolve_alerts(booking, *kinds)


def _close(offer: BookingAssignment, response: str, **fields: Any) -> None:
    offer.response = response
    offer.responded_at = timezone.now()
    for name, value in fields.items():
        setattr(offer, name, value)
    offer.save(update_fields=["response", "responded_at", *fields, "updated_at"])


def _new_offer(
    booking: Booking, partner: PartnerProfile, kind: str, staff: StaffUser | None
) -> BookingAssignment:
    now = timezone.now()
    offer = BookingAssignment.objects.create(
        booking=booking,
        partner=partner,
        kind=kind,
        assigned_by=staff,
        sent_at=now,
        timeout_at=now + _timeout(),
    )
    _schedule_timeout(offer)
    _to_partner(
        partner,
        "offer.new",
        {"assignmentId": str(offer.pk), "bookingId": str(booking.pk), "kind": kind},
    )
    events.publish("offer.sent", {"assignment_id": str(offer.pk)})
    return offer


def _schedule_timeout(offer: BookingAssignment) -> None:
    from apps.assignments.tasks import offer_timeout

    seconds = max(1, int((offer.timeout_at - timezone.now()).total_seconds()))
    offer_id = str(offer.pk)
    _after_commit(lambda: offer_timeout.apply_async((offer_id,), countdown=seconds))


def _withdraw(offer: BookingAssignment, why: str) -> None:
    """Close an open offer (reassigned, unassigned, cancelled, time changed)."""
    _close(offer, OfferResponse.WITHDRAWN)
    _to_partner(
        offer.partner,
        "offer.withdrawn",
        {"assignmentId": str(offer.pk), "bookingId": str(offer.booking_id)},
    )
    events.publish("offer.withdrawn", {"assignment_id": str(offer.pk), "why": why})


def _release(booking: Booking, partner_id: Any, why: str) -> None:
    """Close every live row of one partner on this booking (open offer, accepted job) and tell
    them once (one message, even when an accepted job had an open new-time offer)."""
    rows = list(
        BookingAssignment.objects.select_for_update(of=("self",))
        .select_related("partner")
        .filter(booking=booking, partner_id=partner_id, response__in=LIVE)
        .order_by("-sent_at")
    )
    for row in rows:
        _close(row, OfferResponse.WITHDRAWN)
    if rows:
        main = rows[0]
        _to_partner(
            main.partner,
            "offer.withdrawn",
            {"assignmentId": str(main.pk), "bookingId": str(booking.pk)},
        )
        events.publish("offer.withdrawn", {"assignment_id": str(main.pk), "why": why})


# --- Admin: assign, reassign, accepted by phone, unassign ---


def assign(
    *,
    booking_id: str,
    partner_id: str,
    staff: StaffUser,
    ip: str | None,
    expected_assignment_id: str | None = None,
    check: bool = True,
) -> BookingAssignment:
    """Offer the booking to a partner (§6.10). Assigning someone else withdraws the open offer.
    The partner must be approved, of the booking's type and free at that time. `check`: the
    admin saw `expected_assignment_id` as the open offer (§6.16, two admins at once)."""
    with transaction.atomic():
        booking = _lock_booking(booking_id)
        if booking.status not in (S.NEW, S.OFFERED):
            raise NotAssignable(details={"status": booking.status})
        if check:
            _expect(booking, expected_assignment_id)
        partner = PartnerProfile.objects.filter(pk=uid(partner_id)).first()
        if partner is None:
            raise NotFound()
        if (
            partner.status != PartnerStatus.APPROVED
            or partner.role != booking.price_snapshot["partner_type"]
            or is_deleting(str(partner.pk))  # §6.20: asked to delete their account
        ):
            raise PartnerNotEligible()
        if bookings.partner_busy(str(partner.pk), booking.busy_window, leave_out=booking.pk):
            raise PartnerBusy()
        current = _open_offer(booking)
        if current is not None and current.partner_id == partner.pk:
            return current  # offered to them already: nothing to do
        actor = _staff_actor(staff)
        previous = current.partner.full_name if current else ""
        if current is not None:
            _withdraw(current, "REASSIGNED")
            _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
            bookings.transition(
                booking,
                "WITHDRAW",
                actor,
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
            booking.refresh_from_db()
        bookings.transition(
            booking,
            "OFFER",
            actor,
            note=partner.full_name,
            extra_updates={"partner": partner, "reconfirm_needed": False},
        )
        booking.refresh_from_db()
        offer = _new_offer(booking, partner, OfferKind.NEW, staff)
        record(
            staff,
            "booking.reassigned" if current else "booking.assigned",
            ("bookings.booking", str(booking.pk)),
            before={"partner": previous} if current else None,
            after={"partner": partner.full_name, "partner_id": str(partner.pk)},
            ip=ip,
        )
        queue_changed(booking, "OFFERED")
        return offer


def accept_by_phone(
    *,
    booking_id: str,
    staff: StaffUser,
    note: str,
    ip: str | None,
    expected_assignment_id: str | None = None,
    check: bool = True,
) -> BookingAssignment:
    """The partner agreed on a call (§6.10): the admin records it. Logged. `check`: only the
    offer the admin was looking at (another admin may have reassigned meanwhile)."""
    with transaction.atomic():
        booking = _lock_booking(booking_id)
        offer = _open_offer(booking)
        if offer is None:
            raise NothingOffered()
        if check:
            _expect(booking, expected_assignment_id)
        _accept(booking, offer, _staff_actor(staff), OfferResponse.ACCEPTED_BY_PHONE)
        record(
            staff,
            "booking.accepted_by_phone",
            ("bookings.booking", str(booking.pk)),
            after={"partner": offer.partner.full_name, "partner_id": str(offer.partner_id)},
            reason=note,
            ip=ip,
        )
        return offer


def temporary_assign(
    *,
    booking_id: str,
    details: partners.TemporaryDetails,
    staff: StaffUser,
    ip: str | None,
    expected_assignment_id: str | None = None,
    check: bool = True,
) -> BookingAssignment:
    """Nobody free (§6.19): the admin phoned a person and checked their ID; they get this one
    booking, accepted at once (no 2-minute timer, no offer message). An open offer is
    withdrawn as with reassign. The person gets an SMS with the app link; the family is told
    like for any partner (they're never told it's temporary). Logged with the reason."""
    with transaction.atomic():
        booking = _lock_booking(booking_id)
        if booking.status not in (S.NEW, S.OFFERED):
            raise NotAssignable(details={"status": booking.status})
        if check:
            _expect(booking, expected_assignment_id)
        partner = partners.make_temporary(booking=booking, details=details, staff=staff)
        actor = _staff_actor(staff)
        current = _open_offer(booking)
        if current is not None:
            _withdraw(current, "REASSIGNED")
            _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
            bookings.transition(
                booking,
                "WITHDRAW",
                actor,
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
            booking.refresh_from_db()
        bookings.transition(
            booking,
            "OFFER",
            actor,
            note=partner.full_name,
            extra_updates={"partner": partner, "reconfirm_needed": False},
        )
        booking.refresh_from_db()
        now = timezone.now()
        offer = BookingAssignment.objects.create(
            booking=booking,
            partner=partner,
            kind=OfferKind.TEMPORARY,
            assigned_by=staff,
            sent_at=now,
            timeout_at=now,  # no 2-minute rule: the admin has already spoken to them
        )
        _accept(booking, offer, actor, OfferResponse.ACCEPTED_BY_PHONE)
        check_row = partner.temporary_checks.get(ended_at__isnull=True)
        record(
            staff,
            "booking.temp_assigned",
            ("bookings.booking", str(booking.pk)),
            after={
                "partner": partner.full_name,
                "partner_id": str(partner.pk),
                "id_type": check_row.id_type,
                "id_last4": check_row.id_last4,
            },
            reason=details.reason,
            ip=ip,
        )
        payload = {"partner_id": str(partner.pk), "booking_id": str(booking.pk)}
        events.publish("partner.temp_assigned", payload)
        return offer


class NotTemporary(Conflict):
    code = "NOT_TEMPORARY"
    message = "This booking has no temporary partner with app access now."


def end_temporary_access(*, booking_id: str, staff: StaffUser, reason: str, ip: str | None) -> None:
    """§6.19: an admin ends a temporary partner's app access now, e.g. a problem during the
    visit (unassign and cancel can't once it has started). They're logged out at once, like a
    suspended partner; a job still to do or under way is flagged to the admins
    (PARTNER_UNAVAILABLE) to finish or reassign. Logged with the reason."""
    with transaction.atomic():
        booking = _lock_booking(booking_id)
        partner_id = str(booking.partner_id) if booking.partner_id else ""
        if not partner_id or not partners.end_temporary(
            partner_id=partner_id, booking_id=str(booking.pk), reason="BY_ADMIN", actor=staff
        ):
            raise NotTemporary()
        record(
            staff,
            "temporary.access_ended",
            ("bookings.booking", str(booking.pk)),
            after={"partner_id": partner_id},
            reason=reason,
            ip=ip,
        )
        if booking.status in (S.ACCEPTED, S.IN_PROGRESS):
            alert = StaffAlert.objects.create(
                kind=AlertKind.PARTNER_UNAVAILABLE,
                booking=booking,
                pickup_at=booking.pickup_at,
                details={
                    "partner": booking.partner.full_name if booking.partner else "",
                    "why": "TEMP_ENDED",
                },
            )
            _alert(alert, booking)
        queue_changed(booking, "PARTNER_UNAVAILABLE")


def unassign(
    *,
    booking_id: str,
    staff: StaffUser,
    reason: str,
    ip: str | None,
    expected_assignment_id: str | None = None,
    check: bool = True,
) -> Booking:
    """The partner can't do it after all (they call the admin) or the admin withdraws the offer:
    back to the queue. Logged. `check`: the offer or job the admin was looking at."""
    with transaction.atomic():
        booking = _lock_booking(booking_id)
        if check:
            _expect(booking, expected_assignment_id)
        actor = _staff_actor(staff)
        offer = _open_offer(booking)
        partner_name = booking.partner.full_name if booking.partner else ""
        released_id = str(booking.partner_id) if booking.partner_id else None
        if booking.status == S.OFFERED and offer is not None:
            _withdraw(offer, "UNASSIGNED")
            _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
            bookings.transition(
                booking,
                "WITHDRAW",
                actor,
                note=reason,
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
        elif booking.status == S.ACCEPTED:
            # every live row of this partner (an open new-time offer too), one message
            _release(booking, booking.partner_id, "UNASSIGNED")
            _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT, AlertKind.PARTNER_UNAVAILABLE)
            bookings.transition(
                booking,
                "UNASSIGN",
                actor,
                note=reason,
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
        else:
            raise NotAssignable(details={"status": booking.status})
        booking.refresh_from_db()
        if released_id:  # a temporary partner (§6.19): their one job is gone, so is access
            partners.end_temporary(
                partner_id=released_id,
                booking_id=str(booking.pk),
                reason="UNASSIGNED",
                actor=staff,
            )
        record(
            staff,
            "booking.unassigned",
            ("bookings.booking", str(booking.pk)),
            before={"partner": partner_name},
            reason=reason,
            ip=ip,
        )
        queue_changed(booking, "UNASSIGNED")
        _to_patient(booking)
        return booking


# --- Partner: accept, decline ---


def _lock_offer(
    assignment_id: str, user_id: str | None = None
) -> tuple[Booking, BookingAssignment]:
    """The booking, then the offer (always in this order: see the module notes)."""
    rows = BookingAssignment.objects.filter(pk=uid(assignment_id))
    if user_id is not None:
        rows = rows.filter(partner__user_id=uid(user_id))
    booking_id = rows.values_list("booking_id", flat=True).first()
    if booking_id is None:
        raise NotFound()
    booking = _lock_booking(str(booking_id))
    offer = (
        BookingAssignment.objects.select_for_update(of=("self",))
        .select_related("partner")
        .get(pk=uid(assignment_id))
    )
    return booking, offer


def _accept(
    booking: Booking, offer: BookingAssignment, actor: bookings.Actor, response: str
) -> None:
    temporary = (
        offer.kind == OfferKind.TEMPORARY and offer.partner.status == PartnerStatus.TEMPORARY
    )
    if (offer.partner.status != PartnerStatus.APPROVED and not temporary) or is_deleting(
        str(offer.partner_id)
    ):
        raise PartnerNotEligible()  # suspended, deactivated or deleting meanwhile
    if offer.kind in (OfferKind.NEW, OfferKind.TEMPORARY):
        if booking.status != S.OFFERED or booking.partner_id != offer.partner_id:
            raise OfferNotOpen()
        try:
            with transaction.atomic():
                bookings.transition(
                    booking, "ACCEPT", actor, extra_updates={"reconfirm_needed": False}
                )
        except IntegrityError:
            # The database's no-overlap rule: they took another job at that time meanwhile.
            raise PartnerBusy() from None
        events.publish("booking.assigned", {"booking_id": str(booking.pk)})
        from apps.bookings import visit

        visit.issue_job_otp(booking)  # §6.11: shown to the owner, SMS to the member (after)
    else:
        if booking.status != S.ACCEPTED or booking.partner_id != offer.partner_id:
            raise OfferNotOpen()
        bookings.confirm_new_time(booking, actor)
    _close(offer, response)
    # accepted (or the new time confirmed): nothing is late any more
    _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT, AlertKind.ESCALATION)
    booking.refresh_from_db()
    queue_changed(booking, "ACCEPTED")
    _to_patient(booking)
    _to_partner(offer.partner, "booking.updated", {"bookingId": str(booking.pk)})


def accept(*, assignment_id: str, user_id: str) -> BookingAssignment:
    """R09 Accept (§6.10). The full address, phones and documents open after this."""
    with transaction.atomic():
        booking, offer = _lock_offer(assignment_id, user_id)
        if offer.response != OfferResponse.OPEN:
            raise OfferNotOpen()
        _accept(booking, offer, _partner_actor(offer.partner), OfferResponse.ACCEPTED)
        return offer


def decline(*, assignment_id: str, user_id: str, reason: str, note: str) -> BookingAssignment:
    """R09 Decline with a reason: back to the queue, the admin is alerted (§6.10). Declining a
    new time (re-confirm) also puts the booking back in the queue."""
    with transaction.atomic():
        booking, offer = _lock_offer(assignment_id, user_id)
        if offer.response != OfferResponse.OPEN:
            raise OfferNotOpen()
        actor = _partner_actor(offer.partner)
        if offer.kind == OfferKind.NEW and booking.status == S.OFFERED:
            bookings.transition(
                booking,
                "DECLINE",
                actor,
                note=reason,
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
        elif offer.kind == OfferKind.RECONFIRM and booking.status == S.ACCEPTED:
            # their job at the old time ends too (no message: they just said no)
            for row in BookingAssignment.objects.select_for_update(of=("self",)).filter(
                booking=booking, partner=offer.partner, response__in=ACCEPTED_RESPONSES
            ):
                _close(row, OfferResponse.WITHDRAWN)
            bookings.transition(
                booking,
                "UNASSIGN",
                actor,
                note=f"Declined the new time: {reason}",
                extra_updates={"partner": None, "reconfirm_needed": False},
            )
        else:
            raise OfferNotOpen()
        _close(offer, OfferResponse.DECLINED, decline_reason=reason, decline_note=note[:200])
        _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
        booking.refresh_from_db()
        alert = StaffAlert.objects.create(
            kind=AlertKind.DECLINED,
            booking=booking,
            assignment=offer,
            pickup_at=booking.pickup_at,
            details={
                "partner": offer.partner.full_name,
                "reason": reason,
                "note": note[:200],
                "reconfirm": offer.kind == OfferKind.RECONFIRM,
            },
        )
        _alert(alert, booking)
        queue_changed(booking, "DECLINED")
        _to_patient(booking)
        return offer


# --- Hooks from the bookings app (same transaction) ---


def on_cancel(*, booking_id: str, **_: Any) -> None:
    """A cancelled booking: open offers close; the booking's partner (offered or accepted) hears
    it's off, once. Earlier partners (declined, released) hear nothing."""
    booking = Booking.objects.get(pk=uid(booking_id))
    offers = BookingAssignment.objects.select_for_update(of=("self",)).select_related("partner")
    for offer in offers.filter(booking=booking, response=OfferResponse.OPEN):
        _close(offer, OfferResponse.WITHDRAWN)
        _to_partner(
            offer.partner,
            "offer.withdrawn",
            {"assignmentId": str(offer.pk), "bookingId": str(booking.pk)},
        )
    if booking.partner_id is not None:
        told = (
            offers.filter(booking=booking, partner_id=booking.partner_id)
            .order_by("-sent_at")
            .first()
        )
        if told is not None:
            _to_partner(told.partner, "booking.updated", {"bookingId": str(booking.pk)})
            events.publish("offer.withdrawn", {"assignment_id": str(told.pk), "why": "CANCELLED"})
    StaffAlert.objects.filter(booking=booking, acknowledged_at__isnull=True).update(
        acknowledged_at=timezone.now()
    )
    if booking.partner_id is not None:  # a temporary partner's access ends with it (§6.19)
        partners.end_temporary(
            partner_id=str(booking.partner_id), booking_id=str(booking.pk), reason="CANCELLED"
        )
    queue_changed(booking, "CANCELLED")


def on_reschedule(*, booking: Booking, released_partner_id: str | None) -> None:
    """§6.17: a new time for a booking with a partner.
    - The partner was busy then (the bookings app released them): their job is withdrawn.
    - They had accepted: they get a RECONFIRM offer (2-minute rule again).
    - It was only offered: the same offer goes on, for the new time (timer restarts).
    - Nobody yet: the queue re-sorts (new time, new deadline)."""
    # the old time's escalation is over; the new time gets its own if it is late too
    _resolve_alerts(booking, AlertKind.ESCALATION)
    if released_partner_id:
        _release(booking, uid(released_partner_id), "TIME_CHANGED")
        _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
        partners.end_temporary(
            partner_id=released_partner_id, booking_id=str(booking.pk), reason="RESCHEDULED"
        )
        queue_changed(booking, "UNASSIGNED")
        return
    open_offer = _open_offer(booking)
    if booking.status == S.ACCEPTED and booking.partner_id:
        if open_offer is not None:
            _close(open_offer, OfferResponse.WITHDRAWN)
        _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
        partner = PartnerProfile.objects.get(pk=booking.partner_id)
        _new_offer(booking, partner, OfferKind.RECONFIRM, None)
        queue_changed(booking, "RECONFIRM")
    elif booking.status == S.OFFERED and open_offer is not None:
        # a fresh offer for the new time: a new 2-minute timer and its own alert
        _close(open_offer, OfferResponse.WITHDRAWN)
        _to_partner(
            open_offer.partner,
            "offer.withdrawn",
            {"assignmentId": str(open_offer.pk), "bookingId": str(booking.pk)},
        )
        _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
        Booking.objects.filter(pk=booking.pk).update(reconfirm_needed=False)
        booking.reconfirm_needed = False
        _new_offer(booking, open_offer.partner, OfferKind.NEW, open_offer.assigned_by)
        queue_changed(booking, "OFFERED")
    elif booking.status == S.NEW:
        queue_changed(booking, "RESCHEDULED")


# --- Timers and sweeps (Celery) ---


def offer_timeout(assignment_id: str, *, now: dt.datetime | None = None) -> bool:
    """`accept_timeout_seconds` after an offer: still open → admin alert (call buttons) and a
    reminder to the partner. The offer stays open. Safe to run twice."""
    now = now or timezone.now()
    with transaction.atomic():
        try:
            _, offer = _lock_offer(assignment_id)
        except NotFound:
            return False
        if (
            offer.response != OfferResponse.OPEN
            or offer.reminded_at is not None
            or now < offer.timeout_at - dt.timedelta(seconds=2)
        ):
            return False
        offer.reminded_at = now
        offer.save(update_fields=["reminded_at", "updated_at"])
        try:
            with transaction.atomic():
                alert = StaffAlert.objects.create(
                    kind=AlertKind.OFFER_TIMEOUT,
                    booking=offer.booking,
                    assignment=offer,
                    pickup_at=offer.booking.pickup_at,
                    details={
                        "partner": offer.partner.full_name,
                        "partnerId": str(offer.partner_id),
                    },
                )
        except IntegrityError:
            return False
        _alert(alert, offer.booking)
        metrics.count("OfferTimeouts")  # §13 alarm
        _to_partner(
            offer.partner,
            "offer.reminder",
            {"assignmentId": str(offer.pk), "bookingId": str(offer.booking_id)},
        )
        events.publish("offer.reminder", {"assignment_id": str(offer.pk)})
        return True


def escalation_sweep(*, now: dt.datetime | None = None) -> int:
    """Every 5 min: paid bookings still without a sure partner (NEW / OFFERED, a new time not
    confirmed, the partner suspended) past their assign deadline → red alert and an email to the
    Super Admins (§6.17). Once per booking time."""
    from apps.assignments.selectors import NEEDS_PARTNER

    now = now or timezone.now()
    count = 0
    candidates = Booking.objects.filter(
        NEEDS_PARTNER,
        pickup_at__gt=now - dt.timedelta(hours=12),
        pickup_at__lte=now + dt.timedelta(days=2),
    ).annotate(settled_at=SETTLED_AT)
    for booking in candidates:
        deadline = booking_deadline(booking)
        if deadline > now:
            continue
        try:
            with transaction.atomic():
                alert = StaffAlert.objects.create(
                    kind=AlertKind.ESCALATION,
                    booking=booking,
                    pickup_at=booking.pickup_at,
                    details={"deadline": deadline.isoformat()},
                )
                _alert(alert, booking)
                _email_super_admins(booking)
        except IntegrityError:
            continue  # already escalated for this time
        count += 1
    return count


def _email_super_admins(booking: Booking) -> None:
    when = booking.pickup_at.astimezone(ZoneInfo(settings.DISPLAY_TIME_ZONE))
    subject = f"WellWish: booking {booking.code} still has no partner"
    text = (
        f"Booking {booking.code} ({booking.price_snapshot.get('name', '')}) on "
        f"{when:%d %b %Y, %I:%M %p} IST is still unassigned past its deadline. "
        "Please assign a partner from the admin panel's Unassigned queue."
    )
    emails = list(
        StaffUser.objects.filter(
            role__code="SUPER_ADMIN", status=StaffUser.Status.ACTIVE
        ).values_list("email", flat=True)
    )

    def send() -> None:
        for email in emails:
            try:
                send_mail(email, subject, text)
            except Exception:
                logger.exception("Escalation email failed")

    _after_commit(send)


def on_partner_unavailable(partner_id: str, why: str) -> int:
    """§6.16: a suspended or deactivated partner. Their open offers are withdrawn (the booking
    goes back to the queue) and every upcoming job of theirs is flagged to the admins for
    reassignment (PARTNER_UNAVAILABLE). Returns how many bookings were affected."""
    count = 0
    booking_ids = list(
        BookingAssignment.objects.filter(partner_id=uid(partner_id), response__in=LIVE)
        .values_list("booking_id", flat=True)
        .distinct()
    )
    for booking_id in booking_ids:
        with transaction.atomic():
            booking = _lock_booking(str(booking_id))
            if booking.partner_id != uid(partner_id):
                continue
            if booking.status == S.OFFERED:
                offer = _open_offer(booking)
                if offer is not None:
                    _close(offer, OfferResponse.WITHDRAWN)
                _resolve_alerts(booking, AlertKind.OFFER_TIMEOUT)
                bookings.transition(
                    booking,
                    "WITHDRAW",
                    bookings.SYSTEM,
                    note=f"Partner {why.lower()}",
                    extra_updates={"partner": None, "reconfirm_needed": False},
                )
                booking.refresh_from_db()
                queue_changed(booking, "UNASSIGNED")
            elif booking.status in (S.ACCEPTED, S.IN_PROGRESS):
                name = booking.partner.full_name if booking.partner else ""
                alert = StaffAlert.objects.create(
                    kind=AlertKind.PARTNER_UNAVAILABLE,
                    booking=booking,
                    pickup_at=booking.pickup_at,
                    details={"partner": name, "why": why},
                )
                _alert(alert, booking)
                queue_changed(booking, "PARTNER_UNAVAILABLE")
            else:
                continue
            count += 1
    return count


def raise_alert(
    booking: Booking,
    kind: str,
    details: dict[str, Any],
    *,
    once: bool = True,
    not_since: dt.datetime | None = None,
) -> StaffAlert | None:
    """An alert from another app for the admins (§9.1 Live): no location, a far step, fake
    GPS, wrong visit codes, patient not available, not completed. `once`: not again while one
    of this kind is still open for the booking. `not_since`: not again if one of this kind was
    raised after that moment, even if an admin has acknowledged it (the same silence)."""
    same_kind = StaffAlert.objects.filter(booking=booking, kind=kind)
    if once and same_kind.filter(acknowledged_at__isnull=True).exists():
        return None
    if not_since is not None and same_kind.filter(created_at__gte=not_since).exists():
        return None
    alert = StaffAlert.objects.create(
        kind=kind, booking=booking, pickup_at=booking.pickup_at, details=details
    )
    _alert(alert, booking)
    return alert


def acknowledge(*, alert_id: str, staff: StaffUser) -> StaffAlert:
    with transaction.atomic():
        alert = StaffAlert.objects.select_for_update().filter(pk=uid(alert_id)).first()
        if alert is None:
            raise NotFound()
        if alert.acknowledged_at is None:
            alert.acknowledged_at = timezone.now()
            alert.acknowledged_by = staff
            alert.save(update_fields=["acknowledged_at", "acknowledged_by", "updated_at"])
            data = {"id": str(alert.pk), "bookingId": str(alert.booking_id)}
            _after_commit(lambda: realtime.send_to_group(STAFF_OPS, "alert.acked", data))
        return alert


def forget_partner_name(*, partner_id: str, name: str, replacement: str) -> None:
    """§6.20: a deleted partner's name goes from what was written when they had offers and jobs:
    the offer events in the bookings' timelines and the admins' alerts."""
    if not name:
        return
    booking_ids = list(
        BookingAssignment.objects.filter(partner_id=uid(partner_id))
        .values_list("booking_id", flat=True)
        .distinct()
    )
    bookings.forget_partner_name(booking_ids=booking_ids, name=name, replacement=replacement)
    for alert in StaffAlert.objects.filter(booking_id__in=booking_ids, details__partner=name):
        alert.details = {**alert.details, "partner": replacement}
        alert.save(update_fields=["details", "updated_at"])
