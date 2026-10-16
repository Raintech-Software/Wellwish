"""`ww.ps1 manage create_staff_user --email a@wellwish.in --name "Asha" --role SUPER_ADMIN`

Creates the first Super Admin on a new server. The password is asked for (never on the command
line, where it would end up in the shell history). Later staff are added in the admin panel.
"""

import getpass
from typing import Any

from django.core.management.base import BaseCommand, CommandError, CommandParser

from apps.staff.permissions import ROLES
from apps.staff.services import InvalidStaffUser, create_staff_user


class Command(BaseCommand):
    help = "Create an admin panel user (2FA is set up at the first sign-in)."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("--email", required=True)
        parser.add_argument("--name", required=True)
        parser.add_argument("--role", required=True, choices=sorted(ROLES))

    def handle(self, *args: Any, **options: Any) -> None:
        password = getpass.getpass("Password (min 12 characters): ")
        if password != getpass.getpass("Repeat password: "):
            raise CommandError("The passwords don't match.")
        try:
            staff = create_staff_user(
                name=options["name"],
                email=options["email"],
                password=password,
                role_code=options["role"],
                actor=None,
                ip=None,
            )
        except InvalidStaffUser as exc:
            raise CommandError(exc.message) from None
        self.stdout.write(self.style.SUCCESS(f"Created {staff.email} ({options['role']})."))
