"""Hospitals, doctors and specialities: admin CRUD, delete rules, nearby search (§6.7)."""

import pytest

from apps.audit.models import AuditLog
from apps.hospitals.models import Doctor, Hospital, Speciality
from apps.hospitals.seed import DOCTORS, HOSPITALS, SPECIALITIES, seed_directory
from apps.hospitals.selectors import nearby_hospitals
from common import usage
from common.geo import haversine_km
from conftest import staff_token

pytestmark = pytest.mark.django_db

CENTRE = (20.2961, 85.8245)  # Bhubaneswar
HOSPITAL = {
    "name": "Test Hospital",
    "type": "HOSPITAL",
    "address": "Plot 1, Saheed Nagar, Bhubaneswar",
    "city": "Bhubaneswar",
    "lat": "20.290000",
    "lng": "85.840000",
    "opdHours": "Mon to Sat 9 to 5",
    "departments": ["Cardiology"],
}


@pytest.fixture
def token(api, staff_roles):
    return staff_token(api, staff_roles)


def make_hospital(name: str, lat: float, lng: float, active: bool = True) -> Hospital:
    return Hospital.objects.create(
        name=name, address="Somewhere in Odisha", lat=lat, lng=lng, is_active=active
    )


# --- Nearby search ---


def test_nearby_is_sorted_by_distance_from_the_seed():
    seed_directory()
    found, radius = nearby_hospitals(*CENTRE)
    names = [h.name for h in found]
    assert len(found) == len(HOSPITALS)
    distances = [h.distance_km for h in found]  # type: ignore[attr-defined]
    assert distances == sorted(distances)
    by_python = sorted(HOSPITALS, key=lambda h: haversine_km(*CENTRE, float(h[3]), float(h[4])))
    assert names == [h[0] for h in by_python]
    assert names[0] == "Apollo Hospitals Bhubaneswar"  # about 1.6 km from the centre
    assert radius == 10  # all 5 are within 10 km of the centre


def test_nearby_stays_at_10_km_when_5_are_found():
    for i in range(5):
        make_hospital(f"Near {i}", 20.30 + i * 0.005, 85.82)
    make_hospital("Far", 20.45, 85.82)  # about 17 km away
    found, radius = nearby_hospitals(20.30, 85.82)
    assert radius == 10
    assert [h.name for h in found] == [f"Near {i}" for i in range(5)]


def test_nearby_widens_to_25_km_and_skips_inactive():
    make_hospital("Near", 20.30, 85.82)
    make_hospital("Far", 20.45, 85.82)
    make_hospital("Closed", 20.301, 85.82, active=False)
    make_hospital("Too far", 20.60, 85.82)  # about 33 km
    found, radius = nearby_hospitals(20.30, 85.82)
    assert radius == 25
    assert [h.name for h in found] == ["Near", "Far"]


def test_nearby_filters_by_speciality_and_name():
    seed_directory()
    cardio = Speciality.objects.get(name="Cardiology")
    found, _ = nearby_hospitals(*CENTRE, speciality_id=str(cardio.pk))
    assert [h.name for h in found] == ["AIIMS Bhubaneswar"]
    found, _ = nearby_hospitals(*CENTRE, q="Patnaik")  # a doctor's name
    assert [h.name for h in found] == ["AIIMS Bhubaneswar"]


def test_seed_is_complete_and_safe_to_rerun():
    seed_directory()
    seed_directory()
    assert Speciality.objects.count() == len(SPECIALITIES)
    assert Hospital.objects.count() == len(HOSPITALS) == 5
    assert Doctor.objects.count() == len(DOCTORS) == 10
    assert all(d.hospitals.exists() for d in Doctor.objects.all())


# --- Admin CRUD ---


def test_hospital_crud_and_audit(api, token):
    created = api.post("/admin/hospitals", HOSPITAL, token)
    assert created.status_code == 200, created.json()
    hid = created.json()["id"]
    assert created.json()["lat"] == "20.290000"
    updated = api.put(f"/admin/hospitals/{hid}", {**HOSPITAL, "phone": "06742300000"}, token)
    assert updated.json()["phone"] == "06742300000"
    row = AuditLog.objects.get(action="hospital.updated", entity_id=hid)
    assert row.before == {"phone": ""}
    assert row.after == {"phone": "06742300000"}
    assert api.post(f"/admin/hospitals/{hid}/deactivate", token=token).json()["isActive"] is False
    assert api.delete(f"/admin/hospitals/{hid}", token).status_code == 200
    assert not Hospital.objects.filter(pk=hid).exists()


def test_hospital_location_is_validated(api, token):
    resp = api.post("/admin/hospitals", {**HOSPITAL, "lat": "95.0"}, token)
    assert resp.status_code == 422


def test_hospital_used_in_bookings_cannot_be_deleted(api, token, monkeypatch):
    hid = api.post("/admin/hospitals", HOSPITAL, token).json()["id"]
    monkeypatch.setitem(usage._checks, "hospital", [lambda hospital_id: True])
    resp = api.delete(f"/admin/hospitals/{hid}", token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "IN_USE"


def test_hospital_with_doctors_cannot_be_deleted(api, token):
    hid = api.post("/admin/hospitals", HOSPITAL, token).json()["id"]
    sid = api.post("/admin/specialities", {"name": "Cardiology"}, token).json()["id"]
    doctor = api.post(
        "/admin/doctors",
        {"fullName": "Dr. Test", "specialityId": sid, "hospitalIds": [hid], "languages": ["Odia"]},
        token,
    )
    assert doctor.status_code == 200, doctor.json()
    assert doctor.json()["hospitals"] == [{"id": hid, "name": "Test Hospital"}]
    assert api.delete(f"/admin/hospitals/{hid}", token).status_code == 409
    assert api.delete(f"/admin/specialities/{sid}", token).status_code == 409


def test_doctor_hospitals_are_synced(api, token):
    a = api.post("/admin/hospitals", HOSPITAL, token).json()["id"]
    b = api.post("/admin/hospitals", {**HOSPITAL, "name": "Second"}, token).json()["id"]
    sid = api.post("/admin/specialities", {"name": "ENT"}, token).json()["id"]
    doc = {"fullName": "Dr. Sync", "specialityId": sid, "hospitalIds": [a, b]}
    did = api.post("/admin/doctors", doc, token).json()["id"]
    resp = api.put(f"/admin/doctors/{did}", {**doc, "hospitalIds": [b]}, token)
    assert [h["id"] for h in resp.json()["hospitals"]] == [b]
    row = AuditLog.objects.get(action="doctor.updated", entity_id=did)
    assert row.after == {"hospital_ids": [b]}
    by_hospital = api.get(f"/admin/doctors?hospitalId={a}", token).json()
    assert by_hospital == []


def test_doctor_needs_a_known_speciality(api, token):
    resp = api.post(
        "/admin/doctors",
        {"fullName": "Dr. X", "specialityId": "00000000-0000-0000-0000-000000000000"},
        token,
    )
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "UNKNOWN_SPECIALITY"


def test_speciality_names_are_unique(api, token):
    assert api.post("/admin/specialities", {"name": "Cardiology"}, token).status_code == 200
    resp = api.post("/admin/specialities", {"name": "cardiology"}, token)
    assert resp.json()["error"]["code"] == "NAME_TAKEN"


def test_public_specialities(api):
    seed_directory()
    body = api.get("/public/specialities").json()
    assert len(body) == len(SPECIALITIES)
    assert {"name", "nameHi", "nameOr", "icon"} <= set(body[0])


def test_directory_permissions(api, staff_roles):
    support = staff_token(api, staff_roles, "SUPPORT")  # directory.view only
    assert api.get("/admin/hospitals", support).status_code == 200
    assert api.post("/admin/hospitals", HOSPITAL, support).status_code == 403
    ops = staff_token(api, staff_roles, "OPERATIONS")  # directory.manage
    assert api.post("/admin/hospitals", HOSPITAL, ops).status_code == 200
    finance = staff_token(api, staff_roles, "FINANCE")
    assert api.get("/admin/doctors", finance).status_code == 403
