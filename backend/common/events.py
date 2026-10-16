"""How Django apps talk to each other (ARCHITECTURE §10.2).

    # in apps/bookings/services.py
    events.publish("booking.cancelled", {"booking_id": str(booking.id)})

    # in apps/payments/events.py
    @events.subscribe("booking.cancelled")
    def refund_booking_fee(name: str, payload: dict) -> None: ...

`publish` waits for the database transaction to commit, then runs each handler as its own
Celery task, so a slow or failing handler never breaks the request that published it.
Handlers must be safe to run twice. Payloads must be JSON (ids as strings, money in paise).
"""

import json
from collections import defaultdict
from collections.abc import Callable
from typing import Any

from django.db import transaction

Handler = Callable[[str, dict[str, Any]], None]

_handlers: dict[str, list[str]] = defaultdict(list)


def subscribe(event_name: str) -> Callable[[Handler], Handler]:
    def register(func: Handler) -> Handler:
        path = f"{func.__module__}.{func.__qualname__}"
        if path not in _handlers[event_name]:
            _handlers[event_name].append(path)
        return func

    return register


def handlers_for(event_name: str) -> list[str]:
    return list(_handlers.get(event_name, []))


def publish(event_name: str, payload: dict[str, Any]) -> None:
    json.dumps(payload)  # fail fast if the payload isn't JSON-safe
    paths = handlers_for(event_name)
    if not paths:
        return

    def send() -> None:
        from common.tasks import run_event_handler

        for path in paths:
            run_event_handler.delay(path, event_name, payload)

    transaction.on_commit(send)
