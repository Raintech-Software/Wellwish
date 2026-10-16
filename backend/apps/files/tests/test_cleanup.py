"""Unattached uploads are deleted after 24 h (task 3.4); owned keys can't be borrowed."""

from datetime import timedelta

import pytest
from django.utils import timezone

from apps.files.models import Upload
from apps.files.services import InvalidFile, cleanup_unattached, confirm_upload, create_upload
from apps.files.tests.support import send_file

pytestmark = pytest.mark.django_db

PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 64


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path
    return tmp_path


def uploaded(purpose="kyc_document", owner="u1"):
    ticket = create_upload(purpose=purpose, mime="image/png", size_bytes=len(PNG), owner=owner)
    assert send_file(ticket.upload_url, PNG, "image/png").status_code == 204
    return ticket.file_key


def test_unattached_uploads_are_deleted_after_a_day(_media):
    attached, abandoned, fresh = uploaded(), uploaded(), uploaded()
    confirm_upload(attached, purpose="kyc_document", owner="u1")
    Upload.objects.exclude(key=fresh).update(created_at=timezone.now() - timedelta(hours=25))
    assert cleanup_unattached() == 1
    assert not (_media / abandoned).exists()
    assert (_media / attached).exists() and (_media / fresh).exists()
    assert set(Upload.objects.values_list("key", flat=True)) == {attached, fresh}


def test_owned_uploads_are_only_the_owners():
    key = uploaded(owner="u1")
    assert key.startswith("f/") and "u1" not in key  # opaque: the upload row knows the owner
    with pytest.raises(InvalidFile):
        confirm_upload(key, purpose="kyc_document", owner="u2")
    with pytest.raises(ValueError):
        create_upload(purpose="kyc_document", mime="image/png", size_bytes=10, owner="../x")


def test_kyc_documents_accept_pdf_up_to_10_mb():
    ticket = create_upload(
        purpose="kyc_document", mime="application/pdf", size_bytes=9 * 1024 * 1024, owner="u1"
    )
    assert ticket.file_key.endswith(".pdf")
    with pytest.raises(InvalidFile):
        create_upload(purpose="partner_photo", mime="application/pdf", size_bytes=10, owner="u1")
