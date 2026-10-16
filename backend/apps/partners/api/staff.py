"""Admin: partners list and profile, edit, suspend / reinstate / deactivate, force logout
(§9.1 Partners). Adding a partner by hand is in the kyc app (it creates documents too)."""

import datetime as dt
import json
from uuid import UUID

from django.db.models import Count, Exists, OuterRef, Q, QuerySet
from django.http import HttpRequest
from ninja import Query, Router
from ninja.pagination import paginate

from apps.audit.selectors import entity_history
from apps.files.services import view_url
from apps.kyc import selectors as kyc_selectors
from apps.kyc import services as kyc_services
from apps.kyc.api.out import application_out, checklist_out, document_out
from apps.kyc.schemas import AddPartnerIn, ApplicationOut, DocStateOut, DocumentOut
from apps.partners import selectors, services
from apps.partners.api.out import profile_out
from apps.partners.models import PartnerDeletion, PartnerProfile, SelfieCheck
from apps.partners.schemas import (
    AdminSelfieOut,
    HistoryOut,
    PartnerEditIn,
    PartnerProfileOut,
    PartnerRowOut,
    ReasonIn,
)
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.dates import today_ist
from common.errors import ApiError
from common.pagination import Mapped, WWPagination
from common.request import client_ip
from common.schemas import CamelSchema, OkOut

router = Router(tags=["admin"])


class PartnerDetailOut(CamelSchema):
    partner: PartnerProfileOut
    documents: list[DocStateOut]
    history_documents: list[DocumentOut]
    application: ApplicationOut | None
    history: list[HistoryOut]


def _text(value: object) -> str | None:
    return None if value is None else json.dumps(value, ensure_ascii=False)


def _detail(partner_id: str) -> PartnerDetailOut:
    partner = selectors.get_partner(partner_id)
    app = kyc_selectors.application_of(partner_id)
    history = entity_history("partners.partnerprofile", partner_id)
    return PartnerDetailOut(
        partner=profile_out(partner),
        documents=checklist_out(partner),
        history_documents=[document_out(d) for d in kyc_selectors.documents_of(partner_id)],
        application=application_out(app) if app else None,
        history=[
            HistoryOut(
                at=h.at,
                action=h.action,
                by=h.staff.name if h.staff else None,
                before=_text(h.before),
                after=_text(h.after),
                reason=h.reason,
            )
            for h in history
        ],
    )


@router.get(
    "/partners", response=list[PartnerRowOut], by_alias=True, operation_id="adminPartnersList"
)
@staff_permission("partners.view")
@paginate(WWPagination)
def list_partners(
    request: HttpRequest,
    role: str = "",
    status: str = "",
    available: bool | None = None,
    q: str = "",
    to_review: bool = Query(False, alias="toReview"),
) -> QuerySet[PartnerProfile]:
    """Newest first. `toReview` = approved partners with an upload waiting (renewals)."""
    qs = selectors.partners(
        role=role,
        status=status,
        available=available,
        q=q.strip(),
        ids=kyc_selectors.partners_with_documents_to_review() if to_review else None,
    ).prefetch_related("phones")
    return qs.annotate(
        to_review=Count("documents", filter=Q(documents__status="PENDING"), distinct=True),
        # §6.20: asked to delete their account (the status itself doesn't change meanwhile)
        deleting=Exists(
            PartnerDeletion.objects.filter(
                user_id=OuterRef("pk"), status=PartnerDeletion.Status.PENDING
            )
        ),
    )


@router.get(
    "/partners/{uuid:partner_id}",
    response=PartnerDetailOut,
    by_alias=True,
    operation_id="adminPartnerGet",
)
@staff_permission("partners.view")
def get_partner(request: HttpRequest, partner_id: UUID) -> PartnerDetailOut:
    """Profile, both phones, email, documents (with history), application and status history."""
    return _detail(str(partner_id))


@router.put(
    "/partners/{uuid:partner_id}",
    response=PartnerDetailOut,
    by_alias=True,
    operation_id="adminPartnerUpdate",
)
@staff_permission("partners.add")
def update_partner(request: HttpRequest, partner_id: UUID, data: PartnerEditIn) -> PartnerDetailOut:
    services.update_by_admin(
        actor=acting_staff(request),
        partner_id=str(partner_id),
        data=data.model_dump(),
        ip=client_ip(request),
    )
    return _detail(str(partner_id))


@router.post(
    "/partners/{uuid:partner_id}/suspend",
    response=PartnerDetailOut,
    by_alias=True,
    operation_id="adminPartnerSuspend",
)
@staff_permission("partners.suspend")
def suspend(request: HttpRequest, partner_id: UUID, data: ReasonIn) -> PartnerDetailOut:
    """Logged out at once on their phone."""
    services.suspend(
        actor=acting_staff(request),
        partner_id=str(partner_id),
        reason=data.reason,
        ip=client_ip(request),
    )
    return _detail(str(partner_id))


@router.post(
    "/partners/{uuid:partner_id}/reinstate",
    response=PartnerDetailOut,
    by_alias=True,
    operation_id="adminPartnerReinstate",
)
@staff_permission("partners.suspend")
def reinstate(request: HttpRequest, partner_id: UUID) -> PartnerDetailOut:
    services.reinstate(
        actor=acting_staff(request), partner_id=str(partner_id), ip=client_ip(request)
    )
    return _detail(str(partner_id))


@router.post(
    "/partners/{uuid:partner_id}/deactivate",
    response=PartnerDetailOut,
    by_alias=True,
    operation_id="adminPartnerDeactivate",
)
@staff_permission("partners.suspend")
def deactivate(request: HttpRequest, partner_id: UUID, data: ReasonIn) -> PartnerDetailOut:
    """The partner left or was removed. Their history stays."""
    services.deactivate(
        actor=acting_staff(request),
        partner_id=str(partner_id),
        reason=data.reason,
        ip=client_ip(request),
    )
    return _detail(str(partner_id))


@router.post(
    "/partners/{uuid:partner_id}/logout",
    response=OkOut,
    by_alias=True,
    operation_id="adminPartnerForceLogout",
)
@staff_permission("partners.suspend")
def force_logout(request: HttpRequest, partner_id: UUID) -> OkOut:
    services.force_logout(
        actor=acting_staff(request), partner_id=str(partner_id), ip=client_ip(request)
    )
    return OkOut()


# --- Add a partner by hand (§6.3) ---

PROFILE_KEYS = {
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
}


@router.post(
    "/partners", response=PartnerProfileOut, by_alias=True, operation_id="adminPartnersAdd"
)
@staff_permission("partners.add")
def add_partner(request: HttpRequest, data: AddPartnerIn) -> PartnerProfileOut:
    """Saved APPROVED. Upload the photo and documents first (`/admin/files/upload-url`)."""
    if not data.checked:
        raise ApiError(
            status=422, code="NOT_CHECKED", message="Confirm you checked every document."
        )
    partner = kyc_services.add_partner_by_admin(
        actor=acting_staff(request),
        phone=data.phone,
        role=data.role,
        alternate_phone=data.alternate_phone,
        email=data.email,
        profile=data.model_dump(include=PROFILE_KEYS),
        documents=[
            kyc_services.DocumentInput(
                doc_type=d.doc_type, file_key=d.file_key, number=d.number, expires_on=d.expires_on
            )
            for d in data.documents
        ],
        ip=client_ip(request),
    )
    return profile_out(partner)


def selfie_out(selfie: SelfieCheck) -> AdminSelfieOut:
    partner = selfie.partner
    return AdminSelfieOut(
        id=str(selfie.pk),
        partner_id=str(partner.pk),
        partner_name=partner.full_name,
        role=partner.role,
        at=selfie.at,
        selfie_url=view_url(selfie.file_key) if selfie.file_key else None,
        photo_url=view_url(partner.photo_key) if partner.photo_key else None,
    )


@router.get(
    "/selfies", response=list[AdminSelfieOut], by_alias=True, operation_id="adminSelfiesList"
)
@staff_permission("partners.review")
@paginate(WWPagination)
def list_selfies(
    request: HttpRequest,
    day: dt.date | None = Query(None, alias="date"),  # noqa: B008
    partner_id: UUID | None = Query(None, alias="partnerId"),  # noqa: B008
) -> Mapped[AdminSelfieOut]:
    """Spot checks (§6.15): the day's selfies (India date, today by default), newest first,
    next to each partner's approved photo."""
    rows = selectors.selfies(
        day=day or today_ist(), partner_id=str(partner_id) if partner_id else ""
    )
    return Mapped(rows, selfie_out)
