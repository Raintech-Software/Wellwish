"""Request/response schemas for patients."""

import datetime as dt
from typing import Annotated, Any, Literal

from pydantic import Field, StringConstraints

from apps.accounts.schemas import ConsentNeededOut
from apps.addresses.schemas import AddressOut
from apps.bookings.schemas import AdminBookingRowOut, BookingRowOut
from apps.documents.schemas import PatientDocumentOut
from common.schemas import CamelSchema, StrictIn

GenderIn = Literal["FEMALE", "MALE", "OTHER"]
LanguageIn = Literal["en", "hi", "or"]
RelationIn = Literal[
    "SELF", "MOTHER", "FATHER", "GRANDMOTHER", "GRANDFATHER", "SPOUSE", "CHILD", "SIBLING", "OTHER"
]
MobilityIn = Literal["", "WALKS_ALONE", "NEEDS_SUPPORT", "WHEELCHAIR"]
# The same words partners pick for the languages they speak, so the admin can match them.
MemberLanguageIn = Literal["", "Odia", "Hindi", "English", "Bengali", "Telugu"]


class PatientMeOut(CamelSchema):
    id: str
    phone: str
    full_name: str
    dob: dt.date | None
    gender: str
    language: str
    self_member_id: str
    profile_complete: bool = Field(..., description="false → show profile setup (P04)")
    consents_needed: list[ConsentNeededOut] = Field(
        ..., description="not empty → show the consent screen"
    )
    google_linked: bool


class PatientMeIn(StrictIn):
    full_name: str = Field(..., min_length=2, max_length=80)
    dob: dt.date
    gender: GenderIn
    language: LanguageIn


# --- Family members (§6.18) ---


class MemberIn(StrictIn):
    """Add or edit a family member (P28). Every field is sent; empty text = not given.
    For the account owner (`SELF`) the name, date of birth and gender also update the profile."""

    relation: RelationIn
    full_name: str = Field(..., min_length=2, max_length=80)
    dob: dt.date
    gender: GenderIn
    photo_key: str = Field(..., max_length=255, description="from photo-upload-url, or empty")
    phone: str = Field(..., max_length=20, description="their own mobile (optional)")
    language: MemberLanguageIn
    conditions: str = Field(..., max_length=500, description="e.g. diabetes, BP")
    allergies: str = Field(..., max_length=300)
    mobility: MobilityIn
    sensory_notes: str = Field(..., max_length=300, description="hearing or vision problems")
    emergency_name: str = Field(..., max_length=80, description="empty = the account owner")
    emergency_phone: str = Field(..., max_length=20)
    consent: bool = Field(
        ..., description="'I have their permission…' (required for everyone but yourself)"
    )


class MemberOut(CamelSchema):
    id: str
    relation: str
    is_self: bool
    full_name: str
    dob: dt.date | None
    age: int | None
    gender: str
    photo_key: str
    photo_url: str | None
    phone: str
    language: str
    conditions: str
    allergies: str
    mobility: str
    sensory_notes: str
    emergency_name: str
    emergency_phone: str
    consent_at: dt.datetime | None
    address_count: int
    document_count: int


class MemberPhotoUrlIn(StrictIn):
    mime: str = Field(..., max_length=40)
    size_bytes: int = Field(..., gt=0)


class MemberDetailOut(CamelSchema):
    """P29: the member, their addresses, latest documents and bookings."""

    member: MemberOut
    addresses: list[AddressOut]
    documents: list[PatientDocumentOut]
    bookings: list[BookingRowOut] = Field(
        ..., description="Upcoming (soonest first), then the latest past ones; at most 5"
    )


class DeletionRequestOut(CamelSchema):
    due_at: dt.datetime = Field(..., description="the data is removed after this time")


# --- Admin: patients (§9.1) ---


class PatientRowOut(CamelSchema):
    """Built from a `User` from `selectors.patients()` (annotated with the name and counts)."""

    id: str
    phone: str
    full_name: str
    status: str
    member_count: int
    created_at: dt.datetime
    deletion_due_at: dt.datetime | None
    blocked_at: dt.datetime | None = Field(
        None, description="blocked from the patient app by an admin (§9.1)"
    )

    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.id)


class AdminMemberOut(CamelSchema):
    """What the admin sees of a member: no health notes (conditions, allergies, getting around,
    hearing/vision: only the assigned partner sees those, §6.18)."""

    id: str
    relation: str
    full_name: str
    age: int | None
    gender: str
    phone: str
    language: str
    is_active: bool


class PatientDetailOut(CamelSchema):
    patient: PatientRowOut
    dob: dt.date | None
    gender: str
    language: str
    members: list[AdminMemberOut]
    addresses: list[AddressOut]
    documents_visible: bool = Field(
        ..., description="false: this role may not see patient documents (§9.2)"
    )
    documents: list[PatientDocumentOut]
    bookings_visible: bool = Field(..., description="false: this role may not see bookings")
    bookings: list[AdminBookingRowOut] = Field(..., description="Latest first (at most 100)")
    blocked_reason: str = Field("", description="why it was blocked (when blocked)")


AdminReason = Annotated[str, StringConstraints(strip_whitespace=True, min_length=5, max_length=300)]


class PatientReasonIn(StrictIn):
    reason: AdminReason = Field(..., description="why (5+ letters, logged)")


class AdminPatientIn(PatientMeIn):
    """Edit on the patient's request (§9.1): the profile screen's details and why."""

    reason: AdminReason = Field(..., description="e.g. asked by phone on 13 Oct (logged)")


class DocumentReasonIn(StrictIn):
    reason: Annotated[
        str, StringConstraints(strip_whitespace=True, min_length=5, max_length=300)
    ] = Field(..., description="why you need to open it (5+ letters, logged)")


class AccountDeletionOut(CamelSchema):
    id: str
    phone_last4: str
    status: str
    created_at: dt.datetime
    due_at: dt.datetime
    cancelled_at: dt.datetime | None
    done_at: dt.datetime | None
    kept_partner: bool

    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.id)
