"""Admin-editable settings, service areas and blocked times (ARCHITECTURE §6.17, §9.1, §11)."""

from django.db import models

from common.models import BaseModel


class AppSetting(BaseModel):
    """One row per changed setting. Keys and defaults are in registry.py."""

    key = models.CharField(max_length=60, unique=True)
    value = models.JSONField()
    updated_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )

    class Meta:
        db_table = "app_settings"

    def __str__(self) -> str:
        return self.key


class ServiceArea(BaseModel):
    """Bookings are allowed only for addresses inside an active area (centre + radius)."""

    city = models.CharField(max_length=60)
    name = models.CharField(max_length=80)
    lat = models.DecimalField(max_digits=9, decimal_places=6)
    lng = models.DecimalField(max_digits=9, decimal_places=6)
    radius_km = models.DecimalField(max_digits=5, decimal_places=1)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "service_areas"
        ordering = ("city", "name")

    def __str__(self) -> str:
        return f"{self.city}: {self.name}"


class BlockedTime(BaseModel):
    """A date or time range patients can't book (holiday, fully booked)."""

    class ServiceType(models.TextChoices):
        COMPANION = "COMPANION", "Companion services"
        NURSE = "NURSE", "Nurse services"

    from_ts = models.DateTimeField()
    to_ts = models.DateTimeField()
    reason = models.CharField(max_length=200)
    service_type = models.CharField(
        max_length=16, choices=ServiceType.choices, blank=True, default="", help_text="Empty = all"
    )
    created_by = models.ForeignKey(
        "staff.StaffUser", on_delete=models.PROTECT, null=True, blank=True, related_name="+"
    )

    class Meta:
        db_table = "blocked_times"
        ordering = ("from_ts",)
        constraints = [
            models.CheckConstraint(
                condition=models.Q(to_ts__gt=models.F("from_ts")), name="blocked_times_range"
            )
        ]
        indexes = [models.Index(fields=["from_ts", "to_ts"], name="blocked_times_range_idx")]

    def __str__(self) -> str:
        return f"{self.from_ts:%Y-%m-%d %H:%M} to {self.to_ts:%Y-%m-%d %H:%M}"
