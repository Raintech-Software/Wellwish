"""All writes for the directory. Every change is in the audit log.

Delete rules (§9.1): a hospital or doctor used in a booking is only deactivated; a hospital with
doctors must lose them first; a speciality can be deleted only if no doctor has it.
"""

from decimal import Decimal
from typing import Any

from django.db import transaction

from apps.audit.services import record
from apps.files.services import confirm_upload
from apps.hospitals.models import Doctor, DoctorHospital, Hospital, Speciality
from apps.staff.models import StaffUser
from common import usage
from common.errors import ApiError, Conflict, NotFound


class InUse(Conflict):
    code = "IN_USE"
    message = "This is in use, so it can't be deleted. Deactivate it instead."


class InvalidDirectoryEntry(ApiError):
    status = 422
    code = "INVALID_ENTRY"
    message = "Please check the details."


def _jsonable(value: Any) -> Any:
    return str(value) if isinstance(value, Decimal) else value


def _diff(before: dict[str, Any], after: dict[str, Any]) -> tuple[dict[str, Any], dict[str, Any]]:
    changed = [k for k in after if before.get(k) != after[k]]
    return (
        {k: _jsonable(before.get(k)) for k in changed},
        {k: _jsonable(after[k]) for k in changed},
    )


# --- Specialities ---

SPECIALITY_FIELDS = ("name", "name_hi", "name_or", "icon")


@transaction.atomic
def save_speciality(
    *, actor: StaffUser, data: dict[str, Any], ip: str, speciality_id: str | None = None
) -> Speciality:
    name = data["name"].strip()
    clash = Speciality.objects.filter(name__iexact=name)
    if speciality_id:
        clash = clash.exclude(pk=speciality_id)
    if clash.exists():
        raise InvalidDirectoryEntry(code="NAME_TAKEN", message="This speciality already exists.")
    if speciality_id:
        speciality = Speciality.objects.select_for_update().filter(pk=speciality_id).first()
        if speciality is None:
            raise NotFound()
        before = {f: getattr(speciality, f) for f in SPECIALITY_FIELDS}
    else:
        speciality, before = Speciality(), {}
    for field in SPECIALITY_FIELDS:
        setattr(speciality, field, name if field == "name" else data[field])
    speciality.save()
    old, new = _diff(before, {f: getattr(speciality, f) for f in SPECIALITY_FIELDS})
    if new:
        action = "speciality.updated" if speciality_id else "speciality.created"
        record(actor, action, speciality, before=old or None, after=new, ip=ip)
    return speciality


@transaction.atomic
def delete_speciality(*, actor: StaffUser, speciality_id: str, ip: str) -> None:
    speciality = Speciality.objects.select_for_update().filter(pk=speciality_id).first()
    if speciality is None:
        raise NotFound()
    if speciality.doctors.exists():
        raise InUse(message="Doctors have this speciality, so it can't be deleted.")
    record(
        actor,
        "speciality.deleted",
        ("hospitals.speciality", speciality_id),
        before={"name": speciality.name},
        ip=ip,
    )
    speciality.delete()


# --- Hospitals ---

HOSPITAL_FIELDS = (
    "name",
    "type",
    "address",
    "city",
    "lat",
    "lng",
    "phone",
    "opd_hours",
    "departments",
    "photo_key",
)


@transaction.atomic
def save_hospital(
    *, actor: StaffUser, data: dict[str, Any], ip: str, hospital_id: str | None = None
) -> Hospital:
    if hospital_id:
        hospital = Hospital.objects.select_for_update().filter(pk=hospital_id).first()
        if hospital is None:
            raise NotFound()
        before = {f: getattr(hospital, f) for f in HOSPITAL_FIELDS}
    else:
        hospital, before = Hospital(), {}
    if data["photo_key"] and data["photo_key"] != before.get("photo_key"):
        confirm_upload(data["photo_key"], purpose="hospital_photo")
    for field in HOSPITAL_FIELDS:
        setattr(hospital, field, data[field])
    hospital.save()
    hospital.refresh_from_db()  # decimals as stored (20.29 becomes 20.290000)
    old, new = _diff(before, {f: getattr(hospital, f) for f in HOSPITAL_FIELDS})
    if new:
        action = "hospital.updated" if hospital_id else "hospital.created"
        record(actor, action, hospital, before=old or None, after=new, ip=ip)
    return hospital


@transaction.atomic
def set_hospital_active(*, actor: StaffUser, hospital_id: str, active: bool, ip: str) -> Hospital:
    hospital = Hospital.objects.select_for_update().filter(pk=hospital_id).first()
    if hospital is None:
        raise NotFound()
    if hospital.is_active != active:
        hospital.is_active = active
        hospital.save(update_fields=["is_active", "updated_at"])
        record(
            actor,
            "hospital.activated" if active else "hospital.deactivated",
            hospital,
            before={"is_active": not active},
            after={"is_active": active},
            ip=ip,
        )
    return hospital


@transaction.atomic
def delete_hospital(*, actor: StaffUser, hospital_id: str, ip: str) -> None:
    hospital = Hospital.objects.select_for_update().filter(pk=hospital_id).first()
    if hospital is None:
        raise NotFound()
    if usage.is_used("hospital", hospital_id):
        raise InUse(message="This hospital is used in bookings. Deactivate it instead.")
    if hospital.doctors.exists():
        raise InUse(message="Doctors are listed at this hospital. Remove them or deactivate it.")
    record(
        actor,
        "hospital.deleted",
        ("hospitals.hospital", hospital_id),
        before={"name": hospital.name},
        ip=ip,
    )
    hospital.delete()


# --- Doctors ---

DOCTOR_FIELDS = ("full_name", "photo_key", "qualifications", "opd_info", "languages")


@transaction.atomic
def save_doctor(
    *, actor: StaffUser, data: dict[str, Any], ip: str, doctor_id: str | None = None
) -> Doctor:
    speciality = Speciality.objects.filter(pk=data["speciality_id"]).first()
    if speciality is None:
        raise InvalidDirectoryEntry(code="UNKNOWN_SPECIALITY", message="Choose a speciality.")
    hospital_ids = sorted({str(h) for h in data["hospital_ids"]})
    if Hospital.objects.filter(pk__in=hospital_ids).count() != len(hospital_ids):
        raise InvalidDirectoryEntry(code="UNKNOWN_HOSPITAL", message="Unknown hospital.")

    if doctor_id:
        doctor = Doctor.objects.select_for_update().filter(pk=doctor_id).first()
        if doctor is None:
            raise NotFound()
        before: dict[str, Any] = {f: getattr(doctor, f) for f in DOCTOR_FIELDS}
        before["speciality_id"] = str(doctor.speciality_id)
        before["hospital_ids"] = sorted(
            str(h) for h in doctor.hospitals.values_list("pk", flat=True)
        )
    else:
        doctor, before = Doctor(), {}
    if data["photo_key"] and data["photo_key"] != before.get("photo_key"):
        confirm_upload(data["photo_key"], purpose="doctor_photo")
    for field in DOCTOR_FIELDS:
        setattr(doctor, field, data[field])
    doctor.speciality = speciality
    doctor.save()
    DoctorHospital.objects.filter(doctor=doctor).exclude(hospital_id__in=hospital_ids).delete()
    existing = {
        str(h)
        for h in DoctorHospital.objects.filter(doctor=doctor).values_list("hospital_id", flat=True)
    }
    DoctorHospital.objects.bulk_create(
        [DoctorHospital(doctor=doctor, hospital_id=h) for h in hospital_ids if h not in existing]
    )
    after = {f: getattr(doctor, f) for f in DOCTOR_FIELDS}
    after["speciality_id"] = str(speciality.pk)
    after["hospital_ids"] = hospital_ids
    old, new = _diff(before, after)
    if new:
        action = "doctor.updated" if doctor_id else "doctor.created"
        record(actor, action, doctor, before=old or None, after=new, ip=ip)
    return doctor


@transaction.atomic
def set_doctor_active(*, actor: StaffUser, doctor_id: str, active: bool, ip: str) -> Doctor:
    doctor = Doctor.objects.select_for_update().filter(pk=doctor_id).first()
    if doctor is None:
        raise NotFound()
    if doctor.is_active != active:
        doctor.is_active = active
        doctor.save(update_fields=["is_active", "updated_at"])
        record(
            actor,
            "doctor.activated" if active else "doctor.deactivated",
            doctor,
            before={"is_active": not active},
            after={"is_active": active},
            ip=ip,
        )
    return doctor


@transaction.atomic
def delete_doctor(*, actor: StaffUser, doctor_id: str, ip: str) -> None:
    doctor = Doctor.objects.select_for_update().filter(pk=doctor_id).first()
    if doctor is None:
        raise NotFound()
    if usage.is_used("doctor", doctor_id):
        raise InUse(message="This doctor is used in bookings. Deactivate instead.")
    record(
        actor,
        "doctor.deleted",
        ("hospitals.doctor", doctor_id),
        before={"full_name": doctor.full_name},
        ip=ip,
    )
    doctor.delete()
