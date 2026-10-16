"""Phone OTP rules (ARCHITECTURE §6.2, PHASES 1.19): expiry, 5 tries, resend waits, rate limits,
lockout, Indian numbers only, test numbers, and nothing secret in the cache or logs."""

import logging
import re

import pytest
from django.core.cache import cache

from common.sms import read_dev_outbox
from conftest import TEST_CODE, TEST_NUMBER

PHONE = "+919876543210"
pytestmark = pytest.mark.django_db


def send(api, phone=PHONE, purpose="login", device="device-0001", **extra):
    return api.post(
        "/auth/otp/send", {"phone": phone, "purpose": purpose, "deviceId": device}, **extra
    )


def verify(api, code, phone=PHONE, purpose="login", device="device-0001"):
    return api.post(
        "/auth/otp/verify",
        {"phone": phone, "otp": code, "purpose": purpose, "deviceId": device},
    )


def sent_code(phone=PHONE) -> str:
    """The code from the dev SMS outbox (console SMS backend)."""
    text = read_dev_outbox(phone)[-1]["text"]
    match = re.search(r"\b(\d{6})\b", text)
    assert match
    return match.group(1)


def error(resp) -> dict:
    return resp.json()["error"]


def test_send_and_verify(api, clock):
    resp = send(api)
    assert resp.status_code == 200
    assert resp.json() == {"expiresInSeconds": 300, "resendAfterSeconds": 30, "length": 6}

    code = sent_code()
    resp = verify(api, code)
    assert resp.status_code == 200
    body = resp.json()
    assert body["accessToken"] and body["refreshToken"]
    assert body["isNewUser"] is True

    # a code works once
    assert error(verify(api, code))["code"] == "OTP_EXPIRED"


def test_sms_contains_the_android_app_hash(api, clock):
    api.post(
        "/auth/otp/send",
        {"phone": PHONE, "purpose": "login", "deviceId": "device-0001", "appHash": "AbCdEfGhIjK"},
    )
    text = read_dev_outbox(PHONE)[-1]["text"]
    assert text.startswith("<#> ")
    assert text.endswith("AbCdEfGhIjK")


def test_only_an_hmac_is_stored(api, clock):
    send(api)
    code = sent_code()
    stored = cache.get(f"otp:login:{PHONE}")
    assert stored and code not in stored
    assert len(stored) == 64  # sha256 hex


def test_code_expires_after_5_minutes(api, clock):
    send(api)
    code = sent_code()
    clock.advance(301)
    resp = verify(api, code)
    assert resp.status_code == 400
    assert error(resp)["code"] == "OTP_EXPIRED"


def test_five_wrong_tries_then_a_new_code_is_needed(api, clock):
    send(api)
    code = sent_code()
    wrong = "000000" if code != "000000" else "111111"
    for left in (4, 3, 2, 1):
        resp = verify(api, wrong)
        assert error(resp)["code"] == "OTP_INVALID"
        assert error(resp)["details"]["attemptsLeft"] == left
    assert error(verify(api, wrong))["code"] == "OTP_TOO_MANY_ATTEMPTS"
    # even the right code no longer works
    assert error(verify(api, code))["code"] == "OTP_EXPIRED"


def test_resend_waits_30_then_60_then_120_seconds(api, clock):
    assert send(api).json()["resendAfterSeconds"] == 30
    resp = send(api)
    assert resp.status_code == 429
    assert error(resp)["code"] == "OTP_RESEND_TOO_SOON"
    assert error(resp)["details"]["retryAfterSeconds"] == 30

    clock.advance(30)
    assert send(api).json()["resendAfterSeconds"] == 60
    clock.advance(59)
    assert error(send(api))["code"] == "OTP_RESEND_TOO_SOON"
    clock.advance(1)
    assert send(api).json()["resendAfterSeconds"] == 120
    clock.advance(120)
    assert send(api).json()["resendAfterSeconds"] == 120


def test_a_resend_replaces_the_old_code(api, clock):
    send(api)
    first = sent_code()
    clock.advance(30)
    send(api)
    second = sent_code()
    if first != second:
        assert error(verify(api, first))["code"] == "OTP_INVALID"
    assert verify(api, second).status_code == 200


def test_five_sends_per_phone_per_hour(api, clock):
    for wait in (0, 30, 60, 120, 120):
        clock.advance(wait)
        assert send(api).status_code == 200
    clock.advance(120)
    resp = send(api)
    assert resp.status_code == 429
    assert error(resp)["code"] == "OTP_RATE_LIMITED"
    assert error(resp)["details"]["retryAfterSeconds"] > 0


def test_ten_sends_per_phone_per_day(api, clock, settings):
    settings.OTP_LIMIT_PER_PHONE_HOUR = 100
    settings.OTP_LIMIT_PER_PHONE_DAY = 2
    send(api)
    clock.advance(30)
    send(api)
    clock.advance(60)
    assert error(send(api))["code"] == "OTP_RATE_LIMITED"


def test_limit_per_ip(api, clock, settings):
    settings.OTP_LIMIT_PER_IP_HOUR = 3
    for i in range(3):
        assert send(api, phone=f"+91987654320{i}", device=f"device-000{i}").status_code == 200
    resp = send(api, phone="+919876543209", device="device-0009")
    assert error(resp)["code"] == "OTP_RATE_LIMITED"
    # another IP is not affected
    other = send(api, phone="+919876543208", device="device-0008", REMOTE_ADDR="10.9.9.9")
    assert other.status_code == 200


def test_limit_per_device(api, clock, settings):
    settings.OTP_LIMIT_PER_DEVICE_HOUR = 2
    send(api, phone="+919876543201")
    send(api, phone="+919876543202")
    assert error(send(api, phone="+919876543203"))["code"] == "OTP_RATE_LIMITED"


def test_ten_wrong_codes_lock_the_phone_for_an_hour(api, clock, monkeypatch):
    published = []
    monkeypatch.setattr(
        "common.events.publish", lambda name, payload: published.append((name, payload))
    )
    send(api)
    code = sent_code()
    wrong = "000000" if code != "000000" else "111111"
    for _ in range(5):
        verify(api, wrong)
    clock.advance(30)
    send(api)
    code = sent_code()
    wrong = "000000" if code != "000000" else "111111"
    for _ in range(4):
        assert error(verify(api, wrong))["code"] == "OTP_INVALID"
    resp = verify(api, wrong)  # 10th wrong code
    assert resp.status_code == 429
    assert error(resp)["code"] == "OTP_LOCKED"

    assert published == [("otp.locked", {"phone_masked": "+91******3210", "purpose": "login"})]
    clock.advance(120)
    assert error(send(api))["code"] == "OTP_LOCKED"
    assert error(verify(api, "123456"))["code"] == "OTP_LOCKED"
    clock.advance(3600)
    assert send(api).status_code == 200


@pytest.mark.parametrize("phone", ["+14155550123", "12345", "5876543210", "+91987654321", ""])
def test_only_indian_mobiles(api, clock, phone):
    resp = send(api, phone=phone)
    assert resp.status_code == 422
    assert error(resp)["code"] in ("INVALID_PHONE", "VALIDATION_ERROR")


def test_phone_formats_are_normalised(api, clock):
    assert send(api, phone="98765 43210").status_code == 200
    assert verify(api, sent_code(), phone="+91-98765-43210").status_code == 200


def test_test_number_accepts_the_test_code_without_sms(api, clock):
    assert send(api, phone=TEST_NUMBER).status_code == 200
    assert read_dev_outbox(TEST_NUMBER) == []
    assert verify(api, TEST_CODE, phone=TEST_NUMBER).status_code == 200


def test_unknown_purpose_and_bad_code_format_are_rejected(api, clock):
    resp = api.post("/auth/otp/send", {"phone": PHONE, "purpose": "admin", "deviceId": "dev-0001"})
    assert resp.status_code == 422
    resp = api.post(
        "/auth/otp/verify",
        {"phone": PHONE, "otp": "12ab56", "purpose": "login", "deviceId": "device-0001"},
    )
    assert resp.status_code == 422


def test_sms_failure_is_reported_and_the_code_dropped(api, clock, settings):
    settings.SMS_BACKEND = "common.sms.MSG91SMSBackend"  # not configured → fails
    resp = send(api)
    assert resp.status_code == 503
    assert error(resp)["code"] == "SMS_NOT_SENT"
    assert cache.get(f"otp:login:{PHONE}") is None


def test_no_otp_token_or_full_phone_in_logs(api, clock, caplog):
    caplog.set_level(logging.DEBUG)
    send(api)
    code = sent_code()
    verify(api, "000000" if code != "000000" else "111111")
    tokens = verify(api, code).json()
    api.post("/auth/refresh", {"refreshToken": tokens["refreshToken"]})
    api.post("/auth/refresh", {"refreshToken": tokens["refreshToken"]})  # reuse → warning log

    logged = caplog.text
    assert caplog.records  # something was logged …
    assert code not in logged  # … but never the code,
    assert tokens["accessToken"] not in logged  # the tokens
    assert tokens["refreshToken"] not in logged
    assert "9876543210" not in logged  # or the full phone number


def test_lock_alert_is_published_after_commit(
    api, clock, monkeypatch, django_capture_on_commit_callbacks
):
    """The alert must survive the failed login (it used to be rolled back with it)."""
    delivered = []
    monkeypatch.setattr(
        "common.events.handlers_for", lambda name: ["tests.handler"] if name == "otp.locked" else []
    )
    monkeypatch.setattr(
        "common.tasks.run_event_handler.delay",
        lambda path, name, payload: delivered.append((name, payload)),
    )
    with django_capture_on_commit_callbacks(execute=True):
        for round_ in range(2):
            if round_:
                clock.advance(30)
            send(api)
            wrong = "000000" if sent_code() != "000000" else "111111"
            for _ in range(5):
                verify(api, wrong)
    assert delivered == [("otp.locked", {"phone_masked": "+91******3210", "purpose": "login"})]


def test_only_ascii_digits(api, clock):
    """Devanagari digits would otherwise make a second account for the same phone."""
    devanagari = "9" + "".join(chr(0x0966 + d) for d in (8, 7, 6, 5, 4, 3, 2, 1, 0))
    resp = send(api, phone=devanagari)  # looks like 9876543210
    assert resp.status_code == 422
    assert error(resp)["code"] == "INVALID_PHONE"
