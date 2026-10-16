"""Masks what must never reach a log or Sentry (ARCHITECTURE §12 Logs, PHASES 9.3): full phone
numbers, tokens, one-time codes and Aadhaar numbers. The code already logs masked phones
(`mask_phone`) and ids only; this is the safety net for anything that slips through, e.g. an
admin's phone search in the access log's query string or a number inside an exception text.
"""

import logging
import re
from urllib.parse import unquote_plus

# A JSON Web Token (access, refresh, file links) or an Authorization header's value
_TOKEN = re.compile(r"eyJ[\w-]{4,}\.[\w-]{4,}\.[\w-]{4,}|(?i:bearer)\s+[\w.~+/=-]{8,}")
# A one-time code next to its word: "otp 123456", "code=1234", "OTP: 123456"
_CODE = re.compile(r"(?i)\b(otp|code|pin)(\W{0,3})\d{4,8}\b")
# Aadhaar: 12 digits, maybe in groups of 4
_AADHAAR = re.compile(r"(?<![\d-])\d{4}[ -]?\d{4}[ -]?\d{4}(?![\d-])")
# An Indian mobile: +91 / 91 / 0 in front or not, spaces or dashes allowed (not inside a UUID)
_PHONE = re.compile(r"(?<![\w-])(?:\+?91[\s-]?|0)?[6-9]\d{4}[\s-]?\d{5}(?![\w-])")


def redact(text: str) -> str:
    if "%" in text:  # "q=98765%2043210" in a URL is a phone number too
        text = unquote_plus(text)
    text = _TOKEN.sub("[token]", text)
    text = _CODE.sub(lambda m: f"{m.group(1)}{m.group(2)}[code]", text)
    # phones first: "+91 98765 43210" is 12 digits too
    text = _PHONE.sub(lambda m: "[phone …" + re.sub(r"\D", "", m.group(0))[-4:] + "]", text)
    return _AADHAAR.sub("[number]", text)


class RedactFilter(logging.Filter):
    """On a handler: the message is formatted once and masked (its arguments go with it), and
    so are a traceback and a stack (a database error can quote a phone number)."""

    _formatter = logging.Formatter()

    def filter(self, record: logging.LogRecord) -> bool:
        message = record.getMessage()
        masked = redact(message)
        if masked != message:
            record.msg, record.args = masked, ()
        if record.exc_info and not record.exc_text:
            record.exc_text = self._formatter.formatException(record.exc_info)
        if record.exc_text:
            record.exc_text = redact(record.exc_text)
        if record.stack_info:
            record.stack_info = redact(record.stack_info)
        return True


class AccessLogFilter(logging.Filter):
    """The web server's access lines without query strings: a search's words (a name, a phone)
    never reach the logs. uvicorn's arguments: client, method, path, HTTP version, status."""

    def filter(self, record: logging.LogRecord) -> bool:
        args = record.args
        if isinstance(args, tuple) and len(args) >= 3 and isinstance(args[2], str):
            record.args = (*args[:2], args[2].split("?", 1)[0], *args[3:])
        return True
