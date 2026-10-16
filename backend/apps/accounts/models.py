"""The user identity: one row per phone number (ARCHITECTURE §6.1).

Patient and partner profiles hang off this user (later phases). Admin staff are a separate
table (`staff` app, Phase 1). `is_staff` here only gates the developer-only Django admin.
"""

from typing import Any, ClassVar

from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.db import models

from common.models import BaseModel
from common.phone import normalize_indian_mobile


class UserManager(BaseUserManager["User"]):
    use_in_migrations = True

    def create_user(self, phone: str, password: str | None = None, **extra: Any) -> "User":
        user = self.model(phone=normalize_indian_mobile(phone), **extra)
        if password:
            user.set_password(password)
        else:
            user.set_unusable_password()  # patients and partners log in with OTP
        user.save(using=self._db)
        return user

    def create_superuser(self, phone: str, password: str | None = None, **extra: Any) -> "User":
        extra.setdefault("is_staff", True)
        extra.setdefault("is_superuser", True)
        if not password:
            raise ValueError("A superuser needs a password.")
        return self.create_user(phone, password, **extra)


class User(BaseModel, AbstractBaseUser, PermissionsMixin):
    class Status(models.TextChoices):
        ACTIVE = "ACTIVE", "Active"
        BLOCKED = "BLOCKED", "Blocked"
        DELETED = "DELETED", "Deleted"

    class Language(models.TextChoices):
        ENGLISH = "en", "English"
        HINDI = "hi", "Hindi"
        ODIA = "or", "Odia"

    phone = models.CharField(max_length=16, unique=True, help_text="E.164, e.g. +919876543210")
    phone_verified_at = models.DateTimeField(null=True, blank=True)
    email = models.EmailField(blank=True, default="")
    google_sub = models.CharField(max_length=255, null=True, blank=True, unique=True)
    status = models.CharField(max_length=16, choices=Status.choices, default=Status.ACTIVE)
    language = models.CharField(max_length=8, choices=Language.choices, default=Language.ENGLISH)
    is_staff = models.BooleanField(default=False, help_text="Developer access to the Django admin")
    is_active = models.BooleanField(default=True)

    objects: ClassVar[UserManager] = UserManager()

    USERNAME_FIELD = "phone"
    REQUIRED_FIELDS: ClassVar[list[str]] = []

    class Meta:
        db_table = "users"

    def __str__(self) -> str:
        return f"User {self.id}"


class App(models.TextChoices):
    """Which mobile app a session or device belongs to. Staff sessions live in the staff app."""

    PATIENT = "patient", "Patient app"
    PARTNER = "partner", "Partner app"


class Session(BaseModel):
    """One row per refresh token (ARCHITECTURE §6.4).

    All tokens of one login share a `family_id`, which is the `sid` in the access token.
    Using a refresh token marks its row `rotated_at` and creates the next row. If a rotated
    token is used again, the whole family is revoked (reuse detection).
    """

    class RevokeReason(models.TextChoices):
        LOGOUT = "LOGOUT", "Logged out"
        LOGOUT_ALL = "LOGOUT_ALL", "Logged out everywhere"
        LOGGED_IN_ELSEWHERE = "LOGGED_IN_ELSEWHERE", "Logged in on another device"
        REUSE_DETECTED = "REUSE_DETECTED", "Refresh token reused"
        ACCOUNT_BLOCKED = "ACCOUNT_BLOCKED", "Account blocked or suspended"
        ACCOUNT_DELETED = "ACCOUNT_DELETED", "Account deletion requested"
        JOB_OVER = "JOB_OVER", "Temporary partner: the job is over (§6.19)"

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sessions")
    app = models.CharField(max_length=16, choices=App.choices)
    device_id = models.CharField(max_length=64)
    family_id = models.UUIDField(db_index=True)
    refresh_hash = models.CharField(max_length=64, unique=True)
    expires_at = models.DateTimeField()
    rotated_at = models.DateTimeField(null=True, blank=True)
    revoked_at = models.DateTimeField(null=True, blank=True)
    revoke_reason = models.CharField(
        max_length=24, choices=RevokeReason.choices, blank=True, default=""
    )

    class Meta:
        db_table = "sessions"
        indexes = [models.Index(fields=["user", "app"], name="sessions_user_app_idx")]

    def __str__(self) -> str:
        return f"Session {self.family_id} ({self.app})"


class Device(BaseModel):
    """A phone with one of our apps, for push notifications (FCM)."""

    class Platform(models.TextChoices):
        ANDROID = "android", "Android"
        IOS = "ios", "iOS"

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="devices")
    app = models.CharField(max_length=16, choices=App.choices)
    device_id = models.CharField(max_length=64)
    fcm_token = models.CharField(max_length=512, blank=True, default="")
    platform = models.CharField(max_length=16, choices=Platform.choices)
    app_version = models.CharField(max_length=32, blank=True, default="")

    class Meta:
        db_table = "devices"
        constraints = [
            models.UniqueConstraint(
                fields=["user", "app", "device_id"], name="devices_user_app_device_uniq"
            )
        ]

    def __str__(self) -> str:
        return f"Device {self.device_id} ({self.app})"


class Consent(BaseModel):
    """A consent the user accepted: which document, which version, when, from which IP (§12)."""

    class Type(models.TextChoices):
        TERMS = "TERMS", "Terms of use"
        PRIVACY = "PRIVACY", "Privacy policy"
        HEALTH_DATA = "HEALTH_DATA", "Health data processing"
        PARTNER_TERMS = "PARTNER_TERMS", "Partner terms"  # §6.20 (v2.31)

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="consents")
    type = models.CharField(max_length=16, choices=Type.choices)
    version = models.CharField(max_length=32)
    accepted_at = models.DateTimeField()
    ip = models.GenericIPAddressField(null=True, blank=True)

    class Meta:
        db_table = "consents"
        indexes = [models.Index(fields=["user", "type"], name="consents_user_type_idx")]

    def __str__(self) -> str:
        return f"Consent {self.type} v{self.version}"
