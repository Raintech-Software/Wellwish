"""Patient profile setup (PHASES 1.6, 1.14 backend): GET/PUT /v1/patient/me."""

import pytest

from apps.patients.models import Member, PatientProfile
from conftest import TEST_NUMBER, otp_login

pytestmark = pytest.mark.django_db

PROFILE = {"fullName": "Priyansu  Gouda", "dob": "1990-05-17", "gender": "MALE", "language": "or"}


def test_new_patient_must_complete_profile(api):
    tokens = otp_login(api)
    me = api.get("/patient/me", token=tokens["accessToken"]).json()
    assert me["phone"] == TEST_NUMBER
    assert me["profileComplete"] is False
    assert me["fullName"] == ""
    assert me["dob"] is None
    assert me["language"] == "en"
    assert me["googleLinked"] is False
    assert me["selfMemberId"]


def test_profile_setup_updates_profile_self_member_and_language(api):
    tokens = otp_login(api)
    resp = api.put("/patient/me", PROFILE, token=tokens["accessToken"])
    assert resp.status_code == 200
    me = resp.json()
    assert me["profileComplete"] is True
    assert me["fullName"] == "Priyansu Gouda"  # extra spaces removed
    assert me["dob"] == "1990-05-17"
    assert me["language"] == "or"

    profile = PatientProfile.objects.get()
    member = Member.objects.get(relation="SELF")
    assert (member.full_name, str(member.dob), member.gender, member.language) == (
        "Priyansu Gouda",
        "1990-05-17",
        "MALE",
        "Odia",  # the word partners use, so the admin can match languages
    )
    assert profile.user.language == "or"
    assert str(member.pk) == me["selfMemberId"]


@pytest.mark.parametrize(
    ("change", "code"),
    [
        ({"dob": "2999-01-01"}, "INVALID_DOB"),
        ({"dob": "1850-01-01"}, "INVALID_DOB"),
        ({"fullName": " a "}, "INVALID_NAME"),
        ({"gender": "UNKNOWN"}, "VALIDATION_ERROR"),
        ({"language": "fr"}, "VALIDATION_ERROR"),
        ({"isAdmin": True}, "VALIDATION_ERROR"),
    ],
)
def test_invalid_profile_is_rejected(api, change, code):
    tokens = otp_login(api)
    resp = api.put("/patient/me", PROFILE | change, token=tokens["accessToken"])
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == code


def test_each_patient_sees_only_their_own_profile(api):
    mine = otp_login(api)
    api.put("/patient/me", PROFILE, token=mine["accessToken"])
    other = otp_login(api, phone="+919000000002")
    me = api.get("/patient/me", token=other["accessToken"]).json()
    assert me["phone"] == "+919000000002"
    assert me["fullName"] == ""
