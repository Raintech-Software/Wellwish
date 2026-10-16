"""The patient app's directory (PHASES 5.1, §6.7): nearby hospitals, hospital detail, doctors."""

import pytest

from apps.hospitals.models import Doctor, Hospital, Speciality
from apps.hospitals.seed import seed_directory
from apps.patients.tests.support import patient

pytestmark = pytest.mark.django_db

CENTRE = "lat=20.296100&lng=85.824500"  # Bhubaneswar


@pytest.fixture
def token(api):
    seed_directory()
    return patient(api)


def test_nearby_closest_first(api, token):
    resp = api.get(f"/patient/hospitals/nearby?{CENTRE}", token)
    assert resp.status_code == 200, resp.json()
    data = resp.json()
    assert data["radiusKm"] == 10
    distances = [h["distanceKm"] for h in data["items"]]
    assert distances == sorted(distances)
    assert len(distances) == 5
    first = data["items"][0]
    assert {"lat", "lng", "address", "opdHours", "doctorCount", "photoUrl"} <= first.keys()
    assert isinstance(first["lat"], str)
    assert first["doctorCount"] >= 1


def test_nearby_widens_and_filters(api, token):
    far = api.get("/patient/hospitals/nearby?lat=20.462500&lng=85.882800", token).json()
    assert far["radiusKm"] == 25  # Cuttack: fewer than 5 within 10 km
    cardio = Speciality.objects.get(name="Cardiology")
    by_speciality = api.get(
        f"/patient/hospitals/nearby?{CENTRE}&specialityId={cardio.pk}", token
    ).json()
    expected = set(
        Hospital.objects.filter(doctors__speciality=cardio).values_list("name", flat=True)
    )
    assert {h["name"] for h in by_speciality["items"]} == expected
    doctor = Doctor.objects.filter(hospitals__isnull=False).order_by("full_name")[0]
    by_doctor = api.get(f"/patient/hospitals/nearby?{CENTRE}&q={doctor.full_name[4:]}", token)
    assert {h["name"] for h in by_doctor.json()["items"]} == set(
        doctor.hospitals.values_list("name", flat=True)
    )
    bad = api.get(f"/patient/hospitals/nearby?{CENTRE}&specialityId=nope", token)
    assert bad.status_code == 422


def test_without_a_location_every_hospital_by_name(api, token):
    data = api.get("/patient/hospitals/nearby", token).json()
    assert data["radiusKm"] is None
    names = [h["name"] for h in data["items"]]
    assert names == sorted(names) and len(names) == 5
    assert all(h["distanceKm"] is None for h in data["items"])
    assert api.get("/patient/hospitals/nearby?lat=95&lng=85", token).status_code == 422


def test_inactive_entries_are_hidden(api, token):
    hospital = Hospital.objects.order_by("name")[0]
    hospital.is_active = False
    hospital.save()
    names = [h["name"] for h in api.get("/patient/hospitals/nearby", token).json()["items"]]
    assert hospital.name not in names
    assert api.get(f"/patient/hospitals/{hospital.pk}", token).status_code == 404
    doctor = Doctor.objects.order_by("full_name")[0]
    doctor.is_active = False
    doctor.save()
    assert api.get(f"/patient/doctors/{doctor.pk}", token).status_code == 404
    listed = api.get("/patient/doctors?pageSize=100", token).json()
    assert doctor.full_name not in [d["fullName"] for d in listed["items"]]
    for d in listed["items"]:
        assert hospital.name not in [h["name"] for h in d["hospitals"]]


def test_hospital_detail_with_doctors(api, token):
    hospital = Hospital.objects.filter(doctors__isnull=False).order_by("name")[0]
    data = api.get(f"/patient/hospitals/{hospital.pk}", token).json()
    assert data["name"] == hospital.name
    assert data["departments"] == hospital.departments
    assert data["distanceKm"] is None
    assert {d["fullName"] for d in data["doctors"]} == set(
        hospital.doctors.values_list("full_name", flat=True)
    )
    assert data["doctorCount"] == len(data["doctors"])
    assert data["doctors"][0]["speciality"]["nameOr"]


def test_doctor_directory(api, token):
    page = api.get("/patient/doctors?pageSize=3", token).json()
    assert page["count"] == Doctor.objects.count()
    names = [d["fullName"] for d in page["items"]]
    assert names == sorted(names) and len(names) == 3
    cardio = Speciality.objects.get(name="Cardiology")
    only = api.get(f"/patient/doctors?specialityId={cardio.pk}", token).json()["items"]
    assert {d["speciality"]["name"] for d in only} == {"Cardiology"}
    by_speciality_name = api.get("/patient/doctors?q=cardio", token).json()["items"]
    assert {d["id"] for d in by_speciality_name} == {d["id"] for d in only}
    hospital = Hospital.objects.filter(doctors__isnull=False).order_by("name")[0]
    at = api.get(f"/patient/doctors?hospitalId={hospital.pk}", token).json()["items"]
    assert all(hospital.name in [h["name"] for h in d["hospitals"]] for d in at)
    one = api.get(f"/patient/doctors/{only[0]['id']}", token).json()
    assert one["qualifications"]
    assert one["opdInfo"]
    assert isinstance(one["languages"], list)


def test_needs_a_patient_login(api, token):
    assert api.get("/patient/hospitals/nearby").status_code == 401
    assert api.get("/patient/doctors").status_code == 401
