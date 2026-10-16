"""Turning id strings into UUIDs for ORM lookups (the type checker wants UUIDs for UUID keys)."""

import uuid

from common.errors import NotFound


def uid(value: str | uuid.UUID) -> uuid.UUID:
    """A malformed id (e.g. `?memberId=abc`) is "not found", like someone else's id (§6.5),
    never a server error."""
    if isinstance(value, uuid.UUID):
        return value
    try:
        return uuid.UUID(str(value))
    except ValueError:
        raise NotFound() from None
