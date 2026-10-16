"""Partner registration steps (§6.3: role, two phones, email, profile) and the approval gate."""

import pytest

from apps.accounts.models import User
from apps.partners.models import PartnerPhone, PartnerProfile
from apps.partners.tests.support import (
    ALTERNATE,
    PRIMARY,
    PROFILE,
    email_code,
    partner_login,
    save_profile,
    upload,
    verify_alternate,
    verify_email,
)
from common.mail import read_dev_outbox

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


@pytest.fixture
def token(api):
    return partner_login(api)


def start(api, token, role="COMPANION"):
    return api.post("/partner/register/start", {"role": role}, token)


def test_before_choosing_a_role_the_partner_is_not_registered(api, token):
    assert api.get("/partner/me", token).json()["partnerStatus"] is None
    resp = api.get("/partner/kyc/status", token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "NOT_REGISTERED"


def test_start_creates_the_profile_with_the_login_number(api, token):
    resp = start(api, token)
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["profile"]["status"] == "REGISTERING"
    assert body["profile"]["role"] == "COMPANION"
    assert body["profile"]["phones"] == [{"kind": "PRIMARY", "phone": PRIMARY, "verified": True}]
    assert body["steps"] == {
        "role": True,
        "alternatePhone": False,
        "email": False,
        "profile": False,
        "documents": False,
    }
    assert api.get("/partner/me", token).json()["partnerStatus"] == "REGISTERING"
    # the role can change until the details are submitted
    assert start(api, token, "NURSE").json()["profile"]["role"] == "NURSE"


def test_alternate_phone_must_differ_from_the_login_number(api, token):
    start(api, token)
    resp = api.post("/partner/register/alternate-phone", {"phone": PRIMARY}, token)
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "SAME_AS_PRIMARY"


def test_alternate_phone_is_verified_by_otp(api, token):
    start(api, token)
    wrong = api.post("/partner/register/alternate-phone", {"phone": ALTERNATE}, token)
    assert wrong.status_code == 200
    bad = api.post("/partner/register/alternate-phone/verify", {"code": "000000"}, token)
    assert bad.status_code == 400
    assert bad.json()["error"]["code"] == "OTP_INVALID"
    resp = api.post("/partner/register/alternate-phone/verify", {"code": "123456"}, token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["steps"]["alternatePhone"] is True
    phone = PartnerPhone.objects.get(kind="ALTERNATE")
    assert phone.phone == ALTERNATE and phone.verified_at is not None


def test_alternate_verify_without_a_code_sent(api, token):
    start(api, token)
    resp = api.post("/partner/register/alternate-phone/verify", {"code": "123456"}, token)
    assert resp.json()["error"]["code"] == "OTP_EXPIRED"


def test_email_code_flow(api, token):
    start(api, token)
    sent = api.post("/partner/register/email", {"email": "Asha@Example.com"}, token)
    assert sent.status_code == 200
    assert sent.json()["resendAfterSeconds"] == 30
    messages = read_dev_outbox("asha@example.com")
    assert len(messages) == 1
    code = email_code("asha@example.com")
    wrong = api.post(
        "/partner/register/email/verify",
        {"code": "000000" if code != "000000" else "111111"},
        token,
    )
    assert wrong.json()["error"]["code"] == "EMAIL_CODE_INVALID"
    ok = api.post("/partner/register/email/verify", {"code": code}, token)
    assert ok.status_code == 200
    assert ok.json()["steps"]["email"] is True
    assert ok.json()["profile"]["email"] == "asha@example.com"
    # a code works once
    again = api.post("/partner/register/email/verify", {"code": code}, token)
    assert again.json()["error"]["code"] == "EMAIL_CODE_EXPIRED"


def test_email_resend_waits(api, token):
    start(api, token)
    api.post("/partner/register/email", {"email": "a@example.com"}, token)
    again = api.post("/partner/register/email", {"email": "a@example.com"}, token)
    assert again.status_code == 429
    assert again.json()["error"]["code"] == "EMAIL_RESEND_TOO_SOON"


def test_email_used_by_another_partner_is_refused(api, token):
    other = PartnerProfile.objects.create(
        user=User.objects.create_user("+919876500099"), role="NURSE"
    )
    other.email = "taken@example.com"
    other.email_verified_at = other.created_at
    other.save()
    start(api, token)
    resp = api.post("/partner/register/email", {"email": "taken@example.com"}, token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "EMAIL_TAKEN"


def test_profile_rules(api, token):
    start(api, token)
    too_young = save_profile(api, token, dob="2015-01-01")
    assert too_young.json()["error"]["code"] == "TOO_YOUNG"
    same = save_profile(api, token, emergencyPhone=PRIMARY)
    assert same.json()["error"]["code"] == "EMERGENCY_IS_YOU"
    resp = save_profile(api, token)
    assert resp.status_code == 200, resp.json()
    assert resp.json()["steps"]["profile"] is True
    assert resp.json()["profile"]["photoUrl"].startswith("/v1/files/view/")
    assert resp.json()["profile"]["lat"] == "20.290000"


def test_profile_photo_must_be_your_own_upload(api, token):
    start(api, token)
    other_token = partner_login(api, "+919876543210", device_id="partner-device-2")
    start(api, other_token)
    their_photo = upload(api, other_token, "partner_photo")
    resp = api.put("/partner/register/profile", {**PROFILE, "photoKey": their_photo}, token)
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "FILE_NOT_FOUND"


def test_all_details_make_the_partner_registered(api, token):
    start(api, token)
    verify_alternate(api, token)
    verify_email(api, token)
    resp = save_profile(api, token)
    assert resp.json()["profile"]["status"] == "REGISTERED"
    assert api.get("/partner/me", token).json()["partnerStatus"] == "REGISTERED"


def test_unknown_fields_and_bad_values_are_refused(api, token):
    start(api, token)
    resp = api.put("/partner/register/profile", {**PROFILE, "photoKey": "x", "rating": 5}, token)
    assert resp.status_code == 422
    bad_role = api.post("/partner/register/start", {"role": "DOCTOR"}, token)
    assert bad_role.status_code == 422


def test_gate_only_approved_partners_get_past_registration(api, token):
    start(api, token)
    blocked = api.patch("/partner/me/availability", {"availableToday": True}, token)
    assert blocked.status_code == 403
    assert blocked.json()["error"]["code"] == "PARTNER_NOT_APPROVED"
    # registration, KYC, me and the inbox stay open
    assert api.get("/partner/kyc/status", token).status_code == 200
    assert api.get("/partner/me", token).status_code == 200
    assert api.get("/partner/notifications", token).status_code == 200
    PartnerProfile.objects.update(status="APPROVED")
    ok = api.patch("/partner/me/availability", {"availableToday": False}, token)
    assert ok.status_code == 200
    assert ok.json() == {"availableToday": False, "selfieToday": False}


def test_available_today_needs_todays_selfie_and_resets_daily(api, token):
    from apps.partners.tests.support import upload

    start(api, token)
    PartnerProfile.objects.update(status="APPROVED")
    no_selfie = api.patch("/partner/me/availability", {"availableToday": True}, token)
    assert no_selfie.json()["error"]["code"] == "SELFIE_REQUIRED"
    key = upload(api, token, "partner_selfie")
    taken = api.post("/partner/me/selfie", {"fileKey": key}, token)
    assert taken.json() == {"availableToday": False, "selfieToday": True}
    on = api.patch("/partner/me/availability", {"availableToday": True}, token)
    assert on.json() == {"availableToday": True, "selfieToday": True}
    # the same file can't be today's selfie twice
    again = api.post("/partner/me/selfie", {"fileKey": key}, token)
    assert again.status_code == 422
    # yesterday's switch doesn't count today
    import datetime as dt

    PartnerProfile.objects.update(available_on=dt.date(2020, 1, 1))
    assert api.get("/partner/me/availability", token).json()["availableToday"] is False


def test_patient_token_cannot_use_partner_routes(api):
    from conftest import otp_login

    patient = otp_login(api)["accessToken"]
    assert api.post("/partner/register/start", {"role": "NURSE"}, patient).status_code == 401


def test_admin_spot_checks_todays_selfies(api, token, staff_roles):
    from apps.partners.tests.support import upload
    from conftest import staff_token

    start(api, token)
    PartnerProfile.objects.update(status="APPROVED", full_name="Asha Behera")
    api.post("/partner/me/selfie", {"fileKey": upload(api, token, "partner_selfie")}, token)
    reviewer = staff_token(api, staff_roles, "VERIFICATION")
    rows = api.get("/admin/selfies", reviewer).json()["items"]
    assert len(rows) == 1
    assert rows[0]["partnerName"] == "Asha Behera" and rows[0]["selfieUrl"]
    finance = staff_token(api, staff_roles, "FINANCE")
    assert api.get("/admin/selfies", finance).status_code == 403
