"""All writes for addresses (§6.18). Each address belongs to one of the caller's own members.
Whether it is inside a service area is stored when saved; a booking checks again (§9.1)."""

from dataclasses import dataclass
from decimal import Decimal

from django.db import transaction
from django.utils import timezone

from apps.addresses.models import Address
from apps.app_config.selectors import is_inside_service_area
from apps.patients.models import Member
from common.errors import Conflict, NotFound
from common.ids import uid

MAX_PER_MEMBER = 10


@dataclass(frozen=True)
class AddressInput:
    member_id: str
    label: str
    line1: str
    landmark: str
    notes: str
    lat: Decimal
    lng: Decimal


def _tidy(text: str) -> str:
    return " ".join(text.split())


def _fill(address: Address, data: AddressInput) -> None:
    address.member_id = uid(data.member_id)
    address.label = _tidy(data.label)
    address.line1 = _tidy(data.line1)
    address.landmark = _tidy(data.landmark)
    address.notes = data.notes.strip()
    address.lat = data.lat
    address.lng = data.lng
    address.in_service_area = is_inside_service_area(float(data.lat), float(data.lng))


def _lock_member_with_room(user_id: str, member_id: str) -> None:
    """The caller's own active member (else 404), locked so two quick saves can't both pass
    the limit, with room for one more address."""
    member = (
        Member.objects.select_for_update()
        .filter(pk=uid(member_id), owner_id=uid(user_id), is_active=True)
        .first()
    )
    if member is None:
        raise NotFound()
    count = Address.objects.filter(member=member, is_active=True).count()
    if count >= MAX_PER_MEMBER:
        raise Conflict(
            code="TOO_MANY_ADDRESSES",
            message=f"Up to {MAX_PER_MEMBER} addresses per person. Remove an old one first.",
        )


@transaction.atomic
def add_address(*, user_id: str, data: AddressInput) -> Address:
    _lock_member_with_room(user_id, data.member_id)
    address = Address(user_id=uid(user_id))
    _fill(address, data)
    address.save()
    return address


@transaction.atomic
def update_address(*, user_id: str, address_id: str, data: AddressInput) -> Address:
    address = (
        Address.objects.select_for_update()
        .filter(pk=uid(address_id), user_id=uid(user_id), is_active=True, member__is_active=True)
        .first()
    )
    if address is None:
        raise NotFound()
    if uid(data.member_id) != address.member_id:
        _lock_member_with_room(user_id, data.member_id)  # moved to another family member
    _fill(address, data)
    address.save()
    return address


@transaction.atomic
def remove_address(*, user_id: str, address_id: str) -> None:
    """Hidden, not deleted: past bookings keep a copy of the address anyway (§6.18)."""
    updated = Address.objects.filter(
        pk=uid(address_id), user_id=uid(user_id), is_active=True
    ).update(is_active=False, updated_at=timezone.now())
    if not updated:
        raise NotFound()


def erase_for_owner(*, user_id: str) -> int:
    """Account deletion (§12): remove every address of the account."""
    deleted, _ = Address.objects.filter(user_id=uid(user_id)).delete()
    return deleted


def refresh_service_area(*, address_id: str) -> bool:
    """Check the address against today's service areas again and store the result (a booking
    found it outside: the app then shows it as such). Returns whether it is inside."""
    address = Address.objects.filter(pk=uid(address_id)).first()
    if address is None:
        return False
    inside = is_inside_service_area(float(address.lat), float(address.lng))
    if inside != address.in_service_area:
        address.in_service_area = inside
        address.save(update_fields=["in_service_area", "updated_at"])
    return inside
