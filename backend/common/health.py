"""GET /v1/health — used by docker compose, the load balancer and monitoring."""

import logging

import redis
from django.conf import settings
from django.db import connection
from django.http import HttpRequest
from ninja import Router
from ninja.responses import Status

from common.schemas import CamelSchema

logger = logging.getLogger(__name__)
router = Router(tags=["health"])


class HealthOut(CamelSchema):
    status: str
    db: str
    redis: str
    env: str


def _check_db() -> str:
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        return "ok"
    except Exception:
        logger.exception("Health check: database unavailable")
        return "error"


def _check_redis() -> str:
    try:
        client = redis.Redis.from_url(settings.REDIS_URL, socket_connect_timeout=2)
        client.ping()
        return "ok"
    except Exception:
        logger.exception("Health check: redis unavailable")
        return "error"


@router.get(
    "/health",
    response={200: HealthOut, 503: HealthOut},
    by_alias=True,
    summary="Service health",
    operation_id="health",
)
def health(request: HttpRequest) -> Status:
    db, rds = _check_db(), _check_redis()
    ok = db == "ok" and rds == "ok"
    body = HealthOut(status="ok" if ok else "error", db=db, redis=rds, env=settings.APP_ENV)
    return Status(200 if ok else 503, body)
