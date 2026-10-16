"""Patient app: medical documents (/v1/patient/documents, §6.8, §10.3)."""

from typing import Literal
from uuid import UUID

from django.db.models import QuerySet
from django.http import HttpRequest
from ninja import Query, Router, Schema
from ninja.pagination import paginate
from pydantic import Field

from apps.documents import selectors, services
from apps.documents.models import PatientDocument
from apps.documents.schemas import (
    DocumentStorageOut,
    DocumentUploadUrlIn,
    PatientDocumentIn,
    PatientDocumentOut,
)
from apps.files.schemas import UploadUrlOut, ViewUrlOut
from common.auth import get_principal
from common.pagination import WWPagination
from common.schemas import OkOut

router = Router(tags=["patient"])


def document_out(document: PatientDocument) -> PatientDocumentOut:
    return PatientDocumentOut.from_orm(document)


class PatientDocumentFilter(Schema):
    member_id: str | None = Field(None, alias="memberId")
    type: Literal["PRESCRIPTION", "LAB_REPORT", "SCAN", "DISCHARGE", "ID", "OTHER"] | None = None
    group: Literal["reports", "prescriptions"] | None = Field(
        None, description="the app's tabs: reports = lab reports, scans, discharge summaries"
    )


@router.get(
    "/documents",
    response=list[PatientDocumentOut],
    by_alias=True,
    operation_id="patientDocumentList",
)
@paginate(WWPagination)
def list_documents(
    request: HttpRequest, filters: Query[PatientDocumentFilter]
) -> QuerySet[PatientDocument]:
    """Your documents, newest first (P21): filter by family member, type or tab."""
    user_id = get_principal(request).subject_id
    return selectors.documents(
        user_id, member_id=filters.member_id, doc_type=filters.type or "", group=filters.group or ""
    )


@router.get(
    "/documents/storage",
    response=DocumentStorageOut,
    by_alias=True,
    operation_id="patientDocumentStorage",
)
def storage(request: HttpRequest) -> DocumentStorageOut:
    """How much of the 200 MB is used."""
    user_id = get_principal(request).subject_id
    return DocumentStorageOut(
        used_bytes=selectors.used_bytes(user_id), quota_bytes=services.QUOTA_BYTES
    )


@router.post(
    "/documents/upload-url",
    response=UploadUrlOut,
    by_alias=True,
    operation_id="patientDocumentUploadUrl",
)
def upload_url(request: HttpRequest, data: DocumentUploadUrlIn) -> UploadUrlOut:
    """Step 1 of an upload: PUT the file to `uploadUrl`, then save it with `fileKey`."""
    ticket = services.create_upload(
        user_id=get_principal(request).subject_id, mime=data.mime, size_bytes=data.size_bytes
    )
    return UploadUrlOut(
        file_key=ticket.file_key,
        upload_url=ticket.upload_url,
        upload_fields=ticket.upload_fields,
        mime=ticket.mime,
        max_bytes=ticket.max_bytes,
    )


@router.post(
    "/documents", response=PatientDocumentOut, by_alias=True, operation_id="patientDocumentAdd"
)
def add_document(request: HttpRequest, data: PatientDocumentIn) -> PatientDocumentOut:
    """Save an uploaded file under a family member (or yourself)."""
    document = services.add_document(
        user_id=get_principal(request).subject_id,
        data=services.DocumentInput(
            file_key=data.file_key,
            member_id=data.member_id,
            type=data.type,
            title=data.title,
            date=data.date,
        ),
    )
    return document_out(document)


@router.get(
    "/documents/{uuid:document_id}/view-url",
    response=ViewUrlOut,
    by_alias=True,
    operation_id="patientDocumentViewUrl",
)
def view_url(request: HttpRequest, document_id: UUID) -> ViewUrlOut:
    """A link to open the file (works for 5 minutes)."""
    url, mime = services.view_url(
        user_id=get_principal(request).subject_id, document_id=str(document_id)
    )
    return ViewUrlOut(url=url, mime=mime)


@router.delete(
    "/documents/{uuid:document_id}",
    response=OkOut,
    by_alias=True,
    operation_id="patientDocumentDelete",
)
def delete_document(request: HttpRequest, document_id: UUID) -> OkOut:
    services.delete_document(
        user_id=get_principal(request).subject_id, document_id=str(document_id)
    )
    return OkOut()
