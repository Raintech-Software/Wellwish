"""Admin bookings list and detail (PHASES 5.14, §9.1)."""

import datetime as dt

import pytest

from apps.bookings.models import Booking
from apps.bookings.services import SYSTEM, transition
from apps.bookings.tests.support import body, book, make_world, tomorrow_at
from apps.patients.tests.support import OWNER
from common.dates import today_ist
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture
def booked(api):
    world = make_world(api)
    me = {"fullName": "Priyansu Gouda", "dob": "1990-05-01", "gender": "MALE", "language": "en"}
    assert api.put("/patient/me", me, world.token).status_code == 200
    paid = book(api, world.token, body(world)).json()
    transition(Booking.objects.get(pk=paid["id"]), "PAY", SYSTEM)
    unpaid = book(
        api,
        world.token,
        body(world, "Wound dressing", pickupAt=tomorrow_at(15).isoformat(), documentIds=[]),
    ).json()
    return world, paid, unpaid


def test_list_hides_unpaid_by_default(api, booked, staff_roles):
    world, paid, unpaid = booked
    token = staff_token(api, staff_roles)
    rows = api.get("/admin/bookings", token).json()
    assert [r["id"] for r in rows["items"]] == [paid["id"]]
    row = rows["items"][0]
    assert row["status"] == "NEW"
    assert row["serviceName"] == "Doctor visit companion"
    assert row["partnerType"] == "COMPANION"
    assert row["memberName"] == "Sabitri Gouda"
    assert row["patientPhone"] == OWNER
    assert row["hospitalName"] == world.hospital.name
    assert row["bookingFeePaise"] == 10000

    def ids(query):
        resp = api.get(f"/admin/bookings?{query}", token)
        assert resp.status_code == 200, resp.json()
        return [r["id"] for r in resp.json()["items"]]

    assert ids("status=PENDING_PAYMENT") == [unpaid["id"]]
    assert ids("status=NEW&type=NURSE") == []
    assert ids("status=PENDING_PAYMENT&type=NURSE") == [unpaid["id"]]
    tomorrow = today_ist() + dt.timedelta(days=1)
    assert ids(f"date={tomorrow}") == [paid["id"]]
    assert ids(f"date={tomorrow + dt.timedelta(days=1)}") == []
    assert ids("when=tomorrow") == [paid["id"]]
    assert ids("when=today") == []
    assert ids("when=later") == []
    assert ids(f"q={paid['code']}") == [paid["id"]]
    assert ids(f"q={paid['code'][3:]}") == [paid["id"]]  # without "WW-"
    assert ids("q=0000001") == [paid["id"]]  # the phone
    assert ids("q=sabitri") == [paid["id"]]
    assert ids("q=nobody") == []
    assert api.get("/admin/bookings?status=LOST", token).status_code == 422


def test_detail(api, booked, staff_roles):
    world, paid, _ = booked
    token = staff_token(api, staff_roles)
    detail = api.get(f"/admin/bookings/{paid['id']}", token)
    assert detail.status_code == 200, detail.json()
    data = detail.json()
    assert data["patient"]["phone"] == OWNER
    assert data["patient"]["fullName"] == "Priyansu Gouda"
    assert data["member"]["phone"] == "+919876543210"
    assert data["service"]["balancePaise"] == 40000
    assert data["doctorName"] == world.doctor.full_name
    assert data["address"]["landmark"] == "Near the temple"
    assert data["documentsVisible"] is True
    assert data["documents"][0]["title"] == "Dr. Rath BP tablets"
    assert [(e["fromStatus"], e["status"], e["actorType"]) for e in data["timeline"]] == [
        ("", "PENDING_PAYMENT", "PATIENT"),
        ("PENDING_PAYMENT", "NEW", "SYSTEM"),
    ]
    assert api.get("/admin/bookings/00000000-0000-4000-8000-000000000000", token).status_code == 404


def test_permissions(api, booked, staff_roles):
    _, paid, _ = booked
    support = staff_token(api, staff_roles, "SUPPORT")  # bookings.view, no patient documents
    data = api.get(f"/admin/bookings/{paid['id']}", support).json()
    assert data["documentsVisible"] is False
    assert data["documents"] == [
        {"id": data["documents"][0]["id"], "documentId": data["documents"][0]["documentId"],
         "type": "PRESCRIPTION", "title": "", "removed": False}
    ]  # fmt: skip
    verification = staff_token(api, staff_roles, "VERIFICATION")  # no bookings.view
    assert api.get("/admin/bookings", verification).status_code == 403
    assert api.get(f"/admin/bookings/{paid['id']}", verification).status_code == 403


def test_patient_page_lists_the_bookings(api, booked, staff_roles):
    _, paid, unpaid = booked
    token = staff_token(api, staff_roles)
    user_id = Booking.objects.get(pk=paid["id"]).booked_by_id
    data = api.get(f"/admin/patients/{user_id}", token).json()
    assert {b["id"] for b in data["bookings"]} == {paid["id"], unpaid["id"]}
