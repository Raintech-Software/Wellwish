"""The account deletion page `/delete-account` (ARCHITECTURE §6.20, PHASES 9B.4): no login, an
SMS code proves the number; the same rules as the apps."""

import re

import pytest
from django.test import Client

from apps.assignments.tests.test_assignments import accepted
from apps.partners.models import PartnerDeletion, PartnerProfile
from apps.partners.tests.test_account_deletion import patient_login
from apps.patients.models import AccountDeletion
from common.sms import read_dev_outbox as read_sms

pytestmark = pytest.mark.django_db

ASHA = "+919811100001"


class Page:
    """A browser on the page: keeps the CSRF cookie and posts the forms it was shown."""

    def __init__(self, language: str = "") -> None:
        self.client = Client(enforce_csrf_checks=True)
        self.url = "/delete-account" + (f"?l={language}" if language else "")
        self.html = self.client.get(self.url).content.decode()

    def field(self, name: str) -> str:
        found = re.search(rf'name="{name}" value="([^"]*)"', self.html)
        assert found, f"no {name} in the page"
        return found.group(1)

    def post(self, **data: str) -> str:
        token = self.field("csrfmiddlewaretoken")
        resp = self.client.post(self.url, {"csrfmiddlewaretoken": token, **data})
        assert resp.status_code == 200
        self.html = resp.content.decode()
        return self.html

    def verify(self, phone: str) -> str:
        self.post(step="send", phone=phone[3:])
        code = re.findall(r"[0-9]{6}", read_sms(phone)[-1]["text"])[0]
        return self.post(step="verify", ticket=self.field("ticket"), code=code)

    def delete(self, which: str, sure: bool = True) -> str:
        verified = self.field("verified")
        extra = {"sure": "1"} if sure else {}
        return self.post(step="delete", verified=verified, which=which, **extra)


def test_a_partner_and_patient_deletes_both_accounts_with_an_sms_code(api, asha):
    _, partner_id = asha
    patient_login(api, ASHA)
    page = Page()
    assert 'name="phone"' in page.html
    assert "default-src 'none'" in page.client.get("/delete-account")["Content-Security-Policy"]
    html = page.verify(ASHA)
    assert "WellWish (patients and families)" in html
    assert "WellWish Partner (companions and nurses)" in html

    # the tick is required (also without the browser's check)
    page.delete("partner", sure=False)
    assert PartnerProfile.objects.get(pk=partner_id).status == "APPROVED"

    html = page.delete("partner")
    assert PartnerProfile.objects.get(pk=partner_id).status == "APPROVED"  # waits, status kept
    deletion = PartnerDeletion.objects.get(user_id=partner_id)
    assert deletion.source == "WEB"
    assert "Deletion requested" in html

    page.delete("patient")
    patient_deletion = AccountDeletion.objects.get(user_id=partner_id)
    assert (patient_deletion.status, patient_deletion.source) == ("PENDING", "WEB")
    assert api.get("/patient/me", token=None).status_code == 401


def test_wrong_codes_expired_pages_and_unknown_numbers(api):
    page = Page("hi")
    page.post(step="send", phone="12345")
    assert "10 अंकों का भारतीय मोबाइल नंबर डालें।" in page.html  # in the page's language
    page.post(step="send", phone="98111 00099")
    html = page.post(step="verify", ticket=page.field("ticket"), code="000000")
    assert "यह कोड सही नहीं है" in html
    html = page.post(step="verify", ticket="tampered", code="123456")
    assert "इस पेज की समय-सीमा ख़त्म हो गई है" in html
    # a number nobody uses: the page says so only after the code
    other = Page()
    html = other.verify("+919811100098")
    assert "No WellWish account uses this number." in html


def test_the_page_keeps_the_apps_rules(api, asha, booking, staff_roles):
    accepted(api, booking, asha, staff_roles)
    page = Page("or")
    page.verify(ASHA)
    html = page.delete("partner")
    assert "ଗ୍ରହଣ କରାଯାଇଥିବା ବା ଚାଲିଥିବା କାମ" in html  # ACTIVE_JOBS, in Odia
    assert PartnerProfile.objects.get(user__phone=ASHA).status == "APPROVED"


def test_a_form_without_the_csrf_token_is_refused():
    client = Client(enforce_csrf_checks=True)
    resp = client.post("/delete-account", {"step": "send", "phone": "9811100001"})
    assert resp.status_code == 403
