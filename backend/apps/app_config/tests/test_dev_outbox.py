"""Settings → Test messages: the dev SMS and email outbox in the admin panel (dev only)."""

import pytest
from django.core.cache import cache
from django.test import override_settings

from common.mail import send_mail
from common.sms import send_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def empty_outbox():
    cache.delete_many(["dev_sms_outbox:all", "dev_mail_outbox:all"])


def test_lists_every_sms_and_email_newest_first(api, staff_roles):
    token = staff_token(api, staff_roles)
    send_sms("+919000000001", "LOGIN_OTP", {"otp": "482913"})
    send_sms("+919000000003", "LOGIN_OTP", {"otp": "118822"})
    send_mail("Partner@Example.com", "Your WellWish code", "Your code is 5521.")

    res = api.get("/admin/dev/outbox", token)

    assert res.status_code == 200
    body = res.json()
    assert [m["phone"] for m in body["sms"]] == ["+919000000003", "+919000000001"]
    assert body["sms"][0]["template"] == "LOGIN_OTP"
    assert "118822" in body["sms"][0]["text"]
    assert body["email"][0]["to"] == "partner@example.com"
    assert "5521" in body["email"][0]["text"]


def test_keeps_the_last_50(api, staff_roles):
    token = staff_token(api, staff_roles)
    for i in range(55):
        send_sms(f"+9190000{i:05d}", "LOGIN_OTP", {"otp": f"{i:06d}"})
    sms = api.get("/admin/dev/outbox", token).json()["sms"]
    assert len(sms) == 50
    assert "000054" in sms[0]["text"]


def test_needs_settings_manage(api, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/dev/outbox", ops).status_code == 403


@override_settings(APP_ENV="staging")
def test_not_there_on_a_real_server(api, staff_roles):
    token = staff_token(api, staff_roles)
    send_sms("+919000000001", "LOGIN_OTP", {"otp": "482913"})
    assert api.get("/admin/dev/outbox", token).status_code == 404
