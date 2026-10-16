"""Writing to the audit log. Use from any app's services:

    from apps.audit.services import record

    record(staff, "service.price_changed", service, before={"pricePaise": 50000},
           after={"pricePaise": 60000}, reason="New rate card", ip=client_ip(request))

Never put secrets (password hashes, TOTP secrets, tokens, OTPs) or medical text in before/after.
"""

from typing import TYPE_CHECKING, Any

from django.db import models

from apps.audit.models import AuditLog

if TYPE_CHECKING:
    from apps.staff.models import StaffUser

Entity = models.Model | tuple[str, str]


def _entity(entity: Entity) -> tuple[str, str]:
    if isinstance(entity, tuple):
        return entity
    return entity._meta.label_lower, str(entity.pk)


def record(
    actor: "StaffUser | None",
    action: str,
    entity: Entity,
    *,
    before: dict[str, Any] | None = None,
    after: dict[str, Any] | None = None,
    reason: str = "",
    ip: str | None = None,
) -> AuditLog:
    """Add one audit row. `actor` None = the system did it."""
    entity_type, entity_id = _entity(entity)
    return AuditLog.objects.create(
        staff=actor,
        action=action,
        entity_type=entity_type,
        entity_id=entity_id,
        before=before,
        after=after,
        reason=reason,
        ip=ip,
    )
