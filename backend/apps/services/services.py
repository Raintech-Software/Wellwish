"""All writes for the service catalogue. Every change is in the audit log; price changes are
logged as `service.price_changed` with the old and new amounts (§6.6)."""

from typing import Any

from django.db import transaction

from apps.audit.services import record
from apps.services.models import Service
from apps.staff.models import StaffUser
from common import usage
from common.errors import Conflict, NotFound

FIELDS = (
    "name",
    "name_hi",
    "name_or",
    "description",
    "description_hi",
    "description_or",
    "partner_type",
    "visit_type",
    "price_paise",
    "booking_fee_paise",
    "duration_min",
    "docs_required",
)
PRICE_FIELDS = ("price_paise", "booking_fee_paise")


class InUse(Conflict):
    code = "IN_USE"
    message = "This is used in bookings, so it can't be deleted. Deactivate it instead."


def _get(service_id: str) -> Service:
    service = Service.objects.select_for_update().filter(pk=service_id).first()
    if service is None:
        raise NotFound()
    return service


def _snapshot(service: Service, fields: tuple[str, ...] = FIELDS) -> dict[str, Any]:
    return {field: getattr(service, field) for field in fields}


@transaction.atomic
def create_service(*, actor: StaffUser, data: dict[str, Any], ip: str) -> Service:
    last = Service.objects.order_by("-sort").values_list("sort", flat=True).first()
    service = Service.objects.create(**{f: data[f] for f in FIELDS}, sort=(last or 0) + 1)
    record(actor, "service.created", service, after=_snapshot(service), ip=ip)
    return service


@transaction.atomic
def update_service(*, actor: StaffUser, service_id: str, data: dict[str, Any], ip: str) -> Service:
    """New prices apply to new bookings only: bookings keep their own price snapshot."""
    service = _get(service_id)
    before = _snapshot(service)
    for field in FIELDS:
        setattr(service, field, data[field])
    service.save()
    after = _snapshot(service)
    changed = [f for f in FIELDS if before[f] != after[f]]
    if changed:
        action = (
            "service.price_changed"
            if any(f in PRICE_FIELDS for f in changed)
            else "service.updated"
        )
        record(
            actor,
            action,
            service,
            before={f: before[f] for f in changed},
            after={f: after[f] for f in changed},
            ip=ip,
        )
    return service


@transaction.atomic
def set_active(*, actor: StaffUser, service_id: str, active: bool, ip: str) -> Service:
    """Inactive services disappear from the apps but keep their history."""
    service = _get(service_id)
    if service.is_active != active:
        service.is_active = active
        service.save(update_fields=["is_active", "updated_at"])
        record(
            actor,
            "service.activated" if active else "service.deactivated",
            service,
            before={"is_active": not active},
            after={"is_active": active},
            ip=ip,
        )
    return service


@transaction.atomic
def delete_service(*, actor: StaffUser, service_id: str, ip: str) -> None:
    """Only a service that was never booked can be deleted (§9.1)."""
    service = _get(service_id)
    if usage.is_used("service", str(service.pk)):
        raise InUse()
    record(
        actor,
        "service.deleted",
        ("services.service", str(service.pk)),
        before=_snapshot(service),
        ip=ip,
    )
    service.delete()


@transaction.atomic
def reorder(*, actor: StaffUser, ids: list[str], ip: str) -> None:
    """The order services are shown in the apps."""
    services = {str(s.pk): s for s in Service.objects.select_for_update().filter(pk__in=ids)}
    if len(services) != len(set(ids)):
        raise NotFound()
    for position, service_id in enumerate(ids, start=1):
        service = services[service_id]
        if service.sort != position:
            service.sort = position
            service.save(update_fields=["sort", "updated_at"])
    record(actor, "service.reordered", ("services.service", "*"), after={"order": ids}, ip=ip)
