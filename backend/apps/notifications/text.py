"""Values put into messages in each language (Phase 9.1, ARCHITECTURE §5): a date and time, a
service name. `notify` picks the person's language for the app and the email, English for SMS.

The Hindi and Odia day and month names are the ones the apps show (Intl / CLDR), so a message
and the screen it opens say the same."""

import datetime as dt
from collections.abc import Mapping
from typing import Any

from apps.bookings.times import IST

# One value per language ({"en": …, "hi": …, "or": …}); English when one is missing.
Localized = Mapping[str, str]

_WEEKDAYS = {  # Monday first, like Python's weekday()
    "hi": ("सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि", "रवि"),
    "or": ("ସୋମ", "ମଙ୍ଗଳ", "ବୁଧ", "ଗୁରୁ", "ଶୁକ୍ର", "ଶନି", "ରବି"),
}
_MONTHS = {
    "hi": ("जन॰", "फ़र॰", "मार्च", "अप्रैल", "मई", "जून", "जुल॰", "अग॰", "सित॰", "अक्टू॰", "नव॰", "दिस॰"),
    "or": (
        "ଜାନୁଆରୀ",
        "ଫେବୃଆରୀ",
        "ମାର୍ଚ୍ଚ",
        "ଅପ୍ରେଲ",
        "ମଇ",
        "ଜୁନ",
        "ଜୁଲାଇ",
        "ଅଗଷ୍ଟ",
        "ସେପ୍ଟେମ୍ବର",
        "ଅକ୍ଟୋବର",
        "ନଭେମ୍ବର",
        "ଡିସେମ୍ବର",
    ),
}
_AM_PM = {"hi": ("am", "pm"), "or": ("AM", "PM")}

# "Hello {name}," when the name isn't known yet (e.g. a partner's first email code).
SOMEONE: Localized = {"en": "there", "hi": "जी", "or": "ଆଜ୍ଞା"}


def when(instant: dt.datetime) -> Localized:
    """A visit's time in India time: "Tue 13 Oct, 10:00 AM" in English (as before), the apps'
    "मंगल, 13 अक्टू॰, 10:00 am" / "ମଙ୍ଗଳ, 13 ଅକ୍ଟୋବର, 10:00 AM" in Hindi and Odia."""
    local = instant.astimezone(IST)
    hour = local.hour % 12 or 12
    out = {"en": local.strftime("%a %d %b, %I:%M %p")}
    for language in ("hi", "or"):
        day = _WEEKDAYS[language][local.weekday()]
        month = _MONTHS[language][local.month - 1]
        am_pm = _AM_PM[language][local.hour >= 12]
        out[language] = f"{day}, {local.day} {month}, {hour}:{local.minute:02d} {am_pm}"
    return out


def day(instant: dt.datetime | dt.date) -> Localized:
    """A date in India time: "14 Oct 2026", "14 अक्टू॰ 2026", "14 ଅକ୍ଟୋବର 2026" (§6.20 pages)."""
    local = instant.astimezone(IST).date() if isinstance(instant, dt.datetime) else instant
    out = {"en": f"{local.day} {local.strftime('%b')} {local.year}"}
    for language in ("hi", "or"):
        out[language] = f"{local.day} {_MONTHS[language][local.month - 1]} {local.year}"
    return out


def service(price_snapshot: Mapping[str, Any]) -> Localized:
    """The service's name as booked (the snapshot keeps its Hindi and Odia names)."""
    name = str(price_snapshot.get("name", ""))
    return {
        "en": name,
        "hi": str(price_snapshot.get("name_hi") or name),
        "or": str(price_snapshot.get("name_or") or name),
    }


def for_language(variables: Mapping[str, str | Localized], language: str) -> dict[str, str]:
    """Plain text values for one language."""
    return {
        key: value if isinstance(value, str) else (value.get(language) or value.get("en", ""))
        for key, value in variables.items()
    }
