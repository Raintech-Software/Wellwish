"""Patient documents (PHASES 4.3, 4.4): upload, file under a member, tabs, view, delete,
200 MB quota, ownership."""

import pytest

from apps.documents import services
from apps.documents.models import PatientDocument
from apps.files.storage import get_storage
from apps.patients.tests.support import (
    OTHER,
    PDF,
    PNG,
    add_document,
    add_member,
    patient,
    upload_document,
)

pytestmark = pytest.mark.django_db


def test_two_documents_for_mother_appear_only_under_her(api):
    token = patient(api)
    mother = add_member(api, token)
    me = api.get("/patient/members", token).json()[0]
    first = add_document(api, token, mother["id"], "LAB_REPORT", "Blood test")
    assert first.status_code == 200, first.json()
    second = add_document(api, token, mother["id"], "PRESCRIPTION", "Dr. Rath, BP tablets")
    add_document(api, token, me["id"], "SCAN", "Knee X-ray")

    doc = first.json()
    assert doc["memberName"] == "Sabitri Gouda" and doc["mime"] == "application/pdf"
    assert doc["date"] == "2026-08-12" and doc["sizeBytes"] == len(PDF)

    hers = api.get(f"/patient/documents?memberId={mother['id']}", token).json()
    assert hers["count"] == 2
    assert {d["title"] for d in hers["items"]} == {"Blood test", "Dr. Rath, BP tablets"}
    reports = api.get("/patient/documents?group=reports", token).json()["items"]
    assert {d["title"] for d in reports} == {"Blood test", "Knee X-ray"}
    prescriptions = api.get("/patient/documents?group=prescriptions", token).json()["items"]
    assert [d["id"] for d in prescriptions] == [second.json()["id"]]
    assert api.get("/patient/documents?type=SCAN", token).json()["count"] == 1
    detail = api.get(f"/patient/members/{mother['id']}", token).json()
    assert detail["member"]["documentCount"] == 2 and len(detail["documents"]) == 2


def test_view_link_and_delete(api, django_capture_on_commit_callbacks):
    token = patient(api)
    mother = add_member(api, token)
    doc = add_document(api, token, mother["id"]).json()
    view = api.get(f"/patient/documents/{doc['id']}/view-url", token).json()
    assert view["url"] and view["mime"] == "application/pdf"

    key = PatientDocument.objects.get(pk=doc["id"]).file_key or ""
    assert get_storage().size(key) == len(PDF)
    with django_capture_on_commit_callbacks(execute=True):
        assert api.delete(f"/patient/documents/{doc['id']}", token).status_code == 200
    assert get_storage().size(key) is None  # the file is gone at once
    assert api.get("/patient/documents", token).json()["count"] == 0
    assert api.get(f"/patient/documents/{doc['id']}/view-url", token).status_code == 404
    assert PatientDocument.objects.get(pk=doc["id"]).deleted_at is not None  # row kept


def test_only_real_pdfs_and_photos(api):
    token = patient(api)
    mother = add_member(api, token)
    # says PDF, is not one
    key = upload_document(api, token, content=b"MZ" + b"\x00" * 64, mime="application/pdf")
    resp = api.post(
        "/patient/documents",
        {"fileKey": key, "memberId": mother["id"], "type": "OTHER", "title": "x", "date": None},
        token,
    )
    assert resp.json()["error"]["code"] == "INVALID_FILE"
    # a photo is fine
    key = upload_document(api, token, content=PNG, mime="image/png")
    resp = api.post(
        "/patient/documents",
        {"fileKey": key, "memberId": mother["id"], "type": "ID", "title": "Aadhaar", "date": None},
        token,
    )
    assert resp.status_code == 200 and resp.json()["mime"] == "image/png"
    # a word file is refused before upload
    resp = api.post(
        "/patient/documents/upload-url",
        {"type": "OTHER", "mime": "application/msword", "sizeBytes": 100},
        token,
    )
    assert resp.json()["error"]["code"] == "INVALID_FILE"
    future = api.post(
        "/patient/documents",
        {
            "fileKey": upload_document(api, token),
            "memberId": mother["id"],
            "type": "OTHER",
            "title": "x",
            "date": "2999-01-01",
        },
        token,
    )
    assert future.json()["error"]["code"] == "INVALID_DATE"


def test_the_account_has_200_mb(api, monkeypatch):
    token = patient(api)
    mother = add_member(api, token)
    monkeypatch.setattr(services, "QUOTA_BYTES", len(PDF) * 2)
    assert add_document(api, token, mother["id"]).status_code == 200
    assert add_document(api, token, mother["id"]).status_code == 200
    full = api.post(
        "/patient/documents/upload-url",
        {"type": "OTHER", "mime": "application/pdf", "sizeBytes": len(PDF)},
        token,
    )
    assert full.status_code == 409 and full.json()["error"]["code"] == "STORAGE_FULL"
    storage = api.get("/patient/documents/storage", token).json()
    assert storage == {"usedBytes": len(PDF) * 2, "quotaBytes": len(PDF) * 2}
    # deleting frees room
    first = api.get("/patient/documents", token).json()["items"][0]
    api.delete(f"/patient/documents/{first['id']}", token)
    assert add_document(api, token, mother["id"]).status_code == 200


def test_same_file_cannot_be_saved_twice(api):
    token = patient(api)
    mother = add_member(api, token)
    key = upload_document(api, token)
    body = {"fileKey": key, "memberId": mother["id"], "type": "OTHER", "title": "x", "date": None}
    assert api.post("/patient/documents", body, token).status_code == 200
    assert api.post("/patient/documents", body, token).json()["error"]["code"] == "ALREADY_ADDED"


def test_removed_members_documents_are_hidden(api):
    token = patient(api)
    mother = add_member(api, token)
    doc = add_document(api, token, mother["id"]).json()
    api.delete(f"/patient/members/{mother['id']}", token)
    assert api.get("/patient/documents", token).json()["count"] == 0
    assert api.get(f"/patient/documents/{doc['id']}/view-url", token).status_code == 404


def test_other_patients_cannot_read_or_use_your_documents(api):
    """IDOR (4.4): another account can't list, open or delete your documents, file them under
    your member, or attach your uploaded file."""
    mine = patient(api)
    mother = add_member(api, mine)
    doc = add_document(api, mine, mother["id"]).json()
    my_key = upload_document(api, mine)

    theirs = patient(api, OTHER, device_id="patient-device-2")
    their_self = api.get("/patient/members", theirs).json()[0]
    assert api.get(f"/patient/documents?memberId={mother['id']}", theirs).json()["count"] == 0
    assert api.get(f"/patient/documents/{doc['id']}/view-url", theirs).status_code == 404
    assert api.delete(f"/patient/documents/{doc['id']}", theirs).status_code == 404
    on_my_member = api.post(
        "/patient/documents",
        {
            "fileKey": upload_document(api, theirs),
            "memberId": mother["id"],
            "type": "OTHER",
            "title": "x",
            "date": None,
        },
        theirs,
    )
    assert on_my_member.status_code == 404
    my_file = api.post(
        "/patient/documents",
        {
            "fileKey": my_key,
            "memberId": their_self["id"],
            "type": "OTHER",
            "title": "x",
            "date": None,
        },
        theirs,
    )
    assert my_file.json()["error"]["code"] == "FILE_NOT_FOUND"
    assert PatientDocument.objects.get(pk=doc["id"]).deleted_at is None


def test_removing_a_member_can_delete_their_documents(api, django_capture_on_commit_callbacks):
    token = patient(api)
    mother = add_member(api, token)
    doc = add_document(api, token, mother["id"]).json()
    key = PatientDocument.objects.get(pk=doc["id"]).file_key or ""
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.delete(f"/patient/members/{mother['id']}?deleteDocuments=true", token)
    assert resp.status_code == 200
    assert PatientDocument.objects.get(pk=doc["id"]).deleted_at is not None
    assert get_storage().size(key) is None


def test_kept_documents_of_a_removed_member_free_their_space(api):
    """Kept for past bookings, but the patient can't see them: they don't fill the 200 MB."""
    token = patient(api)
    mother = add_member(api, token)
    add_document(api, token, mother["id"])
    assert api.get("/patient/documents/storage", token).json()["usedBytes"] == len(PDF)
    api.delete(f"/patient/members/{mother['id']}", token)
    assert api.get("/patient/documents/storage", token).json()["usedBytes"] == 0
    assert PatientDocument.objects.get().deleted_at is None  # still there for history


def test_a_failed_file_delete_is_retried_by_the_cleanup(api, monkeypatch):
    from datetime import timedelta

    from django.utils import timezone

    from apps.files import services as files
    from apps.files.models import Upload

    token = patient(api)
    mother = add_member(api, token)
    doc = add_document(api, token, mother["id"]).json()
    key = PatientDocument.objects.get(pk=doc["id"]).file_key or ""
    storage = get_storage()
    real_delete = storage.delete

    def broken(_key):
        raise OSError("storage down")

    monkeypatch.setattr(type(storage), "delete", lambda self, k: broken(k))
    files.delete_file(key)
    upload = Upload.objects.get(key=key)
    assert upload.attached_at is None  # waiting for the cleanup
    monkeypatch.setattr(type(storage), "delete", lambda self, k: real_delete(k))
    assert files.cleanup_unattached(now=timezone.now() + timedelta(days=2)) >= 1
    assert get_storage().size(key) is None and not Upload.objects.filter(key=key).exists()


def test_too_many_unsaved_uploads_are_refused(api, monkeypatch):
    from apps.files import services as files

    monkeypatch.setattr(files, "MAX_OPEN_UPLOADS", 2)
    token = patient(api)
    upload_document(api, token)
    upload_document(api, token)
    resp = api.post(
        "/patient/documents/upload-url",
        {"type": "OTHER", "mime": "application/pdf", "sizeBytes": len(PDF)},
        token,
    )
    assert resp.status_code == 429 and resp.json()["error"]["code"] == "TOO_MANY_UPLOADS"


def test_today_is_india_s_date_early_in_the_morning(monkeypatch):
    """00:30 IST is still yesterday in UTC: "today" (document dates, ages, DOB) is India's."""
    import datetime as dt

    from django.utils import timezone

    from common.dates import today_ist

    monkeypatch.setattr(timezone, "now", lambda: dt.datetime(2026, 10, 9, 19, 0, tzinfo=dt.UTC))
    assert today_ist() == dt.date(2026, 10, 10)
