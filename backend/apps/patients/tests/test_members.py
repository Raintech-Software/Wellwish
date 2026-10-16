"""Family members (PHASES 4.1, 4.4): add, edit, remove, limits, consent, ownership."""

import pytest

from apps.app_config.models import AppSetting
from apps.patients.models import Member, PatientProfile
from apps.patients.tests.support import MOTHER, OTHER, PNG, add_member, patient, put_file

pytestmark = pytest.mark.django_db


def test_add_mother_with_her_details_and_consent(api):
    token = patient(api)
    mother = add_member(api, token)
    assert mother["relation"] == "MOTHER"
    assert mother["fullName"] == "Sabitri Gouda"
    assert mother["phone"] == "+919876543210"  # stored as E.164
    assert mother["age"] >= 72
    assert mother["consentAt"] is not None
    assert mother["isSelf"] is False

    members = api.get("/patient/members", token).json()
    assert [m["relation"] for m in members] == ["SELF", "MOTHER"]  # yourself first
    detail = api.get(f"/patient/members/{mother['id']}", token).json()
    assert detail["member"]["conditions"] == "BP, diabetes"
    assert detail["addresses"] == [] and detail["documents"] == []


@pytest.mark.parametrize(
    ("change", "code"),
    [
        ({"consent": False}, "CONSENT_REQUIRED"),
        ({"relation": "SELF"}, "INVALID_RELATION"),
        ({"phone": "12345"}, "INVALID_PHONE"),
        ({"dob": "2999-01-01"}, "INVALID_DOB"),
        ({"fullName": " a "}, "INVALID_NAME"),
        ({"emergencyName": "Ravi", "emergencyPhone": ""}, "EMERGENCY_INCOMPLETE"),
        ({"mobility": "FLYING"}, "VALIDATION_ERROR"),
        ({"language": "Klingon"}, "VALIDATION_ERROR"),
        ({"ownerId": "x"}, "VALIDATION_ERROR"),
    ],
)
def test_bad_member_details_are_refused(api, change, code):
    token = patient(api)
    resp = api.post("/patient/members", MOTHER | change, token)
    assert resp.status_code in (409, 422), resp.json()
    assert resp.json()["error"]["code"] == code


def test_family_limit_is_a_setting(api):
    token = patient(api)
    AppSetting.objects.update_or_create(key="max_members", defaults={"value": 2})
    add_member(api, token)
    add_member(api, token, relation="FATHER", fullName="Bikram Gouda", gender="MALE")
    resp = api.post("/patient/members", MOTHER | {"relation": "SIBLING"}, token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "TOO_MANY_MEMBERS"


def test_edit_member_and_photo(api):
    token = patient(api)
    mother = add_member(api, token)
    key = put_file(
        api,
        "/patient/members/photo-upload-url",
        token,
        {"mime": "image/png", "sizeBytes": len(PNG)},
        PNG,
    )
    resp = api.put(
        f"/patient/members/{mother['id']}",
        MOTHER | {"photoKey": key, "phone": "", "mobility": "WHEELCHAIR", "consent": False},
        token,
    )
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["photoUrl"] and body["phone"] == "" and body["mobility"] == "WHEELCHAIR"
    assert body["consentAt"] == mother["consentAt"]  # consent given once is kept
    # relation can't turn into SELF
    bad = api.put(f"/patient/members/{mother['id']}", MOTHER | {"relation": "SELF"}, token)
    assert bad.json()["error"]["code"] == "INVALID_RELATION"


def test_editing_yourself_updates_the_profile(api):
    token = patient(api)
    me = api.get("/patient/members", token).json()[0]
    resp = api.put(
        f"/patient/members/{me['id']}",
        MOTHER
        | {
            "relation": "SELF",
            "fullName": "Priyansu Gouda",
            "dob": "1990-05-17",
            "gender": "MALE",
            "consent": False,  # not needed for yourself
        },
        token,
    )
    assert resp.status_code == 200, resp.json()
    profile = PatientProfile.objects.get()
    assert profile.full_name == "Priyansu Gouda" and str(profile.dob) == "1990-05-17"
    other = api.put(f"/patient/members/{me['id']}", MOTHER, token)
    assert other.json()["error"]["code"] == "INVALID_RELATION"


def test_removing_a_member_hides_them_but_keeps_the_row(api):
    token = patient(api)
    mother = add_member(api, token)
    assert api.delete(f"/patient/members/{mother['id']}", token).status_code == 200
    assert [m["relation"] for m in api.get("/patient/members", token).json()] == ["SELF"]
    assert api.get(f"/patient/members/{mother['id']}", token).status_code == 404
    row = Member.objects.get(pk=mother["id"])
    assert row.is_active is False and row.full_name == "Sabitri Gouda"  # history kept
    me = api.get("/patient/members", token).json()[0]
    resp = api.delete(f"/patient/members/{me['id']}", token)
    assert resp.json()["error"]["code"] == "CANT_REMOVE_SELF"


def test_other_patients_get_404_for_your_members(api):
    """IDOR (4.4): another account can't read, edit or remove your members."""
    mine = patient(api)
    mother = add_member(api, mine)
    theirs = patient(api, OTHER, device_id="patient-device-2")
    path = f"/patient/members/{mother['id']}"
    assert api.get(path, theirs).status_code == 404
    assert api.put(path, MOTHER, theirs).status_code == 404
    assert api.delete(path, theirs).status_code == 404
    assert [m["relation"] for m in api.get("/patient/members", theirs).json()] == ["SELF"]
    assert Member.objects.get(pk=mother["id"]).is_active is True


def test_member_photo_must_be_your_own_upload(api):
    mine = patient(api)
    key = put_file(
        api,
        "/patient/members/photo-upload-url",
        mine,
        {"mime": "image/png", "sizeBytes": len(PNG)},
        PNG,
    )
    theirs = patient(api, OTHER, device_id="patient-device-2")
    resp = api.post("/patient/members", MOTHER | {"photoKey": key}, theirs)
    assert resp.json()["error"]["code"] == "FILE_NOT_FOUND"


def test_partner_token_cannot_use_patient_members(api):
    from apps.partners.tests.support import partner_login

    token = partner_login(api)
    assert api.get("/patient/members", token).status_code == 401


def test_one_photo_cannot_be_shared_by_two_members(api):
    """Changing one member's photo deletes the old file: it must not also be another's."""
    token = patient(api)
    key = put_file(
        api,
        "/patient/members/photo-upload-url",
        token,
        {"mime": "image/png", "sizeBytes": len(PNG)},
        PNG,
    )
    add_member(api, token, photoKey=key)
    resp = api.post("/patient/members", MOTHER | {"relation": "FATHER", "photoKey": key}, token)
    assert resp.json()["error"]["code"] == "FILE_ALREADY_USED"


def test_replaced_member_photo_is_deleted(api, django_capture_on_commit_callbacks):
    from apps.files.storage import get_storage

    token = patient(api)
    photo = lambda: put_file(  # noqa: E731
        api,
        "/patient/members/photo-upload-url",
        token,
        {"mime": "image/png", "sizeBytes": len(PNG)},
        PNG,
    )
    first = photo()
    mother = add_member(api, token, photoKey=first)
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.put(f"/patient/members/{mother['id']}", MOTHER | {"photoKey": photo()}, token)
    assert resp.status_code == 200
    assert get_storage().size(first) is None


def test_malformed_ids_are_not_found(api):
    token = patient(api)
    assert api.get("/patient/addresses?memberId=abc", token).status_code == 404
    assert api.get("/patient/documents?memberId=abc", token).status_code == 404
    body = {
        "memberId": "abc",
        "label": "Home",
        "line1": "Plot 12, Saheed Nagar",
        "landmark": "",
        "notes": "",
        "lat": "20.296100",
        "lng": "85.824500",
    }
    assert api.post("/patient/addresses", body, token).status_code == 404
