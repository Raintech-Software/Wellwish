"""Read queries for partner verification, always filtered by the caller."""

from dataclasses import dataclass
from datetime import datetime

from django.db.models import Count, Q, QuerySet

from apps.kyc.models import PartnerApplication, PartnerDocument, RequiredDocument
from apps.partners.selectors import deleting_partner_ids
from common.errors import NotFound
from common.ids import uid


def required_documents(role: str, *, include_inactive: bool = False) -> list[RequiredDocument]:
    qs = RequiredDocument.objects.filter(role=role)
    if not include_inactive:
        qs = qs.filter(is_active=True)
    return list(qs.order_by("sort", "label"))


def all_required_documents() -> QuerySet[RequiredDocument]:
    return RequiredDocument.objects.order_by("role", "sort", "label")


def get_required_document(required_id: str) -> RequiredDocument:
    row = RequiredDocument.objects.filter(pk=required_id).first()
    if row is None:
        raise NotFound()
    return row


def current_documents(partner_id: str) -> dict[str, PartnerDocument]:
    return {
        d.doc_type: d
        for d in PartnerDocument.objects.filter(partner_id=uid(partner_id), is_current=True)
    }


def pending_replacements(partner_id: str) -> dict[str, PartnerDocument]:
    """The newest not-yet-current upload per type (a replacement for an approved document)."""
    found: dict[str, PartnerDocument] = {}
    for d in PartnerDocument.objects.filter(partner_id=uid(partner_id), is_current=False).order_by(
        "-created_at"
    ):
        found.setdefault(d.doc_type, d)
    return found


@dataclass(frozen=True)
class DocState:
    """One line of the partner's document checklist."""

    required: RequiredDocument
    current: PartnerDocument | None
    replacement: PartnerDocument | None  # only while it waits or after it was rejected

    @property
    def status(self) -> str:
        return self.current.status if self.current else "MISSING"


def document_checklist(partner_id: str, role: str) -> list[DocState]:
    current = current_documents(partner_id)
    replacements = pending_replacements(partner_id)
    states = []
    for req in required_documents(role):
        cur = current.get(req.doc_type)
        rep = replacements.get(req.doc_type)
        if rep is not None and (
            rep.status not in (PartnerDocument.Status.PENDING, PartnerDocument.Status.REJECTED)
            or (cur is not None and rep.created_at < cur.created_at)
        ):
            rep = None
        states.append(DocState(required=req, current=cur, replacement=rep))
    return states


def get_document(document_id: str) -> PartnerDocument:
    doc = PartnerDocument.objects.select_related("partner").filter(pk=document_id).first()
    if doc is None:
        raise NotFound()
    return doc


def documents_of(partner_id: str) -> QuerySet[PartnerDocument]:
    """Every upload, newest first (history included)."""
    return (
        PartnerDocument.objects.filter(partner_id=uid(partner_id))
        .select_related("reviewed_by")
        .order_by("doc_type", "-created_at")
    )


def application_of(partner_id: str) -> PartnerApplication | None:
    return (
        PartnerApplication.objects.select_related("claimed_by", "decided_by")
        .filter(partner_id=uid(partner_id))
        .first()
    )


def applications(*, status: str = "", role: str = "") -> QuerySet[PartnerApplication]:
    """The review queue: oldest submission first (§9.4)."""
    qs = PartnerApplication.objects.select_related("partner__user", "claimed_by").annotate(
        pending_docs=Count(
            "partner__documents",
            filter=Q(
                partner__documents__status=PartnerDocument.Status.PENDING,
                partner__documents__is_current=True,
            ),
        )
    )
    if status:
        qs = qs.filter(status=status)
    else:
        qs = qs.filter(
            status__in=[PartnerApplication.Status.SUBMITTED, PartnerApplication.Status.UNDER_REVIEW]
        ).exclude(partner_id__in=deleting_partner_ids())  # §6.20: asked to delete their account
    if role:
        qs = qs.filter(partner__role=role)
    return qs.order_by("submitted_at")


def get_application(application_id: str) -> PartnerApplication:
    app = (
        PartnerApplication.objects.select_related("partner__user", "claimed_by", "decided_by")
        .filter(pk=application_id)
        .first()
    )
    if app is None:
        raise NotFound()
    return app


def partners_with_documents_to_review() -> list[str]:
    """Approved or suspended partners with an upload waiting (re-uploads, renewals)."""
    return [
        str(pk)
        for pk in PartnerDocument.objects.filter(
            status=PartnerDocument.Status.PENDING,
            partner__status__in=["APPROVED", "SUSPENDED"],
        )
        .values_list("partner_id", flat=True)
        .distinct()
    ]


def claim_is_active(app: PartnerApplication, now: datetime) -> bool:
    return (
        app.claimed_by_id is not None and app.claimed_until is not None and app.claimed_until > now
    )


def applications_waiting() -> tuple[int, datetime | None]:
    """The dashboard (9.2): applications waiting for a reviewer, and the oldest one's time."""
    waiting = PartnerApplication.objects.filter(
        status__in=(PartnerApplication.Status.SUBMITTED, PartnerApplication.Status.UNDER_REVIEW)
    ).exclude(partner_id__in=deleting_partner_ids())  # §6.20
    oldest = waiting.order_by("submitted_at").values_list("submitted_at", flat=True).first()
    return waiting.count(), oldest
