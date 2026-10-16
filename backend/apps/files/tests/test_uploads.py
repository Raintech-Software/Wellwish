"""Upload flow with local storage: upload URL, PUT, confirm by magic bytes, view link (§6.8)."""

import pytest
from django.test import Client

from apps.files.services import InvalidFile, confirm_upload, sniff_mime
from apps.files.tests.support import send_file
from apps.hospitals.models import Hospital
from conftest import staff_token

pytestmark = pytest.mark.django_db

PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 64
PNG_SIZE = len(PNG)
JPEG = b"\xff\xd8\xff\xe0" + b"\x00" * 64
HOSPITAL = {
    "name": "Photo Hospital",
    "type": "HOSPITAL",
    "address": "Plot 1, Saheed Nagar, Bhubaneswar",
    "lat": "20.290000",
    "lng": "85.840000",
}


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


@pytest.fixture
def token(api, staff_roles):
    return staff_token(api, staff_roles)


def ticket(api, token, mime="image/png", size=PNG_SIZE, purpose="hospital_photo"):
    return api.post(
        "/admin/files/upload-url", {"purpose": purpose, "mime": mime, "sizeBytes": size}, token
    )


def put(url: str, content: bytes, mime: str):
    """Sends the file as the apps do (a POST with the form fields, v2.31)."""
    return send_file(url, content, mime)


def test_upload_then_attach_to_a_hospital(api, token):
    t = ticket(api, token).json()
    # an opaque key: a link says nothing about what the file is (9.11)
    assert t["fileKey"].startswith("f/") and "hospital" not in t["fileKey"]
    assert t["uploadUrl"].startswith("/v1/files/upload/")
    assert t["uploadFields"] == {"Content-Type": "image/png"}
    assert put(t["uploadUrl"], PNG, "image/png").status_code == 204

    resp = api.post("/admin/hospitals", {**HOSPITAL, "photoKey": t["fileKey"]}, token)
    assert resp.status_code == 200, resp.json()
    photo_url = resp.json()["photoUrl"]
    assert photo_url.startswith("/v1/files/view/")
    view = Client().get(photo_url)
    assert view.status_code == 200
    assert view["Content-Type"] == "image/png"
    assert view["Cache-Control"] == "private, no-store"
    assert b"".join(view.streaming_content) == PNG  # type: ignore[attr-defined]


def test_wrong_type_or_size_is_refused_up_front(api, token):
    assert ticket(api, token, mime="application/pdf").status_code == 422
    big = ticket(api, token, size=6 * 1024 * 1024)
    assert big.json()["error"]["code"] == "FILE_TOO_LARGE"
    assert ticket(api, token, purpose="nope").status_code == 422


def test_file_that_is_not_really_an_image_is_refused(api, token):
    t = ticket(api, token).json()
    put(t["uploadUrl"], b"<script>alert(1)</script>" + b" " * 40, "image/png")
    resp = api.post("/admin/hospitals", {**HOSPITAL, "photoKey": t["fileKey"]}, token)
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "INVALID_FILE"
    assert not Hospital.objects.exists()


def test_photo_must_be_uploaded_first(api, token):
    t = ticket(api, token).json()
    resp = api.post("/admin/hospitals", {**HOSPITAL, "photoKey": t["fileKey"]}, token)
    assert resp.json()["error"]["code"] == "FILE_NOT_FOUND"


def test_upload_rejects_a_different_content_type_and_extra_bytes(api, token):
    t = ticket(api, token).json()
    assert put(t["uploadUrl"], JPEG, "image/jpeg").status_code == 422
    too_big = ticket(api, token, size=len(PNG)).json()
    # the PUT may not exceed the purpose's limit (5 MB)
    assert (
        put(too_big["uploadUrl"], PNG + b"\x00" * (5 * 1024 * 1024), "image/png").status_code == 413
    )


def test_upload_and_view_links_are_signed(api):
    assert put("/v1/files/upload/forged", PNG, "image/png").status_code == 403
    assert Client().get("/v1/files/view/forged").status_code == 403


def test_keys_from_another_purpose_or_outside_the_folder_are_refused():
    with pytest.raises(InvalidFile):
        confirm_upload("directory/doctors/x.png", purpose="hospital_photo")
    with pytest.raises(InvalidFile):
        confirm_upload("directory/hospitals/../../etc/passwd", purpose="hospital_photo")


def test_sniff_mime():
    assert sniff_mime(PNG) == "image/png"
    assert sniff_mime(JPEG) == "image/jpeg"
    assert sniff_mime(b"RIFF\x00\x00\x00\x00WEBPVP8 ") == "image/webp"
    assert sniff_mime(b"%PDF-1.7") == "application/pdf"
    assert sniff_mime(b"GIF89a") is None


def test_upload_url_needs_directory_manage(api, staff_roles):
    support = staff_token(api, staff_roles, "SUPPORT")
    assert ticket(api, support).status_code == 403


def test_a_file_is_attached_only_for_its_purpose_and_owner(settings, tmp_path):
    """Keys are opaque (9.11), so the upload row says whose file it is and what for."""
    from apps.files import services
    from apps.files.models import Upload
    from apps.files.storage import LocalStorage

    settings.MEDIA_ROOT = str(tmp_path)

    mine = services.create_upload(
        purpose="member_photo", mime="image/png", size_bytes=100, owner="u-1"
    )
    LocalStorage().save(mine.file_key, PNG)
    for purpose, owner in (("member_photo", "u-2"), ("partner_photo", "u-1")):
        with pytest.raises(services.InvalidFile):
            services.confirm_upload(mine.file_key, purpose=purpose, owner=owner)
    assert (
        services.confirm_upload(mine.file_key, purpose="member_photo", owner="u-1") == "image/png"
    )
    # a file stored before keys were opaque (no upload row): its place in the key still counts
    old = "members/photos/u-1/old.png"
    LocalStorage().save(old, PNG)
    assert not Upload.objects.filter(key=old).exists()
    assert services.confirm_upload(old, purpose="member_photo", owner="u-1") == "image/png"
    with pytest.raises(services.InvalidFile):
        services.confirm_upload(old, purpose="member_photo", owner="u-2")
