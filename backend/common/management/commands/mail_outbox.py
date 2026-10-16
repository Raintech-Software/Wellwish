"""`ww.ps1 manage mail_outbox <email>` — show the emails the dev console backend 'sent'.

Dev only: real environments use SES and have no outbox.
"""

from typing import Any

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError, CommandParser

from common.mail import read_dev_outbox


class Command(BaseCommand):
    help = "Show the last emails sent to an address by the dev console mail backend."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("email")

    def handle(self, *args: Any, **options: Any) -> None:
        if settings.APP_ENV not in ("dev", "test"):
            raise CommandError("The email outbox exists only in local development.")
        messages = read_dev_outbox(options["email"].strip())
        if not messages:
            self.stdout.write("No emails in the last 10 minutes.")
            return
        for message in messages:
            self.stdout.write(f"{message['at']}  {message['subject']}\n  {message['text']}\n")
