"""All writes for patient documents (§6.8): upload once, file under a family member, reuse.

Limits: PDF/JPG/PNG/HEIC, 10 MB each, 200 MB per account. Deleting removes the file at once;
the row stays (marked deleted) so a past booking can say "document removed".
"""

import datetime as dt
from dataclasses import dataclass
from functools import partial
from typing import Any

from django.db import transaction
from django.utils import timezone

from apps.accounts.models import User
from apps.audit.services import record
from apps.documents import selectors
from apps.documents.models import PatientDocument
from apps.files import services as files
from apps.patients.models import Member
from apps.patients.selectors import is_own_member
from apps.staff.models import StaffUser
from common.dates import today_ist
from common.errors import ApiError, NotFound
from common.ids import uid

MB = 1024 * 1024
QUOTA_BYTES = 200 * MB


class StorageFull(ApiError):
    status = 409
    code = "STORAGE_FULL"
    message = "Your documents are using all 200 MB. Delete some old ones first."


class InvalidDocument(ApiError):
    status = 422
    code = "INVALID_DOCUMENT"
    message = "Please check the document details."


def _check_room(user_id: str, size_bytes: int) -> None:
    used = selectors.used_bytes(user_id)
    if used + size_bytes > QUOTA_BYTES:
        raise StorageFull(details={"usedBytes": used, "quotaBytes": QUOTA_BYTES})


def create_upload(*, user_id: str, mime: str, size_bytes: int) -> files.UploadTicket:
    """Step 1 (§6.8): an upload URL, if the file fits in the account's 200 MB."""
    _check_room(user_id, size_bytes)
    return files.create_upload(
        purpose="patient_document", mime=mime, size_bytes=size_bytes, owner=str(user_id)
    )


@dataclass(frozen=True)
class DocumentInput:
    file_key: str
    member_id: str
    type: str
    title: str
    date: dt.date | None


@transaction.atomic
def add_document(*, user_id: str, data: DocumentInput) -> PatientDocument:
    """Step 3: file the uploaded document under one of the caller's members."""
    if not is_own_member(user_id, data.member_id):
        raise NotFound()
    title = " ".join(data.title.split())
    if not title:
        raise InvalidDocument(code="TITLE_REQUIRED", message="Give the document a name.")
    if data.date is not None and data.date > today_ist():
        raise InvalidDocument(code="INVALID_DATE", message="The date can't be in the future.")
    # One account at a time, so two uploads together can't pass the limit.
    User.objects.select_for_update().filter(pk=uid(user_id)).first()
    if PatientDocument.objects.filter(file_key=data.file_key).exists():
        raise InvalidDocument(code="ALREADY_ADDED", message="This file is already saved.")
    stored = files.confirm_upload_details(
        data.file_key, purpose="patient_document", owner=str(user_id), exclusive=True
    )
    _check_room(user_id, stored.size_bytes)
    return PatientDocument.objects.create(
        owner_id=uid(user_id),
        member_id=uid(data.member_id),
        type=data.type,
        title=title,
        doc_date=data.date,
        file_key=data.file_key,
        mime=stored.mime,
        size_bytes=stored.size_bytes,
        uploaded_by_id=uid(user_id),
    )


class NotAFile(ApiError):
    status = 422
    code = "NOT_A_FILE"
    message = "This is a care note: its text is shown in the app."


def _file_of(document: PatientDocument) -> str:
    if not document.file_key:
        raise NotAFile()
    return document.file_key


def view_url(*, user_id: str, document_id: str) -> tuple[str, str]:
    document = selectors.own_document(user_id, document_id)
    return files.view_url(_file_of(document)), document.mime


def add_care_note(
    *,
    member_id: str,
    booking_code: str,
    text: str,
    vitals: dict[str, Any] | None,
    written_by: str,
) -> PatientDocument:
    """A nurse's care note at "Care done" (§6.11) goes to the member's documents: text and
    optional vitals, no file (counts nothing towards the 200 MB)."""
    member = Member.objects.select_related("owner").get(pk=uid(member_id))
    return PatientDocument.objects.create(
        owner=member.owner,
        member=member,
        type=PatientDocument.Type.CARE_NOTE,
        title=f"Care note · {booking_code}"[:80],
        doc_date=today_ist(),
        file_key=None,
        mime="text/plain",
        size_bytes=0,
        text=text,
        vitals=vitals or None,
        uploaded_by_id=uid(written_by),
    )


@transaction.atomic
def delete_document(*, user_id: str, document_id: str) -> None:
    document = (
        PatientDocument.objects.select_for_update()
        .filter(pk=uid(document_id), owner_id=uid(user_id), deleted_at__isnull=True)
        .first()
    )
    if document is None:
        raise NotFound()
    document.deleted_at = timezone.now()
    document.save(update_fields=["deleted_at", "updated_at"])
    if document.file_key:
        transaction.on_commit(partial(files.delete_file, document.file_key))


@transaction.atomic
def delete_member_documents(*, user_id: str, member_id: str) -> int:
    """Removing a family member with "delete their documents too" (§6.18): rows marked deleted
    (a past booking can still say "document removed"), files deleted after commit."""
    documents = list(
        PatientDocument.objects.select_for_update().filter(
            owner_id=uid(user_id), member_id=uid(member_id), deleted_at__isnull=True
        )
    )
    now = timezone.now()
    for document in documents:
        document.deleted_at = now
        document.save(update_fields=["deleted_at", "updated_at"])
        if document.file_key:
            transaction.on_commit(partial(files.delete_file, document.file_key))
    return len(documents)


def admin_view_url(
    *, actor: StaffUser, user_id: str, document_id: str, reason: str, ip: str
) -> tuple[str, str]:
    """An admin opens a patient's document: only with a reason, always audit-logged (§9.1)."""
    document = selectors.admin_document(user_id, document_id)
    record(
        actor,
        "patient_document.viewed",
        document,
        after={"type": document.type, "member": str(document.member_id)},
        reason=reason,
        ip=ip,
    )
    return files.view_url(_file_of(document)), document.mime


def erase_for_owner(*, user_id: str) -> int:
    """Account deletion (§12): every document and its file goes."""
    keys = list(
        PatientDocument.objects.filter(owner_id=uid(user_id), file_key__isnull=False).values_list(
            "file_key", flat=True
        )
    )
    deleted, _ = PatientDocument.objects.filter(owner_id=uid(user_id)).delete()
    for key in keys:
        if key:
            transaction.on_commit(partial(files.delete_file, key))
    return deleted
