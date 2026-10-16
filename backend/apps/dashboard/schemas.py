"""The admin dashboard (§9.1, Phase 9.2): today at a glance. Each part is there only for roles
that may see it (null otherwise)."""

import datetime as dt

from pydantic import Field

from common.schemas import CamelSchema


class TodayBookingsOut(CamelSchema):
    """Bookings whose visit is today (India date), by status; and the whole Unassigned queue."""

    new: int = Field(..., description="Not assigned yet")
    offered: int = Field(..., description="Offered, waiting for the partner's answer")
    accepted: int
    in_progress: int
    completed: int
    no_show: int = Field(..., description="Patient not available")
    cancelled: int
    queue_today: int = Field(..., description="Unassigned queue: today (incl. late ones)")
    queue_later: int = Field(..., description="Unassigned queue: tomorrow and later")
    queue_late: int = Field(..., description="In the queue past their assign deadline")


class TodayFeesOut(CamelSchema):
    payments: int
    collected_paise: int
    refunded_paise: int
    month_collected_paise: int = Field(..., description="This month so far")
    month_net_paise: int


class ApplicationsOut(CamelSchema):
    waiting: int = Field(..., description="Submitted or under review")
    oldest_at: dt.datetime | None = None


class AlertCountOut(CamelSchema):
    kind: str
    count: int


class AlertsOut(CamelSchema):
    open: int = Field(..., description="Alerts nobody has marked as seen")
    by_kind: list[AlertCountOut]
    sos_open: int = Field(..., description="SOS not resolved")


class DashboardOut(CamelSchema):
    date: dt.date
    bookings: TodayBookingsOut | None = Field(None, description="bookings.view")
    fees: TodayFeesOut | None = Field(None, description="payments.view")
    applications: ApplicationsOut | None = Field(None, description="partners.review")
    alerts: AlertsOut | None = Field(None, description="bookings.view or live.view")
