"""Accounts endpoints for the patient app (/v1/patient/...)."""

from django.http import HttpRequest
from ninja import Router

from apps.accounts import services
from apps.accounts.models import App
from apps.accounts.schemas import ConsentsIn, DeviceIn, OkOut
from common.auth import get_principal
from common.request import client_ip

router = Router(tags=["patient"])


@router.put("/me/device", response=OkOut, by_alias=True, operation_id="patientDeviceRegister")
def register_device(request: HttpRequest, data: DeviceIn) -> OkOut:
    """Save this phone (and its push token, once Firebase is set up) for notifications."""
    services.register_device(
        user_id=get_principal(request).subject_id,
        app=App.PATIENT,
        device_id=data.device_id,
        platform=data.platform,
        app_version=data.app_version,
        fcm_token=data.fcm_token,
    )
    return OkOut()


@router.post("/me/consents", response=OkOut, by_alias=True, operation_id="patientConsentsAccept")
def accept_consents(request: HttpRequest, data: ConsentsIn) -> OkOut:
    """Record the terms, privacy and health-data consents with version, time and IP (§12)."""
    services.accept_consents(
        user_id=get_principal(request).subject_id,
        items=[(item.type, item.version) for item in data.items],
        ip=client_ip(request),
    )
    return OkOut()
