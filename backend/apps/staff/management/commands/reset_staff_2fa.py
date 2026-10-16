"""`ww.ps1 manage reset_staff_2fa --email a@wellwish.in [--new-password]`

The emergency key (§6.4, v2.16): when an admin has lost their authenticator and their recovery
codes and no other Super Admin can reset them (e.g. the only Super Admin). Needs access to the
server itself. Clears the 2FA (a new QR code at the next sign-in), the recovery codes and the
trusted browsers, signs them out everywhere, and with `--new-password` asks for a new password
(never on the command line, where it would end up in the shell history). Written to the audit
log; the admin gets an email.
"""

import getpass
import sys
from typing import Any

from django.core.management.base import BaseCommand, CommandError, CommandParser

from apps.staff.services import InvalidStaffUser, emergency_reset
from common.errors import NotFound


class Command(BaseCommand):
    help = "Reset an admin's 2FA (and optionally the password) when they're locked out."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("--email", required=True)
        parser.add_argument(
            "--new-password", action="store_true", help="Also set a new password (asked for)"
        )

    def handle(self, *args: Any, **options: Any) -> None:
        password = None
        if options["new_password"]:
            if not sys.stdin.isatty():
                # without a terminal getpass may echo the password or never show the prompt
                # (`ww.ps1 manage` runs `docker compose exec -T` and pipes the output)
                raise CommandError(
                    "--new-password needs a terminal to ask for the password. Run:\n"
                    "  docker compose -f infra/docker-compose.yml exec api python manage.py "
                    f"reset_staff_2fa --email {options['email']} --new-password\n"
                    "(on the server: python manage.py reset_staff_2fa … in its shell)"
                )
            password = getpass.getpass("New password (min 12 characters): ")
            if getpass.getpass("Again: ") != password:
                raise CommandError("The passwords don't match.")
        try:
            staff = emergency_reset(email=options["email"], new_password=password)
        except NotFound:
            raise CommandError("No admin user with this email.") from None
        except InvalidStaffUser as exc:
            raise CommandError(exc.message) from None
        self.stdout.write(
            self.style.SUCCESS(
                f"Done: {staff.name}'s 2FA was reset"
                + (" and a new password set" if password else "")
                + ". They scan a new QR code at the next sign-in."
            )
        )
        if staff.status != staff.Status.ACTIVE:
            self.stdout.write(
                self.style.WARNING("This admin is disabled: a Super Admin must enable them.")
            )
