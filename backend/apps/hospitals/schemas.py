"""Request/response schemas for the directory."""

from decimal import Decimal
from typing import Annotated, Literal
from uuid import UUID

from pydantic import Field, StringConstraints

from common.schemas import CamelSchema, Latitude, Longitude, StrictIn

HospitalTypeIn = Literal["HOSPITAL", "CLINIC", "DIAGNOSTIC"]
ShortText = Annotated[str, StringConstraints(strip_whitespace=True, min_length=1, max_length=60)]


class SpecialityOut(CamelSchema):
    id: str
    name: str
    name_hi: str
    name_or: str
    icon: str
    doctor_count: int = 0


class SpecialityIn(StrictIn):
    name: str = Field(..., min_length=2, max_length=60)
    name_hi: str = Field("", max_length=60)
    name_or: str = Field("", max_length=60)
    icon: str = Field("", max_length=40)


class HospitalOut(CamelSchema):
    id: str
    name: str
    type: str
    address: str
    city: str
    lat: Decimal
    lng: Decimal
    phone: str
    opd_hours: str
    departments: list[str]
    photo_key: str
    photo_url: str | None = Field(None, description="Works for 5 minutes")
    is_active: bool
    doctor_count: int = 0


class HospitalIn(StrictIn):
    name: str = Field(..., min_length=2, max_length=120)
    type: HospitalTypeIn
    address: str = Field(..., min_length=5, max_length=300)
    city: str = Field("", max_length=60)
    lat: Latitude
    lng: Longitude
    phone: str = Field("", max_length=20)
    opd_hours: str = Field("", max_length=300)
    departments: list[ShortText] = Field(default_factory=list, max_length=40)
    photo_key: str = Field("", max_length=255)


class HospitalBrief(CamelSchema):
    id: str
    name: str


class DoctorOut(CamelSchema):
    id: str
    full_name: str
    photo_key: str
    photo_url: str | None = None
    speciality: SpecialityOut
    qualifications: str
    opd_info: str
    languages: list[str]
    hospitals: list[HospitalBrief]
    is_active: bool


class DoctorIn(StrictIn):
    full_name: str = Field(..., min_length=2, max_length=80)
    speciality_id: UUID
    hospital_ids: list[UUID] = Field(default_factory=list, max_length=20)
    qualifications: str = Field("", max_length=200)
    opd_info: str = Field("", max_length=300)
    languages: list[ShortText] = Field(default_factory=list, max_length=10)
    photo_key: str = Field("", max_length=255)


# --- Patient app (P06-P09) ---


class PatientHospitalOut(CamelSchema):
    """A hospital card in the nearby list and on the map."""

    id: str
    name: str
    type: str
    address: str
    city: str
    lat: Decimal
    lng: Decimal
    phone: str
    opd_hours: str
    photo_url: str | None = Field(None, description="Works for 5 minutes")
    distance_km: float | None = Field(None, description="None when no location was given")
    doctor_count: int


class NearbyHospitalsOut(CamelSchema):
    radius_km: float | None = Field(
        None, description="The radius searched (10 km, or 25 km if fewer than 5 were found)"
    )
    items: list[PatientHospitalOut]


class PatientDoctorOut(CamelSchema):
    """A doctor in the directory (P08) and the doctor profile (P09)."""

    id: str
    full_name: str
    photo_url: str | None = None
    speciality: SpecialityOut
    qualifications: str
    opd_info: str
    languages: list[str]
    hospitals: list[HospitalBrief] = Field(..., description="Active hospitals only")


class PatientHospitalDetailOut(PatientHospitalOut):
    """Hospital detail (P07): departments and its active doctors."""

    departments: list[str]
    doctors: list[PatientDoctorOut]
