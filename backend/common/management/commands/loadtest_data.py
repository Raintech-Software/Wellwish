"""`python manage.py loadtest_data` — the people of the load test (PHASES 9.4).

Only with `config.settings.loadtest`, which has its own database (`.\\ww.ps1 loadtest` makes it
fresh each time), so the developer's data is never touched.

- `--partners` approved partners, each on a job already **in progress** (the visit's state is
  set directly: the load test is about the live location, not the steps before it), with the
  family that booked it;
- `--patients` more patients, each with a family member and a home address, who book during
  the test.

Their access tokens go to `.loadtest/users.json` (git-ignored) for Locust. Tokens last 15
minutes: the test starts right after.
"""

import datetime as dt
import json
import uuid
from decimal import Decimal
from pathlib import Path
from typing import Any

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError, CommandParser
from django.test import Client
from django.utils import timezone

from apps.accounts.services import _log_in
from apps.app_config.models import ServiceArea
from apps.bookings.models import Booking, BookingStatus
from apps.hospitals.seed import seed_directory
from apps.partners.models import PartnerProfile, PartnerRole, PartnerStatus
from apps.services.models import Service
from apps.services.seed import seed_services

CENTRE = (Decimal("20.296100"), Decimal("85.824500"))  # Bhubaneswar
SERVICE = "Elderly care at home (4 h)"  # a home visit: a member and an address are enough
MEMBER = {
    "relation": "MOTHER",
    "fullName": "Load Test Mother",
    "dob": "1950-01-01",
    "gender": "FEMALE",
    "photoKey": "",
    "phone": "",
    "language": "Odia",
    "conditions": "",
    "allergies": "",
    "mobility": "NEEDS_SUPPORT",
    "sensoryNotes": "",
    "emergencyName": "",
    "emergencyPhone": "",
    "consent": True,
}


class Command(BaseCommand):
    help = "Load-test people and live jobs (only on the load-test database)."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("--partners", type=int, default=100)
        parser.add_argument("--patients", type=int, default=100)
        out = Path(settings.BASE_DIR) / ".loadtest" / "users.json"
        parser.add_argument("--out", default=str(out))

    def handle(self, *args: Any, **options: Any) -> None:
        if not getattr(settings, "LOADTEST", False):
            raise CommandError("Only with config.settings.loadtest (its own database).")
        seed_services()
        seed_directory()
        ServiceArea.objects.get_or_create(
            name="Bhubaneswar",
            defaults={"city": "Bhubaneswar", "lat": CENTRE[0], "lng": CENTRE[1], "radius_km": 25},
        )
        self.client = Client()
        self.service = Service.objects.get(name=SERVICE)
        self.slots = self._slots()

        patients = [self._patient(f"+9171000{i:05d}") for i in range(options["patients"])]
        partners = [self._partner_on_a_job(i) for i in range(options["partners"])]
        out = Path(options["out"])
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(
            json.dumps(
                {"serviceId": str(self.service.pk), "partners": partners, "patients": patients}
            )
        )
        self.stdout.write(
            f"{len(partners)} partners on a live job, {len(patients)} patients → {out}"
        )

    # --- helpers -------------------------------------------------------------------------

    def _api(self, method: str, path: str, token: str, body: Any = None, **extra: Any) -> Any:
        resp = getattr(self.client, method)(
            f"/v1{path}",
            data=json.dumps(body) if body is not None else None,
            content_type="application/json",
            HTTP_AUTHORIZATION=f"Bearer {token}",
            **extra,
        )
        if resp.status_code >= 400:
            body_text = resp.content[:300]
            raise CommandError(f"{method.upper()} {path}: {resp.status_code} {body_text!r}")
        return resp.json()

    def _slots(self) -> list[str]:
        """Free pickup times over the booking window, one job each."""
        token = _log_in("+917199999999", "login", "lt-slots", None).tokens.access_token
        first = self._api("get", f"/patient/booking-times?serviceId={self.service.pk}", token)
        slots: list[str] = []
        for day in first["days"]:
            if day["available"]:
                times = self._api(
                    "get",
                    f"/patient/booking-times?serviceId={self.service.pk}&date={day['date']}",
                    token,
                )["times"]
                slots.extend(times)
        return slots

    def _patient(self, phone: str) -> dict[str, str]:
        token = _log_in(phone, "login", f"lt-{phone[-6:]}", None).tokens.access_token
        member = self._api("post", "/patient/members", token, MEMBER)
        address = self._api(
            "post",
            "/patient/addresses",
            token,
            {
                "memberId": member["id"],
                "label": "Home",
                "line1": "Plot 1, Saheed Nagar, Bhubaneswar 751007",
                "landmark": "",
                "notes": "",
                "lat": str(CENTRE[0]),
                "lng": str(CENTRE[1]),
            },
        )
        return {"token": token, "memberId": member["id"], "addressId": address["id"]}

    def _partner_on_a_job(self, i: int) -> dict[str, Any]:
        login = _log_in(f"+9170000{i:05d}", "partner_primary", f"lt-partner-{i}", None)
        lat = CENTRE[0] + Decimal(i % 10) / 100
        lng = CENTRE[1] + Decimal(i // 10) / 100
        partner = PartnerProfile.objects.create(
            user=login.user,
            role=PartnerRole.COMPANION,
            status=PartnerStatus.APPROVED,
            full_name=f"Load Partner {i}",
            lat=lat,
            lng=lng,
            languages=["Odia"],
            available_today=True,
            approved_at=timezone.now(),
        )
        family = self._patient(f"+9172000{i:05d}")
        booking = self._api(
            "post",
            "/patient/bookings",
            family["token"],
            {
                "serviceId": str(self.service.pk),
                "memberId": family["memberId"],
                "addressId": family["addressId"],
                "pickupAt": self.slots[i % len(self.slots)],
                "documentIds": [],
                "notes": "",
            },
            HTTP_IDEMPOTENCY_KEY=uuid.uuid4().hex,
        )
        # the visit has started: "On the way" (the steps before are not what's measured)
        Booking.objects.filter(pk=booking["id"]).update(
            status=BookingStatus.IN_PROGRESS,
            partner=partner,
            current_step="ON_THE_WAY",
            pickup_at=timezone.now() + dt.timedelta(minutes=30),
        )
        return {
            "token": login.tokens.access_token,
            "bookingId": booking["id"],
            "lat": float(lat),
            "lng": float(lng),
            "familyToken": family["token"],
        }
