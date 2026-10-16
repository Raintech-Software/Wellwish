"""Admin: hospitals, doctors, specialities (/v1/admin/...). View: directory.view.
Change: directory.manage."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Query, Router

from apps.files.services import view_url
from apps.hospitals import selectors, services
from apps.hospitals.models import Doctor, Hospital, Speciality
from apps.hospitals.schemas import (
    DoctorIn,
    DoctorOut,
    HospitalBrief,
    HospitalIn,
    HospitalOut,
    SpecialityIn,
    SpecialityOut,
)
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.request import client_ip
from common.schemas import OkOut

router = Router(tags=["admin"])


def speciality_out(s: Speciality) -> SpecialityOut:
    return SpecialityOut(
        id=str(s.pk),
        name=s.name,
        name_hi=s.name_hi,
        name_or=s.name_or,
        icon=s.icon,
        doctor_count=getattr(s, "doctor_count", 0),
    )


def hospital_out(h: Hospital) -> HospitalOut:
    return HospitalOut(
        id=str(h.pk),
        name=h.name,
        type=h.type,
        address=h.address,
        city=h.city,
        lat=h.lat,
        lng=h.lng,
        phone=h.phone,
        opd_hours=h.opd_hours,
        departments=list(h.departments or []),
        photo_key=h.photo_key,
        photo_url=view_url(h.photo_key) if h.photo_key else None,
        is_active=h.is_active,
        doctor_count=getattr(h, "doctor_count", 0),
    )


def doctor_out(d: Doctor) -> DoctorOut:
    return DoctorOut(
        id=str(d.pk),
        full_name=d.full_name,
        photo_key=d.photo_key,
        photo_url=view_url(d.photo_key) if d.photo_key else None,
        speciality=speciality_out(d.speciality),
        qualifications=d.qualifications,
        opd_info=d.opd_info,
        languages=list(d.languages or []),
        hospitals=[HospitalBrief(id=str(h.pk), name=h.name) for h in d.hospitals.all()],
        is_active=d.is_active,
    )


# --- Specialities ---


@router.get(
    "/specialities",
    response=list[SpecialityOut],
    by_alias=True,
    operation_id="adminSpecialitiesList",
)
@staff_permission("directory.view")
def list_specialities(request: HttpRequest) -> list[SpecialityOut]:
    return [speciality_out(s) for s in selectors.specialities()]


@router.post(
    "/specialities", response=SpecialityOut, by_alias=True, operation_id="adminSpecialitiesCreate"
)
@staff_permission("directory.manage")
def create_speciality(request: HttpRequest, data: SpecialityIn) -> SpecialityOut:
    s = services.save_speciality(
        actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
    )
    return speciality_out(s)


@router.put(
    "/specialities/{uuid:speciality_id}",
    response=SpecialityOut,
    by_alias=True,
    operation_id="adminSpecialitiesUpdate",
)
@staff_permission("directory.manage")
def update_speciality(
    request: HttpRequest, speciality_id: UUID, data: SpecialityIn
) -> SpecialityOut:
    s = services.save_speciality(
        actor=acting_staff(request),
        data=data.model_dump(),
        ip=client_ip(request),
        speciality_id=str(speciality_id),
    )
    return speciality_out(s)


@router.delete(
    "/specialities/{uuid:speciality_id}",
    response=OkOut,
    by_alias=True,
    operation_id="adminSpecialitiesDelete",
)
@staff_permission("directory.manage")
def delete_speciality(request: HttpRequest, speciality_id: UUID) -> OkOut:
    """Refused (409 IN_USE) while a doctor has this speciality."""
    services.delete_speciality(
        actor=acting_staff(request), speciality_id=str(speciality_id), ip=client_ip(request)
    )
    return OkOut()


# --- Hospitals ---


@router.get(
    "/hospitals", response=list[HospitalOut], by_alias=True, operation_id="adminHospitalsList"
)
@staff_permission("directory.view")
def list_hospitals(request: HttpRequest, q: str = "") -> list[HospitalOut]:
    return [hospital_out(h) for h in selectors.hospitals(q=q)]


@router.post("/hospitals", response=HospitalOut, by_alias=True, operation_id="adminHospitalsCreate")
@staff_permission("directory.manage")
def create_hospital(request: HttpRequest, data: HospitalIn) -> HospitalOut:
    h = services.save_hospital(
        actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
    )
    return hospital_out(h)


@router.put(
    "/hospitals/{uuid:hospital_id}",
    response=HospitalOut,
    by_alias=True,
    operation_id="adminHospitalsUpdate",
)
@staff_permission("directory.manage")
def update_hospital(request: HttpRequest, hospital_id: UUID, data: HospitalIn) -> HospitalOut:
    h = services.save_hospital(
        actor=acting_staff(request),
        data=data.model_dump(),
        ip=client_ip(request),
        hospital_id=str(hospital_id),
    )
    return hospital_out(h)


@router.post(
    "/hospitals/{uuid:hospital_id}/deactivate",
    response=HospitalOut,
    by_alias=True,
    operation_id="adminHospitalsDeactivate",
)
@staff_permission("directory.manage")
def deactivate_hospital(request: HttpRequest, hospital_id: UUID) -> HospitalOut:
    return hospital_out(
        services.set_hospital_active(
            actor=acting_staff(request),
            hospital_id=str(hospital_id),
            active=False,
            ip=client_ip(request),
        )
    )


@router.post(
    "/hospitals/{uuid:hospital_id}/activate",
    response=HospitalOut,
    by_alias=True,
    operation_id="adminHospitalsActivate",
)
@staff_permission("directory.manage")
def activate_hospital(request: HttpRequest, hospital_id: UUID) -> HospitalOut:
    return hospital_out(
        services.set_hospital_active(
            actor=acting_staff(request),
            hospital_id=str(hospital_id),
            active=True,
            ip=client_ip(request),
        )
    )


@router.delete(
    "/hospitals/{uuid:hospital_id}",
    response=OkOut,
    by_alias=True,
    operation_id="adminHospitalsDelete",
)
@staff_permission("directory.manage")
def delete_hospital(request: HttpRequest, hospital_id: UUID) -> OkOut:
    """Refused (409 IN_USE) if used in a booking or doctors are listed there."""
    services.delete_hospital(
        actor=acting_staff(request), hospital_id=str(hospital_id), ip=client_ip(request)
    )
    return OkOut()


# --- Doctors ---


@router.get("/doctors", response=list[DoctorOut], by_alias=True, operation_id="adminDoctorsList")
@staff_permission("directory.view")
def list_doctors(
    request: HttpRequest,
    q: str = "",
    speciality_id: UUID | None = Query(None, alias="specialityId"),  # noqa: B008
    hospital_id: UUID | None = Query(None, alias="hospitalId"),  # noqa: B008
) -> list[DoctorOut]:
    qs = selectors.doctors(
        q=q,
        speciality_id=str(speciality_id) if speciality_id else None,
        hospital_id=str(hospital_id) if hospital_id else None,
    )
    return [doctor_out(d) for d in qs]


@router.post("/doctors", response=DoctorOut, by_alias=True, operation_id="adminDoctorsCreate")
@staff_permission("directory.manage")
def create_doctor(request: HttpRequest, data: DoctorIn) -> DoctorOut:
    d = services.save_doctor(
        actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
    )
    return doctor_out(selectors.get_doctor(str(d.pk)))


@router.put(
    "/doctors/{uuid:doctor_id}",
    response=DoctorOut,
    by_alias=True,
    operation_id="adminDoctorsUpdate",
)
@staff_permission("directory.manage")
def update_doctor(request: HttpRequest, doctor_id: UUID, data: DoctorIn) -> DoctorOut:
    services.save_doctor(
        actor=acting_staff(request),
        data=data.model_dump(),
        ip=client_ip(request),
        doctor_id=str(doctor_id),
    )
    return doctor_out(selectors.get_doctor(str(doctor_id)))


@router.post(
    "/doctors/{uuid:doctor_id}/deactivate",
    response=DoctorOut,
    by_alias=True,
    operation_id="adminDoctorsDeactivate",
)
@staff_permission("directory.manage")
def deactivate_doctor(request: HttpRequest, doctor_id: UUID) -> DoctorOut:
    services.set_doctor_active(
        actor=acting_staff(request), doctor_id=str(doctor_id), active=False, ip=client_ip(request)
    )
    return doctor_out(selectors.get_doctor(str(doctor_id)))


@router.post(
    "/doctors/{uuid:doctor_id}/activate",
    response=DoctorOut,
    by_alias=True,
    operation_id="adminDoctorsActivate",
)
@staff_permission("directory.manage")
def activate_doctor(request: HttpRequest, doctor_id: UUID) -> DoctorOut:
    services.set_doctor_active(
        actor=acting_staff(request), doctor_id=str(doctor_id), active=True, ip=client_ip(request)
    )
    return doctor_out(selectors.get_doctor(str(doctor_id)))


@router.delete(
    "/doctors/{uuid:doctor_id}", response=OkOut, by_alias=True, operation_id="adminDoctorsDelete"
)
@staff_permission("directory.manage")
def delete_doctor(request: HttpRequest, doctor_id: UUID) -> OkOut:
    """Refused (409 IN_USE) once the doctor is used in a booking."""
    services.delete_doctor(
        actor=acting_staff(request), doctor_id=str(doctor_id), ip=client_ip(request)
    )
    return OkOut()
