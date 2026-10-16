"""Shared fixtures for the assignment and visit tests (a paid booking, approved partners, the
live messages sent). Loaded for every test through `pytest_plugins` in the root conftest."""

from typing import Any

import pytest

from apps.accounts.models import User
from apps.bookings.tests.support import make_world
from apps.partners.models import PartnerProfile
from apps.partners.tests.support import partner_login, save_profile
from apps.payments import gateway as gw
from apps.payments.tests.test_cancel_reschedule import paid_booking
from common import realtime


@pytest.fixture
def fake():
    gateway = gw.FakeGateway()
    gw.use_gateway(gateway)
    yield gateway
    gw.use_gateway(None)


@pytest.fixture
def world(api):
    return make_world(api)


@pytest.fixture
def sent(monkeypatch) -> list[tuple[str, str, dict[str, Any]]]:
    """Live messages (group, type, data) sent through `common.realtime`."""
    out: list[tuple[str, str, dict[str, Any]]] = []
    monkeypatch.setattr(
        realtime, "send_to_group", lambda group, kind, data: out.append((group, kind, data))
    )
    return out


def approved_partner(
    api,
    phone: str,
    *,
    role: str = "COMPANION",
    name: str = "Asha Behera",
    lat: str = "20.290000",
    lng: str = "85.840000",
) -> tuple[str, str]:
    """An approved partner (registration shortcut: KYC is tested in the kyc app)."""
    token = partner_login(api, phone, device_id=f"device-{phone[-4:]}")
    assert api.post("/partner/register/start", {"role": role}, token).status_code == 200
    resp = save_profile(api, token, fullName=name, lat=lat, lng=lng)
    assert resp.status_code == 200, resp.json()
    user_id = str(User.objects.get(phone=phone).pk)
    PartnerProfile.objects.filter(user__phone=phone).update(status="APPROVED")
    return token, user_id


@pytest.fixture
def asha(api):
    return approved_partner(api, "+919811100001")


@pytest.fixture
def ravi(api):
    return approved_partner(api, "+919811100002", name="Ravi Das", lat="20.350000", lng="85.900000")


@pytest.fixture
def booking(api, world, fake, django_capture_on_commit_callbacks):
    return paid_booking(api, world, fake, django_capture_on_commit_callbacks)
