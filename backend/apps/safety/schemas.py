"""SOS and share link schemas (ARCHITECTURE §6.15, §10.3)."""

import datetime as dt

from pydantic import Field

from apps.bookings.schemas import Coordinate
from common.schemas import CamelSchema, Reason, StrictIn


class SosIn(StrictIn):
    lat: Coordinate | None = None
    lng: Coordinate | None = None
    mock: bool = Field(
        False, description="Android said the position is fake: the SOS still goes, flagged"
    )


class SosOut(CamelSchema):
    id: str
    status: str
    created_at: dt.datetime


class AdminSosOut(CamelSchema):
    id: str
    booking_id: str
    code: str
    side: str = Field(..., description="PATIENT or PARTNER: who pressed it")
    status: str
    lat: str | None
    lng: str | None
    mock_location: bool = Field(False, description="the phone said its position was fake")
    partner_name: str
    partner_phone: str
    member_name: str
    raised_at: dt.datetime
    ack_by: str
    ack_at: dt.datetime | None
    resolved_at: dt.datetime | None
    notes: str


class SosResolveIn(StrictIn):
    notes: Reason


class ShareLinkOut(CamelSchema):
    url: str
    expires_at: dt.datetime


class PublicTrackOut(CamelSchema):
    """What the share link shows (no phones, no address, no health details)."""

    partner_first_name: str
    service_name: str
    service_name_hi: str = Field("", description="The service in Hindi, when it has one (9.1)")
    service_name_or: str = Field("", description="The service in Odia, when it has one (9.1)")
    status: str
    step: str
    lat: str | None = None
    lng: str | None = None
    at: dt.datetime | None = None
    eta_min: int | None = None
