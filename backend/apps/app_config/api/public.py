"""Public endpoints (/v1/public/...): no login needed."""

from django.http import HttpRequest
from ninja import Router

from apps.app_config.schemas import AppConfigOut, AppVersionsOut, LegalUrlsOut
from apps.app_config.selectors import get_app_config
from apps.legal.selectors import public_urls

router = Router(tags=["public"])


@router.get("/app-config", response=AppConfigOut, by_alias=True, operation_id="publicAppConfig")
def app_config(request: HttpRequest) -> AppConfigOut:
    """Minimum app versions (force update), store links, support number, refund %, account
    deletion waiting time, the legal pages and the account deletion page (§6.20)."""
    values = get_app_config()
    return AppConfigOut(
        min_versions=AppVersionsOut(**values.min_versions),
        store_urls=AppVersionsOut(**values.store_urls),
        support_phone=values.support_phone,
        refund_percent=values.refund_percent,
        account_deletion_days=values.account_deletion_days,
        legal_urls=LegalUrlsOut(**public_urls(request)),
    )
