"""Live location (ARCHITECTURE §6.11, §10.4).

- The partner's app sends a point every 10 s (or 20 m) from "On the way" to "Completed", over
  the socket (`location.update`) or, after a network drop, in a batch (`track-batch`).
- A point is used only if: the job is the partner's and in progress, a real position (finite,
  on the globe) with its accuracy ≤ 50 m, not a fake (mock) location, and not an impossible
  jump (> 120 km/h from the last point). Fake locations are refused and flagged to the admin.
- Live points carry the server's time (the phone's clock may be wrong); points kept offline
  carry the phone's time, kept between the job's start and now. A batch can still add to the
  route for a few minutes after the job ended (the app may send its last points then); the
  route is saved 2 minutes after the end.
- The latest point is kept in Redis (`loc:{partnerId}`) and the route so far in
  `track:{bookingId}`; the family gets `booking.location` (with an ETA) and the admins'
  live map `job.location` (at most every 15 s). When the job ends the route is saved to
  PostgreSQL (`booking_tracks`) and Redis is cleared.
- No point for 2 minutes during a job → admin alert (beat task, every minute). A point too
  rough to use (indoors the phone may only know its position to a few hundred metres) still
  shows the phone is alive: the alert is for a phone that went silent (battery, network).
"""

import datetime as dt
import itertools
import logging
import math
from dataclasses import dataclass
from decimal import Decimal
from typing import Any

from django.core.cache import cache
from django.db import transaction
from django.utils import timezone

from apps.bookings.models import Booking, BookingStatus
from apps.tracking import selectors
from apps.tracking.models import BookingTrack
from apps.tracking.selectors import alive_key, latest_point, loc_key, track_key
from common import realtime
from common.errors import NotFound
from common.geo import haversine_km
from common.ids import uid

logger = logging.getLogger(__name__)

S = BookingStatus
MAX_ACCURACY_M = 50
MAX_SPEED_KMH = 120
STAFF_EVERY_S = 15
NO_LOCATION_AFTER = dt.timedelta(minutes=2)
KEEP = 24 * 3600  # Redis keys outlive any job
MAX_POINTS = 6000
FINISH_AFTER_S = 120  # the route is saved this long after the end (late offline points)
LATE_POINTS = dt.timedelta(minutes=5)  # a batch for an ended job is still taken this long


@dataclass(frozen=True)
class Point:
    lat: float
    lng: float
    accuracy: float | None
    at: dt.datetime
    mock: bool = False


def _own_job(booking_id: str, partner_user_id: str) -> Booking | None:
    return (
        Booking.objects.select_related("partner", "hospital")
        .filter(pk=uid(booking_id), partner__user_id=uid(partner_user_id))
        .first()
    )


def _valid(point: Point) -> bool:
    numbers = (
        (point.lat, point.lng) if point.accuracy is None else (point.lat, point.lng, point.accuracy)
    )
    return (
        all(isinstance(n, int | float) and math.isfinite(n) for n in numbers)
        and -90 <= point.lat <= 90
        and -180 <= point.lng <= 180
        and point.at.tzinfo is not None
    )


def _reject(booking: Booking, point: Point, last: dict[str, Any] | None) -> str | None:
    """Why the point can't be used (None: fine)."""
    if not _valid(point):
        return "INVALID"
    if point.mock:
        return "MOCK"
    if point.accuracy is None or point.accuracy > MAX_ACCURACY_M:
        return "INACCURATE"
    if last:
        seconds = (_utc(point.at) - dt.datetime.fromisoformat(last["at"])).total_seconds()
        km = haversine_km(last["lat"], last["lng"], point.lat, point.lng)
        if seconds > 0 and km / (seconds / 3600) > MAX_SPEED_KMH:
            return "TOO_FAST"
    return None


def _utc(at: dt.datetime) -> dt.datetime:
    return at.astimezone(dt.UTC)


def _as_latest(booking: Booking, point: Point) -> dict[str, Any]:
    return {
        "bookingId": str(booking.pk),
        "lat": round(point.lat, 6),
        "lng": round(point.lng, 6),
        "accuracy": point.accuracy,
        "at": _utc(point.at).isoformat(),
    }


def _store(booking: Booking, points: list[dict[str, Any]], *, live: bool) -> None:
    """Adds points to the route (one write for a whole batch); `live`: the newest also becomes
    the partner's current position (only while the job is in progress)."""
    if not points:
        return
    if live and booking.partner_id:
        newest = max(points, key=lambda p: p["at"])
        current = cache.get(loc_key(booking.partner_id))
        if (
            not current
            or current.get("bookingId") != str(booking.pk)
            or current["at"] <= newest["at"]
        ):
            cache.set(loc_key(booking.partner_id), newest, KEEP)
    with transaction.atomic():
        # one writer at a time per job: a live point and a catch-up batch arriving together
        # would otherwise each read the route and the last write would drop the other's points
        Booking.objects.select_for_update().filter(pk=booking.pk).values_list("pk").first()
        track = cache.get(track_key(booking.pk)) or []
        room = MAX_POINTS - len(track)
        if room > 0:
            track.extend([p["at"], p["lat"], p["lng"]] for p in points[:room])
            cache.set(track_key(booking.pk), track, KEEP)


def _broadcast(booking: Booking, latest: dict[str, Any]) -> None:
    eta = selectors.eta_minutes(booking, latest["lat"], latest["lng"])
    # Same shape as GET …/live (LiveLocationOut): coordinates as "20.296100" strings.
    data = {
        "bookingId": str(booking.pk),
        "lat": f"{latest['lat']:.6f}",
        "lng": f"{latest['lng']:.6f}",
        "at": latest["at"],
        "etaMin": eta,
        "step": booking.current_step,
    }
    realtime.send_to_group(
        realtime.user_group("patient", str(booking.booked_by_id)), "booking.location", data
    )
    throttle = f"jobloc:{booking.pk}"
    if cache.add(throttle, 1, STAFF_EVERY_S):  # at most every 15 s for the admins' map
        realtime.send_to_group("staff.ops", "job.location", data | {"code": booking.code})


def flag_mock(booking: Booking) -> None:
    """A fake location: the admins get an alert (once while it's open for this job). Fake GPS
    on 3 different jobs suspends the partner for review, once no visit of theirs is in
    progress (§6.16; `partners.suspend_for_fake_gps`, run again when the job ends)."""
    from apps.assignments import services as assignments
    from apps.partners import services as partners

    partner = booking.partner
    with transaction.atomic():
        # one flag at a time per job (a live point and a step at the same moment)
        Booking.objects.select_for_update().filter(pk=booking.pk).values_list("pk").first()
        alert = assignments.raise_alert(
            booking,
            "MOCK_GPS",
            {
                "partner": partner.full_name if partner else "",
                "partnerId": str(partner.pk) if partner else "",
            },
        )
    if alert is not None and partner is not None and partners.suspend_for_fake_gps(str(partner.pk)):
        logger.warning("Partner of %s suspended: fake GPS on 3 jobs", booking.code)


def record_point(*, booking_id: str, partner_user_id: str, point: Point) -> str | None:
    """One live point (socket `location.update`). Returns why it was refused, or None."""
    booking = _own_job(booking_id, partner_user_id)
    if booking is None or booking.status != S.IN_PROGRESS:
        return "NOT_IN_PROGRESS"
    last = latest_point(booking)
    why = _reject(booking, point, last)
    if why == "MOCK":
        flag_mock(booking)
    if why:
        if why in ("INACCURATE", "TOO_FAST"):
            cache.set(alive_key(booking.pk), timezone.now().isoformat(), KEEP)  # the phone is on
        # the reason and accuracy only (never the position)
        logger.info(
            "Live point refused for %s: %s (accuracy %s m)", booking.code, why, point.accuracy
        )
        return why
    latest = _as_latest(booking, point)
    _store(booking, [latest], live=True)
    _broadcast(booking, latest)
    return None


def _job_window(booking: Booking) -> tuple[dt.datetime, dt.datetime] | None:
    """When points of this job can be taken: from "On the way" until now, or until the end
    while the route isn't saved yet (a few minutes)."""
    events = dict(
        booking.events.filter(event__in=("START", "COMPLETE", "NO_SHOW"))
        .order_by("server_ts")
        .values_list("event", "server_ts")
    )
    start = events.get("START")
    if start is None:
        return None
    now = timezone.now()
    if booking.status == S.IN_PROGRESS:
        return start, now
    ended = events.get("COMPLETE") or events.get("NO_SHOW")
    if (
        booking.status in (S.COMPLETED, S.PATIENT_NO_SHOW)
        and ended is not None
        and now - ended <= LATE_POINTS
        and not BookingTrack.objects.filter(booking=booking).exists()
    ):
        return start, ended
    return None


def record_batch(*, booking_id: str, partner_user_id: str, points: list[Point]) -> int:
    """Points kept on the phone while it was offline (oldest first): added to the route; the
    newest one is shown live. Returns how many were used."""
    booking = _own_job(booking_id, partner_user_id)
    if booking is None:
        raise NotFound()  # not this partner's booking (CLAUDE.md: ownership → 404)
    window = _job_window(booking)
    if window is None:
        return 0
    start, end = window
    timed = []
    for point in points:
        if not _valid(point):
            continue
        at = min(_utc(point.at), end)  # a phone clock ahead of the server's
        if at < start - dt.timedelta(minutes=1):
            continue  # before "On the way"
        timed.append(
            Point(lat=point.lat, lng=point.lng, accuracy=point.accuracy, at=at, mock=point.mock)
        )
    timed.sort(key=lambda p: p.at)
    latest = latest_point(booking)
    # the speed check starts from the live point only if it came before this batch
    previous = (
        latest if latest and timed and latest["at"] <= _utc(timed[0].at).isoformat() else None
    )
    kept: list[dict[str, Any]] = []
    mock = False
    for point in timed:
        why = _reject(booking, point, previous)
        mock = mock or why == "MOCK"
        if why:
            continue
        previous = _as_latest(booking, point)
        kept.append(previous)
    if mock:
        flag_mock(booking)
    live = booking.status == S.IN_PROGRESS
    _store(booking, kept, live=live)
    if kept and live:
        newest = cache.get(loc_key(booking.partner_id))
        if newest and newest.get("bookingId") == str(booking.pk):
            _broadcast(booking, newest)
    return len(kept)


# --- Saving the route at the end (§6.11) ---


def _encode(values: list[tuple[float, float]]) -> str:
    """Google's encoded polyline (precision 1e-5)."""
    out: list[str] = []
    prev_lat = prev_lng = 0
    for lat, lng in values:
        ilat, ilng = round(lat * 1e5), round(lng * 1e5)
        for delta in (ilat - prev_lat, ilng - prev_lng):
            v = ~(delta << 1) if delta < 0 else delta << 1
            while v >= 0x20:
                out.append(chr((0x20 | (v & 0x1F)) + 63))
                v >>= 5
            out.append(chr(v + 63))
        prev_lat, prev_lng = ilat, ilng
    return "".join(out)


def decode(polyline: str) -> list[tuple[float, float]]:
    points: list[tuple[float, float]] = []
    index = lat = lng = 0
    while index < len(polyline):
        for which in (0, 1):
            shift = result = 0
            while True:
                b = ord(polyline[index]) - 63
                index += 1
                result |= (b & 0x1F) << shift
                shift += 5
                if b < 0x20:
                    break
            delta = ~(result >> 1) if result & 1 else result >> 1
            if which == 0:
                lat += delta
            else:
                lng += delta
        points.append((lat / 1e5, lng / 1e5))
    return points


def finish(booking_id: str) -> BookingTrack | None:
    """The job ended: save the route and forget the live data (safe to run twice)."""
    booking = Booking.objects.filter(pk=uid(booking_id)).first()
    if booking is None:
        return None
    track = sorted(cache.get(track_key(booking.pk)) or [], key=lambda p: p[0])
    saved = BookingTrack.objects.filter(booking=booking).first()
    if track and saved is None:
        coords = [(float(p[1]), float(p[2])) for p in track]
        km = sum(haversine_km(a[0], a[1], b[0], b[1]) for a, b in itertools.pairwise(coords))
        saved = BookingTrack.objects.create(
            booking=booking,
            polyline=_encode(coords),
            points_count=len(coords),
            km=Decimal(str(round(km, 2))),
            started_at=dt.datetime.fromisoformat(track[0][0]),
            ended_at=dt.datetime.fromisoformat(track[-1][0]),
        )
    cache.delete(track_key(booking.pk))
    cache.delete(alive_key(booking.pk))
    latest = cache.get(loc_key(booking.partner_id)) if booking.partner_id else None
    if latest and latest.get("bookingId") == str(booking.pk):
        cache.delete(loc_key(booking.partner_id))
    return saved


# --- Watch (§10.5) ---


def no_location_watch(*, now: dt.datetime | None = None) -> int:
    """Every minute: a job in progress with no point for 2 minutes → admin alert (the phone may
    have died: the admin calls the alternate number). Once while the alert is open."""
    from apps.assignments import services as assignments

    now = now or timezone.now()
    count = 0
    for booking in Booking.objects.select_related("partner").filter(status=S.IN_PROGRESS):
        latest = latest_point(booking)
        alive = cache.get(alive_key(booking.pk))
        if latest or alive:
            last = max(dt.datetime.fromisoformat(t) for t in (latest and latest["at"], alive) if t)
        else:
            started = (
                booking.events.filter(event="START")
                .order_by("-server_ts")
                .values_list("server_ts", flat=True)
                .first()
            )
            if started is None:
                continue
            last = started
        if now - last < NO_LOCATION_AFTER:
            continue
        with transaction.atomic():
            alert = assignments.raise_alert(
                booking,
                "NO_LOCATION",
                {
                    "partner": booking.partner.full_name if booking.partner else "",
                    "since": last.isoformat(),
                },
                not_since=last,  # acknowledged: not again until the phone is back and silent again
            )
        count += 1 if alert else 0
    return count


def erase_for_owner(*, user_id: str) -> int:
    """Account deletion (§12): the saved routes of this account's visits go (they end at the
    family's home)."""
    deleted, _ = BookingTrack.objects.filter(booking__booked_by_id=uid(user_id)).delete()
    return deleted
