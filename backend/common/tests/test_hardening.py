"""Phase 1 deep-check fixes: client IP, Sentry scrubbing, socket groups, server settings."""

import os
import subprocess
import sys

import pytest
from django.test import RequestFactory

from common.monitoring import scrub_event
from common.realtime import user_group
from common.request import client_ip

rf = RequestFactory()


def _ip(settings, xff=None, remote="10.0.0.9", trust=True, hops=1):
    settings.TRUST_X_FORWARDED_FOR = trust
    settings.TRUSTED_PROXY_HOPS = hops
    meta = {"REMOTE_ADDR": remote}
    if xff is not None:
        meta["HTTP_X_FORWARDED_FOR"] = xff
    return client_ip(rf.get("/", **meta))


def test_client_ip_ignores_forwarded_for_unless_behind_our_proxy(settings):
    assert _ip(settings, xff="1.2.3.4", trust=False) == "10.0.0.9"


def test_client_ip_uses_the_address_our_proxy_added_not_the_spoofable_left(settings):
    # client sent "6.6.6.6"; Nginx appended the real address it saw
    assert _ip(settings, xff="6.6.6.6, 203.0.113.7") == "203.0.113.7"
    # ALB + Nginx: two trusted hops
    assert _ip(settings, xff="6.6.6.6, 203.0.113.7, 10.0.1.2", hops=2) == "203.0.113.7"


def test_client_ip_rejects_garbage(settings):
    assert _ip(settings, xff="not-an-ip") == "10.0.0.9"
    assert _ip(settings, xff="", remote="garbage") == "0.0.0.0"  # noqa: S104


def test_sentry_events_never_carry_bodies_headers_cookies_or_variables():
    event = {
        "request": {
            "method": "POST",
            "url": "https://api.wellwish.in/v1/auth/otp/verify?phone=9876543210",
            "data": {"otp": "482910", "phone": "9876543210"},
            "headers": {"Authorization": "Bearer abc"},
            "cookies": {"ww_staff_refresh": "secret"},
            "query_string": "phone=9876543210",
        },
        "user": {"ip_address": "1.2.3.4"},
        "exception": {
            "values": [{"stacktrace": {"frames": [{"function": "f", "vars": {"code": "482910"}}]}}]
        },
    }
    scrubbed = scrub_event(event)
    assert scrubbed["request"] == {
        "method": "POST",
        "url": "https://api.wellwish.in/v1/auth/otp/verify",
    }
    assert "user" not in scrubbed
    assert "vars" not in scrubbed["exception"]["values"][0]["stacktrace"]["frames"][0]
    assert "482910" not in str(scrubbed)
    assert "9876543210" not in str(scrubbed)


def test_socket_user_groups_are_per_app():
    assert user_group("patient", "u-1") != user_group("partner", "u-1")


# --- server settings (loaded in a separate Python, like a real server start) ---

SERVER_ENV = {
    "DJANGO_SECRET_KEY": "server-secret-key-for-tests-xxxxxxxxxxxxxxxx",
    "JWT_SIGNING_KEY": "jwt-key-for-tests-xxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "OTP_HMAC_KEY": "otp-key-for-tests-xxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "FIELD_ENCRYPTION_KEY": "ZmRmZGZkZmRmZGZkZmRmZGZkZmRmZGZkZmRmZGZkZmQ=",
    "DATABASE_URL": "postgres://u:p@localhost:5432/db",
    "SMS_BACKEND": "common.sms.MSG91SMSBackend",
    "OTP_TEST_NUMBERS": "",
    "OTP_TEST_CODE": "123456",
    "SENTRY_DSN": "",
    "FILE_S3_BUCKET": "wellwish-test-files",
    "PUBLIC_SITE_URL": "https://wellwish.test",
}


def _load(module: str, **overrides: str) -> subprocess.CompletedProcess[str]:
    env = {**os.environ, **SERVER_ENV, **overrides, "DJANGO_SETTINGS_MODULE": module}
    return subprocess.run(
        [sys.executable, "-c", "import django; django.setup()"],
        env=env,
        capture_output=True,
        text=True,
        timeout=60,
        check=False,
    )


@pytest.mark.parametrize("module", ["config.settings.staging", "config.settings.prod"])
def test_servers_start_with_real_sms(module):
    assert _load(module).returncode == 0


@pytest.mark.parametrize("module", ["config.settings.staging", "config.settings.prod"])
def test_servers_refuse_the_dev_console_sms(module):
    result = _load(module, SMS_BACKEND="common.sms.ConsoleSMSBackend")
    assert result.returncode != 0
    assert "local development only" in result.stderr


def test_staging_allows_several_test_numbers():
    assert (
        _load("config.settings.staging", OTP_TEST_NUMBERS="+919000000001,+919000000002").returncode
        == 0
    )


def test_prod_allows_one_review_number_with_a_private_code():
    two = _load("config.settings.prod", OTP_TEST_NUMBERS="+919000000001,+919000000002")
    assert two.returncode != 0
    default_code = _load("config.settings.prod", OTP_TEST_NUMBERS="+919000000001")
    assert "private OTP_TEST_CODE" in default_code.stderr
    ok = _load("config.settings.prod", OTP_TEST_NUMBERS="+919000000001", OTP_TEST_CODE="739214")
    assert ok.returncode == 0


# --- §12 Logs: the safety net (Phase 9.3) ---


@pytest.mark.parametrize(
    ("line", "masked"),
    [
        (
            "GET /v1/admin/patients?q=9876543210 HTTP/1.1",
            "GET /v1/admin/patients?q=[phone …3210] HTTP/1.1",
        ),
        ("login +91 98765 43210 ok", "login [phone …3210] ok"),
        ("otp 123456 sent", "otp [code] sent"),
        ("Authorization: Bearer abcdefghijklmnop", "Authorization: [token]"),
        ("aadhaar 2345 6789 1234", "aadhaar [number]"),
        # left alone: ids, dates, amounts
        (
            "booking e22a74ba-80e3-49c7-b0c2-fd0873dde871",
            "booking e22a74ba-80e3-49c7-b0c2-fd0873dde871",
        ),
        ("paid 10000 paise at 2026-10-13 10:00:00", "paid 10000 paise at 2026-10-13 10:00:00"),
    ],
)
def test_redact(line, masked):
    from common.redact import redact

    assert redact(line) == masked


def _written(logger_name: str, msg: str, *args: object) -> str:
    """What the configured console handler writes for this line (pytest swaps stderr itself)."""
    import logging

    from common.redact import RedactFilter

    logger = logging.getLogger(logger_name)
    handlers = logger.handlers if not logger.propagate else logging.getLogger().handlers
    console = [h for h in handlers if any(isinstance(f, RedactFilter) for f in h.filters)]
    assert console, f"{logger_name}: no handler masks its lines"
    record = logger.makeRecord(logger_name, logging.WARNING, __file__, 0, msg, args, None)
    assert console[0].filter(record)
    return console[0].format(record)


def test_every_log_line_is_masked_also_the_web_servers():
    app_line = _written("apps.test", "SMS to %s with code 123456", "+919876543210")
    web_line = _written(
        "uvicorn.access", '%s - "%s %s"', "10.0.0.1", "GET", "/v1/admin/partners?q=9876543210"
    )
    for line in (app_line, web_line):
        assert "9876543210" not in line and "123456" not in line
    assert "SMS to [phone …3210] with code [code]" in app_line
    assert '"GET /v1/admin/partners"' in web_line  # no query string at all


def test_tracebacks_and_url_encoded_numbers_are_masked_too():
    """Deep check 9.3: a database error quotes the number; a search arrives URL-encoded."""
    import logging
    import sys

    from common.redact import RedactFilter, redact

    assert redact("q=98765%2043210") == "q=[phone …3210]"
    assert redact("q=%2B91%2098765%2043210") == "q=[phone …3210]"
    try:
        raise ValueError("Key (phone)=(+919876543210) already exists.")
    except ValueError:
        record = logging.getLogger("django.request").makeRecord(
            "django.request", logging.ERROR, __file__, 0, "Internal error", (), sys.exc_info()
        )
    RedactFilter().filter(record)
    line = logging.Formatter("%(message)s").format(record)
    assert "9876543210" not in line and "[phone …3210]" in line


def test_the_celery_worker_logs_through_the_same_mask():
    import logging

    from common.redact import RedactFilter
    from config.celery import _logging

    _logging()
    root = logging.getLogger()
    assert any(isinstance(f, RedactFilter) for h in root.handlers for f in h.filters)


def test_sentry_gets_no_phone_in_texts_or_breadcrumbs():
    from common.monitoring import scrub_breadcrumb

    event = {
        "exception": {"values": [{"value": "No user +919876543210", "stacktrace": {"frames": []}}]},
        "logentry": {"message": "otp 123456 for %s", "params": ["+919876543210"]},
        "breadcrumbs": {"values": [{"message": "cache get rl:otp:+919876543210"}]},
    }
    out = scrub_event(event)
    assert "9876543210" not in str(out) and "123456" not in str(out)
    assert scrub_breadcrumb({"data": {"query": "WHERE phone = '+919876543210'"}})["data"][
        "query"
    ].endswith("…3210]'")
