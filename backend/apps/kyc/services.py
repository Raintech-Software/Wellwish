"""All writes for partner verification (ARCHITECTURE §6.3, §9.4).

- Partner: upload documents (masked numbers, expiry dates), submit.
- Admin: claim an application (30-minute lock), view a document (logged), approve or reject
  each document with a reason, then approve / request changes / reject the application.
- Admin: add a partner by hand (created APPROVED, documents ticked as checked).
- Daily: remind 30 days before a document expires; on expiry, suspend the partner.

The partner's status always moves through `apps.partners.services.change_status`.
"""

import re
from dataclasses import dataclass
from datetime import date, timedelta
from typing import Any

from django.db import transaction
from django.utils import timezone

from apps.accounts import services as accounts_services
from apps.audit.services import record
from apps.files.services import confirm_upload
from apps.kyc import selectors
from apps.kyc.models import NumberRule, PartnerApplication, PartnerDocument, RequiredDocument
from apps.partners import selectors as partner_selectors
from apps.partners import services as partner_services
from apps.partners.models import PartnerProfile
from apps.partners.models import PartnerStatus as S
from apps.staff.models import StaffUser
from common import events
from common.dates import today_ist
from common.errors import ApiError, Conflict, NotFound
from common.ids import uid
from common.phone import InvalidPhone, normalize_indian_mobile

CLAIM_MINUTES = 30
REMIND_DAYS_BEFORE = 30

# Statuses in which the partner may upload: while registering or fixing changes, and once
# approved (renewals) or suspended (replacing an expired document).
UPLOAD_ALLOWED = {S.REGISTERING, S.REGISTERED, S.CHANGES_REQUESTED, S.APPROVED, S.SUSPENDED}


class InvalidDocument(ApiError):
    status = 422
    code = "INVALID_DOCUMENT"
    message = "Please check the document details."


class NotReadyToSubmit(Conflict):
    code = "DOCUMENTS_MISSING"
    message = "Upload every required document first."


class ClaimedByOther(Conflict):
    code = "CLAIMED_BY_OTHER"
    message = "Another admin is reviewing this application."


class NotClaimed(Conflict):
    code = "NOT_CLAIMED"
    message = "Open the application to review it (your 30-minute lock may have ended)."


# --- Numbers ---

_AADHAAR = re.compile(r"^[2-9][0-9]{11}$")
_PAN = re.compile(r"^[A-Z]{5}[0-9]{4}[A-Z]$")


def mask_number(rule: str, raw: str) -> str:
    """Aadhaar and PAN are stored masked (last 4 only); licence numbers as typed (§12)."""
    if rule == NumberRule.NONE:
        return ""
    if rule == NumberRule.TEXT:
        # as printed, so the admin can match it against the certificate ("OD-02-2019-0012345")
        text = " ".join((raw or "").split()).upper()
        if not 3 <= len(text) <= 40:
            raise InvalidDocument(
                code="INVALID_NUMBER", message="Enter the number on the document."
            )
        return text
    value = re.sub(r"[\s-]", "", raw or "").upper()
    if rule == NumberRule.AADHAAR:
        if not _AADHAAR.match(value):
            raise InvalidDocument(
                code="INVALID_AADHAAR", message="Enter the 12-digit Aadhaar number."
            )
        return f"XXXX XXXX {value[-4:]}"
    if rule == NumberRule.PAN:
        if not _PAN.match(value):
            raise InvalidDocument(code="INVALID_PAN", message="Enter the 10-character PAN.")
        return f"XXXXXX{value[-4:]}"
    raise ValueError(f"unknown number rule {rule}")


# --- Partner: documents and submit ---


@dataclass(frozen=True)
class DocumentInput:
    doc_type: str
    file_key: str
    number: str = ""
    expires_on: date | None = None


def _rule(partner: PartnerProfile, doc_type: str) -> RequiredDocument:
    rule = RequiredDocument.objects.filter(
        role=partner.role, doc_type=doc_type, is_active=True
    ).first()
    if rule is None:
        raise InvalidDocument(
            code="UNKNOWN_DOCUMENT", message="This document isn't needed for your role."
        )
    return rule


def _check_fields(rule: RequiredDocument, data: DocumentInput) -> tuple[str, date | None]:
    number = mask_number(rule.number_rule, data.number)
    if rule.number_rule != NumberRule.NONE and not number:
        raise InvalidDocument(code="NUMBER_REQUIRED", message="Enter the number on the document.")
    expires = data.expires_on if rule.has_expiry else None
    if rule.has_expiry:
        if expires is None:
            raise InvalidDocument(code="EXPIRY_REQUIRED", message="Enter the date it's valid till.")
        if expires <= today_ist():
            raise InvalidDocument(
                code="ALREADY_EXPIRED", message="This document has already expired."
            )
    return number, expires


@transaction.atomic
def add_document(*, user_id: str, data: DocumentInput) -> PartnerDocument:
    partner = PartnerProfile.objects.select_for_update().filter(pk=uid(user_id)).first()
    if partner is None:
        raise partner_services.NotRegistered()
    if partner.status not in UPLOAD_ALLOWED:
        raise partner_services.NotEditable()
    rule = _rule(partner, data.doc_type)
    number, expires = _check_fields(rule, data)
    mime = confirm_upload(data.file_key, purpose="kyc_document", owner=str(user_id))
    current = PartnerDocument.objects.filter(
        partner=partner, doc_type=data.doc_type, is_current=True
    ).first()
    new = PartnerDocument(
        partner=partner,
        doc_type=data.doc_type,
        file_key=data.file_key,
        mime=mime,
        number_masked=number,
        expires_on=expires,
    )
    if (
        current is not None
        and current.status == PartnerDocument.Status.APPROVED
        and partner.status
        in (
            S.APPROVED,
            S.SUSPENDED,
        )
    ):
        # A renewal: the approved document stays current until the new one is approved.
        PartnerDocument.objects.filter(
            partner=partner,
            doc_type=data.doc_type,
            is_current=False,
            status=PartnerDocument.Status.PENDING,
        ).update(
            status=PartnerDocument.Status.REJECTED, reject_reason="Replaced by a newer upload."
        )
        new.is_current = False
    elif current is not None:
        current.is_current = False
        current.save(update_fields=["is_current", "updated_at"])
    new.save()
    return new


@transaction.atomic
def submit(*, user_id: str) -> PartnerApplication:
    """Step 7 (§6.3): every mandatory document uploaded and none rejected → SUBMITTED."""
    partner = (
        PartnerProfile.objects.select_for_update()
        .select_related("user")
        .filter(pk=uid(user_id))
        .first()
    )
    if partner is None:
        raise partner_services.NotRegistered()
    if partner.status not in (S.REGISTERED, S.CHANGES_REQUESTED):
        if partner.status == S.REGISTERING:
            raise Conflict(
                code="DETAILS_MISSING", message="Finish your phones, email and profile first."
            )
        raise partner_services.NotEditable()
    if partner.status == S.CHANGES_REQUESTED and not partner_services.details_done(partner):
        raise Conflict(
            code="DETAILS_MISSING", message="Finish your phones, email and profile first."
        )
    missing, rejected = [], []
    for state in selectors.document_checklist(str(partner.pk), partner.role):
        if state.current is None:
            if state.required.mandatory:
                missing.append(state.required.doc_type)
        elif state.current.status == PartnerDocument.Status.REJECTED:
            rejected.append(state.required.doc_type)
    if missing or rejected:
        raise NotReadyToSubmit(details={"missing": missing, "rejected": rejected})
    partner_services.change_status(partner, "submit")
    now = timezone.now()
    app, created = PartnerApplication.objects.select_for_update().get_or_create(
        partner=partner,
        defaults={"submitted_at": now, "first_submitted_at": now},
    )
    if not created:
        app.status = PartnerApplication.Status.SUBMITTED
        app.submitted_at = now
        app.claimed_by = None
        app.claimed_until = None
        app.save()
    events.publish(
        "partner.submitted", {"partner_id": str(partner.pk), "application_id": str(app.pk)}
    )
    return app


# --- Admin: review (§9.4) ---


def _lock_app(application_id: str) -> PartnerApplication:
    app = (
        PartnerApplication.objects.select_for_update()
        .select_related("partner__user")
        .filter(pk=application_id)
        .first()
    )
    if app is None:
        raise NotFound()
    return app


def _require_claim(app: PartnerApplication, actor: StaffUser) -> None:
    if (
        app.claimed_by_id != actor.pk
        or not app.claimed_until
        or app.claimed_until <= timezone.now()
    ):
        raise NotClaimed()


@transaction.atomic
def claim(*, actor: StaffUser, application_id: str, ip: str) -> PartnerApplication:
    """Open an application: it's locked to you for 30 minutes (§9.4). The first open moves
    the partner from SUBMITTED to UNDER_REVIEW."""
    app = _lock_app(application_id)
    now = timezone.now()
    if app.status not in (
        PartnerApplication.Status.SUBMITTED,
        PartnerApplication.Status.UNDER_REVIEW,
    ):
        raise Conflict(code="ALREADY_DECIDED", message="This application was already decided.")
    if selectors.claim_is_active(app, now) and app.claimed_by_id != actor.pk:
        raise ClaimedByOther(
            details={
                "claimedBy": app.claimed_by.name if app.claimed_by else "",
                "until": app.claimed_until.isoformat() if app.claimed_until else "",
            }
        )
    partner = PartnerProfile.objects.select_for_update().get(pk=app.partner_id)
    if partner_selectors.is_deleting(str(partner.pk)):  # §6.20
        raise Conflict(
            code="PARTNER_DELETING",
            message="This partner asked to delete their account. The application isn't reviewed.",
        )
    if partner.status == S.SUBMITTED:
        partner_services.change_status(partner, "claim", actor=actor, ip=ip)
        app.status = PartnerApplication.Status.UNDER_REVIEW
    app.claimed_by = actor
    app.claimed_until = now + timedelta(minutes=CLAIM_MINUTES)
    app.save()
    record(actor, "application.claimed", app, ip=ip)
    return app


@transaction.atomic
def release(*, actor: StaffUser, application_id: str, ip: str) -> PartnerApplication:
    app = _lock_app(application_id)
    if app.claimed_by_id == actor.pk:
        app.claimed_by = None
        app.claimed_until = None
        app.save(update_fields=["claimed_by", "claimed_until", "updated_at"])
        record(actor, "application.released", app, ip=ip)
    return app


def view_document(*, actor: StaffUser, document_id: str, ip: str) -> PartnerDocument:
    """Opening a document is always in the audit log (§12)."""
    doc = selectors.get_document(document_id)
    record(
        actor,
        "partner_document.viewed",
        doc,
        after={"partner": str(doc.partner_id), "doc_type": doc.doc_type},
        ip=ip,
    )
    return doc


@transaction.atomic
def review_document(
    *, actor: StaffUser, document_id: str, approve: bool, reason: str, ip: str
) -> PartnerDocument:
    doc = (
        PartnerDocument.objects.select_for_update()
        .select_related("partner")
        .filter(pk=document_id)
        .first()
    )
    if doc is None:
        raise NotFound()
    partner = PartnerProfile.objects.select_for_update().get(pk=doc.partner_id)
    if partner.status == S.UNDER_REVIEW:
        app = _lock_app(str(partner.application.pk))
        _require_claim(app, actor)
    elif partner.status not in (S.APPROVED, S.SUSPENDED):
        raise Conflict(
            code="NOT_IN_REVIEW", message="Open the application to review its documents."
        )
    if doc.status == PartnerDocument.Status.EXPIRED or (
        not doc.is_current and doc.status != PartnerDocument.Status.PENDING
    ):
        raise Conflict(code="OLD_DOCUMENT", message="This is an old upload. Review the newest one.")
    if not approve and len(reason.strip()) < 3:
        raise InvalidDocument(
            code="REASON_REQUIRED", message="Write why it's rejected (the partner sees it)."
        )
    before = doc.status
    doc.status = PartnerDocument.Status.APPROVED if approve else PartnerDocument.Status.REJECTED
    doc.reject_reason = "" if approve else reason.strip()
    doc.reviewed_by = actor
    doc.reviewed_at = timezone.now()
    if approve and not doc.is_current:
        # A renewal is approved: it replaces the current document.
        PartnerDocument.objects.filter(
            partner=partner, doc_type=doc.doc_type, is_current=True
        ).update(is_current=False, updated_at=timezone.now())
        doc.is_current = True
    doc.save()
    record(
        actor,
        "partner_document.approved" if approve else "partner_document.rejected",
        doc,
        before={"status": before},
        after={"status": doc.status, "doc_type": doc.doc_type},
        reason=doc.reject_reason,
        ip=ip,
    )
    if partner.status in (S.APPROVED, S.SUSPENDED) and not approve:
        events.publish(
            "document.rejected",
            {"partner_id": str(partner.pk), "doc_type": doc.doc_type, "reason": doc.reject_reason},
        )
    if (
        approve
        and partner.status == S.SUSPENDED
        and partner.suspended_reason == partner_services.SUSPENDED_DOCUMENT_EXPIRED
        and not missing_mandatory(partner)
    ):
        # Suspended only because a document expired: the new one is approved, so back to work.
        partner_services.reinstate(
            actor=actor, partner_id=str(partner.pk), ip=ip, reason="New document approved"
        )
    return doc


def missing_mandatory(partner: PartnerProfile) -> list[str]:
    """Mandatory document types without a current approved document."""
    return [
        s.required.doc_type
        for s in selectors.document_checklist(str(partner.pk), partner.role)
        if s.required.mandatory
        and (s.current is None or s.current.status != PartnerDocument.Status.APPROVED)
    ]


def _decide(app: PartnerApplication, actor: StaffUser, status: str, notes: str) -> None:
    app.status = status
    app.decided_by = actor
    app.decided_at = timezone.now()
    app.notes = notes
    app.claimed_by = None
    app.claimed_until = None
    app.save()


@transaction.atomic
def approve_application(*, actor: StaffUser, application_id: str, ip: str) -> PartnerApplication:
    app = _lock_app(application_id)
    _require_claim(app, actor)
    partner = (
        PartnerProfile.objects.select_for_update().select_related("user").get(pk=app.partner_id)
    )
    missing = missing_mandatory(partner)
    waiting = [
        d.doc_type
        for d in selectors.current_documents(str(partner.pk)).values()
        if d.status == PartnerDocument.Status.PENDING
    ]
    if missing or waiting:
        raise Conflict(
            code="DOCUMENTS_NOT_APPROVED",
            message="Approve every required document first (and decide the optional ones).",
            details={"missing": missing, "waiting": waiting},
        )
    partner_services.change_status(
        partner, "approve", actor=actor, ip=ip, extra={"approved_at": timezone.now()}
    )
    _decide(app, actor, PartnerApplication.Status.APPROVED, "")
    events.publish("partner.approved", {"partner_id": str(partner.pk)})
    return app


@transaction.atomic
def request_changes(
    *, actor: StaffUser, application_id: str, note: str, ip: str
) -> PartnerApplication:
    app = _lock_app(application_id)
    _require_claim(app, actor)
    partner = PartnerProfile.objects.select_for_update().get(pk=app.partner_id)
    rejected = [
        d.doc_type
        for d in selectors.current_documents(str(partner.pk)).values()
        if d.status == PartnerDocument.Status.REJECTED
    ]
    if not rejected and len(note.strip()) < 3:
        raise Conflict(
            code="NOTHING_TO_CHANGE",
            message="Reject at least one document with a reason, or write what must change.",
        )
    partner_services.change_status(partner, "request_changes", actor=actor, reason=note, ip=ip)
    _decide(app, actor, PartnerApplication.Status.CHANGES_REQUESTED, note.strip())
    events.publish(
        "partner.changes_requested", {"partner_id": str(partner.pk), "documents": rejected}
    )
    return app


@transaction.atomic
def reject_application(
    *, actor: StaffUser, application_id: str, reason: str, ip: str
) -> PartnerApplication:
    app = _lock_app(application_id)
    _require_claim(app, actor)
    if len(reason.strip()) < 3:
        raise InvalidDocument(
            code="REASON_REQUIRED", message="Write why the application is rejected."
        )
    partner = PartnerProfile.objects.select_for_update().get(pk=app.partner_id)
    partner_services.change_status(partner, "reject", actor=actor, reason=reason, ip=ip)
    _decide(app, actor, PartnerApplication.Status.REJECTED, reason.strip())
    events.publish("partner.rejected", {"partner_id": str(partner.pk), "reason": reason.strip()})
    return app


# --- Admin: add a partner by hand (§6.3, §9.4) ---


@transaction.atomic
def add_partner_by_admin(
    *,
    actor: StaffUser,
    phone: str,
    role: str,
    alternate_phone: str,
    email: str,
    profile: dict[str, Any],
    documents: list[DocumentInput],
    ip: str,
) -> PartnerProfile:
    """Created APPROVED with `added_by_admin`. The admin uploaded the documents and checked each
    one, so they are saved approved. The partner gets an SMS with the app link; the alternate
    phone and email are verified at their first login."""
    try:
        primary = normalize_indian_mobile(phone)
        alternate = normalize_indian_mobile(alternate_phone)
    except InvalidPhone as exc:
        raise partner_services.InvalidPartnerDetails(
            code="INVALID_PHONE", message=str(exc)
        ) from None
    owner = f"staff-{actor.pk}"
    rules = {r.doc_type: r for r in selectors.required_documents(role)}
    given = {d.doc_type for d in documents}
    missing = [t for t, r in rules.items() if r.mandatory and t not in given]
    if missing:
        raise NotReadyToSubmit(details={"missing": missing, "rejected": []})
    if len(given) != len(documents):
        raise InvalidDocument(code="DUPLICATE_DOCUMENT", message="Each document only once.")
    checked = []
    for doc in documents:
        rule = rules.get(doc.doc_type)
        if rule is None:
            raise InvalidDocument(
                code="UNKNOWN_DOCUMENT", message=f"{doc.doc_type} isn't needed for this role."
            )
        number, expires = _check_fields(rule, doc)
        mime = confirm_upload(doc.file_key, purpose="kyc_document", owner=owner)
        checked.append((doc, number, expires, mime))
    if profile.get("photo_key"):
        confirm_upload(profile["photo_key"], purpose="partner_photo", owner=owner)

    user, _ = accounts_services.get_or_create_user(primary)
    partner = partner_services.create_approved(
        user_id=str(user.pk), role=role, data=profile, alternate_phone=alternate, email=email
    )
    now = timezone.now()
    PartnerDocument.objects.bulk_create(
        [
            PartnerDocument(
                partner=partner,
                doc_type=doc.doc_type,
                file_key=doc.file_key,
                mime=mime,
                number_masked=number,
                expires_on=expires,
                status=PartnerDocument.Status.APPROVED,
                reviewed_by=actor,
                reviewed_at=now,
            )
            for doc, number, expires, mime in checked
        ]
    )
    record(
        actor,
        "partner.added",
        partner,
        after={"role": role, "documents": sorted(given)},
        ip=ip,
    )
    events.publish("partner.added", {"partner_id": str(partner.pk)})
    return partner


# --- Admin: the required-documents list (§9.1) ---

REQUIRED_FIELDS = (
    "label",
    "label_hi",
    "label_or",
    "help",
    "help_hi",
    "help_or",
    "mandatory",
    "condition",
    "condition_hi",
    "condition_or",
    "has_expiry",
    "number_rule",
    "camera_only",
    "sort",
    "is_active",
)


@transaction.atomic
def save_required_document(
    *, actor: StaffUser, data: dict[str, Any], ip: str, required_id: str | None = None
) -> RequiredDocument:
    if required_id:
        row = RequiredDocument.objects.select_for_update().filter(pk=required_id).first()
        if row is None:
            raise NotFound()
        before = {f: getattr(row, f) for f in REQUIRED_FIELDS}
    else:
        if RequiredDocument.objects.filter(role=data["role"], doc_type=data["doc_type"]).exists():
            raise Conflict(
                code="ALREADY_EXISTS", message="This document is already in the list for the role."
            )
        row, before = RequiredDocument(role=data["role"], doc_type=data["doc_type"]), {}
    for field in REQUIRED_FIELDS:
        setattr(row, field, data[field])
    row.save()
    after = {f: getattr(row, f) for f in REQUIRED_FIELDS}
    changed = [k for k in after if before.get(k) != after[k]]
    if changed:
        record(
            actor,
            "required_document.updated" if required_id else "required_document.created",
            row,
            before={k: before[k] for k in changed} if required_id else None,
            after={"role": row.role, "doc_type": row.doc_type, **{k: after[k] for k in changed}},
            ip=ip,
        )
    return row


@transaction.atomic
def delete_required_document(*, actor: StaffUser, required_id: str, ip: str) -> None:
    row = RequiredDocument.objects.select_for_update().filter(pk=required_id).first()
    if row is None:
        raise NotFound()
    if PartnerDocument.objects.filter(doc_type=row.doc_type, partner__role=row.role).exists():
        raise Conflict(
            code="IN_USE", message="Partners have uploaded this document. Turn it off instead."
        )
    record(
        actor,
        "required_document.deleted",
        ("kyc.requireddocument", str(row.pk)),
        before={"role": row.role, "doc_type": row.doc_type},
        ip=ip,
    )
    row.delete()


# --- Daily: document expiry (§6.3) ---


def check_expiry(*, today: date | None = None) -> dict[str, int]:
    """Remind 30 days before; on expiry mark the document EXPIRED and, if the role needs it,
    suspend the partner until a new one is approved."""
    today = today or today_ist()
    reminded = expired = suspended = 0
    soon = PartnerDocument.objects.filter(
        is_current=True,
        status=PartnerDocument.Status.APPROVED,
        expires_on__isnull=False,
        expires_on__gte=today,
        expires_on__lte=today + timedelta(days=REMIND_DAYS_BEFORE),
        expiry_reminded_at__isnull=True,
    )
    for doc in soon:
        PartnerDocument.objects.filter(pk=doc.pk).update(expiry_reminded_at=timezone.now())
        events.publish(
            "document.expiring",
            {
                "partner_id": str(doc.partner_id),
                "doc_type": doc.doc_type,
                "expires_on": doc.expires_on.isoformat() if doc.expires_on else "",
            },
        )
        reminded += 1
    for doc in PartnerDocument.objects.select_related("partner").filter(
        is_current=True, status=PartnerDocument.Status.APPROVED, expires_on__lt=today
    ):
        with transaction.atomic():
            PartnerDocument.objects.filter(pk=doc.pk).update(
                status=PartnerDocument.Status.EXPIRED, updated_at=timezone.now()
            )
            record(None, "partner_document.expired", doc, after={"doc_type": doc.doc_type})
            events.publish(
                "document.expired", {"partner_id": str(doc.partner_id), "doc_type": doc.doc_type}
            )
            expired += 1
            rule = RequiredDocument.objects.filter(
                role=doc.partner.role, doc_type=doc.doc_type
            ).first()
            partner = PartnerProfile.objects.select_for_update().get(pk=doc.partner_id)
            if rule is not None and rule.mandatory and partner.status == S.APPROVED:
                partner_services.suspend(
                    actor=None,
                    partner_id=str(partner.pk),
                    reason=f"{rule.label} expired",
                    ip=None,
                    cause=partner_services.SUSPENDED_DOCUMENT_EXPIRED,
                )
                suspended += 1
    return {"reminded": reminded, "expired": expired, "suspended": suspended}


# --- Partner account deletion (§6.20) ---


def erase_for_partner(*, partner_id: str) -> list[str]:
    """A deleted partner's documents and application go. Returns the file keys, for the caller
    to delete after the commit."""
    documents = PartnerDocument.objects.filter(partner_id=uid(partner_id))
    keys = [key for key in documents.values_list("file_key", flat=True) if key]
    documents.delete()
    PartnerApplication.objects.filter(partner_id=uid(partner_id)).delete()
    return keys
