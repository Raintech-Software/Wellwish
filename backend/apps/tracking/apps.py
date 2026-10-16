from django.apps import AppConfig


class TrackingConfig(AppConfig):
    name = "apps.tracking"
    label = "tracking"
    verbose_name = "Tracking (live location during a job)"

    def ready(self) -> None:
        from apps.tracking import events  # noqa: F401  (registers event handlers)
