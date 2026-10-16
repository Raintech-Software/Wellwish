"""Shared pytest fixtures for the backend."""

import time
from collections.abc import Iterator
from dataclasses import dataclass
from typing import TYPE_CHECKING, Any

import pyotp
import pytest
from django.core.cache import cache
from django.test import Client

# Shared fixtures (paid booking, approved partners, live messages) for the job tests.
pytest_plugins = ["apps.assignments.tests.fixtures"]

if TYPE_CHECKING:
    from apps.staff.models import StaffRole, StaffUser

TEST_NUMBER = "+919000000001"  # accepts 123456 (config/settings/test.py)
TEST_CODE = "123456"


@pytest.fixture(autouse=True)
def _clean_cache() -> Iterator[None]:
    """The test cache lives in memory for the whole run: start every test empty."""
    cache.clear()
    yield
    cache.clear()


class Clock:
    """Controls time.time() (OTP waits, rate-limit windows, cache expiry)."""

    def __init__(self) -> None:
        day = 86400
        self.now = float(1_800_000_000 - (1_800_000_000 % day) + 100)  # just after midnight

    def __call__(self) -> float:
        return self.now

    def advance(self, seconds: float) -> None:
        self.now += seconds


@pytest.fixture
def clock(monkeypatch: pytest.MonkeyPatch) -> Clock:
    fake = Clock()
    monkeypatch.setattr(time, "time", fake)
    return fake


class Api:
    """JSON calls against /v1 through Django's test client."""

    def __init__(self) -> None:
        self.client = Client()

    def post(self, path: str, body: Any = None, token: str | None = None, **extra: Any) -> Any:
        if token:
            extra["HTTP_AUTHORIZATION"] = f"Bearer {token}"
        return self.client.post(f"/v1{path}", body or {}, content_type="application/json", **extra)

    def put(self, path: str, body: Any = None, token: str | None = None) -> Any:
        extra: dict[str, Any] = {"HTTP_AUTHORIZATION": f"Bearer {token}"} if token else {}
        return self.client.put(f"/v1{path}", body or {}, content_type="application/json", **extra)

    def get(self, path: str, token: str | None = None, **extra: Any) -> Any:
        if token:
            extra["HTTP_AUTHORIZATION"] = f"Bearer {token}"
        return self.client.get(f"/v1{path}", **extra)

    def patch(self, path: str, body: Any = None, token: str | None = None) -> Any:
        extra: dict[str, Any] = {"HTTP_AUTHORIZATION": f"Bearer {token}"} if token else {}
        return self.client.patch(f"/v1{path}", body or {}, content_type="application/json", **extra)

    def delete(self, path: str, token: str | None = None) -> Any:
        extra: dict[str, Any] = {"HTTP_AUTHORIZATION": f"Bearer {token}"} if token else {}
        return self.client.delete(f"/v1{path}", **extra)


@pytest.fixture
def api() -> Api:
    return Api()


def otp_login(
    api: Api,
    phone: str = TEST_NUMBER,
    purpose: str = "login",
    device_id: str = "device-0001",
) -> dict[str, Any]:
    """Send + verify an OTP for a test number. Returns the token response."""
    sent = api.post("/auth/otp/send", {"phone": phone, "purpose": purpose, "deviceId": device_id})
    assert sent.status_code == 200, sent.json()
    resp = api.post(
        "/auth/otp/verify",
        {"phone": phone, "otp": TEST_CODE, "purpose": purpose, "deviceId": device_id},
    )
    assert resp.status_code == 200, resp.json()
    # each send counts towards the resend wait; tests that log in twice clear it
    cache.delete(f"otp:{purpose}:{phone}:resend")
    return dict(resp.json())


@pytest.fixture
def staff_roles(db: None) -> dict[str, "StaffRole"]:
    """The five roles (seeded by a migration, re-created here in case a transactional test
    flushed the database)."""
    from apps.staff.models import StaffRole, StaffRolePermission
    from apps.staff.permissions import ROLE_PERMISSIONS, ROLES

    roles = {}
    for code, name in ROLES.items():
        role, _ = StaffRole.objects.get_or_create(code=code, defaults={"name": name})
        for permission in ROLE_PERMISSIONS[code]:
            StaffRolePermission.objects.get_or_create(role=role, permission=permission)
        roles[code] = role
    return roles


@dataclass
class StaffLogin:
    staff: "StaffUser"
    password: str
    secret: str
    access_token: str
    response: Any


STAFF_PASSWORD = "correct-horse-battery-staple"  # noqa: S105 (test-only value)


def make_staff(
    roles: dict[str, "StaffRole"], role: str = "SUPER_ADMIN", email: str = ""
) -> "StaffUser":
    from apps.staff.models import StaffUser

    staff = StaffUser(
        name="Test Admin", email=email or f"{role.lower()}@wellwish.test", role=roles[role]
    )
    staff.set_password(STAFF_PASSWORD)
    staff.save()
    return staff


def staff_login(api: Api, staff: "StaffUser") -> StaffLogin:
    """Full admin login: password, TOTP setup (first time), TOTP code."""
    step = api.post("/admin/auth/login", {"email": staff.email, "password": STAFF_PASSWORD})
    assert step.status_code == 200, step.json()
    body = step.json()
    secret = body.get("secret") or ""
    if not secret:
        from common import crypto

        staff.refresh_from_db()
        secret = crypto.decrypt(staff.totp_secret_enc)
    resp = api.post(
        "/admin/auth/totp",
        {"challengeToken": body["challengeToken"], "code": pyotp.TOTP(secret).now()},
    )
    assert resp.status_code == 200, resp.json()
    staff.refresh_from_db()
    return StaffLogin(staff, STAFF_PASSWORD, secret, resp.json()["accessToken"], resp)


def staff_token(api: Api, roles: dict[str, "StaffRole"], role: str = "SUPER_ADMIN") -> str:
    """Creates and signs in a staff member with `role` (once per role and test); returns the
    access token."""
    return staff_login(api, make_staff(roles, role)).access_token
