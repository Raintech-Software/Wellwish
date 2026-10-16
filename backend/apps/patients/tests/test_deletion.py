"""Account deletion (PHASES 4.5, §12): logged out at once, data removed after the grace period,
logging in again cancels, payment records kept (Phase 6), admin view."""

from datetime import timedelta

import pytest
from django.utils import timezone

from apps.accounts.models import Consent, Device, Session, User
from apps.addresses.models import Address
from apps.documents.models import PatientDocument
from apps.files.storage import get_storage
from apps.notifications.models import Notification
from apps.patients.models import AccountDeletion, Member, PatientProfile
from apps.patients.services import process_due_deletions
from apps.patients.tests.support import (
    OWNER,
    add_document,
    add_member,
    address_body,
    patient,
)
from conftest import staff_token

pytestmark = pytest.mark.django_db


def _family_with_data(api):
    token = patient(api)
    api.put(
        "/patient/me/device",
        {"deviceId": "patient-device-1", "platform": "android", "appVersion": "0.1.0"},
        token,
    )
    needed = api.get("/patient/me", token).json()["consentsNeeded"]
    assert api.post("/patient/me/consents", {"items": needed}, token).status_code == 200
    mother = add_member(api, token)
    api.post("/patient/addresses", address_body(mother["id"]), token)
    add_document(api, token, mother["id"])
    user = User.objects.get(phone=OWNER)
    Notification.objects.create(user=user, app="patient", type="X", title="t", body="b")
    return token, mother, user


def test_request_logs_out_at_once_and_keeps_data_during_grace(api):
    token, _, user = _family_with_data(api)
    resp = api.post("/patient/me/delete-request", token=token)
    assert resp.status_code == 200
    due = resp.json()["dueAt"]
    assert due
    assert api.get("/patient/members", token).status_code == 401  # logged out everywhere
    assert not Session.objects.filter(user=user, app="patient", revoked_at__isnull=True).exists()
    deletion = AccountDeletion.objects.get()
    assert deletion.status == "PENDING" and deletion.phone_last4 == OWNER[-4:]
    assert process_due_deletions() == 0  # not due yet
    assert Member.objects.filter(owner=user).count() == 2


def test_logging_in_again_cancels_the_request(api):
    token, _, _ = _family_with_data(api)
    api.post("/patient/me/delete-request", token=token)
    token = patient(api)
    assert AccountDeletion.objects.get().status == "CANCELLED"
    assert len(api.get("/patient/members", token).json()) == 2  # nothing was lost
    assert process_due_deletions(now=timezone.now() + timedelta(days=30)) == 0


def test_after_the_grace_period_the_personal_data_is_erased(
    api, django_capture_on_commit_callbacks
):
    token, _, user = _family_with_data(api)
    key = PatientDocument.objects.get().file_key or ""
    api.post("/patient/me/delete-request", token=token)
    with django_capture_on_commit_callbacks(execute=True):
        assert process_due_deletions(now=timezone.now() + timedelta(days=8)) == 1

    assert not PatientProfile.objects.filter(user=user).exists()
    assert not Member.objects.filter(owner=user).exists()
    assert not Address.objects.filter(user=user).exists()
    assert not PatientDocument.objects.filter(owner=user).exists()
    assert get_storage().size(key) is None
    assert not Notification.objects.filter(user=user, app="patient").exists()
    assert not Device.objects.filter(user=user, app="patient").exists()
    user.refresh_from_db()
    assert user.status == "DELETED" and user.phone != OWNER and user.email == ""
    assert Consent.objects.filter(user=user).exists()  # proof of what was accepted stays
    deletion = AccountDeletion.objects.get()
    assert deletion.status == "DONE" and deletion.kept_partner is False

    # the same number can sign up again, as a new empty account
    fresh = patient(api)
    assert [m["relation"] for m in api.get("/patient/members", fresh).json()] == ["SELF"]
    assert User.objects.get(phone=OWNER).pk != user.pk


def test_a_partner_keeps_their_partner_account(api, django_capture_on_commit_callbacks):
    from apps.partners.tests.support import partner_login

    partner_token = partner_login(api)
    api.post("/partner/register/start", {"role": "COMPANION"}, partner_token)
    token, _, user = _family_with_data(api)
    api.post("/patient/me/delete-request", token=token)
    assert api.get("/partner/me", partner_token).status_code == 200  # still logged in there
    with django_capture_on_commit_callbacks(execute=True):
        process_due_deletions(now=timezone.now() + timedelta(days=8))
    user.refresh_from_db()
    assert user.phone == OWNER and user.status == "ACTIVE"
    assert not Member.objects.filter(owner=user).exists()
    assert AccountDeletion.objects.get().kept_partner is True
    assert api.get("/partner/me", partner_token).status_code == 200


def test_admin_sees_deletion_requests(api, staff_roles):
    token, _, _ = _family_with_data(api)
    api.post("/patient/me/delete-request", token=token)
    admin = staff_token(api, staff_roles)
    rows = api.get("/admin/account-deletions", admin).json()
    assert rows["count"] == 1
    assert rows["items"][0]["status"] == "PENDING"
    assert rows["items"][0]["phoneLast4"] == OWNER[-4:]
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/account-deletions", ops).status_code == 403


def test_erase_removes_member_photos_and_every_session(api, django_capture_on_commit_callbacks):
    from apps.files.storage import get_storage
    from apps.patients.tests.support import PNG, put_file

    token = patient(api)
    key = put_file(
        api,
        "/patient/members/photo-upload-url",
        token,
        {"mime": "image/png", "sizeBytes": len(PNG)},
        PNG,
    )
    add_member(api, token, photoKey=key)
    user = User.objects.get(phone=OWNER)
    api.post("/patient/me/delete-request", token=token)
    with django_capture_on_commit_callbacks(execute=True):
        process_due_deletions(now=timezone.now() + timedelta(days=8))
    assert get_storage().size(key) is None
    assert not Session.objects.filter(user=user).exists()
    assert not Device.objects.filter(user=user).exists()


def test_a_partner_app_login_does_not_cancel_the_deletion(api):
    from apps.partners.tests.support import partner_login

    token, _, _ = _family_with_data(api)
    api.post("/patient/me/delete-request", token=token)
    partner_login(api)  # same number, other app
    assert AccountDeletion.objects.get().status == "PENDING"


def test_the_waiting_time_is_an_admin_setting(api):
    from apps.app_config.models import AppSetting

    AppSetting.objects.update_or_create(key="account_deletion_days", defaults={"value": 3})
    token = patient(api)
    before = timezone.now()
    due = api.post("/patient/me/delete-request", token=token).json()["dueAt"]
    deletion = AccountDeletion.objects.get()
    assert timedelta(days=3) <= deletion.due_at - before < timedelta(days=3, minutes=1)
    assert due
    assert api.get("/public/app-config").json()["accountDeletionDays"] == 3
