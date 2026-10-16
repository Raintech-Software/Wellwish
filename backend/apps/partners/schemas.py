"""Schemas for partner registration and the admin partner pages.

Enum-like fields use plain `str` with a pattern (no enum defaults): the generated Dart client
can't compile enum or list defaults (Phase 2 report).
"""

from datetime import date, datetime
from typing import Annotated, Any, Literal

from pydantic import Field, StringConstraints

from common.schemas import CamelSchema, Latitude, Longitude, Reason, StrictIn

RoleIn = Literal["COMPANION", "NURSE"]
GenderIn = Literal["FEMALE", "MALE", "OTHER"]
Tag = Annotated[str, StringConstraints(strip_whitespace=True, min_length=1, max_length=40)]
OtpCode = Annotated[str, StringConstraints(pattern=r"^[0-9]{6}$")]


class StartIn(StrictIn):
    role: RoleIn


class PhoneIn(StrictIn):
    phone: str = Field(..., max_length=20, description="Indian mobile, e.g. 9876543210")


class CodeIn(StrictIn):
    code: OtpCode


class EmailIn(StrictIn):
    email: str = Field(..., max_length=254, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


class EmailSentOut(CamelSchema):
    resend_after_seconds: int
    expires_in_seconds: int


class ProfileIn(StrictIn):
    """R05 (§6.3 step 5). The photo is uploaded first (`/kyc/upload-url`, purpose partner_photo)."""

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


class AvailabilityIn(StrictIn):
    available_today: bool


class PhoneOut(CamelSchema):
    kind: str
    phone: str
    verified: bool


class PartnerProfileOut(CamelSchema):
    id: str
    role: str
    status: str
    suspended_reason: str
    full_name: str
    dob: date | None
    gender: str
    photo_key: str
    photo_url: str | None = Field(None, description="Works for 5 minutes")
    email: str
    email_verified: bool
    address: str
    lat: str | None
    lng: str | None
    languages: list[str]
    skills: list[str]
    emergency_name: str
    emergency_phone: str
    available_today: bool
    added_by_admin: bool
    phones: list[PhoneOut]
    created_at: datetime
    approved_at: datetime | None
    deletion_due_at: datetime | None = Field(
        None, description="Asked to delete their account: when the personal data is erased (§6.20)"
    )


class AvailabilityOut(CamelSchema):
    available_today: bool
    selfie_today: bool = Field(False, description="Today's selfie is taken (needed to switch on)")


class SelfieIn(StrictIn):
    file_key: str = Field(..., max_length=255, description="From the partner_selfie upload URL")


class AdminSelfieOut(CamelSchema):
    """Admin spot check: today's selfie next to the approved photo (§6.15)."""

    id: str
    partner_id: str
    partner_name: str
    role: str
    at: datetime
    selfie_url: str | None
    photo_url: str | None


# --- Admin ---


class PartnerRowOut(CamelSchema):
    id: str
    role: str
    status: str
    full_name: str
    phone: str
    alternate_phone: str
    email: str
    available_today: bool
    rating_avg: str | None
    added_by_admin: bool
    documents_to_review: int
    created_at: datetime
    deleting: bool = Field(False, description="Asked to delete their account (§6.20)")

    # Built straight from PartnerProfile rows (the list is paginated as a queryset).
    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.pk)

    @staticmethod
    def resolve_phone(obj: Any) -> str:
        return str(obj.user.phone)

    @staticmethod
    def resolve_alternate_phone(obj: Any) -> str:
        return next((p.phone for p in obj.phones.all() if p.kind == "ALTERNATE"), "")

    @staticmethod
    def resolve_available_today(obj: Any) -> bool:
        from apps.partners.selectors import is_available_today

        return is_available_today(obj)

    @staticmethod
    def resolve_rating_avg(obj: Any) -> str | None:
        return None if obj.rating_avg is None else str(obj.rating_avg)

    @staticmethod
    def resolve_documents_to_review(obj: Any) -> int:
        return int(getattr(obj, "to_review", 0))

    @staticmethod
    def resolve_deleting(obj: Any) -> bool:
        return bool(getattr(obj, "deleting", False))


class PartnerEditIn(StrictIn):
    role: RoleIn
    full_name: str = Field(..., min_length=2, max_length=80)
    dob: date
    gender: GenderIn
    address: str = Field(..., min_length=5, max_length=300)
    lat: Latitude
    lng: Longitude
    languages: list[Tag] = Field(..., min_length=1, max_length=8)
    skills: list[Tag] = Field(default_factory=list, max_length=20)
    emergency_name: str = Field(..., min_length=2, max_length=80)
    emergency_phone: str = Field(..., max_length=20)


class ReasonIn(StrictIn):
    reason: Reason


class HistoryOut(CamelSchema):
    at: datetime
    action: str
    by: str | None = Field(None, description="Staff name; empty = the partner or the system")
    before: str | None
    after: str | None
    reason: str


class PartnerDeletionOut(CamelSchema):
    """ "Delete my account" (§6.20)."""

    due_at: datetime = Field(..., description="The personal data is erased after this time")
    done: bool = Field(..., description="Nothing to wait for (never registered): already erased")
