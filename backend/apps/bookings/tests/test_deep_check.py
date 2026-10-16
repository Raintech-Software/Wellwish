"""Phase 5 deep check: fixes found by the independent reviews."""

import datetime as dt

import pytest
from django.core.cache import cache
from django.utils import timezone

from apps.accounts.models import User
from apps.addresses.models import Address
from apps.app_config.models import AppSetting, ServiceArea
from apps.app_config.selectors import CACHE_KEY
from apps.bookings import services
from apps.bookings.models import Booking, BookingStatus
from apps.bookings.services import MAX_UNPAID, SYSTEM, BookingInput, create_booking, transition
from apps.bookings.tests.support import body, book, make_world, tomorrow_at
from apps.hospitals.models import Doctor
from apps.patients.models import AccountDeletion
from apps.patients.services import process_due_deletions
from apps.patients.tests.support import OWNER
from conftest import staff_token

pytestmark = pytest.mark.django_db


@pytest.fixture
def world(api):
    return make_world(api)


def setting(key, value):
    AppSetting.objects.update_or_create(key=key, defaults={"value": value})
    cache.delete(CACHE_KEY)


def as_input(world, **change) -> BookingInput:
    svc = world.service("Doctor visit companion")
    data = {
        "service_id": str(svc.pk),
        "member_id": world.mother["id"],
        "address_id": world.address["id"],
        "pickup_at": tomorrow_at(9, 30),
        "appointment_at": tomorrow_at(10, 30),
        "hospital_id": str(world.hospital.pk),
        "doctor_id": str(world.doctor.pk),
        "document_ids": [world.prescription["id"]],
        "notes": "",
    }
    return BookingInput(**(data | change))


def test_a_retry_finds_its_booking_even_when_the_time_is_now_full(api, world):
    """The key is looked up after the account lock, before the checks that the first booking
    itself would now fail ("full", "too many unpaid")."""
    setting("max_per_slot", 1)
    user_id = str(User.objects.get(phone=OWNER).pk)
    first, created = create_booking(user_id=user_id, data=as_input(world), idempotency_key="k" * 16)
    assert created
    again, created = create_booking(user_id=user_id, data=as_input(world), idempotency_key="k" * 16)
    assert (again.pk, created) == (first.pk, False)


def test_a_retry_of_the_fifth_unpaid_booking(api, world):
    for hour in range(MAX_UNPAID - 1):
        book(api, world.token, body(world, pickupAt=tomorrow_at(12 + hour).isoformat(),
                                    appointmentAt=None))  # fmt: skip
    fifth = book(api, world.token, body(world), "fifth-key-0001")
    retry = book(api, world.token, body(world), "fifth-key-0001")
    assert retry.status_code == 200, retry.json()
    assert retry.json()["id"] == fifth.json()["id"]


def test_a_key_sent_again_with_other_details_is_refused(api, world):
    book(api, world.token, body(world), "same-key-0001")
    other = book(api, world.token, body(world, notes="Different"), "same-key-0001")
    assert other.status_code == 422
    assert other.json()["error"]["code"] == "IDEMPOTENCY_KEY_REUSED"
    assert Booking.objects.count() == 1


def test_the_appointment_must_fall_inside_the_partners_time(api, world):
    late = book(api, world.token, body(world, pickupAt=tomorrow_at(7).isoformat(),
                                        appointmentAt=tomorrow_at(20).isoformat()))  # fmt: skip
    assert late.status_code == 422
    assert late.json()["error"]["details"] == {"field": "appointmentAt"}
    ok = book(api, world.token, body(world, pickupAt=tomorrow_at(7).isoformat(),
                                      appointmentAt=tomorrow_at(11).isoformat()))  # fmt: skip
    assert ok.status_code == 200, ok.json()  # 4 h service: within it


def test_nearby_with_a_location_hides_inactive_doctors_and_finds_the_city(api, world):
    doctor = Doctor.objects.get(pk=world.doctor.pk)
    doctor.is_active = False
    doctor.save()
    near = "lat=20.296100&lng=85.824500"
    found = api.get(f"/patient/hospitals/nearby?{near}&q={doctor.full_name[4:]}", world.token)
    assert found.json()["items"] == []
    city = api.get(f"/patient/hospitals/nearby?{near}&q=bhubaneswar", world.token).json()
    assert len(city["items"]) == 5


def test_asking_to_delete_expires_unpaid_bookings(api, world):
    unpaid = book(api, world.token, body(world)).json()
    assert api.post("/patient/me/delete-request", token=world.token).status_code == 200
    assert Booking.objects.get(pk=unpaid["id"]).status == BookingStatus.EXPIRED


def test_no_erase_while_a_paid_booking_is_open(api, world):
    booking = Booking.objects.get(pk=book(api, world.token, body(world)).json()["id"])
    assert api.post("/patient/me/delete-request", token=world.token).status_code == 200
    # a payment that arrived late (Phase 6 must refuse or refund it; this is the safety net)
    Booking.objects.filter(pk=booking.pk).update(status=BookingStatus.NEW)
    AccountDeletion.objects.update(due_at=timezone.now())
    assert process_due_deletions() == 0
    booking.refresh_from_db()
    assert booking.member_snapshot["full_name"] == "Sabitri Gouda"
    assert AccountDeletion.objects.get().status == AccountDeletion.Status.PENDING


def test_an_address_found_outside_is_stored_as_outside(api, world):
    ServiceArea.objects.update(is_active=False)
    resp = book(api, world.token, body(world))
    assert resp.json()["error"]["code"] == "OUTSIDE_SERVICE_AREA"
    assert Address.objects.get(pk=world.address["id"]).in_service_area is False
    listed = api.get(f"/patient/members/{world.mother['id']}", world.token).json()
    assert listed["addresses"][0]["inServiceArea"] is False


def test_the_address_snapshot_does_not_follow_edits(api, world):
    book(api, world.token, body(world))
    api.put(
        f"/patient/addresses/{world.address['id']}",
        {"memberId": world.mother["id"], "label": "Old house", "line1": "Somewhere else 12",
         "landmark": "", "notes": "", "lat": "20.296100", "lng": "85.824500"},
        world.token,
    )  # fmt: skip
    assert Booking.objects.get().address_snapshot["label"] == "Home"


def test_attachments_have_their_own_id(api, world):
    data = book(api, world.token, body(world)).json()
    attachment = data["documents"][0]
    assert attachment["id"] and attachment["id"] != attachment["documentId"]


# --- Admin list ---


@pytest.fixture
def admin(api, staff_roles):
    return staff_token(api, staff_roles)


def ids(api, token, query=""):
    resp = api.get(f"/admin/bookings?{query}", token)
    assert resp.status_code == 200, resp.json()
    return [r["id"] for r in resp.json()["items"]]


def test_admin_list_shows_upcoming_first_and_past_apart(api, world, admin):
    soon = Booking.objects.get(pk=book(api, world.token, body(world)).json()["id"])
    later = body(world, pickupAt=tomorrow_at(12).isoformat(), appointmentAt=None)
    old = Booking.objects.get(pk=book(api, world.token, later).json()["id"])
    for b in (soon, old):
        transition(b, "PAY", SYSTEM)
    # a finished job last week and a NEW one whose time has passed (still to sort out)
    week_ago = timezone.now() - dt.timedelta(days=7)
    Booking.objects.filter(pk=old.pk).update(status=BookingStatus.COMPLETED, pickup_at=week_ago)
    third = body(world, pickupAt=tomorrow_at(15).isoformat(), appointmentAt=None)
    overdue = Booking.objects.get(pk=book(api, world.token, third).json()["id"])
    transition(overdue, "PAY", SYSTEM)
    Booking.objects.filter(pk=overdue.pk).update(pickup_at=week_ago + dt.timedelta(hours=1))
    assert ids(api, admin) == [str(overdue.pk), str(soon.pk)]
    assert ids(api, admin, "when=past") == [str(overdue.pk), str(old.pk)]  # latest first


def test_admin_search_by_code_finds_unpaid_and_phones_of_both(api, world, admin):
    unpaid = book(api, world.token, body(world)).json()
    assert ids(api, admin) == []  # unpaid: hidden by default
    assert ids(api, admin, f"q={unpaid['code']}") == [unpaid["id"]]
    assert ids(api, admin, f"q={unpaid['code'][3:]}") == [unpaid["id"]]
    paid = Booking.objects.get(pk=unpaid["id"])
    transition(paid, "PAY", SYSTEM)
    assert ids(api, admin, "q=09876543210") == [unpaid["id"]]  # the member's phone, 0-prefixed
    assert ids(api, admin, "q=90000 00001") == [unpaid["id"]]  # the account's phone
    assert ids(api, admin, "q=WW-99999") == []


def test_admin_detail_hides_notes_from_support(api, world, admin, staff_roles):
    data = book(api, world.token, body(world)).json()
    transition(Booking.objects.get(pk=data["id"]), "PAY", SYSTEM)
    full = api.get(f"/admin/bookings/{data['id']}", admin).json()
    assert (full["notes"], full["notesVisible"]) == ("Needs a wheelchair at the gate", True)
    support = staff_token(api, staff_roles, "SUPPORT")
    limited = api.get(f"/admin/bookings/{data['id']}", support).json()
    assert (limited["notes"], limited["notesVisible"]) == ("", False)


def test_patient_page_bookings_need_bookings_view(api, world, staff_roles):
    data = book(api, world.token, body(world)).json()
    user_id = Booking.objects.get(pk=data["id"]).booked_by_id
    finance = staff_token(api, staff_roles, "FINANCE")  # patients.view, no bookings.view
    page = api.get(f"/admin/patients/{user_id}", finance).json()
    assert (page["bookingsVisible"], page["bookings"]) == (False, [])


def test_erased_accounts_show_as_deleted(api, world, admin):
    booking = Booking.objects.get(pk=book(api, world.token, body(world)).json()["id"])
    transition(booking, "PAY", SYSTEM)
    transition(booking, "CANCEL", SYSTEM)
    api.post("/patient/me/delete-request", token=world.token)
    AccountDeletion.objects.update(due_at=timezone.now())
    assert process_due_deletions() == 1
    row = api.get("/admin/bookings?status=CANCELLED", admin).json()["items"][0]
    assert (row["patientDeleted"], row["patientPhone"]) == (True, "")
    assert ids(api, admin, "status=CANCELLED&q=0000") == []  # not found by a random number


def test_the_request_fingerprint(world):
    assert services.request_hash(as_input(world)) == services.request_hash(as_input(world))
    assert services.request_hash(as_input(world)) != services.request_hash(
        as_input(world, notes="x")
    )
    # the same instant written in another time zone is the same request
    ist = as_input(world, pickup_at=tomorrow_at(9, 30).astimezone(dt.UTC))
    assert services.request_hash(ist) == services.request_hash(as_input(world))
