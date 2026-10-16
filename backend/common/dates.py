"""Today's date in India. The server runs in UTC, so between 00:00 and 05:30 IST
`timezone.localdate()` is still yesterday."""

import datetime as dt
from zoneinfo import ZoneInfo

from django.conf import settings
from django.utils import timezone


def today_ist() -> dt.date:
    return timezone.localdate(timezone=ZoneInfo(settings.DISPLAY_TIME_ZONE))
