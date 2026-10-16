from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules


class CommonConfig(AppConfig):
    name = "common"
    verbose_name = "Common"

    def ready(self) -> None:
        # Import every app's events.py so its @subscribe handlers are registered.
        autodiscover_modules("events")
