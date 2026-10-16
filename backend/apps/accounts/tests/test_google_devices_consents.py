"""Google sign-in (PHASES 1.7), devices (1.8) and consents (1.11)."""

import pytest

from apps.accounts import google
from apps.accounts.models import Consent, Device, User
from conftest import TEST_CODE, TEST_NUMBER, otp_login, staff_token

pytestmark = pytest.mark.django_db


def error(resp) -> dict:
    return resp.json()["error"]


@pytest.fixture
def google_ok(monkeypatch):
    """Pretend Google's servers say the ID token is valid."""

    def verify(token: str) -> google.GoogleIdentity:
        if token != "valid-google-token":
            raise google.GoogleTokenInvalid()
        return google.GoogleIdentity(sub="google-sub-1", email="asha@example.com")

    monkeypatch.setattr("apps.accounts.services.verify_id_token", verify)


def test_google_needs_a_verified_phone_once(api, google_ok):
    first = api.post("/auth/google", {"idToken": "valid-google-token", "deviceId": "device-0001"})
    assert first.status_code == 200
    body = first.json()
    assert body["status"] == "PHONE_REQUIRED"
    assert body["tokens"] is None
    link = body["googleLinkToken"]

    api.post(
        "/auth/otp/send", {"phone": TEST_NUMBER, "purpose": "login", "deviceId": "device-0001"}
    )
    resp = api.post(
        "/auth/otp/verify",
        {
            "phone": TEST_NUMBER,
            "otp": TEST_CODE,
            "purpose": "login",
            "deviceId": "device-0001",
            "googleLinkToken": link,
        },
    )
    assert resp.status_code == 200
    user = User.objects.get(phone=TEST_NUMBER)
    assert user.google_sub == "google-sub-1"
    assert user.email == "asha@example.com"

    again = api.post("/auth/google", {"idToken": "valid-google-token", "deviceId": "device-0002"})
    assert again.json()["status"] == "LOGGED_IN"
    access = again.json()["tokens"]["accessToken"]
    me = api.get("/patient/me", token=access).json()
    assert me["googleLinked"] is True


def test_invalid_google_token(api, google_ok):
    resp = api.post("/auth/google", {"idToken": "forged", "deviceId": "device-0001"})
    assert resp.status_code == 401
    assert error(resp)["code"] == "GOOGLE_TOKEN_INVALID"


def test_google_off_without_client_ids(api, settings):
    settings.GOOGLE_CLIENT_IDS = []
    resp = api.post("/auth/google", {"idToken": "anything", "deviceId": "device-0001"})
    assert error(resp)["code"] == "GOOGLE_NOT_CONFIGURED"


def test_google_link_is_patients_only_and_cannot_be_forged(api, google_ok):
    link = api.post(
        "/auth/google", {"idToken": "valid-google-token", "deviceId": "device-0001"}
    ).json()["googleLinkToken"]
    api.post(
        "/auth/otp/send",
        {"phone": TEST_NUMBER, "purpose": "partner_primary", "deviceId": "device-0001"},
    )
    resp = api.post(
        "/auth/otp/verify",
        {
            "phone": TEST_NUMBER,
            "otp": TEST_CODE,
            "purpose": "partner_primary",
            "deviceId": "device-0001",
            "googleLinkToken": link,
        },
    )
    assert error(resp)["code"] == "GOOGLE_NOT_ALLOWED"

    api.post(
        "/auth/otp/send", {"phone": TEST_NUMBER, "purpose": "login", "deviceId": "device-0001"}
    )
    resp = api.post(
        "/auth/otp/verify",
        {
            "phone": TEST_NUMBER,
            "otp": TEST_CODE,
            "purpose": "login",
            "deviceId": "device-0001",
            "googleLinkToken": link + "tampered",
        },
    )
    assert error(resp)["code"] == "GOOGLE_LINK_EXPIRED"
    assert User.objects.filter(google_sub="google-sub-1").count() == 0


def test_one_google_account_links_to_one_phone(api, google_ok):
    for phone in (TEST_NUMBER, "+919000000002"):
        User.objects.create_user(phone)
    User.objects.filter(phone="+919000000002").update(google_sub="google-sub-1")
    link = api.post(
        "/auth/google", {"idToken": "valid-google-token", "deviceId": "device-0001"}
    ).json()
    # +919000000002 has the Google id but no verified phone → PHONE_REQUIRED
    assert link["status"] == "PHONE_REQUIRED"
    api.post(
        "/auth/otp/send", {"phone": TEST_NUMBER, "purpose": "login", "deviceId": "device-0001"}
    )
    resp = api.post(
        "/auth/otp/verify",
        {
            "phone": TEST_NUMBER,
            "otp": TEST_CODE,
            "purpose": "login",
            "deviceId": "device-0001",
            "googleLinkToken": link["googleLinkToken"],
        },
    )
    assert resp.status_code == 409
    assert error(resp)["code"] == "GOOGLE_ALREADY_LINKED"


def test_register_device_is_an_upsert(api):
    tokens = otp_login(api)
    body = {"deviceId": "device-0001", "platform": "android", "appVersion": "0.1.0"}
    assert api.put("/patient/me/device", body, token=tokens["accessToken"]).status_code == 200
    body |= {"appVersion": "0.2.0", "fcmToken": "fcm-abc"}
    assert api.put("/patient/me/device", body, token=tokens["accessToken"]).status_code == 200
    device = Device.objects.get()
    assert (device.app, device.app_version, device.fcm_token) == ("patient", "0.2.0", "fcm-abc")

    partner = otp_login(api, purpose="partner_primary", device_id="partner-phone-a")
    body = {"deviceId": "partner-phone-a", "platform": "android", "appVersion": "0.1.0"}
    assert api.put("/partner/me/device", body, token=partner["accessToken"]).status_code == 200
    assert Device.objects.filter(app="partner").count() == 1
    bad = api.put("/patient/me/device", body | {"platform": "windows"}, token=tokens["accessToken"])
    assert bad.status_code == 422


def test_consents_are_recorded_with_version_time_and_ip(api, staff_roles):
    tokens = otp_login(api)
    me = api.get("/patient/me", token=tokens["accessToken"]).json()
    needed = me["consentsNeeded"]
    assert {c["type"] for c in needed} == {"TERMS", "PRIVACY", "HEALTH_DATA"}

    resp = api.post("/patient/me/consents", {"items": needed}, token=tokens["accessToken"])
    assert resp.status_code == 200
    assert api.get("/patient/me", token=tokens["accessToken"]).json()["consentsNeeded"] == []
    consent = Consent.objects.get(type="TERMS")
    assert consent.version == "2026-10"  # the first drafts' version (§6.20)
    assert consent.ip == "127.0.0.1"
    assert consent.accepted_at is not None

    # the admin publishes new terms asking everyone again: asked again, and only the current
    # version can be accepted (§6.20)
    admin = staff_token(api, staff_roles)
    terms = api.get("/admin/legal/TERMS", admin).json()
    published = api.post(
        "/admin/legal/TERMS",
        {
            "expectedVersion": terms["version"],
            "askAgain": True,
            "titleEn": terms["titleEn"],
            "bodyEn": terms["bodyEn"] + "\n\nA new rule.",
        },
        admin,
    )
    assert published.status_code == 200
    me = api.get("/patient/me", token=tokens["accessToken"]).json()
    assert me["consentsNeeded"] == [{"type": "TERMS", "version": "2"}]
    old = api.post(
        "/patient/me/consents",
        {"items": [{"type": "TERMS", "version": "2026-10"}]},
        token=tokens["accessToken"],
    )
    assert old.status_code == 409
    assert error(old)["code"] == "CONSENT_VERSION_CHANGED"
    # a partner's consent can't be accepted through the patient app
    partner_terms = api.post(
        "/patient/me/consents",
        {"items": [{"type": "PARTNER_TERMS", "version": "2026-10"}]},
        token=tokens["accessToken"],
    )
    assert partner_terms.status_code == 409


def _register(api, token, path="/patient/me/device", device_id="device-0001", fcm=""):
    body = {"deviceId": device_id, "platform": "android", "appVersion": "0.1.0", "fcmToken": fcm}
    assert api.put(path, body, token=token).status_code == 200


def test_logout_forgets_the_device(api):
    tokens = otp_login(api)
    _register(api, tokens["accessToken"], fcm="fcm-1")
    assert Device.objects.count() == 1
    api.post("/auth/logout", token=tokens["accessToken"])
    assert Device.objects.count() == 0  # no more pushes to a logged-out phone


def test_partner_logged_in_elsewhere_forgets_the_old_phone(api):
    old = otp_login(api, purpose="partner_primary", device_id="partner-phone-a")
    _register(api, old["accessToken"], path="/partner/me/device", device_id="partner-phone-a")
    new = otp_login(api, purpose="partner_primary", device_id="partner-phone-b")
    _register(api, new["accessToken"], path="/partner/me/device", device_id="partner-phone-b")
    assert list(Device.objects.values_list("device_id", flat=True)) == ["partner-phone-b"]


def test_a_push_token_belongs_to_one_phone_and_person(api):
    first = otp_login(api)
    _register(api, first["accessToken"], fcm="shared-fcm")
    second = otp_login(api, phone="+919000000002", device_id="device-0002")
    _register(api, second["accessToken"], device_id="device-0002", fcm="shared-fcm")
    rows = list(Device.objects.values_list("user__phone", "fcm_token"))
    assert rows == [("+919000000002", "shared-fcm")]
