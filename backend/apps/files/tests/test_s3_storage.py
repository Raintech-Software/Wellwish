"""The S3 upload path against a real S3 API (PHASES 9B.5): an S3-compatible store in Docker
(SeaweedFS's S3 gateway), `.\\ww.ps1 s3-test`. Skipped in the normal test run (no S3 there).

What S3 itself must do with the presigned POST (v2.31): take a file up to the purpose's limit
of the declared type, refuse one byte more, refuse another type and a changed key; the API
then checks the stored file (size, first bytes) and gives a short view link."""

import os
import time

import pytest
import requests

from apps.files import services
from apps.files.storage import S3Storage

ENDPOINT = os.environ.get("S3_TEST_ENDPOINT", "")
BUCKET = "wellwish-s3-test"
PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 64

pytestmark = [
    pytest.mark.django_db,
    pytest.mark.skipif(not ENDPOINT, reason="needs the S3 test store: .\\ww.ps1 s3-test"),
]


@pytest.fixture
def s3(settings) -> S3Storage:
    settings.FILE_STORAGE = "s3"
    settings.FILE_S3_BUCKET = BUCKET
    settings.FILE_S3_ENDPOINT_URL = ENDPOINT
    for _ in range(60):  # the store may still be starting: any answer means it's up
        try:
            requests.get(ENDPOINT, timeout=2)
            break
        except requests.RequestException:
            time.sleep(1)
    storage = S3Storage()
    existing = [b["Name"] for b in storage.client.list_buckets().get("Buckets", [])]
    if BUCKET not in existing:
        storage.client.create_bucket(
            Bucket=BUCKET, CreateBucketConfiguration={"LocationConstraint": "ap-south-1"}
        )
    return storage


def send(ticket: services.UploadTicket, content: bytes, mime: str, **changes: str):
    fields = {**ticket.upload_fields, **changes}
    return requests.post(
        ticket.upload_url,
        data=fields,
        files={"file": ("upload", content, mime)},
        timeout=30,
        allow_redirects=False,
    )


# A broken policy condition: AWS S3 answers 403 AccessDenied; SeaweedFS (the test store)
# answers 307 back to the bucket. Either way nothing is stored, which the test checks.
REFUSED = {403, 307}


def test_s3_refuses_a_file_over_the_limit_or_of_another_type(s3):
    limit = services.PURPOSES["hospital_photo"].max_bytes  # 5 MB
    ticket = services.create_upload(purpose="hospital_photo", mime="image/png", size_bytes=1000)
    assert set(ticket.upload_fields) >= {"key", "Content-Type", "policy", "x-amz-signature"}
    assert ticket.upload_fields["key"] == ticket.file_key

    too_big = send(ticket, PNG + b"\x00" * (limit - len(PNG) + 1), "image/png")
    assert too_big.status_code == 400 and "EntityTooLarge" in too_big.text
    other_type = send(ticket, PNG, "image/jpeg", **{"Content-Type": "image/jpeg"})
    assert other_type.status_code in REFUSED  # the policy fixes the type
    other_key = send(ticket, PNG, "image/png", key="f/somebody-elses.png")
    assert other_key.status_code in REFUSED  # and the key
    assert s3.size(ticket.file_key) is None  # nothing was stored
    assert s3.size("f/somebody-elses.png") is None

    exactly = send(ticket, PNG + b"\x00" * (limit - len(PNG)), "image/png")
    assert exactly.status_code == 204, exactly.text
    assert s3.size(ticket.file_key) == limit


def test_the_api_checks_the_stored_file_and_links_it(s3):
    ticket = services.create_upload(
        purpose="kyc_document", mime="image/png", size_bytes=len(PNG), owner="u1"
    )
    assert send(ticket, PNG, "image/png").status_code == 204
    assert services.confirm_upload(ticket.file_key, purpose="kyc_document", owner="u1") == (
        "image/png"
    )
    view = requests.get(services.view_url(ticket.file_key), timeout=10)
    assert view.status_code == 200 and view.content == PNG
    s3.delete(ticket.file_key)
    assert s3.size(ticket.file_key) is None
