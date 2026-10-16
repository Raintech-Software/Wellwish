"""Turning verification rows into API answers (partner app and admin)."""

from apps.kyc import selectors
from apps.kyc.models import PartnerApplication, PartnerDocument, RequiredDocument
from apps.kyc.schemas import (
    ApplicationOut,
    DocStateOut,
    DocumentOut,
    KycStatusOut,
    RequiredDocumentOut,
    StepsOut,
)
from apps.partners.api.out import profile_out
from apps.partners.models import PartnerPhone, PartnerProfile
from apps.partners.services import EDITABLE


def required_out(r: RequiredDocument) -> RequiredDocumentOut:
    return RequiredDocumentOut(
        id=str(r.pk),
        role=r.role,
        doc_type=r.doc_type,
        label=r.label,
        label_hi=r.label_hi,
        label_or=r.label_or,
        help=r.help,
        help_hi=r.help_hi,
        help_or=r.help_or,
        mandatory=r.mandatory,
        condition=r.condition,
        condition_hi=r.condition_hi,
        condition_or=r.condition_or,
        has_expiry=r.has_expiry,
        number_rule=r.number_rule,
        camera_only=r.camera_only,
        sort=r.sort,
        is_active=r.is_active,
    )


def document_out(d: PartnerDocument) -> DocumentOut:
    return DocumentOut(
        id=str(d.pk),
        doc_type=d.doc_type,
        status=d.status,
        mime=d.mime,
        number_masked=d.number_masked,
        expires_on=d.expires_on,
        reject_reason=d.reject_reason,
        is_current=d.is_current,
        reviewed_by=d.reviewed_by.name if d.reviewed_by else None,
        reviewed_at=d.reviewed_at,
        created_at=d.created_at,
    )


def checklist_out(partner: PartnerProfile) -> list[DocStateOut]:
    return [
        DocStateOut(
            required=required_out(s.required),
            status=s.status,
            document=document_out(s.current) if s.current else None,
            replacement=document_out(s.replacement) if s.replacement else None,
        )
        for s in selectors.document_checklist(str(partner.pk), partner.role)
    ]


def application_out(app: PartnerApplication) -> ApplicationOut:
    return ApplicationOut(
        id=str(app.pk),
        status=app.status,
        submitted_at=app.submitted_at,
        first_submitted_at=app.first_submitted_at,
        notes=app.notes,
        claimed_by=app.claimed_by.name if app.claimed_by else None,
        claimed_until=app.claimed_until,
        decided_by=app.decided_by.name if app.decided_by else None,
        decided_at=app.decided_at,
    )


def status_out(partner: PartnerProfile) -> KycStatusOut:
    docs = checklist_out(partner)
    alternate = PartnerPhone.objects.filter(
        partner=partner, kind=PartnerPhone.Kind.ALTERNATE, verified_at__isnull=False
    ).exists()
    documents_done = all(
        d.status not in ("MISSING", "REJECTED") for d in docs if d.required.mandatory
    ) and not any(d.status == "REJECTED" for d in docs)
    steps = StepsOut(
        role=True,
        alternate_phone=alternate,
        email=partner.email_verified_at is not None,
        profile=partner.profile_complete,
        documents=documents_done,
    )
    app = selectors.application_of(str(partner.pk))
    return KycStatusOut(
        profile=profile_out(partner),
        steps=steps,
        can_edit=partner.status in EDITABLE,
        can_submit=partner.status in ("REGISTERED", "CHANGES_REQUESTED")
        and steps.alternate_phone
        and steps.email
        and steps.profile
        and documents_done,
        documents=docs,
        application=application_out(app) if app else None,
    )
