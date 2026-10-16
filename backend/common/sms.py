"""Sending SMS (ARCHITECTURE §3.2): MSG91 with DLT-registered templates.

Every SMS is a template code plus variables, e.g. `send_sms(phone, "LOGIN_OTP", {...})`.
Indian rules (DLT) only allow registered templates, so free text can't be sent.

- `ConsoleSMSBackend` (dev and tests): nothing leaves the PC. Messages go to a short-lived
  dev outbox in the cache, readable with `ww.ps1 manage sms_outbox <phone>` or in the admin
  panel (Settings → Test messages, local development only). The log line never contains the
  message text, so OTPs never reach the logs.
- `MSG91SMSBackend` (staging/prod): MSG91 Flow API.

Never log the variables or the full phone number.
"""

import logging
from typing import Any, Protocol

import requests
from django.conf import settings
from django.core.cache import cache
from django.utils import timezone
from django.utils.module_loading import import_string

from common.phone import mask_phone

logger = logging.getLogger(__name__)

# Texts as registered on DLT. `{#var#}` placeholders are filled from the variables.
TEMPLATES: dict[str, str] = {
    "LOGIN_OTP": (
        "<#> {otp} is your WellWish verification code. It expires in 5 minutes. "
        "Do not share it with anyone. {app_hash}"
    ),
    "PARTNER_ADDED": (
        "Welcome to WellWish, {name}. You are now a WellWish partner. Install the partner app "
        "and log in with this number: {link}"
    ),
    "PARTNER_APPROVED": (
        "Congratulations {name}, your WellWish partner account is approved. "
        "Open the WellWish Partner app to start."
    ),
    "PARTNER_CHANGES_REQUESTED": (
        "Some documents in your WellWish partner application need a change. Open the WellWish "
        "Partner app to see why and upload them again."
    ),
    "PARTNER_SUSPENDED": (
        "Your WellWish partner account is paused: {reason}. Please call WellWish support on "
        "{support}."
    ),
    "PARTNER_REINSTATED": "Your WellWish partner account is active again. Thank you.",
    "DOCUMENT_EXPIRED": (
        "Your {document} has expired. Upload a new one in the WellWish Partner app to keep "
        "getting jobs."
    ),
    # To the family member's own phone (§6.18), when a phone is saved for them.
    "BOOKING_CONFIRMED": (
        "WellWish: {service} for {name} on {when} is booked (ref {code}). We will send the "
        "partner's name and phone soon."
    ),
    "BOOKING_CANCELLED": "WellWish: booking {code} for {name} on {when} is cancelled.",
    "BOOKING_RESCHEDULED": "WellWish: booking {code} for {name} is moved to {when}.",
    "BOOKING_ASSIGNED": (
        "WellWish: {partner} ({partner_phone}) will help {name} on {when} (ref {code})."
    ),
    "BOOKING_REMINDER": "WellWish reminder: {service} for {name} on {when} (ref {code}).",
    # To partners (§6.10: offers go by push and SMS)
    "OFFER_NEW": (
        "WellWish: new booking {code} on {when}. Open the WellWish Partner app to accept or "
        "decline."
    ),
    "OFFER_TIME_CHANGED": (
        "WellWish: booking {code} is now on {when}. Please confirm the new time in the Partner app."
    ),
    "JOB_CANCELLED": "WellWish: booking {code} on {when} is cancelled. You don't need to go.",
    # The visit (Phase 8): the job OTP to the family member's own phone (§6.11)
    "JOB_OTP": (
        "WellWish visit code for {name}: {otp}. Give it to {partner} only when they arrive "
        "(ref {code})."
    ),
    # SOS (§6.15): to the emergency contacts of whoever pressed it
    "SOS_ALERT": (
        "WellWish SOS: {who} pressed SOS during visit {code}. Location: {map}. "
        "Please call them now, or 112."
    ),
    # §13: an SOS nobody acknowledged within 2 minutes, to WellWish's own support phone
    "SOS_UNACKED": (
        "WellWish: SOS on visit {code} not acknowledged for 2 minutes. Open the admin panel "
        "Live page and call now."
    ),
    # Temporary partner (§6.19): the person the admin phoned, with the app to install
    "TEMP_PARTNER_JOB": (
        "WellWish: {name}, your WellWish job {code} is on {when}. Install the WellWish Partner "
        "app and log in with this number: {link}"
    ),
}

DEV_OUTBOX_KEY = "dev_sms_outbox:{phone}"
DEV_OUTBOX_TTL_SECONDS = 10 * 60
DEV_OUTBOX_SIZE = 5
# every phone together, newest last, for the admin's Test messages page (dev only)
DEV_OUTBOX_ALL_KEY = "dev_sms_outbox:all"
DEV_OUTBOX_ALL_TTL_SECONDS = 60 * 60
DEV_OUTBOX_ALL_SIZE = 50


class SMSError(Exception):
    pass


class SMSBackend(Protocol):
    def send(self, phone: str, template: str, variables: dict[str, str]) -> None: ...


def render(template: str, variables: dict[str, str]) -> str:
    return TEMPLATES[template].format(**{"app_hash": "", **variables}).strip()


class ConsoleSMSBackend:
    """Dev/test: keeps the last few messages per phone in the cache for 10 minutes."""

    def send(self, phone: str, template: str, variables: dict[str, str]) -> None:
        key = DEV_OUTBOX_KEY.format(phone=phone)
        message = {
            "at": timezone.now().isoformat(),
            "template": template,
            "text": render(template, variables),
        }
        outbox: list[dict[str, Any]] = cache.get(key, [])
        outbox.append(message)
        cache.set(key, outbox[-DEV_OUTBOX_SIZE:], timeout=DEV_OUTBOX_TTL_SECONDS)
        everyone: list[dict[str, Any]] = cache.get(DEV_OUTBOX_ALL_KEY, [])
        everyone.append({**message, "phone": phone})
        cache.set(
            DEV_OUTBOX_ALL_KEY, everyone[-DEV_OUTBOX_ALL_SIZE:], timeout=DEV_OUTBOX_ALL_TTL_SECONDS
        )
        logger.info("SMS %s to %s saved in the dev outbox", template, mask_phone(phone))


def read_dev_outbox(phone: str) -> list[dict[str, Any]]:
    return list(cache.get(DEV_OUTBOX_KEY.format(phone=phone), []))


def read_dev_outbox_all() -> list[dict[str, Any]]:
    """The last 50 SMS to anyone in the last hour, newest first (dev only)."""
    return list(reversed(cache.get(DEV_OUTBOX_ALL_KEY, [])))


def uses_dev_outbox() -> bool:
    """True only in local development and tests (deployed settings refuse the console backend)."""
    return settings.APP_ENV in ("dev", "test") and settings.SMS_BACKEND.endswith(
        "ConsoleSMSBackend"
    )


class MSG91SMSBackend:
    """MSG91 Flow API: one DLT template per message type, ids from settings.MSG91_TEMPLATES."""

    timeout_seconds = 8

    def send(self, phone: str, template: str, variables: dict[str, str]) -> None:
        template_id = settings.MSG91_TEMPLATES.get(template)
        if not template_id or not settings.MSG91_AUTH_KEY:
            raise SMSError(f"MSG91 is not configured for template {template}")
        body = {
            "template_id": template_id,
            "short_url": "0",
            "recipients": [{"mobiles": phone.lstrip("+"), **variables}],
        }
        try:
            response = requests.post(
                settings.MSG91_FLOW_URL,
                json=body,
                headers={"authkey": settings.MSG91_AUTH_KEY, "accept": "application/json"},
                timeout=self.timeout_seconds,
            )
        except requests.RequestException as exc:
            logger.warning(
                "SMS %s to %s failed: %s", template, mask_phone(phone), type(exc).__name__
            )
            raise SMSError("SMS provider unreachable") from None
        if response.status_code >= 400:
            logger.warning(
                "SMS %s to %s rejected: HTTP %s", template, mask_phone(phone), response.status_code
            )
            raise SMSError("SMS provider rejected the message")
        logger.info("SMS %s sent to %s", template, mask_phone(phone))


def get_backend() -> SMSBackend:
    backend: SMSBackend = import_string(settings.SMS_BACKEND)()
    return backend


# DLT (TRAI): a {#var#} value is at most 30 characters, or the operator drops the SMS. Links
# are {#url#} variables (their domains whitelisted on DLT) and may be longer.
DLT_VAR_MAX = 30
URL_VARIABLES = frozenset({"link", "map"})


def dlt_safe(variables: dict[str, str]) -> dict[str, str]:
    """Values cut to what DLT accepts (a long reason or name is shortened, never dropped)."""
    return {
        key: value
        if key in URL_VARIABLES or len(value) <= DLT_VAR_MAX
        else value[: DLT_VAR_MAX - 1].rstrip() + "…"
        for key, value in variables.items()
    }


def send_sms(phone: str, template: str, variables: dict[str, str]) -> None:
    if template not in TEMPLATES:
        raise SMSError(f"Unknown SMS template {template}")
    try:
        get_backend().send(phone, template, dlt_safe(variables))
    except Exception:
        from common.metrics import count

        count("SmsFailures")  # §13 alarm
        raise
