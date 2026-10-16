"""Health endpoint, Celery task, WebSocket echo, seed command and OpenAPI document."""

import pytest
from asgiref.sync import async_to_sync
from channels.testing import WebsocketCommunicator
from django.core.management import call_command

from common import health
from common.tasks import ping
from config.api import api
from config.asgi import application


@pytest.mark.django_db
def test_health_ok(client):
    resp = client.get("/v1/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok", "db": "ok", "redis": "ok", "env": "dev"}


@pytest.mark.django_db
def test_health_reports_redis_down(client, monkeypatch):
    monkeypatch.setattr(health, "_check_redis", lambda: "error")
    resp = client.get("/v1/health")
    assert resp.status_code == 503
    assert resp.json()["status"] == "error"
    assert resp.json()["redis"] == "error"


def test_celery_ping_task():
    assert ping.delay().get(timeout=5) == "pong"


@pytest.mark.django_db
def test_websocket_echo():
    async def run():
        communicator = WebsocketCommunicator(application, "/ws/echo/")
        connected, _ = await communicator.connect()
        assert connected
        await communicator.send_json_to({"hello": "wellwish"})
        reply = await communicator.receive_json_from()
        await communicator.disconnect()
        return reply

    assert async_to_sync(run)() == {"type": "echo", "data": {"hello": "wellwish"}}


@pytest.mark.django_db
def test_seed_command_runs(capsys, monkeypatch):
    monkeypatch.delenv("DEV_ADMIN_EMAIL", raising=False)
    call_command("seed")
    out = capsys.readouterr().out
    assert "Seeded: staff" in out
    assert "no dev admin created" in out


def test_openapi_has_health():
    schema = api.get_openapi_schema()
    assert "/v1/health" in schema["paths"]
    assert schema["info"]["title"] == "WellWish API"
