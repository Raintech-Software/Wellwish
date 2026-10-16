"""SOS and the trip share link (ARCHITECTURE §6.15).

- SOS: on a job in progress, the partner or the family presses SOS. The admins get an alarm (a
  red banner and a sound until someone acknowledges it, then it's resolved with a note) and the
  emergency contacts get an SMS with the location. The apps also show one-tap 112 and 108.
- Share link: the family shares the trip with someone without the app. A secret link shows the
  partner's first name, the step and the live position until the job ends (12 hours at most).
  Only its hash is stored.
"""

import datetime as dt
import hashlib
import secrets
from decimal import Decimal
from typing import Any

from django.conf import settings
from django.db import transaction
from django.utils import timezone

from apps.accounts import selectors as accounts_selectors
from apps.audit.services import record
from apps.bookings import selectors as booking_selectors
from apps.bookings.models import Booking, BookingStatus
from apps.safety.models import ShareLink, SosEvent, SosStatus
from apps.staff.models import StaffUser
from common import events, realtime
from common.errors import Conflict, NotFound
from common.ids import uid

S = BookingStatus
SHARE_MAX = dt.timedelta(hours=12)
ACK_WITHIN = dt.timedelta(minutes=2)  # §13: SOS not acknowledged within 2 minutes


class NotDuringAJob(Conflict):
    code = "NOT_IN_PROGRESS"
    message = "SOS works during a visit. In an emergency call 112 (or 108 for an ambulance)."


class AlreadyResolved(Conflict):
    code = "SOS_ALREADY_RESOLVED"
    message = "Another admin already resolved this SOS."


def _coord(value: float | None) -> Decimal | None:
    return Decimal(str(value)).quantize(Decimal("0.000001")) if value is not None else None


def raise_sos(
    *,
    booking: Booking,
    user_id: str,
    side: str,
    lat: float | None,
    lng: float | None,
    mock: bool = False,
) -> SosEvent:
    """The partner (`side` PARTNER) or the family (PATIENT) pressed SOS. Pressing again while
    one is open just repeats the alarm."""
    if booking.status != S.IN_PROGRESS:
        raise NotDuringAJob()
    with transaction.atomic():
        # The booking's row lock lines up two presses at once: the second finds the first's
        # open SOS (no second alarm, no second SMS).
        Booking.objects.select_for_update(of=("self",)).filter(pk=booking.pk).first()
        sos = (
            SosEvent.objects.select_for_update()
            .filter(booking=booking, raised_by_type=side, status=SosStatus.OPEN)
            .first()
        )
        if sos is None:
            sos = SosEvent.objects.create(
                booking=booking,
                raised_by_type=side,
                raised_by_id=uid(user_id),
                lat=_coord(lat),
                lng=_coord(lng),
                mock_location=mock,
            )
            events.publish("sos.raised", {"sos_id": str(sos.pk)})
        elif lat is not None and lng is not None:
            sos.lat, sos.lng, sos.mock_location = _coord(lat), _coord(lng), mock
            sos.save(update_fields=["lat", "lng", "mock_location", "updated_at"])
        data = sos_message(sos, booking)
        transaction.on_commit(
            lambda: realtime.send_to_group("staff.ops", "sos.new", data), robust=True
        )
    return sos


def sos_message(sos: SosEvent, booking: Booking) -> dict[str, Any]:
    return {
        "id": str(sos.pk),
        "bookingId": str(booking.pk),
        "code": booking.code,
        "side": sos.raised_by_type,
        "lat": str(sos.lat) if sos.lat is not None else None,
        "lng": str(sos.lng) if sos.lng is not None else None,
        "mockLocation": sos.mock_location,
        "partner": booking.partner.full_name if booking.partner else "",
    }


def acknowledge(*, sos_id: str, staff: StaffUser, ip: str | None) -> SosEvent:
    """Someone is on it: the alarm stops for everyone. Logged."""
    with transaction.atomic():
        sos = SosEvent.objects.select_for_update().filter(pk=uid(sos_id)).first()
        if sos is None:
            raise NotFound()
        if sos.status == SosStatus.OPEN:
            sos.status, sos.ack_by, sos.ack_at = SosStatus.ACKNOWLEDGED, staff, timezone.now()
            sos.save(update_fields=["status", "ack_by", "ack_at", "updated_at"])
            record(staff, "sos.acknowledged", sos, ip=ip)
            data = {"id": str(sos.pk), "status": sos.status}
            transaction.on_commit(
                lambda: realtime.send_to_group("staff.ops", "sos.updated", data), robust=True
            )
        return sos


def resolve(*, sos_id: str, staff: StaffUser, notes: str, ip: str | None) -> SosEvent:
    """What happened and how it ended. Logged."""
    with transaction.atomic():
        sos = SosEvent.objects.select_for_update().filter(pk=uid(sos_id)).first()
        if sos is None:
            raise NotFound()
        if sos.status == SosStatus.RESOLVED:
            raise AlreadyResolved()  # another admin closed it meanwhile: keep their notes
        now = timezone.now()
        if sos.status == SosStatus.OPEN:
            sos.ack_by, sos.ack_at = staff, now
        sos.status, sos.resolved_by, sos.resolved_at, sos.notes = (
            SosStatus.RESOLVED,
            staff,
            now,
            notes,
        )
        sos.save()
        record(staff, "sos.resolved", sos, reason=notes, ip=ip)
        data = {"id": str(sos.pk), "status": sos.status}
        transaction.on_commit(
            lambda: realtime.send_to_group("staff.ops", "sos.updated", data), robust=True
        )
        return sos


def escalate_unacknowledged(*, now: dt.datetime | None = None) -> int:
    """Every minute (§13): an SOS nobody acknowledged within 2 minutes (the panel may be closed,
    e.g. at night) → `sos.unacknowledged`: the Super Admins get an email and the support phone an
    SMS. Once per SOS."""
    now = now or timezone.now()
    waiting = SosEvent.objects.filter(
        status=SosStatus.OPEN,
        escalated_at__isnull=True,
        created_at__lte=now - ACK_WITHIN,
    ).values_list("pk", flat=True)
    count = 0
    for sos_id in list(waiting):
        with transaction.atomic():
            sos = (
                SosEvent.objects.select_for_update()
                .filter(pk=sos_id, status=SosStatus.OPEN, escalated_at__isnull=True)
                .first()
            )
            if sos is None:
                continue  # acknowledged meanwhile
            sos.escalated_at = now
            sos.save(update_fields=["escalated_at", "updated_at"])
            events.publish("sos.unacknowledged", {"sos_id": str(sos.pk)})
        count += 1
    return count


# --- Share link ---


def _hash(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


def create_share_link(*, user_id: str, booking_id: str) -> tuple[str, dt.datetime]:
    """P19 "Share": a new secret link for this job (from acceptance until it ends)."""
    booking = booking_selectors.own_booking(user_id, booking_id)
    if booking.status not in (S.ACCEPTED, S.IN_PROGRESS):
        raise NotDuringAJob(message="The trip can be shared from acceptance until the visit ends.")
    token = secrets.token_urlsafe(18)
    expires = timezone.now() + SHARE_MAX
    ShareLink.objects.create(
        booking=booking, token_hash=_hash(token), expires_at=expires, created_by_id=uid(user_id)
    )
    base = settings.SHARE_LINK_BASE_URL.rstrip("/")
    # The page speaks the sharer's language (9.1); the language isn't secret, the token is.
    language = accounts_selectors.get_user(user_id).language
    query = f"?l={language}" if language in ("hi", "or") else ""
    # After "#": browsers don't send it to the server, so it never lands in an access log.
    return f"{base}/t/{query}#{token}", expires


def shared_booking(token: str) -> Booking:
    """The booking behind a share link; gone once the link expired or the job ended."""
    link = (
        ShareLink.objects.select_related("booking", "booking__partner", "booking__hospital")
        .filter(token_hash=_hash(token), expires_at__gt=timezone.now())
        .first()
    )
    if link is None or link.booking.status not in (S.ACCEPTED, S.IN_PROGRESS):
        raise NotFound()
    return link.booking


def erase_for_owner(*, user_id: str) -> None:
    """Account deletion (§12): SOS rows are kept for the record without their position; the
    trip links go."""
    SosEvent.objects.filter(booking__booked_by_id=uid(user_id)).update(lat=None, lng=None)
    ShareLink.objects.filter(booking__booked_by_id=uid(user_id)).delete()
