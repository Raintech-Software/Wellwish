"""Live location during a job (ARCHITECTURE §6.11): the latest point lives in Redis while the
job runs; the route is saved here when it ends."""

from django.db import models

from common.models import BaseModel


class BookingTrack(BaseModel):
    """The partner's route for one job, saved at Completed / patient not available."""

    booking = models.OneToOneField(
        "bookings.Booking", on_delete=models.CASCADE, related_name="track"
    )
    polyline = models.TextField(help_text="Google encoded polyline (lat, lng at 1e-5)")
    points_count = models.PositiveIntegerField()
    km = models.DecimalField(max_digits=7, decimal_places=2)
    started_at = models.DateTimeField(null=True, blank=True)
    ended_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "booking_tracks"

    def __str__(self) -> str:
        return f"Track {self.booking_id} ({self.points_count} points)"
