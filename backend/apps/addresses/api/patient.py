"""Patient app: saved addresses per family member (/v1/patient/addresses, §6.18, §10.3)."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Query, Router, Schema
from pydantic import Field

from apps.addresses import selectors, services
from apps.addresses.models import Address
from apps.addresses.schemas import AddressIn, AddressOut
from common.auth import get_principal
from common.schemas import OkOut

router = Router(tags=["patient"])


def address_out(address: Address) -> AddressOut:
    return AddressOut(
        id=str(address.pk),
        member_id=str(address.member_id),
        label=address.label,
        line1=address.line1,
        landmark=address.landmark,
        notes=address.notes,
        lat=address.lat,
        lng=address.lng,
        in_service_area=address.in_service_area,
        created_at=address.created_at,
    )


def _input(data: AddressIn) -> services.AddressInput:
    return services.AddressInput(
        member_id=data.member_id,
        label=data.label,
        line1=data.line1,
        landmark=data.landmark,
        notes=data.notes,
        lat=data.lat,
        lng=data.lng,
    )


class AddressFilter(Schema):
    member_id: str | None = Field(None, alias="memberId")


@router.get(
    "/addresses", response=list[AddressOut], by_alias=True, operation_id="patientAddressList"
)
def list_addresses(request: HttpRequest, filters: Query[AddressFilter]) -> list[AddressOut]:
    """Your saved addresses (`memberId` → only that family member's)."""
    user_id = get_principal(request).subject_id
    return [address_out(a) for a in selectors.addresses(user_id, member_id=filters.member_id)]


@router.post("/addresses", response=AddressOut, by_alias=True, operation_id="patientAddressAdd")
def add_address(request: HttpRequest, data: AddressIn) -> AddressOut:
    """Save an address for a family member (or yourself). `inServiceArea` says whether WellWish
    serves it."""
    user_id = get_principal(request).subject_id
    return address_out(services.add_address(user_id=user_id, data=_input(data)))


@router.put(
    "/addresses/{uuid:address_id}",
    response=AddressOut,
    by_alias=True,
    operation_id="patientAddressUpdate",
)
def update_address(request: HttpRequest, address_id: UUID, data: AddressIn) -> AddressOut:
    user_id = get_principal(request).subject_id
    return address_out(
        services.update_address(user_id=user_id, address_id=str(address_id), data=_input(data))
    )


@router.delete(
    "/addresses/{uuid:address_id}",
    response=OkOut,
    by_alias=True,
    operation_id="patientAddressRemove",
)
def remove_address(request: HttpRequest, address_id: UUID) -> OkOut:
    services.remove_address(user_id=get_principal(request).subject_id, address_id=str(address_id))
    return OkOut()
