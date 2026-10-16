"""Request/response schemas for accounts: OTP, Google sign-in, tokens, devices, consents."""

from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, OkOut, StrictIn

__all__ = ["OkOut"]  # re-exported for the api modules

OtpPurpose = Literal["login", "partner_primary"]
DeviceId = Field(..., min_length=8, max_length=64, pattern=r"^[A-Za-z0-9._-]+$")
ConsentType = Literal["TERMS", "PRIVACY", "HEALTH_DATA", "PARTNER_TERMS"]
AppLanguage = Literal["en", "hi", "or"]


class OtpSendIn(StrictIn):
    phone: str = Field(..., max_length=20, description="Indian mobile, e.g. 9876543210")
    purpose: OtpPurpose = Field(..., description="login = patient app, partner_primary = partner")
    device_id: str = DeviceId
    app_hash: str = Field(
        "",
        pattern=r"^([A-Za-z0-9+/]{11})?$",
        description="Android SMS Retriever hash, added to the SMS so the app can read it",
    )


class OtpSendOut(CamelSchema):
    expires_in_seconds: int
    resend_after_seconds: int
    length: int


class OtpVerifyIn(StrictIn):
    phone: str = Field(..., max_length=20)
    otp: str = Field(..., pattern=r"^\d{6}$")
    purpose: OtpPurpose
    device_id: str = DeviceId
    google_link_token: str | None = Field(
        None, max_length=2048, description="From /auth/google when it answered PHONE_REQUIRED"
    )
    language: AppLanguage | None = Field(
        None,
        description="The app's language at login (the phone's): a new account starts in it (§5)",
    )


class LanguageIn(StrictIn):
    language: AppLanguage


class TokenOut(CamelSchema):
    access_token: str
    refresh_token: str
    expires_in: int = Field(..., description="Seconds until the access token expires")
    token_type: str = "Bearer"  # noqa: S105 (the token kind, not a secret)
    is_new_user: bool = False


class GoogleIn(StrictIn):
    id_token: str = Field(..., max_length=4096)
    device_id: str = DeviceId


class GoogleOut(CamelSchema):
    status: Literal["LOGGED_IN", "PHONE_REQUIRED"]
    tokens: TokenOut | None = None
    google_link_token: str | None = None


class RefreshIn(StrictIn):
    refresh_token: str = Field(..., max_length=256)


class DeviceIn(StrictIn):
    device_id: str = DeviceId
    platform: Literal["android", "ios"]
    app_version: str = Field(..., max_length=32)
    fcm_token: str = Field("", max_length=512)


class ConsentItemIn(StrictIn):
    type: ConsentType
    version: str = Field(..., max_length=32)


class ConsentsIn(StrictIn):
    items: list[ConsentItemIn] = Field(..., min_length=1, max_length=3)


class ConsentNeededOut(CamelSchema):
    type: ConsentType
    version: str


class PartnerMeOut(CamelSchema):
    id: str
    phone: str
    language: str
    partner_status: str | None = Field(
        None, description="null until the partner registers (Phase 3)"
    )
    role: str | None = None
    temporary_booking_id: str | None = Field(
        None, description="§6.19: a TEMPORARY partner's one booking (the app opens only this job)"
    )
    selfie_today: bool = Field(
        False,
        description="Today's selfie is taken (India date): a TEMPORARY partner's app asks first",
    )
    consents_needed: list[ConsentNeededOut] = Field(
        default_factory=list,
        description="Partner Terms and Privacy Policy not accepted in their current version "
        "(§6.20): the app shows the consent screen first",
    )
