from django.apps import AppConfig


class AssignmentsConfig(AppConfig):
    name = "apps.assignments"
    label = "assignments"
    verbose_name = "Assignments (offers to partners)"

    def ready(self) -> None:
        from apps.assignments import events  # noqa: F401  (registers event handlers)
        from apps.assignments.services import on_cancel, on_reschedule
        from apps.bookings.services import register_cancel_hook, register_reschedule_hook

        # A cancel withdraws the open offer and tells an accepted partner, in its transaction.
        register_cancel_hook(on_cancel)
        # A new time re-confirms with the partner (or releases a busy one).
        register_reschedule_hook(on_reschedule)
