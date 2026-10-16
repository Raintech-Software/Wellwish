"""The "WellWish replied" message for reported problems (Phase 8). English, Hindi, Odia."""

from django.db import migrations

APP = {
    "TICKET_REPLY": {
        "en": ("WellWish replied", "We replied to the problem you reported for booking {code}. Open the booking to read it."),
        "hi": ("WellWish ने जवाब दिया", "बुकिंग {code} के लिए आपकी बताई समस्या का हमने जवाब दिया है। पढ़ने के लिए बुकिंग खोलें।"),
        "or": ("WellWish ଉତ୍ତର ଦେଲା", "ବୁକିଂ {code} ପାଇଁ ଆପଣ ଜଣାଇଥିବା ସମସ୍ୟାର ଆମେ ଉତ୍ତର ଦେଇଛୁ। ପଢ଼ିବାକୁ ବୁକିଂ ଖୋଲନ୍ତୁ।"),
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
    dependencies = [("notifications", "0005_visit_templates")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
