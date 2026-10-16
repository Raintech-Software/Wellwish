"""The "visit completed" message when the family paid the full price in the app (balance ₹0):
no "Pay ₹0 to …" (§1.2, v2.15). English, Hindi, Odia."""

from django.db import migrations

APP = {
    "JOB_COMPLETED_PAID": {
        "en": ("Visit completed", "{service} for {name} is done ({code}). How was {partner}? Rate the visit."),
        "hi": ("विज़िट पूरी", "{name} के लिए {service} पूरी हुई ({code})। {partner} की सेवा कैसी रही? विज़िट को रेट करें।"),
        "or": ("ଭିଜିଟ୍ ସମ୍ପୂର୍ଣ୍ଣ", "{name}ଙ୍କ ପାଇଁ {service} ସମ୍ପୂର୍ଣ୍ଣ ({code})। {partner}ଙ୍କ ସେବା କିପରି ଥିଲା? ଭିଜିଟ୍‌କୁ ରେଟ୍ କରନ୍ତୁ।"),
    },
}


def seed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    for code, languages in APP.items():
        for language, (title, body) in languages.items():
            Template.objects.get_or_create(
                code=code, channel="APP", language=language, defaults={"title": title, "body": body}
            )


class Migration(migrations.Migration):
    dependencies = [("notifications", "0006_ticket_reply_template")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
