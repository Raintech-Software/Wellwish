"""Authorization building blocks (§6.5, PHASES 1.5) and the authenticated WebSocket (§6.14)."""

import pytest
from asgiref.sync import async_to_sync
from channels.db import database_sync_to_async
from channels.testing import WebsocketCommunicator
from django.test import Client
from ninja import NinjaAPI, Router
from ninja.testing import TestClient

from common import auth
from common.auth import SessionJWTAuth, get_principal, partner_status, staff_permission
from common.errors import register_error_handlers
from config.asgi import application
from conftest import TEST_CODE, TEST_NUMBER, Api, make_staff, otp_login, staff_login

# A throwaway API using the real auth class and decorators
test_api = NinjaAPI(urls_namespace="test_auth")
register_error_handlers(test_api)
partner = Router(auth=SessionJWTAuth("partner"))
staff = Router(auth=SessionJWTAuth("staff"))


@partner.get("/offers")
@partner_status("APPROVED")
def offers(request):
    return {"partner": get_principal(request).subject_id}


@partner.get("/kyc")
@partner_status("REGISTERED", "SUBMITTED", "APPROVED")
def kyc(request):
    return {"ok": True}


@staff.post("/assign")
@staff_permission("bookings.manage")
def assign(request):
    return {"ok": True}


test_api.add_router("/partner", partner)
test_api.add_router("/admin", staff)
client = TestClient(test_api)


def bearer(token: str) -> dict:
    return {"Authorization": f"Bearer {token}"}


@pytest.mark.django_db
def test_partner_status_decorator(monkeypatch):
    tokens = otp_login(Api(), purpose="partner_primary", device_id="partner-phone-a")
    headers = bearer(tokens["accessToken"])

    # Phase 1: nobody is a registered partner yet → 403 everywhere that needs a status
    resp = client.get("/partner/offers", headers=headers)
    assert resp.status_code == 403
    assert resp.json()["error"]["code"] == "PARTNER_NOT_APPROVED"

    status = {"value": "SUBMITTED"}
    monkeypatch.setattr(auth, "_partner_status_resolver", lambda user_id: status["value"])
    assert client.get("/partner/kyc", headers=headers).status_code == 200
    assert client.get("/partner/offers", headers=headers).status_code == 403
    status["value"] = "APPROVED"
    assert client.get("/partner/offers", headers=headers).status_code == 200
    status["value"] = "SUSPENDED"
    assert client.get("/partner/offers", headers=headers).status_code == 403
    assert client.get("/partner/kyc", headers=headers).status_code == 403


@pytest.mark.django_db
def test_staff_permission_decorator(staff_roles):
    api = Api()
    ops = staff_login(api, make_staff(staff_roles, role="OPERATIONS"))
    support = staff_login(Api(), make_staff(staff_roles, role="SUPPORT"))
    assert client.post("/admin/assign", headers=bearer(ops.access_token)).status_code == 200
    resp = client.post("/admin/assign", headers=bearer(support.access_token))
    assert resp.status_code == 403
    assert resp.json()["error"]["details"] == {"permission": "bookings.manage"}


@pytest.mark.django_db
def test_wrong_audience_never_reaches_the_decorators():
    patient = otp_login(Api())
    assert client.get("/partner/kyc", headers=bearer(patient["accessToken"])).status_code == 401
    assert client.post("/admin/assign", headers=bearer(patient["accessToken"])).status_code == 401


# --- WebSocket ---


async def _connect(path: str) -> WebsocketCommunicator:
    communicator = WebsocketCommunicator(application, path)
    connected, _ = await communicator.connect()
    assert connected
    return communicator


@pytest.mark.django_db(transaction=True)
def test_socket_needs_a_valid_token_as_first_message():
    async def run() -> tuple[int, int]:
        no_auth = await _connect("/ws/partner/")
        await no_auth.send_json_to({"type": "hello"})
        first = await no_auth.receive_output()
        bad = await _connect("/ws/partner/")
        await bad.send_json_to({"type": "auth", "token": "forged"})
        second = await bad.receive_output()
        return first["code"], second["code"]

    assert async_to_sync(run)() == (4001, 4001)


@pytest.mark.django_db(transaction=True)
def test_patient_token_cannot_open_the_partner_socket():
    patient = otp_login(Api())

    async def run() -> int:
        socket = await _connect("/ws/partner/")
        await socket.send_json_to({"type": "auth", "token": patient["accessToken"]})
        return (await socket.receive_output())["code"]

    assert async_to_sync(run)() == 4001


@pytest.mark.django_db(transaction=True)
def test_second_partner_login_pushes_session_revoked_to_the_first_device():
    first = otp_login(Api(), purpose="partner_primary", device_id="partner-phone-a")

    def login_on_second_phone() -> None:
        api = Api()
        api.post(
            "/auth/otp/send",
            {"phone": TEST_NUMBER, "purpose": "partner_primary", "deviceId": "partner-phone-b"},
        )
        resp = api.post(
            "/auth/otp/verify",
            {
                "phone": TEST_NUMBER,
                "otp": TEST_CODE,
                "purpose": "partner_primary",
                "deviceId": "partner-phone-b",
            },
        )
        assert resp.status_code == 200

    async def run() -> tuple[dict, dict, int]:
        socket = await _connect("/ws/partner/")
        await socket.send_json_to({"type": "auth", "token": first["accessToken"]})
        ok = await socket.receive_json_from(timeout=5)
        await database_sync_to_async(login_on_second_phone)()
        revoked = await socket.receive_json_from(timeout=5)
        closed = await socket.receive_output(timeout=5)
        return ok, revoked, closed["code"]

    ok, revoked, code = async_to_sync(run)()
    assert ok == {"type": "auth.ok", "data": {}}
    assert revoked == {"type": "session.revoked", "data": {"reason": "LOGGED_IN_ELSEWHERE"}}
    assert code == 4003


@pytest.mark.django_db
def test_app_config_is_public():
    resp = Client().get("/v1/public/app-config")
    assert resp.status_code == 200
    body = resp.json()
    assert set(body["minVersions"]) == {"patientAndroid", "patientIos", "partnerAndroid"}
    assert body["refundPercent"] == 50
    assert body["supportPhone"].startswith("+91")
