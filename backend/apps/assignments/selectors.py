"""Read queries for assignments, filtered by the caller (§6.5)."""

import datetime as dt
from dataclasses import dataclass
from typing import Any, Literal
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db.models import Count, Max, Prefetch, Q, QuerySet
from django.utils import timezone

from apps.assignments.models import BookingAssignment, OfferKind, OfferResponse, StaffAlert
from apps.bookings.models import Booking, BookingStatus
from apps.partners.models import PartnerProfile, PartnerStatus
from apps.partners.selectors import deleting_partner_ids, is_available_today
from common.dates import today_ist
from common.errors import NotFound
from common.geo import haversine_km
from common.ids import uid

S = BookingStatus
UNASSIGNED = (S.NEW, S.OFFERED)
# Partners who can do the job they accepted: approved ones, and a temporary partner on their
# one booking (§6.19).
ACTIVE_PARTNER = (PartnerStatus.APPROVED, PartnerStatus.TEMPORARY)
# Paid bookings without a sure partner: not assigned yet, a new time the partner hasn't
# confirmed, or a partner who was suspended or whose temporary access ended (§6.10, §6.16,
# §6.17).
NEEDS_PARTNER = (
    Q(status__in=UNASSIGNED)
    | Q(status=S.ACCEPTED, reconfirm_needed=True)
    | (Q(status=S.ACCEPTED) & ~Q(partner__status__in=ACTIVE_PARTNER))
)
When = Literal["all", "today", "tomorrow", "later"]


def _ist_start(day: dt.date) -> dt.datetime:
    return dt.datetime.combine(day, dt.time(0, 0), tzinfo=ZoneInfo(settings.DISPLAY_TIME_ZONE))


def queue(when: When = "all") -> QuerySet[Booking]:
    """The admins' Unassigned queue (§6.17): paid bookings without a partner yet (NEW, or
    OFFERED and waiting), soonest first. "Today" also holds anything whose time has passed."""
    today = today_ist()
    rows = Booking.objects.filter(NEEDS_PARTNER)
    tomorrow_start = _ist_start(today + dt.timedelta(days=1))
    later_start = _ist_start(today + dt.timedelta(days=2))
    if when == "today":
        rows = rows.filter(pickup_at__lt=tomorrow_start)
    elif when == "tomorrow":
        rows = rows.filter(pickup_at__gte=tomorrow_start, pickup_at__lt=later_start)
    elif when == "later":
        rows = rows.filter(pickup_at__gte=later_start)
    open_offers = BookingAssignment.objects.filter(response=OfferResponse.OPEN).select_related(
        "partner"
    )
    return (
        rows.select_related("partner", "hospital")
        .prefetch_related(Prefetch("assignments", queryset=open_offers, to_attr="open_offers"))
        .annotate(
            open_alerts=Count(
                "staff_alerts", filter=Q(staff_alerts__acknowledged_at__isnull=True), distinct=True
            ),
            # when it was paid or moved: a late booking gets 30 minutes (assign deadline)
            settled_at=Max("events__server_ts", filter=Q(events__event__in=("PAY", "RESCHEDULE"))),
        )
        .order_by("pickup_at")
    )


def queue_counts() -> dict[str, int]:
    return {
        "today": queue("today").count(),
        "tomorrow": queue("tomorrow").count(),
        "later": queue("later").count(),
    }


def open_offer(booking_id: str) -> BookingAssignment | None:
    return (
        BookingAssignment.objects.select_related("partner__user")
        .prefetch_related("partner__phones")
        .filter(booking_id=uid(booking_id), response=OfferResponse.OPEN)
        .first()
    )


def booking_offers(booking_id: str) -> QuerySet[BookingAssignment]:
    """Every offer for a booking, newest first (admin booking page)."""
    return (
        BookingAssignment.objects.select_related("partner__user", "assigned_by")
        .prefetch_related("partner__phones")
        .filter(booking_id=uid(booking_id))
        .order_by("-sent_at")
    )


def alerts(
    *, open_only: bool = True, booking_id: str = "", kinds: list[str] | None = None
) -> QuerySet[StaffAlert]:
    rows = (
        StaffAlert.objects.select_related("booking__partner", "assignment__partner__user")
        .prefetch_related("assignment__partner__phones", "booking__partner__phones")
        .order_by("-created_at")
    )
    if open_only:
        rows = rows.filter(acknowledged_at__isnull=True)
    if booking_id:
        rows = rows.filter(booking_id=uid(booking_id))
    if kinds:
        rows = rows.filter(kind__in=kinds)
    return rows


# --- Candidates (§6.10 suggestion list) ---


@dataclass(frozen=True)
class Candidate:
    partner: PartnerProfile
    distance_km: float | None
    available_today: bool
    jobs_this_week: int
    offered_now: bool


def candidates(booking: Booking) -> list[Candidate]:
    """APPROVED partners of the booking's type who are free then (no accepted job overlapping
    its time), best first: available today, then nearest to the pickup / home address."""
    busy = Booking.objects.filter(
        status__in=(S.ACCEPTED, S.IN_PROGRESS), busy_window__overlap=booking.busy_window
    ).exclude(pk=booking.pk)
    week_start = _ist_start(today_ist() - dt.timedelta(days=today_ist().weekday()))
    partners = (
        PartnerProfile.objects.filter(
            status=PartnerStatus.APPROVED, role=booking.price_snapshot["partner_type"]
        )
        .exclude(pk__in=busy.values("partner_id"))
        .exclude(pk__in=deleting_partner_ids())  # §6.20: asked to delete their account
        .select_related("user")
        .prefetch_related("phones")
        .annotate(
            week_jobs=Count(
                "bookings",
                filter=Q(
                    bookings__status__in=(S.ACCEPTED, S.IN_PROGRESS, S.COMPLETED),
                    bookings__pickup_at__gte=week_start,
                    bookings__pickup_at__lt=week_start + dt.timedelta(days=7),
                ),
                distinct=True,
            )
        )
    )
    lat = booking.address_snapshot.get("lat")
    lng = booking.address_snapshot.get("lng")
    offered = open_offer(str(booking.pk))
    rows: list[Candidate] = []
    for partner in partners:
        distance = None
        if lat and lng and partner.lat is not None and partner.lng is not None:
            distance = round(
                haversine_km(float(lat), float(lng), float(partner.lat), float(partner.lng)), 1
            )
        rows.append(
            Candidate(
                partner=partner,
                distance_km=distance,
                available_today=is_available_today(partner),
                jobs_this_week=int(getattr(partner, "week_jobs", 0)),
                offered_now=offered is not None and offered.partner_id == partner.pk,
            )
        )
    rows.sort(
        key=lambda c: (
            not c.available_today,
            c.distance_km if c.distance_km is not None else 1e9,
            c.partner.full_name,
        )
    )
    return rows


# --- Partner app ---


def partner_of(user_id: str) -> PartnerProfile:
    partner = PartnerProfile.objects.filter(user_id=uid(user_id)).first()
    if partner is None:
        raise NotFound()
    return partner


def partner_open_offers(user_id: str) -> QuerySet[BookingAssignment]:
    """R08 / R10 "New": the partner's open offers, soonest visit first."""
    return (
        BookingAssignment.objects.select_related(
            "booking", "booking__hospital", "booking__member", "partner"
        )
        .prefetch_related("booking__documents")
        .filter(partner__user_id=uid(user_id), response=OfferResponse.OPEN)
        .order_by("booking__pickup_at")
    )


def own_offer(user_id: str, assignment_id: str) -> BookingAssignment:
    offer = (
        BookingAssignment.objects.select_related(
            "booking", "booking__hospital", "booking__member", "partner"
        )
        .prefetch_related("booking__documents")
        .filter(pk=uid(assignment_id), partner__user_id=uid(user_id))
        .first()
    )
    if offer is None:
        raise NotFound()
    return offer


PartnerBucket = Literal["upcoming", "completed"]
ACCEPTED_STATUSES = (S.ACCEPTED, S.IN_PROGRESS)
DONE_STATUSES = (S.COMPLETED, S.PATIENT_NO_SHOW)


def partner_bookings(user_id: str, bucket: PartnerBucket) -> QuerySet[Booking]:
    """R10: accepted jobs (soonest first) or finished ones (latest first)."""
    partner = partner_of(user_id)
    rows = Booking.objects.select_related("hospital").filter(partner=partner)
    if bucket == "upcoming":
        return rows.filter(status__in=ACCEPTED_STATUSES).order_by("pickup_at")
    return rows.filter(status__in=DONE_STATUSES).order_by("-pickup_at")


def own_job(user_id: str, booking_id: str) -> Booking:
    """R11: a booking the partner accepted (or did). Others are 404 (§6.5)."""
    partner = partner_of(user_id)
    booking = (
        Booking.objects.select_related("hospital", "doctor", "member")
        .filter(
            pk=uid(booking_id),
            partner=partner,
            status__in=(*ACCEPTED_STATUSES, *DONE_STATUSES),
        )
        .first()
    )
    if booking is None:
        raise NotFound()
    return booking


def partner_today(user_id: str) -> QuerySet[Booking]:
    """R08: today's accepted jobs, and a job still in progress from an earlier day (a night
    visit past midnight: the app resumes its live location from Home, PHASES 9.11)."""
    partner = partner_of(user_id)
    start = _ist_start(today_ist())
    today = Q(
        status__in=(*ACCEPTED_STATUSES, *DONE_STATUSES),
        pickup_at__gte=start,
        pickup_at__lt=start + dt.timedelta(days=1),
    )
    return (
        Booking.objects.select_related("hospital")
        .filter(Q(partner=partner) & (today | Q(status=S.IN_PROGRESS)))
        .order_by("pickup_at")
    )


def partner_stats(user_id: str) -> dict[str, Any]:
    """R15 Totals (§6.13): jobs, balance collected (cash / UPI), acceptance, upcoming."""
    partner = partner_of(user_id)
    today = today_ist()
    day = _ist_start(today)
    week = _ist_start(today - dt.timedelta(days=today.weekday()))
    month = _ist_start(today.replace(day=1))
    done = Booking.objects.filter(partner=partner, status=S.COMPLETED)

    def balance(since: dt.datetime | None) -> dict[str, int]:
        rows = done.filter(pickup_at__gte=since) if since else done
        sums = {"CASH": 0, "UPI": 0}
        for mode, paise in rows.exclude(balance_collected_paise=None).values_list(
            "balance_mode", "balance_collected_paise"
        ):
            if mode in sums:
                sums[mode] += int(paise or 0)
        return {"cash_paise": sums["CASH"], "upi_paise": sums["UPI"]}

    offers = BookingAssignment.objects.filter(partner=partner)
    return {
        "jobs": {
            "today": done.filter(pickup_at__gte=day).count(),
            "this_week": done.filter(pickup_at__gte=week).count(),
            "this_month": done.filter(pickup_at__gte=month).count(),
            "all_time": done.count(),
        },
        "balance_week": balance(week),
        "balance_month": balance(month),
        "balance_all": balance(None),
        "offers_received": offers.count(),
        "offers_accepted": offers.filter(
            response__in=(OfferResponse.ACCEPTED, OfferResponse.ACCEPTED_BY_PHONE)
        ).count(),
        "offers_declined": offers.filter(response=OfferResponse.DECLINED).count(),
        "offers_not_answered": offers.filter(reminded_at__isnull=False).count(),
        "rating_avg": partner.rating_avg,
        "rating_count": partner.rating_count,
        "upcoming": Booking.objects.filter(
            partner=partner, status=S.ACCEPTED, pickup_at__gte=timezone.now()
        ).count(),
    }


def partner_totals(user_id: str) -> dict[str, int]:
    """R08 quick totals: jobs done today / this week, open offers."""
    partner = partner_of(user_id)
    today = today_ist()
    day = _ist_start(today)
    week = _ist_start(today - dt.timedelta(days=today.weekday()))
    done = Booking.objects.filter(partner=partner, status=S.COMPLETED)
    return {
        "today": done.filter(pickup_at__gte=day).count(),
        "this_week": done.filter(pickup_at__gte=week).count(),
        "upcoming": Booking.objects.filter(
            partner=partner, status=S.ACCEPTED, pickup_at__gte=timezone.now()
        ).count(),
    }


def partner_performance(start: dt.date, end: dt.date) -> list[dict[str, Any]]:
    """Partner performance report (9.2): for each approved partner, and anyone else with work on
    these India dates (`end` included): jobs done and patient-not-available by visit date;
    offers sent then, accepted, declined and not answered in 2 minutes; the rating."""
    since = _ist_start(start)
    until = _ist_start(end + dt.timedelta(days=1))
    done_statuses = (S.COMPLETED, S.PATIENT_NO_SHOW)
    visits = (
        Booking.objects.filter(
            partner__isnull=False,
            status__in=done_statuses,
            pickup_at__gte=since,
            pickup_at__lt=until,
        )
        .values("partner_id")
        .annotate(
            jobs=Count("pk", filter=Q(status=S.COMPLETED)),
            no_show=Count("pk", filter=Q(status=S.PATIENT_NO_SHOW)),
        )
    )
    offers = (
        # a temporary assign is given by phone, not an offer they answer (§6.19)
        BookingAssignment.objects.filter(sent_at__gte=since, sent_at__lt=until)
        .exclude(kind=OfferKind.TEMPORARY)
        .values("partner_id")
        .annotate(
            received=Count("pk"),
            accepted=Count(
                "pk",
                filter=Q(response__in=(OfferResponse.ACCEPTED, OfferResponse.ACCEPTED_BY_PHONE)),
            ),
            declined=Count("pk", filter=Q(response=OfferResponse.DECLINED)),
            not_answered=Count("pk", filter=Q(reminded_at__isnull=False)),
        )
    )
    by_partner: dict[Any, dict[str, int]] = {}
    for row in visits:
        by_partner.setdefault(row["partner_id"], {}).update(
            jobs=row["jobs"], no_show=row["no_show"]
        )
    for row in offers:
        by_partner.setdefault(row["partner_id"], {}).update(
            {k: row[k] for k in ("received", "accepted", "declined", "not_answered")}
        )
    partners = PartnerProfile.objects.filter(
        Q(status=PartnerStatus.APPROVED) | Q(pk__in=list(by_partner))
    ).order_by("full_name")
    rows: list[dict[str, Any]] = []
    for partner in partners:
        counts = by_partner.get(partner.pk, {})
        received = counts.get("received", 0)
        accepted = counts.get("accepted", 0)
        rows.append(
            {
                "partner_id": str(partner.pk),
                "name": partner.full_name,
                "role": partner.role,
                "status": partner.status,
                "jobs": counts.get("jobs", 0),
                "no_show": counts.get("no_show", 0),
                "offers_received": received,
                "offers_accepted": accepted,
                "offers_declined": counts.get("declined", 0),
                "offers_not_answered": counts.get("not_answered", 0),
                "acceptance_percent": round(accepted * 100 / received) if received else None,
                "rating_avg": partner.rating_avg,
                "rating_count": partner.rating_count,
            }
        )
    return rows


def partner_flagged_jobs(partner_id: str, kind: str, *, since: dt.datetime | None) -> int:
    """On how many different jobs this partner got an alert of this kind (e.g. fake GPS,
    §6.16) since `since` (their last approval or reinstatement)."""
    alerts = StaffAlert.objects.filter(kind=kind, details__partnerId=str(partner_id))
    if since is not None:
        alerts = alerts.filter(created_at__gte=since)
    return alerts.values("booking_id").distinct().count()


def unassigned_count(*, settled_before: dt.datetime) -> int:
    """§13 alarm: bookings in the Unassigned queue, paid (or moved) before `settled_before`
    (visits more than 12 hours ago left out)."""
    from apps.assignments.services import SETTLED_AT

    return (
        Booking.objects.filter(NEEDS_PARTNER, pickup_at__gt=timezone.now() - dt.timedelta(hours=12))
        .annotate(settled_at=SETTLED_AT)
        .filter(settled_at__lte=settled_before)
        .count()
    )


def open_alert_counts() -> dict[str, int]:
    """The dashboard (9.2): alerts nobody has marked as seen, by kind."""
    rows = (
        StaffAlert.objects.filter(acknowledged_at__isnull=True)
        .values("kind")
        .annotate(count=Count("pk"))
    )
    return {str(row["kind"]): int(row["count"]) for row in rows}
