"""Accounts endpoints for the partner app (/v1/partner/...).

Partners can log in at any status (§6.3). These endpoints don't need APPROVED.
"""

from django.http import HttpRequest
from ninja import Router

from apps.accounts import selectors, services
from apps.accounts.models import App
from apps.accounts.schemas import (
    ConsentNeededOut,
    ConsentsIn,
    DeviceIn,
    LanguageIn,
    OkOut,
    PartnerMeOut,
)
from apps.partners import selectors as partner_selectors
from common.auth import get_principal, partner_role, temporary_booking
from common.request import client_ip

router = Router(tags=["partner"])


@router.get("/me", response=PartnerMeOut, by_alias=True, operation_id="partnerMeGet")
def me(request: HttpRequest) -> PartnerMeOut:
    """Who is logged in, and their partner status (null until they register in Phase 3)."""
    return _me_out(request)


@router.put("/me/language", response=PartnerMeOut, by_alias=True, operation_id="partnerLanguageSet")
def set_language(request: HttpRequest, data: LanguageIn) -> PartnerMeOut:
    """The app's language and of the messages they get (inbox, push, email; SMS stay English).
    Open at every status, like /me (§5)."""
    principal = get_principal(request)
    services.set_language(user=selectors.get_user(principal.subject_id), language=data.language)
    return _me_out(request)


def _me_out(request: HttpRequest) -> PartnerMeOut:
    principal = get_principal(request)
    user = selectors.get_user(principal.subject_id)
    return PartnerMeOut(
        id=str(user.pk),
        phone=user.phone,
        language=user.language,
        partner_status=principal.partner_status,
        role=partner_role(str(user.pk)),
        temporary_booking_id=temporary_booking(str(user.pk))
        if principal.partner_status == "TEMPORARY"
        else None,
        selfie_today=principal.partner_status is not None
        and partner_selectors.selfie_today(str(user.pk)) is not None,
        consents_needed=[
            ConsentNeededOut(type=t, version=v)  # type: ignore[arg-type]
            for t, v in selectors.consents_needed(str(user.pk), App.PARTNER)
        ],
    )


@router.post(
    "/me/consents", response=PartnerMeOut, by_alias=True, operation_id="partnerConsentsAccept"
)
def accept_consents(request: HttpRequest, data: ConsentsIn) -> PartnerMeOut:
    """The Partner Terms and Privacy Policy, with version, time and IP (§6.20). Open at every
    status: new partners accept before registering, earlier ones at their next app open."""
    services.accept_consents(
        user_id=get_principal(request).subject_id,
        items=[(item.type, item.version) for item in data.items],
        ip=client_ip(request),
        app=App.PARTNER,
    )
    return _me_out(request)


@router.put("/me/device", response=OkOut, by_alias=True, operation_id="partnerDeviceRegister")
def register_device(request: HttpRequest, data: DeviceIn) -> OkOut:
    services.register_device(
        user_id=get_principal(request).subject_id,
        app=App.PARTNER,
        device_id=data.device_id,
        platform=data.platform,
        app_version=data.app_version,
        fcm_token=data.fcm_token,
    )
    return OkOut()
