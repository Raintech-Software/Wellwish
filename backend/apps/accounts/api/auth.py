"""Login endpoints for the two mobile apps (/v1/auth/..., ARCHITECTURE §10.3).

Public except logout. Staff log in through /v1/admin/auth (staff app).
"""

from django.http import HttpRequest
from ninja import Router

from apps.accounts import services
from apps.accounts.schemas import (
    GoogleIn,
    GoogleOut,
    OkOut,
    OtpSendIn,
    OtpSendOut,
    OtpVerifyIn,
    RefreshIn,
    TokenOut,
)
from common.auth import SessionJWTAuth, get_principal
from common.request import client_ip

router = Router(tags=["auth"])


def _token_out(tokens: services.TokenPair, *, is_new_user: bool = False) -> TokenOut:
    return TokenOut(
        access_token=tokens.access_token,
        refresh_token=tokens.refresh_token,
        expires_in=tokens.expires_in,
        is_new_user=is_new_user,
    )


@router.post("/otp/send", response=OtpSendOut, by_alias=True, auth=None, operation_id="authOtpSend")
def otp_send(request: HttpRequest, data: OtpSendIn) -> OtpSendOut:
    """Send a 6-digit login code by SMS (§6.2)."""
    sent = services.send_login_otp(
        phone=data.phone,
        purpose=data.purpose,
        device_id=data.device_id,
        ip=client_ip(request),
        app_hash=data.app_hash,
    )
    return OtpSendOut(
        expires_in_seconds=sent.expires_in_seconds,
        resend_after_seconds=sent.resend_after_seconds,
        length=sent.length,
    )


@router.post(
    "/otp/verify", response=TokenOut, by_alias=True, auth=None, operation_id="authOtpVerify"
)
def otp_verify(request: HttpRequest, data: OtpVerifyIn) -> TokenOut:
    """Check the code and log in. Patients get a profile and a SELF member on first login."""
    result = services.verify_login_otp(
        phone=data.phone,
        code=data.otp,
        purpose=data.purpose,
        device_id=data.device_id,
        google_link_token=data.google_link_token,
        language=data.language,
    )
    return _token_out(result.tokens, is_new_user=result.is_new_user)


@router.post("/google", response=GoogleOut, by_alias=True, auth=None, operation_id="authGoogle")
def google(request: HttpRequest, data: GoogleIn) -> GoogleOut:
    """Patient app only. PHONE_REQUIRED: verify a phone by OTP and send `googleLinkToken` along."""
    result = services.google_login(id_token=data.id_token, device_id=data.device_id)
    if result.tokens is not None:
        return GoogleOut(status="LOGGED_IN", tokens=_token_out(result.tokens))
    return GoogleOut(status="PHONE_REQUIRED", google_link_token=result.google_link_token)


@router.post("/refresh", response=TokenOut, by_alias=True, auth=None, operation_id="authRefresh")
def refresh(request: HttpRequest, data: RefreshIn) -> TokenOut:
    """Swap a refresh token for new tokens. Each refresh token works once."""
    return _token_out(services.refresh_session(data.refresh_token))


@router.post(
    "/logout",
    response=OkOut,
    by_alias=True,
    auth=SessionJWTAuth("patient", "partner"),
    operation_id="authLogout",
)
def logout(request: HttpRequest) -> OkOut:
    services.logout(session_id=get_principal(request).session_id)
    return OkOut()


@router.post(
    "/logout-all",
    response=OkOut,
    by_alias=True,
    auth=SessionJWTAuth("patient", "partner"),
    operation_id="authLogoutAll",
)
def logout_all(request: HttpRequest) -> OkOut:
    """Log out on every device for this app."""
    principal = get_principal(request)
    services.logout_all(user_id=principal.subject_id, app=principal.audience)
    return OkOut()
