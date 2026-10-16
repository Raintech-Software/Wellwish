"""The app language (Phase 9.1, ARCHITECTURE §5): a new account starts in the phone's language;
partners change it in the app at any status (patients in their profile)."""

import re

import pytest
from django.core.cache import cache

from apps.accounts.models import User
from common.sms import read_dev_outbox as read_sms

pytestmark = pytest.mark.django_db


def login(api, phone, *, purpose="partner_primary", language=None, device="lang-phone-1"):
    sent = api.post("/auth/otp/send", {"phone": phone, "purpose": purpose, "deviceId": device})
    assert sent.status_code == 200, sent.json()
    code = re.findall(r"\b(\d{6})\b", read_sms(phone)[-1]["text"])[0]
    body = {"phone": phone, "otp": code, "purpose": purpose, "deviceId": device}
    if language:
        body["language"] = language
    resp = api.post("/auth/otp/verify", body)
    cache.delete(f"otp:{purpose}:{phone}:resend")
    assert resp.status_code == 200, resp.json()
    return resp.json()["accessToken"]


def test_a_new_account_starts_in_the_phones_language(api):
    token = login(api, "+919811200001", language="or")
    assert api.get("/partner/me", token=token).json()["language"] == "or"
    # an existing account keeps its choice, whatever the next phone says
    login(api, "+919811200001", language="hi", device="lang-phone-2")
    assert User.objects.get(phone="+919811200001").language == "or"
    # an app that doesn't send it: English, as before
    login(api, "+919811200002")
    assert User.objects.get(phone="+919811200002").language == "en"
    bad = api.post(
        "/auth/otp/verify",
        {
            "phone": "+919811200002",
            "otp": "123456",
            "purpose": "partner_primary",
            "deviceId": "lang-phone-1",
            "language": "fr",
        },
    )
    assert bad.status_code == 422


def test_a_partner_chooses_the_language_at_any_status(api):
    token = login(api, "+919811200003")  # logged in, not registered yet
    resp = api.put("/partner/me/language", {"language": "hi"}, token=token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["language"] == "hi"
    assert User.objects.get(phone="+919811200003").language == "hi"
    assert api.put("/partner/me/language", {"language": "fr"}, token=token).status_code == 422
    # a patient's token is for the patient app only (patients change it in their profile)
    patient = login(api, "+919811200004", purpose="login")
    assert api.put("/partner/me/language", {"language": "hi"}, token=patient).status_code == 401
