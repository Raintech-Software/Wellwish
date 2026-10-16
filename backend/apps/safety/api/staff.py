"""Admin: the SOS console (§9.1 Live): see, acknowledge, resolve. Logged."""

from typing import Literal
from uuid import UUID

from django.http import HttpRequest
from ninja import Router
from ninja.pagination import paginate

from apps.assignments.api.out import phones
from apps.safety import selectors, services
from apps.safety.models import SosEvent
from apps.safety.schemas import AdminSosOut, SosResolveIn
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.pagination import Mapped, WWPagination
from common.request import client_ip

router = Router(tags=["admin"])


def sos_out(sos: SosEvent) -> AdminSosOut:
    booking = sos.booking
    primary, _ = phones(booking.partner)
    return AdminSosOut(
        id=str(sos.pk),
        booking_id=str(booking.pk),
        code=booking.code,
        side=sos.raised_by_type,
        status=sos.status,
        lat=str(sos.lat) if sos.lat is not None else None,
        lng=str(sos.lng) if sos.lng is not None else None,
        mock_location=sos.mock_location,
        partner_name=booking.partner.full_name if booking.partner else "",
        partner_phone=primary,
        member_name=str(booking.member_snapshot.get("full_name", "")),
        raised_at=sos.created_at,
        ack_by=sos.ack_by.name if sos.ack_by else "",
        ack_at=sos.ack_at,
        resolved_at=sos.resolved_at,
        notes=sos.notes,
    )


@router.get("/sos", response=list[AdminSosOut], by_alias=True, operation_id="adminSosList")
@staff_permission("live.view")
@paginate(WWPagination)
def sos_list(
    request: HttpRequest, status: Literal["active", "all"] = "active"
) -> Mapped[AdminSosOut]:
    """`active`: open and acknowledged (newest first); `all` includes resolved ones."""
    return Mapped(selectors.sos_events(active_only=status == "active"), sos_out)


@router.post(
    "/sos/{uuid:sos_id}/ack", response=AdminSosOut, by_alias=True, operation_id="adminSosAck"
)
@staff_permission("live.manage")
def sos_ack(request: HttpRequest, sos_id: UUID) -> AdminSosOut:
    sos = services.acknowledge(
        sos_id=str(sos_id), staff=acting_staff(request), ip=client_ip(request)
    )
    return sos_out(selectors.sos_event(str(sos.pk)))


@router.post(
    "/sos/{uuid:sos_id}/resolve",
    response=AdminSosOut,
    by_alias=True,
    operation_id="adminSosResolve",
)
@staff_permission("live.manage")
def sos_resolve(request: HttpRequest, sos_id: UUID, data: SosResolveIn) -> AdminSosOut:
    sos = services.resolve(
        sos_id=str(sos_id), staff=acting_staff(request), notes=data.notes, ip=client_ip(request)
    )
    return sos_out(selectors.sos_event(str(sos.pk)))
