"""Request/response schemas for services."""

from typing import Literal
from uuid import UUID

from pydantic import Field, model_validator

from common.schemas import CamelSchema, StrictIn

PartnerTypeIn = Literal["COMPANION", "NURSE"]
VisitTypeIn = Literal["HOSPITAL_VISIT", "HOME_VISIT", "ERRAND"]


class ServiceOut(CamelSchema):
    id: str
    name: str
    name_hi: str
    name_or: str
    description: str
    description_hi: str
    description_or: str
    partner_type: str
    visit_type: str
    price_paise: int
    booking_fee_paise: int
    balance_paise: int = Field(..., description="price minus booking fee, paid to the partner")
    duration_min: int
    docs_required: bool
    is_active: bool
    sort: int


class ServiceIn(StrictIn):
    name: str = Field(..., min_length=2, max_length=80)
    name_hi: str = Field("", max_length=80)
    name_or: str = Field("", max_length=80)
    description: str = Field("", max_length=160)
    description_hi: str = Field("", max_length=160)
    description_or: str = Field("", max_length=160)
    partner_type: PartnerTypeIn
    visit_type: VisitTypeIn
    price_paise: int = Field(..., gt=0, le=10_000_000, description="₹1 = 100 paise")
    booking_fee_paise: int = Field(..., ge=100, description="At least ₹1 (Razorpay's minimum)")
    duration_min: int = Field(..., ge=15, le=24 * 60)
    docs_required: bool = False

    @model_validator(mode="after")
    def fee_not_above_price(self) -> "ServiceIn":
        if self.booking_fee_paise > self.price_paise:
            raise ValueError("The booking fee can't be more than the price.")
        return self


class ReorderIn(StrictIn):
    ids: list[UUID] = Field(..., min_length=1, max_length=500)
