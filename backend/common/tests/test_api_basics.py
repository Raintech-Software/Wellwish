"""Error format, strict input, camelCase output and pagination, tested on a throwaway API."""

import pytest
from ninja import NinjaAPI, Schema
from ninja.pagination import paginate
from ninja.testing import TestClient

from common.errors import NotFound, register_error_handlers
from common.pagination import WWPagination
from common.schemas import CamelSchema, StrictIn

api = NinjaAPI(urls_namespace="test_api_basics")
register_error_handlers(api)


class SampleBookingIn(StrictIn):
    member_id: str
    notes: str = ""


class BookingOut(CamelSchema):
    member_id: str
    pickup_at: str


class Item(Schema):
    n: int


@api.post("/bookings", response=BookingOut, by_alias=True)
def create_booking(request, data: SampleBookingIn):
    return BookingOut(member_id=data.member_id, pickup_at="2026-10-09T09:30:00+05:30")


@api.get("/missing")
def missing(request):
    raise NotFound()


@api.get("/boom")
def boom(request):
    raise RuntimeError("secret internals")


@api.get("/items", response=list[Item])
@paginate(WWPagination)
def items(request):
    return [{"n": i} for i in range(45)]


client = TestClient(api)


def test_camel_case_in_and_out():
    resp = client.post("/bookings", json={"memberId": "m-1"})
    assert resp.status_code == 200
    assert resp.json() == {"memberId": "m-1", "pickupAt": "2026-10-09T09:30:00+05:30"}


def test_unknown_fields_are_rejected_with_error_format():
    resp = client.post("/bookings", json={"memberId": "m-1", "price": 1})
    assert resp.status_code == 422
    body = resp.json()
    assert body["error"]["code"] == "VALIDATION_ERROR"
    assert body["error"]["details"]["errors"]


def test_api_error_uses_error_format():
    resp = client.get("/missing")
    assert resp.status_code == 404
    assert resp.json() == {"error": {"code": "NOT_FOUND", "message": "Not found.", "details": {}}}


def test_unexpected_error_hides_internals():
    resp = client.get("/boom")
    assert resp.status_code == 500
    assert resp.json()["error"]["code"] == "INTERNAL_ERROR"
    assert "secret" not in resp.content.decode()


@pytest.mark.parametrize(
    ("query", "expected_first", "expected_len"),
    [("", 0, 20), ("?page=3", 40, 5), ("?page=2&pageSize=10", 10, 10)],
)
def test_pagination(query, expected_first, expected_len):
    resp = client.get(f"/items{query}")
    body = resp.json()
    assert resp.status_code == 200
    assert body["count"] == 45
    assert len(body["items"]) == expected_len
    assert body["items"][0]["n"] == expected_first


def test_page_size_is_capped():
    assert client.get("/items?pageSize=500").status_code == 422
