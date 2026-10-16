"""Admin: partner applications and document review (§9.4), the required-documents list and
adding a partner by hand (/v1/admin/...)."""

from uuid import UUID

from django.http import HttpRequest
from django.utils import timezone
from ninja import Router

from apps.files.schemas import ViewUrlOut
from apps.files.services import view_url
from apps.kyc import selectors, services
from apps.kyc.api.out import application_out, checklist_out, document_out, required_out
from apps.kyc.models import PartnerApplication
from apps.kyc.schemas import (
    ApplicationDetailOut,
    ApplicationRowOut,
    DocumentOut,
    NoteIn,
    RejectDocumentIn,
    RequiredDocumentIn,
    RequiredDocumentOut,
)
from apps.partners.api.out import profile_out
from apps.partners.schemas import ReasonIn
from apps.staff.selectors import acting_staff
from common.auth import get_principal, staff_any_permission, staff_permission
from common.errors import ApiError
from common.request import client_ip
from common.schemas import OkOut

router = Router(tags=["admin"])


def _row(app: PartnerApplication, me: str) -> ApplicationRowOut:
    now = timezone.now()
    claimed = selectors.claim_is_active(app, now)
    return ApplicationRowOut(
        id=str(app.pk),
        partner_id=str(app.partner_id),
        full_name=app.partner.full_name,
        role=app.partner.role,
        phone=app.partner.user.phone,
        status=app.status,
        submitted_at=app.submitted_at,
        first_submitted_at=app.first_submitted_at,
        waiting_hours=int((now - app.submitted_at).total_seconds() // 3600),
        pending_documents=getattr(app, "pending_docs", 0),
        claimed_by=app.claimed_by.name if claimed and app.claimed_by else None,
        claimed_until=app.claimed_until if claimed else None,
        claimed_by_me=claimed and str(app.claimed_by_id) == me,
    )


def _detail(request: HttpRequest, app_id: str) -> ApplicationDetailOut:
    app = selectors.get_application(app_id)
    me = get_principal(request).subject_id
    claimed_by_me = selectors.claim_is_active(app, timezone.now()) and str(app.claimed_by_id) == me
    missing = services.missing_mandatory(app.partner)
    waiting = any(
        d.status == "PENDING" for d in selectors.current_documents(str(app.partner_id)).values()
    )
    return ApplicationDetailOut(
        application=application_out(app),
        partner=profile_out(app.partner),
        documents=checklist_out(app.partner),
        claimed_by_me=claimed_by_me,
        can_approve=claimed_by_me
        and app.status == PartnerApplication.Status.UNDER_REVIEW
        and not missing
        and not waiting,
        missing_documents=missing,
    )


@router.get(
    "/applications",
    response=list[ApplicationRowOut],
    by_alias=True,
    operation_id="adminApplicationsList",
)
@staff_permission("partners.review")
def list_applications(
    request: HttpRequest, status: str = "", role: str = ""
) -> list[ApplicationRowOut]:
    """Oldest first. Default: submitted and under review."""
    me = get_principal(request).subject_id
    return [_row(a, me) for a in selectors.applications(status=status, role=role)]


@router.get(
    "/applications/{uuid:application_id}",
    response=ApplicationDetailOut,
    by_alias=True,
    operation_id="adminApplicationGet",
)
@staff_permission("partners.review")
def get_application(request: HttpRequest, application_id: UUID) -> ApplicationDetailOut:
    return _detail(request, str(application_id))


@router.post(
    "/applications/{uuid:application_id}/claim",
    response=ApplicationDetailOut,
    by_alias=True,
    operation_id="adminApplicationClaim",
)
@staff_permission("partners.review")
def claim(request: HttpRequest, application_id: UUID) -> ApplicationDetailOut:
    """Open for review: locked to you for 30 minutes (409 CLAIMED_BY_OTHER otherwise)."""
    services.claim(
        actor=acting_staff(request), application_id=str(application_id), ip=client_ip(request)
    )
    return _detail(request, str(application_id))


@router.post(
    "/applications/{uuid:application_id}/release",
    response=OkOut,
    by_alias=True,
    operation_id="adminApplicationRelease",
)
@staff_permission("partners.review")
def release(request: HttpRequest, application_id: UUID) -> OkOut:
    services.release(
        actor=acting_staff(request), application_id=str(application_id), ip=client_ip(request)
    )
    return OkOut()


@router.post(
    "/applications/{uuid:application_id}/approve",
    response=ApplicationDetailOut,
    by_alias=True,
    operation_id="adminApplicationApprove",
)
@staff_permission("partners.review")
def approve(request: HttpRequest, application_id: UUID) -> ApplicationDetailOut:
    """Every required document approved and none waiting → the partner is APPROVED."""
    services.approve_application(
        actor=acting_staff(request), application_id=str(application_id), ip=client_ip(request)
    )
    return _detail(request, str(application_id))


@router.post(
    "/applications/{uuid:application_id}/request-changes",
    response=ApplicationDetailOut,
    by_alias=True,
    operation_id="adminApplicationRequestChanges",
)
@staff_permission("partners.review")
def request_changes(
    request: HttpRequest, application_id: UUID, data: NoteIn
) -> ApplicationDetailOut:
    """The partner sees the reason for each rejected document (and this note)."""
    services.request_changes(
        actor=acting_staff(request),
        application_id=str(application_id),
        note=data.note,
        ip=client_ip(request),
    )
    return _detail(request, str(application_id))


@router.post(
    "/applications/{uuid:application_id}/reject",
    response=ApplicationDetailOut,
    by_alias=True,
    operation_id="adminApplicationReject",
)
@staff_permission("partners.review")
def reject(request: HttpRequest, application_id: UUID, data: ReasonIn) -> ApplicationDetailOut:
    """Final: not eligible."""
    services.reject_application(
        actor=acting_staff(request),
        application_id=str(application_id),
        reason=data.reason,
        ip=client_ip(request),
    )
    return _detail(request, str(application_id))


# --- Documents ---


@router.get(
    "/partner-documents/{uuid:document_id}/view-url",
    response=ViewUrlOut,
    by_alias=True,
    operation_id="adminPartnerDocumentView",
)
@staff_any_permission("partners.review", "partners.add")
def document_view(request: HttpRequest, document_id: UUID) -> ViewUrlOut:
    """A 5-minute link. Every view is in the audit log."""
    doc = services.view_document(
        actor=acting_staff(request), document_id=str(document_id), ip=client_ip(request)
    )
    return ViewUrlOut(url=view_url(doc.file_key), mime=doc.mime)


@router.post(
    "/partner-documents/{uuid:document_id}/approve",
    response=DocumentOut,
    by_alias=True,
    operation_id="adminPartnerDocumentApprove",
)
@staff_permission("partners.review")
def document_approve(request: HttpRequest, document_id: UUID) -> DocumentOut:
    return document_out(
        services.review_document(
            actor=acting_staff(request),
            document_id=str(document_id),
            approve=True,
            reason="",
            ip=client_ip(request),
        )
    )


@router.post(
    "/partner-documents/{uuid:document_id}/reject",
    response=DocumentOut,
    by_alias=True,
    operation_id="adminPartnerDocumentReject",
)
@staff_permission("partners.review")
def document_reject(request: HttpRequest, document_id: UUID, data: RejectDocumentIn) -> DocumentOut:
    """The reason is shown to the partner."""
    return document_out(
        services.review_document(
            actor=acting_staff(request),
            document_id=str(document_id),
            approve=False,
            reason=data.reason,
            ip=client_ip(request),
        )
    )


# --- Required documents (§9.1) ---


@router.get(
    "/required-documents",
    response=list[RequiredDocumentOut],
    by_alias=True,
    operation_id="adminRequiredDocumentsList",
)
@staff_any_permission("partners.review", "partners.add")
def list_required(request: HttpRequest) -> list[RequiredDocumentOut]:
    return [required_out(r) for r in selectors.all_required_documents()]


@router.post(
    "/required-documents",
    response=RequiredDocumentOut,
    by_alias=True,
    operation_id="adminRequiredDocumentsCreate",
)
@staff_permission("partners.review")
def create_required(request: HttpRequest, data: RequiredDocumentIn) -> RequiredDocumentOut:
    return required_out(
        services.save_required_document(
            actor=acting_staff(request), data=data.model_dump(), ip=client_ip(request)
        )
    )


@router.put(
    "/required-documents/{uuid:required_id}",
    response=RequiredDocumentOut,
    by_alias=True,
    operation_id="adminRequiredDocumentsUpdate",
)
@staff_permission("partners.review")
def update_required(
    request: HttpRequest, required_id: UUID, data: RequiredDocumentIn
) -> RequiredDocumentOut:
    """Role and type can't change (add a new row instead)."""
    row = selectors.get_required_document(str(required_id))
    if (row.role, row.doc_type) != (data.role, data.doc_type):
        raise ApiError(
            status=422, code="KEY_FIXED", message="Role and document type can't be changed."
        )
    return required_out(
        services.save_required_document(
            actor=acting_staff(request),
            data=data.model_dump(),
            ip=client_ip(request),
            required_id=str(required_id),
        )
    )


@router.delete(
    "/required-documents/{uuid:required_id}",
    response=OkOut,
    by_alias=True,
    operation_id="adminRequiredDocumentsDelete",
)
@staff_permission("partners.review")
def delete_required(request: HttpRequest, required_id: UUID) -> OkOut:
    """Refused (409 IN_USE) once partners uploaded it: turn it off instead."""
    services.delete_required_document(
        actor=acting_staff(request), required_id=str(required_id), ip=client_ip(request)
    )
    return OkOut()
