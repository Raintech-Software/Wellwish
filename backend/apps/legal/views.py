"""Public pages served by the API (ARCHITECTURE §6.20): the legal pages and the account
deletion page. Server-rendered and escaped; no scripts at all (their CSP forbids them).

The language: `?l=hi` / `?l=or`, else the browser's, else English. A legal page not written in
that language yet is shown in English with a note."""

from django.http import Http404, HttpRequest, HttpResponse
from django.shortcuts import render

from apps.legal import selectors
from apps.legal.models import LegalKind
from apps.legal.text import blocks
from apps.notifications.text import day

CSP = (
    "default-src 'none'; style-src 'unsafe-inline'; img-src 'self' data:; "
    "form-action 'self'; base-uri 'none'; frame-ancestors 'none'"
)

TEXTS: dict[str, dict[str, str]] = {
    "en": {
        "version": "Version {version} · {date}",
        "fallback": "This page isn't written in English yet.",
        "other": "Other pages",
        LegalKind.TERMS: "Terms of Use",
        LegalKind.PRIVACY: "Privacy Policy",
        LegalKind.REFUNDS: "Refund Policy",
        LegalKind.PARTNER_TERMS: "Partner Terms",
        "delete": "Delete your account",
    },
    "hi": {
        "version": "संस्करण {version} · {date}",
        "fallback": "यह पेज अभी हिन्दी में नहीं लिखा गया है, इसलिए अंग्रेज़ी में दिखाया गया है।",
        "other": "अन्य पेज",
        LegalKind.TERMS: "उपयोग की शर्तें",
        LegalKind.PRIVACY: "गोपनीयता नीति",
        LegalKind.REFUNDS: "रिफ़ंड नीति",
        LegalKind.PARTNER_TERMS: "पार्टनर की शर्तें",
        "delete": "अपना खाता हटाएँ",
    },
    "or": {
        "version": "ସଂସ୍କରଣ {version} · {date}",
        "fallback": "ଏହି ପୃଷ୍ଠା ଏପର୍ଯ୍ୟନ୍ତ ଓଡ଼ିଆରେ ଲେଖାଯାଇନାହିଁ, ତେଣୁ ଇଂରାଜୀରେ ଦେଖାଯାଉଛି।",
        "other": "ଅନ୍ୟ ପୃଷ୍ଠା",
        LegalKind.TERMS: "ବ୍ୟବହାର ସର୍ତ୍ତାବଳୀ",
        LegalKind.PRIVACY: "ଗୋପନୀୟତା ନୀତି",
        LegalKind.REFUNDS: "ଫେରସ୍ତ ନୀତି",
        LegalKind.PARTNER_TERMS: "ପାର୍ଟନର ସର୍ତ୍ତାବଳୀ",
        "delete": "ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ",
    },
}
LANGUAGE_NAMES = {"en": "English", "hi": "हिन्दी", "or": "ଓଡ଼ିଆ"}


def page_language(request: HttpRequest) -> str:
    asked = request.GET.get("l", "")
    if asked in selectors.LANGUAGES:
        return asked
    for part in request.headers.get("Accept-Language", "").split(","):
        code = part.split(";")[0].strip().lower()[:2]
        if code in selectors.LANGUAGES:
            return code
    return "en"


def with_headers(response: HttpResponse) -> HttpResponse:
    response["Content-Security-Policy"] = CSP
    # same-origin, not no-referrer: with no-referrer a form POST says "Origin: null", which
    # Django's CSRF check refuses over HTTPS
    response["Referrer-Policy"] = "same-origin"
    response["X-Content-Type-Options"] = "nosniff"
    response["Cache-Control"] = "no-store"
    return response


def chrome(request: HttpRequest, language: str, current_path: str) -> dict[str, object]:
    """What every public page shows around its content: the language links, the other pages."""
    texts = TEXTS[language]
    pages = [(texts[kind], selectors.PATHS[kind]) for kind in LegalKind.values]
    pages.append((texts["delete"], selectors.DELETE_ACCOUNT_PATH))
    return {
        "language": language,
        "texts": texts,
        "languages": [
            (code, name, f"{current_path}?l={code}") for code, name in LANGUAGE_NAMES.items()
        ],
        "pages": [(name, f"{path}?l={language}", path == current_path) for name, path in pages],
    }


def legal_page(request: HttpRequest, slug: str) -> HttpResponse:
    kind = selectors.SLUGS.get(slug)
    if kind is None:
        raise Http404
    language = page_language(request)
    doc = selectors.current(kind)
    shown = selectors.localized(doc, language)
    texts = TEXTS[language]
    context = {
        **chrome(request, language, selectors.PATHS[kind]),
        "title": shown.title,
        "shown_language": shown.language,
        "fallback": shown.language != language,
        "fallback_text": texts["fallback"] if language != "en" else "",
        "version_line": texts["version"].format(
            version=doc.version, date=day(doc.published_at)[language]
        ),
        "blocks": blocks(shown.body),
    }
    return with_headers(render(request, "legal/page.html", context))
