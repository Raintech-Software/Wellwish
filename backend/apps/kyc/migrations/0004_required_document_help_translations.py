"""Phase 9.1: the required documents' hint and condition in Hindi and Odia (only the label had
them; the app showed "If you will drive the patient" in English). Filled for the texts the
seed added; the admin can change them on the Required documents page."""

from django.db import migrations, models

# English text → (Hindi, Odia)
HELP = {
    "Front and back in one photo or PDF. Only the last 4 digits of the number are kept.": (
        "आगे और पीछे दोनों एक फ़ोटो या PDF में। नंबर के केवल आख़िरी 4 अंक रखे जाते हैं।",
        "ଆଗ ଓ ପଛ ଉଭୟ ଗୋଟିଏ ଫଟୋ ବା PDFରେ। ନମ୍ବରର କେବଳ ଶେଷ 4ଟି ଅଙ୍କ ରଖାଯାଏ।",
    ),
    "Take it now with the front camera, face clearly visible.": (
        "अभी सामने वाले कैमरे से लें, चेहरा साफ़ दिखना चाहिए।",
        "ଏବେ ସାମ୍ନା କ୍ୟାମେରାରେ ନିଅନ୍ତୁ, ମୁହଁ ସ୍ପଷ୍ଟ ଦେଖାଯିବା ଉଚିତ।",
    ),
    "Renewed every year.": ("हर साल नवीनीकरण होता है।", "ପ୍ରତିବର୍ଷ ନବୀକରଣ ହୁଏ।"),
    "Electricity bill, ration card, voter ID or bank passbook.": (
        "बिजली बिल, राशन कार्ड, वोटर आईडी या बैंक पासबुक।",
        "ବିଦ୍ୟୁତ୍ ବିଲ୍, ରାସନ କାର୍ଡ, ଭୋଟର ଆଇଡି କିମ୍ବା ବ୍ୟାଙ୍କ ପାସବୁକ୍।",
    ),
    "Certificate with the registration number and valid-till date.": (
        "पंजीकरण संख्या और वैधता तिथि वाला प्रमाणपत्र।",
        "ପଞ୍ଜୀକରଣ ନମ୍ବର ଓ ବୈଧତା ତାରିଖ ଥିବା ପ୍ରମାଣପତ୍ର।",
    ),
}
CONDITION = {
    "If you will drive the patient": (
        "अगर आप मरीज़ को गाड़ी से ले जाएँगे",
        "ଯଦି ଆପଣ ରୋଗୀଙ୍କୁ ଗାଡ଼ିରେ ନେବେ",
    ),
    "If you have one": ("अगर आपके पास है", "ଯଦି ଆପଣଙ୍କ ପାଖରେ ଅଛି"),
}


def translate(apps, schema_editor):
    RequiredDocument = apps.get_model("kyc", "RequiredDocument")
    for english, (hindi, odia) in HELP.items():
        RequiredDocument.objects.filter(help=english, help_hi="").update(help_hi=hindi)
        RequiredDocument.objects.filter(help=english, help_or="").update(help_or=odia)
    for english, (hindi, odia) in CONDITION.items():
        RequiredDocument.objects.filter(condition=english, condition_hi="").update(
            condition_hi=hindi
        )
        RequiredDocument.objects.filter(condition=english, condition_or="").update(
            condition_or=odia
        )


class Migration(migrations.Migration):
    dependencies = [("kyc", "0003_seed_required_documents")]

    operations = [
        migrations.AddField(
            model_name="requireddocument",
            name="condition_hi",
            field=models.CharField(blank=True, default="", max_length=120),
        ),
        migrations.AddField(
            model_name="requireddocument",
            name="condition_or",
            field=models.CharField(blank=True, default="", max_length=120),
        ),
        migrations.AddField(
            model_name="requireddocument",
            name="help_hi",
            field=models.CharField(blank=True, default="", max_length=200),
        ),
        migrations.AddField(
            model_name="requireddocument",
            name="help_or",
            field=models.CharField(blank=True, default="", max_length=200),
        ),
        migrations.RunPython(translate, migrations.RunPython.noop),
    ]
