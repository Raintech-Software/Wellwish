"""Admin login and staff endpoints (/v1/admin/..., ARCHITECTURE §6.4, §9.2).

The refresh token lives in an httpOnly cookie scoped to /v1/admin/auth, so page scripts can't
read it. The admin panel talks to the API through its own origin (Next.js proxies /v1), so the
cookie is first-party. Refresh and logout also need the `X-WW-Client: admin` header, which a
cross-site form can't send.
"""

from django.conf import settings
from django.http import HttpRequest, HttpResponse
from django.utils import timezone
from ninja import Router

from apps.staff import selectors, services
from apps.staff.models import StaffUser
from apps.staff.permissions import PERMISSIONS
from apps.staff.schemas import (
    OkOut,
    PermissionOut,
    RecoveryCodesIn,
    RecoveryCodesOut,
    RoleOut,
    RolesOut,
    StaffEmailCodeIn,
    StaffEmailCodeOut,
    StaffLoginIn,
    StaffLoginOut,
    StaffMeOut,
    StaffRecoveryIn,
    StaffRoleOut,
    StaffTokenOut,
    StaffTotpIn,
)
from common.auth import get_principal, staff_permission
from common.errors import PermissionDenied
from common.request import client_ip

router = Router(tags=["admin"])

CLIENT_HEADER = "HTTP_X_WW_CLIENT"


def _me(staff: StaffUser) -> StaffMeOut:
    return StaffMeOut(
        id=str(staff.pk),
        name=staff.name,
        email=staff.email,
        role=StaffRoleOut(code=staff.role.code, name=staff.role.name),
        permissions=sorted(selectors.permissions_for(str(staff.pk))),
        recovery_codes_left=selectors.recovery_codes_left(str(staff.pk)),
        recovery_codes_saved=staff.recovery_codes_saved_at is not None,
        only_super_admin=selectors.only_super_admin(staff),
    )


def _set_refresh_cookie(response: HttpResponse, tokens: services.StaffTokens) -> None:
    max_age = int((tokens.session_expires_at - timezone.now()).total_seconds())
    response.set_cookie(
        settings.STAFF_REFRESH_COOKIE,
        tokens.refresh_token,
        max_age=max(max_age, 0),
        path=settings.STAFF_REFRESH_COOKIE_PATH,
        secure=settings.STAFF_COOKIE_SECURE,
        httponly=True,
        samesite="Strict",
    )


def _set_trust_cookie(response: HttpResponse, token: str) -> None:
    """The "Trust this browser for 30 days" cookie (v2.16): same rules as the refresh cookie."""
    response.set_cookie(
        settings.STAFF_TRUST_COOKIE,
        token,
        max_age=settings.STAFF_TRUST_DAYS * 24 * 60 * 60,
        path=settings.STAFF_REFRESH_COOKIE_PATH,
        secure=settings.STAFF_COOKIE_SECURE,
        httponly=True,
        samesite="Strict",
    )


def _clear_refresh_cookie(response: HttpResponse) -> None:
    response.delete_cookie(
        settings.STAFF_REFRESH_COOKIE, path=settings.STAFF_REFRESH_COOKIE_PATH, samesite="Strict"
    )


def _require_admin_client(request: HttpRequest) -> None:
    if request.META.get(CLIENT_HEADER) != "admin":
        raise PermissionDenied(code="CLIENT_HEADER_MISSING", message="Missing client header.")


def _token_out(tokens: services.StaffTokens) -> StaffTokenOut:
    return StaffTokenOut(
        access_token=tokens.access_token,
        expires_in=tokens.expires_in,
        staff=_me(tokens.staff),
        recovery_codes=tokens.recovery_codes,
    )


def _step_out(step: services.LoginStep) -> StaffLoginOut:
    return StaffLoginOut(
        step=step.step,  # type: ignore[arg-type]
        challenge_token=step.challenge_token,
        otpauth_uri=step.otpauth_uri,
        secret=step.secret,
        signed_in=_token_out(step.tokens) if step.tokens else None,
    )


@router.post(
    "/auth/login", response=StaffLoginOut, by_alias=True, auth=None, operation_id="adminAuthLogin"
)
def login(request: HttpRequest, response: HttpResponse, data: StaffLoginIn) -> StaffLoginOut:
    """Step 1: email + password. Then ask for the authenticator code (first time: show the QR).
    In a browser the admin trusted (v2.16), signed in at once (`SIGNED_IN`)."""
    step = services.login(
        email=data.email,
        password=data.password,
        ip=client_ip(request),
        trust_token=request.COOKIES.get(settings.STAFF_TRUST_COOKIE) or None,
    )
    if step.tokens is not None:
        _set_refresh_cookie(response, step.tokens)
    return _step_out(step)


@router.post(
    "/auth/totp", response=StaffTokenOut, by_alias=True, auth=None, operation_id="adminAuthTotp"
)
def totp(request: HttpRequest, response: HttpResponse, data: StaffTotpIn) -> StaffTokenOut:
    """Step 2: the 6-digit authenticator code. Sets the refresh cookie (and the trusted-browser
    cookie when asked). Right after 2FA was set up, the answer has the 10 recovery codes."""
    tokens = services.verify_totp(
        challenge_token=data.challenge_token,
        code=data.code,
        ip=client_ip(request),
        trust_browser=data.trust_browser,
        browser=request.META.get("HTTP_USER_AGENT", ""),
    )
    _set_refresh_cookie(response, tokens)
    if tokens.trust_token:
        _set_trust_cookie(response, tokens.trust_token)
    return _token_out(tokens)


@router.post(
    "/auth/recovery",
    response=StaffLoginOut,
    by_alias=True,
    auth=None,
    operation_id="adminAuthRecovery",
)
def recovery(request: HttpRequest, data: StaffRecoveryIn) -> StaffLoginOut:
    """Lost phone (v2.16): a recovery code instead of the 2FA code. Answers TOTP_SETUP: scan the
    new QR code on the new phone (the old authenticator stops working). 401
    RECOVERY_CODE_INVALID; wrong codes count like wrong 2FA codes."""
    step = services.use_recovery_code(
        challenge_token=data.challenge_token, code=data.code, ip=client_ip(request)
    )
    return _step_out(step)


@router.post(
    "/auth/email-code",
    response=StaffEmailCodeOut,
    by_alias=True,
    auth=None,
    operation_id="adminAuthEmailCode",
)
def email_code(request: HttpRequest, data: StaffEmailCodeIn) -> StaffEmailCodeOut:
    """Phone lost or not at hand (v2.18): a 6-digit code to the admin's work email, typed in the
    same box as the authenticator code (`/auth/totp` with the challenge returned here). 429
    EMAIL_CODE_TOO_SOON {retryAfterSeconds} / EMAIL_CODE_RATE_LIMITED; 401 LOGIN_EXPIRED."""
    sent = services.send_email_code(challenge_token=data.challenge_token, ip=client_ip(request))
    return StaffEmailCodeOut(
        challenge_token=sent.challenge_token,
        email_masked=sent.email_masked,
        resend_after_seconds=sent.resend_after_seconds,
    )


@router.post(
    "/auth/refresh",
    response=StaffTokenOut,
    by_alias=True,
    auth=None,
    operation_id="adminAuthRefresh",
)
def refresh(request: HttpRequest, response: HttpResponse) -> StaffTokenOut:
    """New access token from the refresh cookie (12 h from sign-in, 30-min idle logout)."""
    _require_admin_client(request)
    token = request.COOKIES.get(settings.STAFF_REFRESH_COOKIE, "")
    if not token:
        raise services.StaffSessionInvalid()
    try:
        tokens = services.refresh(refresh_token=token, ip=client_ip(request))
    except (services.StaffSessionInvalid, services.StaffSessionIdle):
        _clear_refresh_cookie(response)
        raise
    _set_refresh_cookie(response, tokens)
    return _token_out(tokens)


@router.post(
    "/auth/logout", response=OkOut, by_alias=True, auth=None, operation_id="adminAuthLogout"
)
def logout(request: HttpRequest, response: HttpResponse) -> OkOut:
    _require_admin_client(request)
    services.logout(
        refresh_token=request.COOKIES.get(settings.STAFF_REFRESH_COOKIE),
        session_id=None,
        ip=client_ip(request),
    )
    _clear_refresh_cookie(response)
    return OkOut()


@router.get("/me", response=StaffMeOut, by_alias=True, operation_id="adminMeGet")
def me(request: HttpRequest) -> StaffMeOut:
    """The signed-in staff member and their permissions (the panel builds its menu from them)."""
    return _me(selectors.get_staff(get_principal(request).subject_id))


@router.post(
    "/me/recovery-codes",
    response=RecoveryCodesOut,
    by_alias=True,
    operation_id="adminRecoveryCodesCreate",
)
def recovery_codes(request: HttpRequest, data: RecoveryCodesIn) -> RecoveryCodesOut:
    """10 new recovery codes, shown once; the old ones stop working (v2.16). Needs the
    password (422 WRONG_PASSWORD)."""
    codes = services.new_recovery_codes(
        staff_id=get_principal(request).subject_id, password=data.password, ip=client_ip(request)
    )
    return RecoveryCodesOut(codes=codes)


@router.post(
    "/me/recovery-codes/saved",
    response=StaffMeOut,
    by_alias=True,
    operation_id="adminRecoveryCodesSaved",
)
def recovery_codes_saved(request: HttpRequest) -> StaffMeOut:
    """The admin says "I've saved them" after the codes were shown (at 2FA setup, or new ones).
    Until then `/me` has `recoveryCodesSaved: false` and the panel warns."""
    staff = services.confirm_recovery_codes_saved(
        staff_id=get_principal(request).subject_id, ip=client_ip(request)
    )
    return _me(staff)


@router.get("/roles", response=RolesOut, by_alias=True, operation_id="adminRolesList")
@staff_permission("staff.manage")
def roles(request: HttpRequest) -> RolesOut:
    """The five admin roles and what each can do (§9.2). Read-only."""
    return RolesOut(
        roles=[
            RoleOut(code=role.code, name=role.name, permissions=perms, user_count=count)
            for role, perms, count in selectors.roles_with_permissions()
        ],
        permissions=[PermissionOut(code=c, description=d) for c, d in PERMISSIONS.items()],
    )
