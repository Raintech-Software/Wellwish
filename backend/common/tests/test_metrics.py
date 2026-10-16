"""§13 / PHASES 9.5: the numbers behind the CloudWatch alarms."""

import datetime as dt

import pytest
from django.core.cache import cache
from django.utils import timezone

from common import metrics

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def fresh_cache():
    cache.clear()
    yield
    cache.clear()


def test_failures_are_counted_and_taken_once():
    metrics.count("SmsFailures")
    metrics.count("SmsFailures", 2)
    metrics.count("WebhookFailures")
    taken = metrics.take_counts()
    assert taken["SmsFailures"] == 3 and taken["WebhookFailures"] == 1
    assert taken["EmailFailures"] == 0 and taken["OfferTimeouts"] == 0
    assert metrics.take_counts()["SmsFailures"] == 0  # taken: the next minute starts at 0


class FailingBackend:
    """An SMS / email provider that refuses everything (nothing leaves the PC)."""

    def send(self, *args: object) -> None:
        raise RuntimeError("provider down")


def test_a_failed_sms_email_and_webhook_are_counted(api, settings):
    from common.mail import send_mail
    from common.sms import send_sms

    settings.SMS_BACKEND = "common.tests.test_metrics.FailingBackend"
    settings.MAIL_BACKEND = "common.tests.test_metrics.FailingBackend"
    with pytest.raises(RuntimeError):
        send_sms("+919876543210", "LOGIN_OTP", {"otp": "123456", "hash": ""})
    with pytest.raises(RuntimeError):
        send_mail("someone@example.com", "Hello", "Text")
    assert api.post("/webhooks/razorpay", {}).status_code == 400  # a bad signature
    taken = metrics.take_counts()
    assert (taken["SmsFailures"], taken["EmailFailures"]) == (1, 1)
    assert (taken["WebhookBadSignatures"], taken["WebhookFailures"]) == (1, 0)


def test_publish_sends_to_cloudwatch_only_with_a_namespace(settings, monkeypatch):
    sent: list[dict] = []

    class FakeCloudWatch:
        def put_metric_data(self, **kwargs):
            sent.append(kwargs)

    import boto3  # type: ignore[import-untyped]

    monkeypatch.setattr(boto3, "client", lambda *a, **k: FakeCloudWatch())
    settings.CLOUDWATCH_NAMESPACE = ""
    metrics.count("OfferTimeouts")
    assert metrics.publish()["OfferTimeouts"] == 1 and sent == []
    settings.CLOUDWATCH_NAMESPACE = "WellWish/test"
    metrics.count("EmailFailures")
    values = metrics.publish()
    assert sent[0]["Namespace"] == "WellWish/test"
    names = {m["MetricName"]: m["Value"] for m in sent[0]["MetricData"]}
    assert names["EmailFailures"] == 1 and names["UnassignedOver30Min"] == 0
    measured = {"UnassignedOver30Min", "SosUnacknowledged"}
    assert set(names) == set(values) == set(metrics.COUNTS) | measured


def test_unassigned_and_sos_waiting_are_measured(
    api, booking, asha, staff_roles, django_capture_on_commit_callbacks
):
    from apps.assignments.tests.test_assignments import accepted
    from apps.bookings.tests.test_visit import step

    now = timezone.now()
    # the paid booking has no partner yet: counted 30 minutes after payment
    assert metrics.measure(now)["UnassignedOver30Min"] == 0
    assert metrics.measure(now + dt.timedelta(minutes=31))["UnassignedOver30Min"] == 1
    token, _ = asha
    accepted(api, booking, asha, staff_roles)
    assert metrics.measure(now + dt.timedelta(minutes=31))["UnassignedOver30Min"] == 0
    step(api, token, booking.pk, "ON_THE_WAY")
    api.post(f"/partner/bookings/{booking.pk}/sos", {}, token)
    assert metrics.measure(now + dt.timedelta(minutes=1))["SosUnacknowledged"] == 0
    assert metrics.measure(now + dt.timedelta(minutes=3))["SosUnacknowledged"] == 1
