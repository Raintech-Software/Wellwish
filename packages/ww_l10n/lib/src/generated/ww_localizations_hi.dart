// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'ww_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class WWLocalizationsHi extends WWLocalizations {
  WWLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'WellWish';

  @override
  String get partnerBadge => 'पार्टनर';

  @override
  String get brandTagline => 'आपकी सेहत, हमारी ज़िम्मेदारी';

  @override
  String get loading => 'लोड हो रहा है…';

  @override
  String get tryAgain => 'फिर से कोशिश करें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया। कृपया फिर से कोशिश करें।';

  @override
  String get noInternet => 'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जांचें और फिर से कोशिश करें।';

  @override
  String get loginWelcomeBack => 'फिर से स्वागत है';

  @override
  String get loginSubtitle => 'जारी रखने के लिए लॉगिन करें';

  @override
  String get createAccountTitle => 'अपना खाता बनाएं';

  @override
  String get createAccountSubtitle => 'शुरू करने के लिए अपना मोबाइल नंबर डालें';

  @override
  String get partnerLoginSubtitle => 'अपने मोबाइल नंबर से लॉगिन करें, या कम्पैनियन या नर्स के रूप में जुड़ें';

  @override
  String get partnerLoginTitle => 'स्वागत है';

  @override
  String get partnerJoinHint => 'नए पार्टनर हैं? आवेदन शुरू करने के लिए अपना नंबर डालें।';

  @override
  String get phoneHint => 'मोबाइल नंबर डालें';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get orDivider => 'या';

  @override
  String get loginWith => 'इससे लॉगिन करें';

  @override
  String get google => 'Google';

  @override
  String get newHere => 'नए हैं?';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get haveAccount => 'पहले से खाता है?';

  @override
  String get login => 'लॉगिन';

  @override
  String get invalidPhone => 'सही 10 अंकों का मोबाइल नंबर डालें';

  @override
  String get otpTitle => 'अपना नंबर सत्यापित करें';

  @override
  String otpSentTo(String phone) {
    return '$phone पर भेजा गया 6 अंकों का कोड डालें';
  }

  @override
  String get changeNumber => 'नंबर बदलें';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String resendIn(int seconds) {
    return '$seconds सेकंड में कोड फिर से भेजें';
  }

  @override
  String get resendCode => 'कोड फिर से भेजें';

  @override
  String get codeResent => 'नया कोड भेज दिया गया';

  @override
  String otpWrong(int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts कोशिशें बाकी हैं।',
      one: '1 कोशिश बाकी है।',
    );
    return 'यह कोड सही नहीं है। $_temp0';
  }

  @override
  String get otpExpired => 'यह कोड समाप्त हो गया है। \'कोड फिर से भेजें\' दबाएं।';

  @override
  String get otpTooManyAttempts => 'बहुत सारी गलत कोशिशें। नया कोड पाने के लिए \'कोड फिर से भेजें\' दबाएं।';

  @override
  String get otpLocked => 'बहुत सारे गलत कोड। कृपया एक घंटे बाद फिर से कोशिश करें।';

  @override
  String get otpRateLimited => 'बहुत सारे कोड मांगे गए। कृपया बाद में कोशिश करें।';

  @override
  String get smsNotSent => 'हम SMS नहीं भेज सके। कृपया फिर से कोशिश करें।';

  @override
  String get accountBlocked => 'यह खाता ब्लॉक है। कृपया WellWish सहायता से संपर्क करें।';

  @override
  String get googleFailed => 'Google से साइन-इन नहीं हुआ। कृपया फिर से कोशिश करें।';

  @override
  String get googleVerifyPhone => 'Google से साइन-इन पूरा करने के लिए एक बार अपना मोबाइल नंबर सत्यापित करें।';

  @override
  String get profileSetupTitle => 'अपने बारे में बताएं';

  @override
  String get profileSetupSubtitle => 'इससे आपके साथी या नर्स को आपकी अच्छी देखभाल करने में मदद मिलती है।';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get fullNameHint => 'जैसा आपके पहचान पत्र पर है';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get selectDate => 'तारीख चुनें';

  @override
  String get gender => 'लिंग';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderOther => 'अन्य';

  @override
  String get language => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageOdia => 'ଓଡ଼ିଆ';

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get nameRequired => 'कृपया अपना पूरा नाम डालें';

  @override
  String get dobRequired => 'कृपया अपनी जन्म तिथि चुनें';

  @override
  String get genderRequired => 'कृपया अपना लिंग चुनें';

  @override
  String get consentTitle => 'शुरू करने से पहले';

  @override
  String get consentSubtitle => 'WellWish का उपयोग करने के लिए कृपया पढ़ें और स्वीकार करें।';

  @override
  String get consentTerms => 'मैं उपयोग की शर्तें स्वीकार करता/करती हूं';

  @override
  String get consentTermsDetail => 'बुकिंग, भुगतान, रद्द करना और रिफंड कैसे काम करते हैं।';

  @override
  String get consentPrivacy => 'मैं गोपनीयता नीति स्वीकार करता/करती हूं';

  @override
  String get consentPrivacyDetail => 'आपका डेटा भारत में रहता है और कभी बेचा नहीं जाता।';

  @override
  String get consentHealthData => 'मैं WellWish को अपने स्वास्थ्य दस्तावेज़ रखने की अनुमति देता/देती हूं';

  @override
  String get consentHealthDataDetail =>
      'ये केवल आपकी बुकिंग के लिए तय साथी या नर्स को, विज़िट के दौरान ही दिखाए जाते हैं।';

  @override
  String get agreeAndContinue => 'सहमत हैं, आगे बढ़ें';

  @override
  String get locationTitle => 'अपने पास के अस्पताल खोजें';

  @override
  String get locationBody =>
      'लोकेशन की अनुमति दें ताकि हम आपके पास के अस्पताल और क्लिनिक दिखा सकें। हम आपको ट्रैक नहीं करते।';

  @override
  String get allowLocation => 'लोकेशन की अनुमति दें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String helloName(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get homeTagline => 'अपना ध्यान रखें। आप मायने रखते हैं!';

  @override
  String get heroTitle => 'आपकी सेहत, हमारी प्राथमिकता';

  @override
  String get heroSubtitle => 'WellWish के साथ सबसे अच्छी देखभाल पाएं';

  @override
  String get tileDoctors => 'डॉक्टर';

  @override
  String get tileBookCompanion => 'साथी बुक करें';

  @override
  String get tileBookNurse => 'नर्स बुक करें';

  @override
  String get tileMedicalReports => 'मेडिकल रिपोर्ट';

  @override
  String get tileFamily => 'परिवार';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get comingSoonBody => 'WellWish का यह हिस्सा अगले अपडेट में खुलेगा।';

  @override
  String get navHome => 'होम';

  @override
  String get navDoctors => 'डॉक्टर';

  @override
  String get navReports => 'रिपोर्ट';

  @override
  String get navFamily => 'परिवार';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get verified => 'सत्यापित';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get myBookings => 'मेरी बुकिंग';

  @override
  String get myReports => 'मेरी रिपोर्ट';

  @override
  String get familyMembers => 'परिवार के सदस्य';

  @override
  String get helpSupport => 'सहायता';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutEverywhere => 'सभी डिवाइस से लॉग आउट करें';

  @override
  String get logoutConfirmTitle => 'लॉग आउट करें?';

  @override
  String get logoutConfirmBody => 'फिर से लॉगिन करने के लिए आपको OTP चाहिए होगा।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get sessionExpired => 'आपका सत्र समाप्त हो गया। कृपया फिर से लॉगिन करें।';

  @override
  String get loggedInElsewhere => 'आपने दूसरे फ़ोन पर लॉगिन किया, इसलिए यहां से लॉग आउट कर दिया गया।';

  @override
  String get updateTitle => 'WellWish अपडेट करें';

  @override
  String get updateBody => 'नया संस्करण उपलब्ध है। जारी रखने के लिए कृपया ऐप अपडेट करें।';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get partnerRegisterTitle => 'WellWish पार्टनर बनें';

  @override
  String get partnerRegisterBody =>
      'साथी और नर्स के लिए रजिस्ट्रेशन अगले अपडेट में खुलेगा। तब आप यहां अपनी जानकारी और दस्तावेज़ जोड़ सकेंगे।';

  @override
  String loggedInAs(String phone) {
    return '$phone से लॉगिन हैं';
  }

  @override
  String get registerRoleTitle => 'आप कौन सा काम करेंगे?';

  @override
  String get registerRoleSubtitle => 'आवेदन भेजने तक आप इसे बदल सकते हैं।';

  @override
  String get roleCompanion => 'साथी';

  @override
  String get roleCompanionBody =>
      'मरीज़ों को डॉक्टर के पास ले जाएँ, अस्पताल में मदद करें, दवा लाएँ और घर पर बुज़ुर्गों की देखभाल करें।';

  @override
  String get roleNurse => 'नर्स';

  @override
  String get roleNurseBody =>
      'घर पर इंजेक्शन, घाव की ड्रेसिंग, आईवी ड्रिप और नर्सिंग शिफ्ट। नर्सिंग योग्यता और काउंसिल पंजीकरण ज़रूरी है।';

  @override
  String get registerHubSubtitle => 'ये चरण पूरे करें, फिर अपना आवेदन जाँच के लिए भेजें।';

  @override
  String get stepRole => 'काम का प्रकार';

  @override
  String get stepContact => 'दूसरा नंबर और ईमेल';

  @override
  String get stepProfile => 'आपकी प्रोफ़ाइल';

  @override
  String get stepDocuments => 'दस्तावेज़';

  @override
  String get stepDone => 'पूरा';

  @override
  String get stepTodo => 'बाकी';

  @override
  String documentsProgress(int done, int total) {
    return '$total में से $done अपलोड';
  }

  @override
  String get submitForReview => 'जाँच के लिए भेजें';

  @override
  String get submitHint => 'आवेदन भेजने के लिए सभी चरण पूरे करें।';

  @override
  String get change => 'बदलें';

  @override
  String get save => 'सेव करें';

  @override
  String get contactTitle => 'फ़ोन और ईमेल';

  @override
  String get loginNumber => 'लॉगिन नंबर';

  @override
  String get alternateNumber => 'दूसरा नंबर';

  @override
  String get alternateHelp =>
      'दूसरा नंबर, जैसे परिवार के किसी सदस्य का। अगर आपसे बात न हो पाए तो WellWish इस पर कॉल करेगा।';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String codeSentTo(String target) {
    return '$target पर भेजा गया 6 अंकों का कोड डालें';
  }

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get emailHelp => 'जाँच के लिए हम 6 अंकों का कोड ईमेल करेंगे।';

  @override
  String get invalidEmail => 'सही ईमेल डालें।';

  @override
  String get yourPhoto => 'आपकी फ़ोटो';

  @override
  String get photoHelp => 'आपके चेहरे की साफ़ फ़ोटो। मरीज़ इसे देखेंगे।';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get choosePdf => 'PDF चुनें';

  @override
  String get homeAddress => 'घर का पता';

  @override
  String get homeAddressHint => 'मकान, गली, इलाका, पिन कोड';

  @override
  String get homeLocation => 'घर की लोकेशन';

  @override
  String get homeLocationHelp => 'घर पर रहकर बटन दबाएँ। इससे WellWish आपको पास के काम दे पाएगा।';

  @override
  String get useCurrentLocation => 'मेरी अभी की लोकेशन लें';

  @override
  String get locationSaved => 'लोकेशन जुड़ गई';

  @override
  String get locationDenied => 'लोकेशन नहीं मिली। फ़ोन की सेटिंग में WellWish को लोकेशन की अनुमति दें।';

  @override
  String get languagesYouSpeak => 'आप कौन सी भाषाएँ बोलते हैं';

  @override
  String get skillsLabel => 'कौशल';

  @override
  String get emergencyContact => 'आपातकालीन संपर्क';

  @override
  String get emergencyName => 'उनका नाम';

  @override
  String get emergencyPhone => 'उनका फ़ोन नंबर';

  @override
  String get photoRequired => 'अपनी फ़ोटो जोड़ें।';

  @override
  String get addressRequired => 'अपने घर का पता डालें।';

  @override
  String get locationRequired => 'अपने घर की लोकेशन जोड़ें।';

  @override
  String get languagesRequired => 'कम से कम एक भाषा चुनें।';

  @override
  String get fixMarkedFields => 'कुछ जानकारी छूट गई है। लाल रंग में दिखे खाने देखें।';

  @override
  String get emergencyRequired => 'आपातकालीन संपर्क डालें।';

  @override
  String get languageBengali => 'बांग्ला';

  @override
  String get languageTelugu => 'तेलुगु';

  @override
  String get skillElderlyCare => 'बुज़ुर्ग देखभाल';

  @override
  String get skillWheelchair => 'व्हीलचेयर सहायता';

  @override
  String get skillPaperwork => 'अस्पताल का कागज़ी काम';

  @override
  String get skillTwoWheeler => 'दोपहिया वाहन';

  @override
  String get skillCar => 'कार चलाना';

  @override
  String get skillInjections => 'इंजेक्शन';

  @override
  String get skillDressing => 'घाव की ड्रेसिंग';

  @override
  String get skillIvDrip => 'आईवी ड्रिप';

  @override
  String get skillPostSurgery => 'ऑपरेशन के बाद देखभाल';

  @override
  String get documentsSubtitle => 'फ़ोटो साफ़ और पढ़ने लायक हों। PDF भी चलेगी।';

  @override
  String get docRequired => 'ज़रूरी';

  @override
  String get docOptional => 'वैकल्पिक';

  @override
  String get docMissing => 'अपलोड नहीं';

  @override
  String get docPending => 'जाँच हो रही है';

  @override
  String get docApproved => 'स्वीकृत';

  @override
  String get docRejected => 'बदलाव ज़रूरी';

  @override
  String get docExpired => 'समाप्त';

  @override
  String get upload => 'अपलोड करें';

  @override
  String get uploadAgain => 'फिर से अपलोड करें';

  @override
  String get uploadNew => 'नया अपलोड करें';

  @override
  String get uploading => 'अपलोड हो रहा है…';

  @override
  String get documentNumber => 'दस्तावेज़ पर लिखा नंबर';

  @override
  String get aadhaarNumberHelp => '12 अंक। सिर्फ़ आख़िरी 4 सेव होते हैं।';

  @override
  String get panNumberHelp => '10 अक्षर, जैसे ABCDE1234F। सिर्फ़ आख़िरी 4 सेव होते हैं।';

  @override
  String get validTill => 'कब तक मान्य';

  @override
  String validTillDate(String date) {
    return '$date तक मान्य';
  }

  @override
  String get numberRequired => 'नंबर डालें।';

  @override
  String get expiryRequired => 'मान्यता की तारीख चुनें।';

  @override
  String get renewalPending => 'नया दस्तावेज़ जाँचा जा रहा है';

  @override
  String renewalRejected(String reason) {
    return 'नया स्वीकार नहीं हुआ: $reason';
  }

  @override
  String get cameraOnlyHelp => 'अभी सामने वाले कैमरे से लें।';

  @override
  String get statusTitle => 'आवेदन की स्थिति';

  @override
  String get statusSubmitted => 'भेजा गया';

  @override
  String get statusUnderReview => 'जाँच में';

  @override
  String get statusChangesNeeded => 'बदलाव ज़रूरी';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusSubmittedBody => 'हमें आपका आवेदन मिल गया है। हम जल्द ही आपके दस्तावेज़ जाँचेंगे।';

  @override
  String get statusUnderReviewBody => 'WellWish टीम का सदस्य अभी आपके दस्तावेज़ जाँच रहा है।';

  @override
  String get statusChangesBody =>
      'कुछ दस्तावेज़ों में बदलाव चाहिए। नीचे कारण देखें, फिर से अपलोड करें और दोबारा भेजें।';

  @override
  String get fixDocuments => 'दस्तावेज़ ठीक करें';

  @override
  String get noteFromWellWish => 'WellWish की ओर से नोट';

  @override
  String get statusRejectedTitle => 'आवेदन स्वीकृत नहीं हुआ';

  @override
  String get statusSuspendedTitle => 'खाता रोका गया';

  @override
  String get statusSuspendedBody => 'अभी आपको काम नहीं मिलेगा। ज़्यादा जानने के लिए WellWish सहायता को कॉल करें।';

  @override
  String get suspendedExpiredBody =>
      'एक दस्तावेज़ समाप्त हो गया है। नया अपलोड करें; स्वीकृत होते ही आप फिर काम कर सकेंगे।';

  @override
  String get statusDeactivatedTitle => 'खाता बंद';

  @override
  String get callSupport => 'WellWish सहायता को कॉल करें';

  @override
  String get refresh => 'रिफ़्रेश करें';

  @override
  String get navJobs => 'काम';

  @override
  String get youAreApproved => 'आप स्वीकृत WellWish पार्टनर हैं';

  @override
  String get availableToday => 'आज उपलब्ध';

  @override
  String get availableTodayHelp => 'जब आज काम ले सकें तब चालू करें।';

  @override
  String get verifyContactTitle => 'अपनी संपर्क जानकारी सत्यापित करें';

  @override
  String get verifyContactBody => 'अपना दूसरा नंबर और ईमेल सत्यापित करें ताकि WellWish हमेशा आपसे संपर्क कर सके।';

  @override
  String get noJobsYet => 'अभी कोई काम नहीं';

  @override
  String get noJobsBody => 'WellWish के काम यहाँ दिखेंगे।';

  @override
  String get profileAndDocuments => 'प्रोफ़ाइल और दस्तावेज़';

  @override
  String get notificationsTitle => 'सूचनाएँ';

  @override
  String get noNotifications => 'अभी कोई संदेश नहीं।';

  @override
  String get notificationsKept => 'यहाँ पिछले 30 दिनों के संदेश रहते हैं।';

  @override
  String notificationsUnread(int count) {
    return 'सूचनाएँ, $count अपठित';
  }

  @override
  String get errSameAsPrimary => 'लॉगिन नंबर से अलग नंबर डालें।';

  @override
  String get errEmailTaken => 'यह ईमेल कोई दूसरा पार्टनर इस्तेमाल कर रहा है।';

  @override
  String get errCodeWrong => 'कोड सही नहीं है। जाँचकर फिर कोशिश करें।';

  @override
  String get errWaitBeforeResend => 'दूसरा कोड माँगने से पहले थोड़ा रुकें।';

  @override
  String get errEmailNotSent => 'ईमेल नहीं भेज पाए। फिर से कोशिश करें।';

  @override
  String get errTooYoung => 'पार्टनर की उम्र 18 साल या उससे ज़्यादा होनी चाहिए।';

  @override
  String get errEmergencyIsYou => 'आपातकालीन संपर्क कोई दूसरा व्यक्ति होना चाहिए।';

  @override
  String get errInvalidAadhaar => '12 अंकों का आधार नंबर डालें।';

  @override
  String get errInvalidPan => '10 अक्षरों का पैन डालें।';

  @override
  String get errAlreadyExpired => 'यह दस्तावेज़ पहले ही समाप्त हो चुका है।';

  @override
  String get errInvalidFile => 'यह फ़ाइल नहीं चलेगी। साफ़ फ़ोटो या PDF चुनें।';

  @override
  String get errFileTooLarge => 'फ़ाइल बहुत बड़ी है (ज़्यादा से ज़्यादा 10 MB)।';

  @override
  String get errDocumentsMissing => 'पहले सभी ज़रूरी दस्तावेज़ अपलोड करें।';

  @override
  String get errDetailsMissing => 'पहले फ़ोन, ईमेल और प्रोफ़ाइल पूरी करें।';

  @override
  String get errNotEditable => 'आवेदन की जाँच के दौरान इसे बदला नहीं जा सकता।';

  @override
  String get locationOff => 'लोकेशन बंद है। फ़ोन में लोकेशन चालू करें, फिर दोबारा कोशिश करें।';

  @override
  String get familyTitle => 'परिवार';

  @override
  String get familyIntroTitle => 'अपनों से जुड़े रहें';

  @override
  String get familyIntroBody =>
      'माता-पिता और रिश्तेदारों को जोड़ें और उनके लिए देखभाल बुक करें, चाहे वे दूसरे शहर में हों।';

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String ageYears(int age) {
    return '$age वर्ष';
  }

  @override
  String get noFamilyYet => 'अभी कोई परिवार सदस्य नहीं';

  @override
  String get relationSelf => 'आप';

  @override
  String get relationMother => 'माँ';

  @override
  String get relationFather => 'पिता';

  @override
  String get relationGrandmother => 'दादी / नानी';

  @override
  String get relationGrandfather => 'दादा / नाना';

  @override
  String get relationSpouse => 'पति / पत्नी';

  @override
  String get relationChild => 'बच्चा';

  @override
  String get relationSibling => 'भाई / बहन';

  @override
  String get relationOther => 'अन्य';

  @override
  String get addMemberTitle => 'परिवार सदस्य जोड़ें';

  @override
  String get editDetailsTitle => 'विवरण बदलें';

  @override
  String get relation => 'रिश्ता';

  @override
  String get relationRequired => 'चुनें कि वे आपके क्या लगते हैं।';

  @override
  String get theirPhone => 'उनका मोबाइल नंबर (वैकल्पिक)';

  @override
  String get theirPhoneHelp => 'उन्हें साथी का नाम और विज़िट OTP SMS से मिलेगा।';

  @override
  String get languageTheySpeak => 'वे कौन-सी भाषा बोलते हैं';

  @override
  String get healthNotes => 'स्वास्थ्य जानकारी';

  @override
  String get healthNotesHelp => 'इसे केवल काम पर आए साथी या नर्स ही देखते हैं।';

  @override
  String get conditions => 'बीमारियाँ';

  @override
  String get conditionsHint => 'जैसे डायबिटीज़, बीपी';

  @override
  String get allergies => 'एलर्जी';

  @override
  String get mobility => 'चलना-फिरना';

  @override
  String get mobilityWalksAlone => 'खुद चलते हैं';

  @override
  String get mobilityNeedsSupport => 'सहारे की ज़रूरत';

  @override
  String get mobilityWheelchair => 'व्हीलचेयर';

  @override
  String get sensoryNotes => 'सुनना या देखना';

  @override
  String get sensoryHint => 'जैसे कम सुनाई देता है';

  @override
  String get emergencyContactHelp => 'अपना नंबर इस्तेमाल करने के लिए खाली छोड़ें।';

  @override
  String get emergencyIncomplete => 'नाम और फ़ोन दोनों दें, या दोनों खाली छोड़ें।';

  @override
  String get consentMember =>
      'मेरे पास उनकी अनुमति है कि ये जानकारी सहेजी जाए और उनकी देखभाल के लिए WellWish पार्टनर के साथ साझा की जाए।';

  @override
  String get consentRequired => 'उनकी अनुमति की पुष्टि के लिए टिक करें।';

  @override
  String get notGiven => 'नहीं दिया';

  @override
  String get detailsTitle => 'विवरण';

  @override
  String get mobileLabel => 'मोबाइल';

  @override
  String get addressesTitle => 'पते';

  @override
  String get addAddress => 'पता जोड़ें';

  @override
  String get noAddresses => 'अभी कोई पता नहीं सहेजा गया।';

  @override
  String get noDocumentsYet => 'अभी कोई दस्तावेज़ नहीं।';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get bookingsTitle => 'बुकिंग';

  @override
  String get noBookingsYet => 'अभी कोई बुकिंग नहीं।';

  @override
  String bookForName(String name) {
    return '$name के लिए बुक करें';
  }

  @override
  String get edit => 'बदलें';

  @override
  String get remove => 'हटाएँ';

  @override
  String get removeMember => 'परिवार से हटाएँ';

  @override
  String removeMemberTitle(String name) {
    return '$name को हटाएँ?';
  }

  @override
  String get removeMemberBody => 'वे ऐप से छिप जाएँगे। पुरानी बुकिंग का रिकॉर्ड बना रहेगा।';

  @override
  String get outsideServiceArea => 'WellWish अभी इस इलाके में सेवा नहीं देता।';

  @override
  String get addAddressTitle => 'पता जोड़ें';

  @override
  String get editAddressTitle => 'पता बदलें';

  @override
  String addressForName(String name) {
    return '$name के लिए';
  }

  @override
  String get mapHelp => 'नक्शे को खिसकाएँ ताकि पिन घर पर आ जाए।';

  @override
  String get addressLabel => 'इस पते का नाम';

  @override
  String get addressLabelHint => 'जैसे घर';

  @override
  String get labelHome => 'घर';

  @override
  String get labelWork => 'ऑफ़िस';

  @override
  String get addressLine => 'पूरा पता';

  @override
  String get landmark => 'पास की पहचान (वैकल्पिक)';

  @override
  String get addressNotes => 'साथी के लिए नोट (वैकल्पिक)';

  @override
  String get addressNotesHint => 'गेट, मंज़िल, लिफ़्ट';

  @override
  String get labelRequired => 'पते को नाम दें।';

  @override
  String get addressLineRequired => 'पूरा पता लिखें।';

  @override
  String get savedOutsideArea => 'सहेज लिया। WellWish अभी इस इलाके में सेवा नहीं देता, इसलिए यहाँ बुकिंग नहीं होगी।';

  @override
  String get mapAttribution => '© OpenStreetMap योगदानकर्ता';

  @override
  String get tabAll => 'सभी';

  @override
  String get tabReports => 'रिपोर्ट';

  @override
  String get tabPrescriptions => 'पर्चे';

  @override
  String get everyone => 'सभी लोग';

  @override
  String get uploadDocument => 'दस्तावेज़ अपलोड करें';

  @override
  String get docTypePrescription => 'पर्चा';

  @override
  String get docTypeLabReport => 'लैब रिपोर्ट';

  @override
  String get docTypeScan => 'एक्स-रे / स्कैन';

  @override
  String get docTypeDischarge => 'डिस्चार्ज समरी';

  @override
  String get docTypeId => 'पहचान पत्र';

  @override
  String get docTypeOther => 'अन्य';

  @override
  String get forWhom => 'किसके लिए';

  @override
  String get documentType => 'प्रकार';

  @override
  String get documentTitle => 'नाम';

  @override
  String get documentTitleHint => 'जैसे ब्लड टेस्ट';

  @override
  String get documentDate => 'दस्तावेज़ की तारीख (वैकल्पिक)';

  @override
  String get chooseFile => 'फ़ाइल';

  @override
  String get fileChosen => 'फ़ाइल तैयार';

  @override
  String get fileRequired => 'फ़ोटो या PDF चुनें।';

  @override
  String get titleRequired => 'दस्तावेज़ को नाम दें।';

  @override
  String get view => 'देखें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get deleteDocumentTitle => 'यह दस्तावेज़ हटाएँ?';

  @override
  String get deleteDocumentBody => 'फ़ाइल हमेशा के लिए हट जाएगी।';

  @override
  String storageUsed(String used, String total) {
    return '$total में से $used इस्तेमाल';
  }

  @override
  String get noDocumentsBody => 'पर्चे और रिपोर्ट एक बार अपलोड करें और हर बुकिंग में इस्तेमाल करें।';

  @override
  String get loadMore => 'और देखें';

  @override
  String get openInPhone => 'आपके फ़ोन के PDF ऐप में खुलेगा।';

  @override
  String get cannotOpen => 'यह फ़ाइल यहाँ नहीं खुल सकती।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get notificationsLabel => 'सूचनाएँ';

  @override
  String get notificationsHelp => 'WellWish की सूचनाएँ अपने फ़ोन की सेटिंग्स में चालू या बंद करें।';

  @override
  String get openPhoneSettings => 'फ़ोन सेटिंग्स खोलें';

  @override
  String get deleteAccount => 'मेरा खाता हटाएँ';

  @override
  String get deleteAccountHelp => 'आपकी प्रोफ़ाइल, परिवार, पते और दस्तावेज़ हटा देता है।';

  @override
  String get deleteAccountTitle => 'अपना खाता हटाएँ?';

  @override
  String deleteAccountBody(int days) {
    return 'आप अभी लॉग आउट हो जाएँगे। $days दिन बाद आपकी प्रोफ़ाइल, परिवार के सदस्य, पते और दस्तावेज़ हटा दिए जाएँगे। खाता रखना हो तो उससे पहले फिर से लॉग इन करें। भुगतान के रिकॉर्ड कानून के अनुसार रखे जाते हैं।';
  }

  @override
  String get deleteAccountConfirm => 'खाता हटाएँ';

  @override
  String get accountDeletionRequested => 'आपका खाता जल्द हट जाएगा। रखना हो तो फिर से लॉग इन करें।';

  @override
  String get errTooManyMembers => 'आप जितने परिवार सदस्य जोड़ सकते हैं, उतने जोड़ चुके हैं।';

  @override
  String get errTooManyAddresses => 'हर व्यक्ति के लिए 10 पते तक। पहले कोई पुराना पता हटाएँ।';

  @override
  String get errStorageFull => 'आपके दस्तावेज़ पूरे 200 MB इस्तेमाल कर रहे हैं। पहले कुछ पुराने हटाएँ।';

  @override
  String get errDateInFuture => 'तारीख भविष्य की नहीं हो सकती।';

  @override
  String get errNotFound => 'यह हटा दिया गया है या आपका नहीं है।';

  @override
  String get memberNameHint => 'उनका पूरा नाम';

  @override
  String get spokenOdia => 'ओड़िया';

  @override
  String get spokenHindi => 'हिन्दी';

  @override
  String get spokenEnglish => 'अंग्रेज़ी';

  @override
  String get spokenBengali => 'बांग्ला';

  @override
  String get spokenTelugu => 'तेलुगु';

  @override
  String get alsoDeleteDocuments => 'उनके मेडिकल दस्तावेज़ भी हटाएँ';

  @override
  String get pinRequired => 'नक्शे को खिसकाएँ ताकि पिन घर पर आ जाए, या अपनी मौजूदा जगह इस्तेमाल करें।';

  @override
  String get notificationsLater => 'फ़ोन पर सूचनाएँ आने वाले अपडेट में आएँगी। तब तक ऐप में देखें।';

  @override
  String get photoTooLarge => 'यह फ़ोटो बहुत बड़ी है (अधिकतम 5 MB)।';

  @override
  String accountDeletionOn(String date) {
    return 'आपका खाता $date को हट जाएगा। रखना हो तो उससे पहले फिर से लॉग इन करें।';
  }

  @override
  String get tabDoctors => 'डॉक्टर';

  @override
  String get tabHospitals => 'अस्पताल';

  @override
  String get searchDoctorsHint => 'डॉक्टर या विशेषज्ञता खोजें…';

  @override
  String get searchHospitalsHint => 'अस्पताल, इलाका या डॉक्टर खोजें…';

  @override
  String get allSpecialities => 'सभी';

  @override
  String get viewProfile => 'प्रोफ़ाइल देखें';

  @override
  String get noDoctorsFound => 'कोई डॉक्टर नहीं मिला';

  @override
  String get noHospitalsFound => 'कोई अस्पताल नहीं मिला';

  @override
  String get tryAnotherSearch => 'कोई और खोज या विशेषज्ञता आज़माएँ।';

  @override
  String kmAway(String km) {
    return '$km किमी दूर';
  }

  @override
  String hospitalsWithin(int km) {
    return '$km किमी के अंदर के अस्पताल';
  }

  @override
  String get hospitalsAll => 'सभी अस्पताल';

  @override
  String get hospitalsNoLocation => 'सबसे पास के अस्पताल पहले देखने के लिए लोकेशन की अनुमति दें।';

  @override
  String get showMap => 'नक्शा';

  @override
  String get showList => 'सूची';

  @override
  String get hospitalTypeHospital => 'अस्पताल';

  @override
  String get hospitalTypeClinic => 'क्लिनिक';

  @override
  String get hospitalTypeDiagnostic => 'जाँच केंद्र';

  @override
  String get opdHours => 'ओपीडी समय';

  @override
  String get departments => 'विभाग';

  @override
  String get doctorsHere => 'यहाँ के डॉक्टर';

  @override
  String doctorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डॉक्टर',
      one: '1 डॉक्टर',
      zero: 'कोई डॉक्टर नहीं',
    );
    return '$_temp0';
  }

  @override
  String get callLabel => 'कॉल करें';

  @override
  String get bookCompanionHere => 'इस अस्पताल के लिए साथी बुक करें';

  @override
  String get bookCompanionForDoctor => 'इस डॉक्टर के लिए साथी बुक करें';

  @override
  String get qualifications => 'योग्यता';

  @override
  String get opdDays => 'ओपीडी के दिन और समय';

  @override
  String get doctorSpeaks => 'भाषाएँ';

  @override
  String get doctorHospitals => 'यहाँ मरीज़ देखते हैं';

  @override
  String get chooseService => 'अपनी ज़रूरत की सेवा चुनें';

  @override
  String totalPrice(String amount) {
    return 'कुल $amount';
  }

  @override
  String get prescriptionNeeded => 'पर्चा ज़रूरी';

  @override
  String durationMinutes(int minutes) {
    return 'लगभग $minutes मिनट';
  }

  @override
  String durationHours(int hours) {
    return 'लगभग $hours घंटे';
  }

  @override
  String bookingAt(String place) {
    return '$place के लिए';
  }

  @override
  String get noServices => 'अभी कोई सेवा उपलब्ध नहीं है।';

  @override
  String get chooseBookingType => 'आप क्या बुक करना चाहते हैं?';

  @override
  String get visitDetailsTitle => 'विज़िट की जानकारी';

  @override
  String get hospitalLabel => 'अस्पताल';

  @override
  String get hospitalOptionalLabel => 'अस्पताल या दवा दुकान (वैकल्पिक)';

  @override
  String get chooseHospital => 'अस्पताल चुनें';

  @override
  String get hospitalNotListed => 'मेरा अस्पताल सूची में नहीं है';

  @override
  String get hospitalTextLabel => 'अस्पताल का नाम और इलाका';

  @override
  String get hospitalTextHint => 'जैसे सिटी केयर अस्पताल, पटिया';

  @override
  String get doctorLabel => 'डॉक्टर';

  @override
  String get doctorNotSure => 'पता नहीं';

  @override
  String get dateLabel => 'तारीख़';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get pickADate => 'तारीख़ चुनें';

  @override
  String get appointmentTimeLabel => 'डॉक्टर से मिलने का समय';

  @override
  String get appointmentTimeHint => 'सेट करने के लिए टैप करें (वैकल्पिक)';

  @override
  String get pickupTimeLabel => 'पिकअप का समय';

  @override
  String get visitTimeLabel => 'विज़िट का समय';

  @override
  String get startTimeLabel => 'शुरू होने का समय';

  @override
  String pickupSuggested(int minutes) {
    return 'पिकअप मिलने के समय से $minutes मिनट पहले सुझाया गया है। आप इसे बदल सकते हैं।';
  }

  @override
  String get noTimesLeft => 'इस तारीख़ पर कोई समय नहीं बचा। दूसरी तारीख़ चुनें।';

  @override
  String get timesInIst => 'समय भारतीय समय (IST) में हैं।';

  @override
  String get notesLabel => 'नोट (वैकल्पिक)';

  @override
  String get notesHint => 'व्हीलचेयर, भाषा, गेट नंबर…';

  @override
  String get nextLabel => 'आगे';

  @override
  String get chooseMemberRequired => 'चुनें कि बुकिंग किसके लिए है।';

  @override
  String get hospitalRequired => 'अस्पताल चुनें या उसका नाम लिखें।';

  @override
  String get timeRequired => 'समय चुनें।';

  @override
  String get appointmentAfterPickup => 'मिलने का समय पिकअप के बाद होना चाहिए।';

  @override
  String get addressStepTitle => 'पता';

  @override
  String get pickupAddressHelp => 'साथी उन्हें यहाँ से लेगा।';

  @override
  String get homeVisitAddressHelp => 'जहाँ विज़िट होगी।';

  @override
  String get errandAddressHelp => 'साथी सामान यहाँ लाएगा।';

  @override
  String addressesOfName(String name) {
    return '$name के पते';
  }

  @override
  String get otherAddresses => 'दूसरे सहेजे पते';

  @override
  String get addressRequiredToBook => 'पता चुनें।';

  @override
  String get attachDocumentsTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get attachDocumentsHelp =>
      'साथ ले जाने वाली रिपोर्ट या पर्चे चुनें। इन्हें सिर्फ़ तय किया गया पार्टनर देखेगा।';

  @override
  String get prescriptionRequiredHelp => 'इस सेवा के लिए पर्चा ज़रूरी है।';

  @override
  String get attachPrescription => 'कृपया पर्चा जोड़ें।';

  @override
  String noDocumentsForName(String name) {
    return '$name के अभी कोई दस्तावेज़ नहीं हैं।';
  }

  @override
  String get reviewTitle => 'जाँचें और भुगतान करें';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get whenLabel => 'कब';

  @override
  String get whereLabel => 'कहाँ';

  @override
  String get documentsLabel => 'दस्तावेज़';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दस्तावेज़',
      one: '1 दस्तावेज़',
      zero: 'कोई नहीं',
    );
    return '$_temp0';
  }

  @override
  String get priceTotal => 'कुल';

  @override
  String get payNowFee => 'अभी भुगतान (बुकिंग शुल्क)';

  @override
  String get payCompanionAfter => 'विज़िट के बाद साथी को दें';

  @override
  String get payNurseAfter => 'विज़िट के बाद नर्स को दें';

  @override
  String get extrasNote => 'कैब या ऑटो का किराया और ज़्यादा समय का पैसा सीधे पार्टनर से तय करें।';

  @override
  String get paidInFullNote => 'ऐप में पूरा भुगतान हो गया: विज़िट के बाद साथी या नर्स को कुछ नहीं देना है।';

  @override
  String cancellationRule(int percent) {
    return 'पार्टनर के निकलने से पहले रद्द करने पर बुकिंग शुल्क का $percent% वापस मिलेगा।';
  }

  @override
  String payAmount(String amount) {
    return '$amount भुगतान करें';
  }

  @override
  String get errTimeNotAvailable => 'यह समय अब उपलब्ध नहीं है। दूसरा समय चुनें।';

  @override
  String get errPrescriptionRequired => 'इस सेवा के लिए पर्चा ज़रूरी है। कृपया जोड़ें।';

  @override
  String get errOutsideServiceArea => 'हम अभी इस पते पर सेवा नहीं देते। दूसरा पता चुनें।';

  @override
  String get errTooManyUnpaid => 'आपकी कई बुकिंग भुगतान का इंतज़ार कर रही हैं। थोड़ी देर बाद कोशिश करें।';

  @override
  String get errTooManyRequests => 'एक मिनट में बहुत सारे बदलाव हो गए। कृपया थोड़ा रुककर फिर कोशिश करें।';

  @override
  String get errInvalidBooking => 'बुकिंग की जानकारी जाँचें।';

  @override
  String get errMemberHasBookings => 'इनकी एक बुकिंग अभी पूरी नहीं हुई है। पहले उसे रद्द करें।';

  @override
  String get errActiveBookings => 'आपकी एक बुकिंग अभी पूरी नहीं हुई है। उसे रद्द करें या पूरा होने दें।';

  @override
  String get bookingSavedTitle => 'बुकिंग सहेजी गई';

  @override
  String bookingSavedBody(String code) {
    return 'ऑनलाइन भुगतान अभी उपलब्ध नहीं है। आपकी बुकिंग $code सहेजी गई है और भुगतान का इंतज़ार कर रही है।';
  }

  @override
  String get backToHome => 'होम पर जाएँ';

  @override
  String bookingCode(String code) {
    return 'बुकिंग $code';
  }

  @override
  String get nextBooking => 'अगली बुकिंग';

  @override
  String get statusPendingPayment => 'भुगतान बाकी';

  @override
  String get statusAssigning => 'बुक हो गया। हम आपका पार्टनर तय कर रहे हैं।';

  @override
  String get statusAssigned => 'पार्टनर तय हो गया';

  @override
  String get statusInProgress => 'चल रहा है';

  @override
  String get statusCompleted => 'पूरा हुआ';

  @override
  String get statusNoShow => 'मरीज़ नहीं मिले';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusExpired => 'समय पर भुगतान नहीं हुआ';

  @override
  String payBy(String time) {
    return '$time तक भुगतान करें';
  }

  @override
  String appointmentAt(String time) {
    return 'मिलने का समय $time';
  }

  @override
  String pickupAt(String time) {
    return 'पिकअप $time';
  }

  @override
  String get timelineTitle => 'समयरेखा';

  @override
  String get eventCreate => 'बुकिंग की गई';

  @override
  String get documentRemoved => 'दस्तावेज़ हटाया गया';

  @override
  String get notesTitle => 'नोट';

  @override
  String get yourAddresses => 'आपके पते';

  @override
  String get youHaveNoDocuments => 'आपके अभी कोई दस्तावेज़ नहीं हैं।';

  @override
  String get appointmentTooEarly => 'इस मिलने के समय से पहले कोई पिकअप समय नहीं है। बाद का समय या दूसरी तारीख़ चुनें।';

  @override
  String get pickupTooEarly => 'पिकअप इस मिलने के समय के लिए बहुत जल्दी है। बाद का पिकअप समय चुनें।';

  @override
  String get errBookingChanged => 'यह बुकिंग बदल गई है। जाँचें और फिर से भुगतान पर टैप करें।';

  @override
  String get paymentProcessingTitle => 'आपका भुगतान पक्का कर रहे हैं…';

  @override
  String get paymentProcessingBody => 'इसमें कुछ सेकंड लगते हैं। आप यह स्क्रीन छोड़ सकते हैं: हम आपको संदेश भेजेंगे।';

  @override
  String get paymentTakingLong => 'हम अभी भी आपका भुगतान पक्का कर रहे हैं। होते ही आपको संदेश भेजेंगे।';

  @override
  String get paymentConfirmedTitle => 'बुकिंग पक्की';

  @override
  String get paymentConfirmedBody =>
      'हम आपका पार्टनर तय कर रहे हैं। उनके स्वीकार करते ही उनका नाम, फ़ोटो और फ़ोन यहाँ दिखेगा।';

  @override
  String get paymentFailedTitle => 'भुगतान नहीं हुआ';

  @override
  String paymentFailedBody(String time) {
    return 'अगर पैसे कटे हैं, तो वे अपने आप पक्के होंगे या वापस आ जाएँगे। आप $time तक फिर कोशिश कर सकते हैं।';
  }

  @override
  String get paymentCancelledTitle => 'भुगतान रद्द किया';

  @override
  String get viewBooking => 'बुकिंग देखें';

  @override
  String paidAmount(String amount) {
    return '$amount चुकाया';
  }

  @override
  String get tabUpcoming => 'आने वाली';

  @override
  String get tabOngoing => 'चल रही';

  @override
  String get tabPast => 'पिछली';

  @override
  String get noUpcomingBookings => 'कोई आने वाली बुकिंग नहीं।';

  @override
  String get noOngoingBookings => 'अभी कुछ नहीं चल रहा।';

  @override
  String get noPastBookings => 'अभी कोई पिछली बुकिंग नहीं।';

  @override
  String get cancelBooking => 'बुकिंग रद्द करें';

  @override
  String get cancelTitle => 'यह बुकिंग रद्द करें?';

  @override
  String cancelRefund(String amount, int percent) {
    return 'आपको $amount (बुकिंग शुल्क का $percent%) 5 से 7 कार्य दिवस में आपके भुगतान के तरीके में वापस मिलेगा।';
  }

  @override
  String get cancelNoRefund => 'इस बुकिंग पर कोई रिफ़ंड नहीं है।';

  @override
  String get cancelReasonLabel => 'आप क्यों रद्द कर रहे हैं?';

  @override
  String get cancelReasonPlans => 'योजना बदल गई';

  @override
  String get cancelReasonMistake => 'गलती से बुक हुआ';

  @override
  String get cancelReasonOther => 'कोई और कारण';

  @override
  String get cancelReasonHint => 'और बताएँ (वैकल्पिक)';

  @override
  String get confirmCancel => 'हाँ, रद्द करें';

  @override
  String get keepBooking => 'बुकिंग रखें';

  @override
  String get cancelNotAllowed => 'आपका पार्टनर निकल चुका है। रद्द करने के लिए WellWish सहायता को कॉल करें।';

  @override
  String get bookingCancelledSnack => 'बुकिंग रद्द हो गई।';

  @override
  String get refundsTitle => 'रिफ़ंड';

  @override
  String get refundAwaiting => 'मंज़ूरी बाकी';

  @override
  String get refundPending => 'रास्ते में';

  @override
  String get refundProcessed => 'वापस हो गया';

  @override
  String get refundFailed => 'नहीं हुआ: सहायता टीम आपको कॉल करेगी';

  @override
  String get refundRejected => 'मंज़ूर नहीं';

  @override
  String get changeTime => 'तारीख़ या समय बदलें';

  @override
  String reschedulesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बदलाव बाकी',
      one: '1 बदलाव बाकी',
      zero: 'कोई बदलाव बाकी नहीं',
    );
    return '$_temp0';
  }

  @override
  String get rescheduleTooLate => 'पिकअप के इतने पास समय नहीं बदल सकते। WellWish सहायता को कॉल करें।';

  @override
  String get rescheduleLimit => 'समय फिर से नहीं बदला जा सकता। WellWish सहायता को कॉल करें।';

  @override
  String get confirmNewTime => 'नया समय पक्का करें';

  @override
  String get timeChangedSnack => 'समय बदल गया।';

  @override
  String get partnerWillReconfirm => 'आपका पार्टनर नया समय पक्का करेगा।';

  @override
  String currentTime(String time) {
    return 'अभी: $time';
  }

  @override
  String get errNotPayable => 'इस बुकिंग का भुगतान अब नहीं हो सकता। कृपया फिर से बुक करें।';

  @override
  String get errPaymentsNotSetUp => 'ऑनलाइन भुगतान अभी उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get errInvalidSignature =>
      'हम यह भुगतान पक्का नहीं कर पाए। अगर पैसे कटे हैं, तो वे पक्के होंगे या वापस आएँगे।';

  @override
  String get errGateway => 'भुगतान सेवा ने जवाब नहीं दिया। फिर कोशिश करें।';

  @override
  String get rescheduleNotAllowed => 'अब ऐप में समय नहीं बदला जा सकता। कृपया WellWish सहायता को कॉल करें।';

  @override
  String get eventPaid => 'बुकिंग शुल्क चुकाया';

  @override
  String get eventRescheduled => 'तारीख या समय बदला';

  @override
  String get bookingFeeOnline => 'बुकिंग शुल्क (ऑनलाइन)';

  @override
  String get paymentNotBookedTitle => 'बुकिंग नहीं हुई';

  @override
  String get paymentNotBookedBody =>
      'भुगतान का समय खत्म हो गया, या भुगतान करते समय वह समय किसी और ने ले लिया। आपका पूरा पैसा 5 से 7 कार्य-दिवसों में लौटा दिया जाएगा। कृपया फिर से बुक करें।';

  @override
  String get offersTitle => 'नए ऑफ़र';

  @override
  String offerTimeLeft(String time) {
    return 'जवाब देने के लिए $time बचे';
  }

  @override
  String get offerWaiting => 'कृपया जवाब दें: WellWish इंतज़ार कर रहा है';

  @override
  String get offerReconfirm => 'समय बदला: कृपया पक्का करें';

  @override
  String get todayJobsTitle => 'आज के काम';

  @override
  String get noJobsToday => 'आज कोई काम नहीं।';

  @override
  String get totalsDoneToday => 'आज पूरे';

  @override
  String get totalsThisWeek => 'इस हफ़्ते';

  @override
  String get totalsUpcoming => 'आने वाले';

  @override
  String get selfieTitle => 'आज की सेल्फ़ी';

  @override
  String get selfieBody => 'उपलब्ध होने से पहले एक सेल्फ़ी लें। WellWish इसे आपकी प्रोफ़ाइल फ़ोटो से मिलाता है।';

  @override
  String get takeSelfie => 'सेल्फ़ी लें';

  @override
  String get selfieSaved => 'सेल्फ़ी सेव हुई। आप आज उपलब्ध हैं।';

  @override
  String get selfieNeeded => 'पहले आज की सेल्फ़ी लें।';

  @override
  String get offerTitle => 'बुकिंग ऑफ़र';

  @override
  String get offerArea => 'इलाका';

  @override
  String offerDistance(String km) {
    return 'आपके घर से $km km';
  }

  @override
  String get offerPatient => 'मरीज़';

  @override
  String get offerNeeds => 'ज़रूरतें';

  @override
  String offerDocuments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दस्तावेज़ जुड़े',
      one: '1 दस्तावेज़ जुड़ा',
      zero: 'कोई दस्तावेज़ नहीं',
    );
    return '$_temp0';
  }

  @override
  String get offerPrescription => 'पर्चा जुड़ा है';

  @override
  String offerBalance(String amount) {
    return 'काम के बाद आप $amount लेंगे';
  }

  @override
  String get offerDetailsLater => 'स्वीकार करने के बाद पूरा पता, फ़ोन नंबर, सेहत की जानकारी और दस्तावेज़ दिखेंगे।';

  @override
  String get acceptOffer => 'स्वीकार करें';

  @override
  String get acceptNewTime => 'नया समय पक्का करें';

  @override
  String get declineOffer => 'मना करें';

  @override
  String get declineTitle => 'आप इसे क्यों नहीं ले सकते?';

  @override
  String get declineNotAvailable => 'उपलब्ध नहीं';

  @override
  String get declineTooFar => 'बहुत दूर';

  @override
  String get declineOther => 'दूसरा कारण';

  @override
  String get declineNoteHint => 'नोट लिखें (वैकल्पिक)';

  @override
  String get offerDeclined => 'मना कर दिया। WellWish किसी और को ढूँढेगा।';

  @override
  String get errOfferNotOpen => 'यह बुकिंग अब आपकी नहीं है।';

  @override
  String get errPartnerBusy => 'उस समय आपका दूसरा काम है।';

  @override
  String get jobsNew => 'नए';

  @override
  String get jobsUpcoming => 'आने वाले';

  @override
  String get jobsCompleted => 'पूरे';

  @override
  String get noOffers => 'कोई नया ऑफ़र नहीं।';

  @override
  String get noUpcomingJobs => 'कोई आने वाला काम नहीं।';

  @override
  String get noCompletedJobs => 'अभी कोई पूरा काम नहीं।';

  @override
  String jobTitle(String code) {
    return 'काम $code';
  }

  @override
  String get jobAddress => 'पता';

  @override
  String get navigate => 'रास्ता देखें';

  @override
  String get navigateHospital => 'अस्पताल का रास्ता देखें';

  @override
  String get callPatient => 'मरीज़ को कॉल करें';

  @override
  String callBooker(String name) {
    return '$name (बुक करने वाले) को कॉल करें';
  }

  @override
  String collectBalance(String amount) {
    return 'काम के बाद $amount लें';
  }

  @override
  String get jobAccepted => 'स्वीकार किया';

  @override
  String get reconfirmPending => 'समय बदल गया है। नए ऑफ़र में नया समय पक्का करें।';

  @override
  String get openDocument => 'खोलें';

  @override
  String get yourPartner => 'आपका पार्टनर';

  @override
  String callName(String name) {
    return '$name को कॉल करें';
  }

  @override
  String ratingCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count समीक्षाएँ', one: '1 समीक्षा');
    return '$rating ($_temp0)';
  }

  @override
  String get newPartner => 'नया पार्टनर';

  @override
  String get offerAccepted => 'यह काम आपका है।';

  @override
  String get openJob => 'काम खोलें';

  @override
  String get stepOnTheWay => 'रास्ते में';

  @override
  String get stepReachedPatient => 'मरीज़ के पास पहुँचे';

  @override
  String get stepPickedUp => 'साथ ले लिया';

  @override
  String get stepReachedHospital => 'अस्पताल पहुँचे';

  @override
  String get stepVisitDone => 'डॉक्टर से मिल लिए';

  @override
  String get stepDroppedHome => 'घर छोड़ दिया';

  @override
  String get stepReachedHome => 'घर पहुँचे';

  @override
  String get stepStarted => 'देखभाल शुरू';

  @override
  String get stepCareDone => 'देखभाल पूरी';

  @override
  String get stepAtPlace => 'अस्पताल / दवा की दुकान पर';

  @override
  String get stepTaskDone => 'काम पूरा';

  @override
  String get stepDelivered => 'पहुँचा दिया';

  @override
  String get stepCompleted => 'पूरा';

  @override
  String get activeJobTitle => 'अभी का काम';

  @override
  String nextStepIs(String step) {
    return 'अगला: $step';
  }

  @override
  String get tapWhenDone => 'यह होने पर दबाएँ';

  @override
  String get sharingLocation => 'आपकी लोकेशन मरीज़ के साथ शेयर हो रही है';

  @override
  String get locationOffHelp =>
      'आपकी लोकेशन नहीं मिल रही। WellWish Partner को लोकेशन की अनुमति दें और लोकेशन चालू करें।';

  @override
  String get fgsTitle => 'WellWish विज़िट';

  @override
  String get fgsText => 'इस विज़िट के लिए आपकी लोकेशन मरीज़ के साथ शेयर हो रही है';

  @override
  String get enterOtpTitle => 'विज़िट कोड माँगें';

  @override
  String get enterOtpBody => 'परिवार के पास WellWish ऐप या SMS में 4 अंकों का कोड है।';

  @override
  String jobOtpWrong(int tries) {
    return 'गलत कोड। $tries कोशिश बाकी।';
  }

  @override
  String otpWaitUntil(String time) {
    return 'बहुत सारे गलत कोड। $time पर फिर से कोशिश करें, या WellWish को कॉल करें: वे परिवार से पुष्टि कर सकते हैं।';
  }

  @override
  String get jobOtpLastTry => 'गलत कोड। एक और गलत कोड पर आपको 5 मिनट रुकना होगा।';

  @override
  String get noNetworkOtp => 'नेटवर्क नहीं है। कोड पक्का करने के लिए WellWish को कॉल करें।';

  @override
  String get stepQueued => 'फ़ोन में सेव हो गया। नेटवर्क आने पर भेज दिया जाएगा।';

  @override
  String pendingSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count कदम', one: '1 कदम');
    return 'नेटवर्क का इंतज़ार: $_temp0 भेजने बाकी';
  }

  @override
  String get stepsRefused =>
      'आपके फ़ोन पर सेव किया गया एक कदम स्वीकार नहीं हुआ (शायद WellWish ने पहले ही दर्ज कर दिया है)। नीचे कदम देखें या WellWish को कॉल करें।';

  @override
  String tooEarlyToStart(String time) {
    return 'शुरू करने के लिए बहुत जल्दी है। आप $time से \"रास्ते में\" दबा सकते हैं।';
  }

  @override
  String get shareAgain => 'फिर से शेयर करें';

  @override
  String get callWellWish => 'WellWish को कॉल करें';

  @override
  String waitTimer(String time) {
    return 'मरीज़ का इंतज़ार: $time बाकी';
  }

  @override
  String get patientNotAvailable => 'मरीज़ उपलब्ध नहीं';

  @override
  String get noShowConfirm => 'मरीज़ को उपलब्ध नहीं मार्क करें? WellWish इसकी जाँच करेगा।';

  @override
  String get callFirst => 'पहले मरीज़ को कॉल करके देखें।';

  @override
  String get noShowDone => 'मार्क हो गया: मरीज़ उपलब्ध नहीं। WellWish जाँच करेगा।';

  @override
  String get jobFinished => 'काम पूरा। धन्यवाद!';

  @override
  String get sos => 'SOS';

  @override
  String get sosTitle => 'आपातकाल';

  @override
  String get sosBody =>
      'WellWish और आपातकालीन संपर्कों को आपकी लोकेशन के साथ अलर्ट जाएगा। पुलिस के लिए 112, एम्बुलेंस के लिए 108 पर कॉल करें।';

  @override
  String get sendSos => 'WellWish को SOS भेजें';

  @override
  String get sosSent => 'WellWish को अलर्ट भेज दिया गया।';

  @override
  String get call112 => '112 पर कॉल (पुलिस)';

  @override
  String get call108 => '108 पर कॉल (एम्बुलेंस)';

  @override
  String get careNoteTitle => 'देखभाल नोट';

  @override
  String get careNoteHint => 'आपने क्या किया और मरीज़ कैसे हैं';

  @override
  String get careNoteRequired => 'कृपया छोटा देखभाल नोट लिखें।';

  @override
  String get vitalsTitle => 'जाँच (वैकल्पिक)';

  @override
  String get bpLabel => 'BP (जैसे 120/80)';

  @override
  String get pulseLabel => 'नब्ज़';

  @override
  String get temperatureLabel => 'तापमान (°F)';

  @override
  String get spo2Label => 'SpO₂ (%)';

  @override
  String get sugarLabel => 'शुगर (mg/dL)';

  @override
  String get saveCareNote => 'सेव करें और देखभाल पूरी मार्क करें';

  @override
  String get invalidValue => 'यह मान जाँचें';

  @override
  String get collectTitle => 'बाकी राशि लें';

  @override
  String get collectBody => 'जो लिया वह दर्ज करें। यह पैसा WellWish के पास नहीं आता।';

  @override
  String get amountRupees => 'राशि (₹)';

  @override
  String get payCash => 'नकद';

  @override
  String get payUpi => 'UPI';

  @override
  String get balanceNoteHint => 'नोट (वैकल्पिक)';

  @override
  String get recordBalance => 'राशि दर्ज करें';

  @override
  String balanceRecorded(String amount, String mode) {
    return '$amount लिया ($mode)';
  }

  @override
  String get balanceNotDue => 'लेने के लिए कुछ नहीं है: ऐप में पूरा भुगतान हो गया है।';

  @override
  String balanceTooHigh(String amount) {
    return 'यह लेने वाली राशि ($amount) से ज़्यादा है।';
  }

  @override
  String get totalsTitle => 'कुल';

  @override
  String get jobsDoneTitle => 'पूरे काम';

  @override
  String get totalsThisMonth => 'इस महीने';

  @override
  String get totalsAllTime => 'अब तक';

  @override
  String get balanceCollectedTitle => 'ली गई राशि';

  @override
  String cashUpi(String cash, String upi) {
    return 'नकद $cash · UPI $upi';
  }

  @override
  String get offersTitleTotals => 'ऑफ़र';

  @override
  String offersLine(int received, int accepted, int declined, int late) {
    return '$received मिले · $accepted स्वीकारे · $declined मना · $late 2 मिनट में जवाब नहीं';
  }

  @override
  String get ratingTitle => 'रेटिंग';

  @override
  String get noReviewsYet => 'अभी कोई रिव्यू नहीं';

  @override
  String get seeTotals => 'कुल देखें';

  @override
  String get visitCodeTitle => 'विज़िट कोड';

  @override
  String visitCodeHelp(String name) {
    return '$name के पहुँचने पर उन्हें यह कोड दें। फ़ोन पर किसी को न बताएँ।';
  }

  @override
  String get trackLive => 'लाइव देखें';

  @override
  String get liveEnded => 'विज़िट पूरी हुई। लाइव लोकेशन बंद हो गई है।';

  @override
  String get backToBooking => 'बुकिंग पर वापस जाएँ';

  @override
  String nowStep(String step) {
    return 'अभी: $step';
  }

  @override
  String get chooseStars => '1 से 5 स्टार चुनें';

  @override
  String starsSemantics(int count) {
    return '$count स्टार';
  }

  @override
  String get reportTooShort => 'कृपया कुछ शब्द लिखें';

  @override
  String get sendReport => 'भेजें';

  @override
  String get errAlreadyReviewed => 'आप इस विज़िट को पहले ही रेटिंग दे चुके हैं।';

  @override
  String get errNotReviewable => 'इस विज़िट को रेटिंग नहीं दी जा सकती।';

  @override
  String get errReportTooLate => 'समस्या विज़िट के 24 घंटे तक बताई जा सकती है। कृपया WellWish को कॉल करें।';

  @override
  String get errNotInProgress => 'विज़िट अभी चालू नहीं है। आपात स्थिति में 112 पर कॉल करें।';

  @override
  String get liveTitle => 'लाइव विज़िट';

  @override
  String etaMinutes(int minutes) {
    return 'लगभग $minutes मिनट दूर';
  }

  @override
  String etaHours(int hours, int minutes) {
    return 'लगभग $hours घंटे $minutes मिनट दूर';
  }

  @override
  String updatedAt(String time) {
    return '$time पर अपडेट';
  }

  @override
  String waitingForLocation(String name) {
    return '$name की लोकेशन का इंतज़ार…';
  }

  @override
  String get shareTrip => 'यात्रा शेयर करें';

  @override
  String get linkCopied => 'लिंक कॉपी हो गया। WhatsApp या SMS पर भेजें।';

  @override
  String get visitCompleted => 'विज़िट पूरी';

  @override
  String payPartner(String amount, String name) {
    return '$name को $amount दें';
  }

  @override
  String get payPartnerHelp =>
      'बाकी राशि सीधे अपने साथी या नर्स को दें (नकद या UPI)। कैब का किराया और अतिरिक्त समय उन्हीं से तय करें।';

  @override
  String get rateVisit => 'विज़िट को रेट करें';

  @override
  String get reviewCommentHint => 'कुछ और कहना है? (वैकल्पिक)';

  @override
  String get sendRating => 'रेटिंग भेजें';

  @override
  String get ratingThanks => 'रेटिंग के लिए धन्यवाद!';

  @override
  String get yourRating => 'आपकी रेटिंग';

  @override
  String get tagOnTime => 'समय पर';

  @override
  String get tagKind => 'दयालु';

  @override
  String get tagHelpful => 'मददगार';

  @override
  String get tagProfessional => 'पेशेवर';

  @override
  String get tagGoodCommunication => 'अच्छे से समझाया';

  @override
  String get tagLate => 'देर से';

  @override
  String get tagRude => 'रूखा व्यवहार';

  @override
  String get tagUnhelpful => 'मददगार नहीं';

  @override
  String get reportProblem => 'समस्या बताएँ';

  @override
  String get reportHint => 'क्या गलत हुआ?';

  @override
  String get reportSent => 'भेज दिया। WellWish आपसे संपर्क करेगा।';

  @override
  String get reportedProblems => 'आपकी बताई समस्याएँ';

  @override
  String get wellwishReplied => 'WellWish का जवाब';

  @override
  String get ticketClosed => 'बंद';

  @override
  String get ticketOpen => 'खुला';

  @override
  String noShowShown(String name) {
    return '$name मरीज़ से नहीं मिल पाए। WellWish आपको कॉल करेगा।';
  }

  @override
  String get docTypeCareNote => 'देखभाल नोट';

  @override
  String get vitalsLine => 'जाँच';

  @override
  String get bpShort => 'बीपी';

  @override
  String get careNoteBy => 'विज़िट पर नर्स ने लिखा';

  @override
  String get tempHomeTitle => 'आपका WellWish काम';

  @override
  String get tempHomeBody => 'WellWish ने आपको यह एक विज़िट दी है। नीचे दिए गए कदम एक-एक करके पूरे करें।';

  @override
  String get tempSelfieBody =>
      'शुरू करने से पहले एक सेल्फ़ी लें। परिवार और WellWish इसे इस विज़िट के लिए आपकी फ़ोटो के रूप में देखते हैं।';

  @override
  String get tempSelfieSaved => 'सेल्फ़ी सेव हुई। अब आप काम शुरू कर सकते हैं।';

  @override
  String get tempJobOver => 'आपका WellWish काम पूरा हो गया। धन्यवाद!';

  @override
  String get rootedWarning =>
      'यह फ़ोन रूट किया हुआ लगता है। इस पर मरीज़ों की जानकारी और आपका खाता कम सुरक्षित हैं। कृपया WellWish के कामों के लिए बिना रूट वाला फ़ोन इस्तेमाल करें।';

  @override
  String get otpFieldLabel => '6 अंकों का कोड';

  @override
  String paidPartner(String amount, String name) {
    return '$name को $amount दिए';
  }

  @override
  String get legalTitle => 'शर्तें और नीतियाँ';

  @override
  String get legalTerms => 'उपयोग की शर्तें';

  @override
  String get legalPrivacy => 'गोपनीयता नीति';

  @override
  String get legalRefunds => 'रिफ़ंड नीति';

  @override
  String get legalPartnerTerms => 'पार्टनर की शर्तें';

  @override
  String legalRead(String page) {
    return '$page पढ़ें';
  }

  @override
  String get consentPartnerTerms => 'मैं पार्टनर की शर्तें स्वीकार करता/करती हूं';

  @override
  String get consentPartnerTermsDetail => 'काम, लोकेशन शेयर करना, व्यवहार और आपका खाता कैसे चलते हैं।';

  @override
  String get partnerDeleteAccountHelp => 'आपकी प्रोफ़ाइल, फ़ोन नंबर, ईमेल और दस्तावेज़ हटाता है।';

  @override
  String partnerDeleteAccountBody(int days) {
    return 'आप अभी लॉग आउट हो जाएँगे। $days दिन बाद आपकी प्रोफ़ाइल, फ़ोन नंबर, ईमेल, पता और दस्तावेज़ हटा दिए जाएँगे। खाता रखना हो तो उससे पहले फिर से लॉग इन करें। आपके पुराने कामों का रिकॉर्ड आपकी निजी जानकारी के बिना रहेगा।';
  }

  @override
  String get errorActiveJobs =>
      'आपके पास एक स्वीकार किया हुआ या चल रहा काम है। WellWish से उसे किसी और को देने को कहें, फिर से कोशिश करें।';

  @override
  String get accountErased => 'आपका खाता हटा दिया गया है।';

  @override
  String get deleteLoginBody =>
      'Partner ऐप में इस नंबर के लिए और कुछ सहेजा नहीं गया है। इसे अभी हटा दिया जाएगा और आप लॉग आउट हो जाएँगे।';

  @override
  String get consentChanged => 'WellWish ने अभी ये पेज बदले हैं। कृपया इन्हें फिर से पढ़ें और स्वीकार करें।';

  @override
  String get errUploadAgain => 'अपलोड में बहुत समय लगा। कृपया फिर से कोशिश करें।';
}
