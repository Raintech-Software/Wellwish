"""`ww.ps1 manage sms_outbox <phone>` — show the SMS the dev console backend 'sent'.

Dev only: real environments use MSG91 and have no outbox.
"""

from typing import Any

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError, CommandParser

from common.phone import InvalidPhone, normalize_indian_mobile
from common.sms import read_dev_outbox


class Command(BaseCommand):
    help = "Show the last SMS sent to a phone number by the dev console SMS backend."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("phone", help="Mobile number, e.g. 9876543210")

    def handle(self, *args: Any, **options: Any) -> None:
        if settings.APP_ENV not in ("dev", "test"):
            raise CommandError("The SMS outbox exists only in local development.")
        try:
            phone = normalize_indian_mobile(options["phone"])
        except InvalidPhone as exc:
            raise CommandError(str(exc)) from None
        messages = read_dev_outbox(phone)
        if not messages:
            self.stdout.write("No messages in the last 10 minutes.")
            return
        for message in messages:
            self.stdout.write(f"{message['at']}  {message['template']}\n  {message['text']}\n")
