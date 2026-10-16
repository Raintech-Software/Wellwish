"""Public: specialities (GET /v1/public/specialities, §10.3) for the doctor filter chips."""

from django.http import HttpRequest
from ninja import Router

from apps.hospitals import selectors
from apps.hospitals.api.staff import speciality_out
from apps.hospitals.schemas import SpecialityOut

router = Router(tags=["public"])


@router.get(
    "/specialities",
    response=list[SpecialityOut],
    by_alias=True,
    auth=None,
    operation_id="publicSpecialities",
)
def list_specialities(request: HttpRequest) -> list[SpecialityOut]:
    return [speciality_out(s) for s in selectors.specialities()]
