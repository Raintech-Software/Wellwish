"""Helpers for family, address and document tests (Phase 4)."""

from typing import Any

from apps.app_config.models import ServiceArea
from apps.files.tests.support import send_file
from conftest import Api, otp_login

OWNER = "+919000000001"  # test number: accepts 123456
OTHER = "+919000000002"  # another patient account
PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 64
PDF = b"%PDF-1.4\n" + b"\x00" * 64
INSIDE = {"lat": "20.296100", "lng": "85.824500"}  # Bhubaneswar
OUTSIDE = {"lat": "12.971600", "lng": "77.594600"}  # Bengaluru

MOTHER = {
    "relation": "MOTHER",
    "fullName": "Sabitri Gouda",
    "dob": "1954-03-02",
    "gender": "FEMALE",
    "photoKey": "",
    "phone": "98765 43210",
    "language": "Odia",
    "conditions": "BP, diabetes",
    "allergies": "",
    "mobility": "NEEDS_SUPPORT",
    "sensoryNotes": "Hard of hearing",
    "emergencyName": "",
    "emergencyPhone": "",
    "consent": True,
}


def patient(api: Api, phone: str = OWNER, device_id: str = "patient-device-1") -> str:
    """Log in to the patient app; returns the access token."""
    return str(otp_login(api, phone=phone, device_id=device_id)["accessToken"])


def add_member(api: Api, token: str, **change: Any) -> Any:
    resp = api.post("/patient/members", MOTHER | change, token)
    assert resp.status_code == 200, resp.json()
    return resp.json()


def service_area() -> ServiceArea:
    return ServiceArea.objects.create(
        name="Bhubaneswar", city="Bhubaneswar", lat="20.296100", lng="85.824500", radius_km="25"
    )


def address_body(member_id: str, **change: Any) -> dict[str, Any]:
    return {
        "memberId": member_id,
        "label": "Home",
        "line1": "Plot 12, Saheed Nagar, Bhubaneswar 751007",
        "landmark": "Near the temple",
        "notes": "2nd floor, no lift",
        **INSIDE,
        **change,
    }


def put_file(api: Api, path: str, token: str, body: dict[str, Any], content: bytes) -> str:
    ticket = api.post(path, body, token)
    assert ticket.status_code == 200, ticket.json()
    mime = ticket.json()["mime"]
    put = send_file(ticket.json()["uploadUrl"], content, mime, ticket.json()["uploadFields"])
    assert put.status_code == 204
    return str(ticket.json()["fileKey"])


def upload_document(
    api: Api,
    token: str,
    content: bytes = PDF,
    mime: str = "application/pdf",
    kind: str = "LAB_REPORT",
) -> str:
    return put_file(
        api,
        "/patient/documents/upload-url",
        token,
        {"type": kind, "mime": mime, "sizeBytes": len(content)},
        content,
    )


def add_document(
    api: Api, token: str, member_id: str, kind: str = "LAB_REPORT", title: str = "Blood test"
) -> Any:
    key = upload_document(api, token, kind=kind)
    return api.post(
        "/patient/documents",
        {"fileKey": key, "memberId": member_id, "type": kind, "title": title, "date": "2026-08-12"},
        token,
    )
