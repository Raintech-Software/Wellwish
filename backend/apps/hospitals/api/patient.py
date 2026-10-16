"""Patient app: nearby hospitals, hospital detail, the doctor directory and doctor profiles
(P06-P09, §6.7). Inactive hospitals and doctors are hidden ("not found")."""

from typing import Any
from uuid import UUID

from django.http import HttpRequest
from ninja import Query, Router
from ninja.pagination import paginate

from apps.files.services import view_url
from apps.hospitals import selectors
from apps.hospitals.api.staff import speciality_out
from apps.hospitals.models import Doctor, Hospital
from apps.hospitals.schemas import (
    HospitalBrief,
    NearbyHospitalsOut,
    PatientDoctorOut,
    PatientHospitalDetailOut,
    PatientHospitalOut,
)
from common.pagination import Mapped, WWPagination
from common.schemas import Latitude, Longitude, RadiusKm

router = Router(tags=["patient"])


def _fields(h: Hospital) -> dict[str, Any]:
    distance = getattr(h, "distance_km", None)
    return {
        "id": str(h.pk),
        "name": h.name,
        "type": h.type,
        "address": h.address,
        "city": h.city,
        "lat": h.lat,
        "lng": h.lng,
        "phone": h.phone,
        "opd_hours": h.opd_hours,
        "photo_url": view_url(h.photo_key) if h.photo_key else None,
        "distance_km": round(float(distance), 1) if distance is not None else None,
        "doctor_count": getattr(h, "doctor_count", 0),
    }


def doctor_out(d: Doctor) -> PatientDoctorOut:
    """`d` comes from `selectors.patient_doctors()` (with `active_hospitals`)."""
    return PatientDoctorOut(
        id=str(d.pk),
        full_name=d.full_name,
        photo_url=view_url(d.photo_key) if d.photo_key else None,
        speciality=speciality_out(d.speciality),
        qualifications=d.qualifications,
        opd_info=d.opd_info,
        languages=list(d.languages or []),
        hospitals=[
            HospitalBrief(id=str(h.pk), name=h.name)
            for h in d.active_hospitals  # type: ignore[attr-defined]
        ],
    )


@router.get(
    "/hospitals/nearby",
    response=NearbyHospitalsOut,
    by_alias=True,
    operation_id="patientHospitalsNearby",
)
def nearby(
    request: HttpRequest,
    lat: Latitude | None = None,
    lng: Longitude | None = None,
    radius_km: RadiusKm | None = Query(None, alias="radiusKm"),  # noqa: B008
    speciality_id: UUID | None = Query(None, alias="specialityId"),  # noqa: B008
    q: str = Query("", max_length=60),
) -> NearbyHospitalsOut:
    """P06: hospitals within 10 km of `lat`/`lng` (the phone's location or a saved address),
    closest first, widened to 25 km if fewer than 5 are found. Without a location: every
    active hospital by name. `q` matches the hospital, the city or a doctor's name."""
    rows, radius = selectors.patient_nearby(
        lat=float(lat) if lat is not None else None,
        lng=float(lng) if lng is not None else None,
        radius_km=float(radius_km) if radius_km is not None else None,
        speciality_id=str(speciality_id) if speciality_id else None,
        q=q.strip(),
    )
    return NearbyHospitalsOut(
        radius_km=radius, items=[PatientHospitalOut(**_fields(h)) for h in rows]
    )


@router.get(
    "/hospitals/{uuid:hospital_id}",
    response=PatientHospitalDetailOut,
    by_alias=True,
    operation_id="patientHospitalGet",
)
def hospital_detail(request: HttpRequest, hospital_id: UUID) -> PatientHospitalDetailOut:
    """P07: address, map pin, OPD hours, departments and its doctors."""
    hospital = selectors.patient_hospital(str(hospital_id))
    doctors = list(selectors.patient_doctors(hospital_id=str(hospital.pk)))
    hospital.doctor_count = len(doctors)  # type: ignore[attr-defined]
    return PatientHospitalDetailOut(
        **_fields(hospital),
        departments=list(hospital.departments or []),
        doctors=[doctor_out(d) for d in doctors],
    )


@router.get(
    "/doctors",
    response=list[PatientDoctorOut],
    by_alias=True,
    operation_id="patientDoctorList",
)
@paginate(WWPagination)
def doctors(
    request: HttpRequest,
    q: str = Query("", max_length=60),
    speciality_id: UUID | None = Query(None, alias="specialityId"),  # noqa: B008
    hospital_id: UUID | None = Query(None, alias="hospitalId"),  # noqa: B008
) -> list[PatientDoctorOut]:
    """P08: active doctors by name. `q` matches the name or the speciality."""
    rows = selectors.patient_doctors(
        q=q.strip(),
        speciality_id=str(speciality_id) if speciality_id else None,
        hospital_id=str(hospital_id) if hospital_id else None,
    )
    return Mapped(rows, doctor_out)  # type: ignore[return-value]


@router.get(
    "/doctors/{uuid:doctor_id}",
    response=PatientDoctorOut,
    by_alias=True,
    operation_id="patientDoctorGet",
)
def doctor_detail(request: HttpRequest, doctor_id: UUID) -> PatientDoctorOut:
    """P09: photo, speciality, hospitals, OPD days."""
    return doctor_out(selectors.patient_doctor(str(doctor_id)))
