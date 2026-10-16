"""Message texts for Phase 3 (partner registration and status). APP = push + inbox,
EMAIL = subject + body. English, Hindi and Odia. Variables in {braces}."""

from django.db import migrations

# code → {language: (title, body)}
APP = {
    "PARTNER_SUBMITTED": {
        "en": ("Application received", "Thanks {name}. We are checking your documents and will let you know soon."),
        "hi": ("आवेदन मिल गया", "धन्यवाद {name}। हम आपके दस्तावेज़ जाँच रहे हैं और जल्द ही आपको बताएँगे।"),
        "or": ("ଆବେଦନ ମିଳିଲା", "ଧନ୍ୟବାଦ {name}। ଆମେ ଆପଣଙ୍କ କାଗଜପତ୍ର ଯାଞ୍ଚ କରୁଛୁ ଏବଂ ଶୀଘ୍ର ଜଣାଇବୁ।"),
    },
    "PARTNER_CHANGES_REQUESTED": {
        "en": ("Changes needed", "Some documents need a change. Open the app to see why and upload them again."),
        "hi": ("बदलाव ज़रूरी", "कुछ दस्तावेज़ों में बदलाव चाहिए। कारण देखने और फिर से अपलोड करने के लिए ऐप खोलें।"),
        "or": ("ପରିବର୍ତ୍ତନ ଆବଶ୍ୟକ", "କିଛି କାଗଜପତ୍ରରେ ପରିବର୍ତ୍ତନ ଦରକାର। କାରଣ ଦେଖିବା ଓ ପୁଣି ଅପଲୋଡ୍ କରିବାକୁ ଆପ୍ ଖୋଲନ୍ତୁ।"),
    },
    "PARTNER_APPROVED": {
        "en": ("You're approved!", "Welcome to WellWish, {name}. You can now get jobs."),
        "hi": ("आप स्वीकृत हैं!", "WellWish में स्वागत है, {name}। अब आपको काम मिल सकता है।"),
        "or": ("ଆପଣ ଅନୁମୋଦିତ!", "WellWishକୁ ସ୍ୱାଗତ, {name}। ଏବେ ଆପଣ କାମ ପାଇପାରିବେ।"),
    },
    "PARTNER_REJECTED": {
        "en": ("Application not approved", "Sorry, we can't approve your application: {reason}"),
        "hi": ("आवेदन स्वीकृत नहीं", "क्षमा करें, हम आपका आवेदन स्वीकार नहीं कर सकते: {reason}"),
        "or": ("ଆବେଦନ ଅନୁମୋଦିତ ହେଲା ନାହିଁ", "ଦୁଃଖିତ, ଆମେ ଆପଣଙ୍କ ଆବେଦନ ଗ୍ରହଣ କରିପାରିବୁ ନାହିଁ: {reason}"),
    },
    "PARTNER_SUSPENDED": {
        "en": ("Account paused", "Your partner account is paused: {reason}. Call support on {support}."),
        "hi": ("खाता रोका गया", "आपका पार्टनर खाता रोका गया है: {reason}। सहायता के लिए {support} पर कॉल करें।"),
        "or": ("ଖାତା ବନ୍ଦ ରଖାଯାଇଛି", "ଆପଣଙ୍କ ପାର୍ଟନର ଖାତା ବନ୍ଦ ରଖାଯାଇଛି: {reason}। ସହାୟତା ପାଇଁ {support}କୁ କଲ୍ କରନ୍ତୁ।"),
    },
    "PARTNER_REINSTATED": {
        "en": ("Account active again", "Your partner account is active again."),
        "hi": ("खाता फिर सक्रिय", "आपका पार्टनर खाता फिर से सक्रिय है।"),
        "or": ("ଖାତା ପୁଣି ସକ୍ରିୟ", "ଆପଣଙ୍କ ପାର୍ଟନର ଖାତା ପୁଣି ସକ୍ରିୟ ହୋଇଛି।"),
    },
    "PARTNER_DEACTIVATED": {
        "en": ("Account closed", "Your partner account was closed: {reason}"),
        "hi": ("खाता बंद", "आपका पार्टनर खाता बंद कर दिया गया: {reason}"),
        "or": ("ଖାତା ବନ୍ଦ", "ଆପଣଙ୍କ ପାର୍ଟନର ଖାତା ବନ୍ଦ କରାଯାଇଛି: {reason}"),
    },
    "DOCUMENT_EXPIRING": {
        "en": ("Document expiring soon", "Your {document} expires on {date}. Upload the new one in the app."),
        "hi": ("दस्तावेज़ जल्द समाप्त", "आपका {document} {date} को समाप्त हो रहा है। नया ऐप में अपलोड करें।"),
        "or": ("କାଗଜ ଶୀଘ୍ର ସମାପ୍ତ", "ଆପଣଙ୍କ {document} {date}ରେ ସମାପ୍ତ ହେବ। ନୂଆଟି ଆପରେ ଅପଲୋଡ୍ କରନ୍ତୁ।"),
    },
    "DOCUMENT_EXPIRED": {
        "en": ("Document expired", "Your {document} has expired. Upload a new one to keep getting jobs."),
        "hi": ("दस्तावेज़ समाप्त", "आपका {document} समाप्त हो गया है। काम पाते रहने के लिए नया अपलोड करें।"),
        "or": ("କାଗଜ ସମାପ୍ତ", "ଆପଣଙ୍କ {document} ସମାପ୍ତ ହୋଇଛି। କାମ ପାଇବା ପାଇଁ ନୂଆଟି ଅପଲୋଡ୍ କରନ୍ତୁ।"),
    },
    "DOCUMENT_REJECTED": {
        "en": ("Document not accepted", "Your new {document} wasn't accepted: {reason}. Please upload it again."),
        "hi": ("दस्तावेज़ स्वीकार नहीं", "आपका नया {document} स्वीकार नहीं हुआ: {reason}। कृपया फिर से अपलोड करें।"),
        "or": ("କାଗଜ ଗ୍ରହଣ ହେଲା ନାହିଁ", "ଆପଣଙ୍କ ନୂଆ {document} ଗ୍ରହଣ ହେଲା ନାହିଁ: {reason}। ଦୟାକରି ପୁଣି ଅପଲୋଡ୍ କରନ୍ତୁ।"),
    },
}

EMAIL = {
    "EMAIL_VERIFY_CODE": {
        "en": ("Your WellWish code", "Hello {name},\n\nYour WellWish email code is {code}. It expires in 10 minutes.\n\nIf you didn't ask for it, ignore this email.\n\nWellWish"),
        "hi": ("आपका WellWish कोड", "नमस्ते {name},\n\nआपका WellWish ईमेल कोड {code} है। यह 10 मिनट में समाप्त हो जाएगा।\n\nअगर आपने यह नहीं माँगा, तो इस ईमेल को अनदेखा करें।\n\nWellWish"),
        "or": ("ଆପଣଙ୍କ WellWish କୋଡ୍", "ନମସ୍କାର {name},\n\nଆପଣଙ୍କ WellWish ଇମେଲ୍ କୋଡ୍ {code}। ଏହା 10 ମିନିଟରେ ସମାପ୍ତ ହେବ।\n\nଯଦି ଆପଣ ଏହା ମାଗି ନାହାନ୍ତି, ଏହି ଇମେଲକୁ ଅଣଦେଖା କରନ୍ତୁ।\n\nWellWish"),
    },
    "PARTNER_CHANGES_REQUESTED": {
        "en": ("WellWish: changes needed in your application", "Hello {name},\n\nSome of your documents need a change. Open the WellWish Partner app to see the reason for each one and upload them again.\n\nWellWish"),
    },
    "PARTNER_APPROVED": {
        "en": ("Welcome to WellWish!", "Hello {name},\n\nYour WellWish partner account is approved. Open the WellWish Partner app and switch on \"Available today\" to start getting jobs.\n\nWellWish"),
    },
    "PARTNER_REJECTED": {
        "en": ("WellWish: application not approved", "Hello {name},\n\nSorry, we can't approve your application: {reason}\n\nWellWish"),
    },
    "PARTNER_SUSPENDED": {
        "en": ("WellWish: account paused", "Hello {name},\n\nYour WellWish partner account is paused: {reason}. Please call support on {support}.\n\nWellWish"),
    },
    "PARTNER_DEACTIVATED": {
        "en": ("WellWish: account closed", "Hello {name},\n\nYour WellWish partner account was closed: {reason}\n\nWellWish"),
    },
    "DOCUMENT_EXPIRING": {
        "en": ("WellWish: document expiring on {date}", "Hello {name},\n\nYour {document} expires on {date}. Upload the new one in the WellWish Partner app so your account stays active.\n\nWellWish"),
    },
}


def seed(apps, schema_editor):
    Template = apps.get_model("notifications", "NotificationTemplate")
    for channel, table in (("APP", APP), ("EMAIL", EMAIL)):
        for code, languages in table.items():
            for language, (title, body) in languages.items():
                Template.objects.get_or_create(
                    code=code,
                    channel=channel,
                    language=language,
                    defaults={"title": title, "body": body},
                )


class Migration(migrations.Migration):
    dependencies = [("notifications", "0001_initial")]
    operations = [migrations.RunPython(seed, migrations.RunPython.noop)]
