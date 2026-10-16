"""Live updates over WebSockets (ARCHITECTURE §6.14).

- Endpoints `/ws/patient/`, `/ws/partner/`, `/ws/staff/` (admins: `staff.ops`, `staff.partners`).
- The app sends the access token as the FIRST message: `{"type": "auth", "token": "..."}`.
  It is never put in the URL (URLs end up in logs).
- After auth the socket joins `user.{app}.{id}` and `session.{sid}`.
- Server messages are `{"type": "booking.updated", "data": {...}}`. Send them with
  `send_to_group()` inside `transaction.on_commit`, so nothing goes out for a rolled-back change.
"""

import asyncio
import logging
from typing import Any

from asgiref.sync import async_to_sync
from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer
from channels.layers import get_channel_layer
from django.utils import timezone

from common.auth import Principal, authenticate_token
from common.errors import ApiError

logger = logging.getLogger(__name__)

AUTH_TIMEOUT_SECONDS = 10
CLOSE_UNAUTHORIZED = 4001
CLOSE_SESSION_REVOKED = 4003


def user_group(audience: str, user_id: str) -> str:
    """One group per app: a person using both apps gets each app's messages only there."""
    return f"user.{audience}.{user_id}"


def session_group(session_id: str) -> str:
    return f"session.{session_id}"


def send_to_group(group: str, message_type: str, data: dict[str, Any]) -> None:
    """Call from synchronous code (services, Celery tasks), inside on_commit."""
    layer = get_channel_layer()
    if layer is None:
        return
    async_to_sync(layer.group_send)(
        group, {"type": "push", "message": {"type": message_type, "data": data}}
    )


class AppSocketConsumer(AsyncJsonWebsocketConsumer):
    """Authenticated socket for one app (`audience`)."""

    audience: str = ""

    async def connect(self) -> None:
        self.principal: Principal | None = None
        self.groups_joined: list[str] = []
        await self.accept()
        self.auth_timer = asyncio.get_running_loop().call_later(
            AUTH_TIMEOUT_SECONDS, lambda: asyncio.ensure_future(self._auth_timeout())
        )

    async def _auth_timeout(self) -> None:
        if self.principal is None:
            await self.close(code=CLOSE_UNAUTHORIZED)

    async def receive_json(self, content: Any, **kwargs: Any) -> None:
        if self.principal is None:
            await self._authenticate(content)
            return
        await self.handle_message(content)

    async def _authenticate(self, content: Any) -> None:
        token = content.get("token") if isinstance(content, dict) else None
        if not isinstance(content, dict) or content.get("type") != "auth" or not token:
            await self.close(code=CLOSE_UNAUTHORIZED)
            return
        principal = await database_sync_to_async(authenticate_token)(str(token), (self.audience,))
        if principal is None:
            await self.close(code=CLOSE_UNAUTHORIZED)
            return
        self.principal = principal
        self.auth_timer.cancel()
        for group in (
            user_group(principal.audience, principal.subject_id),
            session_group(principal.session_id),
        ):
            await self.channel_layer.group_add(group, self.channel_name)
            self.groups_joined.append(group)
        await self.joined(principal)
        await self.send_json({"type": "auth.ok", "data": {}})

    async def joined(self, principal: Principal) -> None:
        """More groups after login (the admin's by permission)."""

    async def handle_message(self, content: Any) -> None:
        """App → server messages (e.g. location updates in Phase 8). None yet."""

    async def push(self, event: dict[str, Any]) -> None:
        message = event["message"]
        if message.get("type") == "socket.rejoin":
            # the role changed: the client refreshes its token and joins its new groups
            await self.close(code=CLOSE_UNAUTHORIZED)
            return
        await self.send_json(message)
        if message.get("type") == "session.revoked":
            await self.close(code=CLOSE_SESSION_REVOKED)

    async def disconnect(self, code: int) -> None:
        timer = getattr(self, "auth_timer", None)
        if timer is not None:
            timer.cancel()
        for group in getattr(self, "groups_joined", []):
            await self.channel_layer.group_discard(group, self.channel_name)


class PatientSocketConsumer(AppSocketConsumer):
    audience = "patient"


# Admin groups by what the role may see (§9.2).
STAFF_GROUPS = {
    "staff.ops": ("bookings.view", "live.view", "support.manage"),  # queue, alerts, SOS, tickets
    "staff.partners": ("partners.review",),  # new partner applications
}


class StaffSocketConsumer(AppSocketConsumer):
    """`/ws/staff/`: the admin panel's live queue and alerts (§10.4)."""

    audience = "staff"

    async def joined(self, principal: Principal) -> None:
        permissions = await database_sync_to_async(lambda: set(principal.permissions))()
        for group, needs in STAFF_GROUPS.items():
            if permissions.intersection(needs):
                await self.channel_layer.group_add(group, self.channel_name)
                self.groups_joined.append(group)


class PartnerSocketConsumer(AppSocketConsumer):
    audience = "partner"

    async def handle_message(self, content: Any) -> None:
        """`location.update` every 10 s during a job (§6.11): checked, kept and passed on to the
        family and the admins. A refused point answers `location.rejected` with the reason
        (INVALID, MOCK, INACCURATE, TOO_FAST, NOT_IN_PROGRESS). A live point carries the
        server's time (the phone's clock may be wrong)."""
        if not isinstance(content, dict) or content.get("type") != "location.update":
            return
        data = content.get("data")
        if not isinstance(data, dict) or self.principal is None:
            return
        from apps.tracking import services as tracking

        try:
            booking_id = str(data["bookingId"])
            lat, lng = float(data["lat"]), float(data["lng"])
            accuracy = float(data["accuracy"]) if data.get("accuracy") is not None else None
        except (KeyError, TypeError, ValueError):
            return
        point = tracking.Point(
            lat=lat, lng=lng, accuracy=accuracy, at=timezone.now(), mock=bool(data.get("mock"))
        )
        try:
            why = await database_sync_to_async(tracking.record_point)(
                booking_id=booking_id, partner_user_id=self.principal.subject_id, point=point
            )
        except ApiError:
            why = "NOT_IN_PROGRESS"  # e.g. not a booking id
        except Exception:
            logger.exception("A live point could not be saved")  # the socket stays open
            return
        if why:
            await self.send_json(
                {"type": "location.rejected", "data": {"bookingId": booking_id, "reason": why}}
            )
