"""Celery app. Queues: default, notify (SMS/push/email), money (payments, refunds).

Short timers use `apply_async(countdown=...)`; anything further away uses a beat sweep
every minute that picks up due rows (ARCHITECTURE §10.5). Every task must be safe to run twice.
"""

import os

from celery import Celery
from celery.signals import setup_logging
from kombu import Queue

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.dev")

app = Celery("wellwish")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.conf.task_queues = (
    Queue("default"),
    Queue("notify"),
    Queue("money"),
)
app.autodiscover_tasks()


@setup_logging.connect
def _logging(**kwargs: object) -> None:
    """The worker and beat log through Django's LOGGING, so their lines are masked like the
    API's (§12 Logs; Celery would otherwise replace the handlers with its own)."""
    import logging.config

    from django.conf import settings

    logging.config.dictConfig(settings.LOGGING)
