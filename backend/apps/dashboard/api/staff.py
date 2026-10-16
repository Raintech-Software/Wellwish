"""Admin dashboard (/v1/admin/dashboard, §9.1, Phase 9.2): today's numbers and alerts. Every
role has `dashboard.view`; each part shows only for roles allowed to see it."""

from django.http import HttpRequest
from django.utils import timezone
from ninja import Router

from apps.assignments import selectors as assignments
from apps.assignments.services import booking_deadline
from apps.bookings import selectors as bookings
from apps.dashboard.schemas import (
    AlertCountOut,
    AlertsOut,
    ApplicationsOut,
    DashboardOut,
    TodayBookingsOut,
    TodayFeesOut,
)
from apps.kyc import selectors as kyc
from apps.payments import selectors as payments
from apps.safety import selectors as safety
from common.auth import get_principal, staff_permission
from common.dates import today_ist

router = Router(tags=["admin"])


@router.get("/dashboard", response=DashboardOut, by_alias=True, operation_id="adminDashboard")
@staff_permission("dashboard.view")
def dashboard(request: HttpRequest) -> DashboardOut:
    can = get_principal(request).permissions
    today = today_ist()
    bookings_out = fees_out = applications_out = alerts_out = None
    if "bookings.view" in can:
        counts = bookings.day_counts(today)
        queue = list(assignments.queue("all"))
        now = timezone.now()
        queue_today = assignments.queue_counts()["today"]
        bookings_out = TodayBookingsOut(
            new=counts["NEW"],
            offered=counts["OFFERED"],
            accepted=counts["ACCEPTED"],
            in_progress=counts["IN_PROGRESS"],
            completed=counts["COMPLETED"],
            no_show=counts["PATIENT_NO_SHOW"],
            cancelled=counts["CANCELLED"],
            queue_today=queue_today,
            queue_later=len(queue) - queue_today,
            queue_late=sum(1 for b in queue if now >= booking_deadline(b)),
        )
    if "payments.view" in can:
        day = payments.fee_report(today, today)
        month = payments.fee_report(today.replace(day=1), today)
        fees_out = TodayFeesOut(
            payments=sum(r["payments"] for r in day),
            collected_paise=sum(r["collected"] for r in day),
            refunded_paise=sum(r["refunded"] for r in day),
            month_collected_paise=sum(r["collected"] for r in month),
            month_net_paise=sum(r["net"] for r in month),
        )
    if "partners.review" in can:
        waiting, oldest = kyc.applications_waiting()
        applications_out = ApplicationsOut(waiting=waiting, oldest_at=oldest)
    if can.intersection({"bookings.view", "live.view"}):
        alerts = assignments.open_alert_counts()
        alerts_out = AlertsOut(
            open=sum(alerts.values()),
            by_kind=[AlertCountOut(kind=k, count=v) for k, v in sorted(alerts.items())],
            sos_open=safety.sos_open_count(),
        )
    return DashboardOut(
        date=today,
        bookings=bookings_out,
        fees=fees_out,
        applications=applications_out,
        alerts=alerts_out,
    )
