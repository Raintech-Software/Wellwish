"""Authorization (ARCHITECTURE §6.5): audience → role/status/permission → ownership.

1. `SessionJWTAuth("patient")` on each top-level router: a valid access token for that app
   AND an active session. Anything else is 401.
2. Role, status and permission checks are decorators on the endpoint:

       @router.get("/offers")
       @partner_status("APPROVED")
       def offers(request): ...

       @router.post("/bookings/{id}/assign")
       @staff_permission("bookings.manage")
       def assign(request, id: UUID): ...

3. Ownership is checked in every selector (a failed check is a 404, never a 403).

`common` must not import the apps, so apps register their checks when Django starts
(`register_session_validator`, `register_partner_status_resolver`, `register_staff_permissions`).
"""

import functools
import re
from collections.abc import Callable
from dataclasses import dataclass, field
from typing import Any, TypeVar, cast

from django.http import HttpRequest
from ninja.security import HttpBearer

from common.errors import NotFound, PermissionDenied
from common.tokens import InvalidToken, decode_access_token

# (session id, subject id) → is the session still active?
SessionValidator = Callable[[str, str], bool]
# user id → partner status (None = not registered as a partner)
PartnerStatusResolver = Callable[[str], str | None]
# user id → partner role COMPANION / NURSE (None = not registered as a partner)
PartnerRoleResolver = Callable[[str], str | None]
# user id → the one booking a TEMPORARY partner may open (§6.19), or None
TemporaryBookingResolver = Callable[[str], str | None]
# staff id → set of permission codes
StaffPermissionsResolver = Callable[[str], frozenset[str]]

_session_validators: dict[str, SessionValidator] = {}
# Until the partners app exists (Phase 3) nobody is a registered partner.
_partner_status_resolver: PartnerStatusResolver = lambda user_id: None  # noqa: E731
_partner_role_resolver: PartnerRoleResolver = lambda user_id: None  # noqa: E731
_temporary_booking_resolver: TemporaryBookingResolver = lambda user_id: None  # noqa: E731
_staff_permissions_resolver: StaffPermissionsResolver = lambda staff_id: frozenset()  # noqa: E731


def register_session_validator(audience: str, validator: SessionValidator) -> None:
    _session_validators[audience] = validator


def register_partner_resolvers(
    *,
    status: PartnerStatusResolver,
    role: PartnerRoleResolver,
    temporary_booking: TemporaryBookingResolver | None = None,
) -> None:
    """Called by the partners app (Phase 3) when Django starts."""
    global _partner_status_resolver, _partner_role_resolver, _temporary_booking_resolver
    _partner_status_resolver = status
    _partner_role_resolver = role
    if temporary_booking is not None:
        _temporary_booking_resolver = temporary_booking


def partner_role(user_id: str) -> str | None:
    return _partner_role_resolver(user_id)


def temporary_booking(user_id: str) -> str | None:
    """A TEMPORARY partner's one booking (§6.19), or None."""
    return _temporary_booking_resolver(user_id)


def register_staff_permissions(resolver: StaffPermissionsResolver) -> None:
    global _staff_permissions_resolver
    _staff_permissions_resolver = resolver


@dataclass
class Principal:
    """Who is calling. Set as `request.auth` by `SessionJWTAuth`."""

    subject_id: str  # user id (patient/partner) or staff id
    audience: str
    profile_id: str | None
    role: str | None
    session_id: str
    _cache: dict[str, Any] = field(default_factory=dict, repr=False)

    @property
    def partner_status(self) -> str | None:
        if "partner_status" not in self._cache:
            self._cache["partner_status"] = _partner_status_resolver(self.subject_id)
        return cast("str | None", self._cache["partner_status"])

    @property
    def permissions(self) -> frozenset[str]:
        if "permissions" not in self._cache:
            self._cache["permissions"] = _staff_permissions_resolver(self.subject_id)
        return cast(frozenset[str], self._cache["permissions"])


def authenticate_token(token: str, audiences: tuple[str, ...]) -> Principal | None:
    """Shared by HTTP and WebSocket auth. None = not allowed."""
    try:
        claims = decode_access_token(token, audiences)
    except InvalidToken:
        return None
    validator = _session_validators.get(claims.aud)
    if validator is None or not validator(claims.sid, claims.sub):
        return None
    return Principal(
        subject_id=claims.sub,
        audience=claims.aud,
        profile_id=claims.pid,
        role=claims.role,
        session_id=claims.sid,
    )


class SessionJWTAuth(HttpBearer):
    """Bearer access token for one (or more) apps, with an active session."""

    def __init__(self, *audiences: str) -> None:
        super().__init__()
        self.audiences = audiences

    def authenticate(self, request: HttpRequest, token: str) -> Principal | None:
        return authenticate_token(token, self.audiences)


TEMPORARY_JOB_PATH = re.compile(
    r"^/(?:jobs/(?P<booking_id>[0-9a-f-]{36})(?:/documents/[^/]+/view-url)?"
    r"|bookings/(?P<booking_id2>[0-9a-f-]{36})/(?:steps|calls|balance|track-batch|sos"
    r"|patient-not-available))$"
)


class ApprovedPartnerAuth(SessionJWTAuth):
    """The partner router's auth (§6.3, §6.5): a valid partner session, and every endpoint needs
    an APPROVED partner except the paths listed as open (registration, KYC, me, inbox).
    Deny by default, so a new partner endpoint can't be forgotten."""

    def __init__(self, *, prefix: str, open_paths: tuple[str, ...], open_prefixes: tuple[str, ...]):
        super().__init__("partner")
        self.prefix = prefix
        self.open_paths = open_paths
        self.open_prefixes = open_prefixes

    def authenticate(self, request: HttpRequest, token: str) -> Principal | None:
        principal = super().authenticate(request, token)
        if principal is None:
            return None
        path = request.path.removeprefix(self.prefix)
        if path in self.open_paths or path.startswith(self.open_prefixes):
            return principal
        if principal.partner_status == "TEMPORARY" and self._temporary_may(principal, path):
            return principal
        if principal.partner_status != "APPROVED":
            raise PartnerNotApproved(details={"status": principal.partner_status})
        return principal

    @staticmethod
    def _temporary_may(principal: Principal, path: str) -> bool:
        """A temporary partner (§6.19) opens only their one booking (the job, its steps, calls,
        location points, SOS, balance) and today's selfie. Offers, availability, totals and
        every other booking stay closed."""
        if path == "/me/selfie":
            return True
        match = TEMPORARY_JOB_PATH.match(path)
        if match is None:
            return False
        booking_id = match["booking_id"] or match["booking_id2"]
        if booking_id != _temporary_booking_resolver(principal.subject_id):
            raise NotFound()  # someone else's booking: ownership failures are 404
        return True


def get_principal(request: HttpRequest) -> Principal:
    return cast(Principal, request.auth)  # type: ignore[attr-defined]


F = TypeVar("F", bound=Callable[..., Any])


class PartnerNotApproved(PermissionDenied):
    code = "PARTNER_NOT_APPROVED"
    message = "Your partner account isn't approved yet."


def partner_status(*allowed: str) -> Callable[[F], F]:
    """Only partners whose status is one of `allowed` (§6.3: most endpoints need APPROVED)."""

    def decorator(func: F) -> F:
        @functools.wraps(func)
        def wrapper(request: HttpRequest, *args: Any, **kwargs: Any) -> Any:
            principal = get_principal(request)
            if principal.audience != "partner" or principal.partner_status not in allowed:
                raise PartnerNotApproved(details={"allowed": list(allowed)})
            return func(request, *args, **kwargs)

        return cast(F, wrapper)

    return decorator


def staff_permission(permission: str) -> Callable[[F], F]:
    """Only staff whose role has `permission` (§9.2)."""

    def decorator(func: F) -> F:
        @functools.wraps(func)
        def wrapper(request: HttpRequest, *args: Any, **kwargs: Any) -> Any:
            principal = get_principal(request)
            if principal.audience != "staff" or permission not in principal.permissions:
                raise PermissionDenied(details={"permission": permission})
            return func(request, *args, **kwargs)

        wrapper.required_permissions = (permission,)  # type: ignore[attr-defined]  # §12 test
        return cast(F, wrapper)

    return decorator


def staff_any_permission(*permissions: str) -> Callable[[F], F]:
    """Staff whose role has at least one of `permissions`."""

    def decorator(func: F) -> F:
        @functools.wraps(func)
        def wrapper(request: HttpRequest, *args: Any, **kwargs: Any) -> Any:
            principal = get_principal(request)
            if principal.audience != "staff" or not principal.permissions.intersection(permissions):
                raise PermissionDenied(details={"permission": list(permissions)})
            return func(request, *args, **kwargs)

        wrapper.required_permissions = permissions  # type: ignore[attr-defined]  # §12 test
        return cast(F, wrapper)

    return decorator
