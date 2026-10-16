"""All writes for partners (ARCHITECTURE §6.3): registration steps, the status machine and the
admin actions on a partner. Document review lives in the kyc app, which calls `change_status`.

Status machine (§6.3 diagram, plus REGISTERING for "role chosen, details not finished"):

    REGISTERING ⇄ REGISTERED → SUBMITTED → UNDER_REVIEW → APPROVED ⇄ SUSPENDED
                                    ↑            ↓  ↘ REJECTED         ↘ DEACTIVATED
                          CHANGES_REQUESTED ←────┘

    Temporary partners (§6.19):  TEMPORARY ⇄ TEMP_ENDED → REGISTERING (registers for real)
    Account deletion (§6.20):    a pending deletion leaves the status alone (sanctions keep
                                 working; a login cancels it); the erase: any status but
                                 TEMPORARY → DELETED → REGISTERING (registers again)
"""

import contextlib
import logging
import re
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from decimal import Decimal
from functools import partial
from typing import Any

from django.core.cache import cache
from django.db import transaction
from django.utils import timezone

from apps.accounts import otp
from apps.accounts import selectors as accounts_selectors
from apps.accounts import services as accounts_services
from apps.accounts.models import App, Session
from apps.audit.services import record
from apps.files.services import confirm_upload, staff_owner
from apps.notifications import text
from apps.notifications.services import email_now
from apps.partners import email_codes
from apps.partners.models import (
    DeletionSource,
    PartnerDeletion,
    PartnerPhone,
    PartnerProfile,
    SelfieCheck,
    TemporaryIdCheck,
)
from apps.partners.models import PartnerStatus as S
from apps.staff.models import StaffUser
from common import events
from common.dates import today_ist
from common.errors import ApiError, Conflict, NotFound
from common.ids import uid
from common.mail import MailError
from common.phone import InvalidPhone, normalize_indian_mobile
from common.state_machine import StateMachine, transition

logger = logging.getLogger(__name__)

# §6.20: the erase after a partner's "delete my account" (never during a temporary job). While
# the deletion waits the status doesn't change, so a suspension, a document expiry or a
# rejection still applies, and a login that cancels it changes nothing either.
ERASABLE = tuple(status for status in S.values if status not in (S.TEMPORARY, S.DELETED))
_DELETION_MOVES: dict[tuple[str, str], str] = {
    **{(status, "erase"): S.DELETED for status in ERASABLE},
    (S.DELETED, "register"): S.REGISTERING,
}

PARTNER_MACHINE = StateMachine(
    "partner",
    {
        (S.REGISTERING, "details_done"): S.REGISTERED,
        (S.REGISTERED, "details_missing"): S.REGISTERING,
        (S.REGISTERED, "submit"): S.SUBMITTED,
        (S.CHANGES_REQUESTED, "submit"): S.SUBMITTED,
        (S.SUBMITTED, "claim"): S.UNDER_REVIEW,
        (S.UNDER_REVIEW, "approve"): S.APPROVED,
        (S.UNDER_REVIEW, "request_changes"): S.CHANGES_REQUESTED,
        (S.UNDER_REVIEW, "reject"): S.REJECTED,
        (S.APPROVED, "suspend"): S.SUSPENDED,
        (S.SUSPENDED, "reinstate"): S.APPROVED,
        (S.APPROVED, "deactivate"): S.DEACTIVATED,
        (S.SUSPENDED, "deactivate"): S.DEACTIVATED,
        # §6.19: a temporary partner for one booking (created as TEMPORARY)
        (S.TEMPORARY, "temp_end"): S.TEMP_ENDED,
        (S.TEMP_ENDED, "temp_assign"): S.TEMPORARY,
        (S.TEMP_ENDED, "register"): S.REGISTERING,
        **_DELETION_MOVES,
    },
)

# The partner may change their details only before submitting (and while fixing changes).
EDITABLE = {S.REGISTERING, S.REGISTERED, S.CHANGES_REQUESTED}
ALTERNATE_PENDING_KEY = "partner:alt-phone:{user_id}"
MIN_AGE = 18
SUSPENDED_BY_ADMIN = "ADMIN"
SUSPENDED_DOCUMENT_EXPIRED = "DOCUMENT_EXPIRED"
SUSPENDED_MOCK_GPS = "MOCK_GPS"  # fake GPS flagged 3 times (§6.16)


class NotRegistered(ApiError):
    status = 409
    code = "NOT_REGISTERED"
    message = "Choose Companion or Nurse first."


class NotEditable(Conflict):
    code = "NOT_EDITABLE"
    message = "Your details can't be changed while your application is being reviewed."


class InvalidPartnerDetails(ApiError):
    status = 422
    code = "INVALID_DETAILS"
    message = "Please check your details."


def _partner(user_id: str, *, lock: bool = False) -> PartnerProfile:
    qs = PartnerProfile.objects.select_related("user")
    if lock:
        qs = qs.select_for_update()
    partner = qs.filter(pk=uid(user_id)).first()
    if partner is None:
        raise NotRegistered()
    return partner


def change_status(
    partner: PartnerProfile,
    event: str,
    *,
    actor: StaffUser | None = None,
    reason: str = "",
    ip: str | None = None,
    extra: dict[str, Any] | None = None,
) -> str:
    """The only way a partner's status changes. Every move is in the audit log."""
    old = partner.status
    new = transition(partner, event, machine=PARTNER_MACHINE, extra_updates=extra)
    record(
        actor,
        "partner.status_changed",
        partner,
        before={"status": old},
        after={"status": new},
        reason=reason,
        ip=ip,
    )
    return new


# --- Registration (partner app) ---


@transaction.atomic
def start_registration(*, user_id: str, role: str) -> PartnerProfile:
    """Step 1: choose Companion or Nurse. The role can change until the details are submitted."""
    # §6.20: the Partner Terms and the Privacy Policy come first (the app asks; an old app or a
    # direct call is refused here)
    if accounts_selectors.consents_needed(user_id, App.PARTNER):
        raise Conflict(
            code="CONSENT_NEEDED",
            message="Please accept the Partner Terms and the Privacy Policy first.",
        )
    partner = PartnerProfile.objects.select_for_update().filter(pk=uid(user_id)).first()
    if partner is not None and partner.status == S.DELETED:
        # §6.20: someone who deleted their partner account (and kept the number as a patient)
        # registers again from the start; their old jobs stay linked
        # a new application: nothing of the old account's approval carries over
        change_status(
            partner,
            "register",
            extra={"role": role, "full_name": "", "approved_at": None, "added_by_admin": False},
        )
        PartnerPhone.objects.create(
            partner=partner,
            kind=PartnerPhone.Kind.PRIMARY,
            phone=partner.user.phone,
            verified_at=partner.user.phone_verified_at or timezone.now(),
        )
        return partner
    if partner is not None and partner.status == S.TEMP_ENDED:
        # §6.19: an earlier temporary partner signs up for real; their temporary jobs and ID
        # checks stay linked, the full registration and verification follow
        change_status(partner, "register", extra={"role": role})
        PartnerPhone.objects.filter(
            partner=partner, kind=PartnerPhone.Kind.PRIMARY, verified_at__isnull=True
        ).update(verified_at=partner.user.phone_verified_at or timezone.now())
        return partner
    if partner is not None:
        if partner.status not in (S.REGISTERING, S.REGISTERED):
            raise Conflict(
                code="ROLE_LOCKED", message="Only WellWish can change your role now. Call support."
            )
        if partner.role != role:
            partner.role = role
            partner.save(update_fields=["role", "updated_at"])
        return partner
    user = accounts_selectors.get_user(user_id)
    partner = PartnerProfile.objects.create(user=user, role=role, status=S.REGISTERING)
    PartnerPhone.objects.create(
        partner=partner,
        kind=PartnerPhone.Kind.PRIMARY,
        phone=user.phone,
        verified_at=user.phone_verified_at or timezone.now(),
    )
    record(None, "partner.registration_started", partner, after={"role": role})
    return partner


def _can_verify(partner: PartnerProfile, *, verified: bool) -> None:
    """Phones and email can be set while registering. A partner added by an admin (already
    approved) verifies them once at the first login (§6.3)."""
    if partner.status in EDITABLE:
        return
    if partner.status == S.APPROVED and not verified:
        return
    raise NotEditable()


def request_alternate_otp(*, user_id: str, phone: str, session_id: str, ip: str) -> otp.OtpSent:
    partner = _partner(user_id)
    alternate = PartnerPhone.objects.filter(
        partner=partner, kind=PartnerPhone.Kind.ALTERNATE
    ).first()
    _can_verify(partner, verified=bool(alternate and alternate.verified_at))
    try:
        number = normalize_indian_mobile(phone)
    except InvalidPhone as exc:
        raise InvalidPartnerDetails(code="INVALID_PHONE", message=str(exc)) from None
    if number == partner.user.phone:
        raise InvalidPartnerDetails(
            code="SAME_AS_PRIMARY", message="Enter a different number from your login number."
        )
    sent = otp.send_code(
        phone=number,
        purpose="partner_alternate",
        device_id=accounts_selectors.session_device_id(session_id),
        ip=ip,
    )
    cache.set(
        ALTERNATE_PENDING_KEY.format(user_id=user_id), number, timeout=sent.expires_in_seconds
    )
    return sent


def verify_alternate_otp(*, user_id: str, code: str) -> PartnerProfile:
    partner = _partner(user_id)
    number = cache.get(ALTERNATE_PENDING_KEY.format(user_id=user_id))
    if not number:
        raise ApiError(
            status=400, code="OTP_EXPIRED", message="This code has expired. Ask for a new one."
        )
    alternate = PartnerPhone.objects.filter(
        partner=partner, kind=PartnerPhone.Kind.ALTERNATE
    ).first()
    _can_verify(partner, verified=bool(alternate and alternate.verified_at))
    # Outside a transaction: the lockout after too many wrong codes must not be rolled back.
    otp.verify_code(phone=number, purpose="partner_alternate", code=code)
    cache.delete(ALTERNATE_PENDING_KEY.format(user_id=user_id))
    with transaction.atomic():
        partner = _partner(user_id, lock=True)
        PartnerPhone.objects.update_or_create(
            partner=partner,
            kind=PartnerPhone.Kind.ALTERNATE,
            defaults={"phone": number, "verified_at": timezone.now()},
        )
        _sync_registered(partner)
    return partner


def _email_taken(email: str, user_id: str) -> bool:
    return (
        PartnerProfile.objects.filter(email__iexact=email, email_verified_at__isnull=False)
        .exclude(pk=uid(user_id))
        .exists()
    )


def request_email_code(*, user_id: str, email: str) -> int:
    """Send a 6-digit code to `email`. Returns seconds before another can be asked for."""
    partner = _partner(user_id)
    _can_verify(partner, verified=bool(partner.email_verified_at))
    email = email.strip().lower()
    if _email_taken(email, user_id):
        raise Conflict(code="EMAIL_TAKEN", message="Another partner already uses this email.")
    code, resend_after = email_codes.new_code(user_id=user_id, email=email)
    try:
        email_now(
            user_id=user_id,
            code="EMAIL_VERIFY_CODE",
            variables={"code": code, "name": partner.full_name or text.SOMEONE},
            email=email,
        )
    except MailError:
        raise ApiError(
            status=503,
            code="EMAIL_NOT_SENT",
            message="We couldn't send the email. Please try again.",
        ) from None
    finally:
        del code
    return resend_after


@transaction.atomic
def verify_email_code(*, user_id: str, code: str) -> PartnerProfile:
    partner = _partner(user_id, lock=True)
    _can_verify(partner, verified=bool(partner.email_verified_at))
    email = email_codes.check_code(user_id=user_id, code=code)
    if _email_taken(email, user_id):
        raise Conflict(code="EMAIL_TAKEN", message="Another partner already uses this email.")
    partner.email = email
    partner.email_verified_at = timezone.now()
    partner.save(update_fields=["email", "email_verified_at", "updated_at"])
    _sync_registered(partner)
    return partner


PROFILE_FIELDS = (
    "full_name",
    "dob",
    "gender",
    "photo_key",
    "address",
    "lat",
    "lng",
    "languages",
    "skills",
    "emergency_name",
    "emergency_phone",
)


def _check_profile(data: dict[str, Any], primary_phone: str) -> dict[str, Any]:
    dob: date = data["dob"]
    today = today_ist()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    if age < MIN_AGE:
        raise InvalidPartnerDetails(code="TOO_YOUNG", message="Partners must be 18 or older.")
    if age > 100:
        raise InvalidPartnerDetails(code="INVALID_DOB", message="Check the date of birth.")
    try:
        data["emergency_phone"] = normalize_indian_mobile(data["emergency_phone"])
    except InvalidPhone as exc:
        raise InvalidPartnerDetails(code="INVALID_EMERGENCY_PHONE", message=str(exc)) from None
    if data["emergency_phone"] == primary_phone:
        raise InvalidPartnerDetails(
            code="EMERGENCY_IS_YOU", message="The emergency contact must be someone else's number."
        )
    data["full_name"] = " ".join(data["full_name"].split())
    return data


@transaction.atomic
def update_profile(*, user_id: str, data: dict[str, Any]) -> PartnerProfile:
    """Step 5: name, DOB, gender, photo, home address + pin, languages, skills, emergency
    contact (§6.3)."""
    partner = _partner(user_id, lock=True)
    if partner.status not in EDITABLE:
        raise NotEditable()
    data = _check_profile(dict(data), partner.user.phone)
    if data["photo_key"] != partner.photo_key:
        confirm_upload(data["photo_key"], purpose="partner_photo", owner=str(user_id))
    for field in PROFILE_FIELDS:
        setattr(partner, field, data[field])
    partner.save()
    _sync_registered(partner)
    return partner


def details_done(partner: PartnerProfile) -> bool:
    alternate = PartnerPhone.objects.filter(
        partner=partner, kind=PartnerPhone.Kind.ALTERNATE, verified_at__isnull=False
    ).exists()
    return alternate and partner.email_verified_at is not None and partner.profile_complete


def _sync_registered(partner: PartnerProfile) -> None:
    """REGISTERING ⇄ REGISTERED as the phones, email and profile become (in)complete."""
    done = details_done(partner)
    if partner.status == S.REGISTERING and done:
        change_status(partner, "details_done")
    elif partner.status == S.REGISTERED and not done:
        change_status(partner, "details_missing")


class SelfieRequired(Conflict):
    code = "SELFIE_REQUIRED"
    message = "Take today's selfie first."


def set_availability(*, user_id: str, available: bool) -> PartnerProfile:
    """Approved partners only (the API gate checks): "Available today" (§8.3). It counts for
    today's India date only; switching it on needs today's selfie (§6.15)."""
    from apps.partners.selectors import selfie_today

    partner = _partner(user_id)
    if available and selfie_today(str(partner.pk)) is None:
        raise SelfieRequired()
    partner.available_today = available
    partner.available_on = today_ist() if available else None
    partner.save(update_fields=["available_today", "available_on", "updated_at"])
    return partner


def record_selfie(*, user_id: str, file_key: str) -> SelfieCheck:
    """The once-a-day selfie (§6.15), uploaded first with the `partner_selfie` upload URL."""
    partner = _partner(user_id)
    confirm_upload(file_key, purpose="partner_selfie", owner=str(partner.user_id), exclusive=True)
    if partner.status == S.TEMPORARY:
        # §6.19: a temporary partner has no profile photo; the day's selfie is their photo
        PartnerProfile.objects.filter(pk=partner.pk).update(
            photo_key=file_key, updated_at=timezone.now()
        )
    return SelfieCheck.objects.create(partner=partner, file_key=file_key, at=timezone.now())


# --- Admin actions (§9.1 Partners) ---


def _admin_partner(partner_id: str) -> PartnerProfile:
    partner = (
        PartnerProfile.objects.select_for_update()
        .select_related("user")
        .filter(pk=uid(partner_id))
        .first()
    )
    if partner is None:
        raise NotFound()
    return partner


def _sign_out(partner: PartnerProfile) -> None:
    """Logged out at once on every phone; the socket gets `session.revoked` (§6.3)."""
    accounts_services.revoke_user_sessions(
        user_id=str(partner.pk), reason=Session.RevokeReason.ACCOUNT_BLOCKED
    )


@transaction.atomic
def suspend(
    *,
    actor: StaffUser | None,
    partner_id: str,
    reason: str,
    ip: str | None,
    cause: str = SUSPENDED_BY_ADMIN,
) -> PartnerProfile:
    partner = _admin_partner(partner_id)
    change_status(
        partner,
        "suspend",
        actor=actor,
        reason=reason,
        ip=ip,
        extra={"suspended_reason": cause, "available_today": False},
    )
    _sign_out(partner)
    events.publish(
        "partner.suspended", {"partner_id": str(partner.pk), "reason": reason, "cause": cause}
    )
    return partner


FAKE_GPS_JOBS_TO_SUSPEND = 3  # §6.16


@transaction.atomic
def suspend_for_fake_gps(partner_id: str) -> bool:
    """§6.16: fake GPS flagged on 3 different jobs since the partner was last approved (or
    reinstated) → suspended for review. Never in the middle of a visit (the patient and the
    family would lose the partner's app): then it waits, and runs again when that job ends.
    Safe to call twice or at the same moment (the partner's row is locked)."""
    from apps.assignments import selectors as assignment_selectors
    from apps.audit import selectors as audit_selectors
    from apps.bookings.models import Booking, BookingStatus

    partner = PartnerProfile.objects.select_for_update().filter(pk=uid(partner_id)).first()
    if partner is None or partner.status != S.APPROVED:
        return False
    if Booking.objects.filter(partner=partner, status=BookingStatus.IN_PROGRESS).exists():
        return False
    since = (
        audit_selectors.last_status_change(
            PartnerProfile._meta.label_lower, str(partner.pk), S.APPROVED
        )
        or partner.approved_at
    )
    jobs = assignment_selectors.partner_flagged_jobs(str(partner.pk), "MOCK_GPS", since=since)
    if jobs < FAKE_GPS_JOBS_TO_SUSPEND:
        return False
    suspend(
        actor=None,
        partner_id=str(partner.pk),
        reason=f"Fake GPS location on {jobs} jobs",
        ip=None,
        cause=SUSPENDED_MOCK_GPS,
    )
    return True


@transaction.atomic
def reinstate(
    *, actor: StaffUser | None, partner_id: str, ip: str | None, reason: str = ""
) -> PartnerProfile:
    partner = _admin_partner(partner_id)
    change_status(
        partner, "reinstate", actor=actor, reason=reason, ip=ip, extra={"suspended_reason": ""}
    )
    events.publish("partner.reinstated", {"partner_id": str(partner.pk)})
    return partner


@transaction.atomic
def deactivate(*, actor: StaffUser, partner_id: str, reason: str, ip: str) -> PartnerProfile:
    partner = _admin_partner(partner_id)
    change_status(
        partner, "deactivate", actor=actor, reason=reason, ip=ip, extra={"available_today": False}
    )
    _sign_out(partner)
    events.publish("partner.deactivated", {"partner_id": str(partner.pk), "reason": reason})
    return partner


def force_logout(*, actor: StaffUser, partner_id: str, ip: str) -> None:
    partner = get_partner_for_admin(partner_id)
    _sign_out(partner)
    record(actor, "partner.force_logout", partner, ip=ip)


def get_partner_for_admin(partner_id: str) -> PartnerProfile:
    partner = PartnerProfile.objects.select_related("user").filter(pk=uid(partner_id)).first()
    if partner is None:
        raise NotFound()
    return partner


ADMIN_EDIT_FIELDS = (
    "role",
    "full_name",
    "dob",
    "gender",
    "address",
    "lat",
    "lng",
    "languages",
    "skills",
    "emergency_name",
    "emergency_phone",
)


def _jsonable(value: Any) -> Any:
    """For audit before/after: dates as ISO text, decimals as text."""
    if isinstance(value, date):
        return value.isoformat()
    if value is None or isinstance(value, str | int | bool | list):
        return value
    return str(value)


@transaction.atomic
def update_by_admin(
    *, actor: StaffUser, partner_id: str, data: dict[str, Any], ip: str
) -> PartnerProfile:
    """Profile, skills, address and role (§9.1). Phones and email are changed by the partner
    (they need re-verification)."""
    partner = _admin_partner(partner_id)
    if partner.status == S.DELETED or pending_deletion(partner_id):  # §6.20: nothing to put back
        raise Conflict(
            code="PARTNER_DELETED",
            message="This partner asked to delete their account. Their details can't be edited.",
        )
    data = _check_profile(dict(data), partner.user.phone)
    before = {f: _jsonable(getattr(partner, f)) for f in ADMIN_EDIT_FIELDS}
    for field in ADMIN_EDIT_FIELDS:
        setattr(partner, field, data[field])
    partner.save()
    partner.refresh_from_db()
    after = {f: _jsonable(getattr(partner, f)) for f in ADMIN_EDIT_FIELDS}
    changed = [f for f in ADMIN_EDIT_FIELDS if before[f] != after[f]]
    if changed:
        record(
            actor,
            "partner.role_changed" if "role" in changed else "partner.updated",
            partner,
            before={f: before[f] for f in changed},
            after={f: after[f] for f in changed},
            ip=ip,
        )
    return partner


def create_approved(
    *, user_id: str, role: str, data: dict[str, Any], alternate_phone: str, email: str
) -> PartnerProfile:
    """For the kyc app's manual add (§6.3): created APPROVED, alternate phone and email are
    verified by the partner at the first login. Call inside a transaction."""
    if PartnerProfile.objects.filter(pk=uid(user_id)).exists():
        raise Conflict(code="ALREADY_PARTNER", message="This number already belongs to a partner.")
    user = accounts_selectors.get_user(user_id)
    data = _check_profile(dict(data), user.phone)
    if alternate_phone == user.phone:
        raise InvalidPartnerDetails(
            code="SAME_AS_PRIMARY",
            message="The alternate number must differ from the login number.",
        )
    email = email.strip().lower()
    if email and _email_taken(email, user_id):
        raise Conflict(code="EMAIL_TAKEN", message="Another partner already uses this email.")
    now = timezone.now()
    partner = PartnerProfile.objects.create(
        user=user,
        role=role,
        status=S.APPROVED,
        email=email,
        added_by_admin=True,
        approved_at=now,
        **{f: data[f] for f in PROFILE_FIELDS},
    )
    PartnerPhone.objects.create(
        partner=partner,
        kind=PartnerPhone.Kind.PRIMARY,
        phone=user.phone,
        verified_at=user.phone_verified_at,
    )
    PartnerPhone.objects.create(
        partner=partner, kind=PartnerPhone.Kind.ALTERNATE, phone=alternate_phone
    )
    return partner


def lock_for_rating(partner_id: str) -> None:
    """Inside the caller's transaction: two reviews saved at once line up here, so the second
    average sees the first review."""
    PartnerProfile.objects.select_for_update().filter(pk=uid(partner_id)).first()


def set_rating(partner_id: str, avg: Decimal | None, count: int) -> None:
    """The reviews app's average of visible reviews (§6.13)."""
    PartnerProfile.objects.filter(pk=uid(partner_id)).update(rating_avg=avg, rating_count=count)


# --- Temporary partners (§6.19, v2.17) ---

ID_LAST4 = re.compile(r"^[0-9A-Z]{4}$")


class PhoneIsPartner(Conflict):
    code = "PHONE_IS_PARTNER"
    message = "This number belongs to a WellWish partner or applicant. Use Assign instead."


class TempPartnerBusy(Conflict):
    code = "TEMP_PARTNER_BUSY"
    message = "This person is already a temporary partner on another booking."


class TempPartnerIsFamily(Conflict):
    code = "TEMP_PARTNER_IS_FAMILY"
    message = "This is the number of the family who booked. Use someone else's number."


@dataclass(frozen=True)
class TemporaryDetails:
    """What the admin types after phoning the person and checking their ID (§6.19)."""

    phone: str
    full_name: str
    gender: str
    id_type: str
    id_last4: str
    id_photo_key: str
    nursing_reg_no: str
    reason: str


def make_temporary(*, booking: Any, details: TemporaryDetails, staff: StaffUser) -> PartnerProfile:
    """The person for a temporary assign (§6.19), inside the caller's transaction (the booking
    is locked): a new number or a patient's number gets a TEMPORARY profile; one whose earlier
    temporary job ended is reused. Refused: the booking's own family, any partner or applicant
    (also as an alternate phone), and someone busy on another temporary job."""
    try:
        number = normalize_indian_mobile(details.phone)
    except InvalidPhone as exc:
        raise InvalidPartnerDetails(code="INVALID_PHONE", message=str(exc)) from None
    family = {booking.booked_by.phone}
    if booking.member_snapshot.get("phone"):
        with contextlib.suppress(InvalidPhone):
            family.add(normalize_indian_mobile(str(booking.member_snapshot["phone"])))
    if number in family:
        raise TempPartnerIsFamily()
    role = str(booking.price_snapshot["partner_type"])
    last4 = details.id_last4.strip().upper()
    if not ID_LAST4.match(last4):
        raise InvalidPartnerDetails(code="INVALID_ID_LAST4", message="Enter the last 4 characters.")
    if role == "NURSE" and not details.nursing_reg_no.strip():
        raise InvalidPartnerDetails(
            code="NURSING_REG_REQUIRED", message="Enter the nursing registration number."
        )
    elsewhere = (
        PartnerPhone.objects.filter(phone=number)
        .exclude(partner__status__in=(S.TEMPORARY, S.TEMP_ENDED))
        .select_related("partner")
        .first()
    )
    if elsewhere is not None:
        raise PhoneIsPartner(details={"status": elsewhere.partner.status})

    # the user row stays locked until the assign commits: two admins typing the same new
    # number at once are served one after the other (the second finds them busy)
    user = accounts_services.lock_or_create_user(number)
    partner = PartnerProfile.objects.select_for_update().filter(pk=user.pk).first()
    profile = {
        "role": role,
        "full_name": details.full_name.strip(),
        "gender": details.gender,
        "available_today": False,
    }
    if partner is not None and partner.status == S.TEMPORARY:
        # their earlier job is over (e.g. Completed less than an hour ago): end it now and
        # reuse them; a job still running keeps them busy
        current = (
            TemporaryIdCheck.objects.select_related("booking")
            .filter(partner=partner, ended_at__isnull=True)
            .first()
        )
        over = _temporary_job_over(current, now=timezone.now(), wait=timedelta(0))
        if current is None or over is None:
            raise TempPartnerBusy()
        end_temporary(
            partner_id=str(partner.pk), booking_id=str(current.booking_id), reason=over, actor=staff
        )
        partner.refresh_from_db()
    if partner is None:
        partner = PartnerProfile.objects.create(user=user, status=S.TEMPORARY, **profile)
        PartnerPhone.objects.create(partner=partner, kind=PartnerPhone.Kind.PRIMARY, phone=number)
        record(staff, "partner.temp_created", partner, after={"role": role})
    elif partner.status != S.TEMP_ENDED:
        raise PhoneIsPartner(details={"status": partner.status})
    else:
        # the photo the family sees is a selfie of today, never an old one (§6.19): today's
        # counts for "On the way", so a person reused the same day keeps it as the photo
        from apps.partners.selectors import selfie_today

        today = selfie_today(str(partner.pk))
        photo = today.file_key if today else ""
        change_status(partner, "temp_assign", actor=staff, extra={**profile, "photo_key": photo})

    confirm_upload(
        details.id_photo_key,
        purpose="temp_partner_id",
        owner=staff_owner(str(staff.pk)),
        exclusive=True,
    )
    TemporaryIdCheck.objects.create(
        partner=partner,
        booking=booking,
        id_type=details.id_type,
        id_last4=last4,
        id_photo_key=details.id_photo_key,
        nursing_reg_no=details.nursing_reg_no.strip()[:40],
        reason=details.reason.strip()[:300],
        checked_by=staff,
        checked_at=timezone.now(),
    )
    return partner


TEMPORARY_ACCESS_AFTER_JOB = timedelta(hours=1)


def end_temporary(
    *, partner_id: str, booking_id: str, reason: str, actor: StaffUser | None = None
) -> bool:
    """§6.19: a temporary partner's access to `booking_id` ends: at once on cancel, unassign,
    reassign or a time change; 1 hour after Completed (the sweep); or when an admin ends it.
    Status TEMP_ENDED, their partner-app sessions end and the socket closes (a patient account
    on the same number keeps working). The ID check stays on record. False if they weren't
    TEMPORARY on that booking (safe to call twice; a late call for an old booking never ends
    the access to a newer one)."""
    with transaction.atomic():
        partner = PartnerProfile.objects.select_for_update().filter(pk=uid(partner_id)).first()
        if partner is None or partner.status != S.TEMPORARY:
            return False
        now = timezone.now()
        closed = TemporaryIdCheck.objects.filter(
            partner=partner, booking_id=uid(booking_id), ended_at__isnull=True
        ).update(ended_at=now, end_reason=reason, updated_at=now)
        if not closed:
            return False
        change_status(
            partner, "temp_end", actor=actor, reason=reason, extra={"available_today": False}
        )
        accounts_services.revoke_user_sessions(
            user_id=str(partner.pk), reason=Session.RevokeReason.JOB_OVER, app="partner"
        )
        events.publish(
            "partner.temp_ended",
            {"partner_id": str(partner.pk), "booking_id": str(booking_id), "reason": reason},
        )
    return True


def _temporary_job_over(
    check: TemporaryIdCheck | None, *, now: datetime, wait: timedelta
) -> str | None:
    """Why this temporary job is over (an EndReason), or None while it still runs. Completed /
    patient-not-available count `wait` after they happened (the sweep's hour; none when an admin
    reuses the person)."""
    if check is None:
        return None
    booking = check.booking
    if booking.partner_id != check.partner_id:
        return str(TemporaryIdCheck.EndReason.UNASSIGNED)
    if booking.status == "CANCELLED":
        return str(TemporaryIdCheck.EndReason.CANCELLED)
    if booking.status in ("COMPLETED", "PATIENT_NO_SHOW"):
        finished = (
            booking.events.filter(to_status=booking.status)
            .order_by("-server_ts")
            .values_list("server_ts", flat=True)
            .first()
        )
        if finished is not None and now - finished >= wait:
            return str(TemporaryIdCheck.EndReason.COMPLETED)
    return None


def end_temporary_sweep(*, now: datetime | None = None) -> int:
    """Every 5 minutes: temporary partners whose job is over (1 hour after Completed or
    patient-not-available), and, as a safety net, those whose booking was cancelled or no
    longer has them (the hooks normally end those at once)."""
    now = now or timezone.now()
    ended = 0
    open_checks = TemporaryIdCheck.objects.filter(
        ended_at__isnull=True, partner__status=S.TEMPORARY
    ).select_related("booking")
    for check in open_checks:
        try:
            reason = _temporary_job_over(check, now=now, wait=TEMPORARY_ACCESS_AFTER_JOB)
            if reason is not None:
                ended += end_temporary(
                    partner_id=str(check.partner_id),
                    booking_id=str(check.booking_id),
                    reason=reason,
                )
        except Exception:  # one bad row must not stop the others; the next run tries again
            logger.exception("Ending temporary access failed for check %s", check.pk)
    return ended


# --- Account deletion (§6.20) ---

ERASED_NAME = "Former partner"


class ActiveJobs(Conflict):
    code = "ACTIVE_JOBS"
    message = "You have an accepted or ongoing job. Ask WellWish to move it, then try again."


def _deletion_days() -> int:
    from apps.app_config.selectors import get_setting

    return int(get_setting("account_deletion_days"))


@transaction.atomic
def request_deletion(*, user_id: str, source: str = DeletionSource.APP) -> PartnerDeletion:
    """ "Delete my account" (Partner app or the website): logged out at once; the personal data
    goes after `account_deletion_days` unless they log in again. Refused while an accepted or
    ongoing job is theirs. The status doesn't change meanwhile (a suspension or an expiry still
    applies); they get no offers and aren't reviewed. Someone who never chose a role has
    nothing to wait for."""
    from apps.bookings.services import partner_has_open_jobs

    accounts_services.lock_user(user_id)  # the order a login takes: user, then the deletion
    partner = (
        PartnerProfile.objects.select_for_update()
        .select_related("user")
        .filter(pk=uid(user_id))
        .first()
    )
    user = partner.user if partner else accounts_selectors.get_user(user_id)
    pending = PartnerDeletion.objects.filter(
        user=user, status=PartnerDeletion.Status.PENDING
    ).first()
    if pending is not None:  # asked twice (the app, then the website)
        _sign_out_deleted(str(user.pk))
        return pending
    now = timezone.now()
    if partner is None or partner.status == S.DELETED:
        deletion = PartnerDeletion.objects.create(
            user=user,
            status=PartnerDeletion.Status.DONE,
            due_at=now,
            done_at=now,
            phone_last4=user.phone[-4:],
            source=source,
        )
        deletion.kept_patient = _erase_login(str(user.pk))
        deletion.save(update_fields=["kept_patient", "updated_at"])
        return deletion
    if partner.status == S.TEMPORARY or partner_has_open_jobs(str(partner.pk)):
        raise ActiveJobs()
    deletion = PartnerDeletion.objects.create(
        user=user,
        due_at=now + timedelta(days=_deletion_days()),
        phone_last4=user.phone[-4:],
        source=source,
    )
    if partner.available_today:
        partner.available_today = False
        partner.save(update_fields=["available_today", "updated_at"])
    record(
        None,
        "partner.deletion_requested",
        partner,
        after={"dueAt": deletion.due_at.isoformat(), "source": source},
    )
    _sign_out_deleted(str(user.pk))
    events.publish(
        "partner.deletion_requested",
        {"partner_id": str(partner.pk), "due_at": deletion.due_at.isoformat()},
    )
    return deletion


def _sign_out_deleted(user_id: str) -> None:
    accounts_services.revoke_user_sessions(
        user_id=user_id, reason=Session.RevokeReason.ACCOUNT_DELETED, app=App.PARTNER
    )


def cancel_deletion_on_login(user_id: str) -> None:
    """A Partner app login before the date keeps the account. The status never changed, so
    nothing else changes back (a suspension, an expiry or the fake-GPS count all stay)."""
    deletion = (
        PartnerDeletion.objects.select_for_update()
        .filter(user_id=uid(user_id), status=PartnerDeletion.Status.PENDING)
        .first()
    )
    if deletion is None:
        return
    deletion.status = PartnerDeletion.Status.CANCELLED
    deletion.cancelled_at = timezone.now()
    deletion.save(update_fields=["status", "cancelled_at", "updated_at"])
    partner = PartnerProfile.objects.filter(pk=uid(user_id)).first()
    if partner is not None:
        record(None, "partner.deletion_cancelled", partner, reason="Logged in again")


def pending_deletion(user_id: str) -> PartnerDeletion | None:
    return PartnerDeletion.objects.filter(
        user_id=uid(user_id), status=PartnerDeletion.Status.PENDING
    ).first()


def _erase_login(user_id: str) -> bool:
    """The Partner app's inbox, phones and sessions go. The user row stays only if they are
    also a patient (then the number still logs in there). Returns whether it stayed."""
    from apps.notifications.services import erase_inbox
    from apps.patients.selectors import has_profile

    erase_inbox(user_id=user_id, app=App.PARTNER)
    keep = has_profile(user_id)
    accounts_services.erase_app_account(user_id=user_id, app=App.PARTNER, keep_user=keep)
    return keep


def _erase_partner(deletion: PartnerDeletion) -> bool:
    """Remove the partner's personal data (§6.20). Bookings, fees, reviews and the audit log
    stay, with the name "Former partner". Returns whether the account was erased."""
    from apps.assignments.services import forget_partner_name
    from apps.bookings.services import partner_has_open_jobs
    from apps.files.services import delete_file
    from apps.kyc.services import erase_for_partner

    user_id = str(deletion.user_id)
    partner = PartnerProfile.objects.select_for_update().filter(pk=uid(user_id)).first()
    files: list[str] = []
    if partner is not None and partner.status != S.DELETED:
        if partner.status == S.TEMPORARY:  # made temporary meanwhile: waits for the job's end
            logger.warning("Partner deletion %s waits: a temporary job", deletion.pk)
            return False
        if partner_has_open_jobs(user_id):
            logger.warning("Partner deletion %s waits: a job is still theirs", deletion.pk)
            return False
        files.append(partner.photo_key)
        selfies = SelfieCheck.objects.filter(partner=partner)
        files += list(selfies.values_list("file_key", flat=True))
        selfies.delete()
        checks = TemporaryIdCheck.objects.filter(partner=partner)
        files += list(checks.values_list("id_photo_key", flat=True))
        checks.update(id_photo_key="", id_last4="", nursing_reg_no="", updated_at=timezone.now())
        PartnerPhone.objects.filter(partner=partner).delete()
        files += erase_for_partner(partner_id=user_id)
        # what was written with their name (offer events, the admins' alerts) says the same
        forget_partner_name(partner_id=user_id, name=partner.full_name, replacement=ERASED_NAME)
        change_status(
            partner,
            "erase",
            reason="Account deletion: personal data erased",
            extra={
                "full_name": ERASED_NAME,
                "dob": None,
                "gender": "",
                "photo_key": "",
                "email": "",
                "email_verified_at": None,
                "address": "",
                "lat": None,
                "lng": None,
                "languages": [],
                "skills": [],
                "emergency_name": "",
                "emergency_phone": "",
                "available_today": False,
                "available_on": None,
                "suspended_reason": "",
            },
        )
    deletion.kept_patient = _erase_login(user_id)
    deletion.status = PartnerDeletion.Status.DONE
    deletion.done_at = timezone.now()
    deletion.save(update_fields=["kept_patient", "status", "done_at", "updated_at"])
    for key in files:
        if key:
            transaction.on_commit(partial(delete_file, key))
    return True


def process_due_deletions(*, now: datetime | None = None) -> int:
    """Daily task: erase every partner whose waiting time is over. One transaction each, so
    one failure doesn't stop the others."""
    done = 0
    due = PartnerDeletion.objects.filter(
        status=PartnerDeletion.Status.PENDING, due_at__lte=now or timezone.now()
    ).values_list("pk", "user_id")
    for deletion_id, user_id in list(due[:500]):
        try:
            with transaction.atomic():
                # the order a login takes (user, then the deletion): the two never deadlock
                accounts_services.lock_user(str(user_id))
                deletion = PartnerDeletion.objects.select_for_update().get(pk=deletion_id)
                if deletion.status != PartnerDeletion.Status.PENDING:
                    continue
                if _erase_partner(deletion):
                    done += 1
        except Exception:
            logger.exception("Partner deletion %s failed; it is retried tomorrow", deletion_id)
    return done
