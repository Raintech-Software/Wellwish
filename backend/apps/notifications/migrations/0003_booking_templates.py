"""Message texts for Phase 6 (booking paid, cancelled, time changed, refund done) for the patient
app's inbox and push. English, Hindi and Odia. Variables in {braces}."""

from django.db import migrations

APP = {
    "BOOKING_CONFIRMED": {
        "en": ("Booking confirmed", "{service} for {name} on {when} is booked ({code}). We're assigning your partner."),
        "hi": ("बुकिंग पक्की", "{name} के लिए {when} को {service} बुक हो गया ({code})। हम आपका पार्टनर तय कर रहे हैं।"),
        "or": ("ବୁକିଂ ନିଶ୍ଚିତ", "{name}ଙ୍କ ପାଇଁ {when}ରେ {service} ବୁକ୍ ହେଲା ({code})। ଆମେ ଆପଣଙ୍କ ପାର୍ଟନର୍ ସ୍ଥିର କରୁଛୁ।"),
    },
    "BOOKING_CANCELLED": {
        "en": ("Booking cancelled", "Booking {code} for {name} on {when} is cancelled. A refund, if any, reaches your payment method in 5 to 7 working days."),
        "hi": ("बुकिंग रद्द", "{name} की {when} की बुकिंग {code} रद्द हो गई। रिफ़ंड हो तो 5 से 7 कार्य दिवस में आपके भुगतान के तरीके में आएगा।"),
        "or": ("ବୁକିଂ ବାତିଲ୍", "{name}ଙ୍କ {when}ର ବୁକିଂ {code} ବାତିଲ୍ ହେଲା। ଫେରସ୍ତ ଥିଲେ 5 ରୁ 7 କାର୍ଯ୍ୟ ଦିବସରେ ଆପଣଙ୍କ ପୈଠ ମାଧ୍ୟମକୁ ଆସିବ।"),
    },
    "BOOKING_RESCHEDULED": {
        "en": ("Time changed", "Booking {code} for {name} is now on {when}."),
        "hi": ("समय बदला", "{name} की बुकिंग {code} अब {when} को है।"),
        "or": ("ସମୟ ବଦଳିଲା", "{name}ଙ୍କ ବୁକିଂ {code} ଏବେ {when}ରେ।"),
    },
    "REFUND_PROCESSED": {
        "en": ("Refund done", "₹{amount} for booking {code} is refunded. It reaches your account in 5 to 7 working days."),
        "hi": ("रिफ़ंड हो गया", "बुकिंग {code} के ₹{amount} वापस कर दिए गए। ये 5 से 7 कार्य दिवस में आपके खाते में आएँगे।"),
        "or": ("ଫେରସ୍ତ ହେଲା", "ବୁକିଂ {code}ର ₹{amount} ଫେରସ୍ତ ହେଲା। ଏହା 5 ରୁ 7 କାର୍ଯ୍ୟ ଦିବସରେ ଆପଣଙ୍କ ଖାତାକୁ ଆସିବ।"),
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
    dependencies = [("notifications", "0002_seed_templates")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
