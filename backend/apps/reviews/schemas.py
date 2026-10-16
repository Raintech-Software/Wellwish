"""Reviews and support ticket schemas (ARCHITECTURE §6.11, §10.3)."""

import datetime as dt
from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, Reason, StrictIn

ReviewTag = Literal[
    "ON_TIME", "KIND", "HELPFUL", "PROFESSIONAL", "GOOD_COMMUNICATION", "LATE", "RUDE", "UNHELPFUL"
]


class ReviewIn(StrictIn):
    stars: int = Field(..., ge=1, le=5)
    tags: list[ReviewTag] = Field(default_factory=list, max_length=8)
    comment: str = Field("", max_length=500)


class ReviewOut(CamelSchema):
    stars: int
    tags: list[str]
    comment: str
    created_at: dt.datetime


class PartnerReviewOut(ReviewOut):
    """R15: a review the partner sees (no names)."""

    service_name: str
    service_name_hi: str = Field("", description="The service in Hindi, when it has one (9.1)")
    service_name_or: str = Field("", description="The service in Odia, when it has one (9.1)")


class ReportIn(StrictIn):
    text: str = Field(..., min_length=5, max_length=1000)


class TicketReplyOut(CamelSchema):
    by: str = Field(..., description="STAFF")
    name: str
    text: str
    at: dt.datetime


class TicketOut(CamelSchema):
    id: str
    text: str
    status: str
    replies: list[TicketReplyOut]
    created_at: dt.datetime


class AdminTicketOut(TicketOut):
    booking_id: str | None
    code: str
    patient_name: str
    patient_phone: str
    partner_name: str
    closed_at: dt.datetime | None


class TicketReplyIn(StrictIn):
    text: str = Field(..., min_length=2, max_length=1000)


class AdminReviewOut(ReviewOut):
    id: str
    booking_id: str
    code: str
    partner_id: str
    partner_name: str
    status: str
    hidden_reason: str


class ReviewModerateIn(StrictIn):
    reason: Reason
