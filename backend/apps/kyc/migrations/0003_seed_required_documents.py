"""The document list from ARCHITECTURE §6.3. The admin can change it later (Required documents
page), so this only adds rows that don't exist yet."""

from django.db import migrations

# doc_type, label, Hindi, Odia, help, mandatory, condition, has_expiry, number_rule, camera_only
COMMON = [
    ("AADHAAR", "Aadhaar card", "आधार कार्ड", "ଆଧାର କାର୍ଡ",
     "Front and back in one photo or PDF. Only the last 4 digits of the number are kept.",
     True, "", False, "AADHAAR", False),
    ("PAN", "PAN card", "पैन कार्ड", "ପାନ୍ କାର୍ଡ", "", True, "", False, "PAN", False),
    ("SELFIE", "Live selfie", "लाइव सेल्फी", "ଲାଇଭ୍ ସେଲଫି",
     "Take it now with the front camera, face clearly visible.", True, "", False, "NONE", True),
    ("POLICE_VERIFICATION", "Police verification certificate", "पुलिस सत्यापन प्रमाणपत्र",
     "ପୋଲିସ ଯାଞ୍ଚ ପ୍ରମାଣପତ୍ର", "Renewed every year.", True, "", True, "NONE", False),
    ("ADDRESS_PROOF", "Address proof", "पते का प्रमाण", "ଠିକଣା ପ୍ରମାଣ",
     "Electricity bill, ration card, voter ID or bank passbook.", True, "", False, "NONE", False),
]
DRIVING = ("DRIVING_LICENCE", "Driving licence", "ड्राइविंग लाइसेंस", "ଡ୍ରାଇଭିଂ ଲାଇସେନ୍ସ", "",
           False, "If you will drive the patient", True, "TEXT", False)
COMPANION = [
    *COMMON,
    DRIVING,
    ("FIRST_AID", "First-aid / elderly-care training", "प्राथमिक चिकित्सा / बुज़ुर्ग देखभाल प्रशिक्षण",
     "ପ୍ରାଥମିକ ଚିକିତ୍ସା / ବୟସ୍କ ଯତ୍ନ ତାଲିମ", "", False, "If you have one", False, "NONE", False),
]
NURSE = [
    *COMMON,
    ("NURSING_QUALIFICATION", "Nursing qualification (ANM / GNM / B.Sc)",
     "नर्सिंग योग्यता (ANM / GNM / B.Sc)", "ନର୍ସିଂ ଯୋଗ୍ୟତା (ANM / GNM / B.Sc)", "", True, "", False,
     "NONE", False),
    ("NURSING_REGISTRATION", "Nursing council registration", "नर्सिंग काउंसिल पंजीकरण",
     "ନର୍ସିଂ କାଉନସିଲ ପଞ୍ଜୀକରଣ", "Certificate with the registration number and valid-till date.",
     True, "", True, "TEXT", False),
    DRIVING,
]


def seed(apps, schema_editor):
    RequiredDocument = apps.get_model("kyc", "RequiredDocument")
    for role, rows in (("COMPANION", COMPANION), ("NURSE", NURSE)):
        for sort, row in enumerate(rows, start=1):
            doc_type, label, hi, odia, help_, mandatory, condition, expiry, number, camera = row
            RequiredDocument.objects.get_or_create(
                role=role,
                doc_type=doc_type,
                defaults={
                    "label": label,
                    "label_hi": hi,
                    "label_or": odia,
                    "help": help_,
                    "mandatory": mandatory,
                    "condition": condition,
                    "has_expiry": expiry,
                    "number_rule": number,
                    "camera_only": camera,
                    "sort": sort,
                },
            )


class Migration(migrations.Migration):
    dependencies = [("kyc", "0002_initial")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
