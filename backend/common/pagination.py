"""Page-number pagination: `?page=2&pageSize=20` → `{items, count, page, pageSize}`.

Use on a list endpoint with `@paginate(WWPagination)`.
"""

from collections.abc import Callable
from typing import Any

from django.conf import settings
from django.db.models import QuerySet
from django.http import HttpRequest
from ninja import Field, Schema
from ninja.pagination import PaginationBase


class WWPagination(PaginationBase):
    class Input(Schema):
        page: int = Field(1, ge=1)
        page_size: int = Field(
            settings.API_PAGE_SIZE_DEFAULT,
            ge=1,
            le=settings.API_PAGE_SIZE_MAX,
            alias="pageSize",
        )

    class Output(Schema):
        items: list[Any]
        count: int
        page: int
        page_size: int = Field(..., alias="pageSize")

    items_attribute: str = "items"

    def paginate_queryset(
        self,
        queryset: QuerySet[Any] | list[Any],
        pagination: Any,
        request: HttpRequest,
        **params: Any,
    ) -> dict[str, Any]:
        page: int = pagination.page
        size: int = pagination.page_size
        start = (page - 1) * size
        count = queryset.count() if isinstance(queryset, QuerySet) else len(queryset)
        return {
            "items": queryset[start : start + size],
            "count": count,
            "page": page,
            "pageSize": size,
        }


class Mapped[R]:
    """A queryset whose rows are turned into response schemas only for the returned page:
    `return Mapped(rows, booking_row)` from a `@paginate(WWPagination)` endpoint."""

    def __init__(self, rows: QuerySet[Any], build: Callable[[Any], R]) -> None:
        self.rows = rows
        self.build = build

    def __len__(self) -> int:
        return self.rows.count()

    def __getitem__(self, page: slice) -> list[R]:
        return [self.build(row) for row in self.rows[page]]
