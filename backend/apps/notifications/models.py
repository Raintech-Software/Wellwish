"""In-app inbox and message templates (ARCHITECTURE §10.1, §11).

Templates hold the push/inbox and email texts per language, so wording can change without an
app release. SMS texts are fixed by DLT registration and live in `common/sms.py`.
"""

from django.db import models

from common.models import BaseModel


class Channel(models.TextChoices):
    APP = "APP", "Push + in-app inbox"
    EMAIL = "EMAIL", "Email"


class NotificationTemplate(BaseModel):
    code = models.CharField(max_length=48)
    channel = models.CharField(max_length=8, choices=Channel.choices)
    language = models.CharField(max_length=8, default="en")
    title = models.CharField(max_length=160, help_text="Push title / email subject")
    body = models.TextField(help_text="Variables in {braces}, e.g. {name}")

    class Meta:
        db_table = "notification_templates"
        constraints = [
            models.UniqueConstraint(
                fields=["code", "channel", "language"], name="notification_template_uniq"
            )
        ]

    def __str__(self) -> str:
        return f"{self.code} {self.channel} {self.language}"


class Notification(BaseModel):
    """One inbox entry. Never holds codes, tokens or medical text."""

    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE, related_name="+")
    app = models.CharField(max_length=16, help_text="patient / partner")
    type = models.CharField(max_length=48)
    title = models.CharField(max_length=160)
    body = models.TextField()
    data = models.JSONField(default=dict, blank=True)
    read_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "notifications"
        ordering = ("-created_at",)
        indexes = [
            models.Index(fields=["user", "app", "-created_at"], name="notifications_inbox_idx")
        ]

    def __str__(self) -> str:
        return f"Notification {self.type}"
