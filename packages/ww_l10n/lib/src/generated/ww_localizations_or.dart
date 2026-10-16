// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'ww_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class WWLocalizationsOr extends WWLocalizations {
  WWLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appName => 'WellWish';

  @override
  String get partnerBadge => 'ପାର୍ଟନର';

  @override
  String get brandTagline => 'आपकी सेहत, हमारी ज़िम्मेदारी';

  @override
  String get loading => 'ଲୋଡ୍ ହେଉଛି…';

  @override
  String get tryAgain => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get somethingWentWrong => 'କିଛି ଭୁଲ ହୋଇଗଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get noInternet => 'ଇଣ୍ଟରନେଟ୍ ସଂଯୋଗ ନାହିଁ। ଆପଣଙ୍କ ନେଟୱର୍କ ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get loginWelcomeBack => 'ପୁଣି ସ୍ୱାଗତ';

  @override
  String get loginSubtitle => 'ଜାରି ରଖିବାକୁ ଲଗଇନ୍ କରନ୍ତୁ';

  @override
  String get createAccountTitle => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ତିଆରି କରନ୍ତୁ';

  @override
  String get createAccountSubtitle => 'ଆରମ୍ଭ କରିବାକୁ ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String get partnerLoginSubtitle => 'ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବରରେ ଲଗଇନ୍ କରନ୍ତୁ, କିମ୍ବା କମ୍ପାନିଅନ୍ ବା ନର୍ସ ଭାବେ ଯୋଗ ଦିଅନ୍ତୁ';

  @override
  String get partnerLoginTitle => 'ସ୍ୱାଗତ';

  @override
  String get partnerJoinHint => 'ନୂଆ ପାର୍ଟନର? ଆବେଦନ ଆରମ୍ଭ କରିବାକୁ ଆପଣଙ୍କ ନମ୍ବର ଦିଅନ୍ତୁ।';

  @override
  String get phoneHint => 'ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String get sendOtp => 'OTP ପଠାନ୍ତୁ';

  @override
  String get orDivider => 'କିମ୍ବା';

  @override
  String get loginWith => 'ଏହା ସହିତ ଲଗଇନ୍ କରନ୍ତୁ';

  @override
  String get google => 'Google';

  @override
  String get newHere => 'ନୂଆ କି?';

  @override
  String get createAccount => 'ଆକାଉଣ୍ଟ ତିଆରି କରନ୍ତୁ';

  @override
  String get haveAccount => 'ପୂର୍ବରୁ ଆକାଉଣ୍ଟ ଅଛି କି?';

  @override
  String get login => 'ଲଗଇନ୍';

  @override
  String get invalidPhone => 'ଏକ ଠିକ୍ 10 ଅଙ୍କର ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String get otpTitle => 'ଆପଣଙ୍କ ନମ୍ବର ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String otpSentTo(String phone) {
    return '$phone କୁ ପଠାଯାଇଥିବା 6 ଅଙ୍କର କୋଡ୍ ଦିଅନ୍ତୁ';
  }

  @override
  String get changeNumber => 'ନମ୍ବର ବଦଳାନ୍ତୁ';

  @override
  String get verify => 'ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String resendIn(int seconds) {
    return '$seconds ସେକେଣ୍ଡରେ କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ';
  }

  @override
  String get resendCode => 'କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ';

  @override
  String get codeResent => 'ନୂଆ କୋଡ୍ ପଠାଗଲା';

  @override
  String otpWrong(int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: 'ଆଉ $attempts ଥର ଚେଷ୍ଟା ବାକି।',
      one: 'ଆଉ 1 ଥର ଚେଷ୍ଟା ବାକି।',
    );
    return 'ଏହି କୋଡ୍ ଠିକ୍ ନୁହେଁ। $_temp0';
  }

  @override
  String get otpExpired => 'ଏହି କୋଡ୍ର ସମୟ ସରିଗଲା। \'କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ\' ଦବାନ୍ତୁ।';

  @override
  String get otpTooManyAttempts => 'ଅନେକ ଥର ଭୁଲ ହେଲା। ନୂଆ କୋଡ୍ ପାଇଁ \'କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ\' ଦବାନ୍ତୁ।';

  @override
  String get otpLocked => 'ଅନେକ ଭୁଲ କୋଡ୍। ଦୟାକରି ଏକ ଘଣ୍ଟା ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get otpRateLimited => 'ଅନେକ ଥର କୋଡ୍ ମଗାଗଲା। ଦୟାକରି ପରେ ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get smsNotSent => 'ଆମେ SMS ପଠାଇ ପାରିଲୁ ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get accountBlocked => 'ଏହି ଆକାଉଣ୍ଟ ବ୍ଲକ୍ ହୋଇଛି। ଦୟାକରି WellWish ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get googleFailed => 'Google ସାଇନ୍-ଇନ୍ ହେଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get googleVerifyPhone => 'Google ସାଇନ୍-ଇନ୍ ସମାପ୍ତ କରିବାକୁ ଥରେ ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବର ଯାଞ୍ଚ କରନ୍ତୁ।';

  @override
  String get profileSetupTitle => 'ଆପଣଙ୍କ ବିଷୟରେ କୁହନ୍ତୁ';

  @override
  String get profileSetupSubtitle => 'ଏହା ଆପଣଙ୍କ ସାଥୀ କିମ୍ବା ନର୍ସଙ୍କୁ ଆପଣଙ୍କର ଭଲ ଯତ୍ନ ନେବାରେ ସାହାଯ୍ୟ କରେ।';

  @override
  String get fullName => 'ପୂରା ନାମ';

  @override
  String get fullNameHint => 'ଆପଣଙ୍କ ପରିଚୟ ପତ୍ରରେ ଥିବା ପରି';

  @override
  String get dateOfBirth => 'ଜନ୍ମ ତାରିଖ';

  @override
  String get selectDate => 'ତାରିଖ ବାଛନ୍ତୁ';

  @override
  String get gender => 'ଲିଙ୍ଗ';

  @override
  String get genderFemale => 'ମହିଳା';

  @override
  String get genderMale => 'ପୁରୁଷ';

  @override
  String get genderOther => 'ଅନ୍ୟ';

  @override
  String get language => 'ଭାଷା';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageOdia => 'ଓଡ଼ିଆ';

  @override
  String get continueLabel => 'ଆଗକୁ ବଢ଼ନ୍ତୁ';

  @override
  String get nameRequired => 'ଦୟାକରି ଆପଣଙ୍କ ପୂରା ନାମ ଦିଅନ୍ତୁ';

  @override
  String get dobRequired => 'ଦୟାକରି ଆପଣଙ୍କ ଜନ୍ମ ତାରିଖ ବାଛନ୍ତୁ';

  @override
  String get genderRequired => 'ଦୟାକରି ଆପଣଙ୍କ ଲିଙ୍ଗ ବାଛନ୍ତୁ';

  @override
  String get consentTitle => 'ଆରମ୍ଭ କରିବା ପୂର୍ବରୁ';

  @override
  String get consentSubtitle => 'WellWish ବ୍ୟବହାର କରିବାକୁ ଦୟାକରି ପଢ଼ି ସ୍ୱୀକାର କରନ୍ତୁ।';

  @override
  String get consentTerms => 'ମୁଁ ବ୍ୟବହାର ସର୍ତ୍ତାବଳୀ ସ୍ୱୀକାର କରୁଛି';

  @override
  String get consentTermsDetail => 'ବୁକିଂ, ପେମେଣ୍ଟ, ବାତିଲ ଏବଂ ଫେରସ୍ତ କିପରି କାମ କରେ।';

  @override
  String get consentPrivacy => 'ମୁଁ ଗୋପନୀୟତା ନୀତି ସ୍ୱୀକାର କରୁଛି';

  @override
  String get consentPrivacyDetail => 'ଆପଣଙ୍କ ତଥ୍ୟ ଭାରତରେ ରହେ ଏବଂ କେବେ ବିକ୍ରି କରାଯାଏ ନାହିଁ।';

  @override
  String get consentHealthData => 'ମୁଁ WellWish କୁ ମୋର ସ୍ୱାସ୍ଥ୍ୟ ଦସ୍ତାବିଜ ରଖିବାକୁ ଅନୁମତି ଦେଉଛି';

  @override
  String get consentHealthDataDetail =>
      'ଏଗୁଡ଼ିକ କେବଳ ଆପଣଙ୍କ ବୁକିଂ ପାଇଁ ନିଯୁକ୍ତ ସାଥୀ କିମ୍ବା ନର୍ସଙ୍କୁ, ଭିଜିଟ୍ ସମୟରେ ହିଁ ଦେଖାଯାଏ।';

  @override
  String get agreeAndContinue => 'ରାଜି, ଆଗକୁ ବଢ଼ନ୍ତୁ';

  @override
  String get locationTitle => 'ଆପଣଙ୍କ ପାଖରେ ଥିବା ହସ୍ପିଟାଲ୍ ଖୋଜନ୍ତୁ';

  @override
  String get locationBody =>
      'ଲୋକେସନ୍ ଅନୁମତି ଦିଅନ୍ତୁ, ଯାହାଦ୍ୱାରା ଆମେ ଆପଣଙ୍କ ପାଖରେ ଥିବା ହସ୍ପିଟାଲ୍ ଓ କ୍ଲିନିକ୍ ଦେଖାଇପାରିବୁ। ଆମେ ଆପଣଙ୍କୁ ଟ୍ରାକ୍ କରୁନାହୁଁ।';

  @override
  String get allowLocation => 'ଲୋକେସନ୍ ଅନୁମତି ଦିଅନ୍ତୁ';

  @override
  String get notNow => 'ଏବେ ନୁହେଁ';

  @override
  String helloName(String name) {
    return 'ନମସ୍କାର, $name';
  }

  @override
  String get homeTagline => 'ନିଜର ଯତ୍ନ ନିଅନ୍ତୁ। ଆପଣ ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ!';

  @override
  String get heroTitle => 'ଆପଣଙ୍କ ସ୍ୱାସ୍ଥ୍ୟ, ଆମର ପ୍ରାଥମିକତା';

  @override
  String get heroSubtitle => 'WellWish ସହିତ ସର୍ବୋତ୍ତମ ଯତ୍ନ ପାଆନ୍ତୁ';

  @override
  String get tileDoctors => 'ଡାକ୍ତର';

  @override
  String get tileBookCompanion => 'ସାଥୀ ବୁକ୍ କରନ୍ତୁ';

  @override
  String get tileBookNurse => 'ନର୍ସ ବୁକ୍ କରନ୍ତୁ';

  @override
  String get tileMedicalReports => 'ମେଡିକାଲ୍ ରିପୋର୍ଟ';

  @override
  String get tileFamily => 'ପରିବାର';

  @override
  String get comingSoon => 'ଶୀଘ୍ର ଆସୁଛି';

  @override
  String get comingSoonBody => 'WellWish ର ଏହି ଅଂଶ ଆଗାମୀ ଅପଡେଟ୍ରେ ଖୋଲିବ।';

  @override
  String get navHome => 'ହୋମ୍';

  @override
  String get navDoctors => 'ଡାକ୍ତର';

  @override
  String get navReports => 'ରିପୋର୍ଟ';

  @override
  String get navFamily => 'ପରିବାର';

  @override
  String get navProfile => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String get profileTitle => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String get verified => 'ଯାଞ୍ଚିତ';

  @override
  String get personalInformation => 'ବ୍ୟକ୍ତିଗତ ତଥ୍ୟ';

  @override
  String get myBookings => 'ମୋର ବୁକିଂ';

  @override
  String get myReports => 'ମୋର ରିପୋର୍ଟ';

  @override
  String get familyMembers => 'ପରିବାର ସଦସ୍ୟ';

  @override
  String get helpSupport => 'ସହାୟତା';

  @override
  String get logout => 'ଲଗଆଉଟ୍';

  @override
  String get logoutEverywhere => 'ସବୁ ଡିଭାଇସରୁ ଲଗଆଉଟ୍ କରନ୍ତୁ';

  @override
  String get logoutConfirmTitle => 'ଲଗଆଉଟ୍ କରିବେ?';

  @override
  String get logoutConfirmBody => 'ପୁଣି ଲଗଇନ୍ କରିବାକୁ ଆପଣଙ୍କୁ OTP ଦରକାର ହେବ।';

  @override
  String get cancel => 'ବାତିଲ୍';

  @override
  String get sessionExpired => 'ଆପଣଙ୍କ ସେସନ୍ ଶେଷ ହୋଇଗଲା। ଦୟାକରି ପୁଣି ଲଗଇନ୍ କରନ୍ତୁ।';

  @override
  String get loggedInElsewhere => 'ଆପଣ ଅନ୍ୟ ଫୋନରେ ଲଗଇନ୍ କଲେ, ତେଣୁ ଏଠାରୁ ଲଗଆଉଟ୍ ହୋଇଗଲେ।';

  @override
  String get updateTitle => 'WellWish ଅପଡେଟ୍ କରନ୍ତୁ';

  @override
  String get updateBody => 'ନୂଆ ସଂସ୍କରଣ ଉପଲବ୍ଧ। ଜାରି ରଖିବାକୁ ଦୟାକରି ଆପ୍ ଅପଡେଟ୍ କରନ୍ତୁ।';

  @override
  String get updateNow => 'ଏବେ ଅପଡେଟ୍ କରନ୍ତୁ';

  @override
  String get partnerRegisterTitle => 'WellWish ପାର୍ଟନର ହୁଅନ୍ତୁ';

  @override
  String get partnerRegisterBody =>
      'ସାଥୀ ଓ ନର୍ସଙ୍କ ପାଇଁ ପଞ୍ଜୀକରଣ ପରବର୍ତ୍ତୀ ଅପଡେଟ୍ରେ ଖୋଲିବ। ସେତେବେଳେ ଆପଣ ଏଠାରେ ଆପଣଙ୍କ ତଥ୍ୟ ଓ ଦସ୍ତାବିଜ ଯୋଡ଼ିପାରିବେ।';

  @override
  String loggedInAs(String phone) {
    return '$phone ରେ ଲଗଇନ୍ ଅଛି';
  }

  @override
  String get registerRoleTitle => 'ଆପଣ କେଉଁ କାମ କରିବେ?';

  @override
  String get registerRoleSubtitle => 'ଆବେଦନ ପଠାଇବା ପର୍ଯ୍ୟନ୍ତ ଆପଣ ଏହା ବଦଳାଇପାରିବେ।';

  @override
  String get roleCompanion => 'ସାଥୀ';

  @override
  String get roleCompanionBody =>
      'ରୋଗୀଙ୍କୁ ଡାକ୍ତରଙ୍କ ପାଖକୁ ନିଅନ୍ତୁ, ଡାକ୍ତରଖାନାରେ ସାହାଯ୍ୟ କରନ୍ତୁ, ଔଷଧ ଆଣନ୍ତୁ ଓ ଘରେ ବୟସ୍କଙ୍କ ଯତ୍ନ ନିଅନ୍ତୁ।';

  @override
  String get roleNurse => 'ନର୍ସ';

  @override
  String get roleNurseBody =>
      'ଘରେ ଇଞ୍ଜେକସନ, ଘା ଡ୍ରେସିଂ, ଆଇଭି ଡ୍ରିପ ଓ ନର୍ସିଂ ସିଫ୍ଟ। ନର୍ସିଂ ଯୋଗ୍ୟତା ଓ କାଉନସିଲ ପଞ୍ଜୀକରଣ ଦରକାର।';

  @override
  String get registerHubSubtitle => 'ଏହି ପଦକ୍ଷେପ ଶେଷ କରନ୍ତୁ, ତାପରେ ଆବେଦନ ଯାଞ୍ଚ ପାଇଁ ପଠାନ୍ତୁ।';

  @override
  String get stepRole => 'କାମର ପ୍ରକାର';

  @override
  String get stepContact => 'ଦ୍ୱିତୀୟ ନମ୍ବର ଓ ଇମେଲ୍';

  @override
  String get stepProfile => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍';

  @override
  String get stepDocuments => 'କାଗଜପତ୍ର';

  @override
  String get stepDone => 'ଶେଷ';

  @override
  String get stepTodo => 'ବାକି';

  @override
  String documentsProgress(int done, int total) {
    return '$total ରୁ $done ଅପଲୋଡ୍';
  }

  @override
  String get submitForReview => 'ଯାଞ୍ଚ ପାଇଁ ପଠାନ୍ତୁ';

  @override
  String get submitHint => 'ଆବେଦନ ପଠାଇବାକୁ ସବୁ ପଦକ୍ଷେପ ଶେଷ କରନ୍ତୁ।';

  @override
  String get change => 'ବଦଳାନ୍ତୁ';

  @override
  String get save => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get contactTitle => 'ଫୋନ୍ ଓ ଇମେଲ୍';

  @override
  String get loginNumber => 'ଲଗଇନ୍ ନମ୍ବର';

  @override
  String get alternateNumber => 'ଦ୍ୱିତୀୟ ନମ୍ବର';

  @override
  String get alternateHelp => 'ଦ୍ୱିତୀୟ ନମ୍ବର, ଯେପରି ପରିବାରର କାହାର। ଆପଣଙ୍କୁ ନ ପାଇଲେ WellWish ଏଥିରେ କଲ୍ କରିବ।';

  @override
  String get sendCode => 'କୋଡ୍ ପଠାନ୍ତୁ';

  @override
  String codeSentTo(String target) {
    return '$targetକୁ ପଠାଯାଇଥିବା 6 ଅଙ୍କ କୋଡ୍ ଦିଅନ୍ତୁ';
  }

  @override
  String get emailLabel => 'ଇମେଲ୍';

  @override
  String get emailHelp => 'ଯାଞ୍ଚ ପାଇଁ ଆମେ 6 ଅଙ୍କ କୋଡ୍ ଇମେଲ୍ କରିବୁ।';

  @override
  String get invalidEmail => 'ସଠିକ୍ ଇମେଲ୍ ଦିଅନ୍ତୁ।';

  @override
  String get yourPhoto => 'ଆପଣଙ୍କ ଫଟୋ';

  @override
  String get photoHelp => 'ଆପଣଙ୍କ ମୁହଁର ସଫା ଫଟୋ। ରୋଗୀ ଏହା ଦେଖିବେ।';

  @override
  String get takePhoto => 'ଫଟୋ ନିଅନ୍ତୁ';

  @override
  String get chooseFromGallery => 'ଗ୍ୟାଲେରୀରୁ ବାଛନ୍ତୁ';

  @override
  String get choosePdf => 'PDF ବାଛନ୍ତୁ';

  @override
  String get homeAddress => 'ଘର ଠିକଣା';

  @override
  String get homeAddressHint => 'ଘର, ରାସ୍ତା, ଅଞ୍ଚଳ, ପିନ୍ କୋଡ୍';

  @override
  String get homeLocation => 'ଘର ଲୋକେସନ୍';

  @override
  String get homeLocationHelp => 'ଘରେ ରହି ବଟନ୍ ଦବାନ୍ତୁ। ଏହା WellWishକୁ ଆପଣଙ୍କୁ ପାଖ କାମ ଦେବାରେ ସାହାଯ୍ୟ କରେ।';

  @override
  String get useCurrentLocation => 'ମୋର ବର୍ତ୍ତମାନ ଲୋକେସନ୍ ନିଅନ୍ତୁ';

  @override
  String get locationSaved => 'ଲୋକେସନ୍ ଯୋଡ଼ାଗଲା';

  @override
  String get locationDenied => 'ଲୋକେସନ୍ ମିଳିଲା ନାହିଁ। ଫୋନ୍ ସେଟିଂସରେ WellWishକୁ ଲୋକେସନ୍ ଅନୁମତି ଦିଅନ୍ତୁ।';

  @override
  String get languagesYouSpeak => 'ଆପଣ କେଉଁ ଭାଷା କୁହନ୍ତି';

  @override
  String get skillsLabel => 'ଦକ୍ଷତା';

  @override
  String get emergencyContact => 'ଜରୁରୀ ଯୋଗାଯୋଗ';

  @override
  String get emergencyName => 'ତାଙ୍କ ନାମ';

  @override
  String get emergencyPhone => 'ତାଙ୍କ ଫୋନ୍ ନମ୍ବର';

  @override
  String get photoRequired => 'ଆପଣଙ୍କ ଫଟୋ ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get addressRequired => 'ଆପଣଙ୍କ ଘର ଠିକଣା ଦିଅନ୍ତୁ।';

  @override
  String get locationRequired => 'ଆପଣଙ୍କ ଘର ଲୋକେସନ୍ ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get languagesRequired => 'ଅତି କମରେ ଗୋଟିଏ ଭାଷା ବାଛନ୍ତୁ।';

  @override
  String get fixMarkedFields => 'କିଛି ତଥ୍ୟ ବାକି ଅଛି। ଲାଲ ରଙ୍ଗରେ ଦେଖାଯାଉଥିବା ଘର ଦେଖନ୍ତୁ।';

  @override
  String get emergencyRequired => 'ଜରୁରୀ ଯୋଗାଯୋଗ ଦିଅନ୍ତୁ।';

  @override
  String get languageBengali => 'ବଙ୍ଗଳା';

  @override
  String get languageTelugu => 'ତେଲୁଗୁ';

  @override
  String get skillElderlyCare => 'ବୟସ୍କ ଯତ୍ନ';

  @override
  String get skillWheelchair => 'ହ୍ୱିଲଚେୟାର ସାହାଯ୍ୟ';

  @override
  String get skillPaperwork => 'ଡାକ୍ତରଖାନା କାଗଜପତ୍ର';

  @override
  String get skillTwoWheeler => 'ଦୁଇଚକିଆ';

  @override
  String get skillCar => 'କାର୍ ଚଳାଇବା';

  @override
  String get skillInjections => 'ଇଞ୍ଜେକସନ';

  @override
  String get skillDressing => 'ଘା ଡ୍ରେସିଂ';

  @override
  String get skillIvDrip => 'ଆଇଭି ଡ୍ରିପ';

  @override
  String get skillPostSurgery => 'ଅସ୍ତ୍ରୋପଚାର ପରେ ଯତ୍ନ';

  @override
  String get documentsSubtitle => 'ଫଟୋ ସଫା ଓ ପଢ଼ିହେବା ଭଳି ହେଉ। PDF ମଧ୍ୟ ଚଳିବ।';

  @override
  String get docRequired => 'ଆବଶ୍ୟକ';

  @override
  String get docOptional => 'ଇଚ୍ଛାଧୀନ';

  @override
  String get docMissing => 'ଅପଲୋଡ୍ ହୋଇନାହିଁ';

  @override
  String get docPending => 'ଯାଞ୍ଚ ଚାଲିଛି';

  @override
  String get docApproved => 'ଅନୁମୋଦିତ';

  @override
  String get docRejected => 'ପରିବର୍ତ୍ତନ ଦରକାର';

  @override
  String get docExpired => 'ସମାପ୍ତ';

  @override
  String get upload => 'ଅପଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get uploadAgain => 'ପୁଣି ଅପଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get uploadNew => 'ନୂଆ ଅପଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get uploading => 'ଅପଲୋଡ୍ ହେଉଛି…';

  @override
  String get documentNumber => 'କାଗଜରେ ଥିବା ନମ୍ବର';

  @override
  String get aadhaarNumberHelp => '12 ଅଙ୍କ। କେବଳ ଶେଷ 4ଟି ସେଭ୍ ହୁଏ।';

  @override
  String get panNumberHelp => '10 ଅକ୍ଷର, ଯେପରି ABCDE1234F। କେବଳ ଶେଷ 4ଟି ସେଭ୍ ହୁଏ।';

  @override
  String get validTill => 'କେବେ ପର୍ଯ୍ୟନ୍ତ ବୈଧ';

  @override
  String validTillDate(String date) {
    return '$date ପର୍ଯ୍ୟନ୍ତ ବୈଧ';
  }

  @override
  String get numberRequired => 'ନମ୍ବର ଦିଅନ୍ତୁ।';

  @override
  String get expiryRequired => 'ବୈଧତା ତାରିଖ ବାଛନ୍ତୁ।';

  @override
  String get renewalPending => 'ନୂଆଟି ଯାଞ୍ଚ ହେଉଛି';

  @override
  String renewalRejected(String reason) {
    return 'ନୂଆଟି ଗ୍ରହଣ ହେଲା ନାହିଁ: $reason';
  }

  @override
  String get cameraOnlyHelp => 'ବର୍ତ୍ତମାନ ସାମ୍ନା କ୍ୟାମେରାରେ ନିଅନ୍ତୁ।';

  @override
  String get statusTitle => 'ଆବେଦନ ସ୍ଥିତି';

  @override
  String get statusSubmitted => 'ପଠାଯାଇଛି';

  @override
  String get statusUnderReview => 'ଯାଞ୍ଚରେ';

  @override
  String get statusChangesNeeded => 'ପରିବର୍ତ୍ତନ ଦରକାର';

  @override
  String get statusApproved => 'ଅନୁମୋଦିତ';

  @override
  String get statusSubmittedBody => 'ଆମେ ଆପଣଙ୍କ ଆବେଦନ ପାଇଛୁ। ଶୀଘ୍ର କାଗଜପତ୍ର ଯାଞ୍ଚ କରିବୁ।';

  @override
  String get statusUnderReviewBody => 'WellWish ଦଳର ଜଣେ ସଦସ୍ୟ ବର୍ତ୍ତମାନ ଆପଣଙ୍କ କାଗଜପତ୍ର ଯାଞ୍ଚ କରୁଛନ୍ତି।';

  @override
  String get statusChangesBody => 'କିଛି କାଗଜପତ୍ରରେ ପରିବର୍ତ୍ତନ ଦରକାର। ତଳେ କାରଣ ଦେଖନ୍ତୁ, ପୁଣି ଅପଲୋଡ୍ କରି ପୁଣି ପଠାନ୍ତୁ।';

  @override
  String get fixDocuments => 'କାଗଜପତ୍ର ଠିକ୍ କରନ୍ତୁ';

  @override
  String get noteFromWellWish => 'WellWishର ନୋଟ୍';

  @override
  String get statusRejectedTitle => 'ଆବେଦନ ଅନୁମୋଦିତ ହେଲା ନାହିଁ';

  @override
  String get statusSuspendedTitle => 'ଖାତା ବନ୍ଦ ରଖାଯାଇଛି';

  @override
  String get statusSuspendedBody => 'ବର୍ତ୍ତମାନ ଆପଣ କାମ ପାଇବେ ନାହିଁ। ଅଧିକ ଜାଣିବାକୁ WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get suspendedExpiredBody => 'ଗୋଟିଏ କାଗଜ ସମାପ୍ତ ହୋଇଛି। ନୂଆଟି ଅପଲୋଡ୍ କରନ୍ତୁ; ଅନୁମୋଦନ ପରେ ପୁଣି କାମ କରିପାରିବେ।';

  @override
  String get statusDeactivatedTitle => 'ଖାତା ବନ୍ଦ';

  @override
  String get callSupport => 'WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ';

  @override
  String get refresh => 'ରିଫ୍ରେସ୍ କରନ୍ତୁ';

  @override
  String get navJobs => 'କାମ';

  @override
  String get youAreApproved => 'ଆପଣ ଅନୁମୋଦିତ WellWish ପାର୍ଟନର';

  @override
  String get availableToday => 'ଆଜି ଉପଲବ୍ଧ';

  @override
  String get availableTodayHelp => 'ଆଜି କାମ ନେଇପାରିଲେ ଚାଲୁ କରନ୍ତୁ।';

  @override
  String get verifyContactTitle => 'ଆପଣଙ୍କ ଯୋଗାଯୋଗ ତଥ୍ୟ ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get verifyContactBody => 'ଦ୍ୱିତୀୟ ନମ୍ବର ଓ ଇମେଲ୍ ଯାଞ୍ଚ କରନ୍ତୁ ଯେପରି WellWish ସବୁବେଳେ ଯୋଗାଯୋଗ କରିପାରିବ।';

  @override
  String get noJobsYet => 'ଏବେ କୌଣସି କାମ ନାହିଁ';

  @override
  String get noJobsBody => 'WellWishର କାମ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get profileAndDocuments => 'ପ୍ରୋଫାଇଲ୍ ଓ କାଗଜପତ୍ର';

  @override
  String get notificationsTitle => 'ବିଜ୍ଞପ୍ତି';

  @override
  String get noNotifications => 'ଏବେ କୌଣସି ବାର୍ତ୍ତା ନାହିଁ।';

  @override
  String get notificationsKept => 'ଏଠାରେ ଗତ 30 ଦିନର ବାର୍ତ୍ତା ରହେ।';

  @override
  String notificationsUnread(int count) {
    return 'ବିଜ୍ଞପ୍ତି, $countଟି ପଢ଼ାଯାଇନାହିଁ';
  }

  @override
  String get errSameAsPrimary => 'ଲଗଇନ୍ ନମ୍ବରଠାରୁ ଅଲଗା ନମ୍ବର ଦିଅନ୍ତୁ।';

  @override
  String get errEmailTaken => 'ଏହି ଇମେଲ୍ ଅନ୍ୟ ଜଣେ ପାର୍ଟନର ବ୍ୟବହାର କରୁଛନ୍ତି।';

  @override
  String get errCodeWrong => 'କୋଡ୍ ଠିକ୍ ନୁହେଁ। ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errWaitBeforeResend => 'ଆଉ ଏକ କୋଡ୍ ମାଗିବା ପୂର୍ବରୁ ଟିକେ ଅପେକ୍ଷା କରନ୍ତୁ।';

  @override
  String get errEmailNotSent => 'ଇମେଲ୍ ପଠାଇପାରିଲୁ ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errTooYoung => 'ପାର୍ଟନରଙ୍କ ବୟସ 18 କିମ୍ବା ଅଧିକ ହେବା ଦରକାର।';

  @override
  String get errEmergencyIsYou => 'ଜରୁରୀ ଯୋଗାଯୋଗ ଅନ୍ୟ କେହି ହେବା ଦରକାର।';

  @override
  String get errInvalidAadhaar => '12 ଅଙ୍କର ଆଧାର ନମ୍ବର ଦିଅନ୍ତୁ।';

  @override
  String get errInvalidPan => '10 ଅକ୍ଷରର ପାନ୍ ଦିଅନ୍ତୁ।';

  @override
  String get errAlreadyExpired => 'ଏହି କାଗଜ ପୂର୍ବରୁ ସମାପ୍ତ ହୋଇସାରିଛି।';

  @override
  String get errInvalidFile => 'ଏହି ଫାଇଲ୍ ଚଳିବ ନାହିଁ। ସଫା ଫଟୋ କିମ୍ବା PDF ବାଛନ୍ତୁ।';

  @override
  String get errFileTooLarge => 'ଫାଇଲ୍ ବହୁତ ବଡ଼ (ସର୍ବାଧିକ 10 MB)।';

  @override
  String get errDocumentsMissing => 'ପ୍ରଥମେ ସବୁ ଆବଶ୍ୟକ କାଗଜ ଅପଲୋଡ୍ କରନ୍ତୁ।';

  @override
  String get errDetailsMissing => 'ପ୍ରଥମେ ଫୋନ୍, ଇମେଲ୍ ଓ ପ୍ରୋଫାଇଲ୍ ଶେଷ କରନ୍ତୁ।';

  @override
  String get errNotEditable => 'ଆବେଦନ ଯାଞ୍ଚ ବେଳେ ଏହା ବଦଳାଯାଇପାରିବ ନାହିଁ।';

  @override
  String get locationOff => 'ଲୋକେସନ୍ ବନ୍ଦ ଅଛି। ଫୋନରେ ଲୋକେସନ୍ ଚାଲୁ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get familyTitle => 'ପରିବାର';

  @override
  String get familyIntroTitle => 'ଆପଣଙ୍କ ପ୍ରିୟଜନଙ୍କ ସହ ଯୋଡ଼ି ହୋଇ ରୁହନ୍ତୁ';

  @override
  String get familyIntroBody =>
      'ବାପା-ମାଆ ଓ ସମ୍ପର୍କୀୟଙ୍କୁ ଯୋଡ଼ନ୍ତୁ ଓ ସେମାନଙ୍କ ପାଇଁ ଯତ୍ନ ବୁକ୍ କରନ୍ତୁ, ଅନ୍ୟ ସହରରେ ଥିଲେ ମଧ୍ୟ।';

  @override
  String get addMember => 'ସଦସ୍ୟ ଯୋଡ଼ନ୍ତୁ';

  @override
  String ageYears(int age) {
    return '$age ବର୍ଷ';
  }

  @override
  String get noFamilyYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ପରିବାର ସଦସ୍ୟ ନାହାଁନ୍ତି';

  @override
  String get relationSelf => 'ଆପଣ';

  @override
  String get relationMother => 'ମାଆ';

  @override
  String get relationFather => 'ବାପା';

  @override
  String get relationGrandmother => 'ଜେଜେମା / ଆଈ';

  @override
  String get relationGrandfather => 'ଜେଜେବାପା / ଅଜା';

  @override
  String get relationSpouse => 'ସ୍ୱାମୀ / ସ୍ତ୍ରୀ';

  @override
  String get relationChild => 'ପିଲା';

  @override
  String get relationSibling => 'ଭାଇ / ଭଉଣୀ';

  @override
  String get relationOther => 'ଅନ୍ୟ';

  @override
  String get addMemberTitle => 'ପରିବାର ସଦସ୍ୟ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get editDetailsTitle => 'ବିବରଣୀ ବଦଳାନ୍ତୁ';

  @override
  String get relation => 'ସମ୍ପର୍କ';

  @override
  String get relationRequired => 'ସେ ଆପଣଙ୍କର କିଏ, ବାଛନ୍ତୁ।';

  @override
  String get theirPhone => 'ତାଙ୍କ ମୋବାଇଲ୍ ନମ୍ବର (ଇଚ୍ଛାଧୀନ)';

  @override
  String get theirPhoneHelp => 'ସେ ସାଥୀଙ୍କ ନାମ ଓ ଭିଜିଟ୍ OTP SMS ରେ ପାଇବେ।';

  @override
  String get languageTheySpeak => 'ସେ କେଉଁ ଭାଷା କୁହନ୍ତି';

  @override
  String get healthNotes => 'ସ୍ୱାସ୍ଥ୍ୟ ସୂଚନା';

  @override
  String get healthNotesHelp => 'କେବଳ କାମରେ ଥିବା ସାଥୀ ବା ନର୍ସ ଏହା ଦେଖନ୍ତି।';

  @override
  String get conditions => 'ରୋଗ';

  @override
  String get conditionsHint => 'ଯେପରି ଡାଇବେଟିସ୍, BP';

  @override
  String get allergies => 'ଆଲର୍ଜି';

  @override
  String get mobility => 'ଚାଲିବା-ବୁଲିବା';

  @override
  String get mobilityWalksAlone => 'ନିଜେ ଚାଲନ୍ତି';

  @override
  String get mobilityNeedsSupport => 'ସାହାରା ଦରକାର';

  @override
  String get mobilityWheelchair => 'ହ୍ୱିଲଚେୟାର';

  @override
  String get sensoryNotes => 'ଶୁଣିବା ବା ଦେଖିବା';

  @override
  String get sensoryHint => 'ଯେପରି କମ୍ ଶୁଣନ୍ତି';

  @override
  String get emergencyContactHelp => 'ଆପଣଙ୍କ ନିଜ ନମ୍ବର ପାଇଁ ଖାଲି ଛାଡ଼ନ୍ତୁ।';

  @override
  String get emergencyIncomplete => 'ନାମ ଓ ଫୋନ୍ ଦୁଇଟି ଦିଅନ୍ତୁ, ବା ଦୁଇଟି ଖାଲି ଛାଡ଼ନ୍ତୁ।';

  @override
  String get consentMember =>
      'ଏହି ବିବରଣୀ ସେଭ୍ କରିବା ଓ ତାଙ୍କ ଯତ୍ନ ପାଇଁ WellWish ପାର୍ଟନରଙ୍କ ସହ ଅଂଶୀଦାର କରିବାକୁ ମୋ ପାଖରେ ତାଙ୍କ ଅନୁମତି ଅଛି।';

  @override
  String get consentRequired => 'ତାଙ୍କ ଅନୁମତି ନିଶ୍ଚିତ କରିବାକୁ ଟିକ୍ ଦିଅନ୍ତୁ।';

  @override
  String get notGiven => 'ଦିଆଯାଇନାହିଁ';

  @override
  String get detailsTitle => 'ବିବରଣୀ';

  @override
  String get mobileLabel => 'ମୋବାଇଲ୍';

  @override
  String get addressesTitle => 'ଠିକଣା';

  @override
  String get addAddress => 'ଠିକଣା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get noAddresses => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଠିକଣା ସେଭ୍ ହୋଇନାହିଁ।';

  @override
  String get noDocumentsYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଡକ୍ୟୁମେଣ୍ଟ ନାହିଁ।';

  @override
  String get seeAll => 'ସବୁ ଦେଖନ୍ତୁ';

  @override
  String get bookingsTitle => 'ବୁକିଂ';

  @override
  String get noBookingsYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ବୁକିଂ ନାହିଁ।';

  @override
  String bookForName(String name) {
    return '$nameଙ୍କ ପାଇଁ ବୁକ୍ କରନ୍ତୁ';
  }

  @override
  String get edit => 'ବଦଳାନ୍ତୁ';

  @override
  String get remove => 'ହଟାନ୍ତୁ';

  @override
  String get removeMember => 'ପରିବାରରୁ ହଟାନ୍ତୁ';

  @override
  String removeMemberTitle(String name) {
    return '$nameଙ୍କୁ ହଟାଇବେ?';
  }

  @override
  String get removeMemberBody => 'ସେ ଆପରୁ ଲୁଚିଯିବେ। ପୁରୁଣା ବୁକିଂର ଇତିହାସ ରହିବ।';

  @override
  String get outsideServiceArea => 'WellWish ଏବେ ଏହି ଅଞ୍ଚଳରେ ସେବା ଦିଏ ନାହିଁ।';

  @override
  String get addAddressTitle => 'ଠିକଣା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get editAddressTitle => 'ଠିକଣା ବଦଳାନ୍ତୁ';

  @override
  String addressForName(String name) {
    return '$nameଙ୍କ ପାଇଁ';
  }

  @override
  String get mapHelp => 'ମାନଚିତ୍ରକୁ ଘୁଞ୍ଚାନ୍ତୁ ଯେପରି ପିନ୍ ଘର ଉପରେ ରହେ।';

  @override
  String get addressLabel => 'ଏହି ଠିକଣାର ନାମ';

  @override
  String get addressLabelHint => 'ଯେପରି ଘର';

  @override
  String get labelHome => 'ଘର';

  @override
  String get labelWork => 'ଅଫିସ୍';

  @override
  String get addressLine => 'ପୂରା ଠିକଣା';

  @override
  String get landmark => 'ନିକଟସ୍ଥ ଚିହ୍ନ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get addressNotes => 'ସାଥୀଙ୍କ ପାଇଁ ନୋଟ୍ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get addressNotesHint => 'ଗେଟ୍, ମହଲା, ଲିଫ୍ଟ';

  @override
  String get labelRequired => 'ଠିକଣାକୁ ଏକ ନାମ ଦିଅନ୍ତୁ।';

  @override
  String get addressLineRequired => 'ପୂରା ଠିକଣା ଲେଖନ୍ତୁ।';

  @override
  String get savedOutsideArea => 'ସେଭ୍ ହେଲା। WellWish ଏବେ ଏହି ଅଞ୍ଚଳରେ ସେବା ଦିଏ ନାହିଁ, ତେଣୁ ଏଠି ବୁକିଂ ହେବ ନାହିଁ।';

  @override
  String get mapAttribution => '© OpenStreetMap ଅବଦାନକାରୀ';

  @override
  String get tabAll => 'ସବୁ';

  @override
  String get tabReports => 'ରିପୋର୍ଟ';

  @override
  String get tabPrescriptions => 'ପ୍ରେସକ୍ରିପସନ୍';

  @override
  String get everyone => 'ସମସ୍ତେ';

  @override
  String get uploadDocument => 'ଡକ୍ୟୁମେଣ୍ଟ ଅପଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get docTypePrescription => 'ପ୍ରେସକ୍ରିପସନ୍';

  @override
  String get docTypeLabReport => 'ଲ୍ୟାବ୍ ରିପୋର୍ଟ';

  @override
  String get docTypeScan => 'ଏକ୍ସ-ରେ / ସ୍କାନ୍';

  @override
  String get docTypeDischarge => 'ଡିସଚାର୍ଜ ସାରାଂଶ';

  @override
  String get docTypeId => 'ପରିଚୟ ପତ୍ର';

  @override
  String get docTypeOther => 'ଅନ୍ୟ';

  @override
  String get forWhom => 'କାହା ପାଇଁ';

  @override
  String get documentType => 'ପ୍ରକାର';

  @override
  String get documentTitle => 'ନାମ';

  @override
  String get documentTitleHint => 'ଯେପରି ରକ୍ତ ପରୀକ୍ଷା';

  @override
  String get documentDate => 'ଡକ୍ୟୁମେଣ୍ଟର ତାରିଖ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get chooseFile => 'ଫାଇଲ୍';

  @override
  String get fileChosen => 'ଫାଇଲ୍ ପ୍ରସ୍ତୁତ';

  @override
  String get fileRequired => 'ଫଟୋ ବା PDF ବାଛନ୍ତୁ।';

  @override
  String get titleRequired => 'ଡକ୍ୟୁମେଣ୍ଟକୁ ଏକ ନାମ ଦିଅନ୍ତୁ।';

  @override
  String get view => 'ଦେଖନ୍ତୁ';

  @override
  String get delete => 'ଡିଲିଟ୍';

  @override
  String get deleteDocumentTitle => 'ଏହି ଡକ୍ୟୁମେଣ୍ଟ ଡିଲିଟ୍ କରିବେ?';

  @override
  String get deleteDocumentBody => 'ଫାଇଲ୍ ସବୁଦିନ ପାଇଁ ଡିଲିଟ୍ ହେବ।';

  @override
  String storageUsed(String used, String total) {
    return '$total ମଧ୍ୟରୁ $used ବ୍ୟବହୃତ';
  }

  @override
  String get noDocumentsBody => 'ପ୍ରେସକ୍ରିପସନ୍ ଓ ରିପୋର୍ଟ ଥରେ ଅପଲୋଡ୍ କରନ୍ତୁ ଓ ପ୍ରତି ବୁକିଂରେ ବ୍ୟବହାର କରନ୍ତୁ।';

  @override
  String get loadMore => 'ଆହୁରି ଦେଖନ୍ତୁ';

  @override
  String get openInPhone => 'ଆପଣଙ୍କ ଫୋନର PDF ଆପରେ ଖୋଲିବ।';

  @override
  String get cannotOpen => 'ଏହି ଫାଇଲ୍ ଏଠି ଖୋଲି ହେବ ନାହିଁ।';

  @override
  String get settingsTitle => 'ସେଟିଂସ୍';

  @override
  String get notificationsLabel => 'ବିଜ୍ଞପ୍ତି';

  @override
  String get notificationsHelp => 'WellWish ବିଜ୍ଞପ୍ତି ଆପଣଙ୍କ ଫୋନ୍ ସେଟିଂସରେ ଚାଲୁ ବା ବନ୍ଦ କରନ୍ତୁ।';

  @override
  String get openPhoneSettings => 'ଫୋନ୍ ସେଟିଂସ୍ ଖୋଲନ୍ତୁ';

  @override
  String get deleteAccount => 'ମୋ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get deleteAccountHelp => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ପରିବାର, ଠିକଣା ଓ ଡକ୍ୟୁମେଣ୍ଟ ହଟାଇଦିଏ।';

  @override
  String get deleteAccountTitle => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରିବେ?';

  @override
  String deleteAccountBody(int days) {
    return 'ଆପଣ ଏବେ ଲଗ୍ ଆଉଟ୍ ହେବେ। $days ଦିନ ପରେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ପରିବାର ସଦସ୍ୟ, ଠିକଣା ଓ ଡକ୍ୟୁମେଣ୍ଟ ଡିଲିଟ୍ ହେବ। ଆକାଉଣ୍ଟ ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ ପୁଣି ଲଗ୍ ଇନ୍ କରନ୍ତୁ। ଦେୟ ରେକର୍ଡ ଆଇନ ଅନୁସାରେ ରଖାଯାଏ।';
  }

  @override
  String get deleteAccountConfirm => 'ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get accountDeletionRequested => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଶୀଘ୍ର ଡିଲିଟ୍ ହେବ। ରଖିବାକୁ ହେଲେ ପୁଣି ଲଗ୍ ଇନ୍ କରନ୍ତୁ।';

  @override
  String get errTooManyMembers => 'ଆପଣ ଯେତିକି ପରିବାର ସଦସ୍ୟ ଯୋଡ଼ିପାରିବେ, ସେତିକି ଯୋଡ଼ି ସାରିଛନ୍ତି।';

  @override
  String get errTooManyAddresses => 'ପ୍ରତି ବ୍ୟକ୍ତି ପାଇଁ 10ଟି ଠିକଣା ପର୍ଯ୍ୟନ୍ତ। ପ୍ରଥମେ ପୁରୁଣା ଗୋଟିଏ ହଟାନ୍ତୁ।';

  @override
  String get errStorageFull => 'ଆପଣଙ୍କ ଡକ୍ୟୁମେଣ୍ଟ ପୂରା 200 MB ବ୍ୟବହାର କରୁଛି। ପ୍ରଥମେ କିଛି ପୁରୁଣା ଡିଲିଟ୍ କରନ୍ତୁ।';

  @override
  String get errDateInFuture => 'ତାରିଖ ଭବିଷ୍ୟତର ହୋଇପାରିବ ନାହିଁ।';

  @override
  String get errNotFound => 'ଏହା ହଟାଯାଇଛି ବା ଆପଣଙ୍କର ନୁହେଁ।';

  @override
  String get memberNameHint => 'ତାଙ୍କ ପୂରା ନାମ';

  @override
  String get spokenOdia => 'ଓଡ଼ିଆ';

  @override
  String get spokenHindi => 'ହିନ୍ଦୀ';

  @override
  String get spokenEnglish => 'ଇଂରାଜୀ';

  @override
  String get spokenBengali => 'ବଙ୍ଗଳା';

  @override
  String get spokenTelugu => 'ତେଲୁଗୁ';

  @override
  String get alsoDeleteDocuments => 'ତାଙ୍କ ମେଡିକାଲ ଡକ୍ୟୁମେଣ୍ଟ ମଧ୍ୟ ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get pinRequired =>
      'ମାନଚିତ୍ରକୁ ଘୁଞ୍ଚାନ୍ତୁ ଯେପରି ପିନ୍ ଘର ଉପରେ ରହେ, କିମ୍ବା ଆପଣଙ୍କ ବର୍ତ୍ତମାନର ସ୍ଥାନ ବ୍ୟବହାର କରନ୍ତୁ।';

  @override
  String get notificationsLater => 'ଫୋନ୍ ବିଜ୍ଞପ୍ତି ଆସନ୍ତା ଅପଡେଟ୍‌ରେ ଆସିବ। ସେପର୍ଯ୍ୟନ୍ତ ଆପ୍‌ରେ ଦେଖନ୍ତୁ।';

  @override
  String get photoTooLarge => 'ଏହି ଫଟୋ ବହୁତ ବଡ଼ (ସର୍ବାଧିକ 5 MB)।';

  @override
  String accountDeletionOn(String date) {
    return 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ $date ରେ ଡିଲିଟ୍ ହେବ। ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ ପୁଣି ଲଗ୍ ଇନ୍ କରନ୍ତୁ।';
  }

  @override
  String get tabDoctors => 'ଡାକ୍ତର';

  @override
  String get tabHospitals => 'ହସ୍ପିଟାଲ୍';

  @override
  String get searchDoctorsHint => 'ଡାକ୍ତର ବା ବିଶେଷଜ୍ଞତା ଖୋଜନ୍ତୁ…';

  @override
  String get searchHospitalsHint => 'ହସ୍ପିଟାଲ୍, ଅଞ୍ଚଳ ବା ଡାକ୍ତର ଖୋଜନ୍ତୁ…';

  @override
  String get allSpecialities => 'ସବୁ';

  @override
  String get viewProfile => 'ପ୍ରୋଫାଇଲ୍ ଦେଖନ୍ତୁ';

  @override
  String get noDoctorsFound => 'କୌଣସି ଡାକ୍ତର ମିଳିଲେ ନାହିଁ';

  @override
  String get noHospitalsFound => 'କୌଣସି ହସ୍ପିଟାଲ୍ ମିଳିଲା ନାହିଁ';

  @override
  String get tryAnotherSearch => 'ଅନ୍ୟ ଖୋଜ ବା ବିଶେଷଜ୍ଞତା ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String kmAway(String km) {
    return '$km କିମି ଦୂର';
  }

  @override
  String hospitalsWithin(int km) {
    return '$km କିମି ମଧ୍ୟରେ ଥିବା ହସ୍ପିଟାଲ୍';
  }

  @override
  String get hospitalsAll => 'ସବୁ ହସ୍ପିଟାଲ୍';

  @override
  String get hospitalsNoLocation => 'ନିକଟତମ ହସ୍ପିଟାଲ୍ ପ୍ରଥମେ ଦେଖିବାକୁ ଲୋକେସନ୍ ଅନୁମତି ଦିଅନ୍ତୁ।';

  @override
  String get showMap => 'ମାନଚିତ୍ର';

  @override
  String get showList => 'ତାଲିକା';

  @override
  String get hospitalTypeHospital => 'ହସ୍ପିଟାଲ୍';

  @override
  String get hospitalTypeClinic => 'କ୍ଲିନିକ୍';

  @override
  String get hospitalTypeDiagnostic => 'ପରୀକ୍ଷା କେନ୍ଦ୍ର';

  @override
  String get opdHours => 'ଓପିଡି ସମୟ';

  @override
  String get departments => 'ବିଭାଗ';

  @override
  String get doctorsHere => 'ଏଠାର ଡାକ୍ତର';

  @override
  String doctorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ଜଣ ଡାକ୍ତର',
      one: '1 ଜଣ ଡାକ୍ତର',
      zero: 'କୌଣସି ଡାକ୍ତର ନାହାନ୍ତି',
    );
    return '$_temp0';
  }

  @override
  String get callLabel => 'କଲ୍ କରନ୍ତୁ';

  @override
  String get bookCompanionHere => 'ଏହି ହସ୍ପିଟାଲ୍ ପାଇଁ ସାଥୀ ବୁକ୍ କରନ୍ତୁ';

  @override
  String get bookCompanionForDoctor => 'ଏହି ଡାକ୍ତରଙ୍କ ପାଇଁ ସାଥୀ ବୁକ୍ କରନ୍ତୁ';

  @override
  String get qualifications => 'ଯୋଗ୍ୟତା';

  @override
  String get opdDays => 'ଓପିଡି ଦିନ ଓ ସମୟ';

  @override
  String get doctorSpeaks => 'ଭାଷା';

  @override
  String get doctorHospitals => 'ଏଠାରେ ରୋଗୀ ଦେଖନ୍ତି';

  @override
  String get chooseService => 'ଆପଣଙ୍କୁ ଦରକାର ସେବା ବାଛନ୍ତୁ';

  @override
  String totalPrice(String amount) {
    return 'ମୋଟ $amount';
  }

  @override
  String get prescriptionNeeded => 'ପ୍ରେସକ୍ରିପସନ୍ ଦରକାର';

  @override
  String durationMinutes(int minutes) {
    return 'ପ୍ରାୟ $minutes ମିନିଟ୍';
  }

  @override
  String durationHours(int hours) {
    return 'ପ୍ରାୟ $hours ଘଣ୍ଟା';
  }

  @override
  String bookingAt(String place) {
    return '$place ପାଇଁ';
  }

  @override
  String get noServices => 'ଏବେ କୌଣସି ସେବା ଉପଲବ୍ଧ ନାହିଁ।';

  @override
  String get chooseBookingType => 'ଆପଣ କ\'ଣ ବୁକ୍ କରିବାକୁ ଚାହାନ୍ତି?';

  @override
  String get visitDetailsTitle => 'ଭିଜିଟ୍ ବିବରଣୀ';

  @override
  String get hospitalLabel => 'ହସ୍ପିଟାଲ୍';

  @override
  String get hospitalOptionalLabel => 'ହସ୍ପିଟାଲ୍ ବା ଔଷଧ ଦୋକାନ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get chooseHospital => 'ହସ୍ପିଟାଲ୍ ବାଛନ୍ତୁ';

  @override
  String get hospitalNotListed => 'ମୋ ହସ୍ପିଟାଲ୍ ତାଲିକାରେ ନାହିଁ';

  @override
  String get hospitalTextLabel => 'ହସ୍ପିଟାଲ୍ ନାମ ଓ ଅଞ୍ଚଳ';

  @override
  String get hospitalTextHint => 'ଯେପରି ସିଟି କେୟାର୍ ହସ୍ପିଟାଲ୍, ପଟିଆ';

  @override
  String get doctorLabel => 'ଡାକ୍ତର';

  @override
  String get doctorNotSure => 'ଜଣା ନାହିଁ';

  @override
  String get dateLabel => 'ତାରିଖ';

  @override
  String get today => 'ଆଜି';

  @override
  String get tomorrow => 'କାଲି';

  @override
  String get pickADate => 'ତାରିଖ ବାଛନ୍ତୁ';

  @override
  String get appointmentTimeLabel => 'ଡାକ୍ତରଙ୍କ ଆପଏଣ୍ଟମେଣ୍ଟ ସମୟ';

  @override
  String get appointmentTimeHint => 'ସେଟ୍ କରିବାକୁ ଟାପ୍ କରନ୍ତୁ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get pickupTimeLabel => 'ପିକଅପ୍ ସମୟ';

  @override
  String get visitTimeLabel => 'ଭିଜିଟ୍ ସମୟ';

  @override
  String get startTimeLabel => 'ଆରମ୍ଭ ସମୟ';

  @override
  String pickupSuggested(int minutes) {
    return 'ଆପଏଣ୍ଟମେଣ୍ଟର $minutes ମିନିଟ୍ ପୂର୍ବରୁ ପିକଅପ୍ ପରାମର୍ଶ ଦିଆଯାଇଛି। ଆପଣ ଏହା ବଦଳାଇପାରିବେ।';
  }

  @override
  String get noTimesLeft => 'ଏହି ତାରିଖରେ କୌଣସି ସମୟ ବାକି ନାହିଁ। ଅନ୍ୟ ତାରିଖ ବାଛନ୍ତୁ।';

  @override
  String get timesInIst => 'ସମୟ ଭାରତୀୟ ସମୟ (IST) ରେ ଅଛି।';

  @override
  String get notesLabel => 'ନୋଟ୍ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get notesHint => 'ହ୍ୱିଲଚେୟାର୍, ଭାଷା, ଗେଟ୍ ନମ୍ବର…';

  @override
  String get nextLabel => 'ପରବର୍ତ୍ତୀ';

  @override
  String get chooseMemberRequired => 'ବୁକିଂ କାହା ପାଇଁ ବାଛନ୍ତୁ।';

  @override
  String get hospitalRequired => 'ହସ୍ପିଟାଲ୍ ବାଛନ୍ତୁ ବା ନାମ ଲେଖନ୍ତୁ।';

  @override
  String get timeRequired => 'ସମୟ ବାଛନ୍ତୁ।';

  @override
  String get appointmentAfterPickup => 'ଆପଏଣ୍ଟମେଣ୍ଟ ପିକଅପ୍ ସମୟ ପରେ ହେବା ଦରକାର।';

  @override
  String get addressStepTitle => 'ଠିକଣା';

  @override
  String get pickupAddressHelp => 'ସାଥୀ ତାଙ୍କୁ ଏଠାରୁ ନେବେ।';

  @override
  String get homeVisitAddressHelp => 'ଯେଉଁଠି ଭିଜିଟ୍ ହେବ।';

  @override
  String get errandAddressHelp => 'ସାଥୀ ଜିନିଷ ଏଠାକୁ ଆଣିବେ।';

  @override
  String addressesOfName(String name) {
    return '$nameଙ୍କ ଠିକଣା';
  }

  @override
  String get otherAddresses => 'ଅନ୍ୟ ସେଭ୍ ଠିକଣା';

  @override
  String get addressRequiredToBook => 'ଠିକଣା ବାଛନ୍ତୁ।';

  @override
  String get attachDocumentsTitle => 'ଡକ୍ୟୁମେଣ୍ଟ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get attachDocumentsHelp =>
      'ସାଙ୍ଗରେ ନେବାକୁ ଥିବା ରିପୋର୍ଟ ବା ପ୍ରେସକ୍ରିପସନ୍ ବାଛନ୍ତୁ। କେବଳ ନିଯୁକ୍ତ ପାର୍ଟନର୍ ଏହା ଦେଖିବେ।';

  @override
  String get prescriptionRequiredHelp => 'ଏହି ସେବା ପାଇଁ ପ୍ରେସକ୍ରିପସନ୍ ଦରକାର।';

  @override
  String get attachPrescription => 'ଦୟାକରି ପ୍ରେସକ୍ରିପସନ୍ ଯୋଡ଼ନ୍ତୁ।';

  @override
  String noDocumentsForName(String name) {
    return '$nameଙ୍କର ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଡକ୍ୟୁମେଣ୍ଟ ନାହିଁ।';
  }

  @override
  String get reviewTitle => 'ଯାଞ୍ଚ କରି ପୈଠ କରନ୍ତୁ';

  @override
  String get serviceLabel => 'ସେବା';

  @override
  String get whenLabel => 'କେବେ';

  @override
  String get whereLabel => 'କେଉଁଠି';

  @override
  String get documentsLabel => 'ଡକ୍ୟୁମେଣ୍ଟ';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଡକ୍ୟୁମେଣ୍ଟ',
      one: '1ଟି ଡକ୍ୟୁମେଣ୍ଟ',
      zero: 'କିଛି ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get priceTotal => 'ମୋଟ';

  @override
  String get payNowFee => 'ଏବେ ପୈଠ (ବୁକିଂ ଶୁଳ୍କ)';

  @override
  String get payCompanionAfter => 'ଭିଜିଟ୍ ପରେ ସାଥୀଙ୍କୁ ଦିଅନ୍ତୁ';

  @override
  String get payNurseAfter => 'ଭିଜିଟ୍ ପରେ ନର୍ସଙ୍କୁ ଦିଅନ୍ତୁ';

  @override
  String get extrasNote => 'କ୍ୟାବ୍ ବା ଅଟୋ ଭଡ଼ା ଓ ଅତିରିକ୍ତ ସମୟର ଟଙ୍କା ସିଧାସଳଖ ପାର୍ଟନରଙ୍କ ସହ ତୁଲାନ୍ତୁ।';

  @override
  String get paidInFullNote => 'ଆପ୍‌ରେ ସମ୍ପୂର୍ଣ୍ଣ ଦେୟ ହୋଇଗଲା: ଭିଜିଟ୍ ପରେ ସାଥୀ କିମ୍ବା ନର୍ସଙ୍କୁ କିଛି ଦେବାକୁ ନାହିଁ।';

  @override
  String cancellationRule(int percent) {
    return 'ପାର୍ଟନର୍ ବାହାରିବା ପୂର୍ବରୁ ବାତିଲ୍ କଲେ ବୁକିଂ ଶୁଳ୍କର $percent% ଫେରସ୍ତ ମିଳିବ।';
  }

  @override
  String payAmount(String amount) {
    return '$amount ପୈଠ କରନ୍ତୁ';
  }

  @override
  String get errTimeNotAvailable => 'ଏହି ସମୟ ଆଉ ଉପଲବ୍ଧ ନାହିଁ। ଅନ୍ୟ ସମୟ ବାଛନ୍ତୁ।';

  @override
  String get errPrescriptionRequired => 'ଏହି ସେବା ପାଇଁ ପ୍ରେସକ୍ରିପସନ୍ ଦରକାର। ଦୟାକରି ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get errOutsideServiceArea => 'ଆମେ ଏବେ ଏହି ଠିକଣାରେ ସେବା ଦେଉନାହୁଁ। ଅନ୍ୟ ଠିକଣା ବାଛନ୍ତୁ।';

  @override
  String get errTooManyUnpaid => 'ଆପଣଙ୍କର ଅନେକ ବୁକିଂ ପୈଠ ପାଇଁ ଅପେକ୍ଷା କରୁଛି। କିଛି ସମୟ ପରେ ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errTooManyRequests => 'ଏକ ମିନିଟରେ ବହୁତ ପରିବର୍ତ୍ତନ ହେଲା। ଦୟାକରି ଟିକେ ଅପେକ୍ଷା କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errInvalidBooking => 'ବୁକିଂ ବିବରଣୀ ଯାଞ୍ଚ କରନ୍ତୁ।';

  @override
  String get errMemberHasBookings => 'ଏହାଙ୍କର ଏକ ବୁକିଂ ଏପର୍ଯ୍ୟନ୍ତ ଶେଷ ହୋଇନାହିଁ। ପ୍ରଥମେ ତାହା ବାତିଲ୍ କରନ୍ତୁ।';

  @override
  String get errActiveBookings =>
      'ଆପଣଙ୍କର ଏକ ବୁକିଂ ଏପର୍ଯ୍ୟନ୍ତ ଶେଷ ହୋଇନାହିଁ। ତାହା ବାତିଲ୍ କରନ୍ତୁ ବା ଶେଷ ହେବା ଯାଏଁ ଅପେକ୍ଷା କରନ୍ତୁ।';

  @override
  String get bookingSavedTitle => 'ବୁକିଂ ସେଭ୍ ହେଲା';

  @override
  String bookingSavedBody(String code) {
    return 'ଅନଲାଇନ୍ ପୈଠ ଏବେ ଉପଲବ୍ଧ ନାହିଁ। ଆପଣଙ୍କ ବୁକିଂ $code ସେଭ୍ ହୋଇଛି ଓ ପୈଠ ପାଇଁ ଅପେକ୍ଷା କରୁଛି।';
  }

  @override
  String get backToHome => 'ହୋମକୁ ଫେରନ୍ତୁ';

  @override
  String bookingCode(String code) {
    return 'ବୁକିଂ $code';
  }

  @override
  String get nextBooking => 'ପରବର୍ତ୍ତୀ ବୁକିଂ';

  @override
  String get statusPendingPayment => 'ପୈଠ ବାକି';

  @override
  String get statusAssigning => 'ବୁକ୍ ହେଲା। ଆମେ ଆପଣଙ୍କ ପାର୍ଟନର୍ ସ୍ଥିର କରୁଛୁ।';

  @override
  String get statusAssigned => 'ପାର୍ଟନର୍ ସ୍ଥିର ହେଲେ';

  @override
  String get statusInProgress => 'ଚାଲିଛି';

  @override
  String get statusCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get statusNoShow => 'ରୋଗୀ ମିଳିଲେ ନାହିଁ';

  @override
  String get statusCancelled => 'ବାତିଲ୍';

  @override
  String get statusExpired => 'ସମୟରେ ପୈଠ ହେଲା ନାହିଁ';

  @override
  String payBy(String time) {
    return '$time ସୁଦ୍ଧା ପୈଠ କରନ୍ତୁ';
  }

  @override
  String appointmentAt(String time) {
    return 'ଆପଏଣ୍ଟମେଣ୍ଟ $time';
  }

  @override
  String pickupAt(String time) {
    return 'ପିକଅପ୍ $time';
  }

  @override
  String get timelineTitle => 'ସମୟରେଖା';

  @override
  String get eventCreate => 'ବୁକିଂ କରାଗଲା';

  @override
  String get documentRemoved => 'ଡକ୍ୟୁମେଣ୍ଟ ହଟାଗଲା';

  @override
  String get notesTitle => 'ନୋଟ୍';

  @override
  String get yourAddresses => 'ଆପଣଙ୍କ ଠିକଣା';

  @override
  String get youHaveNoDocuments => 'ଆପଣଙ୍କର ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଡକ୍ୟୁମେଣ୍ଟ ନାହିଁ।';

  @override
  String get appointmentTooEarly => 'ଏହି ଆପଏଣ୍ଟମେଣ୍ଟ ପୂର୍ବରୁ କୌଣସି ପିକଅପ୍ ସମୟ ନାହିଁ। ପରର ସମୟ ବା ଅନ୍ୟ ତାରିଖ ବାଛନ୍ତୁ।';

  @override
  String get pickupTooEarly => 'ଏହି ଆପଏଣ୍ଟମେଣ୍ଟ ପାଇଁ ପିକଅପ୍ ବହୁତ ଶୀଘ୍ର। ପରର ପିକଅପ୍ ସମୟ ବାଛନ୍ତୁ।';

  @override
  String get errBookingChanged => 'ଏହି ବୁକିଂ ବଦଳିଛି। ଯାଞ୍ଚ କରି ପୁଣି ପୈଠ ଟାପ୍ କରନ୍ତୁ।';

  @override
  String get paymentProcessingTitle => 'ଆପଣଙ୍କ ପୈଠ ନିଶ୍ଚିତ କରୁଛୁ…';

  @override
  String get paymentProcessingBody =>
      'ଏଥିରେ କିଛି ସେକେଣ୍ଡ ଲାଗେ। ଆପଣ ଏହି ସ୍କ୍ରିନ୍ ଛାଡ଼ିପାରିବେ: ଆମେ ଆପଣଙ୍କୁ ମେସେଜ୍ ପଠାଇବୁ।';

  @override
  String get paymentTakingLong => 'ଆମେ ଏବେ ବି ଆପଣଙ୍କ ପୈଠ ନିଶ୍ଚିତ କରୁଛୁ। ହେବା ମାତ୍ରେ ଆପଣଙ୍କୁ ମେସେଜ୍ ପଠାଇବୁ।';

  @override
  String get paymentConfirmedTitle => 'ବୁକିଂ ନିଶ୍ଚିତ';

  @override
  String get paymentConfirmedBody =>
      'ଆମେ ଆପଣଙ୍କ ପାର୍ଟନର୍ ସ୍ଥିର କରୁଛୁ। ସେ ଗ୍ରହଣ କଲା ପରେ ତାଙ୍କ ନାମ, ଫଟୋ ଓ ଫୋନ୍ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get paymentFailedTitle => 'ପୈଠ ହେଲା ନାହିଁ';

  @override
  String paymentFailedBody(String time) {
    return 'ଯଦି ଟଙ୍କା କଟିଛି, ତାହା ନିଜେ ନିଶ୍ଚିତ ହେବ ବା ଫେରିବ। ଆପଣ $time ପର୍ଯ୍ୟନ୍ତ ପୁଣି ଚେଷ୍ଟା କରିପାରିବେ।';
  }

  @override
  String get paymentCancelledTitle => 'ପୈଠ ବାତିଲ୍ କଲେ';

  @override
  String get viewBooking => 'ବୁକିଂ ଦେଖନ୍ତୁ';

  @override
  String paidAmount(String amount) {
    return '$amount ପୈଠ ହୋଇଛି';
  }

  @override
  String get tabUpcoming => 'ଆଗାମୀ';

  @override
  String get tabOngoing => 'ଚାଲୁଥିବା';

  @override
  String get tabPast => 'ପୂର୍ବର';

  @override
  String get noUpcomingBookings => 'କୌଣସି ଆଗାମୀ ବୁକିଂ ନାହିଁ।';

  @override
  String get noOngoingBookings => 'ଏବେ କିଛି ଚାଲିନାହିଁ।';

  @override
  String get noPastBookings => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ପୂର୍ବ ବୁକିଂ ନାହିଁ।';

  @override
  String get cancelBooking => 'ବୁକିଂ ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get cancelTitle => 'ଏହି ବୁକିଂ ବାତିଲ୍ କରିବେ?';

  @override
  String cancelRefund(String amount, int percent) {
    return 'ଆପଣ $amount (ବୁକିଂ ଶୁଳ୍କର $percent%) 5 ରୁ 7 କାର୍ଯ୍ୟ ଦିବସରେ ଆପଣଙ୍କ ପୈଠ ମାଧ୍ୟମକୁ ଫେରି ପାଇବେ।';
  }

  @override
  String get cancelNoRefund => 'ଏହି ବୁକିଂରେ କୌଣସି ଫେରସ୍ତ ନାହିଁ।';

  @override
  String get cancelReasonLabel => 'ଆପଣ କାହିଁକି ବାତିଲ୍ କରୁଛନ୍ତି?';

  @override
  String get cancelReasonPlans => 'ଯୋଜନା ବଦଳିଲା';

  @override
  String get cancelReasonMistake => 'ଭୁଲରେ ବୁକ୍ ହେଲା';

  @override
  String get cancelReasonOther => 'ଅନ୍ୟ କାରଣ';

  @override
  String get cancelReasonHint => 'ଅଧିକ କୁହନ୍ତୁ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get confirmCancel => 'ହଁ, ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get keepBooking => 'ବୁକିଂ ରଖନ୍ତୁ';

  @override
  String get cancelNotAllowed => 'ଆପଣଙ୍କ ପାର୍ଟନର୍ ବାହାରି ସାରିଛନ୍ତି। ବାତିଲ୍ କରିବାକୁ WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get bookingCancelledSnack => 'ବୁକିଂ ବାତିଲ୍ ହେଲା।';

  @override
  String get refundsTitle => 'ଫେରସ୍ତ';

  @override
  String get refundAwaiting => 'ଅନୁମୋଦନ ବାକି';

  @override
  String get refundPending => 'ଆସୁଛି';

  @override
  String get refundProcessed => 'ଫେରସ୍ତ ହେଲା';

  @override
  String get refundFailed => 'ହେଲା ନାହିଁ: ସହାୟତା ଦଳ ଆପଣଙ୍କୁ କଲ୍ କରିବେ';

  @override
  String get refundRejected => 'ଅନୁମୋଦିତ ନୁହେଁ';

  @override
  String get changeTime => 'ତାରିଖ ବା ସମୟ ବଦଳାନ୍ତୁ';

  @override
  String reschedulesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ପରିବର୍ତ୍ତନ ବାକି',
      one: '1ଟି ପରିବର୍ତ୍ତନ ବାକି',
      zero: 'କୌଣସି ପରିବର୍ତ୍ତନ ବାକି ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get rescheduleTooLate => 'ପିକଅପ୍ ଏତେ ପାଖରେ ସମୟ ବଦଳାଯାଇପାରିବ ନାହିଁ। WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get rescheduleLimit => 'ସମୟ ପୁଣି ବଦଳାଯାଇପାରିବ ନାହିଁ। WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get confirmNewTime => 'ନୂଆ ସମୟ ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get timeChangedSnack => 'ସମୟ ବଦଳିଲା।';

  @override
  String get partnerWillReconfirm => 'ଆପଣଙ୍କ ପାର୍ଟନର୍ ନୂଆ ସମୟ ନିଶ୍ଚିତ କରିବେ।';

  @override
  String currentTime(String time) {
    return 'ଏବେ: $time';
  }

  @override
  String get errNotPayable => 'ଏହି ବୁକିଂର ପୈଠ ଆଉ ହୋଇପାରିବ ନାହିଁ। ଦୟାକରି ପୁଣି ବୁକ୍ କରନ୍ତୁ।';

  @override
  String get errPaymentsNotSetUp => 'ଅନଲାଇନ୍ ପୈଠ ଏବେ ଉପଲବ୍ଧ ନାହିଁ। ପରେ ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errInvalidSignature => 'ଆମେ ଏହି ପୈଠ ନିଶ୍ଚିତ କରିପାରିଲୁ ନାହିଁ। ଟଙ୍କା କଟିଥିଲେ ତାହା ନିଶ୍ଚିତ ହେବ ବା ଫେରିବ।';

  @override
  String get errGateway => 'ପୈଠ ସେବା ଉତ୍ତର ଦେଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get rescheduleNotAllowed => 'ଏବେ ଆପ୍‌ରେ ସମୟ ବଦଳାଯାଇପାରିବ ନାହିଁ। ଦୟାକରି WellWish ସହାୟତାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get eventPaid => 'ବୁକିଂ ଶୁଳ୍କ ଦିଆଗଲା';

  @override
  String get eventRescheduled => 'ତାରିଖ ବା ସମୟ ବଦଳିଲା';

  @override
  String get bookingFeeOnline => 'ବୁକିଂ ଶୁଳ୍କ (ଅନଲାଇନ୍)';

  @override
  String get paymentNotBookedTitle => 'ବୁକିଂ ହେଲା ନାହିଁ';

  @override
  String get paymentNotBookedBody =>
      'ପୈଠ ସମୟ ସରିଗଲା, କିମ୍ବା ପୈଠ କରୁଥିବା ବେଳେ ସେହି ସମୟ ଅନ୍ୟ କେହି ନେଇଗଲେ। ଆପଣଙ୍କ ସମ୍ପୂର୍ଣ୍ଣ ଟଙ୍କା 5 ରୁ 7 କାର୍ଯ୍ୟ ଦିବସରେ ଫେରାଇ ଦିଆଯିବ। ଦୟାକରି ପୁଣି ବୁକ୍ କରନ୍ତୁ।';

  @override
  String get offersTitle => 'ନୂଆ ଅଫର୍';

  @override
  String offerTimeLeft(String time) {
    return 'ଉତ୍ତର ଦେବାକୁ $time ବାକି';
  }

  @override
  String get offerWaiting => 'ଦୟାକରି ଉତ୍ତର ଦିଅନ୍ତୁ: WellWish ଅପେକ୍ଷା କରୁଛି';

  @override
  String get offerReconfirm => 'ସମୟ ବଦଳିଲା: ଦୟାକରି ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get todayJobsTitle => 'ଆଜିର କାମ';

  @override
  String get noJobsToday => 'ଆଜି କୌଣସି କାମ ନାହିଁ।';

  @override
  String get totalsDoneToday => 'ଆଜି ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get totalsThisWeek => 'ଏହି ସପ୍ତାହ';

  @override
  String get totalsUpcoming => 'ଆଗାମୀ';

  @override
  String get selfieTitle => 'ଆଜିର ସେଲ୍ଫି';

  @override
  String get selfieBody => 'ଉପଲବ୍ଧ ହେବା ଆଗରୁ ଗୋଟିଏ ସେଲ୍ଫି ନିଅନ୍ତୁ। WellWish ଏହାକୁ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ଫଟୋ ସହ ମିଳାଏ।';

  @override
  String get takeSelfie => 'ସେଲ୍ଫି ନିଅନ୍ତୁ';

  @override
  String get selfieSaved => 'ସେଲ୍ଫି ସେଭ୍ ହେଲା। ଆପଣ ଆଜି ଉପଲବ୍ଧ।';

  @override
  String get selfieNeeded => 'ପ୍ରଥମେ ଆଜିର ସେଲ୍ଫି ନିଅନ୍ତୁ।';

  @override
  String get offerTitle => 'ବୁକିଂ ଅଫର୍';

  @override
  String get offerArea => 'ଅଞ୍ଚଳ';

  @override
  String offerDistance(String km) {
    return 'ଆପଣଙ୍କ ଘରୁ $km km';
  }

  @override
  String get offerPatient => 'ରୋଗୀ';

  @override
  String get offerNeeds => 'ଆବଶ୍ୟକତା';

  @override
  String offerDocuments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଦସ୍ତାବିଜ ଯୋଡ଼ାଯାଇଛି',
      one: '1ଟି ଦସ୍ତାବିଜ ଯୋଡ଼ାଯାଇଛି',
      zero: 'କୌଣସି ଦସ୍ତାବିଜ ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get offerPrescription => 'ପ୍ରେସକ୍ରିପସନ୍ ଯୋଡ଼ାଯାଇଛି';

  @override
  String offerBalance(String amount) {
    return 'କାମ ପରେ ଆପଣ $amount ନେବେ';
  }

  @override
  String get offerDetailsLater => 'ଗ୍ରହଣ କଲା ପରେ ସମ୍ପୂର୍ଣ୍ଣ ଠିକଣା, ଫୋନ୍ ନମ୍ବର, ସ୍ୱାସ୍ଥ୍ୟ ତଥ୍ୟ ଓ ଦସ୍ତାବିଜ ଦେଖାଯିବ।';

  @override
  String get acceptOffer => 'ଗ୍ରହଣ କରନ୍ତୁ';

  @override
  String get acceptNewTime => 'ନୂଆ ସମୟ ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get declineOffer => 'ମନା କରନ୍ତୁ';

  @override
  String get declineTitle => 'ଆପଣ କାହିଁକି ନେଇପାରିବେ ନାହିଁ?';

  @override
  String get declineNotAvailable => 'ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get declineTooFar => 'ବହୁତ ଦୂର';

  @override
  String get declineOther => 'ଅନ୍ୟ କାରଣ';

  @override
  String get declineNoteHint => 'ନୋଟ୍ ଲେଖନ୍ତୁ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get offerDeclined => 'ମନା କଲେ। WellWish ଅନ୍ୟ କାହାକୁ ଖୋଜିବ।';

  @override
  String get errOfferNotOpen => 'ଏହି ବୁକିଂ ଆଉ ଆପଣଙ୍କର ନୁହେଁ।';

  @override
  String get errPartnerBusy => 'ସେହି ସମୟରେ ଆପଣଙ୍କର ଅନ୍ୟ କାମ ଅଛି।';

  @override
  String get jobsNew => 'ନୂଆ';

  @override
  String get jobsUpcoming => 'ଆଗାମୀ';

  @override
  String get jobsCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get noOffers => 'କୌଣସି ନୂଆ ଅଫର୍ ନାହିଁ।';

  @override
  String get noUpcomingJobs => 'କୌଣସି ଆଗାମୀ କାମ ନାହିଁ।';

  @override
  String get noCompletedJobs => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସମ୍ପୂର୍ଣ୍ଣ କାମ ନାହିଁ।';

  @override
  String jobTitle(String code) {
    return 'କାମ $code';
  }

  @override
  String get jobAddress => 'ଠିକଣା';

  @override
  String get navigate => 'ରାସ୍ତା ଦେଖନ୍ତୁ';

  @override
  String get navigateHospital => 'ଡାକ୍ତରଖାନାର ରାସ୍ତା ଦେଖନ୍ତୁ';

  @override
  String get callPatient => 'ରୋଗୀଙ୍କୁ କଲ୍ କରନ୍ତୁ';

  @override
  String callBooker(String name) {
    return '$nameଙ୍କୁ (ବୁକ୍ କରିଥିବା) କଲ୍ କରନ୍ତୁ';
  }

  @override
  String collectBalance(String amount) {
    return 'କାମ ପରେ $amount ନିଅନ୍ତୁ';
  }

  @override
  String get jobAccepted => 'ଗ୍ରହଣ କରାଯାଇଛି';

  @override
  String get reconfirmPending => 'ସମୟ ବଦଳିଛି। ନୂଆ ଅଫର୍‌ରେ ନୂଆ ସମୟ ନିଶ୍ଚିତ କରନ୍ତୁ।';

  @override
  String get openDocument => 'ଖୋଲନ୍ତୁ';

  @override
  String get yourPartner => 'ଆପଣଙ୍କ ପାର୍ଟନର୍';

  @override
  String callName(String name) {
    return '$nameଙ୍କୁ କଲ୍ କରନ୍ତୁ';
  }

  @override
  String ratingCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countଟି ସମୀକ୍ଷା', one: '1ଟି ସମୀକ୍ଷା');
    return '$rating ($_temp0)';
  }

  @override
  String get newPartner => 'ନୂଆ ପାର୍ଟନର୍';

  @override
  String get offerAccepted => 'ଏହି କାମ ଆପଣଙ୍କର।';

  @override
  String get openJob => 'କାମ ଖୋଲନ୍ତୁ';

  @override
  String get stepOnTheWay => 'ରାସ୍ତାରେ';

  @override
  String get stepReachedPatient => 'ରୋଗୀଙ୍କ ପାଖରେ ପହଞ୍ଚିଲେ';

  @override
  String get stepPickedUp => 'ସାଥିରେ ନେଲେ';

  @override
  String get stepReachedHospital => 'ଡାକ୍ତରଖାନାରେ';

  @override
  String get stepVisitDone => 'ଡାକ୍ତର ଦେଖାଇ ସାରିଲେ';

  @override
  String get stepDroppedHome => 'ଘରେ ଛାଡ଼ିଦେଲେ';

  @override
  String get stepReachedHome => 'ଘରେ ପହଞ୍ଚିଲେ';

  @override
  String get stepStarted => 'ଯତ୍ନ ଆରମ୍ଭ';

  @override
  String get stepCareDone => 'ଯତ୍ନ ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get stepAtPlace => 'ଡାକ୍ତରଖାନା / ଔଷଧ ଦୋକାନରେ';

  @override
  String get stepTaskDone => 'କାମ ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get stepDelivered => 'ପହଞ୍ଚାଇ ଦେଲେ';

  @override
  String get stepCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get activeJobTitle => 'ଏବେର କାମ';

  @override
  String nextStepIs(String step) {
    return 'ପରବର୍ତ୍ତୀ: $step';
  }

  @override
  String get tapWhenDone => 'ଏହା ହେଲେ ଦବାନ୍ତୁ';

  @override
  String get sharingLocation => 'ଆପଣଙ୍କ ଅବସ୍ଥାନ ରୋଗୀଙ୍କ ସହ ସେୟାର ହେଉଛି';

  @override
  String get locationOffHelp =>
      'ଆପଣଙ୍କ ଅବସ୍ଥାନ ମିଳୁନାହିଁ। WellWish Partnerକୁ ଅବସ୍ଥାନ ଅନୁମତି ଦିଅନ୍ତୁ ଏବଂ Location ଚାଲୁ କରନ୍ତୁ।';

  @override
  String get fgsTitle => 'WellWish ଭିଜିଟ୍';

  @override
  String get fgsText => 'ଏହି ଭିଜିଟ୍ ପାଇଁ ଆପଣଙ୍କ ଅବସ୍ଥାନ ରୋଗୀଙ୍କ ସହ ସେୟାର ହେଉଛି';

  @override
  String get enterOtpTitle => 'ଭିଜିଟ୍ କୋଡ୍ ମାଗନ୍ତୁ';

  @override
  String get enterOtpBody => 'ପରିବାର ପାଖରେ WellWish ଆପ୍ କିମ୍ବା SMSରେ 4 ଅଙ୍କର କୋଡ୍ ଅଛି।';

  @override
  String jobOtpWrong(int tries) {
    return 'ଭୁଲ କୋଡ୍। $triesଟି ଚେଷ୍ଟା ବାକି।';
  }

  @override
  String otpWaitUntil(String time) {
    return 'ବହୁତ ଭୁଲ କୋଡ୍। $timeରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ, କିମ୍ବା WellWishକୁ କଲ୍ କରନ୍ତୁ: ସେମାନେ ପରିବାର ସହ ନିଶ୍ଚିତ କରିପାରିବେ।';
  }

  @override
  String get jobOtpLastTry => 'ଭୁଲ କୋଡ୍। ଆଉ ଗୋଟିଏ ଭୁଲ କୋଡ୍ ହେଲେ 5 ମିନିଟ୍ ଅପେକ୍ଷା କରିବାକୁ ପଡ଼ିବ।';

  @override
  String get noNetworkOtp => 'ନେଟୱାର୍କ ନାହିଁ। କୋଡ୍ ନିଶ୍ଚିତ କରିବାକୁ WellWishକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get stepQueued => 'ଫୋନରେ ସେଭ୍ ହେଲା। ନେଟୱାର୍କ ଆସିଲେ ପଠାଯିବ।';

  @override
  String pendingSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countଟି ପଦକ୍ଷେପ', one: '1ଟି ପଦକ୍ଷେପ');
    return 'ନେଟୱାର୍କ ଅପେକ୍ଷା: $_temp0 ପଠାଇବା ବାକି';
  }

  @override
  String get stepsRefused =>
      'ଆପଣଙ୍କ ଫୋନରେ ସେଭ୍ ହୋଇଥିବା ଗୋଟିଏ ପଦକ୍ଷେପ ଗ୍ରହଣ ହେଲା ନାହିଁ (WellWish ହୁଏତ ପୂର୍ବରୁ ଦର୍ଜ କରିସାରିଛି)। ତଳେ ପଦକ୍ଷେପଗୁଡ଼ିକ ଦେଖନ୍ତୁ କିମ୍ବା WellWishକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String tooEarlyToStart(String time) {
    return 'ଆରମ୍ଭ କରିବା ପାଇଁ ବହୁତ ଶୀଘ୍ର। ଆପଣ $timeରୁ \"ରାସ୍ତାରେ\" ଦବାଇପାରିବେ।';
  }

  @override
  String get shareAgain => 'ପୁଣି ସେୟାର୍ କରନ୍ତୁ';

  @override
  String get callWellWish => 'WellWishକୁ କଲ୍ କରନ୍ତୁ';

  @override
  String waitTimer(String time) {
    return 'ରୋଗୀଙ୍କ ପାଇଁ ଅପେକ୍ଷା: $time ବାକି';
  }

  @override
  String get patientNotAvailable => 'ରୋଗୀ ଉପଲବ୍ଧ ନାହାଁନ୍ତି';

  @override
  String get noShowConfirm => 'ରୋଗୀଙ୍କୁ ଉପଲବ୍ଧ ନାହାଁନ୍ତି ବୋଲି ମାର୍କ କରିବେ? WellWish ଯାଞ୍ଚ କରିବ।';

  @override
  String get callFirst => 'ପ୍ରଥମେ ରୋଗୀଙ୍କୁ କଲ୍ କରି ଦେଖନ୍ତୁ।';

  @override
  String get noShowDone => 'ମାର୍କ ହେଲା: ରୋଗୀ ଉପଲବ୍ଧ ନାହାଁନ୍ତି। WellWish ଯାଞ୍ଚ କରିବ।';

  @override
  String get jobFinished => 'କାମ ସମ୍ପୂର୍ଣ୍ଣ। ଧନ୍ୟବାଦ!';

  @override
  String get sos => 'SOS';

  @override
  String get sosTitle => 'ଜରୁରୀକାଳୀନ';

  @override
  String get sosBody =>
      'WellWish ଓ ଜରୁରୀକାଳୀନ ସମ୍ପର୍କଙ୍କୁ ଆପଣଙ୍କ ଅବସ୍ଥାନ ସହ ଆଲର୍ଟ ଯିବ। ପୋଲିସ ପାଇଁ 112, ଆମ୍ବୁଲାନ୍ସ ପାଇଁ 108 କଲ୍ କରନ୍ତୁ।';

  @override
  String get sendSos => 'WellWishକୁ SOS ପଠାନ୍ତୁ';

  @override
  String get sosSent => 'WellWishକୁ ଆଲର୍ଟ ପଠାଗଲା।';

  @override
  String get call112 => '112 କଲ୍ (ପୋଲିସ)';

  @override
  String get call108 => '108 କଲ୍ (ଆମ୍ବୁଲାନ୍ସ)';

  @override
  String get careNoteTitle => 'ଯତ୍ନ ନୋଟ୍';

  @override
  String get careNoteHint => 'ଆପଣ କ\'ଣ କଲେ ଓ ରୋଗୀ କିପରି ଅଛନ୍ତି';

  @override
  String get careNoteRequired => 'ଦୟାକରି ଛୋଟ ଯତ୍ନ ନୋଟ୍ ଲେଖନ୍ତୁ।';

  @override
  String get vitalsTitle => 'ଭାଇଟାଲ୍ସ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get bpLabel => 'BP (ଯଥା 120/80)';

  @override
  String get pulseLabel => 'ନାଡ଼ି';

  @override
  String get temperatureLabel => 'ତାପମାତ୍ରା (°F)';

  @override
  String get spo2Label => 'SpO₂ (%)';

  @override
  String get sugarLabel => 'ସୁଗାର (mg/dL)';

  @override
  String get saveCareNote => 'ସେଭ୍ କରି ଯତ୍ନ ସମ୍ପୂର୍ଣ୍ଣ ମାର୍କ କରନ୍ତୁ';

  @override
  String get invalidValue => 'ଏହି ମୂଲ୍ୟ ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get collectTitle => 'ବାକି ରାଶି ନିଅନ୍ତୁ';

  @override
  String get collectBody => 'ଯାହା ନେଲେ ତାହା ଲେଖନ୍ତୁ। ଏହି ଟଙ୍କା WellWish ପାଖକୁ ଆସେ ନାହିଁ।';

  @override
  String get amountRupees => 'ରାଶି (₹)';

  @override
  String get payCash => 'ନଗଦ';

  @override
  String get payUpi => 'UPI';

  @override
  String get balanceNoteHint => 'ନୋଟ୍ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get recordBalance => 'ରାଶି ଲେଖନ୍ତୁ';

  @override
  String balanceRecorded(String amount, String mode) {
    return '$amount ନେଲେ ($mode)';
  }

  @override
  String get balanceNotDue => 'ନେବାକୁ କିଛି ନାହିଁ: ଆପ୍‌ରେ ସମ୍ପୂର୍ଣ୍ଣ ଦେୟ ହୋଇଗଲା।';

  @override
  String balanceTooHigh(String amount) {
    return 'ଏହା ନେବାକୁ ଥିବା ରାଶି ($amount)ଠାରୁ ଅଧିକ।';
  }

  @override
  String get totalsTitle => 'ମୋଟ';

  @override
  String get jobsDoneTitle => 'ସମ୍ପୂର୍ଣ୍ଣ କାମ';

  @override
  String get totalsThisMonth => 'ଏହି ମାସ';

  @override
  String get totalsAllTime => 'ଏପର୍ଯ୍ୟନ୍ତ';

  @override
  String get balanceCollectedTitle => 'ନିଆଯାଇଥିବା ରାଶି';

  @override
  String cashUpi(String cash, String upi) {
    return 'ନଗଦ $cash · UPI $upi';
  }

  @override
  String get offersTitleTotals => 'ଅଫର୍';

  @override
  String offersLine(int received, int accepted, int declined, int late) {
    return '$received ମିଳିଲା · $accepted ଗ୍ରହଣ · $declined ମନା · $late 2 ମିନିଟରେ ଉତ୍ତର ନାହିଁ';
  }

  @override
  String get ratingTitle => 'ରେଟିଂ';

  @override
  String get noReviewsYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ରିଭ୍ୟୁ ନାହିଁ';

  @override
  String get seeTotals => 'ମୋଟ ଦେଖନ୍ତୁ';

  @override
  String get visitCodeTitle => 'ଭିଜିଟ୍ କୋଡ୍';

  @override
  String visitCodeHelp(String name) {
    return '$name ପହଞ୍ଚିଲେ ତାଙ୍କୁ ଏହି କୋଡ୍ ଦିଅନ୍ତୁ। ଫୋନରେ କାହାକୁ କୁହନ୍ତୁ ନାହିଁ।';
  }

  @override
  String get trackLive => 'ଲାଇଭ୍ ଦେଖନ୍ତୁ';

  @override
  String get liveEnded => 'ଭିଜିଟ୍ ଶେଷ ହେଲା। ଲାଇଭ୍ ଲୋକେସନ୍ ବନ୍ଦ ହୋଇଗଲା।';

  @override
  String get backToBooking => 'ବୁକିଂକୁ ଫେରନ୍ତୁ';

  @override
  String nowStep(String step) {
    return 'ଏବେ: $step';
  }

  @override
  String get chooseStars => '1ରୁ 5 ଷ୍ଟାର୍ ବାଛନ୍ତୁ';

  @override
  String starsSemantics(int count) {
    return '$count ଷ୍ଟାର୍';
  }

  @override
  String get reportTooShort => 'ଦୟାକରି କିଛି ଶବ୍ଦ ଲେଖନ୍ତୁ';

  @override
  String get sendReport => 'ପଠାନ୍ତୁ';

  @override
  String get errAlreadyReviewed => 'ଆପଣ ଏହି ଭିଜିଟ୍‌କୁ ପୂର୍ବରୁ ରେଟିଂ ଦେଇସାରିଛନ୍ତି।';

  @override
  String get errNotReviewable => 'ଏହି ଭିଜିଟ୍‌କୁ ରେଟିଂ ଦିଆଯାଇପାରିବ ନାହିଁ।';

  @override
  String get errReportTooLate => 'ଭିଜିଟ୍‌ର 24 ଘଣ୍ଟା ପର୍ଯ୍ୟନ୍ତ ସମସ୍ୟା ଜଣାଇପାରିବେ। ଦୟାକରି WellWishକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get errNotInProgress => 'ଭିଜିଟ୍ ଏବେ ଚାଲୁନାହିଁ। ଜରୁରୀକାଳୀନ ପାଇଁ 112କୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get liveTitle => 'ଲାଇଭ୍ ଭିଜିଟ୍';

  @override
  String etaMinutes(int minutes) {
    return 'ପ୍ରାୟ $minutes ମିନିଟ୍ ଦୂର';
  }

  @override
  String etaHours(int hours, int minutes) {
    return 'ପ୍ରାୟ $hours ଘଣ୍ଟା $minutes ମିନିଟ୍ ଦୂର';
  }

  @override
  String updatedAt(String time) {
    return '$timeରେ ଅପଡେଟ୍';
  }

  @override
  String waitingForLocation(String name) {
    return '$nameଙ୍କ ଅବସ୍ଥାନ ପାଇଁ ଅପେକ୍ଷା…';
  }

  @override
  String get shareTrip => 'ଯାତ୍ରା ସେୟାର୍ କରନ୍ତୁ';

  @override
  String get linkCopied => 'ଲିଙ୍କ୍ କପି ହେଲା। WhatsApp କିମ୍ବା SMSରେ ପଠାନ୍ତୁ।';

  @override
  String get visitCompleted => 'ଭିଜିଟ୍ ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String payPartner(String amount, String name) {
    return '$nameଙ୍କୁ $amount ଦିଅନ୍ତୁ';
  }

  @override
  String get payPartnerHelp =>
      'ବାକି ରାଶି ସିଧାସଳଖ ଆପଣଙ୍କ ସାଥୀ ବା ନର୍ସଙ୍କୁ ଦିଅନ୍ତୁ (ନଗଦ ବା UPI)। କ୍ୟାବ୍ ଭଡ଼ା ଓ ଅତିରିକ୍ତ ସମୟ ତାଙ୍କ ସହ ସ୍ଥିର କରନ୍ତୁ।';

  @override
  String get rateVisit => 'ଭିଜିଟ୍‌କୁ ରେଟ୍ କରନ୍ତୁ';

  @override
  String get reviewCommentHint => 'ଆଉ କିଛି କହିବେ? (ଇଚ୍ଛାଧୀନ)';

  @override
  String get sendRating => 'ରେଟିଂ ପଠାନ୍ତୁ';

  @override
  String get ratingThanks => 'ରେଟିଂ ପାଇଁ ଧନ୍ୟବାଦ!';

  @override
  String get yourRating => 'ଆପଣଙ୍କ ରେଟିଂ';

  @override
  String get tagOnTime => 'ସମୟରେ';

  @override
  String get tagKind => 'ଦୟାଳୁ';

  @override
  String get tagHelpful => 'ସହାୟକ';

  @override
  String get tagProfessional => 'ପେସାଦାର';

  @override
  String get tagGoodCommunication => 'ଭଲରେ ବୁଝାଇଲେ';

  @override
  String get tagLate => 'ଡେରି';

  @override
  String get tagRude => 'ଅଭଦ୍ର';

  @override
  String get tagUnhelpful => 'ସହାୟକ ନୁହେଁ';

  @override
  String get reportProblem => 'ସମସ୍ୟା ଜଣାନ୍ତୁ';

  @override
  String get reportHint => 'କ\'ଣ ଭୁଲ ହେଲା?';

  @override
  String get reportSent => 'ପଠାଗଲା। WellWish ଆପଣଙ୍କ ସହ ଯୋଗାଯୋଗ କରିବ।';

  @override
  String get reportedProblems => 'ଆପଣ ଜଣାଇଥିବା ସମସ୍ୟା';

  @override
  String get wellwishReplied => 'WellWishର ଉତ୍ତର';

  @override
  String get ticketClosed => 'ବନ୍ଦ';

  @override
  String get ticketOpen => 'ଖୋଲା';

  @override
  String noShowShown(String name) {
    return '$name ରୋଗୀଙ୍କୁ ଦେଖା କରିପାରିଲେ ନାହିଁ। WellWish ଆପଣଙ୍କୁ କଲ୍ କରିବ।';
  }

  @override
  String get docTypeCareNote => 'ଯତ୍ନ ନୋଟ୍';

  @override
  String get vitalsLine => 'ଭାଇଟାଲ୍ସ';

  @override
  String get bpShort => 'ବିପି';

  @override
  String get careNoteBy => 'ଭିଜିଟ୍‌ରେ ନର୍ସ ଲେଖିଛନ୍ତି';

  @override
  String get tempHomeTitle => 'ଆପଣଙ୍କ WellWish କାମ';

  @override
  String get tempHomeBody => 'WellWish ଆପଣଙ୍କୁ ଏହି ଗୋଟିଏ ଭିଜିଟ୍ ଦେଇଛି। ତଳେ ଥିବା ପଦକ୍ଷେପଗୁଡ଼ିକ ଗୋଟିଏ ଗୋଟିଏ କରି କରନ୍ତୁ।';

  @override
  String get tempSelfieBody =>
      'ଆରମ୍ଭ କରିବା ଆଗରୁ ଗୋଟିଏ ସେଲ୍ଫି ନିଅନ୍ତୁ। ପରିବାର ଏବଂ WellWish ଏହାକୁ ଏହି ଭିଜିଟ୍ ପାଇଁ ଆପଣଙ୍କ ଫଟୋ ଭାବେ ଦେଖନ୍ତି।';

  @override
  String get tempSelfieSaved => 'ସେଲ୍ଫି ସେଭ୍ ହେଲା। ଏବେ ଆପଣ କାମ ଆରମ୍ଭ କରିପାରିବେ।';

  @override
  String get tempJobOver => 'ଆପଣଙ୍କ WellWish କାମ ଶେଷ ହୋଇଗଲା। ଧନ୍ୟବାଦ!';

  @override
  String get rootedWarning =>
      'ଏହି ଫୋନ୍ ରୁଟ୍ କରାଯାଇଥିବା ପରି ଲାଗୁଛି। ଏଥିରେ ରୋଗୀଙ୍କ ତଥ୍ୟ ଓ ଆପଣଙ୍କ ଆକାଉଣ୍ଟ କମ୍ ସୁରକ୍ଷିତ। ଦୟାକରି WellWish କାମ ପାଇଁ ରୁଟ୍ ହୋଇନଥିବା ଫୋନ୍ ବ୍ୟବହାର କରନ୍ତୁ।';

  @override
  String get otpFieldLabel => '6 ଅଙ୍କର କୋଡ୍';

  @override
  String paidPartner(String amount, String name) {
    return '$nameଙ୍କୁ $amount ଦିଆଗଲା';
  }

  @override
  String get legalTitle => 'ସର୍ତ୍ତାବଳୀ ଓ ନୀତି';

  @override
  String get legalTerms => 'ବ୍ୟବହାର ସର୍ତ୍ତାବଳୀ';

  @override
  String get legalPrivacy => 'ଗୋପନୀୟତା ନୀତି';

  @override
  String get legalRefunds => 'ଫେରସ୍ତ ନୀତି';

  @override
  String get legalPartnerTerms => 'ପାର୍ଟନର ସର୍ତ୍ତାବଳୀ';

  @override
  String legalRead(String page) {
    return '$page ପଢ଼ନ୍ତୁ';
  }

  @override
  String get consentPartnerTerms => 'ମୁଁ ପାର୍ଟନର ସର୍ତ୍ତାବଳୀ ସ୍ୱୀକାର କରୁଛି';

  @override
  String get consentPartnerTermsDetail => 'କାମ, ଲୋକେସନ୍ ସେୟାର୍, ବ୍ୟବହାର ଓ ଆପଣଙ୍କ ଆକାଉଣ୍ଟ କିପରି ଚାଲେ।';

  @override
  String get partnerDeleteAccountHelp => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ଫୋନ୍ ନମ୍ବର, ଇମେଲ୍ ଓ ଡକ୍ୟୁମେଣ୍ଟ ଡିଲିଟ୍ କରେ।';

  @override
  String partnerDeleteAccountBody(int days) {
    return 'ଆପଣ ଏବେ ଲଗ୍ ଆଉଟ୍ ହେବେ। $days ଦିନ ପରେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍, ଫୋନ୍ ନମ୍ବର, ଇମେଲ୍, ଠିକଣା ଓ ଡକ୍ୟୁମେଣ୍ଟ ଡିଲିଟ୍ ହେବ। ଆକାଉଣ୍ଟ ରଖିବାକୁ ହେଲେ ତା ପୂର୍ବରୁ ପୁଣି ଲଗ୍ ଇନ୍ କରନ୍ତୁ। ଆପଣଙ୍କ ପୁରୁଣା କାମର ରେକର୍ଡ ଆପଣଙ୍କ ବ୍ୟକ୍ତିଗତ ତଥ୍ୟ ବିନା ରହିବ।';
  }

  @override
  String get errorActiveJobs =>
      'ଆପଣଙ୍କର ଗୋଟିଏ ଗ୍ରହଣ କରାଯାଇଥିବା ବା ଚାଲିଥିବା କାମ ଅଛି। WellWishକୁ ତାହା ଅନ୍ୟଙ୍କୁ ଦେବାକୁ କୁହନ୍ତୁ, ତା\'ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get accountErased => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ ହୋଇଗଲା।';

  @override
  String get deleteLoginBody =>
      'Partner ଆପ୍‌ରେ ଏହି ନମ୍ବର ପାଇଁ ଆଉ କିଛି ସେଭ୍ ହୋଇନାହିଁ। ଏହା ଏବେ ଡିଲିଟ୍ ହେବ ଓ ଆପଣ ଲଗ୍ ଆଉଟ୍ ହେବେ।';

  @override
  String get consentChanged => 'WellWish ଏବେ ଏହି ପୃଷ୍ଠାଗୁଡ଼ିକ ବଦଳାଇଛି। ଦୟାକରି ପୁଣି ପଢ଼ି ସ୍ୱୀକାର କରନ୍ତୁ।';

  @override
  String get errUploadAgain => 'ଅପଲୋଡ୍‌ରେ ବହୁତ ସମୟ ଲାଗିଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';
}
