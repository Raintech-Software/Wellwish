"""The service catalogue (ARCHITECTURE §6.6): what patients can book and its fixed price.

Money is integer paise. The booking fee is paid online (WellWish's income); the balance
(price minus booking fee) is paid to the partner after the visit and is always calculated, never
stored or typed. Bookings keep their own price snapshot, so price changes never touch them.
"""

from django.db import models

from common.models import BaseModel


class PartnerType(models.TextChoices):
    COMPANION = "COMPANION", "Companion"
    NURSE = "NURSE", "Nurse"


class VisitType(models.TextChoices):
    """Decides the job steps (§6.11) and the booking form."""

    HOSPITAL_VISIT = "HOSPITAL_VISIT", "Hospital visit"
    HOME_VISIT = "HOME_VISIT", "Home visit"
    ERRAND = "ERRAND", "Errand"


class Service(BaseModel):
    name = models.CharField(max_length=80)
    name_hi = models.CharField(max_length=80, blank=True, default="")
    name_or = models.CharField(max_length=80, blank=True, default="")
    description = models.CharField(max_length=160, blank=True, default="")
    description_hi = models.CharField(max_length=160, blank=True, default="")
    description_or = models.CharField(max_length=160, blank=True, default="")
    partner_type = models.CharField(max_length=16, choices=PartnerType.choices)
    visit_type = models.CharField(max_length=16, choices=VisitType.choices)
    price_paise = models.BigIntegerField(help_text="Total price shown to the patient")
    booking_fee_paise = models.BigIntegerField(help_text="Paid online at booking")
    duration_min = models.PositiveIntegerField(help_text="Blocks the partner's time")
    docs_required = models.BooleanField(
        default=False, help_text="e.g. a prescription for injection and IV"
    )
    is_active = models.BooleanField(default=True)
    sort = models.PositiveIntegerField(default=0)

    class Meta:
        db_table = "services"
        ordering = ("sort", "name")
        constraints = [
            models.CheckConstraint(
                condition=models.Q(booking_fee_paise__gte=0)
                & models.Q(booking_fee_paise__lte=models.F("price_paise")),
                name="services_fee_between_zero_and_price",
            ),
            models.CheckConstraint(
                condition=models.Q(price_paise__gt=0), name="services_price_positive"
            ),
        ]

    def __str__(self) -> str:
        return self.name

    @property
    def balance_paise(self) -> int:
        return self.price_paise - self.booking_fee_paise
