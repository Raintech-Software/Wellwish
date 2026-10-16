"""`python manage.py seed` — load development data. Safe to run more than once.

Each phase adds its seeder to SEEDERS (Phase 1: the dev admin; Phase 2: services, hospitals…).
"""

from typing import Any

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError, CommandParser
from django.db import transaction
from django.utils.module_loading import import_string

# (label, dotted path to a function that takes no arguments and is idempotent)
SEEDERS: list[tuple[str, str]] = [
    ("staff", "apps.staff.seed.seed_dev_admin"),
    ("services", "apps.services.seed.seed_services"),
    ("directory", "apps.hospitals.seed.seed_directory"),
    ("app_config", "apps.app_config.seed.seed_app_config"),
]


class Command(BaseCommand):
    help = "Load development seed data. Refuses to run in production."

    def add_arguments(self, parser: CommandParser) -> None:
        parser.add_argument("--only", help="Run a single seeder by label.")

    def handle(self, *args: Any, **options: Any) -> None:
        if settings.APP_ENV == "prod":
            raise CommandError("Seed data must never be loaded in production.")

        seeders = SEEDERS
        if options.get("only"):
            seeders = [s for s in SEEDERS if s[0] == options["only"]]
            if not seeders:
                raise CommandError(f"No seeder called {options['only']!r}.")

        if not seeders:
            self.stdout.write("Nothing to seed yet. Seeders are added from Phase 2.")
            return

        for label, path in seeders:
            with transaction.atomic():
                import_string(path)()
            self.stdout.write(self.style.SUCCESS(f"Seeded: {label}"))
