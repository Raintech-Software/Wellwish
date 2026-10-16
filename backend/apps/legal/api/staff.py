"""Admin: Settings → Legal pages (ARCHITECTURE §6.20). Super Admin only (`legal.manage`)."""

from django.http import HttpRequest
from ninja import Router

from apps.legal import selectors, services
from apps.legal.models import LegalDocument
from apps.legal.schemas import (
    LegalDocumentOut,
    LegalKindIn,
    LegalPublishIn,
    LegalSummaryOut,
    LegalVersionOut,
)
from apps.staff.selectors import acting_staff
from common.auth import staff_permission
from common.errors import NotFound
from common.request import client_ip

router = Router(tags=["admin"])


def _by(doc: LegalDocument) -> str | None:
    return doc.published_by.name if doc.published_by else None


def _document(request: HttpRequest, doc: LegalDocument, newest: int) -> LegalDocumentOut:
    return LegalDocumentOut(
        kind=doc.kind,  # type: ignore[arg-type]
        version=doc.version,
        is_newest=doc.version == newest,
        consent_version=doc.consent_version,
        asked_again=doc.asked_again,
        title_en=doc.title_en,
        title_hi=doc.title_hi,
        title_or=doc.title_or,
        body_en=doc.body_en,
        body_hi=doc.body_hi,
        body_or=doc.body_or,
        published_at=doc.published_at,
        published_by=_by(doc),
        public_url=selectors.public_url(request, selectors.PATHS[doc.kind]),
    )


@router.get("/legal", response=list[LegalSummaryOut], by_alias=True, operation_id="adminLegalList")
@staff_permission("legal.manage")
def legal_list(request: HttpRequest) -> list[LegalSummaryOut]:
    return [
        LegalSummaryOut(
            kind=doc.kind,  # type: ignore[arg-type]
            title=doc.title_en,
            version=doc.version,
            consent_version=doc.consent_version,
            asked_again=doc.asked_again,
            languages=selectors.languages_written(doc),
            published_at=doc.published_at,
            published_by=_by(doc),
            public_url=selectors.public_url(request, selectors.PATHS[doc.kind]),
        )
        for doc in selectors.all_current()
    ]


@router.get("/legal/{kind}", response=LegalDocumentOut, by_alias=True, operation_id="adminLegalGet")
@staff_permission("legal.manage")
def legal_get(request: HttpRequest, kind: LegalKindIn) -> LegalDocumentOut:
    """The newest version, to edit."""
    doc = selectors.current(kind)
    return _document(request, doc, doc.version)


@router.get(
    "/legal/{kind}/versions",
    response=list[LegalVersionOut],
    by_alias=True,
    operation_id="adminLegalVersions",
)
@staff_permission("legal.manage")
def legal_versions(request: HttpRequest, kind: LegalKindIn) -> list[LegalVersionOut]:
    return [
        LegalVersionOut(
            version=doc.version,
            asked_again=doc.asked_again,
            published_at=doc.published_at,
            published_by=_by(doc),
        )
        for doc in selectors.history(kind)
    ]


@router.get(
    "/legal/{kind}/versions/{version}",
    response=LegalDocumentOut,
    by_alias=True,
    operation_id="adminLegalVersion",
)
@staff_permission("legal.manage")
def legal_version(request: HttpRequest, kind: LegalKindIn, version: int) -> LegalDocumentOut:
    """An old version, read-only (which text someone accepted)."""
    doc = selectors.version_of(kind, version)
    if doc is None:
        raise NotFound()
    return _document(request, doc, selectors.current(kind).version)


@router.post(
    "/legal/{kind}", response=LegalDocumentOut, by_alias=True, operation_id="adminLegalPublish"
)
@staff_permission("legal.manage")
def legal_publish(
    request: HttpRequest, kind: LegalKindIn, data: LegalPublishIn
) -> LegalDocumentOut:
    """Publish a new version: a small fix (nobody is asked again) or `askAgain` (everyone
    accepts it again at their next app open). Logged."""
    doc = services.publish(
        actor=acting_staff(request),
        kind=kind,
        texts=services.LegalTexts(
            title_en=data.title_en,
            title_hi=data.title_hi,
            title_or=data.title_or,
            body_en=data.body_en,
            body_hi=data.body_hi,
            body_or=data.body_or,
        ),
        ask_again=data.ask_again,
        expected_version=data.expected_version,
        ip=client_ip(request),
    )
    return _document(request, doc, doc.version)
