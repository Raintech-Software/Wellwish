"""Is this row still used somewhere? (ARCHITECTURE §9.1: anything used in a booking is
deactivated, never deleted.)

The app that owns a table asks before a hard delete. Apps that refer to it register a check
when Django starts, e.g. the bookings app (Phase 5):

    usage.register("service", lambda service_id: Booking.objects.filter(service_id=...).exists())
"""

from collections import defaultdict
from collections.abc import Callable

Check = Callable[[str], bool]

_checks: dict[str, list[Check]] = defaultdict(list)


def register(kind: str, check: Check) -> None:
    if check not in _checks[kind]:
        _checks[kind].append(check)


def is_used(kind: str, object_id: str) -> bool:
    return any(check(object_id) for check in _checks.get(kind, []))
