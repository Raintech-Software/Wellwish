"""Upload flow (ARCHITECTURE §6.8):

1. The app asks for an upload URL (purpose, file type, size): `create_upload`.
2. It uploads the file straight to storage (S3, or the local dev folder): a multipart POST
   with the ticket's form fields first and the file last (field `file`). The storage refuses
   a file over the purpose's limit or of another type (v2.31, presigned POST).
3. It sends the returned `fileKey` with its form; the owning app calls `confirm_upload`,
   which checks the size and the real file type from the first bytes ("magic bytes").

Keys are opaque (`f/<random>.jpg`, PHASES 9.11): a view link says nothing about the file (a
selfie or a profile photo, a KYC document…). Every upload is recorded in `uploads` with its
purpose and owner, and `confirm_upload` checks both, so nobody can attach another person's file
or use a file for something else. Ones never attached to a form are deleted after 24 h. Files
stored before keys were opaque have the purpose and owner in the key (`kyc/{owner}/…`); one
without its upload row is still checked that way.
"""

import logging
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta

from django.utils import timezone

from apps.files.models import Upload
from apps.files.storage import get_storage
from common.errors import ApiError

logger = logging.getLogger(__name__)

MB = 1024 * 1024
UNATTACHED_TTL = timedelta(hours=24)


@dataclass(frozen=True)
class Purpose:
    prefix: str  # where files of this purpose were stored before keys were opaque
    mimes: tuple[str, ...]
    max_bytes: int
    owned: bool = False  # True: only the owner who asked for the upload may attach it


OPAQUE = "f/"


def staff_owner(staff_id: str) -> str:
    """Owner part of the key for files an admin uploads (a new partner's documents, a temporary
    partner's ID photo)."""
    return f"staff-{staff_id}"


PHOTO_MIMES = ("image/jpeg", "image/png", "image/webp")
# HEIC is left out of KYC on purpose: admin browsers can't show it (Android cameras save JPEG).
DOCUMENT_MIMES = (*PHOTO_MIMES, "application/pdf")
# Patient medical documents (§6.8): PDF/JPG/PNG/HEIC. The app sends photos as JPEG anyway.
MEDICAL_MIMES = (*DOCUMENT_MIMES, "image/heic")

PURPOSES: dict[str, Purpose] = {
    "hospital_photo": Purpose("directory/hospitals/", PHOTO_MIMES, 5 * MB),
    "doctor_photo": Purpose("directory/doctors/", PHOTO_MIMES, 5 * MB),
    "partner_photo": Purpose("partners/photos/", PHOTO_MIMES, 5 * MB, owned=True),
    "partner_selfie": Purpose("partners/selfies/", PHOTO_MIMES, 5 * MB, owned=True),
    "kyc_document": Purpose("kyc/", DOCUMENT_MIMES, 10 * MB, owned=True),
    # §6.19: the ID photo of a temporary partner, uploaded by the admin who checked it
    "temp_partner_id": Purpose("partners/temporary-ids/", DOCUMENT_MIMES, 10 * MB, owned=True),
    "member_photo": Purpose("members/photos/", PHOTO_MIMES, 5 * MB, owned=True),
    "patient_document": Purpose("documents/", MEDICAL_MIMES, 10 * MB, owned=True),
}

EXTENSIONS = {
    "image/jpeg": "jpg",
    "image/png": "png",
    "image/webp": "webp",
    "image/heic": "heic",
    "application/pdf": "pdf",
}


def sniff_mime(head: bytes) -> str | None:
    """The real type from the first bytes, whatever the file name or the app said."""
    if head.startswith(b"\xff\xd8\xff"):
        return "image/jpeg"
    if head.startswith(b"\x89PNG\r\n\x1a\n"):
        return "image/png"
    if head[:4] == b"RIFF" and head[8:12] == b"WEBP":
        return "image/webp"
    if head[4:8] == b"ftyp" and head[8:12] in (b"heic", b"heix", b"mif1", b"msf1"):
        return "image/heic"
    if head.startswith(b"%PDF-"):
        return "application/pdf"
    return None


class TooManyUploads(ApiError):
    status = 429
    code = "TOO_MANY_UPLOADS"
    message = "Too many files started but not saved. Save or wait a day, then try again."


# Owned uploads not yet attached, per owner and purpose, in the last 24 h. Stops one account
# from parking files in storage (they are deleted after 24 h anyway).
MAX_OPEN_UPLOADS = 30


class InvalidFile(ApiError):
    status = 422
    code = "INVALID_FILE"
    message = "This file can't be used. Please choose a JPG or PNG photo."


@dataclass(frozen=True)
class UploadTicket:
    file_key: str
    upload_url: str
    upload_fields: dict[str, str]
    mime: str
    max_bytes: int


def _prefix(rules: Purpose, owner: str) -> str:
    if not rules.owned:
        return rules.prefix
    if not owner or "/" in owner or ".." in owner:
        raise ValueError("Owned uploads need a plain owner id")
    return f"{rules.prefix}{owner}/"


def create_upload(*, purpose: str, mime: str, size_bytes: int, owner: str = "") -> UploadTicket:
    rules = PURPOSES.get(purpose)
    if rules is None:
        raise InvalidFile(code="UNKNOWN_PURPOSE", message="Unknown upload type.")
    if mime not in rules.mimes:
        raise InvalidFile(details={"allowed": list(rules.mimes)})
    if not 0 < size_bytes <= rules.max_bytes:
        raise InvalidFile(
            code="FILE_TOO_LARGE",
            message=f"The file is too large (max {rules.max_bytes // MB} MB).",
            details={"maxBytes": rules.max_bytes},
        )
    if rules.owned:
        open_uploads = Upload.objects.filter(
            owner=owner,
            purpose=purpose,
            attached_at__isnull=True,
            created_at__gte=timezone.now() - UNATTACHED_TTL,
        ).count()
        if open_uploads >= MAX_OPEN_UPLOADS:
            raise TooManyUploads()
    _prefix(rules, owner)  # an owned upload needs a plain owner id
    key = f"{OPAQUE}{uuid.uuid4().hex}.{EXTENSIONS[mime]}"
    url, fields = get_storage().upload_target(key, mime, rules.max_bytes)
    Upload.objects.create(key=key, purpose=purpose, owner=owner)
    return UploadTicket(
        file_key=key, upload_url=url, upload_fields=fields, mime=mime, max_bytes=rules.max_bytes
    )


@dataclass(frozen=True)
class ConfirmedFile:
    mime: str
    size_bytes: int


def confirm_upload(file_key: str, *, purpose: str, owner: str = "", exclusive: bool = False) -> str:
    """Raises InvalidFile unless `file_key` is an uploaded file of the right kind, size and
    owner. Marks it attached (so the cleanup keeps it) and returns its real type.
    `exclusive`: the file must not be attached to anything yet (one file, one owner record:
    a photo shared by two family members would vanish from one when the other changes it)."""
    return confirm_upload_details(file_key, purpose=purpose, owner=owner, exclusive=exclusive).mime


def confirm_upload_details(
    file_key: str, *, purpose: str, owner: str = "", exclusive: bool = False
) -> ConfirmedFile:
    """`confirm_upload`, also returning the stored size (for quotas)."""
    rules = PURPOSES[purpose]
    missing = InvalidFile(code="FILE_NOT_FOUND", message="Please upload the file again.")
    if not _belongs(file_key, purpose, rules, owner):
        raise missing
    storage = get_storage()
    size = storage.size(file_key)
    if size is None:
        raise missing
    if size > rules.max_bytes or size == 0:
        raise InvalidFile(code="FILE_TOO_LARGE", details={"maxBytes": rules.max_bytes})
    mime = sniff_mime(storage.head_bytes(file_key, 16))
    if mime not in rules.mimes:
        raise InvalidFile(
            message="This file can't be used. Please choose a photo (JPG, PNG) or a PDF."
            if "application/pdf" in rules.mimes
            else InvalidFile.message
        )
    attached = Upload.objects.filter(key=file_key, attached_at__isnull=True).update(
        attached_at=timezone.now(), updated_at=timezone.now()
    )
    if exclusive and not attached:
        raise InvalidFile(code="FILE_ALREADY_USED", message="Please upload the file again.")
    return ConfirmedFile(mime=mime, size_bytes=size)


def _belongs(file_key: str, purpose: str, rules: Purpose, owner: str) -> bool:
    """An upload of this purpose (and this owner, for owned purposes)."""
    if not file_key or ".." in file_key:
        return False
    row = Upload.objects.filter(key=file_key).values("purpose", "owner").first()
    if row is not None:
        return row["purpose"] == purpose and (not rules.owned or row["owner"] == owner)
    # a file stored before keys were opaque, without its upload row: the place in its key
    return not file_key.startswith(OPAQUE) and file_key.startswith(_prefix(rules, owner))


def delete_file(file_key: str) -> None:
    """Remove a stored file (a deleted document, a replaced photo). Missing files are fine.
    If the storage can't delete it now, the upload is marked unattached so the daily cleanup
    tries again: a medical file is never left behind untracked."""
    if not file_key:
        return
    try:
        get_storage().delete(file_key)
    except Exception:
        logger.warning("Could not delete a stored file; the daily cleanup retries it")
        updated = Upload.objects.filter(key=file_key).update(
            attached_at=None, updated_at=timezone.now()
        )
        if not updated:
            Upload.objects.create(key=file_key, purpose="to_delete")
        return
    Upload.objects.filter(key=file_key).delete()


def view_url(file_key: str) -> str:
    """A link that works for 5 minutes. Files are never public."""
    return get_storage().view_url(file_key)


def cleanup_unattached(*, now: datetime | None = None) -> int:
    """Delete uploads that were never attached to a form within 24 h (task 3.4)."""
    cutoff = (now or timezone.now()) - UNATTACHED_TTL
    storage = get_storage()
    deleted = 0
    for upload in Upload.objects.filter(attached_at__isnull=True, created_at__lt=cutoff)[:1000]:
        try:
            storage.delete(upload.key)
        except Exception:  # keep the row and try again tomorrow
            logger.warning("Could not delete an unattached upload (%s)", upload.purpose)
            continue
        upload.delete()
        deleted += 1
    return deleted
