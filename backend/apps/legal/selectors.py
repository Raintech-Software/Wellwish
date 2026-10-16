"""Reads for the legal pages (ARCHITECTURE §6.20)."""

from dataclasses import dataclass

from django.conf import settings
from django.http import HttpRequest

from apps.legal.models import LegalDocument, LegalKind

# Public addresses of the pages (the store listings and the apps link to them)
SLUGS: dict[str, str] = {
    "terms": LegalKind.TERMS,
    "privacy": LegalKind.PRIVACY,
    "refunds": LegalKind.REFUNDS,
    "partner-terms": LegalKind.PARTNER_TERMS,
}
PATHS: dict[str, str] = {kind: f"/legal/{slug}" for slug, kind in SLUGS.items()}
DELETE_ACCOUNT_PATH = "/delete-account"
LANGUAGES = ("en", "hi", "or")


def current(kind: str) -> LegalDocument:
    """The newest version (every kind has one from the first drafts)."""
    return (
        LegalDocument.objects.select_related("published_by")
        .filter(kind=kind)
        .order_by("-version")[0]
    )


def all_current() -> list[LegalDocument]:
    """The newest version of each document, in the order of LegalKind."""
    newest = {
        doc.kind: doc
        for doc in LegalDocument.objects.select_related("published_by")
        .order_by("kind", "-version")
        .distinct("kind")
    }
    return [newest[kind] for kind in LegalKind.values if kind in newest]


def history(kind: str) -> list[LegalDocument]:
    return list(
        LegalDocument.objects.select_related("published_by").filter(kind=kind).order_by("-version")
    )


def version_of(kind: str, version: int) -> LegalDocument | None:
    return (
        LegalDocument.objects.select_related("published_by")
        .filter(kind=kind, version=version)
        .first()
    )


def consent_versions() -> dict[str, str]:
    """What people accept now for each document (§6.20): changes only when a version asked
    everyone again."""
    return {
        kind: version
        for kind, version in LegalDocument.objects.order_by("kind", "-version")
        .distinct("kind")
        .values_list("kind", "consent_version")
    }


@dataclass(frozen=True)
class Localized:
    title: str
    body: str
    language: str  # the language shown ("en" when the asked one isn't written yet)


def localized(doc: LegalDocument, language: str) -> Localized:
    """Hindi and Odia may stay empty: the English text is shown then."""
    if language in ("hi", "or"):
        title = getattr(doc, f"title_{language}")
        body = getattr(doc, f"body_{language}")
        if title and body:
            return Localized(title, body, language)
    return Localized(doc.title_en, doc.body_en, "en")


def languages_written(doc: LegalDocument) -> list[str]:
    return [
        lang for lang in LANGUAGES if getattr(doc, f"title_{lang}") and getattr(doc, f"body_{lang}")
    ]


def public_url(request: HttpRequest | None, path: str) -> str:
    """`PUBLIC_SITE_URL` on servers; otherwise the address this request came in on."""
    base = settings.PUBLIC_SITE_URL.rstrip("/")
    if base:
        return f"{base}{path}"
    if request is None:
        return path
    return request.build_absolute_uri(path)


def public_urls(request: HttpRequest | None) -> dict[str, str]:
    return {
        "terms": public_url(request, PATHS[LegalKind.TERMS]),
        "privacy": public_url(request, PATHS[LegalKind.PRIVACY]),
        "refunds": public_url(request, PATHS[LegalKind.REFUNDS]),
        "partner_terms": public_url(request, PATHS[LegalKind.PARTNER_TERMS]),
        "delete_account": public_url(request, DELETE_ACCOUNT_PATH),
    }
