"""Schemas for uploads."""

from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, StrictIn


class UploadUrlIn(StrictIn):
    """Admin uploads: directory photos, a partner's photo and documents (manual add) and a
    temporary partner's ID photo (§6.19)."""

    purpose: Literal[
        "hospital_photo", "doctor_photo", "partner_photo", "kyc_document", "temp_partner_id"
    ]
    mime: str = Field(..., max_length=60)
    size_bytes: int = Field(..., gt=0)


class PartnerUploadUrlIn(StrictIn):
    """Partner app uploads: profile photo, KYC documents (JPG, PNG, WebP or PDF) and the daily
    selfie."""

    purpose: Literal["partner_photo", "kyc_document", "partner_selfie"]
    mime: str = Field(..., max_length=60)
    size_bytes: int = Field(..., gt=0)


class UploadUrlOut(CamelSchema):
    file_key: str = Field(..., description="Send this with the form after uploading")
    upload_url: str = Field(
        ...,
        description="POST the file here as multipart/form-data: every upload field first, then "
        "the file as `file` (/path = on this API). The storage refuses a bigger file.",
    )
    upload_fields: dict[str, str] = Field(
        ..., description="Form fields to send before the file, unchanged (the signed policy)"
    )
    mime: str
    max_bytes: int


class ViewUrlOut(CamelSchema):
    """A private file link (KYC documents, patient documents)."""

    url: str = Field(..., description="Works for 5 minutes")
    mime: str
