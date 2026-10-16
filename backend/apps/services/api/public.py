"""Public: the service catalogue with prices (GET /v1/public/services, §10.3)."""

from typing import Literal

from django.http import HttpRequest
from ninja import Query, Router

from apps.services import selectors
from apps.services.api.staff import service_out
from apps.services.schemas import ServiceOut

router = Router(tags=["public"])


@router.get(
    "/services", response=list[ServiceOut], by_alias=True, auth=None, operation_id="publicServices"
)
def list_services(
    request: HttpRequest,
    partner_type: Literal["COMPANION", "NURSE"] | None = Query(None, alias="partnerType"),
) -> list[ServiceOut]:
    """Active services in display order, with the price, the booking fee paid online and the
    balance paid to the partner. `?partnerType=NURSE` for the Book a Nurse list."""
    return [service_out(s) for s in selectors.active_services(partner_type)]
