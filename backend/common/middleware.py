"""Every write to the API is rate limited (§12, PHASES 9.3).

POST / PUT / PATCH / DELETE under /v1/ count per minute: per caller (their access token) and per
IP (higher, for many families behind one hospital Wi-Fi). Over the limit: 429 TOO_MANY_REQUESTS
with Retry-After. The stricter limits of codes and sign-in (OTP, admin login) stay as they are.
Left out: sign-in and token refresh (they have their own, stricter limits; a shared hospital or
mobile-network IP must never log people out) and the dev-only file stand-ins. Razorpay's signed
webhook counts per IP only. The token and the IP are only kept hashed (common.ratelimit).
"""

from collections.abc import Callable

from django.conf import settings
from django.http import HttpRequest, HttpResponse, JsonResponse

from common.errors import error_body
from common.ratelimit import Limit
from common.request import client_ip

WRITES = frozenset({"POST", "PUT", "PATCH", "DELETE"})
EXEMPT = ("/v1/files/", "/v1/auth/", "/v1/admin/auth/")
PER_IP_ONLY = ("/v1/webhooks/",)


class WriteRateLimitMiddleware:
    def __init__(self, get_response: Callable[[HttpRequest], HttpResponse]):
        self.get_response = get_response

    def __call__(self, request: HttpRequest) -> HttpResponse:
        if (
            request.method in WRITES
            and request.path.startswith("/v1/")
            and not request.path.startswith(EXEMPT)
        ):
            refused = self._over_the_limit(request)
            if refused is not None:
                return refused
        return self.get_response(request)

    @staticmethod
    def _over_the_limit(request: HttpRequest) -> HttpResponse | None:
        checks: list[tuple[Limit, str]] = []
        per_caller = settings.WRITE_RATE_LIMIT_PER_MINUTE
        per_ip = settings.WRITE_RATE_LIMIT_PER_IP_MINUTE
        auth = request.META.get("HTTP_AUTHORIZATION", "")
        if per_caller and auth.startswith("Bearer ") and not request.path.startswith(PER_IP_ONLY):
            checks.append((Limit("write:caller", per_caller, 60), auth[7:]))
        if per_ip:
            checks.append((Limit("write:ip", per_ip, 60), client_ip(request)))
        for limit, ident in checks:
            if limit.hit(ident) > limit.max_hits:
                retry = limit.retry_after()
                response = JsonResponse(
                    error_body(
                        "TOO_MANY_REQUESTS",
                        "Too many changes in a minute. Please wait a moment and try again.",
                        {"retryAfterSeconds": retry},
                    ),
                    status=429,
                )
                response["Retry-After"] = str(retry)
                return response
        return None
