"""Admin: services and prices (/v1/admin/services). View: services.view. Change: services.manage."""

from uuid import UUID

from django.http import HttpRequest
from ninja import Router

from apps.services import selectors, services
from apps.services.models import Service
from apps.services.schemas import ReorderIn, ServiceIn, ServiceOut
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.request import client_ip
from common.schemas import OkOut

router = Router(tags=["admin"])


def service_out(service: Service) -> ServiceOut:
    return ServiceOut(
        id=str(service.pk),
        name=service.name,
        name_hi=service.name_hi,
        name_or=service.name_or,
        description=service.description,
        description_hi=service.description_hi,
        description_or=service.description_or,
        partner_type=service.partner_type,
        visit_type=service.visit_type,
        price_paise=service.price_paise,
        booking_fee_paise=service.booking_fee_paise,
        balance_paise=service.balance_paise,
        duration_min=service.duration_min,
        docs_required=service.docs_required,
        is_active=service.is_active,
        sort=service.sort,
    )


@router.get("/services", response=list[ServiceOut], by_alias=True, operation_id="adminServicesList")
@staff_permission("services.view")
def list_services(request: HttpRequest) -> list[ServiceOut]:
    """All services, active and inactive, in display order."""
    return [service_out(s) for s in selectors.all_services()]


@router.post("/services", response=ServiceOut, by_alias=True, operation_id="adminServicesCreate")
@staff_permission("services.manage")
def create_service(request: HttpRequest, data: ServiceIn) -> ServiceOut:
    service = services.create_service(
        actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
    )
    return service_out(service)


@router.put(
    "/services/{uuid:service_id}",
    response=ServiceOut,
    by_alias=True,
    operation_id="adminServicesUpdate",
)
@staff_permission("services.manage")
def update_service(request: HttpRequest, service_id: UUID, data: ServiceIn) -> ServiceOut:
    """New prices apply to new bookings only."""
    service = services.update_service(
        actor=acting_staff(request),
        service_id=str(service_id),
        data=data.model_dump(),
        ip=client_ip(request),
    )
    return service_out(service)


@router.post(
    "/services/{uuid:service_id}/deactivate",
    response=ServiceOut,
    by_alias=True,
    operation_id="adminServicesDeactivate",
)
@staff_permission("services.manage")
def deactivate_service(request: HttpRequest, service_id: UUID) -> ServiceOut:
    return service_out(
        services.set_active(
            actor=acting_staff(request),
            service_id=str(service_id),
            active=False,
            ip=client_ip(request),
        )
    )


@router.post(
    "/services/{uuid:service_id}/activate",
    response=ServiceOut,
    by_alias=True,
    operation_id="adminServicesActivate",
)
@staff_permission("services.manage")
def activate_service(request: HttpRequest, service_id: UUID) -> ServiceOut:
    return service_out(
        services.set_active(
            actor=acting_staff(request),
            service_id=str(service_id),
            active=True,
            ip=client_ip(request),
        )
    )


@router.delete(
    "/services/{uuid:service_id}", response=OkOut, by_alias=True, operation_id="adminServicesDelete"
)
@staff_permission("services.manage")
def delete_service(request: HttpRequest, service_id: UUID) -> OkOut:
    """Refused (409 IN_USE) once the service has been booked: deactivate it instead."""
    services.delete_service(
        actor=acting_staff(request), service_id=str(service_id), ip=client_ip(request)
    )
    return OkOut()


@router.post(
    "/services/reorder", response=OkOut, by_alias=True, operation_id="adminServicesReorder"
)
@staff_permission("services.manage")
def reorder_services(request: HttpRequest, data: ReorderIn) -> OkOut:
    services.reorder(
        actor=acting_staff(request), ids=[str(i) for i in data.ids], ip=client_ip(request)
    )
    return OkOut()
