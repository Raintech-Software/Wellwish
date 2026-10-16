from django.apps import AppConfig


class BookingsConfig(AppConfig):
    name = "apps.bookings"
    label = "bookings"
    verbose_name = "Bookings"

    def ready(self) -> None:
        from apps.bookings.models import Booking
        from common import usage

        # Services, hospitals and doctors used in a booking are deactivated, never deleted.
        usage.register("service", lambda pk: Booking.objects.filter(service_id=pk).exists())
        usage.register("hospital", lambda pk: Booking.objects.filter(hospital_id=pk).exists())
        usage.register("doctor", lambda pk: Booking.objects.filter(doctor_id=pk).exists())
