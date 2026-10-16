"""All writes for patients: profile, the SELF member, family members (§6.18) and account
deletion (§12, PHASES 4.5)."""

import datetime as dt
import logging
from dataclasses import dataclass
from datetime import timedelta
from functools import partial

from django.db import transaction
from django.utils import timezone

from apps.accounts.models import User
from apps.app_config.selectors import get_setting
from apps.audit.services import record
from apps.files import services as files
from apps.patients.models import AccountDeletion, Member, PatientProfile
from apps.staff.models import StaffUser
from common.dates import today_ist
from common.errors import ApiError, Conflict, NotFound
from common.ids import uid
from common.phone import InvalidPhone, normalize_indian_mobile

logger = logging.getLogger(__name__)

# The app's language code → the language word partners pick (so the admin can match them).
LANGUAGE_WORDS = {"en": "English", "hi": "Hindi", "or": "Odia"}


class InvalidProfile(ApiError):
    status = 422
    code = "INVALID_PROFILE"
    message = "Please check your details."


class InvalidMember(ApiError):
    status = 422
    code = "INVALID_MEMBER"
    message = "Please check the details."


def ensure_profile(user: User) -> PatientProfile:
    """Called on every patient login. Creates the profile and the SELF member the first time,
    and cancels a pending account deletion (logging in again means "keep my account")."""
    profile, _ = PatientProfile.objects.get_or_create(user=user)
    Member.objects.get_or_create(owner=user, relation=Member.Relation.SELF)
    AccountDeletion.objects.filter(user=user, status=AccountDeletion.Status.PENDING).update(
        status=AccountDeletion.Status.CANCELLED,
        cancelled_at=timezone.now(),
        updated_at=timezone.now(),
    )
    return profile


def _check_name_and_dob(full_name: str, dob: dt.date, error: type[ApiError]) -> str:
    full_name = " ".join(full_name.split())
    today = today_ist()
    if len(full_name) < 2:
        raise error(code="INVALID_NAME", message="Please enter the full name.")
    if dob > today or dob.year < today.year - 120:
        raise error(code="INVALID_DOB", message="Please enter a valid date of birth.")
    return full_name


@transaction.atomic
def update_profile(
    *,
    user: User,
    full_name: str,
    dob: dt.date,
    gender: str,
    language: str,
    by_admin: bool = False,
) -> PatientProfile:
    """Profile setup (P04) and later edits. The SELF member always mirrors the profile.
    `by_admin`: an admin's edit on the patient's request, which must not cancel a pending
    "delete my account" (only the patient logging in again does)."""
    full_name = _check_name_and_dob(full_name, dob, InvalidProfile)
    profile = (
        PatientProfile.objects.select_for_update().get(user=user)
        if by_admin
        else ensure_profile(user)
    )
    profile.full_name = full_name
    profile.dob = dob
    profile.gender = gender
    profile.save(update_fields=["full_name", "dob", "gender", "updated_at"])
    Member.objects.filter(owner=user, relation=Member.Relation.SELF).update(
        full_name=full_name,
        dob=dob,
        gender=gender,
        language=LANGUAGE_WORDS.get(language, ""),
        updated_at=timezone.now(),
    )

    from apps.accounts.services import set_language

    set_language(user=user, language=language)
    return profile


# --- Admin actions on an account (§9.1, PHASES 9.10) ---


def _admin_profile(user_id: str) -> PatientProfile:
    profile = (
        PatientProfile.objects.select_for_update()
        .select_related("user")
        .filter(user_id=uid(user_id))
    ).first()
    if profile is None:
        raise NotFound()
    return profile


@transaction.atomic
def block(*, actor: StaffUser, user_id: str, reason: str, ip: str | None) -> PatientProfile:
    """Abuse: logged out of the patient app on every phone at once, and its login refused until
    unblocked. The partner app (someone who is also a partner) is not touched; bookings stay
    as they are (the admin cancels any that must go). Logged."""
    from apps.accounts.models import App, Session
    from apps.accounts.services import revoke_user_sessions

    profile = _admin_profile(user_id)
    if profile.blocked_at is None:
        profile.blocked_at, profile.blocked_reason = timezone.now(), reason
        profile.save(update_fields=["blocked_at", "blocked_reason", "updated_at"])
        record(actor, "patient.blocked", profile.user, reason=reason, ip=ip)
    revoke_user_sessions(
        user_id=str(profile.user_id), reason=Session.RevokeReason.ACCOUNT_BLOCKED, app=App.PATIENT
    )
    return profile


@transaction.atomic
def unblock(*, actor: StaffUser, user_id: str, reason: str, ip: str | None) -> PatientProfile:
    profile = _admin_profile(user_id)
    if profile.blocked_at is not None:
        profile.blocked_at, profile.blocked_reason = None, ""
        profile.save(update_fields=["blocked_at", "blocked_reason", "updated_at"])
        record(actor, "patient.unblocked", profile.user, reason=reason, ip=ip)
    return profile


@transaction.atomic
def admin_update_profile(
    *,
    actor: StaffUser,
    user_id: str,
    full_name: str,
    dob: dt.date,
    gender: str,
    language: str,
    reason: str,
    ip: str | None,
) -> PatientProfile:
    """Only on the patient's request, e.g. by phone (§9.1): the same details as the app's
    profile screen. Logged with the reason and which details changed. The phone number can't
    change here (it's the login, proved by OTP). A pending deletion stays pending."""
    profile = _admin_profile(user_id)
    user = profile.user
    fields = ("full_name", "dob", "gender")
    before = {f: str(getattr(profile, f)) for f in fields} | {"language": user.language}
    update_profile(
        user=user, full_name=full_name, dob=dob, gender=gender, language=language, by_admin=True
    )
    profile.refresh_from_db()
    user.refresh_from_db()
    after = {f: str(getattr(profile, f)) for f in fields} | {"language": user.language}
    changed = sorted(k for k in before if before[k] != after[k])
    if changed:
        # which details changed, not their values: audit rows can't be erased with the account
        record(actor, "patient.updated", user, after={"changed": changed}, reason=reason, ip=ip)
    return profile


def admin_request_deletion(
    *, actor: StaffUser, user_id: str, reason: str, ip: str | None
) -> AccountDeletion:
    """A patient who asks by phone to delete their account (§9.1, §12): the same as "Delete my
    account" in the app (refused while a paid booking isn't finished; logging in again within
    the waiting time keeps the account). Logged."""
    with transaction.atomic():
        _admin_profile(user_id)  # a patient account, or 404
        deletion = request_deletion(user_id=user_id, source="ADMIN")
        record(actor, "patient.deletion_requested", deletion.user, reason=reason, ip=ip)
    return deletion


# --- Family members ---


@dataclass(frozen=True)
class MemberInput:
    relation: str
    full_name: str
    dob: dt.date
    gender: str
    photo_key: str
    phone: str
    language: str
    conditions: str
    allergies: str
    mobility: str
    sensory_notes: str
    emergency_name: str
    emergency_phone: str
    consent: bool


def _phone_or_blank(raw: str, field: str) -> str:
    if not raw.strip():
        return ""
    try:
        return normalize_indian_mobile(raw)
    except InvalidPhone as exc:
        raise InvalidMember(
            code="INVALID_PHONE", message=str(exc), details={"field": field}
        ) from None


def _own_member(user_id: str, member_id: str, *, lock: bool = False) -> Member:
    """The caller's own active member, or 404 (other people's ids look like missing ones)."""
    query = Member.objects.filter(pk=uid(member_id), owner_id=uid(user_id), is_active=True)
    member = (query.select_for_update() if lock else query).first()
    if member is None:
        raise NotFound()
    return member


def _apply(member: Member, data: MemberInput, owner_id: str) -> str:
    """Fill the member from the form. Returns the photo key it replaced (to delete), if any."""
    member.full_name = _check_name_and_dob(data.full_name, data.dob, InvalidMember)
    member.dob = data.dob
    member.gender = data.gender
    member.phone = _phone_or_blank(data.phone, "phone")
    member.language = data.language
    member.conditions = data.conditions.strip()
    member.allergies = data.allergies.strip()
    member.mobility = data.mobility
    member.sensory_notes = data.sensory_notes.strip()
    member.emergency_name = " ".join(data.emergency_name.split())
    member.emergency_phone = _phone_or_blank(data.emergency_phone, "emergencyPhone")
    if bool(member.emergency_name) != bool(member.emergency_phone):
        raise InvalidMember(
            code="EMERGENCY_INCOMPLETE",
            message="Give both the emergency contact's name and phone, or leave both empty.",
        )
    old_photo = ""
    if data.photo_key != member.photo_key:
        if data.photo_key:
            files.confirm_upload(
                data.photo_key, purpose="member_photo", owner=owner_id, exclusive=True
            )
        old_photo = member.photo_key
        member.photo_key = data.photo_key
    if member.relation != Member.Relation.SELF:
        if not data.consent and member.consent_at is None:
            raise InvalidMember(
                code="CONSENT_REQUIRED",
                message="Please confirm you have their permission to save these details.",
            )
        if member.consent_at is None:
            member.consent_at = timezone.now()
    return old_photo


@transaction.atomic
def add_member(*, user_id: str, data: MemberInput) -> Member:
    if data.relation == Member.Relation.SELF:
        raise InvalidMember(code="INVALID_RELATION", message="Choose how they are related to you.")
    # Lock the owner's row so two quick taps can't both pass the limit.
    User.objects.select_for_update().filter(pk=uid(user_id)).first()
    limit = int(get_setting("max_members"))
    active = (
        Member.objects.filter(owner_id=uid(user_id), is_active=True)
        .exclude(relation=Member.Relation.SELF)
        .count()
    )
    if active >= limit:
        raise Conflict(
            code="TOO_MANY_MEMBERS",
            message=f"You can add up to {limit} family members.",
            details={"limit": limit},
        )
    member = Member(owner_id=uid(user_id), relation=data.relation)
    _apply(member, data, user_id)
    member.save()
    return member


@transaction.atomic
def update_member(*, user_id: str, member_id: str, data: MemberInput) -> Member:
    member = _own_member(user_id, member_id, lock=True)
    is_self = member.relation == Member.Relation.SELF
    if is_self != (data.relation == Member.Relation.SELF):
        raise InvalidMember(code="INVALID_RELATION", message="This relation can't be changed.")
    member.relation = data.relation
    old_photo = _apply(member, data, user_id)
    member.save()
    if is_self:
        # The account owner's name, date of birth and gender live in the profile too.
        PatientProfile.objects.filter(user_id=uid(user_id)).update(
            full_name=member.full_name,
            dob=member.dob,
            gender=member.gender,
            updated_at=timezone.now(),
        )
    if old_photo:
        transaction.on_commit(lambda: files.delete_file(old_photo))
    return member


@transaction.atomic
def remove_member(*, user_id: str, member_id: str, delete_documents: bool = False) -> None:
    """Hidden from the app; past bookings keep it. Their documents stay unless the owner asks
    (`delete_documents`, §6.18); kept ones no longer count towards the 200 MB, since the
    patient can't see them any more. You can't remove yourself (that's "delete account")."""
    from apps.bookings import services as bookings

    # The account first, as "Book" does: a booking can't be made for them meanwhile.
    User.objects.select_for_update().get(pk=uid(user_id))
    member = _own_member(user_id, member_id, lock=True)
    if member.relation == Member.Relation.SELF:
        raise InvalidMember(code="CANT_REMOVE_SELF", message="You can't remove yourself.")
    if bookings.has_active_bookings(user_id=user_id, member_id=str(member.pk)):
        raise Conflict(
            code="MEMBER_HAS_BOOKINGS",
            message="This person has a booking that isn't finished. Cancel it first.",
        )
    bookings.expire_unpaid_of(user_id=user_id, member_id=str(member.pk), note="Member removed")
    member.is_active = False
    member.save(update_fields=["is_active", "updated_at"])
    if delete_documents:
        from apps.documents.services import delete_member_documents

        delete_member_documents(user_id=user_id, member_id=str(member.pk))


def create_member_photo_upload(*, user_id: str, mime: str, size_bytes: int) -> files.UploadTicket:
    return files.create_upload(
        purpose="member_photo", mime=mime, size_bytes=size_bytes, owner=str(user_id)
    )


# --- Account deletion (§12: within 30 days, payment records kept) ---


@transaction.atomic
def request_deletion(*, user_id: str, source: str = "APP") -> AccountDeletion:
    """Logs the patient out everywhere at once; the data goes after the grace period.
    `source`: APP, WEB (the account deletion page, §6.20) or ADMIN."""
    from apps.accounts.models import App
    from apps.accounts.services import revoke_user_sessions
    from apps.bookings import services as bookings

    user = User.objects.select_for_update().get(pk=uid(user_id))
    if bookings.has_active_bookings(user_id=str(user.pk)):
        raise Conflict(
            code="ACTIVE_BOOKINGS",
            message="You have a booking that isn't finished. Cancel it or wait until it's done.",
        )
    # Unpaid bookings would otherwise wait until the erase and could still be paid.
    bookings.expire_unpaid_of(user_id=str(user.pk), note="Account deletion requested")
    pending = AccountDeletion.objects.filter(
        user=user, status=AccountDeletion.Status.PENDING
    ).first()
    if pending is None:
        pending = AccountDeletion.objects.create(
            user=user,
            due_at=timezone.now() + timedelta(days=int(get_setting("account_deletion_days"))),
            phone_last4=user.phone[-4:],
            source=source,
        )
    revoke_user_sessions(user_id=str(user.pk), reason="ACCOUNT_DELETED", app=App.PATIENT)
    return pending


def _erase_patient(deletion: AccountDeletion) -> bool:
    """Remove the patient's personal data. Each app clears its own tables. Not while a paid
    booking is still open (e.g. paid late): that one must finish or be cancelled first; the daily
    task tries again. Returns whether the account was erased."""
    from apps.accounts import services as accounts
    from apps.accounts.models import App
    from apps.addresses import services as addresses
    from apps.bookings import services as bookings
    from apps.documents import services as documents
    from apps.notifications import services as notifications
    from apps.partners.selectors import partner_status_of
    from apps.reviews import services as reviews
    from apps.safety import services as safety
    from apps.tracking import services as tracking

    user = User.objects.select_for_update().get(pk=deletion.user_id)
    user_id = str(user.pk)
    if bookings.has_active_bookings(user_id=user_id):
        logger.warning("Account deletion %s waits: a paid booking is not finished", deletion.pk)
        return False
    bookings.erase_for_owner(user_id=user_id)  # kept, without the personal details
    documents.erase_for_owner(user_id=user_id)
    addresses.erase_for_owner(user_id=user_id)
    tracking.erase_for_owner(user_id=user_id)
    safety.erase_for_owner(user_id=user_id)
    reviews.erase_for_owner(user_id=user_id)
    notifications.erase_inbox(user_id=user_id, app=App.PATIENT)
    photos = [
        key for key in Member.objects.filter(owner=user).values_list("photo_key", flat=True) if key
    ]
    Member.objects.filter(owner=user).delete()
    PatientProfile.objects.filter(user=user).delete()
    # a partner account still in use keeps the user row (§6.20: a DELETED one doesn't)
    kept_partner = partner_status_of(user_id) not in (None, "DELETED")
    accounts.erase_patient_account(user_id=user_id, keep_user=kept_partner)
    deletion.status = AccountDeletion.Status.DONE
    deletion.done_at = timezone.now()
    deletion.kept_partner = kept_partner
    deletion.save(update_fields=["status", "done_at", "kept_partner", "updated_at"])
    for key in photos:
        transaction.on_commit(partial(files.delete_file, key))
    return True


def process_due_deletions(*, now: dt.datetime | None = None) -> int:
    """Daily task: erase every account whose grace period is over. One transaction each, so
    one failure doesn't stop the others."""
    done = 0
    due = AccountDeletion.objects.filter(
        status=AccountDeletion.Status.PENDING, due_at__lte=now or timezone.now()
    ).values_list("pk", flat=True)
    for deletion_id in list(due[:500]):
        try:
            with transaction.atomic():
                deletion = AccountDeletion.objects.select_for_update().get(pk=deletion_id)
                if deletion.status != AccountDeletion.Status.PENDING:
                    continue
                if _erase_patient(deletion):
                    done += 1
        except Exception:
            logger.exception("Account deletion %s failed; it is retried tomorrow", deletion_id)
    return done
