"""Read queries for patient documents, always filtered by the owner (others get 404)."""

from django.db.models import Count, QuerySet, Sum

from apps.documents.models import PatientDocument
from common.errors import NotFound
from common.ids import uid


def documents(
    user_id: str, *, member_id: str | None = None, doc_type: str = "", group: str = ""
) -> QuerySet[PatientDocument]:
    """The owner's documents of active members, newest first. `group`: `reports` (lab reports,
    scans, discharge summaries) or `prescriptions`, for the app's tabs."""
    rows = (
        PatientDocument.objects.filter(
            owner_id=uid(user_id), deleted_at__isnull=True, member__is_active=True
        )
        .select_related("member")
        .order_by("-created_at")
    )
    if member_id:
        rows = rows.filter(member_id=uid(member_id))
    if doc_type:
        rows = rows.filter(type=doc_type)
    if group == "reports":
        rows = rows.filter(type__in=PatientDocument.REPORT_TYPES)
    elif group == "prescriptions":
        rows = rows.filter(type=PatientDocument.Type.PRESCRIPTION)
    return rows


def own_document(user_id: str, document_id: str) -> PatientDocument:
    document = (
        PatientDocument.objects.filter(
            pk=uid(document_id),
            owner_id=uid(user_id),
            deleted_at__isnull=True,
            member__is_active=True,
        )
        .select_related("member")
        .first()
    )
    if document is None:
        raise NotFound()
    return document


def used_bytes(user_id: str) -> int:
    """Storage used by the account: the documents the patient can see and delete. Deleted
    ones and those of removed family members (kept only for past bookings) don't count."""
    total = PatientDocument.objects.filter(
        owner_id=uid(user_id), deleted_at__isnull=True, member__is_active=True
    ).aggregate(total=Sum("size_bytes"))["total"]
    return int(total or 0)


def counts_by_member(user_id: str) -> dict[str, int]:
    rows = (
        PatientDocument.objects.filter(
            owner_id=uid(user_id), deleted_at__isnull=True, member__is_active=True
        )
        .values("member_id")
        .annotate(n=Count("id"))
    )
    return {str(row["member_id"]): row["n"] for row in rows}


def admin_documents(user_id: str) -> QuerySet[PatientDocument]:
    """Admin: an account's documents (titles and types only; opening one needs a reason)."""
    return (
        PatientDocument.objects.filter(owner_id=uid(user_id), deleted_at__isnull=True)
        .select_related("member")
        .order_by("-created_at")
    )


def admin_document(user_id: str, document_id: str) -> PatientDocument:
    document = admin_documents(user_id).filter(pk=uid(document_id)).first()
    if document is None:
        raise NotFound()
    return document
