"""Service catalogue: admin CRUD, prices in paise, audit of price changes, public list (§6.6)."""

import pytest

from apps.audit.models import AuditLog
from apps.services.models import Service
from apps.services.seed import SAMPLE_SERVICES, seed_services
from common import usage
from conftest import staff_token

pytestmark = pytest.mark.django_db

NEW = {
    "name": "Doctor visit companion",
    "nameHi": "डॉक्टर विज़िट साथी",
    "partnerType": "COMPANION",
    "visitType": "HOSPITAL_VISIT",
    "pricePaise": 50000,
    "bookingFeePaise": 10000,
    "durationMin": 240,
}


@pytest.fixture
def token(api, staff_roles):
    return staff_token(api, staff_roles)


def test_create_shows_the_calculated_balance(api, token):
    resp = api.post("/admin/services", NEW, token)
    assert resp.status_code == 200, resp.json()
    body = resp.json()
    assert body["pricePaise"] == 50000
    assert body["bookingFeePaise"] == 10000
    assert body["balancePaise"] == 40000
    assert body["isActive"] is True
    assert AuditLog.objects.filter(action="service.created", entity_id=body["id"]).exists()


def test_booking_fee_above_price_is_refused(api, token):
    resp = api.post("/admin/services", {**NEW, "bookingFeePaise": 60000}, token)
    assert resp.status_code == 422
    assert Service.objects.count() == 0


def test_balance_cannot_be_typed(api, token):
    resp = api.post("/admin/services", {**NEW, "balancePaise": 1}, token)
    assert resp.status_code == 422  # unknown field


def test_price_change_is_audited_with_before_and_after(api, token):
    created = api.post("/admin/services", NEW, token).json()
    resp = api.put(f"/admin/services/{created['id']}", {**NEW, "pricePaise": 60000}, token)
    assert resp.status_code == 200
    assert resp.json()["balancePaise"] == 50000
    row = AuditLog.objects.get(action="service.price_changed", entity_id=created["id"])
    assert row.before == {"price_paise": 50000}
    assert row.after == {"price_paise": 60000}
    assert row.staff is not None


def test_other_changes_are_audited_as_updates(api, token):
    created = api.post("/admin/services", NEW, token).json()
    api.put(f"/admin/services/{created['id']}", {**NEW, "durationMin": 180}, token)
    row = AuditLog.objects.get(action="service.updated", entity_id=created["id"])
    assert row.before == {"duration_min": 240}
    assert row.after == {"duration_min": 180}


def test_deactivated_service_is_hidden_from_the_apps(api, token):
    created = api.post("/admin/services", NEW, token).json()
    resp = api.post(f"/admin/services/{created['id']}/deactivate", token=token)
    assert resp.json()["isActive"] is False
    assert api.get("/public/services").json() == []
    assert len(api.get("/admin/services", token).json()) == 1
    api.post(f"/admin/services/{created['id']}/activate", token=token)
    assert len(api.get("/public/services").json()) == 1


def test_unused_service_can_be_deleted(api, token):
    created = api.post("/admin/services", NEW, token).json()
    assert api.delete(f"/admin/services/{created['id']}", token).status_code == 200
    assert not Service.objects.exists()
    assert AuditLog.objects.filter(action="service.deleted").exists()


def test_used_service_cannot_be_deleted(api, token, monkeypatch):
    created = api.post("/admin/services", NEW, token).json()
    monkeypatch.setitem(usage._checks, "service", [lambda service_id: True])
    resp = api.delete(f"/admin/services/{created['id']}", token)
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "IN_USE"
    assert Service.objects.filter(pk=created["id"]).exists()


def test_reorder(api, token):
    a = api.post("/admin/services", NEW, token).json()
    b = api.post("/admin/services", {**NEW, "name": "Medicine pickup"}, token).json()
    assert (
        api.post("/admin/services/reorder", {"ids": [b["id"], a["id"]]}, token).status_code == 200
    )
    names = [s["name"] for s in api.get("/public/services").json()]
    assert names == ["Medicine pickup", "Doctor visit companion"]


def test_unknown_id_is_404(api, token):
    missing = "00000000-0000-0000-0000-000000000000"
    assert api.put(f"/admin/services/{missing}", NEW, token).status_code == 404


def test_public_list_has_the_seeded_prices_and_balance(api):
    seed_services()
    seed_services()  # safe to run twice
    body = api.get("/public/services").json()
    assert len(body) == len(SAMPLE_SERVICES)
    first = body[0]
    assert first["name"] == "Doctor visit companion"
    assert (first["pricePaise"], first["bookingFeePaise"], first["balancePaise"]) == (
        50000,
        10000,
        40000,
    )
    shift = next(s for s in body if s["name"] == "12-hour nursing shift")
    assert shift["balancePaise"] == 130000
    nurses = api.get("/public/services?partnerType=NURSE").json()
    assert {s["partnerType"] for s in nurses} == {"NURSE"}
    assert len(nurses) == 4


def test_permissions(api, staff_roles):
    support = staff_token(api, staff_roles, "SUPPORT")  # services.view only
    assert api.get("/admin/services", support).status_code == 200
    assert api.post("/admin/services", NEW, support).status_code == 403
    finance = staff_token(api, staff_roles, "FINANCE")  # services.manage
    assert api.post("/admin/services", NEW, finance).status_code == 200
    verification = staff_token(api, staff_roles, "VERIFICATION")
    assert api.get("/admin/services", verification).status_code == 403
