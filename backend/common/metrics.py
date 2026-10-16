"""Numbers for the CloudWatch alarms (ARCHITECTURE §13, PHASES 9.5).

- Failures and timeouts are counted where they happen (`count("SmsFailures")`), in Redis.
- Once a minute (`publish`, a beat task) the counts are taken, and these are measured: paid
  bookings still without a partner 30 minutes later, SOS not acknowledged within 2 minutes.
- They go to CloudWatch (`put_metric_data` with the server's IAM role, no keys) only when
  `CLOUDWATCH_NAMESPACE` is set (e.g. "WellWish/production"); otherwise they're only logged.
  The alarms on them are in infra/cloudwatch/alarms.json. 5xx and response times come from
  the load balancer's own metrics.
"""

import datetime as dt
import logging

from django.conf import settings
from django.core.cache import cache
from django.utils import timezone

logger = logging.getLogger(__name__)

COUNTS = (
    "SmsFailures",
    "EmailFailures",
    "WebhookFailures",
    "WebhookBadSignatures",
    "OfferTimeouts",
)
UNASSIGNED_AFTER = dt.timedelta(minutes=30)
KEY = "metric:{name}"
KEEP_S = 24 * 3600


def count(name: str, n: int = 1) -> None:
    """One more of `name`. Never breaks the caller (a metric is not worth a failed request)."""
    key = KEY.format(name=name)
    try:
        if not cache.add(key, n, timeout=KEEP_S):
            cache.incr(key, n)
    except Exception as exc:
        logger.warning("Metric %s not counted: %s", name, type(exc).__name__)


def take_counts() -> dict[str, int]:
    """The counts since the last call (one that comes in meanwhile is kept for the next)."""
    out: dict[str, int] = {}
    for name in COUNTS:
        key = KEY.format(name=name)
        value = int(cache.get(key) or 0)
        if value:
            cache.decr(key, value)
        out[name] = value
    return out


def measure(now: dt.datetime) -> dict[str, int]:
    from apps.assignments import selectors as assignments
    from apps.safety import selectors as safety

    return {
        "UnassignedOver30Min": assignments.unassigned_count(settled_before=now - UNASSIGNED_AFTER),
        "SosUnacknowledged": safety.unacknowledged_count(now=now),
    }


def publish(*, now: dt.datetime | None = None) -> dict[str, int]:
    now = now or timezone.now()
    if not cache.add("metric:publishing", 1, timeout=50):
        return {}  # another run is publishing this minute
    try:
        values = take_counts() | measure(now)
    finally:
        cache.delete("metric:publishing")
    namespace = settings.CLOUDWATCH_NAMESPACE
    if namespace:
        try:
            import boto3  # type: ignore[import-untyped]

            boto3.client("cloudwatch", region_name=settings.CLOUDWATCH_REGION).put_metric_data(
                Namespace=namespace,
                MetricData=[
                    {"MetricName": name, "Value": value, "Unit": "Count", "Timestamp": now}
                    for name, value in values.items()
                ],
            )
        except Exception as exc:
            logger.warning("Metrics not sent to CloudWatch: %s", type(exc).__name__)
    if any(values.values()):
        logger.info("Metrics: %s", values)
    return values
