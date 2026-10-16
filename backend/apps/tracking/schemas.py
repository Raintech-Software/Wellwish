"""Live location schemas (ARCHITECTURE §6.11, §10.3, §10.4)."""

import datetime as dt

from pydantic import AwareDatetime, Field

from apps.bookings.schemas import Coordinate
from common.schemas import CamelSchema, StrictIn


class TrackPointIn(StrictIn):
    """One point kept on the phone while it was offline."""

    lat: Coordinate
    lng: Coordinate
    accuracy: float = Field(..., ge=0, le=100000, allow_inf_nan=False, description="Metres")
    mock: bool = Field(False, description="Android said it is a fake (mock) location")
    at: AwareDatetime = Field(
        ..., description="The phone's time (kept between the job's start and now)"
    )


class TrackBatchIn(StrictIn):
    points: list[TrackPointIn] = Field(..., max_length=2000)


class TrackBatchOut(CamelSchema):
    accepted: int = Field(
        ..., description="Points used (the others were inaccurate, fake or impossible)"
    )


class LiveLocationOut(CamelSchema):
    """P19 / the admins' live map: where the partner is now."""

    booking_id: str
    lat: str | None = Field(None, description="Empty until the first point")
    lng: str | None = None
    at: dt.datetime | None = None
    eta_min: int | None = Field(
        None, description="Minutes to where they're heading (a simple guess)"
    )
    step: str


class LiveJobOut(LiveLocationOut):
    code: str
    partner_name: str
    partner_phone: str
    partner_alternate_phone: str
    service_name: str
    member_name: str
    pickup_at: dt.datetime
    stale: bool = Field(..., description="No point for 2 minutes")


class TrackOut(CamelSchema):
    """A finished job's route (admin booking page)."""

    points: list[list[float]] = Field(..., description="[lat, lng] pairs")
    km: str
    started_at: dt.datetime | None
    ended_at: dt.datetime | None
