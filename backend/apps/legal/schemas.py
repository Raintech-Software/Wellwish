"""Schemas for the legal pages (ARCHITECTURE §6.20)."""

from datetime import datetime
from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, StrictIn

LegalKindIn = Literal["TERMS", "PRIVACY", "REFUNDS", "PARTNER_TERMS"]

TITLE_MAX = 120
BODY_MAX = 100_000


class LegalSummaryOut(CamelSchema):
    """One document on the admin's Legal pages list (its newest version)."""

    kind: LegalKindIn
    title: str = Field(..., description="The English title")
    version: int
    consent_version: str
    asked_again: bool = Field(..., description="Whether the newest version asked everyone again")
    languages: list[str] = Field(..., description="Languages written (en, hi, or)")
    published_at: datetime
    published_by: str | None = Field(None, description="Empty for the first drafts")
    public_url: str


class LegalVersionOut(CamelSchema):
    version: int
    asked_again: bool
    published_at: datetime
    published_by: str | None


class LegalDocumentOut(CamelSchema):
    kind: LegalKindIn
    version: int
    is_newest: bool
    consent_version: str
    asked_again: bool
    title_en: str
    title_hi: str
    title_or: str
    body_en: str
    body_hi: str
    body_or: str
    published_at: datetime
    published_by: str | None
    public_url: str


class LegalPublishIn(StrictIn):
    """A new version. Hindi and Odia may stay empty (the English text is shown); a language is
    either complete (title and text) or empty."""

    expected_version: int = Field(..., ge=1, description="The newest version you edited")
    ask_again: bool = Field(
        ..., description="Everyone accepts it again at their next app open (else a small fix)"
    )
    title_en: str = Field(..., min_length=1, max_length=TITLE_MAX)
    title_hi: str = Field("", max_length=TITLE_MAX)
    title_or: str = Field("", max_length=TITLE_MAX)
    body_en: str = Field(..., min_length=1, max_length=BODY_MAX)
    body_hi: str = Field("", max_length=BODY_MAX)
    body_or: str = Field("", max_length=BODY_MAX)
