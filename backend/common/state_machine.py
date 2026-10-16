"""One gate for every status change (ARCHITECTURE §6.9, CLAUDE.md).

Each app defines a `StateMachine` with its allowed (status, event) → new status table and
calls `transition()`. It refuses moves not in the table (409 INVALID_TRANSITION) and uses the
model's `version` column so two changes arriving together can't both win (409 CONFLICT).
The app records its own event row in `on_transition`, inside the same database transaction.
"""

from collections.abc import Callable, Mapping
from dataclasses import dataclass
from typing import Any

from django.db import models, transaction
from django.db.models import F
from django.utils import timezone

from common.errors import Conflict

OnTransition = Callable[[models.Model, str, str, str, Any], None]


class InvalidTransition(Conflict):
    code = "INVALID_TRANSITION"
    message = "This action isn't allowed right now."


class ConcurrentUpdate(Conflict):
    code = "CONFLICT"
    message = "Someone else changed this just now. Reload and try again."


@dataclass(frozen=True)
class StateMachine:
    name: str
    transitions: Mapping[tuple[str, str], str]  # (current status, event) → new status

    def next_status(self, current: str, event: str) -> str:
        try:
            return self.transitions[(current, event)]
        except KeyError:
            raise InvalidTransition(
                details={"machine": self.name, "status": current, "event": event}
            ) from None

    def allowed_events(self, current: str) -> list[str]:
        return sorted(event for (status, event) in self.transitions if status == current)


def transition(
    obj: models.Model,
    event: str,
    *,
    machine: StateMachine,
    actor: Any = None,
    status_field: str = "status",
    version_field: str = "version",
    extra_updates: Mapping[str, Any] | None = None,
    on_transition: OnTransition | None = None,
) -> str:
    """Move `obj` to the next status for `event`. Returns the new status."""
    current: str = getattr(obj, status_field)
    new_status = machine.next_status(current, event)
    version = getattr(obj, version_field)

    updates: dict[str, Any] = {
        status_field: new_status,
        version_field: F(version_field) + 1,
        **(extra_updates or {}),
    }
    field_names = {f.name for f in obj._meta.get_fields()}
    if "updated_at" in field_names and "updated_at" not in updates:
        updates["updated_at"] = timezone.now()  # .update() skips auto_now

    manager = type(obj)._default_manager
    with transaction.atomic():
        changed = manager.filter(
            pk=obj.pk, **{status_field: current, version_field: version}
        ).update(**updates)
        if changed != 1:
            raise ConcurrentUpdate(details={"machine": machine.name})
        obj.refresh_from_db(fields=[name for name in updates if name in field_names])
        if on_transition is not None:
            on_transition(obj, current, new_status, event, actor)
    return new_status
