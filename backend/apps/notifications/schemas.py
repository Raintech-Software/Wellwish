"""Schemas for the in-app inbox."""

from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import Field

from common.schemas import CamelSchema, StrictIn


class NotificationOut(CamelSchema):
    id: str
    type: str
    title: str
    body: str
    data: dict[str, str]
    created_at: datetime
    read_at: datetime | None

    @staticmethod
    def resolve_id(obj: Any) -> str:
        return str(obj.pk)


class UnreadCountOut(CamelSchema):
    unread: int


class MarkReadIn(StrictIn):
    ids: list[UUID] | None = Field(None, max_length=200, description="Leave out to mark all read")
