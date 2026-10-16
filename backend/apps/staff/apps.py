from django.apps import AppConfig


class StaffConfig(AppConfig):
    name = "apps.staff"
    label = "staff"
    verbose_name = "Staff"

    def ready(self) -> None:
        from apps.staff.selectors import permissions_for
        from apps.staff.services import touch_session
        from common.auth import register_session_validator, register_staff_permissions

        register_session_validator("staff", touch_session)
        register_staff_permissions(permissions_for)
