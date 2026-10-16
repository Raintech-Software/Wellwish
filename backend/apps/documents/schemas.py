"""Request/response schemas for patient documents."""

import datetime as dt
from typing import Any, Literal

from pydantic import Field

from common.schemas import CamelSchema, StrictIn

DocumentTypeIn = Literal["PRESCRIPTION", "LAB_REPORT", "SCAN", "DISCHARGE", "ID", "OTHER"]


class DocumentUploadUrlIn(StrictIn):
    type: DocumentTypeIn
    mime: str = Field(..., max_length=40)
    size_bytes: int = Field(..., gt=0)


class PatientDocumentIn(StrictIn):
    file_key: str = Field(..., min_length=1, max_length=255)
    member_id: str = Field(..., max_length=36)
    type: DocumentTypeIn
    title: str = Field(..., min_length=1, max_length=80)
    date: dt.date | None = Field(..., description="date on the document, if known")


class PatientDocumentOut(CamelSchema):
    """Built from a `PatientDocument` (with its member loaded)."""

    id: str
    member_id: str
    member_name: str
    type: str
    title: str
    date: dt.date | None
    mime: str
    size_bytes: int
    created_at: dt.datetime
    text: str = Field("", description="CARE_NOTE only: the nurse's note (no file to open)")
    vitals: dict[str, Any] | None = Field(None, description="CARE_NOTE only: BP, pulse, ...")

    # Work on the model and on an already-built PatientDocumentOut (nested responses build
    # twice).
    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.id)

    @staticmethod
    def resolve_member_id(obj: Any) -> str:
        return str(obj.member_id)


class DocumentStorageOut(CamelSchema):
    used_bytes: int
    quota_bytes: int
