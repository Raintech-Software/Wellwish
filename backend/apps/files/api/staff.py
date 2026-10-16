"""Admin uploads: directory photos (directory.manage) and partner photos/documents for a
partner added by hand (partners.add). Patient uploads arrive in Phase 4."""

from django.http import HttpRequest
from ninja import Router

from apps.files import services
from apps.files.schemas import UploadUrlIn, UploadUrlOut
from apps.files.services import staff_owner
from common.auth import get_principal
from common.errors import PermissionDenied

router = Router(tags=["admin"])

PERMISSION_FOR = {
    "hospital_photo": "directory.manage",
    "doctor_photo": "directory.manage",
    "partner_photo": "partners.add",
    "kyc_document": "partners.add",
    "temp_partner_id": "bookings.manage",  # the temporary assign (§6.19)
}


@router.post(
    "/files/upload-url", response=UploadUrlOut, by_alias=True, operation_id="adminFilesUploadUrl"
)
def upload_url(request: HttpRequest, data: UploadUrlIn) -> UploadUrlOut:
    """Step 1 of an upload: get a short-lived URL to PUT the file to."""
    principal = get_principal(request)
    permission = PERMISSION_FOR[data.purpose]
    if permission not in principal.permissions:
        raise PermissionDenied(details={"permission": permission})
    owned = services.PURPOSES[data.purpose].owned
    ticket = services.create_upload(
        purpose=data.purpose,
        mime=data.mime,
        size_bytes=data.size_bytes,
        owner=staff_owner(principal.subject_id) if owned else "",
    )
    return UploadUrlOut(
        file_key=ticket.file_key,
        upload_url=ticket.upload_url,
        upload_fields=ticket.upload_fields,
        mime=ticket.mime,
        max_bytes=ticket.max_bytes,
    )
