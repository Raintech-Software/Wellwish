"""The account deletion page `/delete-account` (ARCHITECTURE §6.20; Google Play asks for one).

No login: an SMS code proves the number, then the page lists the accounts on it (WellWish,
WellWish Partner) and deletes each with the same rules as the apps. Server-rendered forms with
CSRF protection, no scripts. Between the steps the number travels in a short-lived signed token.
"""

from dataclasses import dataclass
from typing import Any

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.views.decorators.http import require_http_methods

from apps.accounts import services as accounts
from apps.app_config.selectors import get_app_config
from apps.legal.deletion_texts import DELETE_TEXTS
from apps.legal.selectors import DELETE_ACCOUNT_PATH
from apps.legal.views import chrome, page_language, with_headers
from apps.notifications.text import day
from apps.partners import services as partners
from apps.partners.selectors import partner_status_of
from apps.patients import selectors as patient_selectors
from apps.patients import services as patients
from common.errors import ApiError
from common.request import client_ip
from common.tokens import InvalidToken, issue_challenge, read_challenge

PHONE_TICKET = "deletion_page_phone"  # the code was sent to this number
VERIFIED_TICKET = "deletion_page_verified"  # the code was right
PHONE_TICKET_SECONDS = 10 * 60
VERIFIED_TICKET_SECONDS = 15 * 60


@dataclass(frozen=True)
class Account:
    which: str  # "patient", "partner" or "login"
    name: str
    what: str
    status: str = ""  # a message once deletion is requested or done


def _accounts(user_id: str, texts: dict[str, str], days: int, language: str) -> list[Account]:
    out = []
    if patient_selectors.has_profile(user_id):
        pending = patient_selectors.pending_deletion(user_id)
        out.append(
            Account(
                "patient",
                texts["patient_name"],
                texts["patient_what"].format(days=days),
                texts["requested"].format(date=day(pending.due_at)[language]) if pending else "",
            )
        )
    status = partner_status_of(user_id)
    if status not in (None, "DELETED"):
        pending_partner = partners.pending_deletion(user_id)
        out.append(
            Account(
                "partner",
                texts["partner_name"],
                texts["partner_what"].format(days=days),
                texts["requested"].format(date=day(pending_partner.due_at)[language])
                if pending_partner
                else "",
            )
        )
    if not out:  # a login without a profile in either app (e.g. never chose a partner role)
        out.append(Account("login", texts["login_name"], texts["login_what"]))
    return out


def _masked(phone: str) -> str:
    return f"+91 ••••• •{phone[-4:]}"


def _spaced(phone: str) -> str:
    """+919000000000 → +91 90000 00000, as the apps show numbers."""
    if phone.startswith("+91") and len(phone) == 13:
        return f"+91 {phone[3:8]} {phone[8:]}"
    return phone


@require_http_methods(["GET", "POST"])
def delete_account(request: HttpRequest) -> HttpResponse:
    language = page_language(request)
    texts = DELETE_TEXTS[language]
    config = get_app_config()
    context: dict[str, Any] = {
        **chrome(request, language, DELETE_ACCOUNT_PATH),
        "t": texts,
        "action": f"{DELETE_ACCOUNT_PATH}?l={language}",
        "help": texts["help"].format(phone=_spaced(config.support_phone)),
        "step": "phone",
        "message": "",
        "done": "",
    }
    if request.method == "POST":
        _step(request, context, texts, config.account_deletion_days, language)
    return with_headers(render(request, "legal/delete.html", context))


def _step(
    request: HttpRequest, context: dict[str, Any], texts: dict[str, str], days: int, language: str
) -> None:
    step = request.POST.get("step", "")
    try:
        if step == "send":
            context["phone_value"] = request.POST.get("phone", "")[:20]
            phone = accounts.send_deletion_code(
                phone=request.POST.get("phone", ""), ip=client_ip(request)
            )
            context.update(
                step="code",
                code_label=texts["code_label"].format(phone=_masked(phone)),
                ticket=issue_challenge(PHONE_TICKET, {"phone": phone}, PHONE_TICKET_SECONDS),
            )
        elif step == "verify":
            context.update(step="code", ticket=request.POST.get("ticket", ""))
            _, data = read_challenge(request.POST.get("ticket", ""), PHONE_TICKET)
            phone = str(data["phone"])
            context["code_label"] = texts["code_label"].format(phone=_masked(phone))
            user_id = accounts.verify_deletion_code(
                phone=phone, code=request.POST.get("code", "").strip()[:12]
            )
            if user_id is None:
                context.update(step="none")
                return
            verified = issue_challenge(
                VERIFIED_TICKET, {"user_id": user_id, "phone": phone}, VERIFIED_TICKET_SECONDS
            )
            context.update(
                step="accounts",
                verified=verified,
                accounts=_accounts(user_id, texts, days, language),
            )
        elif step == "delete":
            verified = request.POST.get("verified", "")
            _, data = read_challenge(verified, VERIFIED_TICKET)
            user_id = str(data["user_id"])
            context.update(step="accounts", verified=verified)
            try:
                which = request.POST.get("which", "")
                if request.POST.get("sure") != "1":  # the tick is required in the form too
                    which = ""
                if which == "patient" and patient_selectors.has_profile(user_id):
                    patients.request_deletion(user_id=user_id, source="WEB")
                elif which in ("partner", "login"):
                    deletion = partners.request_deletion(user_id=user_id, source="WEB")
                    if deletion.status == deletion.Status.DONE:
                        context["done"] = texts["deleted"]
            finally:
                gone = bool(context["done"])  # deleted at once: nothing left to list
                context["accounts"] = [] if gone else _accounts(user_id, texts, days, language)
    except InvalidToken:
        context.update(step="phone", message=texts["EXPIRED"])
    except ApiError as error:
        context["message"] = texts.get(error.code, texts["ERROR"])
        if step == "send":
            context["step"] = "phone"
