"""The admin dashboard (§9.1, Phase 9.2): today's numbers, each part only for roles allowed to
see it."""

import pytest

from apps.assignments.models import StaffAlert
from apps.bookings.times import IST
from conftest import staff_token

pytestmark = pytest.mark.django_db


def test_each_role_sees_its_parts(api, staff_roles):
    parts = ("bookings", "fees", "applications", "alerts")

    def seen(role):
        resp = api.get("/admin/dashboard", staff_token(api, staff_roles, role))
        assert resp.status_code == 200, resp.json()
        return {p for p in parts if resp.json()[p] is not None}

    assert seen("SUPER_ADMIN") == set(parts)
    assert seen("OPERATIONS") == {"bookings", "alerts"}
    assert seen("FINANCE") == {"fees"}
    assert seen("VERIFICATION") == {"applications"}
    assert seen("SUPPORT") == {"bookings", "alerts"}
    assert api.get("/admin/dashboard").status_code == 401


def test_todays_numbers(api, booking, staff_roles, monkeypatch):
    from apps.dashboard.api import staff as dashboard

    admin = staff_token(api, staff_roles)
    fees = api.get("/admin/dashboard", admin).json()["fees"]  # the fee was paid today
    assert (fees["payments"], fees["collectedPaise"], fees["refundedPaise"]) == (1, 10000, 0)
    assert fees["monthCollectedPaise"] == fees["monthNetPaise"] == 10000

    visit_day = booking.pickup_at.astimezone(IST).date()
    monkeypatch.setattr(dashboard, "today_ist", lambda: visit_day)  # "today" = the visit's day
    StaffAlert.objects.create(kind="OFFER_TIMEOUT", booking=booking, pickup_at=booking.pickup_at)
    data = api.get("/admin/dashboard", admin).json()
    assert data["date"] == visit_day.isoformat()
    assert data["bookings"]["new"] == 1 and data["bookings"]["completed"] == 0
    assert data["bookings"]["queueToday"] + data["bookings"]["queueLater"] == 1
    assert data["alerts"]["open"] == 1
    assert data["alerts"]["byKind"] == [{"kind": "OFFER_TIMEOUT", "count": 1}]
    assert data["alerts"]["sosOpen"] == 0
    assert data["applications"]["waiting"] == 0
