"""Schemas for documents, the partner's verification status and the admin review pages."""

from datetime import date, datetime
from typing import Literal

from pydantic import Field

from apps.partners.schemas import (
    GenderIn,
    PartnerProfileOut,
    RoleIn,
    Tag,
)
from common.schemas import CamelSchema, Latitude, Longitude, Reason, StrictIn

NumberRuleIn = Literal["NONE", "AADHAAR", "PAN", "TEXT"]
DocType = Field(..., min_length=2, max_length=40, pattern=r"^[A-Z][A-Z0-9_]*$")


class RequiredDocumentOut(CamelSchema):
    id: str
    role: str
    doc_type: str
    label: str
    label_hi: str
    label_or: str
    help: str
    help_hi: str = Field("", description="The hint in Hindi, when the admin gave one (9.1)")
    help_or: str = Field("", description="The hint in Odia, when the admin gave one (9.1)")
    mandatory: bool
    condition: str
    condition_hi: str = Field("", description="The condition in Hindi (9.1)")
    condition_or: str = Field("", description="The condition in Odia (9.1)")
    has_expiry: bool
    number_rule: str = Field(..., description="NONE · AADHAAR · PAN · TEXT")
    camera_only: bool
    sort: int
    is_active: bool


class RequiredDocumentIn(StrictIn):
    role: RoleIn
    doc_type: str = DocType
    label: str = Field(..., min_length=2, max_length=80)
    label_hi: str = Field("", max_length=80)
    label_or: str = Field("", max_length=80)
    help: str = Field("", max_length=200)
    help_hi: str = Field("", max_length=200)
    help_or: str = Field("", max_length=200)
    mandatory: bool
    condition: str = Field("", max_length=120)
    condition_hi: str = Field("", max_length=120)
    condition_or: str = Field("", max_length=120)
    has_expiry: bool
    number_rule: NumberRuleIn
    camera_only: bool
    sort: int = Field(..., ge=0, le=1000)
    is_active: bool


class DocumentIn(StrictIn):
    doc_type: str = DocType
    file_key: str = Field(..., min_length=1, max_length=255)
    number: str = Field("", max_length=40, description="Aadhaar/PAN are stored masked")
    expires_on: date | None = None


class DocumentOut(CamelSchema):
    id: str
    doc_type: str
    status: str = Field(..., description="PENDING · APPROVED · REJECTED · EXPIRED")
    mime: str
    number_masked: str
    expires_on: date | None
    reject_reason: str
    is_current: bool
    reviewed_by: str | None
    reviewed_at: datetime | None
    created_at: datetime


class DocStateOut(CamelSchema):
    """One line of the partner's checklist (R06)."""

    required: RequiredDocumentOut
    status: str = Field(..., description="MISSING · PENDING · APPROVED · REJECTED · EXPIRED")
    document: DocumentOut | None
    replacement: DocumentOut | None = Field(
        None, description="A renewal waiting for review (or rejected)"
    )


class ApplicationOut(CamelSchema):
    id: str
    status: str
    submitted_at: datetime
    first_submitted_at: datetime
    notes: str = Field(..., description="Message to the partner (changes needed / rejected)")
    claimed_by: str | None
    claimed_until: datetime | None
    decided_by: str | None
    decided_at: datetime | None


class StepsOut(CamelSchema):
    role: bool
    alternate_phone: bool
    email: bool
    profile: bool
    documents: bool


class KycStatusOut(CamelSchema):
    """Everything the partner app needs for R04 to R07 and R16."""

    profile: PartnerProfileOut
    steps: StepsOut
    can_edit: bool = Field(..., description="Details can be changed (not while in review)")
    can_submit: bool
    documents: list[DocStateOut]
    application: ApplicationOut | None


# --- Admin ---


class ApplicationRowOut(CamelSchema):
    id: str
    partner_id: str
    full_name: str
    role: str
    phone: str
    status: str
    submitted_at: datetime
    first_submitted_at: datetime
    waiting_hours: int
    pending_documents: int
    claimed_by: str | None
    claimed_until: datetime | None
    claimed_by_me: bool


class ApplicationDetailOut(CamelSchema):
    application: ApplicationOut
    partner: PartnerProfileOut
    documents: list[DocStateOut]
    claimed_by_me: bool
    can_approve: bool
    missing_documents: list[str]


class AddPartnerIn(StrictIn):
    """Manual add (§6.3): saved APPROVED; documents are uploaded and checked by the admin."""

    role: RoleIn
    phone: str = Field(..., max_length=20, description="Login number (primary)")
    alternate_phone: str = Field(..., max_length=20)
    email: str = Field(..., max_length=254, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    full_name: str = Field(..., min_length=2, max_length=80)
    dob: date
    gender: GenderIn
    photo_key: str = Field(..., min_length=1, max_length=255)
    address: str = Field(..., min_length=5, max_length=300)
    lat: Latitude
    lng: Longitude
    languages: list[Tag] = Field(..., min_length=1, max_length=8)
    skills: list[Tag] = Field(default_factory=list, max_length=20)
    emergency_name: str = Field(..., min_length=2, max_length=80)
    emergency_phone: str = Field(..., max_length=20)
    documents: list[DocumentIn] = Field(..., min_length=1, max_length=20)
    checked: bool = Field(..., description="The admin confirms every document was checked")


class RejectDocumentIn(StrictIn):
    reason: Reason


class NoteIn(StrictIn):
    note: str = Field("", max_length=1000)
