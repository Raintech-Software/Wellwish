"""Ratings, "Report a problem" and the partner's totals (PHASES 8.7, 8.9; ARCHITECTURE §6.11,
§6.13, §9.1 Support)."""

import datetime as dt

import pytest
from django.utils import timezone

from apps.assignments.tests.test_assignments import accepted
from apps.audit.models import AuditLog
from apps.bookings.models import BookingEvent, BookingStatus
from apps.bookings.tests.test_visit import HOME, step
from apps.notifications.models import Notification
from apps.partners.models import PartnerProfile
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture
def completed(api, booking, asha, staff_roles):
    """Asha did the hospital visit (the admin marked the middle steps) and recorded ₹400 cash."""
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    for name in ("REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    step(api, token, booking.pk, "COMPLETED", **HOME)
    api.post(
        f"/partner/bookings/{booking.pk}/balance",
        {"amountPaise": 40000, "mode": "CASH", "note": ""},
        token,
    )
    return booking, token, ops


def test_the_family_rates_the_visit_once(api, world, completed, staff_roles):
    booking, token, _ = completed
    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert detail["canReview"] is True and detail["review"] is None
    resp = api.post(
        f"/patient/bookings/{booking.pk}/review",
        {"stars": 4, "tags": ["ON_TIME", "KIND"], "comment": "Very patient with Maa"},
        world.token,
    )
    assert resp.status_code == 200, resp.json()
    partner = PartnerProfile.objects.get(full_name="Asha Behera")
    assert (partner.rating_avg, partner.rating_count) == (4, 1)
    again = api.post(f"/patient/bookings/{booking.pk}/review", {"stars": 5}, world.token)
    assert again.json()["error"]["code"] == "ALREADY_REVIEWED"
    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert detail["canReview"] is False and detail["review"]["stars"] == 4

    mine = api.get("/partner/reviews", token).json()
    assert mine[0]["comment"] == "Very patient with Maa" and "Sabitri" not in str(mine)
    # the service in the partner's language too (Phase 9.1)
    assert mine[0]["serviceNameHi"] == booking.price_snapshot.get("name_hi", "")

    # moderation: hidden (not deleted), the average leaves it out; logged
    support = staff_token(api, staff_roles, "SUPPORT")
    review_id = api.get("/admin/reviews", support).json()["items"][0]["id"]
    hidden = api.post(
        f"/admin/reviews/{review_id}/hide", {"reason": "Mentions a phone number"}, support
    )
    assert hidden.json()["status"] == "HIDDEN"
    partner.refresh_from_db()
    assert (partner.rating_avg, partner.rating_count) == (None, 0)
    assert api.get("/partner/reviews", token).json() == []
    assert AuditLog.objects.filter(action="review.hidden").exists()


def test_a_review_needs_a_completed_visit(api, world, booking, asha, staff_roles):
    accepted(api, booking, asha, staff_roles)
    resp = api.post(f"/patient/bookings/{booking.pk}/review", {"stars": 5}, world.token)
    assert resp.json()["error"]["code"] == "NOT_REVIEWABLE"


def test_report_a_problem_within_24_hours_and_the_admin_replies(
    api, world, completed, staff_roles, django_capture_on_commit_callbacks
):
    booking, _, _ = completed
    resp = api.post(
        f"/patient/bookings/{booking.pk}/report-problem",
        {"text": "The companion left before the doctor came."},
        world.token,
    )
    assert resp.status_code == 200, resp.json()
    support = staff_token(api, staff_roles, "SUPPORT")
    tickets = api.get("/admin/tickets", support).json()["items"]
    assert tickets[0]["code"] == booking.code and tickets[0]["status"] == "OPEN"
    with django_capture_on_commit_callbacks(execute=True):
        replied = api.post(
            f"/admin/tickets/{tickets[0]['id']}/reply",
            {"text": "Sorry! We've spoken to the companion and will call you."},
            support,
        )
    assert replied.json()["replies"][0]["name"]
    assert Notification.objects.filter(type="TICKET_REPLY").exists()
    detail = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert detail["tickets"][0]["replies"][0]["text"].startswith("Sorry")
    closed = api.post(f"/admin/tickets/{tickets[0]['id']}/close", token=support)
    assert closed.json()["status"] == "CLOSED"
    assert api.get("/admin/tickets", support).json()["items"] == []

    # 24 hours later: too late in the app
    BookingEvent.objects.filter(booking=booking, to_status=BookingStatus.COMPLETED).update(
        server_ts=timezone.now() - dt.timedelta(hours=25)
    )
    late = api.post(
        f"/patient/bookings/{booking.pk}/report-problem", {"text": "One more thing"}, world.token
    )
    assert late.json()["error"]["code"] == "REPORT_TOO_LATE"
    finance = staff_token(api, staff_roles, "FINANCE")
    assert api.get("/admin/tickets", finance).status_code == 403


def test_the_partner_totals(api, world, completed):
    booking, token, _ = completed
    api.post(f"/patient/bookings/{booking.pk}/review", {"stars": 5}, world.token)
    totals = api.get("/partner/totals", token).json()
    assert totals["jobs"]["allTime"] == 1 and totals["jobs"]["thisMonth"] == 1
    assert totals["balanceAll"] == {"cashPaise": 40000, "upiPaise": 0}
    assert totals["offersReceived"] == 1 and totals["offersAccepted"] == 1
    assert totals["ratingAvg"] == "5.0" and totals["ratingCount"] == 1
    assert totals["recentReviews"][0]["stars"] == 5
