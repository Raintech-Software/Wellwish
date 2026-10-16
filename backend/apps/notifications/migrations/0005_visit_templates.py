"""Message texts for Phase 8 (the visit) for the patient app's inbox and push. English, Hindi
and Odia. Variables in {braces}. The job OTP goes by SMS only (never stored in the inbox)."""

from django.db import migrations

APP = {
    "PARTNER_ON_THE_WAY": {
        "en": ("Partner on the way", "{partner} is on the way for {name} ({code}). Track them live in the app."),
        "hi": ("पार्टनर रास्ते में", "{partner} {name} के लिए रास्ते में हैं ({code})। ऐप में लाइव देखें।"),
        "or": ("ପାର୍ଟନର୍ ରାସ୍ତାରେ", "{partner} {name}ଙ୍କ ପାଇଁ ରାସ୍ତାରେ ଅଛନ୍ତି ({code})। ଆପ୍‌ରେ ଲାଇଭ୍ ଦେଖନ୍ତୁ।"),
    },
    "JOB_COMPLETED": {
        "en": ("Visit completed", "{service} for {name} is done ({code}). Pay {balance} to {partner} and rate the visit."),
        "hi": ("विज़िट पूरी", "{name} के लिए {service} पूरी हुई ({code})। {partner} को {balance} दें और विज़िट को रेट करें।"),
        "or": ("ଭିଜିଟ୍ ସମ୍ପୂର୍ଣ୍ଣ", "{name}ଙ୍କ ପାଇଁ {service} ସମ୍ପୂର୍ଣ୍ଣ ({code})। {partner}ଙ୍କୁ {balance} ଦିଅନ୍ତୁ ଏବଂ ଭିଜିଟ୍‌କୁ ରେଟ୍ କରନ୍ତୁ।"),
    },
    "PATIENT_NOT_AVAILABLE": {
        "en": ("Patient not available", "{partner} waited for {name} but couldn't meet them ({code}). WellWish will call you."),
        "hi": ("मरीज़ उपलब्ध नहीं", "{partner} ने {name} का इंतज़ार किया पर मिल नहीं पाए ({code})। WellWish आपको कॉल करेगा।"),
        "or": ("ରୋଗୀ ଉପଲବ୍ଧ ନାହାଁନ୍ତି", "{partner} {name}ଙ୍କ ପାଇଁ ଅପେକ୍ଷା କଲେ କିନ୍ତୁ ଦେଖା ହେଲା ନାହିଁ ({code})। WellWish ଆପଣଙ୍କୁ କଲ୍ କରିବ।"),
    },
}


def seed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    for code, languages in APP.items():
        for language, (title, body) in languages.items():
            Template.objects.get_or_create(
                code=code, channel="APP", language=language, defaults={"title": title, "body": body}
            )


def unseed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    Template.objects.filter(code__in=list(APP), channel="APP").delete()


class Migration(migrations.Migration):
    dependencies = [("notifications", "0004_assignment_templates")]

    operations = [migrations.RunPython(seed, unseed)]
