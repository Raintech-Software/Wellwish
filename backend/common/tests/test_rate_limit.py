"""§12 / PHASES 9.3: every write to the API is rate limited, per caller and per IP."""

import pytest
from django.core.cache import cache

from apps.patients.tests.support import patient
from common.ratelimit import Limit

pytestmark = pytest.mark.django_db

DEVICE = {"deviceId": "rate-limit-phone", "platform": "android", "appVersion": "1.0.0"}


def test_writes_per_caller(api, settings):
    settings.WRITE_RATE_LIMIT_PER_MINUTE = 3
    settings.WRITE_RATE_LIMIT_PER_IP_MINUTE = 100
    token = patient(api)
    for _ in range(3):
        assert api.put("/patient/me/device", DEVICE, token=token).status_code == 200
    refused = api.put("/patient/me/device", DEVICE, token=token)
    assert refused.status_code == 429
    assert refused.json()["error"]["code"] == "TOO_MANY_REQUESTS"
    assert int(refused["Retry-After"]) > 0
    # reading isn't limited; another person isn't slowed down by this one
    for _ in range(5):
        assert api.get("/patient/me", token).status_code == 200
    other = patient(api, phone="+919000000002", device_id="other-phone")
    assert api.put("/patient/me/device", DEVICE, token=other).status_code == 200


def test_writes_per_ip_and_sign_in_is_left_out(api, settings):
    settings.WRITE_RATE_LIMIT_PER_MINUTE = 0
    settings.WRITE_RATE_LIMIT_PER_IP_MINUTE = 2
    statuses = [api.put("/patient/me/device", DEVICE).status_code for _ in range(3)]
    assert statuses[:2] == [401, 401] and statuses[2] == 429  # counted before the login check
    # sign-in and token refresh have their own limits: a shared IP never logs people out
    for _ in range(4):
        assert api.post("/auth/refresh", {"refreshToken": "x" * 40}).status_code != 429


def test_the_webhook_counts_per_ip_only(api, settings):
    """Razorpay posts from a few IPs; a flood of bad signatures from one IP is slowed down."""
    from django.core.cache import cache

    from common import metrics

    cache.clear()
    settings.WRITE_RATE_LIMIT_PER_MINUTE = 1
    settings.WRITE_RATE_LIMIT_PER_IP_MINUTE = 3
    statuses = [api.post("/webhooks/razorpay", {}).status_code for _ in range(4)]
    assert statuses == [400, 400, 400, 429]
    taken = metrics.take_counts()
    assert taken["WebhookBadSignatures"] == 3 and taken["WebhookFailures"] == 0


def test_the_cache_never_holds_the_phone_number():
    limit = Limit("otp:phone:hour", max_hits=5, window_seconds=3600)
    limit.hit("+919876543210")
    keys = list(cache._cache.keys()) if hasattr(cache, "_cache") else []  # locmem in tests
    assert keys and not any("9876543210" in str(k) for k in keys)
