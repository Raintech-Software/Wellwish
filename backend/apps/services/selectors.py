"""Read queries for services."""

from django.db.models import QuerySet

from apps.services.models import Service
from common.errors import NotFound


def active_services(partner_type: str | None = None) -> QuerySet[Service]:
    """What the apps show: active only, in the admin's order."""
    qs = Service.objects.filter(is_active=True)
    if partner_type:
        qs = qs.filter(partner_type=partner_type)
    return qs.order_by("sort", "name")


def all_services() -> QuerySet[Service]:
    return Service.objects.order_by("sort", "name")


def get_service(service_id: str) -> Service:
    service = Service.objects.filter(pk=service_id).first()
    if service is None:
        raise NotFound()
    return service
