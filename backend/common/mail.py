"""Sending email (ARCHITECTURE §3.2): AWS SES.

- `ConsoleMailBackend` (dev and tests): nothing leaves the PC. Messages go to a short-lived
  dev outbox in the cache, readable with `ww.ps1 manage mail_outbox <email>` or in the admin
  panel (Settings → Test messages, local development only). The log line never contains the
  subject or body (they can hold verification codes).
- `SESMailBackend` (staging/prod): Amazon SES in Mumbai, credentials from the server's role.

Never log the body or the full address.
"""

import logging
from typing import Any, Protocol

from django.conf import settings
from django.core.cache import cache
from django.utils import timezone
from django.utils.module_loading import import_string

logger = logging.getLogger(__name__)

DEV_OUTBOX_KEY = "dev_mail_outbox:{email}"
DEV_OUTBOX_TTL_SECONDS = 10 * 60
DEV_OUTBOX_SIZE = 5
# every address together, newest last, for the admin's Test messages page (dev only)
DEV_OUTBOX_ALL_KEY = "dev_mail_outbox:all"
DEV_OUTBOX_ALL_TTL_SECONDS = 60 * 60
DEV_OUTBOX_ALL_SIZE = 50


class MailError(Exception):
    pass


class MailBackend(Protocol):
    def send(self, to: str, subject: str, text: str) -> None: ...


def mask_email(email: str) -> str:
    """a***@example.com — for logs."""
    name, _, domain = email.partition("@")
    return f"{name[:1]}***@{domain}" if domain else "***"


class ConsoleMailBackend:
    """Dev/test: keeps the last few emails per address in the cache for 10 minutes."""

    def send(self, to: str, subject: str, text: str) -> None:
        key = DEV_OUTBOX_KEY.format(email=to.lower())
        message = {"at": timezone.now().isoformat(), "subject": subject, "text": text}
        outbox: list[dict[str, Any]] = cache.get(key, [])
        outbox.append(message)
        cache.set(key, outbox[-DEV_OUTBOX_SIZE:], timeout=DEV_OUTBOX_TTL_SECONDS)
        everyone: list[dict[str, Any]] = cache.get(DEV_OUTBOX_ALL_KEY, [])
        everyone.append({**message, "to": to.lower()})
        cache.set(
            DEV_OUTBOX_ALL_KEY, everyone[-DEV_OUTBOX_ALL_SIZE:], timeout=DEV_OUTBOX_ALL_TTL_SECONDS
        )
        logger.info("Email to %s saved in the dev outbox", mask_email(to))


def read_dev_outbox(email: str) -> list[dict[str, Any]]:
    return list(cache.get(DEV_OUTBOX_KEY.format(email=email.lower()), []))


def read_dev_outbox_all() -> list[dict[str, Any]]:
    """The last 50 emails to anyone in the last hour, newest first (dev only)."""
    return list(reversed(cache.get(DEV_OUTBOX_ALL_KEY, [])))


class SESMailBackend:
    """Amazon SES (verified domain, production access). Plain-text emails."""

    def send(self, to: str, subject: str, text: str) -> None:
        if not settings.MAIL_FROM:
            raise MailError("MAIL_FROM is not configured")
        import boto3  # type: ignore[import-untyped]

        client = boto3.client("ses", region_name=settings.MAIL_SES_REGION)
        try:
            client.send_email(
                Source=settings.MAIL_FROM,
                Destination={"ToAddresses": [to]},
                Message={
                    "Subject": {"Data": subject, "Charset": "UTF-8"},
                    "Body": {"Text": {"Data": text, "Charset": "UTF-8"}},
                },
            )
        except Exception as exc:
            logger.warning("Email to %s failed: %s", mask_email(to), type(exc).__name__)
            raise MailError("Email provider rejected the message") from None
        logger.info("Email sent to %s", mask_email(to))


def get_backend() -> MailBackend:
    backend: MailBackend = import_string(settings.MAIL_BACKEND)()
    return backend


def send_mail(to: str, subject: str, text: str) -> None:
    try:
        get_backend().send(to, subject, text)
    except Exception:
        from common.metrics import count

        count("EmailFailures")  # §13 alarm
        raise
