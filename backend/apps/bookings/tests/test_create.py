"""Creating a booking (PHASES 5.3, 5.4, 5.6): snapshots, the server's checks, one booking per
double tap, the patient's lists, unpaid bookings expiring."""

import datetime as dt
import uuid

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.app_config.models import AppSetting
from apps.app_config.selectors import CACHE_KEY
from apps.bookings.models import Booking, BookingStatus
from apps.bookings.services import MAX_UNPAID, SYSTEM, expire_unpaid, transition
from apps.bookings.tests.support import body, book, make_world, tomorrow_at
from apps.documents.models import PatientDocument
from apps.patients.tests.support import OTHER, OUTSIDE, add_document, address_body, patient

pytestmark = pytest.mark.django_db


@pytest.fixture
def world(api):
    return make_world(api)


def test_doctor_visit_for_mother_tomorrow(api, world):
    """Exit criterion 1: Mother, tomorrow, a nearby hospital and doctor, her prescription."""
    resp = book(api, world.token, body(world))
    assert resp.status_code == 200, resp.json()
    data = resp.json()
    assert data["status"] == "PENDING_PAYMENT"
    assert data["code"].startswith("WW-1")
    assert data["service"] == {
        "name": "Doctor visit companion",
        "nameHi": "डॉक्टर विज़िट साथी",
        "nameOr": "ଡାକ୍ତର ଦେଖାଇବା ସାଥୀ",
        "partnerType": "COMPANION",
        "visitType": "HOSPITAL_VISIT",
        "durationMin": 240,
        "docsRequired": False,
        "pricePaise": 50000,
        "bookingFeePaise": 10000,
        "balancePaise": 40000,
    }
    assert data["member"]["fullName"] == "Sabitri Gouda"
    assert data["member"]["relation"] == "MOTHER"
    assert data["member"]["age"] >= 72
    assert data["memberName"] == "Sabitri Gouda"
    assert data["address"]["line1"] == "Plot 12, Saheed Nagar, Bhubaneswar 751007"
    assert data["address"]["lat"] == "20.296100"
    assert data["hospitalName"] == world.hospital.name
    assert data["doctorName"] == world.doctor.full_name
    assert dt.datetime.fromisoformat(data["pickupAt"]) == tomorrow_at(9, 30)
    assert dt.datetime.fromisoformat(data["appointmentAt"]) == tomorrow_at(10, 30)
    assert data["documents"] == [
        {
            "id": data["documents"][0]["id"],
            "documentId": world.prescription["id"],
            "type": "PRESCRIPTION",
            "title": "Dr. Rath BP tablets",
            "removed": False,
        }
    ]
    assert data["notes"] == "Needs a wheelchair at the gate"
    assert [(t["status"], t["event"]) for t in data["timeline"]] == [("PENDING_PAYMENT", "CREATE")]
    assert dt.datetime.fromisoformat(data["payBy"]) > timezone.now() + dt.timedelta(minutes=29)

    booking = Booking.objects.get()
    start, end = booking.busy_window.lower, booking.busy_window.upper
    assert start == tomorrow_at(8, 30)  # pickup - 1 h
    assert end == tomorrow_at(9, 30) + dt.timedelta(minutes=240 + 30)


def test_snapshots_do_not_follow_later_changes(api, world):
    book(api, world.token, body(world))
    service = world.service("Doctor visit companion")
    service.price_paise = 90000
    service.save()
    api.put(
        f"/patient/members/{world.mother['id']}",
        {**api.get(f"/patient/members/{world.mother['id']}", world.token).json()["member"],
         "fullName": "Sabitri Devi", "consent": True},
        world.token,
    )  # fmt: skip
    booking = Booking.objects.get()
    assert booking.price_snapshot["price_paise"] == 50000
    assert booking.member_snapshot["full_name"] == "Sabitri Gouda"


def test_a_double_tap_books_once(api, world):
    """Exit criterion 4: the same Idempotency-Key returns the same booking."""
    key = uuid.uuid4().hex
    first = book(api, world.token, body(world), key)
    second = book(api, world.token, body(world), key)
    assert first.status_code == second.status_code == 200
    assert first.json()["id"] == second.json()["id"]
    assert Booking.objects.count() == 1
    # another person's key is theirs: no clash
    other = patient(api, OTHER, "other-device")
    assert book(api, other, body(world), key).status_code == 404  # Mother isn't theirs
    # a new Review screen (new key) is a new booking
    assert book(api, world.token, body(world)).json()["id"] != first.json()["id"]


def test_the_key_is_required(api, world):
    resp = api.post("/patient/bookings", body(world), world.token)
    assert resp.status_code == 422
    short = api.post("/patient/bookings", body(world), world.token, HTTP_IDEMPOTENCY_KEY="abc")
    assert short.status_code == 422


def test_a_prescription_is_needed_for_an_injection(api, world):
    """Exit criterion 3."""
    injection = world.service("Injection visit")
    no_docs = book(api, world.token, body(world, "Injection visit", documentIds=[]))
    assert no_docs.status_code == 422
    assert no_docs.json()["error"]["code"] == "PRESCRIPTION_REQUIRED"
    lab_only = book(
        api, world.token, body(world, "Injection visit", documentIds=[world.lab_report["id"]])
    )
    assert lab_only.json()["error"]["code"] == "PRESCRIPTION_REQUIRED"
    ok = book(api, world.token, body(world, "Injection visit"))
    assert ok.status_code == 200, ok.json()
    assert ok.json()["service"]["docsRequired"] is True
    assert ok.json()["hospitalName"] == ""
    assert Booking.objects.get().service_id == injection.pk


def test_a_time_inside_the_minimum_notice_is_refused(api, world):
    """Exit criterion 2 (server side)."""
    soon = timezone.now() + dt.timedelta(hours=1)
    soon = soon.replace(minute=0, second=0, microsecond=0)
    resp = book(api, world.token, body(world, pickupAt=soon.isoformat(), appointmentAt=None))
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "TIME_NOT_AVAILABLE"
    assert resp.json()["error"]["details"] == {"reason": "TOO_SOON"}
    odd = book(api, world.token, body(world, pickupAt=tomorrow_at(9, 10).isoformat()))
    assert odd.json()["error"]["details"] == {"reason": "NOT_ON_STEP"}
    naive = book(api, world.token, body(world, pickupAt="2030-01-01T09:00:00"))
    assert naive.status_code == 422


def test_other_peoples_things_are_not_found(api, world):
    other = patient(api, OTHER, "other-device")
    their_me = api.get("/patient/members", other).json()[0]
    their_address = api.post("/patient/addresses", address_body(their_me["id"]), other).json()
    their_doc = add_document(api, other, their_me["id"], kind="PRESCRIPTION").json()
    for change in (
        {"memberId": their_me["id"]},
        {"addressId": their_address["id"]},
        {"documentIds": [their_doc["id"]]},
        {"serviceId": str(uuid.uuid4())},
        {"hospitalId": str(uuid.uuid4()), "doctorId": None},
    ):
        resp = book(api, world.token, body(world, **change))
        assert resp.status_code == 404, (change, resp.json())
    assert Booking.objects.count() == 0


def test_address_and_place_rules(api, world):
    far = api.post(
        "/patient/addresses", address_body(world.mother["id"], label="Bengaluru", **OUTSIDE),
        world.token,
    ).json()  # fmt: skip
    resp = book(api, world.token, body(world, addressId=far["id"]))
    assert resp.json()["error"]["code"] == "OUTSIDE_SERVICE_AREA"

    def code_and_field(**change):
        error = book(api, world.token, body(world, **change)).json()["error"]
        return error["code"], error["details"].get("field")

    assert code_and_field(hospitalId=None, doctorId=None) == ("INVALID_BOOKING", "hospitalId")
    assert code_and_field(hospitalText="Kalinga Hospital") == ("INVALID_BOOKING", "hospitalText")
    assert code_and_field(hospitalId=None, hospitalText="Kalinga Hospital, Chandrasekharpur") == (
        "INVALID_BOOKING",
        "doctorId",
    )  # a typed-in hospital has no listed doctor
    other_hospital = world.hospital.__class__.objects.exclude(
        pk__in=world.doctor.hospitals.values("pk")
    ).first()
    assert code_and_field(hospitalId=str(other_hospital.pk)) == ("INVALID_BOOKING", "doctorId")
    assert code_and_field(appointmentAt=tomorrow_at(9, 0).isoformat()) == (
        "INVALID_BOOKING",
        "appointmentAt",
    )
    nurse = body(world, "Wound dressing", hospitalId=str(world.hospital.pk))
    assert book(api, world.token, nurse).json()["error"]["details"]["field"] == "hospitalId"
    lab_of_me = add_document(api, world.token, world.me["id"]).json()
    assert code_and_field(documentIds=[lab_of_me["id"]]) == ("INVALID_BOOKING", "documentIds")

    typed = book(
        api,
        world.token,
        body(world, hospitalId=None, doctorId=None, hospitalText="Kalinga Hospital, CS Pur"),
    )
    assert typed.status_code == 200, typed.json()
    assert typed.json()["hospitalName"] == "Kalinga Hospital, CS Pur"
    assert typed.json()["hospitalId"] is None
    errand = book(api, world.token, body(world, "Medicine pickup", documentIds=[]))
    assert errand.status_code == 200, errand.json()
    world.hospital.is_active = False
    world.hospital.save()
    assert book(api, world.token, body(world)).status_code == 404


def test_unpaid_bookings_are_limited_and_expire(api, world):
    for hour in range(MAX_UNPAID):
        resp = book(api, world.token, body(world, pickupAt=tomorrow_at(8 + hour).isoformat(),
                                             appointmentAt=None))  # fmt: skip
        assert resp.status_code == 200, resp.json()
    too_many = book(
        api, world.token, body(world, pickupAt=tomorrow_at(15).isoformat(), appointmentAt=None)
    )
    assert too_many.status_code == 429
    assert too_many.json()["error"]["code"] == "TOO_MANY_UNPAID"

    assert expire_unpaid() == 0  # not yet
    later = timezone.now() + dt.timedelta(minutes=31)
    assert expire_unpaid(now=later) == MAX_UNPAID
    assert expire_unpaid(now=later) == 0  # safe to run twice
    assert set(Booking.objects.values_list("status", flat=True)) == {"EXPIRED"}
    past = api.get("/patient/bookings?bucket=past", world.token).json()
    assert past["count"] == MAX_UNPAID
    assert past["items"][0]["payBy"] is None
    event = Booking.objects.get(pk=Booking.objects.values("pk")[:1]).events.order_by("server_ts")
    assert [(e.event, e.actor_type) for e in event][-1] == ("EXPIRE", "SYSTEM")


def test_payment_time_is_the_setting(api, world):
    AppSetting.objects.create(key="payment_expiry_min", value=10)
    cache.delete(CACHE_KEY)
    book(api, world.token, body(world))
    assert expire_unpaid(now=timezone.now() + dt.timedelta(minutes=11)) == 1


def test_my_bookings(api, world):
    first = book(api, world.token, body(world)).json()
    second = book(api, world.token, body(world, pickupAt=tomorrow_at(8).isoformat(),
                                         appointmentAt=None)).json()  # fmt: skip
    upcoming = api.get("/patient/bookings?bucket=upcoming", world.token).json()
    assert [b["id"] for b in upcoming["items"]] == [second["id"], first["id"]]  # soonest first
    row = upcoming["items"][1]
    assert row["code"] == first["code"]
    assert row["service"]["bookingFeePaise"] == 10000
    assert row["memberName"] == "Sabitri Gouda"
    assert "address" not in row
    assert api.get("/patient/bookings", world.token).json()["count"] == 2  # upcoming by default
    assert api.get("/patient/bookings?bucket=ongoing", world.token).json()["count"] == 0
    assert api.get("/patient/bookings?bucket=everything", world.token).status_code == 422

    booking = Booking.objects.get(pk=first["id"])
    transition(booking, "PAY", SYSTEM)
    transition(booking, "OFFER", SYSTEM)
    transition(booking, "ACCEPT", SYSTEM)
    transition(booking, "START", SYSTEM)
    assert api.get("/patient/bookings?bucket=ongoing", world.token).json()["count"] == 1
    detail = api.get(f"/patient/bookings/{first['id']}", world.token).json()
    assert [t["status"] for t in detail["timeline"]] == [
        "PENDING_PAYMENT", "NEW", "OFFERED", "ACCEPTED", "IN_PROGRESS",
    ]  # fmt: skip

    other = patient(api, OTHER, "other-device")
    assert api.get(f"/patient/bookings/{first['id']}", other).status_code == 404
    assert api.get("/patient/bookings", other).json()["count"] == 0
    assert api.get("/patient/bookings/not-a-uuid", world.token).status_code == 404


def test_member_profile_lists_their_bookings(api, world):
    later = book(api, world.token, body(world)).json()
    sooner = book(api, world.token, body(world, pickupAt=tomorrow_at(8).isoformat(),
                                         appointmentAt=None)).json()  # fmt: skip
    mine = book(api, world.token, body(world, "Wound dressing", memberId=world.me["id"],
                                       documentIds=[])).json()  # fmt: skip
    hers = api.get(f"/patient/members/{world.mother['id']}", world.token).json()["bookings"]
    assert [b["id"] for b in hers] == [sooner["id"], later["id"]]
    transition(Booking.objects.get(pk=sooner["id"]), "EXPIRE", SYSTEM)
    hers = api.get(f"/patient/members/{world.mother['id']}", world.token).json()["bookings"]
    assert [b["id"] for b in hers] == [later["id"], sooner["id"]]  # unfinished first
    me = api.get(f"/patient/members/{world.me['id']}", world.token).json()["bookings"]
    assert [b["id"] for b in me] == [mine["id"]]


def test_a_deleted_document_shows_as_removed(api, world):
    booking = book(api, world.token, body(world)).json()
    deleted = api.delete(f"/patient/documents/{world.prescription['id']}", world.token)
    assert deleted.status_code == 200
    detail = api.get(f"/patient/bookings/{booking['id']}", world.token).json()
    assert detail["documents"] == [
        {
            "id": detail["documents"][0]["id"],
            "documentId": None,
            "type": "PRESCRIPTION",
            "title": "",
            "removed": True,
        }
    ]
    assert PatientDocument.objects.filter(pk=world.prescription["id"]).exists()


def test_removing_a_member_and_deleting_the_account(api, world):
    booking = Booking.objects.get(pk=book(api, world.token, body(world)).json()["id"])
    transition(booking, "PAY", SYSTEM)  # now a paid, unfinished booking
    removed = api.delete(f"/patient/members/{world.mother['id']}", world.token)
    assert removed.status_code == 409
    assert removed.json()["error"]["code"] == "MEMBER_HAS_BOOKINGS"
    deleted = api.post("/patient/me/delete-request", token=world.token)
    assert deleted.status_code == 409
    assert deleted.json()["error"]["code"] == "ACTIVE_BOOKINGS"

    booking.refresh_from_db()
    transition(booking, "CANCEL", SYSTEM)
    unpaid = book(api, world.token, body(world, pickupAt=tomorrow_at(12).isoformat(),
                                         appointmentAt=None)).json()  # fmt: skip
    assert api.delete(f"/patient/members/{world.mother['id']}", world.token).status_code == 200
    assert Booking.objects.get(pk=unpaid["id"]).status == BookingStatus.EXPIRED


def test_erasing_the_account_keeps_bookings_without_personal_details(api, world):
    from apps.patients.models import AccountDeletion
    from apps.patients.services import process_due_deletions

    booking = Booking.objects.get(pk=book(api, world.token, body(world)).json()["id"])
    transition(booking, "PAY", SYSTEM)
    transition(booking, "CANCEL", SYSTEM)
    pending = book(api, world.token, body(world, pickupAt=tomorrow_at(12).isoformat(),
                                          appointmentAt=None)).json()  # fmt: skip
    assert api.post("/patient/me/delete-request", token=world.token).status_code == 200
    AccountDeletion.objects.update(due_at=timezone.now())
    assert process_due_deletions() == 1
    kept = Booking.objects.get(pk=booking.pk)
    assert kept.member_snapshot == {"erased": True}
    assert kept.address_snapshot == {"erased": True}
    assert kept.notes == ""
    assert kept.member_id is None and kept.address_id is None
    assert kept.price_snapshot["booking_fee_paise"] == 10000  # payment records stay
    assert kept.documents.get().document_id is None
    assert Booking.objects.get(pk=pending["id"]).status == BookingStatus.EXPIRED


def test_booked_things_cannot_be_deleted(api, world, staff_roles):
    from conftest import staff_token

    book(api, world.token, body(world))
    token = staff_token(api, staff_roles)
    service = world.service("Doctor visit companion")
    for path in (
        f"/admin/services/{service.pk}",
        f"/admin/hospitals/{world.hospital.pk}",
        f"/admin/doctors/{world.doctor.pk}",
    ):
        resp = api.delete(path, token)
        assert resp.status_code == 409, path
        assert resp.json()["error"]["code"] == "IN_USE"


def test_now_is_now():
    assert tomorrow_at(9) > timezone.now()
