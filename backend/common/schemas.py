"""Schema bases. JSON uses camelCase (`memberId`), Python uses snake_case (`member_id`).

- `CamelSchema` for responses: return with `by_alias=True` on the endpoint.
- `StrictIn` for every request body: unknown fields are rejected with 422 (ARCHITECTURE §12).
"""

from decimal import ROUND_HALF_UP, Decimal, InvalidOperation
from typing import Annotated

from ninja import Schema
from pydantic import ConfigDict, PlainValidator, StringConstraints, WithJsonSchema
from pydantic.alias_generators import to_camel


class CamelSchema(Schema):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)


class StrictIn(CamelSchema):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True, extra="forbid")


class ErrorDetail(Schema):
    code: str
    message: str
    details: dict[str, object] = {}


class ErrorOut(Schema):
    """Documents the error format in OpenAPI."""

    error: ErrorDetail


class OkOut(CamelSchema):
    """Response for actions that have nothing else to return."""

    ok: bool = True


def decimal_text(low: str, high: str, places: int) -> PlainValidator:
    """An exact decimal sent as text ("20.296100"), checked to be within [low, high] and rounded
    to `places`. Sent as text because the generated Dart client can't read number-or-text
    fields, and text keeps every digit (a float would not)."""
    lo, hi, step = Decimal(low), Decimal(high), Decimal(1).scaleb(-places)

    def parse(value: object) -> Decimal:
        if isinstance(value, bool) or not isinstance(value, str | int | float | Decimal):
            raise ValueError("Enter a number.")
        try:
            number = Decimal(str(value).strip())
        except InvalidOperation:
            raise ValueError("Enter a number.") from None
        if not number.is_finite() or not lo <= number <= hi:
            raise ValueError(f"Must be between {low} and {high}.")
        return number.quantize(step, rounding=ROUND_HALF_UP)

    return PlainValidator(parse)


def _text(example: str) -> WithJsonSchema:
    return WithJsonSchema({"type": "string", "examples": [example]})


# Reasons and notes typed by staff: surrounding spaces are removed BEFORE the length check,
# so "     " is not a reason (a plain `Field(min_length=…)` counts the spaces).
Reason = Annotated[str, StringConstraints(strip_whitespace=True, min_length=3, max_length=300)]


Latitude = Annotated[Decimal, decimal_text("-90", "90", 6), _text("20.296100")]
Longitude = Annotated[Decimal, decimal_text("-180", "180", 6), _text("85.824500")]
RadiusKm = Annotated[Decimal, decimal_text("0.5", "200", 1), _text("25.0")]
