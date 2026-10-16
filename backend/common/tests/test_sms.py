"""SMS adapters (PHASES 1.2): MSG91 request format and the dev console outbox."""

import logging

import pytest
import requests

from common.sms import ConsoleSMSBackend, MSG91SMSBackend, SMSError, read_dev_outbox, send_sms


class FakeResponse:
    def __init__(self, status: int) -> None:
        self.status_code = status


def test_msg91_sends_the_dlt_template_with_variables(settings, monkeypatch, caplog):
    settings.MSG91_AUTH_KEY = "test-auth-key"
    settings.MSG91_TEMPLATES = {"LOGIN_OTP": "dlt-template-123"}
    calls = []

    def fake_post(url, json, headers, timeout):
        calls.append((url, json, headers, timeout))
        return FakeResponse(200)

    monkeypatch.setattr(requests, "post", fake_post)
    caplog.set_level(logging.INFO)
    MSG91SMSBackend().send(
        "+919876543210", "LOGIN_OTP", {"otp": "482910", "app_hash": "AbCdEfGhIjK"}
    )

    url, body, headers, timeout = calls[0]
    assert url == settings.MSG91_FLOW_URL
    assert body == {
        "template_id": "dlt-template-123",
        "short_url": "0",
        "recipients": [{"mobiles": "919876543210", "otp": "482910", "app_hash": "AbCdEfGhIjK"}],
    }
    assert headers["authkey"] == "test-auth-key"
    assert timeout > 0
    assert "482910" not in caplog.text
    assert "9876543210" not in caplog.text


@pytest.mark.parametrize("failure", ["http", "network", "not-configured"])
def test_msg91_failures_raise(settings, monkeypatch, failure):
    settings.MSG91_AUTH_KEY = "" if failure == "not-configured" else "key"
    settings.MSG91_TEMPLATES = {"LOGIN_OTP": "dlt-template-123"}

    def fake_post(*args, **kwargs):
        if failure == "network":
            raise requests.ConnectionError("down")
        return FakeResponse(401)

    monkeypatch.setattr(requests, "post", fake_post)
    with pytest.raises(SMSError):
        MSG91SMSBackend().send("+919876543210", "LOGIN_OTP", {"otp": "1", "app_hash": ""})


def test_console_backend_keeps_the_last_messages_without_logging_them(caplog):
    caplog.set_level(logging.INFO)
    backend = ConsoleSMSBackend()
    for i in range(7):
        backend.send("+919876543210", "LOGIN_OTP", {"otp": f"00000{i}", "app_hash": ""})
    outbox = read_dev_outbox("+919876543210")
    assert len(outbox) == 5
    assert outbox[-1]["text"].startswith("<#> 000006 is your WellWish verification code")
    assert "000006" not in caplog.text


def test_only_registered_templates_can_be_sent():
    with pytest.raises(SMSError):
        send_sms("+919876543210", "FREE_TEXT", {})


def test_every_sms_template_has_a_dlt_template_id_setting():
    """Each DLT text in `TEMPLATES` needs its MSG91 template id (`MSG91_TEMPLATE_<CODE>`), or
    MSG91 refuses to send it on the servers."""
    from django.conf import settings

    from common.sms import TEMPLATES

    assert set(TEMPLATES) == set(settings.MSG91_TEMPLATES)


def test_values_are_cut_to_what_dlt_accepts():
    """DLT drops an SMS whose {#var#} value is over 30 characters; links are {#url#} (9.1)."""
    from common.sms import DLT_VAR_MAX, dlt_safe

    reason = "Documents were not clear and the police verification has expired"
    link = "https://play.google.com/store/apps/details?id=in.wellwish.partner"
    safe = dlt_safe({"reason": reason, "name": "Asha", "link": link})
    assert len(safe["reason"]) <= DLT_VAR_MAX and safe["reason"].endswith("…")
    assert safe["name"] == "Asha" and safe["link"] == link
    send_sms("+919811100099", "PARTNER_SUSPENDED", {"reason": reason, "support": "1800"})
    text = read_dev_outbox("+919811100099")[-1]["text"]
    assert reason not in text and safe["reason"] in text
