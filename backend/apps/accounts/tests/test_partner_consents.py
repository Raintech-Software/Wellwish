"""Partners accept the Partner Terms and the Privacy Policy (ARCHITECTURE §6.20, PHASES 9B.2)."""

import re

import pytest

from apps.accounts.models import Consent
from apps.partners.tests.support import partner_login
from common.sms import read_dev_outbox as read_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db


def test_a_new_partner_accepts_the_partner_terms_and_privacy_before_registering(api):
    token = partner_login(api, accept_terms=False)
    me = api.get("/partner/me", token).json()
    assert me["partnerStatus"] is None
    assert me["consentsNeeded"] == [
        {"type": "PARTNER_TERMS", "version": "2026-10"},
        {"type": "PRIVACY", "version": "2026-10"},
    ]
    # health data is the patients' consent, not a partner's
    wrong = api.post(
        "/partner/me/consents", {"items": [{"type": "HEALTH_DATA", "version": "2026-10"}]}, token
    )
    assert wrong.status_code == 409
    resp = api.post("/partner/me/consents", {"items": me["consentsNeeded"]}, token)
    assert resp.status_code == 200
    assert resp.json()["consentsNeeded"] == []
    rows = Consent.objects.filter(user__phone="+919000000001").order_by("type")
    assert [(c.type, c.version, c.ip) for c in rows] == [
        ("PARTNER_TERMS", "2026-10", "127.0.0.1"),
        ("PRIVACY", "2026-10", "127.0.0.1"),
    ]


def test_an_approved_partner_is_asked_again_and_the_privacy_policy_is_shared(
    api, asha, staff_roles
):
    token, partner_id = asha
    Consent.objects.filter(user_id=partner_id).delete()  # registered before Phase 9B
    me = api.get("/partner/me", token).json()
    assert me["partnerStatus"] == "APPROVED"
    assert {c["type"] for c in me["consentsNeeded"]} == {"PARTNER_TERMS", "PRIVACY"}
    assert (
        api.post("/partner/me/consents", {"items": me["consentsNeeded"]}, token).status_code == 200
    )

    # new Partner Terms asking everyone again: only that one is asked
    admin = staff_token(api, staff_roles)
    terms = api.get("/admin/legal/PARTNER_TERMS", admin).json()
    body = {
        "expectedVersion": terms["version"],
        "askAgain": True,
        "titleEn": terms["titleEn"],
        "bodyEn": terms["bodyEn"] + "\n\n- A new rule.",
    }
    assert api.post("/admin/legal/PARTNER_TERMS", body, admin).status_code == 200
    assert api.get("/partner/me", token).json()["consentsNeeded"] == [
        {"type": "PARTNER_TERMS", "version": "2"}
    ]

    # the same person in the patient app: the Privacy Policy is already accepted
    phone = "+919811100001"
    assert (
        api.post(
            "/auth/otp/send", {"phone": phone, "purpose": "login", "deviceId": "patient-device-1"}
        ).status_code
        == 200
    )
    code = re.findall(r"[0-9]{6}", read_sms(phone)[-1]["text"])[0]
    patient = api.post(
        "/auth/otp/verify",
        {"phone": phone, "otp": code, "purpose": "login", "deviceId": "patient-device-1"},
    ).json()["accessToken"]
    needed = api.get("/patient/me", patient).json()["consentsNeeded"]
    assert {c["type"] for c in needed} == {"TERMS", "HEALTH_DATA"}
