"""Saved addresses (ARCHITECTURE §6.18, §11). Each one belongs to the account owner **and** a
family member: when booking for Mother, only Mother's addresses are offered."""

from django.conf import settings
from django.db import models

from apps.patients.models import Member
from common.models import BaseModel


class Address(BaseModel):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="addresses"
    )
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name="addresses")
    label = models.CharField(max_length=40, help_text="Home, Daughter's flat…")
    line1 = models.CharField(max_length=200)
    landmark = models.CharField(max_length=120, blank=True, default="")
    notes = models.CharField(max_length=300, blank=True, default="", help_text="Gate, floor, lift")
    lat = models.DecimalField(max_digits=9, decimal_places=6)
    lng = models.DecimalField(max_digits=9, decimal_places=6)
    in_service_area = models.BooleanField(
        default=False, help_text="Checked when saved; a booking checks again (§9.1)"
    )
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "addresses"
        indexes = [
            models.Index(fields=["user", "is_active"], name="addresses_user_active_idx"),
            models.Index(fields=["member", "is_active"], name="addresses_member_active_idx"),
        ]

    def __str__(self) -> str:
        return f"Address {self.id}"
