from collections.abc import Callable

from django.apps import AppConfig


class AccountsConfig(AppConfig):
    name = "apps.accounts"
    label = "accounts"
    verbose_name = "Accounts"

    def ready(self) -> None:
        from apps.accounts.models import App
        from common.auth import register_session_validator

        for app in (App.PATIENT, App.PARTNER):
            register_session_validator(app, _validator_for(app))


def _validator_for(app: str) -> Callable[[str, str], bool]:
    from apps.accounts.selectors import session_is_active

    def validate(session_id: str, user_id: str) -> bool:
        return session_is_active(session_id, user_id, app)

    return validate
