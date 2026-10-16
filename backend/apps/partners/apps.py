from django.apps import AppConfig


class PartnersConfig(AppConfig):
    name = "apps.partners"
    label = "partners"
    verbose_name = "Partners"

    def ready(self) -> None:
        from apps.partners.selectors import (
            open_temporary_booking_id,
            partner_role_of,
            partner_status_of,
        )
        from common.auth import register_partner_resolvers

        register_partner_resolvers(
            status=partner_status_of,
            role=partner_role_of,
            temporary_booking=open_temporary_booking_id,
        )
