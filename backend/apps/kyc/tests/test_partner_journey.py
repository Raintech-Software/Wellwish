"""A companion's whole journey with no shortcuts (§6.3, §6.10, §9.4): signs up in the Partner
app with a new number, the admin reviews and approves every document, then the new partner is
suggested for a paid booking, gets the offer and accepts it. Other tests set APPROVED directly."""

import pytest

from apps.audit.models import AuditLog
from apps.bookings.models import Booking
from apps.kyc.models import PartnerApplication, PartnerDocument
from apps.partners.models import PartnerProfile
from apps.partners.tests.support import partner_login, register, upload
from common.sms import read_dev_outbox as read_sms
from conftest import staff_token

pytestmark = pytest.mark.django_db

NEW_COMPANION = "+919811100077"  # not a test number: the login code comes from the dev outbox


@pytest.fixture(autouse=True)
def _media(settings, tmp_path):
    settings.FILE_STORAGE = "local"
    settings.MEDIA_ROOT = tmp_path


def test_a_new_companion_signs_up_is_approved_and_takes_a_booking(
    api, world, booking, staff_roles, django_capture_on_commit_callbacks
):
    capture = django_capture_on_commit_callbacks

    # 1. Partner app: login with the SMS code, role, both phones, email, profile, documents
    partner = partner_login(api, NEW_COMPANION, device_id="journey-phone")
    assert api.get("/partner/me", partner).json()["partnerStatus"] is None
    status = register(api, partner, "COMPANION", email="new.companion@example.com")
    assert status["canSubmit"] is True
    assert api.get("/partner/me", partner).json()["partnerStatus"] == "REGISTERED"
    # not approved yet: no jobs, and never suggested to the admin
    assert api.get("/partner/offers", partner).json()["error"]["code"] == "PARTNER_NOT_APPROVED"
    ops = staff_token(api, staff_roles, "OPERATIONS")
    profile = PartnerProfile.objects.get(user__phone=NEW_COMPANION)
    partner_id = str(profile.pk)
    candidates = api.get(f"/admin/bookings/{booking.pk}/candidates", ops).json()
    assert partner_id not in [c["partnerId"] for c in candidates]

    with capture(execute=True):
        sent = api.post("/partner/kyc/submit", token=partner)
    assert sent.status_code == 200, sent.json()
    assert sent.json()["profile"]["status"] == "SUBMITTED"

    # 2. Admin panel (Verification role): the application is in the queue; claim, open and
    #    approve every document, then approve the partner
    reviewer = staff_token(api, staff_roles, "VERIFICATION")
    queue = api.get("/admin/applications", reviewer).json()
    assert [row["fullName"] for row in queue] == ["Asha Behera"]
    application = str(PartnerApplication.objects.get(partner=profile).pk)
    claimed = api.post(f"/admin/applications/{application}/claim", token=reviewer)
    assert claimed.status_code == 200, claimed.json()
    assert api.get("/partner/me", partner).json()["partnerStatus"] == "UNDER_REVIEW"
    documents = PartnerDocument.objects.filter(partner=profile, is_current=True)
    assert {"AADHAAR", "PAN", "SELFIE", "POLICE_VERIFICATION", "ADDRESS_PROOF"} <= {
        d.doc_type for d in documents
    }
    for doc in documents:
        view = api.get(f"/admin/partner-documents/{doc.pk}/view-url", reviewer)
        assert view.status_code == 200, view.json()
        ok = api.post(f"/admin/partner-documents/{doc.pk}/approve", token=reviewer)
        assert ok.status_code == 200, ok.json()
    detail = api.get(f"/admin/applications/{application}", reviewer).json()
    assert detail["canApprove"] is True
    with capture(execute=True):
        approved = api.post(f"/admin/applications/{application}/approve", token=reviewer)
    assert approved.status_code == 200, approved.json()

    # the partner hears about it and the app opens up
    assert api.get("/partner/me", partner).json()["partnerStatus"] == "APPROVED"
    assert any("approved" in m["text"] for m in read_sms(NEW_COMPANION))
    assert AuditLog.objects.filter(action="partner.status_changed", entity_id=partner_id).exists()

    # 3. Partner app: today's selfie, "Available today"
    selfie = api.post(
        "/partner/me/selfie", {"fileKey": upload(api, partner, "partner_selfie")}, partner
    )
    assert selfie.status_code == 200, selfie.json()
    available = api.patch("/partner/me/availability", {"availableToday": True}, partner)
    assert available.json() == {"availableToday": True, "selfieToday": True}

    # 4. Admin (Operations): the new partner is suggested for the paid booking and assigned
    candidates = api.get(f"/admin/bookings/{booking.pk}/candidates", ops).json()
    assert partner_id in [c["partnerId"] for c in candidates]
    with capture(execute=True):
        assigned = api.post(
            f"/admin/bookings/{booking.pk}/assign",
            {"partnerId": partner_id, "expectedAssignmentId": None},
            ops,
        )
    assert assigned.status_code == 200, assigned.json()
    assert assigned.json()["status"] == "OFFERED"

    # 5. Partner app: the offer arrives; accepting opens the full job
    offers = api.get("/partner/offers", partner).json()
    assert len(offers) == 1
    with capture(execute=True):
        accepted = api.post(f"/partner/offers/{offers[0]['assignmentId']}/accept", token=partner)
    assert accepted.status_code == 200, accepted.json()
    assert accepted.json()["status"] == "ACCEPTED"
    assert Booking.objects.get(pk=booking.pk).partner_id is not None

    # 6. Patient app: the family sees their companion
    family = api.get(f"/patient/bookings/{booking.pk}", world.token).json()
    assert family["status"] == "ACCEPTED"
    assert family["partner"]["fullName"] == "Asha Behera"
    assert family["partner"]["phone"] == NEW_COMPANION
