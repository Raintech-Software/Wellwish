"""Sending messages (ARCHITECTURE §10.1): push, in-app inbox, email and SMS.

    notify(user_id=..., app="partner", code="PARTNER_APPROVED", variables={"name": "Asha"},
           email="asha@example.com", phone="+919876543210")

`MESSAGES` says which channels each message uses. Texts come from `notification_templates`
in the user's language (English if missing). One failing channel never stops the others.
"""

import logging
from collections import defaultdict
from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

from django.utils import timezone

from apps.accounts import selectors as accounts
from apps.accounts.services import forget_push_tokens
from apps.notifications import text
from apps.notifications.models import Channel, Notification, NotificationTemplate
from apps.notifications.text import Localized
from common.mail import MailError, send_mail
from common.push import send_push
from common.sms import send_sms

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Message:
    push: bool = False
    inbox: bool = False
    email: bool = False
    sms: str = ""  # DLT template code in common/sms.py


MESSAGES: dict[str, Message] = {
    "PARTNER_SUBMITTED": Message(inbox=True),
    "PARTNER_CHANGES_REQUESTED": Message(
        push=True, inbox=True, email=True, sms="PARTNER_CHANGES_REQUESTED"
    ),
    "PARTNER_APPROVED": Message(push=True, inbox=True, email=True, sms="PARTNER_APPROVED"),
    "PARTNER_REJECTED": Message(push=True, inbox=True, email=True),
    "PARTNER_SUSPENDED": Message(push=True, inbox=True, email=True, sms="PARTNER_SUSPENDED"),
    "PARTNER_REINSTATED": Message(push=True, inbox=True, sms="PARTNER_REINSTATED"),
    "PARTNER_DEACTIVATED": Message(inbox=True, email=True),
    "PARTNER_ADDED": Message(sms="PARTNER_ADDED"),
    "DOCUMENT_EXPIRING": Message(push=True, inbox=True, email=True),
    "DOCUMENT_EXPIRED": Message(push=True, inbox=True, sms="DOCUMENT_EXPIRED"),
    "DOCUMENT_REJECTED": Message(push=True, inbox=True),
    # Patient app (Phase 6). The SMS goes to the family member's own phone, if saved.
    "BOOKING_CONFIRMED": Message(push=True, inbox=True, sms="BOOKING_CONFIRMED"),
    "BOOKING_CANCELLED": Message(push=True, inbox=True, sms="BOOKING_CANCELLED"),
    "BOOKING_RESCHEDULED": Message(push=True, inbox=True, sms="BOOKING_RESCHEDULED"),
    "REFUND_PROCESSED": Message(push=True, inbox=True),
    # Phase 7: offers (partner app), partner assigned and reminders (§6.14)
    "OFFER_NEW": Message(push=True, inbox=True, sms="OFFER_NEW"),
    "OFFER_TIME_CHANGED": Message(push=True, inbox=True, sms="OFFER_TIME_CHANGED"),
    "OFFER_REMINDER": Message(push=True, inbox=True),
    "OFFER_WITHDRAWN": Message(push=True, inbox=True),
    "JOB_CANCELLED": Message(push=True, inbox=True, sms="JOB_CANCELLED"),
    "JOB_REMINDER": Message(push=True, inbox=True),
    "BOOKING_ASSIGNED": Message(push=True, inbox=True, sms="BOOKING_ASSIGNED"),
    "BOOKING_REMINDER": Message(push=True, inbox=True, sms="BOOKING_REMINDER"),
    # Phase 8: the visit (§6.11, §6.14). The job OTP: SMS only, never stored in the inbox.
    "JOB_OTP": Message(sms="JOB_OTP"),
    "PARTNER_ON_THE_WAY": Message(push=True, inbox=True),
    "JOB_COMPLETED": Message(push=True, inbox=True),
    "JOB_COMPLETED_PAID": Message(push=True, inbox=True),  # balance ₹0: no "Pay ₹0 to …"
    "PATIENT_NOT_AVAILABLE": Message(push=True, inbox=True),
    "SOS_ALERT": Message(sms="SOS_ALERT"),  # to emergency contacts only
    "TEMP_PARTNER_JOB": Message(sms="TEMP_PARTNER_JOB"),  # §6.19: the app link and the job
    "TICKET_REPLY": Message(push=True, inbox=True),
    # Verification code: email only, never stored in the inbox.
    "EMAIL_VERIFY_CODE": Message(email=True),
}


def _render(text: str, variables: dict[str, str]) -> str:
    return text.format_map(defaultdict(str, variables))


def _template(code: str, channel: str, language: str) -> NotificationTemplate | None:
    rows = {
        t.language: t
        for t in NotificationTemplate.objects.filter(
            code=code, channel=channel, language__in=[language, "en"]
        )
    }
    return rows.get(language) or rows.get("en")


def notify(
    *,
    user_id: str,
    app: str,
    code: str,
    variables: Mapping[str, str | Localized],
    email: str = "",
    phone: str = "",
    data: dict[str, str] | None = None,
) -> None:
    """Send one message: push and inbox and email in the person's language, SMS in English
    (developer decision, Phase 9). A value may be given per language (`text.when`,
    `text.service`)."""
    message = MESSAGES[code]
    language = accounts.get_user(user_id).language
    data = {"type": code, **(data or {})}
    sms_variables = text.for_language(variables, "en")
    variables = text.for_language(variables, language)

    if message.push or message.inbox:
        template = _template(code, Channel.APP, language)
        if template is None:
            logger.warning("No app template for %s", code)
        else:
            title = _render(template.title, variables)
            body = _render(template.body, variables)
            if message.inbox:
                Notification.objects.create(
                    user_id=user_id, app=app, type=code, title=title, body=body, data=data
                )
                _tell_app(user_id, app, code)
            if message.push:
                _safely("push", code, lambda: _push(user_id, app, title, body, data))
    if message.email and email:
        template = _template(code, Channel.EMAIL, language)
        if template is not None:
            subject = _render(template.title, variables)
            email_body = _render(template.body, variables)
            _safely("email", code, lambda: send_mail(email, subject, email_body))
    if message.sms and phone:
        _safely("sms", code, lambda: send_sms(phone, message.sms, sms_variables))


def _tell_app(user_id: str, app: str, code: str) -> None:
    """The bell's number, live (§10.4, v2.32): `notification.new` on that person's app socket
    once the message is saved."""
    from django.db import transaction

    from apps.notifications import selectors
    from common import realtime

    def send() -> None:
        realtime.send_to_group(
            realtime.user_group(app, user_id),
            "notification.new",
            {"type": code, "unread": selectors.unread_count(user_id, app)},
        )

    transaction.on_commit(send, robust=True)


def _push(user_id: str, app: str, title: str, body: str, data: dict[str, str]) -> None:
    dead = send_push(accounts.push_tokens(user_id, app), title, body, data)
    forget_push_tokens(dead)


def _safely(channel: str, code: str, send: Any) -> None:
    try:
        send()
    except Exception as exc:  # one channel failing must not stop the others
        logger.warning("%s for %s failed: %s", channel, code, type(exc).__name__)


def erase_inbox(*, user_id: str, app: str) -> int:
    """Account deletion (§12): remove the person's inbox in that app."""
    deleted, _ = Notification.objects.filter(user_id=user_id, app=app).delete()
    return deleted


def delete_old_family_messages(*, now: Any = None) -> int:
    """Nightly: the family's messages older than 30 days go (v2.33). The inbox no longer shows
    them, and they hold names and dates, so they aren't kept. Partner messages stay."""
    from datetime import timedelta

    from apps.notifications.selectors import FAMILY_INBOX_DAYS

    before = (now or timezone.now()) - timedelta(days=FAMILY_INBOX_DAYS)
    deleted, _ = Notification.objects.filter(app="patient", created_at__lt=before).delete()
    if deleted:
        logger.info("Deleted %s family messages older than %s days", deleted, FAMILY_INBOX_DAYS)
    return deleted


def mark_read(*, user_id: str, app: str, ids: list[str] | None) -> int:
    """Mark the given inbox entries (or all, when ids is None) as read."""
    qs = Notification.objects.filter(user_id=user_id, app=app, read_at__isnull=True)
    if ids is not None:
        qs = qs.filter(pk__in=ids)
    return qs.update(read_at=timezone.now(), updated_at=timezone.now())


def email_now(
    *, user_id: str, code: str, variables: Mapping[str, str | Localized], email: str
) -> None:
    """Send one templated email right away and raise if it can't be sent (used for
    verification codes, where the person is waiting for it)."""
    language = accounts.get_user(user_id).language
    template = _template(code, Channel.EMAIL, language)
    if template is None:
        raise MailError(f"No email template for {code}")
    values = text.for_language(variables, language)
    send_mail(email, _render(template.title, values), _render(template.body, values))
