"""Dev seed: the Bhubaneswar service area and every setting saved with its default value."""

from decimal import Decimal

from apps.app_config.models import AppSetting, ServiceArea
from apps.app_config.registry import SETTINGS


def seed_app_config() -> None:
    ServiceArea.objects.get_or_create(
        city="Bhubaneswar",
        name="Bhubaneswar city",
        defaults={
            "lat": Decimal("20.296100"),
            "lng": Decimal("85.824500"),
            "radius_km": Decimal("25.0"),
        },
    )
    for spec in SETTINGS:
        AppSetting.objects.get_or_create(key=spec.key, defaults={"value": spec.default})
