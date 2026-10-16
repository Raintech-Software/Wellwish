"""Request/response schemas for staff (admin login, roles)."""

from datetime import datetime
from typing import Literal

from pydantic import Field

from common.schemas import CamelSchema, OkOut, StrictIn

__all__ = ["OkOut"]  # re-exported for the api modules


class StaffLoginIn(StrictIn):
    email: str = Field(..., max_length=254, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    password: str = Field(..., min_length=1, max_length=256)


class StaffTotpIn(StrictIn):
    challenge_token: str = Field(..., max_length=2048)
    code: str = Field(..., pattern=r"^\d{6}$")
    trust_browser: bool = Field(
        False, description="Trust this browser for 30 days: the password alone signs in here"
    )


class StaffRecoveryIn(StrictIn):
    challenge_token: str = Field(..., max_length=2048)
    code: str = Field(..., pattern=r"^[A-Za-z0-9 -]{8,12}$", description="e.g. abcd-2345")


class StaffEmailCodeIn(StrictIn):
    challenge_token: str = Field(..., max_length=2048, description="From the code step")


class StaffEmailCodeOut(CamelSchema):
    challenge_token: str = Field(..., description="Use this one from now on (10 minutes)")
    email_masked: str = Field(..., description="Where the code went, e.g. a•••@wellwish.in")
    resend_after_seconds: int


class RecoveryCodesIn(StrictIn):
    password: str = Field(..., min_length=1, max_length=256)


class RecoveryCodesOut(CamelSchema):
    codes: list[str] = Field(..., description="Shown once: 10 one-time codes")


class StaffRoleOut(CamelSchema):
    code: str
    name: str


class StaffMeOut(CamelSchema):
    id: str
    name: str
    email: str
    role: StaffRoleOut
    permissions: list[str]
    recovery_codes_left: int = Field(..., description="Unused recovery codes (v2.16)")
    recovery_codes_saved: bool = Field(
        ..., description="The admin confirmed saving the current codes (false: warn, make new ones)"
    )
    only_super_admin: bool = Field(
        ..., description="A Super Admin who is the only active one: add a second (v2.16)"
    )


class StaffTokenOut(CamelSchema):
    access_token: str
    expires_in: int
    staff: StaffMeOut
    recovery_codes: list[str] | None = Field(
        None, description="Only right after 2FA was set up: show once, then never again"
    )


class StaffLoginOut(CamelSchema):
    step: Literal["TOTP_SETUP", "TOTP", "SIGNED_IN"] = Field(
        ...,
        description="TOTP_SETUP: first login, show the QR code. TOTP: ask for the code. "
        "SIGNED_IN: a trusted browser (v2.16), the tokens below.",
    )
    challenge_token: str = Field("", description="Empty when SIGNED_IN")
    otpauth_uri: str | None = Field(None, description="Only for TOTP_SETUP: encode as QR code")
    secret: str | None = Field(None, description="Only for TOTP_SETUP: for typing in by hand")
    signed_in: StaffTokenOut | None = Field(None, description="Only for SIGNED_IN")


class PermissionOut(CamelSchema):
    code: str
    description: str


class RoleOut(CamelSchema):
    code: str
    name: str
    permissions: list[str]
    user_count: int


class RolesOut(CamelSchema):
    roles: list[RoleOut]
    permissions: list[PermissionOut]


# --- Staff users page ---

ROLE_PATTERN = r"^(SUPER_ADMIN|OPERATIONS|VERIFICATION|FINANCE|SUPPORT)$"


class StaffUserOut(CamelSchema):
    id: str
    name: str
    email: str
    role: StaffRoleOut
    status: Literal["ACTIVE", "DISABLED"]
    two_factor_set: bool = Field(..., description="False until they scan the QR code")
    last_login_at: datetime | None
    created_at: datetime
    active_sessions: int
    is_you: bool


class StaffUserCreateIn(StrictIn):
    name: str = Field(..., min_length=2, max_length=80)
    email: str = Field(..., max_length=254, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    role: str = Field(..., pattern=ROLE_PATTERN)
    password: str = Field(
        ..., min_length=12, max_length=256, description="First password; tell them in person"
    )


class StaffUserUpdateIn(StrictIn):
    name: str = Field(..., min_length=2, max_length=80)
    role: str = Field(..., pattern=ROLE_PATTERN)


class StaffPasswordIn(StrictIn):
    password: str = Field(..., min_length=12, max_length=256)


class ForceLogoutOut(CamelSchema):
    sessions_ended: int
