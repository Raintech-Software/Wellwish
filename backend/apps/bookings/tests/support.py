"""Helpers for booking tests (Phase 5): a patient with Mother, her address and documents, the
sample services and the Bhubaneswar directory."""

import datetime as dt
import uuid
from dataclasses import dataclass
from typing import Any

from apps.bookings.times import IST
from apps.hospitals.models import Doctor, Hospital
from apps.hospitals.seed import seed_directory
from apps.patients.tests.support import (
    add_document,
    add_member,
    address_body,
    patient,
    service_area,
)
from apps.services.models import Service
from apps.services.seed import seed_services
from common.dates import today_ist
from conftest import Api


@dataclass
class World:
    token: str
    me: dict[str, Any]
    mother: dict[str, Any]
    address: dict[str, Any]
    prescription: dict[str, Any]
    lab_report: dict[str, Any]
    hospital: Hospital
    doctor: Doctor

    def service(self, name: str) -> Service:
        return Service.objects.get(name=name)


def make_world(api: Api) -> World:
    seed_services()
    seed_directory()
    service_area()
    token = patient(api)
    me = api.get("/patient/members", token).json()[0]
    mother = add_member(api, token)
    address = api.post("/patient/addresses", address_body(mother["id"]), token).json()
    prescription = add_document(
        api, token, mother["id"], kind="PRESCRIPTION", title="Dr. Rath BP tablets"
    ).json()
    lab_report = add_document(api, token, mother["id"], kind="LAB_REPORT").json()
    doctor = Doctor.objects.filter(hospitals__isnull=False).order_by("full_name").first()
    assert doctor is not None
    hospital = doctor.hospitals.order_by("name").first()
    assert hospital is not None
    return World(token, me, mother, address, prescription, lab_report, hospital, doctor)


def at_ist(day: dt.date, hour: int, minute: int = 0) -> dt.datetime:
    return dt.datetime.combine(day, dt.time(hour, minute), tzinfo=IST)


def tomorrow_at(hour: int, minute: int = 0) -> dt.datetime:
    return at_ist(today_ist() + dt.timedelta(days=1), hour, minute)


def body(world: World, service: str = "Doctor visit companion", **change: Any) -> dict[str, Any]:
    """A valid booking: Mother, tomorrow, pickup 9:30 for a 10:30 appointment, at the doctor's
    hospital, with her prescription."""
    svc = world.service(service)
    data: dict[str, Any] = {
        "serviceId": str(svc.pk),
        "memberId": world.mother["id"],
        "addressId": world.address["id"],
        "pickupAt": tomorrow_at(9, 30).isoformat(),
        "documentIds": [world.prescription["id"]],
        "notes": "Needs a wheelchair at the gate",
    }
    if svc.visit_type == "HOSPITAL_VISIT":
        data |= {
            "appointmentAt": tomorrow_at(10, 30).isoformat(),
            "hospitalId": str(world.hospital.pk),
            "doctorId": str(world.doctor.pk),
        }
    return data | change


def book(api: Api, token: str, data: dict[str, Any], key: str | None = None) -> Any:
    return api.post("/patient/bookings", data, token, HTTP_IDEMPOTENCY_KEY=key or uuid.uuid4().hex)
