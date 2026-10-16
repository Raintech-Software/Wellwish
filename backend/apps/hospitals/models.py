"""Hospitals and doctors directory (ARCHITECTURE §6.7). Doctors don't log in and can't be
booked: the directory tells WellWish where the patient goes and whom they see.

Locations are plain latitude/longitude (no PostGIS) with a composite index for the
bounding-box filter in `common.geo.nearby`.
"""

from django.db import models

from common.models import BaseModel


class Speciality(BaseModel):
    name = models.CharField(max_length=60, unique=True)
    name_hi = models.CharField(max_length=60, blank=True, default="")
    name_or = models.CharField(max_length=60, blank=True, default="")
    icon = models.CharField(
        max_length=40, blank=True, default="", help_text="Icon key for the apps"
    )

    class Meta:
        db_table = "specialities"
        ordering = ("name",)
        verbose_name_plural = "specialities"

    def __str__(self) -> str:
        return self.name


class Hospital(BaseModel):
    class Type(models.TextChoices):
        HOSPITAL = "HOSPITAL", "Hospital"
        CLINIC = "CLINIC", "Clinic"
        DIAGNOSTIC = "DIAGNOSTIC", "Diagnostic centre"

    name = models.CharField(max_length=120)
    type = models.CharField(max_length=16, choices=Type.choices, default=Type.HOSPITAL)
    address = models.CharField(max_length=300)
    city = models.CharField(max_length=60, blank=True, default="")
    lat = models.DecimalField(max_digits=9, decimal_places=6)
    lng = models.DecimalField(max_digits=9, decimal_places=6)
    phone = models.CharField(max_length=20, blank=True, default="")
    opd_hours = models.CharField(max_length=300, blank=True, default="", help_text="As text")
    departments = models.JSONField(default=list, blank=True, help_text="List of names")
    photo_key = models.CharField(max_length=255, blank=True, default="")
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "hospitals"
        ordering = ("name",)
        indexes = [models.Index(fields=["lat", "lng"], name="hospitals_lat_lng_idx")]

    def __str__(self) -> str:
        return self.name


class Doctor(BaseModel):
    full_name = models.CharField(max_length=80)
    photo_key = models.CharField(max_length=255, blank=True, default="")
    speciality = models.ForeignKey(Speciality, on_delete=models.PROTECT, related_name="doctors")
    qualifications = models.CharField(max_length=200, blank=True, default="")
    opd_info = models.CharField(
        max_length=300, blank=True, default="", help_text="Days and times, as text"
    )
    languages = models.JSONField(default=list, blank=True)
    is_active = models.BooleanField(default=True)
    hospitals: "models.ManyToManyField[Hospital, DoctorHospital]" = models.ManyToManyField(
        Hospital, through="DoctorHospital", related_name="doctors"
    )

    class Meta:
        db_table = "doctors"
        ordering = ("full_name",)

    def __str__(self) -> str:
        return self.full_name


class DoctorHospital(BaseModel):
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    hospital = models.ForeignKey(Hospital, on_delete=models.CASCADE)

    class Meta:
        db_table = "doctor_hospitals"
        constraints = [
            models.UniqueConstraint(fields=["doctor", "hospital"], name="doctor_hospital_uniq")
        ]

    def __str__(self) -> str:
        return f"{self.doctor_id} @ {self.hospital_id}"
