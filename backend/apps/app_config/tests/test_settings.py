"""Settings page, service areas and blocked dates (§6.12, §6.17, §9.1, §11)."""

from datetime import UTC, datetime, timedelta

import pytest

from apps.app_config import services as config_services
from apps.app_config.models import AppSetting, ServiceArea
from apps.app_config.registry import SETTINGS
from apps.app_config.seed import seed_app_config
from apps.app_config.selectors import get_setting, is_blocked, is_inside_service_area
from apps.audit.models import AuditLog
from conftest import staff_token

pytestmark = pytest.mark.django_db

AREA = {
    "city": "Bhubaneswar",
    "name": "Bhubaneswar city",
    "lat": "20.296100",
    "lng": "85.824500",
    "radiusKm": "25.0",
}


@pytest.fixture
def token(api, staff_roles):
    return staff_token(api, staff_roles)


def all_settings(body: dict) -> dict[str, dict]:
    return {s["key"]: s for g in body["groups"] for s in g["settings"]}


# --- Settings ---


def test_every_setting_is_listed_with_its_default(api, token):
    resp = api.get("/admin/settings", token)
    assert resp.status_code == 200
    listed = all_settings(resp.json())
    assert set(listed) == {s.key for s in SETTINGS}
    assert listed["refund_percent"]["value"] == "50"
    assert listed["refund_percent"]["kind"] == "int"
    assert listed["time_step_min"]["choices"] == ["15", "30", "60"]


def test_update_validates_saves_and_audits(api, token):
    resp = api.put(
        "/admin/settings",
        {"values": {"refund_percent": "60", "service_hours_start": "08:00"}},
        token,
    )
    assert resp.status_code == 200, resp.json()
    listed = all_settings(resp.json())
    assert listed["refund_percent"]["value"] == "60"
    assert get_setting("refund_percent") == 60  # stored as a number
    assert get_setting("service_hours_start") == "08:00"
    row = AuditLog.objects.get(action="settings.updated")
    assert row.before == {"refund_percent": 50, "service_hours_start": "07:00"}
    assert row.after == {"refund_percent": 60, "service_hours_start": "08:00"}
    # the public app config sees the change at once
    assert api.get("/public/app-config").json()["refundPercent"] == 60


@pytest.mark.parametrize(
    ("key", "value"),
    [
        ("refund_percent", "101"),
        ("refund_percent", "half"),
        ("time_step_min", "20"),
        ("service_hours_end", "25:00"),
        ("support_phone", "12345"),
        ("min_version_patient_android", "v1"),
        ("no_such_setting", "1"),
    ],
)
def test_invalid_values_are_refused_and_nothing_is_saved(api, token, key, value):
    resp = api.put("/admin/settings", {"values": {"refund_percent": "70", key: value}}, token)
    assert resp.status_code == 422
    error = resp.json()["error"]
    assert error["code"] == "INVALID_SETTINGS"
    assert key in error["details"]["fields"]
    assert not AppSetting.objects.exists()


def test_phone_is_normalised(api, token):
    api.put("/admin/settings", {"values": {"support_phone": "98765 43210"}}, token)
    assert get_setting("support_phone") == "+919876543210"


def test_settings_need_settings_manage(api, staff_roles):
    ops = staff_token(api, staff_roles, "OPERATIONS")
    assert api.get("/admin/settings", ops).status_code == 403
    assert api.get("/admin/service-areas", ops).status_code == 403
    assert api.get("/admin/blocked-times", ops).status_code == 403


def test_seed_saves_the_defaults_and_the_service_area():
    seed_app_config()
    seed_app_config()
    assert AppSetting.objects.count() == len(SETTINGS)
    assert ServiceArea.objects.count() == 1


# --- Service areas ---


def test_service_area_crud(api, token):
    created = api.post("/admin/service-areas", AREA, token)
    assert created.status_code == 200, created.json()
    aid = created.json()["id"]
    assert created.json()["radiusKm"] == "25.0"
    resp = api.put(f"/admin/service-areas/{aid}", {**AREA, "radiusKm": "30"}, token)
    assert resp.json()["radiusKm"] == "30.0"
    row = AuditLog.objects.get(action="service_area.updated")
    assert row.before == {"radius_km": "25.0"}
    assert row.after == {"radius_km": "30.0"}
    assert (
        api.post(f"/admin/service-areas/{aid}/deactivate", token=token).json()["isActive"] is False
    )
    assert api.delete(f"/admin/service-areas/{aid}", token).status_code == 200
    assert not ServiceArea.objects.exists()


def test_inside_service_area(api, token):
    api.post("/admin/service-areas", AREA, token)
    assert is_inside_service_area(20.35, 85.82)  # Patia, about 6 km
    assert is_inside_service_area(20.46, 85.88)  # Cuttack, about 19 km
    assert not is_inside_service_area(19.81, 85.83)  # Puri, about 54 km
    check = api.get("/admin/service-areas/check?lat=19.81&lng=85.83", token)
    assert check.json() == {"inside": False}


def test_inactive_area_does_not_count(api, token):
    aid = api.post("/admin/service-areas", AREA, token).json()["id"]
    api.post(f"/admin/service-areas/{aid}/deactivate", token=token)
    assert not is_inside_service_area(20.2961, 85.8245)


def test_service_area_radius_is_validated(api, token):
    assert api.post("/admin/service-areas", {**AREA, "radiusKm": "0"}, token).status_code == 422
    assert api.post("/admin/service-areas", {**AREA, "lat": "91"}, token).status_code == 422


# --- Blocked times ---


def test_blocked_time_crud_and_is_blocked(api, token):
    start = datetime(2026, 11, 1, 0, 0, tzinfo=UTC)
    body = {
        "fromTs": start.isoformat(),
        "toTs": (start + timedelta(days=1)).isoformat(),
        "reason": "Diwali",
    }
    created = api.post("/admin/blocked-times", body, token)
    assert created.status_code == 200, created.json()
    assert created.json()["affectedBookings"] == []
    assert created.json()["serviceType"] is None
    assert is_blocked(start + timedelta(hours=5))
    assert is_blocked(start + timedelta(hours=5), "NURSE")
    assert not is_blocked(start + timedelta(days=1))  # the end is not included

    bid = created.json()["id"]
    resp = api.put(f"/admin/blocked-times/{bid}", {**body, "serviceType": "NURSE"}, token)
    assert resp.json()["serviceType"] == "NURSE"
    assert is_blocked(start + timedelta(hours=5), "NURSE")
    assert not is_blocked(start + timedelta(hours=5), "COMPANION")

    assert len(api.get("/admin/blocked-times", token).json()) == 1
    assert api.delete(f"/admin/blocked-times/{bid}", token).status_code == 200
    actions = set(AuditLog.objects.values_list("action", flat=True))
    assert {"blocked_time.created", "blocked_time.updated", "blocked_time.deleted"} <= actions


def test_blocked_time_end_must_be_after_start(api, token):
    now = datetime(2026, 11, 1, tzinfo=UTC).isoformat()
    resp = api.post("/admin/blocked-times", {"fromTs": now, "toTs": now, "reason": "Oops"}, token)
    assert resp.status_code == 422
    assert resp.json()["error"]["code"] == "INVALID_RANGE"


def test_saving_a_block_lists_the_affected_bookings(api, token, monkeypatch):
    seen = []

    def finder(start, end, service_type):
        seen.append((start, end, service_type))
        return [{"id": "b1", "code": "WW-1001", "pickup_at": start, "status": "ASSIGNED"}]

    monkeypatch.setattr(config_services, "_affected_finders", [finder])
    start = datetime(2026, 11, 1, tzinfo=UTC)
    resp = api.post(
        "/admin/blocked-times",
        {
            "fromTs": start.isoformat(),
            "toTs": (start + timedelta(hours=4)).isoformat(),
            "reason": "Bandh",
        },
        token,
    )
    assert resp.json()["affectedBookings"][0]["code"] == "WW-1001"
    assert seen == [(start, start + timedelta(hours=4), None)]
