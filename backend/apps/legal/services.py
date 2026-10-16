"""Writes for the legal pages (ARCHITECTURE §6.20): publishing a new version."""

from dataclasses import dataclass

from django.db import IntegrityError, transaction
from django.utils import timezone

from apps.audit.services import record
from apps.legal.models import LegalDocument
from apps.legal.text import clean
from apps.staff.models import StaffUser
from common.errors import ApiError, Conflict, NotFound


class VersionChanged(Conflict):
    code = "LEGAL_VERSION_CHANGED"
    message = "Someone published a new version meanwhile. Reload and make your change again."


class NothingChanged(ApiError):
    status = 422
    code = "NOTHING_CHANGED"
    message = "The text is the same as the published version."


class IncompleteLanguage(ApiError):
    status = 422
    code = "INCOMPLETE_LANGUAGE"
    message = "Fill in both the title and the text of a language, or leave both empty."


@dataclass(frozen=True)
class LegalTexts:
    title_en: str
    title_hi: str
    title_or: str
    body_en: str
    body_hi: str
    body_or: str


FIELDS = ("title_en", "title_hi", "title_or", "body_en", "body_hi", "body_or")


def _cleaned(texts: LegalTexts) -> dict[str, str]:
    values = {
        "title_en": " ".join(texts.title_en.split()),
        "title_hi": " ".join(texts.title_hi.split()),
        "title_or": " ".join(texts.title_or.split()),
        "body_en": clean(texts.body_en),
        "body_hi": clean(texts.body_hi),
        "body_or": clean(texts.body_or),
    }
    if not values["title_en"] or not values["body_en"]:
        raise IncompleteLanguage(details={"language": "en"})
    for lang in ("hi", "or"):
        if bool(values[f"title_{lang}"]) != bool(values[f"body_{lang}"]):
            raise IncompleteLanguage(details={"language": lang})
    return values


@transaction.atomic
def publish(
    *,
    actor: StaffUser,
    kind: str,
    texts: LegalTexts,
    ask_again: bool,
    expected_version: int,
    ip: str | None,
) -> LegalDocument:
    """A new version of the document. `ask_again`: everyone accepts it again at their next app
    open (its consent version changes); otherwise a small fix nobody is asked about."""
    latest = (
        LegalDocument.objects.select_for_update().filter(kind=kind).order_by("-version").first()
    )
    if latest is None:
        raise NotFound()
    if latest.version != expected_version:
        raise VersionChanged(details={"version": latest.version})
    values = _cleaned(texts)
    if all(getattr(latest, field) == values[field] for field in FIELDS):
        raise NothingChanged()
    version = latest.version + 1
    try:
        with transaction.atomic():  # another publish of this version won meanwhile: 409
            doc = LegalDocument.objects.create(
                kind=kind,
                version=version,
                consent_version=str(version) if ask_again else latest.consent_version,
                asked_again=ask_again,
                published_by=actor,
                published_at=timezone.now(),
                **values,
            )
    except IntegrityError:
        raise VersionChanged(details={"version": version}) from None
    record(
        actor,
        "legal.published",
        doc,
        before={"version": latest.version},
        after={
            "version": version,
            "askedAgain": ask_again,
            "changed": [field for field in FIELDS if getattr(latest, field) != values[field]],
        },
        ip=ip,
    )
    return doc
