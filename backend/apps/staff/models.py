"""Admin panel users, roles and sessions (ARCHITECTURE §6.4, §9.2, §11).

Staff are a separate table from patients/partners. Login: email + password (Argon2) + TOTP.
Staff are never deleted (the audit log points to them): they are disabled.
"""

from django.contrib.auth.hashers import check_password, make_password
from django.db import models

from common.models import BaseModel


class StaffRole(BaseModel):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=64)

    class Meta:
        db_table = "staff_roles"

    def __str__(self) -> str:
        return self.name


class StaffRolePermission(BaseModel):
    role = models.ForeignKey(StaffRole, on_delete=models.CASCADE, related_name="permissions")
    permission = models.CharField(max_length=64)

    class Meta:
        db_table = "staff_role_permissions"
        constraints = [
            models.UniqueConstraint(fields=["role", "permission"], name="staff_role_perm_uniq")
        ]

    def __str__(self) -> str:
        return f"{self.role_id}:{self.permission}"


class StaffUser(BaseModel):
    class Status(models.TextChoices):
        ACTIVE = "ACTIVE", "Active"
        DISABLED = "DISABLED", "Disabled"

    name = models.CharField(max_length=80)
    email = models.EmailField(unique=True, help_text="Stored lower-case")
    password_hash = models.CharField(max_length=256)
    totp_secret_enc = models.TextField(blank=True, default="", help_text="Fernet-encrypted")
    totp_confirmed_at = models.DateTimeField(null=True, blank=True)
    totp_last_step = models.BigIntegerField(
        null=True, blank=True, help_text="Last TOTP time step used (a code works once)"
    )
    recovery_codes_saved_at = models.DateTimeField(
        null=True,
        blank=True,
        help_text="When the admin confirmed saving the current recovery codes (empty: not yet)",
    )
    role = models.ForeignKey(StaffRole, on_delete=models.PROTECT, related_name="users")
    status = models.CharField(max_length=16, choices=Status.choices, default=Status.ACTIVE)
    last_login_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "staff_users"

    def __str__(self) -> str:
        return f"StaffUser {self.id}"

    def set_password(self, raw: str) -> None:
        self.password_hash = make_password(raw)

    def check_password(self, raw: str) -> bool:
        return bool(self.password_hash) and check_password(raw, self.password_hash)


class StaffSession(BaseModel):
    """One row per refresh token, like accounts.Session, with the admin rules: 12 h from login,
    logged out after 30 minutes without activity (§6.4)."""

    class RevokeReason(models.TextChoices):
        LOGOUT = "LOGOUT", "Logged out"
        IDLE = "IDLE", "Idle for too long"
        REUSE_DETECTED = "REUSE_DETECTED", "Refresh token reused"
        DISABLED = "DISABLED", "Staff user disabled"
        FORCED = "FORCED", "Logged out by an admin"

    staff = models.ForeignKey(StaffUser, on_delete=models.CASCADE, related_name="sessions")
    family_id = models.UUIDField(db_index=True)
    refresh_hash = models.CharField(max_length=64, unique=True)
    started_at = models.DateTimeField(help_text="When the login happened (same for the family)")
    expires_at = models.DateTimeField(help_text="started_at + 12 h")
    last_seen_at = models.DateTimeField()
    rotated_at = models.DateTimeField(null=True, blank=True)
    revoked_at = models.DateTimeField(null=True, blank=True)
    revoke_reason = models.CharField(
        max_length=24, choices=RevokeReason.choices, blank=True, default=""
    )
    ip = models.GenericIPAddressField(null=True, blank=True)

    class Meta:
        db_table = "staff_sessions"

    def __str__(self) -> str:
        return f"StaffSession {self.family_id}"


class StaffRecoveryCode(BaseModel):
    """One-time codes for signing in when the authenticator app is lost (§6.4, v2.16). Ten are
    given when 2FA is set up and shown once; only an HMAC of each is kept."""

    staff = models.ForeignKey(StaffUser, on_delete=models.CASCADE, related_name="recovery_codes")
    code_hash = models.CharField(max_length=64, unique=True)
    used_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "staff_recovery_codes"

    def __str__(self) -> str:
        return f"StaffRecoveryCode {self.id}"


class StaffTrustedBrowser(BaseModel):
    """The "Trust this browser for 30 days" box (§6.4, v2.16): the right password in this browser
    signs in without the 2FA code. Only a hash of the cookie's token is kept."""

    staff = models.ForeignKey(StaffUser, on_delete=models.CASCADE, related_name="trusted_browsers")
    token_hash = models.CharField(max_length=64, unique=True)
    expires_at = models.DateTimeField()
    last_used_at = models.DateTimeField(null=True, blank=True)
    ip = models.GenericIPAddressField(null=True, blank=True)
    label = models.CharField(max_length=120, blank=True, default="", help_text="The browser")

    class Meta:
        db_table = "staff_trusted_browsers"

    def __str__(self) -> str:
        return f"StaffTrustedBrowser {self.id}"
