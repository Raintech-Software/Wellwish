"""Reads for the SOS console (§9.1 Live)."""

import datetime as dt

from django.db.models import QuerySet

from apps.safety.models import SosEvent, SosStatus
from common.errors import NotFound
from common.ids import uid


def _rows() -> QuerySet[SosEvent]:
    return SosEvent.objects.select_related(
        "booking", "booking__partner__user", "ack_by"
    ).prefetch_related("booking__partner__phones")


def sos_events(*, active_only: bool) -> QuerySet[SosEvent]:
    rows = _rows()
    if active_only:
        rows = rows.exclude(status=SosStatus.RESOLVED)
    return rows.order_by("-created_at")


def sos_event(sos_id: str) -> SosEvent:
    sos = _rows().filter(pk=uid(sos_id)).first()
    if sos is None:
        raise NotFound()
    return sos


def unacknowledged_count(*, now: dt.datetime) -> int:
    """§13 alarm: SOS nobody acknowledged within 2 minutes."""
    from apps.safety.services import ACK_WITHIN

    return SosEvent.objects.filter(status=SosStatus.OPEN, created_at__lte=now - ACK_WITHIN).count()


def sos_open_count() -> int:
    """The dashboard (9.2): SOS not resolved yet (open or acknowledged)."""
    return SosEvent.objects.exclude(status=SosStatus.RESOLVED).count()
