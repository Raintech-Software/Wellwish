"""Read queries for addresses, always filtered by the caller (other people's → 404)."""

from django.db.models import Count, QuerySet

from apps.addresses.models import Address
from common.errors import NotFound
from common.ids import uid


def addresses(user_id: str, *, member_id: str | None = None) -> QuerySet[Address]:
    """The caller's active addresses of active members, newest first."""
    rows = Address.objects.filter(
        user_id=uid(user_id), is_active=True, member__is_active=True
    ).order_by("-created_at")
    if member_id:
        rows = rows.filter(member_id=uid(member_id))
    return rows


def own_address(user_id: str, address_id: str) -> Address:
    address = Address.objects.filter(
        pk=uid(address_id), user_id=uid(user_id), is_active=True, member__is_active=True
    ).first()
    if address is None:
        raise NotFound()
    return address


def counts_by_member(user_id: str) -> dict[str, int]:
    rows = (
        Address.objects.filter(user_id=uid(user_id), is_active=True)
        .values("member_id")
        .annotate(n=Count("id"))
    )
    return {str(row["member_id"]): row["n"] for row in rows}


def all_addresses(user_id: str) -> QuerySet[Address]:
    """Admin: an account's active addresses, with their member."""
    return (
        Address.objects.filter(user_id=uid(user_id), is_active=True)
        .select_related("member")
        .order_by("member__created_at", "-created_at")
    )
