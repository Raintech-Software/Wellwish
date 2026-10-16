"""Every admin-editable setting, with its type, limits and default (ARCHITECTURE §6.12, §6.17,
§9.1 Settings, §11 app_settings). A key not saved in the database uses its default.

Kinds: "int" (min/max), "choice" (choices), "time" ("HH:MM"), "phone" (Indian mobile or
landline in E.164), "version" ("1.2.3").
"""

import re
from dataclasses import dataclass, field
from typing import Any

from common.phone import InvalidPhone, normalize_indian_mobile


@dataclass(frozen=True)
class SettingDef:
    key: str
    group: str
    label: str
    kind: str
    default: Any
    help: str = ""
    min: int | None = None
    max: int | None = None
    choices: tuple[str, ...] = field(default_factory=tuple)
    unit: str = ""


GROUPS = (
    "Cancellation and refunds",
    "Assignment",
    "Payments",
    "Scheduling",
    "Family",
    "Support",
    "App versions",
    "Privacy",
)

SETTINGS: tuple[SettingDef, ...] = (
    SettingDef(
        "refund_percent",
        GROUPS[0],
        "Refund on patient cancel",
        "int",
        50,
        "Share of the booking fee refunded when the patient cancels in time. The Refund Policy "
        "(Settings → Legal pages) states it: publish it again after a change.",
        0,
        100,
        unit="%",
    ),
    SettingDef(
        "cancel_cutoff_step",
        GROUPS[0],
        "Patient can cancel until",
        "choice",
        "ON_THE_WAY",
        "After this step the patient must contact support. The Refund Policy (Settings → Legal "
        "pages) states it: publish it again after a change.",
        choices=("ON_THE_WAY", "REACHED_PATIENT"),
    ),
    SettingDef(
        "refund_approval_above_paise",
        GROUPS[0],
        "Refunds above this need Finance approval",
        "int",
        50000,
        "In paise (₹500 = 50000).",
        0,
        10_000_000,
        unit="paise",
    ),
    SettingDef(
        "accept_timeout_seconds",
        GROUPS[1],
        "Time for the partner to accept",
        "int",
        120,
        "After this the admin is alerted to call the partner.",
        30,
        900,
        unit="s",
    ),
    SettingDef(
        "assign_deadline_evening_hour",
        GROUPS[1],
        "Assign by (evening before)",
        "int",
        18,
        "Hour (24 h, IST) on the evening before the visit.",
        0,
        23,
        unit="h",
    ),
    SettingDef(
        "assign_deadline_hours_before",
        GROUPS[1],
        "…or hours before pickup",
        "int",
        3,
        "Whichever comes first turns the booking red.",
        1,
        24,
        unit="h",
    ),
    SettingDef(
        "payment_expiry_min",
        GROUPS[2],
        "Unpaid bookings expire after",
        "int",
        30,
        "The Refund Policy (Settings → Legal pages) states it: publish it again after a change.",
        5,
        120,
        unit="min",
    ),
    SettingDef(
        "booking_window_days",
        GROUPS[3],
        "Booking window",
        "int",
        30,
        "The latest date a patient can pick.",
        1,
        90,
        unit="days",
    ),
    SettingDef(
        "min_notice_hours",
        GROUPS[3],
        "Minimum notice",
        "int",
        3,
        "Earliest time = now + this.",
        0,
        48,
        unit="h",
    ),
    SettingDef("service_hours_start", GROUPS[3], "Service hours from", "time", "07:00"),
    SettingDef(
        "service_hours_end",
        GROUPS[3],
        "Service hours until",
        "time",
        "21:00",
        "Nurse shifts can run overnight.",
    ),
    SettingDef(
        "time_step_min",
        GROUPS[3],
        "Time step",
        "choice",
        "30",
        "Times offered: 9:00, 9:30…",
        choices=("15", "30", "60"),
    ),
    SettingDef(
        "travel_buffer_min",
        GROUPS[3],
        "Travel buffer",
        "int",
        60,
        "Suggested pickup = appointment minus this.",
        0,
        180,
        unit="min",
    ),
    SettingDef("max_reschedules", GROUPS[3], "Reschedules per booking", "int", 2, "", 0, 10),
    SettingDef(
        "reschedule_cutoff_hours",
        GROUPS[3],
        "Patients can change the time until",
        "int",
        3,
        "Hours before the pickup. After that they call support.",
        0,
        48,
        unit="h",
    ),
    SettingDef(
        "max_per_slot",
        GROUPS[3],
        "Max bookings per time",
        "int",
        0,
        "0 = off. Use when partners are few.",
        0,
        100,
    ),
    SettingDef("max_members", GROUPS[4], "Family members per account", "int", 10, "", 1, 20),
    SettingDef(
        "support_phone",
        GROUPS[5],
        "Support phone",
        "phone",
        "+919000000000",
        "Shown in the apps and on SMS.",
    ),
    SettingDef("support_whatsapp", GROUPS[5], "Support WhatsApp", "phone", "", "Optional."),
    SettingDef(
        "min_version_patient_android",
        GROUPS[6],
        "Patient app (Android) minimum",
        "version",
        "0.1.0",
        "Older apps must update.",
    ),
    SettingDef(
        "min_version_patient_ios", GROUPS[6], "Patient app (iOS) minimum", "version", "0.1.0"
    ),
    SettingDef(
        "min_version_partner_android",
        GROUPS[6],
        "Partner app (Android) minimum",
        "version",
        "0.1.0",
    ),
    SettingDef(
        "account_deletion_days",
        GROUPS[7],
        "Wait before deleting an account",
        "int",
        7,
        'Days between a patient\'s "delete my account" and the erase. Logging in again within '
        "this time keeps the account. The law allows at most 30 days.",
        1,
        30,
        unit="days",
    ),
)

BY_KEY = {s.key: s for s in SETTINGS}

_TIME = re.compile(r"^([01]\d|2[0-3]):[0-5]\d$")
_VERSION = re.compile(r"^\d{1,3}\.\d{1,3}\.\d{1,3}$")


class InvalidSetting(ValueError):
    pass


def clean(key: str, value: Any) -> Any:
    """The value to store, or InvalidSetting with a message for the admin."""
    spec = BY_KEY.get(key)
    if spec is None:
        raise InvalidSetting("Unknown setting.")
    if spec.kind == "int":
        if isinstance(value, str) and re.fullmatch(r"-?[0-9]{1,9}", value.strip()):
            value = int(value.strip())
        if isinstance(value, bool) or not isinstance(value, int):
            raise InvalidSetting("Enter a whole number.")
        if (spec.min is not None and value < spec.min) or (
            spec.max is not None and value > spec.max
        ):
            raise InvalidSetting(f"Must be between {spec.min} and {spec.max}.")
        return value
    if not isinstance(value, str):
        raise InvalidSetting("Enter text.")
    value = value.strip()
    if spec.kind == "choice":
        if value not in spec.choices:
            raise InvalidSetting(f"Choose one of: {', '.join(spec.choices)}.")
        return value
    if spec.kind == "time":
        if not _TIME.match(value):
            raise InvalidSetting("Use HH:MM (24 h).")
        return value
    if spec.kind == "version":
        if not _VERSION.match(value):
            raise InvalidSetting("Use a version like 1.2.0.")
        return value
    if spec.kind == "phone":
        if value == "" and spec.default == "":
            return ""
        try:
            return normalize_indian_mobile(value)
        except InvalidPhone:
            raise InvalidSetting("Enter a valid Indian mobile number.") from None
    raise InvalidSetting("Unknown setting type.")
