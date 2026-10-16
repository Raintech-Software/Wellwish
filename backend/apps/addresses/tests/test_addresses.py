"""Addresses per family member (PHASES 4.2, 4.4)."""

import pytest

from apps.addresses.models import Address
from apps.addresses.services import MAX_PER_MEMBER
from apps.patients.tests.support import (
    OTHER,
    OUTSIDE,
    add_member,
    address_body,
    patient,
    service_area,
)

pytestmark = pytest.mark.django_db


def test_address_for_mother_inside_the_service_area(api):
    service_area()
    token = patient(api)
    mother = add_member(api, token)
    resp = api.post("/patient/addresses", address_body(mother["id"]), token)
    assert resp.status_code == 200, resp.json()
    address = resp.json()
    assert address["memberId"] == mother["id"]
    assert address["inServiceArea"] is True
    assert address["lat"] == "20.296100"  # exact decimals travel as text

    # only Mother's addresses when asked for hers
    me = api.get("/patient/members", token).json()[0]
    api.post("/patient/addresses", address_body(me["id"], label="Office"), token)
    mine = api.get(f"/patient/addresses?memberId={me['id']}", token).json()
    hers = api.get(f"/patient/addresses?memberId={mother['id']}", token).json()
    assert [a["label"] for a in mine] == ["Office"]
    assert [a["label"] for a in hers] == ["Home"]
    assert len(api.get("/patient/addresses", token).json()) == 2
    detail = api.get(f"/patient/members/{mother['id']}", token).json()
    assert detail["member"]["addressCount"] == 1
    assert [a["id"] for a in detail["addresses"]] == [address["id"]]


def test_outside_the_service_area_is_saved_with_a_warning(api):
    service_area()
    token = patient(api)
    mother = add_member(api, token)
    resp = api.post("/patient/addresses", address_body(mother["id"], **OUTSIDE), token)
    assert resp.status_code == 200
    assert resp.json()["inServiceArea"] is False


def test_edit_and_remove_an_address(api):
    service_area()
    token = patient(api)
    mother = add_member(api, token)
    address = api.post("/patient/addresses", address_body(mother["id"]), token).json()
    resp = api.put(
        f"/patient/addresses/{address['id']}",
        address_body(mother["id"], label="Old house", **OUTSIDE),
        token,
    )
    assert resp.status_code == 200
    assert resp.json()["label"] == "Old house" and resp.json()["inServiceArea"] is False
    assert api.delete(f"/patient/addresses/{address['id']}", token).status_code == 200
    assert api.get("/patient/addresses", token).json() == []
    assert Address.objects.get(pk=address["id"]).is_active is False  # hidden, not deleted


@pytest.mark.parametrize(
    ("change", "status"),
    [
        ({"lat": "95"}, 422),
        ({"lng": "abc"}, 422),
        ({"line1": "x"}, 422),
        ({"label": ""}, 422),
        ({"memberId": "00000000-0000-0000-0000-000000000000"}, 404),
    ],
)
def test_bad_addresses_are_refused(api, change, status):
    token = patient(api)
    mother = add_member(api, token)
    resp = api.post("/patient/addresses", address_body(mother["id"], **change), token)
    assert resp.status_code == status, resp.json()


def test_address_limit_per_member(api):
    token = patient(api)
    mother = add_member(api, token)
    for i in range(MAX_PER_MEMBER):
        api.post("/patient/addresses", address_body(mother["id"], label=f"Place {i}"), token)
    resp = api.post("/patient/addresses", address_body(mother["id"]), token)
    assert resp.json()["error"]["code"] == "TOO_MANY_ADDRESSES"


def test_removed_members_addresses_are_hidden(api):
    token = patient(api)
    mother = add_member(api, token)
    address = api.post("/patient/addresses", address_body(mother["id"]), token).json()
    api.delete(f"/patient/members/{mother['id']}", token)
    assert api.get("/patient/addresses", token).json() == []
    path = f"/patient/addresses/{address['id']}"
    assert api.put(path, address_body(mother["id"]), token).status_code == 404


def test_other_patients_get_404_for_your_addresses(api):
    """IDOR (4.4): no reading, editing, removing or adding to someone else's member."""
    mine = patient(api)
    mother = add_member(api, mine)
    address = api.post("/patient/addresses", address_body(mother["id"]), mine).json()
    theirs = patient(api, OTHER, device_id="patient-device-2")
    their_self = api.get("/patient/members", theirs).json()[0]
    path = f"/patient/addresses/{address['id']}"
    assert api.get(f"/patient/addresses?memberId={mother['id']}", theirs).json() == []
    assert api.put(path, address_body(their_self["id"]), theirs).status_code == 404
    assert api.delete(path, theirs).status_code == 404
    assert api.post("/patient/addresses", address_body(mother["id"]), theirs).status_code == 404
    assert Address.objects.get(pk=address["id"]).is_active is True
    # and an address can't be moved onto someone else's member
    resp = api.put(path, address_body(their_self["id"]), mine)
    assert resp.status_code == 404


def test_moving_an_address_respects_the_other_members_limit(api):
    token = patient(api)
    mother = add_member(api, token)
    father = add_member(api, token, relation="FATHER", fullName="Bikram Gouda", gender="MALE")
    for i in range(MAX_PER_MEMBER):
        api.post("/patient/addresses", address_body(father["id"], label=f"Place {i}"), token)
    address = api.post("/patient/addresses", address_body(mother["id"]), token).json()
    resp = api.put(f"/patient/addresses/{address['id']}", address_body(father["id"]), token)
    assert resp.json()["error"]["code"] == "TOO_MANY_ADDRESSES"
