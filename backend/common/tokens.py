"""Access tokens, refresh tokens and short-lived challenge tokens (ARCHITECTURE §6.4).

- **Access token:** a JWT valid for 15 minutes with `sub`, `aud` (patient / partner / staff),
  `pid` (profile id), `role` and `sid` (session id). Every request also checks that the session
  is still active, so a revoked session stops working at once.
- **Refresh token:** a random string. Only its SHA-256 hash is stored.
- **Challenge token:** a JWT for one step of a login (admin 2FA, Google → phone link).
"""

import hashlib
import secrets
import uuid
from collections.abc import Collection
from dataclasses import dataclass
from datetime import timedelta
from typing import Any

import jwt
from django.conf import settings
from django.utils import timezone

ALGORITHM = "HS256"
AUDIENCES = ("patient", "partner", "staff")


class InvalidToken(Exception):
    pass


@dataclass(frozen=True)
class AccessClaims:
    sub: str  # user id (patient/partner) or staff id
    aud: str  # patient | partner | staff
    pid: str | None  # profile id
    role: str | None  # PATIENT · COMPANION / NURSE · staff role code
    sid: str  # session id (the refresh-token family)


def issue_access_token(claims: AccessClaims) -> tuple[str, int]:
    """Returns (token, seconds until it expires)."""
    ttl = settings.ACCESS_TOKEN_TTL_SECONDS
    now = timezone.now()
    payload = {
        "iss": settings.JWT_ISSUER,
        "sub": claims.sub,
        "aud": claims.aud,
        "pid": claims.pid,
        "role": claims.role,
        "sid": claims.sid,
        "iat": now,
        "exp": now + timedelta(seconds=ttl),
        "jti": uuid.uuid4().hex,
    }
    return jwt.encode(payload, settings.JWT_SIGNING_KEY, algorithm=ALGORITHM), ttl


def decode_access_token(token: str, audiences: Collection[str]) -> AccessClaims:
    try:
        payload = jwt.decode(
            token,
            settings.JWT_SIGNING_KEY,
            algorithms=[ALGORITHM],
            audience=list(audiences),
            issuer=settings.JWT_ISSUER,
            options={"require": ["exp", "iat", "sub", "aud", "sid"]},
        )
    except jwt.PyJWTError as exc:
        raise InvalidToken(str(exc)) from None
    return AccessClaims(
        sub=str(payload["sub"]),
        aud=str(payload["aud"]),
        pid=payload.get("pid"),
        role=payload.get("role"),
        sid=str(payload["sid"]),
    )


def new_refresh_token() -> str:
    return secrets.token_urlsafe(48)


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


def issue_challenge(purpose: str, data: dict[str, Any], ttl_seconds: int) -> str:
    """A short-lived signed token for one login step. `purpose` keeps them from being mixed up."""
    now = timezone.now()
    payload = {
        "iss": settings.JWT_ISSUER,
        "aud": f"challenge:{purpose}",
        "iat": now,
        "exp": now + timedelta(seconds=ttl_seconds),
        "jti": uuid.uuid4().hex,
        "data": data,
    }
    return jwt.encode(payload, settings.JWT_SIGNING_KEY, algorithm=ALGORITHM)


def read_challenge(token: str, purpose: str) -> tuple[str, dict[str, Any]]:
    """Returns (jti, data). Raises InvalidToken if expired, tampered or for another purpose."""
    try:
        payload = jwt.decode(
            token,
            settings.JWT_SIGNING_KEY,
            algorithms=[ALGORITHM],
            audience=f"challenge:{purpose}",
            issuer=settings.JWT_ISSUER,
            options={"require": ["exp", "jti"]},
        )
    except jwt.PyJWTError as exc:
        raise InvalidToken(str(exc)) from None
    return str(payload["jti"]), dict(payload.get("data") or {})
