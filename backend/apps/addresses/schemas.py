"""Request/response schemas for addresses."""

import datetime as dt
from decimal import Decimal

from pydantic import Field

from common.schemas import CamelSchema, Latitude, Longitude, StrictIn


class AddressIn(StrictIn):
    member_id: str = Field(..., max_length=36)
    label: str = Field(..., min_length=1, max_length=40)
    line1: str = Field(..., min_length=5, max_length=200, description="house, street, area, PIN")
    landmark: str = Field(..., max_length=120)
    notes: str = Field(..., max_length=300, description="gate, floor, lift…")
    lat: Latitude
    lng: Longitude


class AddressOut(CamelSchema):
    id: str
    member_id: str
    label: str
    line1: str
    landmark: str
    notes: str
    lat: Decimal
    lng: Decimal
    in_service_area: bool = Field(..., description="false → bookings here are refused")
    created_at: dt.datetime
