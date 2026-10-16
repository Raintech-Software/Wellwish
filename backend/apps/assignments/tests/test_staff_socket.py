"""The admin panel's live socket (PHASES 7.9; ARCHITECTURE §10.4)."""

import pytest
from asgiref.sync import async_to_sync
from channels.db import database_sync_to_async
from channels.testing import WebsocketCommunicator

from common import realtime
from config.asgi import application
from conftest import Api, staff_token


async def _connect(path: str) -> WebsocketCommunicator:
    communicator = WebsocketCommunicator(application, path)
    connected, _ = await communicator.connect()
    assert connected
    return communicator


@pytest.mark.django_db(transaction=True)
def test_admins_get_queue_and_alerts_by_role(staff_roles):
    ops = staff_token(Api(), staff_roles, "OPERATIONS")
    verification = staff_token(Api(), staff_roles, "VERIFICATION")

    async def run() -> tuple[dict, dict, dict]:
        ops_socket = await _connect("/ws/staff/")
        await ops_socket.send_json_to({"type": "auth", "token": ops})
        assert (await ops_socket.receive_json_from(timeout=5))["type"] == "auth.ok"
        reviewer = await _connect("/ws/staff/")
        await reviewer.send_json_to({"type": "auth", "token": verification})
        assert (await reviewer.receive_json_from(timeout=5))["type"] == "auth.ok"
        await database_sync_to_async(realtime.send_to_group)(
            "staff.ops", "queue.changed", {"bookingId": "b-1", "reason": "NEW"}
        )
        await database_sync_to_async(realtime.send_to_group)(
            "staff.partners", "alert", {"kind": "NEW_APPLICATION"}
        )
        queue = await ops_socket.receive_json_from(timeout=5)
        application_alert = await reviewer.receive_json_from(timeout=5)
        # Operations doesn't review applications; Verification doesn't see the booking queue
        nothing_for_ops = await ops_socket.receive_nothing(timeout=0.5)
        nothing_for_reviewer = await reviewer.receive_nothing(timeout=0.5)
        await ops_socket.disconnect()
        await reviewer.disconnect()
        return queue, application_alert, {"ops": nothing_for_ops, "rev": nothing_for_reviewer}

    queue, application_alert, quiet = async_to_sync(run)()
    assert queue == {"type": "queue.changed", "data": {"bookingId": "b-1", "reason": "NEW"}}
    assert application_alert == {"type": "alert", "data": {"kind": "NEW_APPLICATION"}}
    assert quiet == {"ops": True, "rev": True}


@pytest.mark.django_db(transaction=True)
def test_a_partner_token_cannot_open_the_staff_socket():
    from apps.partners.tests.support import partner_login

    token = partner_login(Api(), "+919811100009", device_id="device-9", accept_terms=False)

    async def run() -> int:
        socket = await _connect("/ws/staff/")
        await socket.send_json_to({"type": "auth", "token": token})
        return (await socket.receive_output(timeout=5))["code"]

    assert async_to_sync(run)() == 4001
