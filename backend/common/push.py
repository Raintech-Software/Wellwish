"""Push notifications (ARCHITECTURE §3.2): Firebase Cloud Messaging (HTTP v1).

- `ConsolePushBackend` (dev and tests, and until the Firebase project exists): nothing is sent.
  The last pushes per token are kept in a dev outbox in the cache; the log line never contains
  the text.
- `FCMPushBackend` (staging/prod): FCM HTTP v1 with a service account (`FCM_CREDENTIALS_FILE`,
  `FCM_PROJECT_ID`). See docs/KEYS-AND-ACCOUNTS.md.

`send_push` returns the tokens FCM says are dead, so the caller can forget them.
"""

import logging
from typing import Any, Protocol

import requests
from django.conf import settings
from django.core.cache import cache
from django.utils import timezone
from django.utils.module_loading import import_string

logger = logging.getLogger(__name__)

DEV_OUTBOX_KEY = "dev_push_outbox:{token}"
DEV_OUTBOX_TTL_SECONDS = 10 * 60
FCM_SCOPE = "https://www.googleapis.com/auth/firebase.messaging"


class PushBackend(Protocol):
    def send(self, tokens: list[str], title: str, body: str, data: dict[str, str]) -> list[str]: ...


class ConsolePushBackend:
    def send(self, tokens: list[str], title: str, body: str, data: dict[str, str]) -> list[str]:
        for token in tokens:
            key = DEV_OUTBOX_KEY.format(token=token)
            outbox: list[dict[str, Any]] = cache.get(key, [])
            outbox.append(
                {"at": timezone.now().isoformat(), "title": title, "body": body, "data": data}
            )
            cache.set(key, outbox[-5:], timeout=DEV_OUTBOX_TTL_SECONDS)
        logger.info("Push saved in the dev outbox for %s device(s)", len(tokens))
        return []


def read_dev_outbox(token: str) -> list[dict[str, Any]]:
    return list(cache.get(DEV_OUTBOX_KEY.format(token=token), []))


class FCMPushBackend:
    timeout_seconds = 8

    def _access_token(self) -> str:
        from google.auth.transport.requests import Request
        from google.oauth2 import service_account

        credentials = service_account.Credentials.from_service_account_file(
            settings.FCM_CREDENTIALS_FILE, scopes=[FCM_SCOPE]
        )
        credentials.refresh(Request())
        return str(credentials.token)

    def send(self, tokens: list[str], title: str, body: str, data: dict[str, str]) -> list[str]:
        if not settings.FCM_PROJECT_ID or not settings.FCM_CREDENTIALS_FILE:
            logger.warning("FCM is not configured: push skipped")
            return []
        url = f"https://fcm.googleapis.com/v1/projects/{settings.FCM_PROJECT_ID}/messages:send"
        headers = {"Authorization": f"Bearer {self._access_token()}"}
        dead: list[str] = []
        for token in tokens:
            message = {
                "message": {
                    "token": token,
                    "notification": {"title": title, "body": body},
                    "data": data,
                    "android": {"priority": "high"},
                }
            }
            try:
                response = requests.post(
                    url, json=message, headers=headers, timeout=self.timeout_seconds
                )
            except requests.RequestException as exc:
                logger.warning("Push failed: %s", type(exc).__name__)
                continue
            if response.status_code in (400, 404) and "UNREGISTERED" in response.text:
                dead.append(token)
            elif response.status_code >= 400:
                logger.warning("Push rejected: HTTP %s", response.status_code)
        return dead


def get_backend() -> PushBackend:
    backend: PushBackend = import_string(settings.PUSH_BACKEND)()
    return backend


def send_push(tokens: list[str], title: str, body: str, data: dict[str, str]) -> list[str]:
    if not tokens:
        return []
    return get_backend().send(tokens, title, body, data)
