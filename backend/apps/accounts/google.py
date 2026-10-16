"""Google sign-in for the patient app (ARCHITECTURE §6.2: allowed, but the phone must be
verified by OTP once). The app sends Google's ID token; we check it with Google's public keys."""

from dataclasses import dataclass

from django.conf import settings
from google.auth.transport import requests as google_requests
from google.oauth2 import id_token

from common.errors import ApiError

GOOGLE_ISSUERS = ("accounts.google.com", "https://accounts.google.com")


class GoogleTokenInvalid(ApiError):
    status = 401
    code = "GOOGLE_TOKEN_INVALID"
    message = "Google sign-in failed. Please try again."


@dataclass(frozen=True)
class GoogleIdentity:
    sub: str
    email: str


def verify_id_token(token: str) -> GoogleIdentity:
    if not settings.GOOGLE_CLIENT_IDS:
        raise GoogleTokenInvalid(code="GOOGLE_NOT_CONFIGURED", message="Google sign-in is off.")
    try:
        info = id_token.verify_oauth2_token(token, google_requests.Request(), audience=None)
    except ValueError:
        raise GoogleTokenInvalid() from None
    if info.get("aud") not in settings.GOOGLE_CLIENT_IDS or info.get("iss") not in GOOGLE_ISSUERS:
        raise GoogleTokenInvalid()
    email = info.get("email", "") if info.get("email_verified") else ""
    return GoogleIdentity(sub=str(info["sub"]), email=str(email))
