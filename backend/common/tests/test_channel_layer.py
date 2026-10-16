"""The real Redis channel layer (tests otherwise use the in-memory one).

Phase 1 found that idle sockets died after 5 s: channels_redis waits 5 s on Redis for each
message and redis-py 8's default read timeout is also 5 s. This test keeps that fixed.
"""

import asyncio

from asgiref.sync import async_to_sync
from channels_redis.core import RedisChannelLayer
from django.conf import settings

from config.settings import base


def test_redis_read_timeout_is_longer_than_the_channel_wait():
    host = base.CHANNEL_LAYERS["default"]["CONFIG"]["hosts"][0]
    assert host["socket_timeout"] > RedisChannelLayer.brpop_timeout


def test_a_receive_can_wait_longer_than_five_seconds():
    # own prefix, so the running dev server's channels are never touched
    layer = RedisChannelLayer(prefix="wellwish-test", **base.CHANNEL_LAYERS["default"]["CONFIG"])

    async def run() -> dict:
        channel = await layer.new_channel()

        async def send_later() -> None:
            await asyncio.sleep(RedisChannelLayer.brpop_timeout + 1.5)
            await layer.send(channel, {"type": "push", "ok": True})

        sender = asyncio.ensure_future(send_later())
        message = await asyncio.wait_for(layer.receive(channel), timeout=20)
        await sender
        await layer.close_pools()
        return message

    assert settings.REDIS_URL  # runs against the compose Redis
    assert async_to_sync(run)() == {"type": "push", "ok": True}
