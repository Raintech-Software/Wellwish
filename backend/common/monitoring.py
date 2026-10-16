"""Error monitoring (Sentry) without personal or secret data (ARCHITECTURE §12: no OTPs, tokens,
full phone numbers, Aadhaar or medical text may leave the server).

- Request bodies and local variables are never attached (they hold OTPs, tokens, phones).
- Headers and cookies are dropped (Authorization, the staff refresh cookie).
- Query strings are dropped.
- Every text left (exception values, messages, breadcrumbs) is masked with `common.redact`
  (phones, tokens, codes, Aadhaar numbers), Phase 9.3.
"""

from typing import Any

from common.redact import redact

SENT_REQUEST_FIELDS = ("method", "url")


def scrub_event(event: dict[str, Any], hint: dict[str, Any] | None = None) -> dict[str, Any]:
    """Sentry `before_send`: keep only the method and the path of the request."""
    request = event.get("request")
    if isinstance(request, dict):
        kept = {key: request[key] for key in SENT_REQUEST_FIELDS if key in request}
        if isinstance(kept.get("url"), str):
            kept["url"] = kept["url"].split("?", 1)[0]
        event["request"] = kept
    event.pop("user", None)
    for exception in (event.get("exception") or {}).get("values", []) or []:
        if isinstance(exception.get("value"), str):
            exception["value"] = redact(exception["value"])
        for frame in (exception.get("stacktrace") or {}).get("frames", []) or []:
            frame.pop("vars", None)
    if isinstance(event.get("message"), str):
        event["message"] = redact(event["message"])
    logentry = event.get("logentry")
    if isinstance(logentry, dict):
        for key in ("message", "formatted"):
            if isinstance(logentry.get(key), str):
                logentry[key] = redact(logentry[key])
        logentry.pop("params", None)
    if isinstance(event.get("extra"), dict):  # e.g. a Celery task's arguments
        event["extra"] = _redact_all(event["extra"])
    breadcrumbs = event.get("breadcrumbs")
    values = breadcrumbs.get("values", []) if isinstance(breadcrumbs, dict) else []
    for crumb in values or []:
        scrub_breadcrumb(crumb)
    return event


def _redact_all(value: Any) -> Any:
    """Every text inside, however deep (lists, dicts)."""
    if isinstance(value, str):
        return redact(value)
    if isinstance(value, dict):
        return {k: _redact_all(v) for k, v in value.items()}
    if isinstance(value, list | tuple):
        return [_redact_all(v) for v in value]
    return value


def scrub_breadcrumb(crumb: dict[str, Any], hint: dict[str, Any] | None = None) -> dict[str, Any]:
    """Sentry `before_breadcrumb`: a log line, an SQL query or a cache key may hold a phone."""
    if isinstance(crumb.get("message"), str):
        crumb["message"] = redact(crumb["message"])
    data = crumb.get("data")
    if isinstance(data, dict):
        crumb["data"] = _redact_all(data)
    return crumb


def init_sentry(dsn: str, environment: str) -> None:
    import sentry_sdk

    sentry_sdk.init(
        dsn=dsn,
        environment=environment,
        send_default_pii=False,
        include_local_variables=False,
        max_request_body_size="never",
        before_send=scrub_event,  # type: ignore[arg-type]
        before_breadcrumb=scrub_breadcrumb,
    )
