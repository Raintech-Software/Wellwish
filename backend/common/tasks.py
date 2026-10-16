from typing import Any

from celery import shared_task
from django.utils.module_loading import import_string


@shared_task(name="common.ping")
def ping() -> str:
    """Smoke test: `ping.delay().get(timeout=10)` returns 'pong' when a worker is running."""
    return "pong"


@shared_task(name="common.publish_metrics")
def publish_metrics() -> dict[str, int]:
    """Every minute: the numbers behind the CloudWatch alarms (§13)."""
    from common import metrics

    return metrics.publish()


@shared_task(
    name="common.run_event_handler",
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_backoff_max=300,
    max_retries=3,
)
def run_event_handler(handler_path: str, event_name: str, payload: dict[str, Any]) -> None:
    import_string(handler_path)(event_name, payload)
