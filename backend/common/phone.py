"""Indian mobile numbers only (ARCHITECTURE §6.2). Stored in E.164: +919876543210."""

import re

# ASCII digits only: \d would also accept Devanagari and other digits, giving the same phone
# a second spelling (a second account, separate rate limits).
_INDIAN_MOBILE = re.compile(r"^[6-9][0-9]{9}$")
_SEPARATORS = re.compile(r"[\s\-().]")


class InvalidPhone(ValueError):
    pass


def normalize_indian_mobile(raw: str) -> str:
    """'98765 43210', '+91-9876543210', '09876543210' → '+919876543210'."""
    digits = _SEPARATORS.sub("", raw or "")
    if digits.startswith("+91"):
        digits = digits[3:]
    elif digits.startswith("91") and len(digits) == 12:
        digits = digits[2:]
    elif digits.startswith("0") and len(digits) == 11:
        digits = digits[1:]
    if not _INDIAN_MOBILE.match(digits):
        raise InvalidPhone("Enter a valid 10-digit Indian mobile number.")
    return f"+91{digits}"


def mask_phone(e164: str) -> str:
    """For logs and support screens: '+919876543210' → '+91******3210'."""
    if len(e164) < 7:
        return "***"
    return f"{e164[:3]}{'*' * (len(e164) - 7)}{e164[-4:]}"
