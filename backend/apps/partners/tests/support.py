"""Helpers for partner registration tests: log in, upload files, fill each step."""

import re
from typing import Any

from django.core.cache import cache

from apps.files.tests.support import send_file
from common.mail import read_dev_outbox as read_mail
from common.sms import read_dev_outbox as read_sms
from conftest import TEST_CODE, Api

PRIMARY = "+919000000001"  # test number: accepts 123456
ALTERNATE = "+919000000002"  # test number too
PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 64
PDF = b"%PDF-1.4\n" + b"\x00" * 64

PROFILE = {
    "fullName": "Asha Behera",
    "dob": "1990-05-17",
    "gender": "FEMALE",
    "address": "Plot 12, Saheed Nagar, Bhubaneswar 751007",
    "lat": "20.290000",
    "lng": "85.840000",
    "languages": ["Odia", "Hindi"],
    "skills": ["Elderly care"],
    "emergencyName": "Ravi Behera",
    "emergencyPhone": "9876500001",
}


def partner_login(
    api: Api, phone: str = PRIMARY, device_id: str = "partner-device-1", accept_terms: bool = True
) -> str:
    """OTP login in the partner app. Test numbers use 123456; others read the dev outbox."""
    sent = api.post(
        "/auth/otp/send", {"phone": phone, "purpose": "partner_primary", "deviceId": device_id}
    )
    assert sent.status_code == 200, sent.json()
    code = TEST_CODE
    if phone not in ("+919000000001", "+919000000002"):
        code = re.findall(r"\b(\d{6})\b", read_sms(phone)[-1]["text"])[0]
    resp = api.post(
        "/auth/otp/verify",
        {"phone": phone, "otp": code, "purpose": "partner_primary", "deviceId": device_id},
    )
    assert resp.status_code == 200, resp.json()
    cache.delete(f"otp:partner_primary:{phone}:resend")
    token = str(resp.json()["accessToken"])
    if accept_terms:  # §6.20: the app's consent screen (registering needs it)
        needed = api.get("/partner/me", token).json()["consentsNeeded"]
        if needed:
            assert api.post("/partner/me/consents", {"items": needed}, token).status_code == 200
    return token


def upload(
    api: Api,
    token: str,
    purpose: str,
    content: bytes = PNG,
    mime: str = "image/png",
    admin: bool = False,
) -> str:
    path = "/admin/files/upload-url" if admin else "/partner/kyc/upload-url"
    ticket = api.post(path, {"purpose": purpose, "mime": mime, "sizeBytes": len(content)}, token)
    assert ticket.status_code == 200, ticket.json()
    put = send_file(ticket.json()["uploadUrl"], content, mime, ticket.json()["uploadFields"])
    assert put.status_code == 204
    return str(ticket.json()["fileKey"])


def verify_alternate(api: Api, token: str, phone: str = ALTERNATE) -> Any:
    sent = api.post("/partner/register/alternate-phone", {"phone": phone}, token)
    assert sent.status_code == 200, sent.json()
    return api.post("/partner/register/alternate-phone/verify", {"code": TEST_CODE}, token)


def email_code(email: str) -> str:
    return re.findall(r"\b(\d{6})\b", read_mail(email)[-1]["text"])[0]


def verify_email(api: Api, token: str, email: str = "asha@example.com") -> Any:
    sent = api.post("/partner/register/email", {"email": email}, token)
    assert sent.status_code == 200, sent.json()
    return api.post("/partner/register/email/verify", {"code": email_code(email)}, token)


def save_profile(api: Api, token: str, **changes: Any) -> Any:
    photo = upload(api, token, "partner_photo")
    return api.put("/partner/register/profile", {**PROFILE, "photoKey": photo, **changes}, token)


DOCUMENT_FIELDS = {
    "AADHAAR": {"number": "2345 6789 1234"},
    "PAN": {"number": "ABCDE1234F"},
    "POLICE_VERIFICATION": {"expiresOn": "2099-01-31"},
    "NURSING_REGISTRATION": {"number": "OD-NC-12345", "expiresOn": "2099-12-31"},
    "DRIVING_LICENCE": {"number": "OD0220190001234", "expiresOn": "2099-06-30"},
}


def add_document(api: Api, token: str, doc_type: str, **changes: Any) -> Any:
    key = upload(api, token, "kyc_document", PDF, "application/pdf")
    body = {"docType": doc_type, "fileKey": key, **DOCUMENT_FIELDS.get(doc_type, {}), **changes}
    return api.post("/partner/kyc/documents", body, token)


def register(api: Api, token: str, role: str = "COMPANION", email: str = "asha@example.com") -> Any:
    """Every step up to REGISTERED, then every mandatory document. Returns the last status."""
    assert api.post("/partner/register/start", {"role": role}, token).status_code == 200
    assert verify_alternate(api, token).status_code == 200
    assert verify_email(api, token, email).status_code == 200
    assert save_profile(api, token).status_code == 200
    required = api.get("/partner/kyc/required", token).json()
    status = None
    for doc in required:
        if doc["mandatory"]:
            resp = add_document(api, token, doc["docType"])
            assert resp.status_code == 200, resp.json()
            status = resp.json()
    return status
