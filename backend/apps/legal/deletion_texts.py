"""The account deletion page's texts (§6.20) in English, Hindi and Odia. The Hindi and Odia
use the apps' own words (ww_l10n); they are in the review sheet for the client."""

DELETE_TEXTS: dict[str, dict[str, str]] = {
    "en": {
        "title": "Delete your WellWish account",
        "intro": "For the WellWish app and the WellWish Partner app. We send a code to your "
        "number to check that it is yours.",
        "phone_label": "Your mobile number",
        "send": "Send code",
        "code_label": "The 6-digit code sent to {phone}",
        "verify": "Continue",
        "other_number": "Use another number",
        "none": "No WellWish account uses this number.",
        "accounts_intro": "These accounts use this number. Choose what to delete.",
        "patient_name": "WellWish (patients and families)",
        "patient_what": "Your profile, family members, addresses and documents are deleted "
        "after {days} days. Log in to the app before then to keep your account. Payment "
        "records are kept, as the law requires.",
        "partner_name": "WellWish Partner (companions and nurses)",
        "partner_what": "Your profile, phone numbers, email, address and documents are deleted "
        "after {days} days. Log in to the Partner app before then to keep your account. Your "
        "past jobs stay on record without your personal details.",
        "login_name": "Your WellWish login",
        "login_what": "Nothing else is saved for this number. It is deleted at once.",
        "logged_out": "You are logged out of the app at once.",
        "delete": "Delete this account",
        "confirm": "Yes, delete it",
        "requested": "Deletion requested: it will be deleted on {date}. Log in again before "
        "then to keep it.",
        "deleted": "Deleted.",
        "help": "Need help? Call WellWish: {phone}",
        "INVALID_PHONE": "Enter a 10-digit Indian mobile number.",
        "OTP_RATE_LIMITED": "Too many codes asked for. Please try again later.",
        "OTP_RESEND_TOO_SOON": "Please wait a minute before asking for a new code.",
        "OTP_EXPIRED": "This code has expired. Ask for a new one.",
        "OTP_INVALID": "That code isn't right. Check the SMS and try again.",
        "OTP_TOO_MANY_ATTEMPTS": "Too many wrong tries. Ask for a new code.",
        "OTP_LOCKED": "Too many wrong codes. Try again in an hour.",
        "SMS_NOT_SENT": "We couldn't send the SMS. Please try again.",
        "ACTIVE_BOOKINGS": "You have a booking that isn't finished. Cancel it in the app or "
        "wait until it's done, then try again.",
        "ACTIVE_JOBS": "You have an accepted or ongoing job. Ask WellWish to move it, then try "
        "again.",
        "EXPIRED": "This page has expired. Please start again.",
        "ERROR": "Something went wrong. Please try again.",
    },
    "hi": {
        "title": "अपना WellWish खाता हटाएँ",
        "intro": "WellWish ऐप और WellWish Partner ऐप के लिए। यह नंबर आपका है, यह जाँचने के "
        "लिए हम उस पर एक कोड भेजते हैं।",
        "phone_label": "आपका मोबाइल नंबर",
        "send": "कोड भेजें",
        "code_label": "{phone} पर भेजा गया 6 अंकों का कोड",
        "verify": "आगे बढ़ें",
        "other_number": "दूसरा नंबर डालें",
        "none": "इस नंबर से कोई WellWish खाता नहीं है।",
        "accounts_intro": "इस नंबर से ये खाते हैं। चुनें कि क्या हटाना है।",
        "patient_name": "WellWish (मरीज़ और परिवार)",
        "patient_what": "{days} दिन बाद आपकी प्रोफ़ाइल, परिवार के सदस्य, पते और दस्तावेज़ हटा "
        "दिए जाएँगे। खाता रखना हो तो उससे पहले ऐप में लॉग इन करें। भुगतान के रिकॉर्ड कानून के "
        "अनुसार रखे जाते हैं।",
        "partner_name": "WellWish Partner (साथी और नर्स)",
        "partner_what": "{days} दिन बाद आपकी प्रोफ़ाइल, फ़ोन नंबर, ईमेल, पता और दस्तावेज़ हटा "
        "दिए जाएँगे। खाता रखना हो तो उससे पहले Partner ऐप में लॉग इन करें। आपके पुराने कामों का "
        "रिकॉर्ड आपकी निजी जानकारी के बिना रहेगा।",
        "login_name": "आपका WellWish लॉगिन",
        "login_what": "इस नंबर के लिए और कुछ सहेजा नहीं गया है। यह तुरंत हटा दिया जाएगा।",
        "logged_out": "आप ऐप से तुरंत लॉग आउट हो जाएँगे।",
        "delete": "यह खाता हटाएँ",
        "confirm": "हाँ, इसे हटाएँ",
        "requested": "हटाने का अनुरोध मिल गया: यह {date} को हटा दिया जाएगा। रखना हो तो उससे "
        "पहले फिर से लॉग इन करें।",
        "deleted": "हटा दिया गया।",
        "help": "मदद चाहिए? WellWish को कॉल करें: {phone}",
        "INVALID_PHONE": "10 अंकों का भारतीय मोबाइल नंबर डालें।",
        "OTP_RATE_LIMITED": "बहुत ज़्यादा कोड माँगे गए। कृपया कुछ देर बाद फिर से कोशिश करें।",
        "OTP_RESEND_TOO_SOON": "नया कोड माँगने से पहले एक मिनट रुकें।",
        "OTP_EXPIRED": "इस कोड की समय-सीमा ख़त्म हो गई है। नया कोड माँगें।",
        "OTP_INVALID": "यह कोड सही नहीं है। SMS देखकर फिर से कोशिश करें।",
        "OTP_TOO_MANY_ATTEMPTS": "बहुत ज़्यादा ग़लत कोशिशें। नया कोड माँगें।",
        "OTP_LOCKED": "बहुत ज़्यादा ग़लत कोड। एक घंटे बाद फिर से कोशिश करें।",
        "SMS_NOT_SENT": "हम SMS नहीं भेज सके। कृपया फिर से कोशिश करें।",
        "ACTIVE_BOOKINGS": "आपकी एक बुकिंग अभी पूरी नहीं हुई है। उसे ऐप में रद्द करें या पूरी "
        "होने तक रुकें, फिर से कोशिश करें।",
        "ACTIVE_JOBS": "आपके पास एक स्वीकार किया हुआ या चल रहा काम है। WellWish से उसे किसी और को "
        "देने को कहें, फिर से कोशिश करें।",
        "EXPIRED": "इस पेज की समय-सीमा ख़त्म हो गई है। कृपया फिर से शुरू करें।",
        "ERROR": "कुछ ग़लत हो गया। कृपया फिर से कोशिश करें।",
    },
    "or": {
        "title": "ଆପଣଙ୍କ WellWish ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ",
        "intro": "WellWish ଆପ୍ ଓ WellWish Partner ଆପ୍ ପାଇଁ। ଏହି ନମ୍ବର ଆପଣଙ୍କର କି ନାହିଁ ଯାଞ୍ଚ "
        "କରିବାକୁ ଆମେ ସେଥିକୁ ଏକ କୋଡ୍ ପଠାଉ।",
        "phone_label": "ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବର",
        "send": "କୋଡ୍ ପଠାନ୍ତୁ",
        "code_label": "{phone}କୁ ପଠାଯାଇଥିବା 6 ଅଙ୍କର କୋଡ୍",
        "verify": "ଆଗକୁ ବଢ଼ନ୍ତୁ",
        "other_number": "ଅନ୍ୟ ନମ୍ବର ଦିଅନ୍ତୁ",
        "none": "ଏହି ନମ୍ବରରେ କୌଣସି WellWish ଆକାଉଣ୍ଟ ନାହିଁ।",
        "accounts_intro": "ଏହି ନମ୍ବରରେ ଏହି ଆକାଉଣ୍ଟଗୁଡ଼ିକ ଅଛି। କ'ଣ ଡିଲିଟ୍ କରିବେ ବାଛନ୍ତୁ।",
        "patient_name": "WellWish (ରୋଗୀ ଓ ପରିବାର)",
        "patient_what": "{days} ଦିନ ପରେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ପରିବାର ସଦସ୍ୟ, ଠିକଣା ଓ ଡକ୍ୟୁମେଣ୍ଟ "
        "ଡିଲିଟ୍ ହେବ। ଆକାଉଣ୍ଟ ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ ଆପ୍‌ରେ ଲଗ୍ ଇନ୍ କରନ୍ତୁ। ଦେୟ ରେକର୍ଡ ଆଇନ "
        "ଅନୁସାରେ ରଖାଯାଏ।",
        "partner_name": "WellWish Partner (ସାଥୀ ଓ ନର୍ସ)",
        "partner_what": "{days} ଦିନ ପରେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ଫୋନ୍ ନମ୍ବର, ଇମେଲ୍, ଠିକଣା ଓ ଡକ୍ୟୁମେଣ୍ଟ "
        "ଡିଲିଟ୍ ହେବ। ଆକାଉଣ୍ଟ ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ Partner ଆପ୍‌ରେ ଲଗ୍ ଇନ୍ କରନ୍ତୁ। ଆପଣଙ୍କ "
        "ପୁରୁଣା କାମର ରେକର୍ଡ ଆପଣଙ୍କ ବ୍ୟକ୍ତିଗତ ତଥ୍ୟ ବିନା ରହିବ।",
        "login_name": "ଆପଣଙ୍କ WellWish ଲଗଇନ୍",
        "login_what": "ଏହି ନମ୍ବର ପାଇଁ ଆଉ କିଛି ସେଭ୍ ହୋଇନାହିଁ। ଏହା ତୁରନ୍ତ ଡିଲିଟ୍ ହେବ।",
        "logged_out": "ଆପଣ ଆପ୍‌ରୁ ତୁରନ୍ତ ଲଗ୍ ଆଉଟ୍ ହେବେ।",
        "delete": "ଏହି ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ",
        "confirm": "ହଁ, ଏହାକୁ ଡିଲିଟ୍ କରନ୍ତୁ",
        "requested": "ଡିଲିଟ୍ ଅନୁରୋଧ ମିଳିଲା: ଏହା {date}ରେ ଡିଲିଟ୍ ହେବ। ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ ପୁଣି ଲଗ୍ ଇନ୍ କରନ୍ତୁ।",
        "deleted": "ଡିଲିଟ୍ ହୋଇଗଲା।",
        "help": "ସାହାଯ୍ୟ ଦରକାର? WellWishକୁ କଲ୍ କରନ୍ତୁ: {phone}",
        "INVALID_PHONE": "10 ଅଙ୍କର ଭାରତୀୟ ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ।",
        "OTP_RATE_LIMITED": "ବହୁତ ଅଧିକ କୋଡ୍ ମଗାଗଲା। ଦୟାକରି କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "OTP_RESEND_TOO_SOON": "ନୂଆ କୋଡ୍ ମାଗିବା ପୂର୍ବରୁ ଏକ ମିନିଟ୍ ଅପେକ୍ଷା କରନ୍ତୁ।",
        "OTP_EXPIRED": "ଏହି କୋଡ୍‌ର ସମୟ ସରିଗଲା। ନୂଆ କୋଡ୍ ମାଗନ୍ତୁ।",
        "OTP_INVALID": "ଏହି କୋଡ୍ ଠିକ୍ ନୁହେଁ। SMS ଦେଖି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "OTP_TOO_MANY_ATTEMPTS": "ବହୁତ ଭୁଲ ଚେଷ୍ଟା। ନୂଆ କୋଡ୍ ମାଗନ୍ତୁ।",
        "OTP_LOCKED": "ବହୁତ ଭୁଲ କୋଡ୍। ଏକ ଘଣ୍ଟା ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "SMS_NOT_SENT": "ଆମେ SMS ପଠାଇ ପାରିଲୁ ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "ACTIVE_BOOKINGS": "ଆପଣଙ୍କର ଗୋଟିଏ ବୁକିଂ ଏପର୍ଯ୍ୟନ୍ତ ଶେଷ ହୋଇନାହିଁ। ଆପ୍‌ରେ ତାକୁ ବାତିଲ୍ "
        "କରନ୍ତୁ କିମ୍ବା ଶେଷ ହେବା ପର୍ଯ୍ୟନ୍ତ ଅପେକ୍ଷା କରନ୍ତୁ, ତା'ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "ACTIVE_JOBS": "ଆପଣଙ୍କର ଗୋଟିଏ ଗ୍ରହଣ କରାଯାଇଥିବା ବା ଚାଲିଥିବା କାମ ଅଛି। WellWishକୁ ତାହା "
        "ଅନ୍ୟଙ୍କୁ ଦେବାକୁ କୁହନ୍ତୁ, ତା'ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
        "EXPIRED": "ଏହି ପୃଷ୍ଠାର ସମୟ ସରିଗଲା। ଦୟାକରି ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ।",
        "ERROR": "କିଛି ଭୁଲ ହେଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।",
    },
}
