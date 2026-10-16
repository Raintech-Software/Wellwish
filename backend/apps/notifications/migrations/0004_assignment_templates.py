"""Message texts for Phase 7 (offers to partners, partner assigned, reminders) for the apps'
inbox and push. English, Hindi and Odia. Variables in {braces}."""

from django.db import migrations

APP = {
    # Partner app
    "OFFER_NEW": {
        "en": ("New booking offer", "{service} on {when}, {area}. Open the app to accept or decline."),
        "hi": ("नई बुकिंग का ऑफ़र", "{when} को {service}, {area}। स्वीकार या मना करने के लिए ऐप खोलें।"),
        "or": ("ନୂଆ ବୁକିଂ ଅଫର୍", "{when}ରେ {service}, {area}। ଗ୍ରହଣ କିମ୍ବା ମନା କରିବାକୁ ଆପ୍ ଖୋଲନ୍ତୁ।"),
    },
    "OFFER_TIME_CHANGED": {
        "en": ("Time changed", "Booking {code} is now on {when}. Please confirm the new time in the app."),
        "hi": ("समय बदला", "बुकिंग {code} अब {when} को है। कृपया ऐप में नया समय पक्का करें।"),
        "or": ("ସମୟ ବଦଳିଲା", "ବୁକିଂ {code} ଏବେ {when}ରେ। ଦୟାକରି ଆପ୍‌ରେ ନୂଆ ସମୟ ନିଶ୍ଚିତ କରନ୍ତୁ।"),
    },
    "OFFER_REMINDER": {
        "en": ("Please answer the offer", "{service} on {when} is waiting for your answer."),
        "hi": ("कृपया ऑफ़र का जवाब दें", "{when} को {service} आपके जवाब का इंतज़ार कर रहा है।"),
        "or": ("ଦୟାକରି ଅଫର୍‌ର ଉତ୍ତର ଦିଅନ୍ତୁ", "{when}ରେ {service} ଆପଣଙ୍କ ଉତ୍ତର ପାଇଁ ଅପେକ୍ଷା କରୁଛି।"),
    },
    "OFFER_WITHDRAWN": {
        "en": ("Booking withdrawn", "Booking {code} on {when} is no longer yours."),
        "hi": ("बुकिंग वापस ली गई", "{when} की बुकिंग {code} अब आपकी नहीं है।"),
        "or": ("ବୁକିଂ ଫେରାଇ ନିଆଗଲା", "{when}ର ବୁକିଂ {code} ଆଉ ଆପଣଙ୍କର ନୁହେଁ।"),
    },
    "JOB_CANCELLED": {
        "en": ("Booking cancelled", "Booking {code} on {when} is cancelled. You don't need to go."),
        "hi": ("बुकिंग रद्द", "{when} की बुकिंग {code} रद्द हो गई। आपको जाने की ज़रूरत नहीं है।"),
        "or": ("ବୁକିଂ ବାତିଲ୍", "{when}ର ବୁକିଂ {code} ବାତିଲ୍ ହେଲା। ଆପଣଙ୍କୁ ଯିବାକୁ ପଡ଼ିବ ନାହିଁ।"),
    },
    "JOB_REMINDER": {
        "en": ("Job reminder", "{service} for {name} on {when} ({code})."),
        "hi": ("काम की याद", "{when} को {name} के लिए {service} ({code})।"),
        "or": ("କାମ ମନେପକାଇବା", "{when}ରେ {name}ଙ୍କ ପାଇଁ {service} ({code})।"),
    },
    # Patient app
    "BOOKING_ASSIGNED": {
        "en": ("Partner assigned", "{partner} will help {name} on {when} ({code}). Phone: {partner_phone}."),
        "hi": ("पार्टनर तय", "{partner} {when} को {name} की मदद करेंगे ({code})। फ़ोन: {partner_phone}।"),
        "or": ("ପାର୍ଟନର୍ ସ୍ଥିର", "{partner} {when}ରେ {name}ଙ୍କୁ ସାହାଯ୍ୟ କରିବେ ({code})। ଫୋନ୍: {partner_phone}।"),
    },
    "BOOKING_REMINDER": {
        "en": ("Reminder", "{service} for {name} on {when} ({code})."),
        "hi": ("याद दिलाना", "{when} को {name} के लिए {service} ({code})।"),
        "or": ("ମନେପକାଇବା", "{when}ରେ {name}ଙ୍କ ପାଇଁ {service} ({code})।"),
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
    dependencies = [("notifications", "0003_booking_templates")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
