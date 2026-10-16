"""Admin sign-in recovery (§6.4, v2.16, PHASES 8.16): trusted browsers, recovery codes, the
"only Super Admin" warning and the server emergency command."""

import re
import sys
import time
from datetime import timedelta

import pyotp
import pytest
from django.conf import settings as django_settings
from django.core.management import CommandError, call_command
from django.utils import timezone

from apps.audit.models import AuditLog
from apps.staff.models import StaffRecoveryCode, StaffSession, StaffTrustedBrowser
from common.mail import read_dev_outbox
from conftest import STAFF_PASSWORD, Api, make_staff, staff_login

pytestmark = pytest.mark.django_db
CODE = re.compile(r"^[a-z2-9]{4}-[a-z2-9]{4}$")


def next_code(secret: str) -> str:
    """The next 30-second code: the current one was used by the first sign-in (a code works
    once), and the server accepts one step either side."""
    return pyotp.TOTP(secret).at(int(time.time()) + 30)


def code_step(api: Api, email: str) -> dict:
    resp = api.post("/admin/auth/login", {"email": email, "password": STAFF_PASSWORD})
    assert resp.status_code == 200, resp.json()
    return resp.json()


# --- Recovery codes ---


def test_setting_up_2fa_gives_10_recovery_codes_shown_once(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    codes = first.response.json()["recoveryCodes"]
    assert len(codes) == 10 and len(set(codes)) == 10
    assert all(CODE.match(c) for c in codes)
    stored = list(StaffRecoveryCode.objects.values_list("code_hash", flat=True))
    assert len(stored) == 10 and not set(codes) & set(stored)  # only hashes are kept

    me = api.get("/admin/me", first.access_token).json()
    assert me["recoveryCodesLeft"] == 10

    step = code_step(api, first.staff.email)
    again = api.post(
        "/admin/auth/totp",
        {"challengeToken": step["challengeToken"], "code": next_code(first.secret)},
    )
    assert again.json()["recoveryCodes"] is None  # never shown again


def test_a_recovery_code_sets_up_a_new_authenticator(
    api, staff_roles, django_capture_on_commit_callbacks
):
    boss = make_staff(staff_roles, email="boss@wellwish.test")
    staff_login(Api(), boss)
    lost = staff_login(api, make_staff(staff_roles, email="lost@wellwish.test"))
    codes = lost.response.json()["recoveryCodes"]

    step = code_step(api, lost.staff.email)
    assert step["step"] == "TOTP"
    with django_capture_on_commit_callbacks(execute=True):
        resp = api.post(
            "/admin/auth/recovery",
            {"challengeToken": step["challengeToken"], "code": codes[0].upper()},
        )
    assert resp.status_code == 200, resp.json()
    setup = resp.json()
    assert setup["step"] == "TOTP_SETUP"
    assert setup["secret"] and setup["secret"] != lost.secret
    # the old phone and the old sessions stop working
    assert not StaffSession.objects.filter(staff=lost.staff, revoked_at__isnull=True).exists()
    assert AuditLog.objects.filter(action="staff.recovery_code_used", staff=lost.staff).exists()
    # the admin and the other Super Admin are told
    assert "recovery code" in read_dev_outbox("lost@wellwish.test")[-1]["text"]
    assert "recovery code" in read_dev_outbox("boss@wellwish.test")[-1]["text"]

    done = api.post(
        "/admin/auth/totp",
        {"challengeToken": setup["challengeToken"], "code": pyotp.TOTP(setup["secret"]).now()},
    )
    assert done.status_code == 200
    fresh = done.json()["recoveryCodes"]
    assert len(fresh) == 10 and not set(fresh) & set(codes)

    # the used code and the old ones no longer work
    step = code_step(api, lost.staff.email)
    for old in (codes[0], codes[1]):
        bad = api.post(
            "/admin/auth/recovery", {"challengeToken": step["challengeToken"], "code": old}
        )
        assert bad.status_code == 401
        assert bad.json()["error"]["code"] == "RECOVERY_CODE_INVALID"


def test_after_a_recovery_code_the_password_alone_never_signs_in(
    api, staff_roles, django_capture_on_commit_callbacks
):
    """Deep check 12 Oct: the new secret lives only in the setup challenge. Someone with the
    password can't take over the half-done setup, and a setup left half-done doesn't leave the
    account password-only."""
    lost = staff_login(api, make_staff(staff_roles, email="lost@wellwish.test"))
    codes = lost.response.json()["recoveryCodes"]
    step = code_step(api, lost.staff.email)
    with django_capture_on_commit_callbacks(execute=True):
        setup = api.post(
            "/admin/auth/recovery", {"challengeToken": step["challengeToken"], "code": codes[0]}
        ).json()
    assert setup["step"] == "TOTP_SETUP"

    # meanwhile, someone with the password: only the code step, never the new QR code
    other = code_step(Api(), lost.staff.email)
    assert other["step"] == "TOTP" and not other.get("secret")
    # and the old phone's codes no longer work
    old = Api().post(
        "/admin/auth/totp",
        {"challengeToken": other["challengeToken"], "code": next_code(lost.secret)},
    )
    assert old.status_code == 401 and old.json()["error"]["code"] == "TOTP_INVALID"

    # the setup left half-done: still the code step, and another recovery code starts again
    again = code_step(api, lost.staff.email)
    assert again["step"] == "TOTP"
    with django_capture_on_commit_callbacks(execute=True):
        second = api.post(
            "/admin/auth/recovery", {"challengeToken": again["challengeToken"], "code": codes[1]}
        ).json()
    assert second["step"] == "TOTP_SETUP" and second["secret"] != setup["secret"]
    done = api.post(
        "/admin/auth/totp",
        {"challengeToken": second["challengeToken"], "code": pyotp.TOTP(second["secret"]).now()},
    )
    assert done.status_code == 200, done.json()
    assert len(done.json()["recoveryCodes"]) == 10


def test_sign_ins_that_skip_the_code_are_told_apart_in_the_audit_log(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    trust(api, first)
    trusted = AuditLog.objects.get(action="staff.browser_trusted")
    assert trusted.after is not None
    browser_id = trusted.after["trusted_browser"]
    assert StaffTrustedBrowser.objects.filter(pk=browser_id).exists()
    assert code_step(api, first.staff.email)["step"] == "SIGNED_IN"
    last = AuditLog.objects.filter(action="staff.login").order_by("-at", "-id").first()
    assert last is not None and last.after == {"via_trusted_browser": browser_id}


def test_the_server_command_asks_for_a_password_only_in_a_terminal(api, staff_roles, monkeypatch):
    make_staff(staff_roles, email="only@wellwish.test")
    monkeypatch.setattr(sys.stdin, "isatty", lambda: False)
    with pytest.raises(CommandError, match="needs a terminal"):
        call_command("reset_staff_2fa", email="only@wellwish.test", new_password=True)


def test_wrong_recovery_codes_count_like_wrong_2fa_codes(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    step = code_step(api, first.staff.email)
    for _ in range(django_settings.STAFF_TOTP_MAX_FAILURES - 1):
        bad = api.post(
            "/admin/auth/recovery", {"challengeToken": step["challengeToken"], "code": "aaaa-bbbb"}
        )
        assert bad.status_code == 401
    locked = api.post(
        "/admin/auth/recovery", {"challengeToken": step["challengeToken"], "code": "aaaa-bbbb"}
    )
    assert locked.status_code == 429
    assert locked.json()["error"]["code"] == "LOGIN_LOCKED"


def test_a_recovery_code_doesnt_replace_the_first_setup(api, staff_roles):
    staff = make_staff(staff_roles)
    step = code_step(api, staff.email)
    assert step["step"] == "TOTP_SETUP"
    resp = api.post(
        "/admin/auth/recovery", {"challengeToken": step["challengeToken"], "code": "aaaa-bbbb"}
    )
    assert resp.status_code == 401
    assert resp.json()["error"]["code"] == "LOGIN_EXPIRED"


def test_codes_count_as_saved_only_after_the_admin_says_so(api, staff_roles):
    """Deep check 12 Oct: a page reloaded on the codes screen signed in with codes nobody saw.
    Now `/me` says they weren't saved until "I've saved them", and the panel warns."""
    first = staff_login(api, make_staff(staff_roles))
    me = api.get("/admin/me", first.access_token).json()
    assert me["recoveryCodesLeft"] == 10 and me["recoveryCodesSaved"] is False
    saved = api.post("/admin/me/recovery-codes/saved", token=first.access_token)
    assert saved.status_code == 200, saved.json()
    assert saved.json()["recoveryCodesSaved"] is True
    assert AuditLog.objects.filter(action="staff.recovery_codes_saved").count() == 1
    # new codes: not saved again until confirmed
    api.post("/admin/me/recovery-codes", {"password": STAFF_PASSWORD}, first.access_token)
    assert api.get("/admin/me", first.access_token).json()["recoveryCodesSaved"] is False


def test_new_recovery_codes_need_the_password(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    old = first.response.json()["recoveryCodes"]
    wrong = api.post(
        "/admin/me/recovery-codes", {"password": "not-my-password"}, first.access_token
    )
    assert wrong.status_code == 422
    assert wrong.json()["error"]["code"] == "WRONG_PASSWORD"

    resp = api.post("/admin/me/recovery-codes", {"password": STAFF_PASSWORD}, first.access_token)
    assert resp.status_code == 200
    new = resp.json()["codes"]
    assert len(new) == 10 and not set(new) & set(old)
    assert StaffRecoveryCode.objects.filter(staff=first.staff).count() == 10


def test_a_super_admin_reset_clears_the_recovery_codes(api, staff_roles):
    boss = staff_login(api, make_staff(staff_roles, email="boss@wellwish.test"))
    other = staff_login(Api(), make_staff(staff_roles, "OPERATIONS"))
    assert StaffRecoveryCode.objects.filter(staff=other.staff).count() == 10
    resp = api.post(f"/admin/staff-users/{other.staff.pk}/reset-2fa", token=boss.access_token)
    assert resp.status_code == 200
    assert not StaffRecoveryCode.objects.filter(staff=other.staff).exists()


# --- An emailed code instead of the authenticator (v2.18) ---


def emailed_code(email: str) -> str:
    return re.findall(r"\b(\d{6})\b", read_dev_outbox(email)[-1]["text"])[0]


def test_an_emailed_code_signs_in_without_the_phone(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles, email="asha.admin@wellwish.test"))
    step = code_step(api, first.staff.email)
    sent = api.post("/admin/auth/email-code", {"challengeToken": step["challengeToken"]})
    assert sent.status_code == 200, sent.json()
    body = sent.json()
    assert body["emailMasked"] == "a•••@wellwish.test"
    assert body["resendAfterSeconds"] == 30
    mail = read_dev_outbox("asha.admin@wellwish.test")[-1]
    assert mail["subject"] == "WellWish Admin sign-in code"
    code = emailed_code("asha.admin@wellwish.test")
    assert code not in str(AuditLog.objects.get(action="staff.email_code_sent").after)  # never kept

    # the step the code was sent with replaces the old one
    old = api.post("/admin/auth/totp", {"challengeToken": step["challengeToken"], "code": code})
    assert old.json()["error"]["code"] == "LOGIN_EXPIRED"
    done = api.post("/admin/auth/totp", {"challengeToken": body["challengeToken"], "code": code})
    assert done.status_code == 200, done.json()
    last = AuditLog.objects.filter(action="staff.login").order_by("-at", "-id").first()
    assert last is not None and last.after == {"email_code": True}
    # once only
    again = api.post("/admin/auth/totp", {"challengeToken": body["challengeToken"], "code": code})
    assert again.json()["error"]["code"] == "LOGIN_EXPIRED"


def test_the_authenticator_still_works_after_asking_for_an_emailed_code(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    step = code_step(api, first.staff.email)
    sent = api.post("/admin/auth/email-code", {"challengeToken": step["challengeToken"]}).json()
    resp = api.post(
        "/admin/auth/totp",
        {"challengeToken": sent["challengeToken"], "code": next_code(first.secret)},
    )
    assert resp.status_code == 200, resp.json()


def test_emailed_codes_wait_between_sends_and_wrong_ones_count(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    step = code_step(api, first.staff.email)
    sent = api.post("/admin/auth/email-code", {"challengeToken": step["challengeToken"]}).json()
    soon = api.post("/admin/auth/email-code", {"challengeToken": sent["challengeToken"]})
    assert soon.status_code == 429
    assert soon.json()["error"]["code"] == "EMAIL_CODE_TOO_SOON"
    assert 0 < soon.json()["error"]["details"]["retryAfterSeconds"] <= 30
    code = emailed_code(first.staff.email)
    wrong = "000000" if code != "000000" else "111111"
    for _ in range(django_settings.STAFF_TOTP_MAX_FAILURES - 1):
        bad = api.post(
            "/admin/auth/totp", {"challengeToken": sent["challengeToken"], "code": wrong}
        )
        assert bad.json()["error"]["code"] == "TOTP_INVALID"
    locked = api.post("/admin/auth/totp", {"challengeToken": sent["challengeToken"], "code": wrong})
    assert locked.status_code == 429
    # locked: even the right code waits
    right = api.post("/admin/auth/totp", {"challengeToken": sent["challengeToken"], "code": code})
    assert right.json()["error"]["code"] == "LOGIN_LOCKED"


def test_at_most_5_emailed_codes_an_hour(api, staff_roles):
    from django.core.cache import cache

    first = staff_login(api, make_staff(staff_roles))
    cache.set(f"staff:email-code-sends:{first.staff.pk}", {"count": 5, "last": 0.0}, 3600)
    step = code_step(api, first.staff.email)
    resp = api.post("/admin/auth/email-code", {"challengeToken": step["challengeToken"]})
    assert resp.status_code == 429
    assert resp.json()["error"]["code"] == "EMAIL_CODE_RATE_LIMITED"


def test_no_emailed_code_before_2fa_is_set_up(api, staff_roles):
    staff = make_staff(staff_roles)
    step = code_step(api, staff.email)
    assert step["step"] == "TOTP_SETUP"
    resp = api.post("/admin/auth/email-code", {"challengeToken": step["challengeToken"]})
    assert resp.status_code == 401
    assert resp.json()["error"]["code"] == "LOGIN_EXPIRED"
    assert not read_dev_outbox(staff.email)


# --- Trust this browser for 30 days ---


def trust(api: Api, first) -> None:
    step = code_step(api, first.staff.email)
    resp = api.post(
        "/admin/auth/totp",
        {
            "challengeToken": step["challengeToken"],
            "code": next_code(first.secret),
            "trustBrowser": True,
        },
    )
    assert resp.status_code == 200, resp.json()
    cookie = resp.cookies[django_settings.STAFF_TRUST_COOKIE]
    assert cookie["httponly"]
    assert cookie["path"] == "/v1/admin/auth"
    assert cookie["samesite"] == "Strict"


def test_a_trusted_browser_needs_only_the_password(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    trust(api, first)

    step = code_step(api, first.staff.email)
    assert step["step"] == "SIGNED_IN"
    assert step["signedIn"]["accessToken"]
    assert step["signedIn"]["staff"]["email"] == first.staff.email
    # a wrong password is still refused
    wrong = api.post("/admin/auth/login", {"email": first.staff.email, "password": "nope-nope"})
    assert wrong.status_code == 401
    # another browser still needs the code
    assert code_step(Api(), first.staff.email)["step"] == "TOTP"


def test_trust_ends_after_30_days(api, staff_roles):
    first = staff_login(api, make_staff(staff_roles))
    trust(api, first)
    StaffTrustedBrowser.objects.update(expires_at=timezone.now() - timedelta(seconds=1))
    assert code_step(api, first.staff.email)["step"] == "TOTP"


@pytest.mark.parametrize("action", ["reset-2fa", "logout", "disable", "password"])
def test_trust_is_forgotten_when_an_admin_steps_in(api, staff_roles, action):
    boss = staff_login(Api(), make_staff(staff_roles, email="boss@wellwish.test"))
    first = staff_login(api, make_staff(staff_roles, "OPERATIONS"))
    trust(api, first)
    path = f"/admin/staff-users/{first.staff.pk}/{action}"
    body = {"password": "A-brand-new-password-2026"} if action == "password" else None
    resp = Api().post(path, body, boss.access_token)
    assert resp.status_code == 200, resp.json()
    assert not StaffTrustedBrowser.objects.filter(staff=first.staff).exists()


# --- Only one Super Admin; the server command ---


def test_the_only_super_admin_is_warned(api, staff_roles):
    boss = staff_login(api, make_staff(staff_roles, email="boss@wellwish.test"))
    assert api.get("/admin/me", boss.access_token).json()["onlySuperAdmin"] is True
    ops = staff_login(Api(), make_staff(staff_roles, "OPERATIONS"))
    assert api.get("/admin/me", ops.access_token).json()["onlySuperAdmin"] is False
    make_staff(staff_roles, email="second@wellwish.test")
    assert api.get("/admin/me", boss.access_token).json()["onlySuperAdmin"] is False


def test_the_server_command_resets_a_locked_out_admin(
    api, staff_roles, monkeypatch, django_capture_on_commit_callbacks
):
    first = staff_login(api, make_staff(staff_roles, email="only@wellwish.test"))
    trust(api, first)
    monkeypatch.setattr("getpass.getpass", lambda prompt="": "A-brand-new-password-2026")
    monkeypatch.setattr(sys.stdin, "isatty", lambda: True)  # run in a terminal
    with django_capture_on_commit_callbacks(execute=True):
        call_command("reset_staff_2fa", email="ONLY@wellwish.test", new_password=True)

    staff = first.staff
    staff.refresh_from_db()
    assert staff.totp_confirmed_at is None and staff.totp_secret_enc == ""
    assert staff.check_password("A-brand-new-password-2026")
    assert not StaffRecoveryCode.objects.filter(staff=staff).exists()
    assert not StaffTrustedBrowser.objects.filter(staff=staff).exists()
    assert not StaffSession.objects.filter(staff=staff, revoked_at__isnull=True).exists()
    row = AuditLog.objects.get(action="staff.emergency_reset")
    assert row.staff_id is None  # done by the system
    assert "reset on the server" in read_dev_outbox("only@wellwish.test")[-1]["text"]
    # the next sign-in shows a new QR code
    login = {"email": "only@wellwish.test", "password": "A-brand-new-password-2026"}
    step = Api().post("/admin/auth/login", login).json()
    assert step["step"] == "TOTP_SETUP"
