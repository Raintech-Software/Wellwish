from typing import Any

from channels.generic.websocket import AsyncJsonWebsocketConsumer


class EchoConsumer(AsyncJsonWebsocketConsumer):
    """Dev-only smoke test for WebSockets: sends back whatever it receives."""

    async def connect(self) -> None:
        await self.accept()

    async def receive_json(self, content: Any, **kwargs: Any) -> None:
        await self.send_json({"type": "echo", "data": content})
