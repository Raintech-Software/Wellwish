"""Partner app: registration (/v1/partner/register/*, §6.3, §10.3) and approved-only actions.

Registration works before approval. Everything else under /v1/partner needs APPROVED
(enforced for the whole router in config/api.py).
"""

from django.http import HttpRequest
from ninja import Router

from apps.accounts.schemas import OtpSendOut
from apps.kyc.api.out import status_out
from apps.kyc.schemas import KycStatusOut
from apps.partners import email_codes, selectors, services
from apps.partners.api.out import own_partner
from apps.partners.models import PartnerDeletion
from apps.partners.schemas import (
    AvailabilityIn,
    AvailabilityOut,
    CodeIn,
    EmailIn,
    EmailSentOut,
    PartnerDeletionOut,
    PhoneIn,
    ProfileIn,
    SelfieIn,
    StartIn,
)
from common.auth import get_principal
from common.request import client_ip

router = Router(tags=["partner"])


def _status(request: HttpRequest) -> KycStatusOut:
    return status_out(own_partner(get_principal(request).subject_id))


@router.post(
    "/register/start", response=KycStatusOut, by_alias=True, operation_id="partnerRegisterStart"
)
def start(request: HttpRequest, data: StartIn) -> KycStatusOut:
    """R03: Companion or Nurse. Can be changed until the application is submitted."""
    services.start_registration(user_id=get_principal(request).subject_id, role=data.role)
    return _status(request)


@router.post(
    "/register/alternate-phone",
    response=OtpSendOut,
    by_alias=True,
    operation_id="partnerAlternatePhoneSend",
)
def alternate_phone(request: HttpRequest, data: PhoneIn) -> OtpSendOut:
    """R04: send an OTP to the alternate number (must differ from the login number)."""
    principal = get_principal(request)
    sent = services.request_alternate_otp(
        user_id=principal.subject_id,
        phone=data.phone,
        session_id=principal.session_id,
        ip=client_ip(request),
    )
    return OtpSendOut(
        expires_in_seconds=sent.expires_in_seconds,
        resend_after_seconds=sent.resend_after_seconds,
        length=sent.length,
    )


@router.post(
    "/register/alternate-phone/verify",
    response=KycStatusOut,
    by_alias=True,
    operation_id="partnerAlternatePhoneVerify",
)
def alternate_phone_verify(request: HttpRequest, data: CodeIn) -> KycStatusOut:
    services.verify_alternate_otp(user_id=get_principal(request).subject_id, code=data.code)
    return _status(request)


@router.post(
    "/register/email", response=EmailSentOut, by_alias=True, operation_id="partnerEmailSend"
)
def email(request: HttpRequest, data: EmailIn) -> EmailSentOut:
    """R04: email a 6-digit code."""
    resend_after = services.request_email_code(
        user_id=get_principal(request).subject_id, email=data.email
    )
    return EmailSentOut(
        resend_after_seconds=resend_after, expires_in_seconds=email_codes.CODE_TTL_SECONDS
    )


@router.post(
    "/register/email/verify",
    response=KycStatusOut,
    by_alias=True,
    operation_id="partnerEmailVerify",
)
def email_verify(request: HttpRequest, data: CodeIn) -> KycStatusOut:
    services.verify_email_code(user_id=get_principal(request).subject_id, code=data.code)
    return _status(request)


@router.put(
    "/register/profile", response=KycStatusOut, by_alias=True, operation_id="partnerProfileSave"
)
def profile(request: HttpRequest, data: ProfileIn) -> KycStatusOut:
    """R05: name, DOB, gender, photo, home address + pin, languages, skills, emergency contact."""
    services.update_profile(user_id=get_principal(request).subject_id, data=data.model_dump())
    return _status(request)


@router.patch(
    "/me/availability",
    response=AvailabilityOut,
    by_alias=True,
    operation_id="partnerAvailabilitySet",
)
def availability(request: HttpRequest, data: AvailabilityIn) -> AvailabilityOut:
    """Approved partners: "Available today" (§8.3). Helps the admin choose; no tracking. For
    today's India date only; switching on needs today's selfie (409 SELFIE_REQUIRED)."""
    user_id = get_principal(request).subject_id
    services.set_availability(user_id=user_id, available=data.available_today)
    return _availability(user_id)


def _availability(user_id: str) -> AvailabilityOut:
    partner = own_partner(user_id)
    return AvailabilityOut(
        available_today=selectors.is_available_today(partner),
        selfie_today=selectors.selfie_today(str(partner.pk)) is not None,
    )


@router.get(
    "/me/availability",
    response=AvailabilityOut,
    by_alias=True,
    operation_id="partnerAvailabilityGet",
)
def availability_get(request: HttpRequest) -> AvailabilityOut:
    """R08: whether the partner is available today and has taken today's selfie."""
    return _availability(get_principal(request).subject_id)


@router.post(
    "/me/selfie",
    response=AvailabilityOut,
    by_alias=True,
    operation_id="partnerSelfieAdd",
)
def selfie(request: HttpRequest, data: SelfieIn) -> AvailabilityOut:
    """The once-a-day selfie before going available (§6.15): upload it with the
    `partner_selfie` upload URL, then send its `fileKey`. The admin spot-checks them."""
    user_id = get_principal(request).subject_id
    services.record_selfie(user_id=user_id, file_key=data.file_key)
    return _availability(user_id)


@router.post(
    "/me/delete",
    response=PartnerDeletionOut,
    by_alias=True,
    operation_id="partnerDeleteAccount",
)
def delete_account(request: HttpRequest) -> PartnerDeletionOut:
    """Delete my account (§6.20), at any status. You are logged out on every phone now; your
    personal data is erased after `dueAt`, unless you log in again before then. 409
    `ACTIVE_JOBS` while an accepted or ongoing job is yours: WellWish moves it first."""
    deletion = services.request_deletion(user_id=get_principal(request).subject_id)
    return PartnerDeletionOut(
        due_at=deletion.due_at, done=deletion.status == PartnerDeletion.Status.DONE
    )
