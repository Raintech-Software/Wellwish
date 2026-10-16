"""Legal pages (ARCHITECTURE §6.20, PHASES 9B.1): versions, publishing, public pages."""

import pytest
from django.test import Client

from apps.audit.models import AuditLog
from apps.legal.models import LegalDocument
from apps.legal.text import blocks
from conftest import staff_token

pytestmark = pytest.mark.django_db


def error(resp) -> dict:
    return resp.json()["error"]


def body(doc: dict, **changes) -> dict:
    """A publish body from a document as the admin panel has it."""
    out = {
        "expectedVersion": doc["version"],
        "askAgain": False,
        **{k: doc[k] for k in ("titleEn", "titleHi", "titleOr", "bodyEn", "bodyHi", "bodyOr")},
    }
    return {**out, **changes}


def test_the_text_format_is_escaped_and_never_carries_html():
    out = blocks(
        "# Who we are\nLine one\nline two\n\n- **Bold** item\n- <script>alert(1)</script>\n"
        "After the list\n\n<b>not bold</b>"
    )
    assert [b.kind for b in out] == ["h", "p", "ul", "p", "p"]
    assert out[1].items == ("Line one line two",)
    assert out[2].items[0] == "<strong>Bold</strong> item"
    assert out[2].items[1] == "&lt;script&gt;alert(1)&lt;/script&gt;"
    assert out[4].items == ("&lt;b&gt;not bold&lt;/b&gt;",)


def test_the_first_drafts_are_public_pages_in_every_language():
    client = Client()
    for slug, title in [
        ("terms", "Terms of Use"),
        ("privacy", "Privacy Policy"),
        ("refunds", "Refund Policy"),
        ("partner-terms", "Partner Terms"),
    ]:
        resp = client.get(f"/legal/{slug}")
        assert resp.status_code == 200
        html = resp.content.decode()
        assert f"<h1>{title}</h1>" in html
        assert "script-src" not in resp["Content-Security-Policy"]  # no script may run
        assert "default-src 'none'" in resp["Content-Security-Policy"]
    # Hindi asked, not written yet: the English text with a note in Hindi
    html = client.get("/legal/privacy?l=hi").content.decode()
    assert "अंग्रेज़ी में दिखाया गया है" in html and "<h1>Privacy Policy</h1>" in html
    # the browser's language when there's no ?l=
    odia = client.get("/legal/terms", HTTP_ACCEPT_LANGUAGE="or-IN,or;q=0.9,en;q=0.8")
    assert "ସଂସ୍କରଣ 1" in odia.content.decode()
    assert client.get("/legal/cookies").status_code == 404


def test_app_config_links_the_pages(api, settings):
    links = api.get("/public/app-config").json()["legalUrls"]
    assert links["privacy"] == "http://testserver/legal/privacy"
    assert links["deleteAccount"] == "http://testserver/delete-account"
    settings.PUBLIC_SITE_URL = "https://wellwish.in/"
    links = api.get("/public/app-config").json()["legalUrls"]
    assert links["partnerTerms"] == "https://wellwish.in/legal/partner-terms"


def test_only_super_admins_manage_the_legal_pages(api, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/legal", ops).status_code == 403
    assert api.get("/admin/legal/PRIVACY", ops).status_code == 403
    token = staff_token(api, staff_roles)
    listed = api.get("/admin/legal", token).json()
    assert [d["kind"] for d in listed] == ["TERMS", "PRIVACY", "REFUNDS", "PARTNER_TERMS"]
    assert listed[1]["version"] == 1 and listed[1]["languages"] == ["en"]
    assert listed[1]["publishedBy"] is None  # the first drafts


def test_a_small_fix_asks_nobody_and_ask_again_changes_the_consent_version(api, staff_roles):
    token = staff_token(api, staff_roles)
    doc = api.get("/admin/legal/PRIVACY", token).json()
    assert doc["consentVersion"] == "2026-10" and doc["isNewest"]

    fixed = api.post(
        "/admin/legal/PRIVACY",
        body(
            doc,
            bodyEn=doc["bodyEn"] + "\n\nOne more line.",
            titleHi="गोपनीयता नीति",
            bodyHi="# हम कौन हैं\nWellWish …",
        ),
        token,
    )
    assert fixed.status_code == 200, fixed.json()
    fixed = fixed.json()
    assert fixed["version"] == 2 and fixed["consentVersion"] == "2026-10"  # nobody asked
    assert not fixed["askedAgain"]
    audit = AuditLog.objects.get(action="legal.published")
    assert audit.after == {
        "version": 2,
        "askedAgain": False,
        "changed": ["title_hi", "body_en", "body_hi"],
    }

    again = api.post(
        "/admin/legal/PRIVACY", body(fixed, titleEn="Privacy Notice", askAgain=True), token
    )
    assert again.status_code == 200
    assert again.json()["version"] == 3 and again.json()["consentVersion"] == "3"

    # the public page shows the newest version, in Hindi now that it is written
    html = Client().get("/legal/privacy?l=hi").content.decode()
    assert "<h1>गोपनीयता नीति</h1>" in html and "दिखाया गया है" not in html
    assert "<h1>Privacy Notice</h1>" in Client().get("/legal/privacy").content.decode()

    # history and an old version, read-only
    versions = api.get("/admin/legal/PRIVACY/versions", token).json()
    assert [(v["version"], v["askedAgain"]) for v in versions] == [(3, True), (2, False), (1, True)]
    assert versions[0]["publishedBy"] == "Test Admin"
    old = api.get("/admin/legal/PRIVACY/versions/1", token).json()
    assert old["titleEn"] == "Privacy Policy" and not old["isNewest"]
    assert api.get("/admin/legal/PRIVACY/versions/9", token).status_code == 404


def test_publishing_refuses_stale_unchanged_or_half_written_texts(api, staff_roles):
    token = staff_token(api, staff_roles)
    doc = api.get("/admin/legal/TERMS", token).json()
    same = api.post("/admin/legal/TERMS", body(doc), token)
    assert same.status_code == 422 and error(same)["code"] == "NOTHING_CHANGED"
    half = api.post("/admin/legal/TERMS", body(doc, titleOr="ବ୍ୟବହାର ସର୍ତ୍ତାବଳୀ"), token)
    assert half.status_code == 422 and error(half)["code"] == "INCOMPLETE_LANGUAGE"
    blank = api.post("/admin/legal/TERMS", body(doc, titleEn="   "), token)
    assert blank.status_code == 422
    assert api.post("/admin/legal/TERMS", body(doc, bodyEn="New terms."), token).status_code == 200
    # someone else published meanwhile: the old edit is refused, nothing is lost
    stale = api.post("/admin/legal/TERMS", body(doc, bodyEn="My edit."), token)
    assert stale.status_code == 409 and error(stale)["code"] == "LEGAL_VERSION_CHANGED"
    assert LegalDocument.objects.filter(kind="TERMS").count() == 2
    unknown = api.post("/admin/legal/COOKIES", body(doc), token)
    assert unknown.status_code == 422
