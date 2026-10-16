"""Inbox, templates in the user's language, and the push / email / SMS adapters (3.11)."""

import pytest

from apps.accounts.models import Device, User
from apps.notifications.models import Notification
from apps.notifications.services import notify
from apps.partners.tests.support import partner_login
from common import push
from common.mail import read_dev_outbox as read_mail
from common.push import read_dev_outbox as read_push
from common.sms import read_dev_outbox as read_sms

pytestmark = pytest.mark.django_db


@pytest.fixture
def user():
    return User.objects.create_user("+919876511111")


def test_notify_uses_every_channel_in_the_users_language(user):
    user.language = "hi"
    user.save()
    Device.objects.create(
        user=user, app="partner", device_id="d1", platform="android", fcm_token="tok-1"
    )
    notify(
        user_id=str(user.pk),
        app="partner",
        code="PARTNER_APPROVED",
        variables={"name": "Asha"},
        email="asha@example.com",
        phone=user.phone,
    )
    inbox = Notification.objects.get(user=user)
    assert inbox.title == "आप स्वीकृत हैं!"
    assert "Asha" in inbox.body
    assert read_push("tok-1")[0]["title"] == "आप स्वीकृत हैं!"
    assert read_mail("asha@example.com")[0]["subject"] == "WellWish में स्वागत है!"  # Phase 9.1
    assert "approved" in read_sms(user.phone)[0]["text"]  # SMS stay English (Phase 9 decision)


def test_dates_and_service_names_in_the_persons_language_sms_in_english(user):
    """Phase 9.1: no English date or service name inside a Hindi or Odia message."""
    import datetime as dt

    from apps.notifications import text

    visit = dt.datetime(2026, 10, 13, 10, 0, tzinfo=text.IST)  # a Tuesday
    when = text.when(visit)
    assert when["en"] == "Tue 13 Oct, 10:00 AM"  # as before
    assert when["hi"] == "मंगल, 13 अक्टू॰, 10:00 am"
    assert when["or"] == "ମଙ୍ଗଳ, 13 ଅକ୍ଟୋବର, 10:00 AM"
    afternoon = text.when(visit.replace(hour=15, minute=30))
    assert afternoon["hi"].endswith("3:30 pm") and afternoon["or"].endswith("3:30 PM")
    service = text.service({"name": "Doctor visit companion", "name_hi": "डॉक्टर विज़िट साथी"})
    assert service == {
        "en": "Doctor visit companion",
        "hi": "डॉक्टर विज़िट साथी",
        "or": "Doctor visit companion",
    }

    user.language = "hi"
    user.save()
    notify(
        user_id=str(user.pk),
        app="patient",
        code="BOOKING_CONFIRMED",
        variables={"code": "WW-1", "name": "Sabitri", "service": service, "when": when},
        phone="+919876522222",
    )
    inbox = Notification.objects.get(user=user)
    assert "डॉक्टर विज़िट साथी" in inbox.body and "Doctor visit" not in inbox.body
    sms = read_sms("+919876522222")[0]["text"]
    assert "Doctor visit companion" in sms and "Tue 13 Oct" in sms


def test_partner_emails_in_odia(user):
    user.language = "or"
    user.save()
    notify(
        user_id=str(user.pk),
        app="partner",
        code="PARTNER_APPROVED",
        variables={"name": "Asha"},
        email="asha@example.com",
    )
    mail = read_mail("asha@example.com")[0]
    assert mail["subject"] == "WellWishକୁ ସ୍ୱାଗତ!" and "ଆଜି ଉପଲବ୍ଧ" in mail["text"]


def test_one_failing_channel_does_not_stop_the_others(user, monkeypatch):
    def broken(*args, **kwargs):
        raise RuntimeError("FCM down")

    monkeypatch.setattr(push, "send_push", broken)
    monkeypatch.setattr("apps.notifications.services.send_push", broken)
    Device.objects.create(
        user=user, app="partner", device_id="d1", platform="android", fcm_token="t"
    )
    notify(
        user_id=str(user.pk),
        app="partner",
        code="PARTNER_REINSTATED",
        variables={},
        phone=user.phone,
    )
    assert Notification.objects.filter(user=user).count() == 1
    assert read_sms(user.phone)


def test_dead_push_tokens_are_forgotten(user, monkeypatch):
    Device.objects.create(
        user=user, app="partner", device_id="d1", platform="android", fcm_token="dead"
    )
    monkeypatch.setattr("apps.notifications.services.send_push", lambda tokens, *a: list(tokens))
    notify(user_id=str(user.pk), app="partner", code="PARTNER_REINSTATED", variables={})
    assert Device.objects.get().fcm_token == ""


def test_email_code_is_never_kept_in_the_inbox(user):
    notify(
        user_id=str(user.pk),
        app="partner",
        code="EMAIL_VERIFY_CODE",
        variables={"code": "123456", "name": "A"},
        email="a@example.com",
    )
    assert not Notification.objects.exists()
    assert "123456" in read_mail("a@example.com")[0]["text"]


def test_inbox_list_unread_and_mark_read(api):
    token = partner_login(api)
    user = User.objects.get(phone="+919000000001")
    for _ in range(3):
        notify(user_id=str(user.pk), app="partner", code="PARTNER_REINSTATED", variables={})
    other = User.objects.create_user("+919876522222")
    notify(user_id=str(other.pk), app="partner", code="PARTNER_REINSTATED", variables={})

    listed = api.get("/partner/notifications", token).json()
    assert listed["count"] == 3  # only their own
    assert listed["items"][0]["title"] == "Account active again"
    assert api.get("/partner/notifications/unread-count", token).json() == {"unread": 3}
    first = listed["items"][0]["id"]
    assert api.post("/partner/notifications/read", {"ids": [first]}, token).json() == {"unread": 2}
    assert api.post("/partner/notifications/read", {}, token).json() == {"unread": 0}
    # someone else's id does nothing
    theirs = str(Notification.objects.get(user=other).pk)
    api.post("/partner/notifications/read", {"ids": [theirs]}, token)
    assert Notification.objects.get(pk=theirs).read_at is None


def test_fcm_backend_reports_dead_tokens(settings, monkeypatch):
    settings.FCM_PROJECT_ID = "wellwish-test"
    settings.FCM_CREDENTIALS_FILE = "/nowhere.json"

    class Answer:
        def __init__(self, status, text=""):
            self.status_code, self.text = status, text

    answers = {"good": Answer(200), "dead": Answer(404, '{"error":{"status":"UNREGISTERED"}}')}
    backend = push.FCMPushBackend()
    monkeypatch.setattr(backend, "_access_token", lambda: "token")
    monkeypatch.setattr(
        "common.push.requests.post",
        lambda url, json, headers, timeout: answers[json["message"]["token"]],
    )
    assert backend.send(["good", "dead"], "t", "b", {}) == ["dead"]


# --- Family inbox (P25, v2.32) ---


def test_family_inbox_list_unread_and_mark_read(api):
    from conftest import otp_login

    token = otp_login(api)["accessToken"]
    user = User.objects.get(phone="+919000000001")
    for code in ("BOOKING_CONFIRMED", "BOOKING_ASSIGNED"):
        notify(
            user_id=str(user.pk), app="patient", code=code, variables={}, data={"bookingId": "b-1"}
        )
    # the same person's partner-app messages stay in the partner app
    notify(user_id=str(user.pk), app="partner", code="PARTNER_REINSTATED", variables={})
    other = User.objects.create_user("+919876533333")
    notify(user_id=str(other.pk), app="patient", code="BOOKING_CONFIRMED", variables={})

    listed = api.get("/patient/notifications", token).json()
    assert listed["count"] == 2  # only their own, only the family app
    assert [n["type"] for n in listed["items"]] == ["BOOKING_ASSIGNED", "BOOKING_CONFIRMED"]
    assert listed["items"][0]["data"]["bookingId"] == "b-1"  # opens that booking
    assert api.get("/patient/notifications/unread-count", token).json() == {"unread": 2}
    # an empty selection marks nothing
    assert api.post("/patient/notifications/read", {"ids": []}, token).json() == {"unread": 2}
    first = listed["items"][0]["id"]
    assert api.post("/patient/notifications/read", {"ids": [first]}, token).json() == {"unread": 1}
    assert api.post("/patient/notifications/read", {}, token).json() == {"unread": 0}
    theirs = str(Notification.objects.get(user=other).pk)
    api.post("/patient/notifications/read", {"ids": [theirs]}, token)
    assert Notification.objects.get(pk=theirs).read_at is None


def test_a_new_inbox_message_is_announced_live(
    user, monkeypatch, django_capture_on_commit_callbacks
):
    from common import realtime

    sent = []
    monkeypatch.setattr(
        realtime, "send_to_group", lambda g, kind, data: sent.append((g, kind, data))
    )
    with django_capture_on_commit_callbacks(execute=True):
        notify(user_id=str(user.pk), app="patient", code="BOOKING_CONFIRMED", variables={})
        notify(user_id=str(user.pk), app="patient", code="JOB_OTP", variables={"otp": "1234"})
    # the bell gets the new count; the job OTP (SMS only) is never in the inbox nor announced
    assert sent == [
        (f"user.patient.{user.pk}", "notification.new", {"type": "BOOKING_CONFIRMED", "unread": 1})
    ]


def test_family_inbox_shows_30_days_and_the_newest_50(api):
    """Developer, 16 Oct 2026 (v2.33): no 99+ of old messages; the partner inbox keeps all."""
    from datetime import timedelta

    from django.utils import timezone

    from conftest import otp_login

    token = otp_login(api)["accessToken"]
    user = User.objects.get(phone="+919000000001")
    for _ in range(55):
        notify(user_id=str(user.pk), app="patient", code="BOOKING_CONFIRMED", variables={})
    old = Notification.objects.create(
        user=user, app="patient", type="BOOKING_CANCELLED", title="Old", body="Old"
    )
    Notification.objects.filter(pk=old.pk).update(created_at=timezone.now() - timedelta(days=31))
    partner_old = Notification.objects.create(
        user=user, app="partner", type="PARTNER_APPROVED", title="Old", body="Old"
    )
    Notification.objects.filter(pk=partner_old.pk).update(
        created_at=timezone.now() - timedelta(days=200)
    )

    listed = api.get("/patient/notifications?pageSize=100", token).json()
    assert listed["count"] == 50  # the newest 50; the 31-day-old one isn't there
    assert "Old" not in [n["title"] for n in listed["items"]]
    assert api.get("/patient/notifications/unread-count", token).json() == {"unread": 50}


def test_the_nightly_job_deletes_family_messages_older_than_30_days(user):
    from datetime import timedelta

    from django.utils import timezone

    from apps.notifications.tasks import delete_old_family_inbox

    rows = {
        kind: Notification.objects.create(user=user, app=app, type="X", title=kind, body="")
        for kind, app in (("old", "patient"), ("new", "patient"), ("partner", "partner"))
    }
    Notification.objects.filter(pk__in=[rows["old"].pk, rows["partner"].pk]).update(
        created_at=timezone.now() - timedelta(days=31)
    )
    assert delete_old_family_inbox() == 1
    assert set(Notification.objects.values_list("title", flat=True)) == {"new", "partner"}
