"""Request helpers."""

import ipaddress

from django.conf import settings
from django.http import HttpRequest


def _valid_ip(value: str) -> str | None:
    try:
        return str(ipaddress.ip_address(value.strip()))
    except ValueError:
        return None


def client_ip(request: HttpRequest) -> str:
    """The caller's IP, for rate limits, the audit log and consents.

    Behind our proxy (staging/prod) X-Forwarded-For is "client-supplied…, real client": each
    proxy appends the address it saw. Only the entries our own proxies added can be trusted,
    so read from the right (TRUSTED_PROXY_HOPS entries), never the left, which anyone can fake.
    """
    remote = _valid_ip(str(request.META.get("REMOTE_ADDR") or "")) or "0.0.0.0"  # noqa: S104
    if not settings.TRUST_X_FORWARDED_FOR:
        return remote
    hops = [h for h in request.META.get("HTTP_X_FORWARDED_FOR", "").split(",") if h.strip()]
    trusted: int = settings.TRUSTED_PROXY_HOPS
    if len(hops) < trusted:
        return remote
    return _valid_ip(hops[-trusted]) or remote
