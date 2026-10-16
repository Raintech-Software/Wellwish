"""Phase 9.1: the partner emails in Hindi and Odia (they were English only). The wording follows
the app messages of the same codes. Variables in {braces}."""

from django.db import migrations

EMAIL = {
    "PARTNER_CHANGES_REQUESTED": {
        "hi": ("WellWish: आपके आवेदन में बदलाव ज़रूरी", "नमस्ते {name},\n\nआपके कुछ दस्तावेज़ों में बदलाव चाहिए। हर दस्तावेज़ का कारण देखने और उसे फिर से अपलोड करने के लिए WellWish Partner ऐप खोलें।\n\nWellWish"),
        "or": ("WellWish: ଆପଣଙ୍କ ଆବେଦନରେ ପରିବର୍ତ୍ତନ ଆବଶ୍ୟକ", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ କିଛି କାଗଜପତ୍ରରେ ପରିବର୍ତ୍ତନ ଦରକାର। ପ୍ରତ୍ୟେକର କାରଣ ଦେଖିବା ଓ ପୁଣି ଅପଲୋଡ୍ କରିବାକୁ WellWish Partner ଆପ୍ ଖୋଲନ୍ତୁ।\n\nWellWish"),
    },
    "PARTNER_APPROVED": {
        "hi": ("WellWish में स्वागत है!", "नमस्ते {name},\n\nआपका WellWish पार्टनर खाता स्वीकृत हो गया है। काम मिलना शुरू करने के लिए WellWish Partner ऐप खोलें और \"आज उपलब्ध\" चालू करें।\n\nWellWish"),
        "or": ("WellWishକୁ ସ୍ୱାଗତ!", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ WellWish ପାର୍ଟନର ଖାତା ଅନୁମୋଦିତ ହୋଇଛି। କାମ ପାଇବା ଆରମ୍ଭ କରିବାକୁ WellWish Partner ଆପ୍ ଖୋଲି \"ଆଜି ଉପଲବ୍ଧ\" ଚାଲୁ କରନ୍ତୁ।\n\nWellWish"),
    },
    "PARTNER_REJECTED": {
        "hi": ("WellWish: आवेदन स्वीकृत नहीं", "नमस्ते {name},\n\nक्षमा करें, हम आपका आवेदन स्वीकार नहीं कर सकते: {reason}\n\nWellWish"),
        "or": ("WellWish: ଆବେଦନ ଅନୁମୋଦିତ ହେଲା ନାହିଁ", "ନମସ୍କାର {name},\n\nଦୁଃଖିତ, ଆମେ ଆପଣଙ୍କ ଆବେଦନ ଗ୍ରହଣ କରିପାରିବୁ ନାହିଁ: {reason}\n\nWellWish"),
    },
    "PARTNER_SUSPENDED": {
        "hi": ("WellWish: खाता रोका गया", "नमस्ते {name},\n\nआपका WellWish पार्टनर खाता रोका गया है: {reason}। कृपया सहायता के लिए {support} पर कॉल करें।\n\nWellWish"),
        "or": ("WellWish: ଖାତା ବନ୍ଦ ରଖାଯାଇଛି", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ WellWish ପାର୍ଟନର ଖାତା ବନ୍ଦ ରଖାଯାଇଛି: {reason}। ଦୟାକରି ସହାୟତା ପାଇଁ {support}କୁ କଲ୍ କରନ୍ତୁ।\n\nWellWish"),
    },
    "PARTNER_DEACTIVATED": {
        "hi": ("WellWish: खाता बंद", "नमस्ते {name},\n\nआपका WellWish पार्टनर खाता बंद कर दिया गया: {reason}\n\nWellWish"),
        "or": ("WellWish: ଖାତା ବନ୍ଦ", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ WellWish ପାର୍ଟନର ଖାତା ବନ୍ଦ କରାଯାଇଛି: {reason}\n\nWellWish"),
    },
    "DOCUMENT_EXPIRING": {
        "hi": ("WellWish: दस्तावेज़ {date} को समाप्त हो रहा है", "नमस्ते {name},\n\nआपका {document} {date} को समाप्त हो रहा है। अपना खाता चालू रखने के लिए WellWish Partner ऐप में नया दस्तावेज़ अपलोड करें।\n\nWellWish"),
        "or": ("WellWish: କାଗଜ {date}ରେ ସମାପ୍ତ ହେବ", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ {document} {date}ରେ ସମାପ୍ତ ହେବ। ଆପଣଙ୍କ ଖାତା ସକ୍ରିୟ ରଖିବାକୁ WellWish Partner ଆପ୍‌ରେ ନୂଆଟି ଅପଲୋଡ୍ କରନ୍ତୁ।\n\nWellWish"),
    },
}


def seed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    for code, languages in EMAIL.items():
        for language, (title, body) in languages.items():
            Template.objects.get_or_create(
                code=code, channel="EMAIL", language=language, defaults={"title": title, "body": body}
            )


def unseed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    Template.objects.filter(channel="EMAIL", code__in=EMAIL, language__in=("hi", "or")).delete()


class Migration(migrations.Migration):
    dependencies = [("notifications", "0007_job_completed_paid_template")]
    operations = [migrations.RunPython(seed, unseed)]
