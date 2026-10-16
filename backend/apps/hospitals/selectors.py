"""Read queries for the directory, including nearby hospitals (§6.7)."""

from django.db.models import Count, Prefetch, Q, QuerySet

from apps.hospitals.models import Doctor, Hospital, Speciality
from common.errors import NotFound
from common.geo import nearby
from common.ids import uid

NEARBY_KM = 10
WIDER_KM = 25
MIN_RESULTS = 5


def nearby_hospitals(
    lat: float,
    lng: float,
    *,
    radius_km: float | None = None,
    speciality_id: str | None = None,
    q: str = "",
) -> tuple[list[Hospital], float]:
    """Active hospitals within 10 km, closest first, each with `distance_km`. If fewer than 5
    are found, the search widens to 25 km. A given `radius_km` is used as-is.
    Returns (hospitals, radius used)."""
    qs = patient_hospitals(speciality_id=speciality_id, q=q)
    if radius_km is not None:
        return list(nearby(qs, lat, lng, radius_km)), radius_km
    found = list(nearby(qs, lat, lng, NEARBY_KM))
    if len(found) >= MIN_RESULTS:
        return found, NEARBY_KM
    return list(nearby(qs, lat, lng, WIDER_KM)), WIDER_KM


def hospitals(*, q: str = "", include_inactive: bool = True) -> QuerySet[Hospital]:
    qs = Hospital.objects.annotate(doctor_count=Count("doctors", distinct=True))
    if not include_inactive:
        qs = qs.filter(is_active=True)
    if q:
        qs = qs.filter(Q(name__icontains=q) | Q(address__icontains=q) | Q(city__icontains=q))
    return qs.order_by("name")


def get_hospital(hospital_id: str) -> Hospital:
    hospital = Hospital.objects.filter(pk=hospital_id).first()
    if hospital is None:
        raise NotFound()
    return hospital


def doctors(
    *, q: str = "", speciality_id: str | None = None, hospital_id: str | None = None
) -> QuerySet[Doctor]:
    qs = Doctor.objects.select_related("speciality").prefetch_related("hospitals")
    if q:
        qs = qs.filter(full_name__icontains=q)
    if speciality_id:
        qs = qs.filter(speciality_id=speciality_id)
    if hospital_id:
        qs = qs.filter(hospitals__id=hospital_id)
    return qs.order_by("full_name").distinct()


def get_doctor(doctor_id: str) -> Doctor:
    doctor = (
        Doctor.objects.select_related("speciality")
        .prefetch_related("hospitals")
        .filter(pk=doctor_id)
        .first()
    )
    if doctor is None:
        raise NotFound()
    return doctor


def specialities() -> QuerySet[Speciality]:
    return Speciality.objects.annotate(doctor_count=Count("doctors")).order_by("name")


def get_speciality(speciality_id: str) -> Speciality:
    speciality = Speciality.objects.filter(pk=speciality_id).first()
    if speciality is None:
        raise NotFound()
    return speciality


# --- Patient app (P06-P09): active entries only; inactive ones are "not found" ---

PATIENT_LIST_LIMIT = 100


def _active_doctor_count() -> Count:
    return Count("doctors", filter=Q(doctors__is_active=True), distinct=True)


def patient_hospitals(*, speciality_id: str | None = None, q: str = "") -> QuerySet[Hospital]:
    """Active hospitals for the patient app."""
    qs = Hospital.objects.filter(is_active=True)
    if speciality_id:
        qs = qs.filter(
            doctors__speciality_id=uid(speciality_id), doctors__is_active=True
        ).distinct()
    if q:
        qs = qs.filter(
            Q(name__icontains=q)
            | Q(city__icontains=q)
            | Q(doctors__full_name__icontains=q, doctors__is_active=True)
        ).distinct()
    return qs


def patient_nearby(
    *,
    lat: float | None,
    lng: float | None,
    radius_km: float | None = None,
    speciality_id: str | None = None,
    q: str = "",
) -> tuple[list[Hospital], float | None]:
    """Nearby hospitals (10 km, widened to 25 km if fewer than 5), closest first. Without a
    location (permission refused, no saved address): every active hospital, by name.
    Each one has `distance_km` (None without a location) and `doctor_count` (active doctors).
    Returns (hospitals, radius used)."""
    if lat is None or lng is None:
        rows: list[Hospital] = list(
            patient_hospitals(speciality_id=speciality_id, q=q)
            .annotate(doctor_count=_active_doctor_count())
            .order_by("name")[:PATIENT_LIST_LIMIT]
        )
        for row in rows:
            row.distance_km = None  # type: ignore[attr-defined]
        return rows, None
    if speciality_id:
        uid(speciality_id)  # a malformed id is "not found"
    found, used = nearby_hospitals(lat, lng, radius_km=radius_km, speciality_id=speciality_id, q=q)
    found = found[:PATIENT_LIST_LIMIT]
    counts = dict(
        Hospital.objects.filter(pk__in=[h.pk for h in found])
        .annotate(n=_active_doctor_count())
        .values_list("pk", "n")
    )
    for hospital in found:
        hospital.doctor_count = counts.get(hospital.pk, 0)  # type: ignore[attr-defined]
    return found, used


def patient_hospital(hospital_id: str) -> Hospital:
    hospital = Hospital.objects.filter(pk=uid(hospital_id), is_active=True).first()
    if hospital is None:
        raise NotFound()
    return hospital


def patient_doctors(
    *, q: str = "", speciality_id: str | None = None, hospital_id: str | None = None
) -> QuerySet[Doctor]:
    """Active doctors by name, each with `active_hospitals` (a list)."""
    qs = (
        Doctor.objects.filter(is_active=True)
        .select_related("speciality")
        .prefetch_related(
            Prefetch(
                "hospitals",
                queryset=Hospital.objects.filter(is_active=True).order_by("name"),
                to_attr="active_hospitals",
            )
        )
    )
    if q:
        qs = qs.filter(Q(full_name__icontains=q) | Q(speciality__name__icontains=q))
    if speciality_id:
        qs = qs.filter(speciality_id=uid(speciality_id))
    if hospital_id:
        qs = qs.filter(hospitals__id=uid(hospital_id), hospitals__is_active=True)
    return qs.order_by("full_name").distinct()


def patient_doctor(doctor_id: str) -> Doctor:
    doctor = patient_doctors().filter(pk=uid(doctor_id)).first()
    if doctor is None:
        raise NotFound()
    return doctor
