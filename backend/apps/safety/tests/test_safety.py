"""SOS and the trip share link (PHASES 8.8; ARCHITECTURE §6.15)."""

import pytest
from django.core.cache import cache

from apps.accounts.models import User
from apps.assignments.tests.test_assignments import accepted
from apps.audit.models import AuditLog
from apps.bookings.tests.test_visit import HOME, step
from apps.partners.models import PartnerProfile
from apps.patients.models import Member
from apps.safety.models import SosEvent
from apps.tracking import services as tracking
from common.sms import read_dev_outbox as read_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def fresh_cache():
    cache.clear()
    yield
    cache.clear()


def test_the_partner_presses_sos(
    api, booking, asha, staff_roles, sent, django_capture_on_commit_callbacks
):
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    early = api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    assert early.json()["error"]["code"] == "NOT_IN_PROGRESS"
    step(api, token, booking.pk, "ON_THE_WAY")
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/partner/bookings/{booking.pk}/sos", {"lat": "20.290000", "lng": "85.840000"}, token
        )
    assert resp.status_code == 200, resp.json()
    alarm = [d for g, k, d in sent if g == "staff.ops" and k == "sos.new"]
    assert alarm and alarm[0]["side"] == "PARTNER" and alarm[0]["lat"] == "20.290000"
    emergency = PartnerProfile.objects.get(full_name="Asha Behera").emergency_phone
    sms = read_sms(emergency)[-1]
    assert (
        sms["template"] == "SOS_ALERT" and "maps.google.com/?q=20.290000,85.840000" in sms["text"]
    )
    # pressing again repeats the alarm, no second SOS
    api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    assert SosEvent.objects.count() == 1

    # the console: Support may look, Operations acknowledges and resolves (logged)
    support = staff_token(api, staff_roles, "SUPPORT")
    rows = api.get("/admin/sos", support).json()["items"]
    assert rows[0]["code"] == booking.code and rows[0]["status"] == "OPEN"
    sos_id = rows[0]["id"]
    assert api.post(f"/admin/sos/{sos_id}/ack", token=support).status_code == 403
    assert api.post(f"/admin/sos/{sos_id}/ack", token=ops).json()["status"] == "ACKNOWLEDGED"
    done = api.post(f"/admin/sos/{sos_id}/resolve", {"notes": "Partner slipped, is fine"}, ops)
    assert done.json()["status"] == "RESOLVED"
    assert api.get("/admin/sos", ops).json()["items"] == []  # active only by default
    assert AuditLog.objects.filter(action__in=("sos.acknowledged", "sos.resolved")).count() == 2


def test_the_family_presses_sos(
    api, world, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    Member.objects.filter(pk=world.mother["id"]).update(emergency_phone="+919876500077")
    step(api, token, booking.pk, "ON_THE_WAY")
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(f"/patient/bookings/{booking.pk}/sos", {}, world.token)
    assert resp.status_code == 200, resp.json()
    sms = read_sms("+919876500077")[-1]
    assert sms["template"] == "SOS_ALERT" and "not shared" in sms["text"]


def test_the_share_link_follows_the_trip_until_it_ends(api, world, booking, asha, staff_roles):
    token, user_id = asha
    ops = accepted(api, booking, asha, staff_roles)
    link = api.post(f"/patient/bookings/{booking.pk}/share-link", token=world.token).json()
    page_url, secret = link["url"].split("#", 1)
    assert page_url.endswith("/t/") and len(secret) >= 20  # the secret is never in a URL path
    shared = {"HTTP_X_SHARE_TOKEN": secret}
    trip = api.get("/public/track", **shared).json()
    assert trip["partnerFirstName"] == "Asha" and trip["lat"] is None
    assert "phone" not in str(trip).lower()
    step(api, token, booking.pk, "ON_THE_WAY")
    tracking.record_point(
        booking_id=str(booking.pk),
        partner_user_id=user_id,
        point=tracking.Point(
            lat=20.28,
            lng=85.83,
            accuracy=9,
            at=booking.created_at.now(tz=booking.created_at.tzinfo),
        ),
    )
    trip = api.get("/public/track", **shared).json()
    assert trip["lat"] == "20.280000" and trip["step"] == "ON_THE_WAY"
    page = api.client.get("/t/")
    assert page.status_code == 200 and b"leaflet" in page.content and b"integrity=" in page.content
    # in the sharer's language (Phase 9.1): an Odia family's link opens the page in Odia
    assert "ରାସ୍ତାରେ" in page.content.decode() and "रास्ते में" in page.content.decode()
    assert "serviceNameOr" in trip
    User.objects.filter(pk=booking.booked_by_id).update(language="or")
    odia = api.post(f"/patient/bookings/{booking.pk}/share-link", token=world.token).json()
    assert odia["url"].split("#", 1)[0].endswith("/t/?l=or")
    for name in ("REACHED_PATIENT", "PICKED_UP", "REACHED_HOSPITAL", "VISIT_DONE", "DROPPED_HOME"):
        api.post(f"/admin/bookings/{booking.pk}/steps", {"step": name, "reason": "Test run"}, ops)
    step(api, token, booking.pk, "COMPLETED", **HOME)
    assert api.get("/public/track", **shared).status_code == 404  # the visit ended
    assert api.get("/public/track", HTTP_X_SHARE_TOKEN="not-a-real-token").status_code == 404


def test_an_sos_nobody_acknowledges_in_2_minutes_reaches_the_super_admins(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    """§13: the panel may be closed (at night): after 2 minutes the Super Admins get an email
    and WellWish's support phone an SMS, once; an acknowledged SOS is left alone."""
    import datetime as dt

    from django.utils import timezone

    from apps.app_config.selectors import get_setting
    from apps.safety import services
    from apps.staff.models import StaffUser
    from common.mail import read_dev_outbox as read_mail
    from common.phone import normalize_indian_mobile

    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    staff_token(api, staff_roles, "SUPER_ADMIN")
    boss = StaffUser.objects.get(role__code="SUPER_ADMIN")
    step(api, token, booking.pk, "ON_THE_WAY")
    api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    sos = SosEvent.objects.get()
    now = timezone.now()
    with django_capture_on_commit_callbacks(execute=True):
        assert services.escalate_unacknowledged(now=now + dt.timedelta(seconds=90)) == 0
        assert services.escalate_unacknowledged(now=now + dt.timedelta(minutes=2, seconds=5)) == 1
        assert services.escalate_unacknowledged(now=now + dt.timedelta(minutes=5)) == 0  # once
    mail = read_mail(boss.email)[-1]
    assert booking.code in mail["subject"] and "not acknowledged" in mail["subject"]
    support = normalize_indian_mobile(str(get_setting("support_phone")))
    assert read_sms(support)[-1]["template"] == "SOS_UNACKED"
    sos.refresh_from_db()
    assert sos.escalated_at is not None

    # the family's SOS, acknowledged in time: no escalation
    SosEvent.objects.all().delete()
    api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    api.post(f"/admin/sos/{SosEvent.objects.get().pk}/ack", token=ops)
    assert services.escalate_unacknowledged(now=now + dt.timedelta(minutes=10)) == 0


def test_an_sos_from_a_fake_location_still_goes_but_is_flagged(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    """Deep check 9.3: never refused; the admins see the flag, the SMS leaves the place out."""
    token, _ = asha
    ops = accepted(api, booking, asha, staff_roles)
    step(api, token, booking.pk, "ON_THE_WAY")
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            f"/partner/bookings/{booking.pk}/sos",
            {"lat": "20.290000", "lng": "85.840000", "mock": True},
            token,
        )
    assert resp.status_code == 200
    row = api.get("/admin/sos", ops).json()["items"][0]
    assert row["mockLocation"] is True and row["lat"] == "20.290000"
    emergency = PartnerProfile.objects.get(full_name="Asha Behera").emergency_phone
    sms = read_sms(emergency)[-1]
    assert sms["template"] == "SOS_ALERT" and "maps.google.com" not in sms["text"]
    assert "not shared" in sms["text"]
