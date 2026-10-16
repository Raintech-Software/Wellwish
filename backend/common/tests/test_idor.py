"""§12 Authorization, checked for EVERY endpoint (PHASES 9.3).

- Patient and partner apps: each endpoint that takes an object id in its path is called by
  another patient / another approved partner with the first one's real ids (and a valid body, so
  nothing is refused before the ownership check): the answer is 404, and nothing changes.
- Admin panel: each endpoint needs a permission (`staff_permission` / `staff_any_permission`);
  the few that don't say why below.
- A new endpoint fails these tests until it is added to the tables below.
"""

import re
from collections.abc import Callable
from typing import Any

import pytest

from apps.bookings.tests.support import tomorrow_at
from apps.documents.models import PatientDocument
from apps.patients.models import Member
from apps.patients.tests.support import MOTHER, address_body, patient
from config.api import api as ninja_api
from conftest import staff_token

pytestmark = pytest.mark.django_db

Body = Callable[[dict[str, Any]], dict[str, Any] | None]
NO_BODY: Body = lambda ctx: None  # noqa: E731

POINT = {"lat": "20.296100", "lng": "85.824500", "accuracy": 10.0}

# (method, path) → the body another user sends (built from their own ids in `ctx`)
PATIENT_OWNED: dict[tuple[str, str], Body] = {
    ("PUT", "/patient/addresses/{address_id}"): lambda ctx: address_body(ctx["b_member"]),
    ("DELETE", "/patient/addresses/{address_id}"): NO_BODY,
    ("GET", "/patient/bookings/{booking_id}"): NO_BODY,
    ("POST", "/patient/bookings/{booking_id}/cancel"): lambda ctx: {"reason": "Plans changed"},
    ("GET", "/patient/bookings/{booking_id}/cancel-preview"): NO_BODY,
    ("POST", "/patient/bookings/{booking_id}/checkout"): NO_BODY,
    ("GET", "/patient/bookings/{booking_id}/live"): NO_BODY,
    ("POST", "/patient/bookings/{booking_id}/report-problem"): lambda ctx: {
        "text": "Nobody came to help us"
    },
    ("POST", "/patient/bookings/{booking_id}/reschedule"): lambda ctx: {
        "pickupAt": tomorrow_at(15).isoformat(),
        "appointmentAt": tomorrow_at(16).isoformat(),
    },
    ("GET", "/patient/bookings/{booking_id}/reschedule-times"): NO_BODY,
    ("POST", "/patient/bookings/{booking_id}/review"): lambda ctx: {"stars": 1},
    ("POST", "/patient/bookings/{booking_id}/share-link"): NO_BODY,
    ("POST", "/patient/bookings/{booking_id}/sos"): lambda ctx: {},
    ("DELETE", "/patient/documents/{document_id}"): NO_BODY,
    ("GET", "/patient/documents/{document_id}/view-url"): NO_BODY,
    ("GET", "/patient/members/{member_id}"): NO_BODY,
    ("PUT", "/patient/members/{member_id}"): lambda ctx: MOTHER,
    ("DELETE", "/patient/members/{member_id}"): NO_BODY,
}
# The hospital and doctor directory is shared, not anyone's data.
PATIENT_PUBLIC = {
    ("GET", "/patient/doctors/{doctor_id}"),
    ("GET", "/patient/hospitals/{hospital_id}"),
}

PARTNER_OWNED: dict[tuple[str, str], Body] = {
    ("GET", "/partner/jobs/{booking_id}"): NO_BODY,
    ("GET", "/partner/jobs/{booking_id}/documents/{link_id}/view-url"): NO_BODY,
    ("GET", "/partner/offers/{assignment_id}"): NO_BODY,
    ("POST", "/partner/offers/{assignment_id}/accept"): NO_BODY,
    ("POST", "/partner/offers/{assignment_id}/decline"): lambda ctx: {"reason": "TOO_FAR"},
    ("POST", "/partner/bookings/{booking_id}/steps"): lambda ctx: {"step": "ON_THE_WAY", **POINT},
    ("POST", "/partner/bookings/{booking_id}/calls"): lambda ctx: {"to": "MEMBER"},
    ("POST", "/partner/bookings/{booking_id}/patient-not-available"): lambda ctx: POINT,
    ("POST", "/partner/bookings/{booking_id}/balance"): lambda ctx: {
        "amountPaise": 40000,
        "mode": "CASH",
    },
    ("POST", "/partner/bookings/{booking_id}/sos"): lambda ctx: {},
    ("POST", "/partner/bookings/{booking_id}/track-batch"): lambda ctx: {
        "points": [{**POINT, "at": tomorrow_at(10).isoformat()}]
    },
}

# Admin endpoints that need no permission, and why.
ADMIN_OPEN = {
    ("POST", "/admin/auth/login"): "signing in",
    ("POST", "/admin/auth/totp"): "signing in",
    ("POST", "/admin/auth/recovery"): "signing in",
    ("POST", "/admin/auth/email-code"): "signing in",
    ("POST", "/admin/auth/refresh"): "signing in",
    ("POST", "/admin/auth/logout"): "signing out",
    ("GET", "/admin/me"): "the admin's own account",
    ("POST", "/admin/me/recovery-codes"): "the admin's own account",
    ("POST", "/admin/me/recovery-codes/saved"): "the admin's own account",
    ("POST", "/admin/files/upload-url"): "checks the permission of each file purpose itself",
}


def _operations() -> list[tuple[str, str, Any]]:
    """Every (method, path, view) of the API, from the routers (paths without /v1)."""
    found: list[tuple[str, str, Any]] = []

    def walk(router: Any, prefix: str) -> None:
        for path, view in router.path_operations.items():
            for op in view.operations:
                for method in op.methods:
                    found.append((method, prefix + path, op.view_func))
        for entry in getattr(router, "_routers", []):
            walk(entry[1], prefix + entry[0])

    for prefix, router in ninja_api._routers:
        walk(router, prefix)
    # "{uuid:booking_id}" → "{booking_id}" (the type converter isn't part of the name)
    return [(m, re.sub(r"\{\w+:(\w+)\}", r"{\1}", p), view) for m, p, view in found]


def _with_ids(path: str) -> bool:
    return "{" in path


def test_every_endpoint_with_an_id_is_covered():
    """A new endpoint must be added here: an ownership check (404) or a reason it has none."""
    ops = _operations()
    patient = {(m, p) for m, p, _ in ops if p.startswith("/patient/") and _with_ids(p)}
    partner = {(m, p) for m, p, _ in ops if p.startswith("/partner/") and _with_ids(p)}
    assert patient == set(PATIENT_OWNED) | PATIENT_PUBLIC
    assert partner == set(PARTNER_OWNED)


def test_every_admin_endpoint_needs_a_permission():
    missing = [
        (m, p)
        for m, p, view in _operations()
        if p.startswith("/admin/")
        and (m, p) not in ADMIN_OPEN
        and not getattr(view, "required_permissions", None)
    ]
    assert missing == []
    # and the open ones still exist (a renamed endpoint must be looked at again)
    paths = {(m, p) for m, p, _ in _operations()}
    assert set(ADMIN_OPEN) <= paths


def test_a_role_without_permissions_gets_nothing(api, staff_roles):
    """The upload URL checks each purpose itself: a role without the permission is refused."""
    support = staff_token(api, staff_roles, "SUPPORT")
    for purpose in ("partner_photo", "kyc_document", "temp_partner_id", "member_photo"):
        resp = api.post(
            "/admin/files/upload-url",
            {"purpose": purpose, "mime": "image/jpeg", "sizeBytes": 1000},
            support,
        )
        if purpose != "member_photo":
            assert resp.status_code == 403, (purpose, resp.json())


def _call(api, method: str, path: str, token: str, body: dict[str, Any] | None) -> Any:
    if method == "GET":
        return api.get(path, token)
    if method == "DELETE":
        extra = {"HTTP_AUTHORIZATION": f"Bearer {token}"}
        return api.client.delete(f"/v1{path}", **extra)
    return getattr(api, method.lower())(path, body or {}, token)


def test_another_patient_gets_404_for_every_id(api, world, booking):
    other = patient(api, phone="+919000000002", device_id="other-patient")
    ctx = {"b_member": api.get("/patient/members", other).json()[0]["id"]}
    ids = {
        "booking_id": str(booking.pk),
        "address_id": world.address["id"],
        "member_id": world.mother["id"],
        "document_id": world.prescription["id"],
    }
    refused = {}
    for (method, path), body in PATIENT_OWNED.items():
        resp = _call(api, method, path.format(**ids), other, body(ctx))
        refused[(method, path)] = resp.status_code
    assert set(refused.values()) == {404}, {k: v for k, v in refused.items() if v != 404}
    # nothing of the first patient changed
    booking.refresh_from_db()
    assert booking.status == "NEW" and booking.cancelled_by == ""
    assert Member.objects.filter(pk=world.mother["id"], is_active=True).exists()
    assert PatientDocument.objects.filter(pk=world.prescription["id"]).exists()
    assert api.get(f"/patient/bookings/{booking.pk}", world.token).status_code == 200


def test_another_partner_gets_404_for_every_id(api, booking, asha, ravi, staff_roles):
    asha_token, asha_id = asha
    ravi_token, _ = ravi
    ops = staff_token(api, staff_roles, "OPERATIONS")
    api.post(
        f"/admin/bookings/{booking.pk}/assign",
        {"partnerId": asha_id, "expectedAssignmentId": None},
        ops,
    )
    offer = api.get("/partner/offers", asha_token).json()[0]
    job = api.get(f"/partner/jobs/{booking.pk}", asha_token)
    links = job.json().get("documents", []) if job.status_code == 200 else []
    ids = {
        "booking_id": str(booking.pk),
        "assignment_id": offer["assignmentId"],
        "link_id": links[0]["id"] if links else "00000000-0000-0000-0000-000000000000",
    }
    refused = {}
    for (method, path), body in PARTNER_OWNED.items():
        resp = _call(api, method, path.format(**ids), ravi_token, body({}))
        refused[(method, path)] = resp.status_code
    assert set(refused.values()) == {404}, {k: v for k, v in refused.items() if v != 404}
    # the offer is still Asha's to answer
    booking.refresh_from_db()
    assert booking.status == "OFFERED" and str(booking.partner_id) == asha_id


def _body_schemas() -> list[tuple[str, str, Any]]:
    """(method, path, schema) of every request body."""
    found = []

    def walk(router: Any, prefix: str) -> None:
        for path, view in router.path_operations.items():
            for op in view.operations:
                for model in op.signature.models:
                    if getattr(model, "__ninja_param_source__", None) != "body":
                        continue
                    for field in model.model_fields.values():
                        found.append(("/".join(op.methods), prefix + path, field.annotation))
        for entry in getattr(router, "_routers", []):
            walk(entry[1], prefix + entry[0])

    for prefix, router in ninja_api._routers:
        walk(router, prefix)
    return found


def test_every_request_body_refuses_unknown_fields():
    """§12 Input: every body is a schema with extra="forbid" (StrictIn), so a field the
    endpoint doesn't know (e.g. "status" or "pricePaise" slipped in) is refused, not ignored."""
    from typing import get_args

    from pydantic import BaseModel

    def schemas(annotation: Any) -> list[Any]:
        if isinstance(annotation, type) and issubclass(annotation, BaseModel):
            return [annotation]
        return [s for arg in get_args(annotation) for s in schemas(arg)]

    bodies = _body_schemas()
    assert len(bodies) > 80  # 90 when written (Phase 9.3)
    loose = [
        (m, p, getattr(s, "__name__", str(s)))
        for m, p, annotation in bodies
        for s in schemas(annotation) or [annotation]  # a body that isn't a schema is loose too
        if getattr(s, "model_config", {}).get("extra") != "forbid"
    ]
    assert loose == []
