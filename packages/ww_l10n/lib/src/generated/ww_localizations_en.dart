// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'ww_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class WWLocalizationsEn extends WWLocalizations {
  WWLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WellWish';

  @override
  String get partnerBadge => 'Partner';

  @override
  String get brandTagline => 'आपकी सेहत, हमारी ज़िम्मेदारी';

  @override
  String get loading => 'Loading…';

  @override
  String get tryAgain => 'Try again';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get noInternet => 'No internet connection. Check your network and try again.';

  @override
  String get loginWelcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Login to continue';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle => 'Enter your mobile number to get started';

  @override
  String get partnerLoginSubtitle => 'Log in, or join as a companion or nurse, with your mobile number';

  @override
  String get partnerLoginTitle => 'Welcome';

  @override
  String get partnerJoinHint => 'New partner? Enter your number to start your application.';

  @override
  String get phoneHint => 'Enter mobile number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get orDivider => 'OR';

  @override
  String get loginWith => 'Login with';

  @override
  String get google => 'Google';

  @override
  String get newHere => 'New here?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get login => 'Login';

  @override
  String get invalidPhone => 'Enter a valid 10-digit mobile number';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSentTo(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String get changeNumber => 'Change number';

  @override
  String get verify => 'Verify';

  @override
  String resendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get codeResent => 'A new code was sent';

  @override
  String otpWrong(int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts tries left.',
      one: '1 try left.',
    );
    return 'That code isn\'t right. $_temp0';
  }

  @override
  String get otpExpired => 'This code has expired. Tap Resend code.';

  @override
  String get otpTooManyAttempts => 'Too many wrong tries. Tap Resend code for a new one.';

  @override
  String get otpLocked => 'Too many wrong codes. Please try again in an hour.';

  @override
  String get otpRateLimited => 'Too many code requests. Please try again later.';

  @override
  String get smsNotSent => 'We couldn\'t send the SMS. Please try again.';

  @override
  String get accountBlocked => 'This account is blocked. Please contact WellWish support.';

  @override
  String get googleFailed => 'Google sign-in didn\'t work. Please try again.';

  @override
  String get googleVerifyPhone => 'Verify your mobile number once to finish signing in with Google.';

  @override
  String get profileSetupTitle => 'Tell us about you';

  @override
  String get profileSetupSubtitle => 'This helps your companion or nurse take good care of you.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'As on your ID card';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get selectDate => 'Select date';

  @override
  String get gender => 'Gender';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get genderOther => 'Other';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageOdia => 'ଓଡ଼ିଆ';

  @override
  String get continueLabel => 'Continue';

  @override
  String get nameRequired => 'Please enter your full name';

  @override
  String get dobRequired => 'Please select your date of birth';

  @override
  String get genderRequired => 'Please select your gender';

  @override
  String get consentTitle => 'Before you start';

  @override
  String get consentSubtitle => 'Please read and accept to use WellWish.';

  @override
  String get consentTerms => 'I accept the Terms of Use';

  @override
  String get consentTermsDetail => 'How bookings, payments, cancellations and refunds work.';

  @override
  String get consentPrivacy => 'I accept the Privacy Policy';

  @override
  String get consentPrivacyDetail => 'Your data stays in India and is never sold.';

  @override
  String get consentHealthData => 'I allow WellWish to keep my health documents';

  @override
  String get consentHealthDataDetail =>
      'They are shown only to the companion or nurse assigned to your booking, during the visit.';

  @override
  String get agreeAndContinue => 'Agree and continue';

  @override
  String get locationTitle => 'Find hospitals near you';

  @override
  String get locationBody => 'Allow location so we can show hospitals and clinics close to you. We don\'t track you.';

  @override
  String get allowLocation => 'Allow location';

  @override
  String get notNow => 'Not now';

  @override
  String helloName(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeTagline => 'Take care. You matter!';

  @override
  String get heroTitle => 'Your Health, Our Priority';

  @override
  String get heroSubtitle => 'Get the best care with WellWish';

  @override
  String get tileDoctors => 'Doctors';

  @override
  String get tileBookCompanion => 'Book a Companion';

  @override
  String get tileBookNurse => 'Book a Nurse';

  @override
  String get tileMedicalReports => 'Medical Reports';

  @override
  String get tileFamily => 'Family';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get comingSoonBody => 'This part of WellWish opens in an upcoming update.';

  @override
  String get navHome => 'Home';

  @override
  String get navDoctors => 'Doctors';

  @override
  String get navReports => 'Reports';

  @override
  String get navFamily => 'Family';

  @override
  String get navProfile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get verified => 'Verified';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get myReports => 'My Reports';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get logout => 'Logout';

  @override
  String get logoutEverywhere => 'Log out on all devices';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmBody => 'You\'ll need an OTP to log in again.';

  @override
  String get cancel => 'Cancel';

  @override
  String get sessionExpired => 'Your session ended. Please log in again.';

  @override
  String get loggedInElsewhere => 'You logged in on another phone, so you were logged out here.';

  @override
  String get updateTitle => 'Update WellWish';

  @override
  String get updateBody => 'A new version is available. Please update the app to continue.';

  @override
  String get updateNow => 'Update now';

  @override
  String get partnerRegisterTitle => 'Become a WellWish partner';

  @override
  String get partnerRegisterBody =>
      'Registration for companions and nurses opens in the next update. You\'ll be able to add your details and documents here.';

  @override
  String loggedInAs(String phone) {
    return 'Logged in as $phone';
  }

  @override
  String get registerRoleTitle => 'What work will you do?';

  @override
  String get registerRoleSubtitle => 'You can change this until you send your application.';

  @override
  String get roleCompanion => 'Companion';

  @override
  String get roleCompanionBody =>
      'Take patients to the doctor, help at the hospital, run medicine errands and care for elders at home.';

  @override
  String get roleNurse => 'Nurse';

  @override
  String get roleNurseBody =>
      'Injections, wound dressing, IV drips and nursing shifts at home. Needs a nursing qualification and council registration.';

  @override
  String get registerHubSubtitle => 'Finish these steps, then send your application for review.';

  @override
  String get stepRole => 'Work type';

  @override
  String get stepContact => 'Alternate number and email';

  @override
  String get stepProfile => 'Your profile';

  @override
  String get stepDocuments => 'Documents';

  @override
  String get stepDone => 'Done';

  @override
  String get stepTodo => 'To do';

  @override
  String documentsProgress(int done, int total) {
    return '$done of $total uploaded';
  }

  @override
  String get submitForReview => 'Send for review';

  @override
  String get submitHint => 'Finish every step to send your application.';

  @override
  String get change => 'Change';

  @override
  String get save => 'Save';

  @override
  String get contactTitle => 'Phones and email';

  @override
  String get loginNumber => 'Login number';

  @override
  String get alternateNumber => 'Alternate number';

  @override
  String get alternateHelp => 'A second number, e.g. a family member\'s. WellWish calls it if we can\'t reach you.';

  @override
  String get sendCode => 'Send code';

  @override
  String codeSentTo(String target) {
    return 'Enter the 6-digit code sent to $target';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHelp => 'We email a 6-digit code to check it.';

  @override
  String get invalidEmail => 'Enter a valid email.';

  @override
  String get yourPhoto => 'Your photo';

  @override
  String get photoHelp => 'A clear photo of your face. Patients see it.';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get choosePdf => 'Choose a PDF';

  @override
  String get homeAddress => 'Home address';

  @override
  String get homeAddressHint => 'House, street, area, PIN code';

  @override
  String get homeLocation => 'Home location';

  @override
  String get homeLocationHelp => 'Stand at home and tap the button. It helps WellWish give you jobs nearby.';

  @override
  String get useCurrentLocation => 'Use my current location';

  @override
  String get locationSaved => 'Location added';

  @override
  String get locationDenied => 'Location not shared. Allow location for WellWish in your phone\'s settings.';

  @override
  String get languagesYouSpeak => 'Languages you speak';

  @override
  String get skillsLabel => 'Skills';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get emergencyName => 'Their name';

  @override
  String get emergencyPhone => 'Their phone number';

  @override
  String get photoRequired => 'Add your photo.';

  @override
  String get addressRequired => 'Enter your home address.';

  @override
  String get locationRequired => 'Add your home location.';

  @override
  String get languagesRequired => 'Pick at least one language.';

  @override
  String get fixMarkedFields => 'Some details are missing. Check the fields marked in red.';

  @override
  String get emergencyRequired => 'Enter an emergency contact.';

  @override
  String get languageBengali => 'Bengali';

  @override
  String get languageTelugu => 'Telugu';

  @override
  String get skillElderlyCare => 'Elderly care';

  @override
  String get skillWheelchair => 'Wheelchair help';

  @override
  String get skillPaperwork => 'Hospital paperwork';

  @override
  String get skillTwoWheeler => 'Two-wheeler';

  @override
  String get skillCar => 'Car driving';

  @override
  String get skillInjections => 'Injections';

  @override
  String get skillDressing => 'Wound dressing';

  @override
  String get skillIvDrip => 'IV drip';

  @override
  String get skillPostSurgery => 'Post-surgery care';

  @override
  String get documentsSubtitle => 'Photos must be clear and readable. A PDF is fine too.';

  @override
  String get docRequired => 'Required';

  @override
  String get docOptional => 'Optional';

  @override
  String get docMissing => 'Not uploaded';

  @override
  String get docPending => 'Being checked';

  @override
  String get docApproved => 'Approved';

  @override
  String get docRejected => 'Change needed';

  @override
  String get docExpired => 'Expired';

  @override
  String get upload => 'Upload';

  @override
  String get uploadAgain => 'Upload again';

  @override
  String get uploadNew => 'Upload new';

  @override
  String get uploading => 'Uploading…';

  @override
  String get documentNumber => 'Number on the document';

  @override
  String get aadhaarNumberHelp => '12 digits. Only the last 4 are saved.';

  @override
  String get panNumberHelp => '10 characters, e.g. ABCDE1234F. Only the last 4 are saved.';

  @override
  String get validTill => 'Valid till';

  @override
  String validTillDate(String date) {
    return 'Valid till $date';
  }

  @override
  String get numberRequired => 'Enter the number.';

  @override
  String get expiryRequired => 'Pick the valid-till date.';

  @override
  String get renewalPending => 'New one is being checked';

  @override
  String renewalRejected(String reason) {
    return 'New one not accepted: $reason';
  }

  @override
  String get cameraOnlyHelp => 'Take it now with the front camera.';

  @override
  String get statusTitle => 'Application status';

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get statusUnderReview => 'Under review';

  @override
  String get statusChangesNeeded => 'Changes needed';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusSubmittedBody => 'We received your application and will check your documents soon.';

  @override
  String get statusUnderReviewBody => 'A WellWish team member is checking your documents now.';

  @override
  String get statusChangesBody =>
      'Some documents need a change. See the reasons below, upload them again and send again.';

  @override
  String get fixDocuments => 'Fix documents';

  @override
  String get noteFromWellWish => 'Note from WellWish';

  @override
  String get statusRejectedTitle => 'Application not approved';

  @override
  String get statusSuspendedTitle => 'Account paused';

  @override
  String get statusSuspendedBody => 'You can\'t get jobs right now. Call WellWish support to know more.';

  @override
  String get suspendedExpiredBody =>
      'A document has expired. Upload a new one; you can work again once it\'s approved.';

  @override
  String get statusDeactivatedTitle => 'Account closed';

  @override
  String get callSupport => 'Call WellWish support';

  @override
  String get refresh => 'Refresh';

  @override
  String get navJobs => 'Jobs';

  @override
  String get youAreApproved => 'You\'re an approved WellWish partner';

  @override
  String get availableToday => 'Available today';

  @override
  String get availableTodayHelp => 'Turn on when you can take jobs today.';

  @override
  String get verifyContactTitle => 'Verify your contact details';

  @override
  String get verifyContactBody => 'Verify your alternate number and email so WellWish can always reach you.';

  @override
  String get noJobsYet => 'No jobs yet';

  @override
  String get noJobsBody => 'Jobs from WellWish will appear here.';

  @override
  String get profileAndDocuments => 'Profile and documents';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No messages yet.';

  @override
  String get notificationsKept => 'Messages from the last 30 days are kept here.';

  @override
  String notificationsUnread(int count) {
    return 'Notifications, $count unread';
  }

  @override
  String get errSameAsPrimary => 'Enter a different number from your login number.';

  @override
  String get errEmailTaken => 'Another partner already uses this email.';

  @override
  String get errCodeWrong => 'That code isn\'t right. Check and try again.';

  @override
  String get errWaitBeforeResend => 'Please wait a little before asking for another code.';

  @override
  String get errEmailNotSent => 'We couldn\'t send the email. Please try again.';

  @override
  String get errTooYoung => 'Partners must be 18 or older.';

  @override
  String get errEmergencyIsYou => 'The emergency contact must be someone else.';

  @override
  String get errInvalidAadhaar => 'Enter the 12-digit Aadhaar number.';

  @override
  String get errInvalidPan => 'Enter the 10-character PAN.';

  @override
  String get errAlreadyExpired => 'This document has already expired.';

  @override
  String get errInvalidFile => 'This file can\'t be used. Choose a clear photo or a PDF.';

  @override
  String get errFileTooLarge => 'The file is too large (max 10 MB).';

  @override
  String get errDocumentsMissing => 'Upload every required document first.';

  @override
  String get errDetailsMissing => 'Finish your phones, email and profile first.';

  @override
  String get errNotEditable => 'This can\'t be changed while your application is being checked.';

  @override
  String get locationOff => 'Location is off. Turn on location on your phone, then try again.';

  @override
  String get familyTitle => 'Family';

  @override
  String get familyIntroTitle => 'Stay connected with your loved ones';

  @override
  String get familyIntroBody => 'Add parents and relatives to book care for them, even in another city.';

  @override
  String get addMember => 'Add member';

  @override
  String ageYears(int age) {
    return '$age yrs';
  }

  @override
  String get noFamilyYet => 'No family members yet';

  @override
  String get relationSelf => 'You';

  @override
  String get relationMother => 'Mother';

  @override
  String get relationFather => 'Father';

  @override
  String get relationGrandmother => 'Grandmother';

  @override
  String get relationGrandfather => 'Grandfather';

  @override
  String get relationSpouse => 'Spouse';

  @override
  String get relationChild => 'Child';

  @override
  String get relationSibling => 'Brother / Sister';

  @override
  String get relationOther => 'Other';

  @override
  String get addMemberTitle => 'Add family member';

  @override
  String get editDetailsTitle => 'Edit details';

  @override
  String get relation => 'Relation';

  @override
  String get relationRequired => 'Choose how they are related to you.';

  @override
  String get theirPhone => 'Their mobile number (optional)';

  @override
  String get theirPhoneHelp => 'They get SMS with the companion\'s name and the visit OTP.';

  @override
  String get languageTheySpeak => 'Language they speak';

  @override
  String get healthNotes => 'Health notes';

  @override
  String get healthNotesHelp => 'Only the companion or nurse on the job sees these.';

  @override
  String get conditions => 'Conditions';

  @override
  String get conditionsHint => 'e.g. diabetes, BP';

  @override
  String get allergies => 'Allergies';

  @override
  String get mobility => 'Getting around';

  @override
  String get mobilityWalksAlone => 'Walks alone';

  @override
  String get mobilityNeedsSupport => 'Needs support';

  @override
  String get mobilityWheelchair => 'Wheelchair';

  @override
  String get sensoryNotes => 'Hearing or vision';

  @override
  String get sensoryHint => 'e.g. hard of hearing';

  @override
  String get emergencyContactHelp => 'Leave empty to use your own number.';

  @override
  String get emergencyIncomplete => 'Give both the name and the phone, or leave both empty.';

  @override
  String get consentMember =>
      'I have their permission to save these details and share them with WellWish partners for their care.';

  @override
  String get consentRequired => 'Please tick to confirm their permission.';

  @override
  String get notGiven => 'Not given';

  @override
  String get detailsTitle => 'Details';

  @override
  String get mobileLabel => 'Mobile';

  @override
  String get addressesTitle => 'Addresses';

  @override
  String get addAddress => 'Add address';

  @override
  String get noAddresses => 'No address saved yet.';

  @override
  String get noDocumentsYet => 'No documents yet.';

  @override
  String get seeAll => 'See all';

  @override
  String get bookingsTitle => 'Bookings';

  @override
  String get noBookingsYet => 'No bookings yet.';

  @override
  String bookForName(String name) {
    return 'Book for $name';
  }

  @override
  String get edit => 'Edit';

  @override
  String get remove => 'Remove';

  @override
  String get removeMember => 'Remove from family';

  @override
  String removeMemberTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get removeMemberBody => 'They are hidden from the app. Past bookings keep their history.';

  @override
  String get outsideServiceArea => 'WellWish doesn\'t serve this area yet.';

  @override
  String get addAddressTitle => 'Add address';

  @override
  String get editAddressTitle => 'Edit address';

  @override
  String addressForName(String name) {
    return 'For $name';
  }

  @override
  String get mapHelp => 'Move the map so the pin sits on the house.';

  @override
  String get addressLabel => 'Name this address';

  @override
  String get addressLabelHint => 'e.g. Home';

  @override
  String get labelHome => 'Home';

  @override
  String get labelWork => 'Work';

  @override
  String get addressLine => 'Full address';

  @override
  String get landmark => 'Landmark (optional)';

  @override
  String get addressNotes => 'Notes for the companion (optional)';

  @override
  String get addressNotesHint => 'Gate, floor, lift';

  @override
  String get labelRequired => 'Give the address a name.';

  @override
  String get addressLineRequired => 'Enter the full address.';

  @override
  String get savedOutsideArea => 'Saved. WellWish doesn\'t serve this area yet, so it can\'t be booked.';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get tabAll => 'All';

  @override
  String get tabReports => 'Reports';

  @override
  String get tabPrescriptions => 'Prescriptions';

  @override
  String get everyone => 'Everyone';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get docTypePrescription => 'Prescription';

  @override
  String get docTypeLabReport => 'Lab report';

  @override
  String get docTypeScan => 'X-ray / scan';

  @override
  String get docTypeDischarge => 'Discharge summary';

  @override
  String get docTypeId => 'ID';

  @override
  String get docTypeOther => 'Other';

  @override
  String get forWhom => 'For whom';

  @override
  String get documentType => 'Type';

  @override
  String get documentTitle => 'Name';

  @override
  String get documentTitleHint => 'e.g. Blood test';

  @override
  String get documentDate => 'Date on the document (optional)';

  @override
  String get chooseFile => 'The file';

  @override
  String get fileChosen => 'File ready';

  @override
  String get fileRequired => 'Choose a photo or a PDF.';

  @override
  String get titleRequired => 'Give the document a name.';

  @override
  String get view => 'View';

  @override
  String get delete => 'Delete';

  @override
  String get deleteDocumentTitle => 'Delete this document?';

  @override
  String get deleteDocumentBody => 'The file is deleted for good.';

  @override
  String storageUsed(String used, String total) {
    return '$used of $total used';
  }

  @override
  String get noDocumentsBody => 'Upload prescriptions and reports once and use them in every booking.';

  @override
  String get loadMore => 'Load more';

  @override
  String get openInPhone => 'Opens in your phone\'s PDF app.';

  @override
  String get cannotOpen => 'This file can\'t be opened here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get notificationsHelp => 'Turn WellWish notifications on or off in your phone\'s settings.';

  @override
  String get openPhoneSettings => 'Open phone settings';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountHelp => 'Removes your profile, family, addresses and documents.';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String deleteAccountBody(int days) {
    return 'You will be logged out now. Your profile, family members, addresses and documents are deleted after $days days. Log in again before then to keep your account. Payment records are kept, as the law requires.';
  }

  @override
  String get deleteAccountConfirm => 'Delete account';

  @override
  String get accountDeletionRequested => 'Your account will be deleted soon. Log in again to keep it.';

  @override
  String get errTooManyMembers => 'You\'ve reached the most family members you can add.';

  @override
  String get errTooManyAddresses => 'Up to 10 addresses per person. Remove an old one first.';

  @override
  String get errStorageFull => 'Your documents are using all 200 MB. Delete some old ones first.';

  @override
  String get errDateInFuture => 'The date can\'t be in the future.';

  @override
  String get errNotFound => 'This was removed or isn\'t yours.';

  @override
  String get memberNameHint => 'Their full name';

  @override
  String get spokenOdia => 'Odia';

  @override
  String get spokenHindi => 'Hindi';

  @override
  String get spokenEnglish => 'English';

  @override
  String get spokenBengali => 'Bengali';

  @override
  String get spokenTelugu => 'Telugu';

  @override
  String get alsoDeleteDocuments => 'Also delete their medical documents';

  @override
  String get pinRequired => 'Move the map so the pin sits on the house, or use your current location.';

  @override
  String get notificationsLater =>
      'Phone notifications arrive in a coming update. Until then, check the app for updates.';

  @override
  String get photoTooLarge => 'This photo is too large (max 5 MB).';

  @override
  String accountDeletionOn(String date) {
    return 'Your account will be deleted on $date. Log in again before then to keep it.';
  }

  @override
  String get tabDoctors => 'Doctors';

  @override
  String get tabHospitals => 'Hospitals';

  @override
  String get searchDoctorsHint => 'Search doctor or speciality…';

  @override
  String get searchHospitalsHint => 'Search hospital, area or doctor…';

  @override
  String get allSpecialities => 'All';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String get noHospitalsFound => 'No hospitals found';

  @override
  String get tryAnotherSearch => 'Try another search or speciality.';

  @override
  String kmAway(String km) {
    return '$km km away';
  }

  @override
  String hospitalsWithin(int km) {
    return 'Hospitals within $km km';
  }

  @override
  String get hospitalsAll => 'All hospitals';

  @override
  String get hospitalsNoLocation => 'Allow location to see the closest hospitals first.';

  @override
  String get showMap => 'Map';

  @override
  String get showList => 'List';

  @override
  String get hospitalTypeHospital => 'Hospital';

  @override
  String get hospitalTypeClinic => 'Clinic';

  @override
  String get hospitalTypeDiagnostic => 'Diagnostic centre';

  @override
  String get opdHours => 'OPD hours';

  @override
  String get departments => 'Departments';

  @override
  String get doctorsHere => 'Doctors here';

  @override
  String doctorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doctors',
      one: '1 doctor',
      zero: 'No doctors listed',
    );
    return '$_temp0';
  }

  @override
  String get callLabel => 'Call';

  @override
  String get bookCompanionHere => 'Book a companion to this hospital';

  @override
  String get bookCompanionForDoctor => 'Book a companion for this doctor';

  @override
  String get qualifications => 'Qualifications';

  @override
  String get opdDays => 'OPD days and times';

  @override
  String get doctorSpeaks => 'Speaks';

  @override
  String get doctorHospitals => 'Sees patients at';

  @override
  String get chooseService => 'Choose the service you need';

  @override
  String totalPrice(String amount) {
    return 'Total $amount';
  }

  @override
  String get prescriptionNeeded => 'Prescription needed';

  @override
  String durationMinutes(int minutes) {
    return 'About $minutes min';
  }

  @override
  String durationHours(int hours) {
    return 'About $hours h';
  }

  @override
  String bookingAt(String place) {
    return 'For $place';
  }

  @override
  String get noServices => 'No services are available right now.';

  @override
  String get chooseBookingType => 'What would you like to book?';

  @override
  String get visitDetailsTitle => 'Visit details';

  @override
  String get hospitalLabel => 'Hospital';

  @override
  String get hospitalOptionalLabel => 'Hospital or pharmacy (optional)';

  @override
  String get chooseHospital => 'Choose the hospital';

  @override
  String get hospitalNotListed => 'My hospital isn\'t listed';

  @override
  String get hospitalTextLabel => 'Hospital name and area';

  @override
  String get hospitalTextHint => 'e.g. City Care Hospital, Patia';

  @override
  String get doctorLabel => 'Doctor';

  @override
  String get doctorNotSure => 'Not sure';

  @override
  String get dateLabel => 'Date';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get pickADate => 'Pick a date';

  @override
  String get appointmentTimeLabel => 'Doctor appointment time';

  @override
  String get appointmentTimeHint => 'Tap to set (optional)';

  @override
  String get pickupTimeLabel => 'Pickup time';

  @override
  String get visitTimeLabel => 'Visit time';

  @override
  String get startTimeLabel => 'Start time';

  @override
  String pickupSuggested(int minutes) {
    return 'Pickup suggested $minutes min before the appointment. You can change it.';
  }

  @override
  String get noTimesLeft => 'No times left on this date. Please pick another date.';

  @override
  String get timesInIst => 'Times are India time (IST).';

  @override
  String get notesLabel => 'Notes (optional)';

  @override
  String get notesHint => 'Wheelchair, language, gate number…';

  @override
  String get nextLabel => 'Next';

  @override
  String get chooseMemberRequired => 'Choose who the booking is for.';

  @override
  String get hospitalRequired => 'Choose the hospital or type it in.';

  @override
  String get timeRequired => 'Choose a time.';

  @override
  String get appointmentAfterPickup => 'The appointment must be after the pickup time.';

  @override
  String get addressStepTitle => 'Address';

  @override
  String get pickupAddressHelp => 'Where the companion picks them up.';

  @override
  String get homeVisitAddressHelp => 'Where the visit takes place.';

  @override
  String get errandAddressHelp => 'Where the companion brings things back to.';

  @override
  String addressesOfName(String name) {
    return '$name\'s addresses';
  }

  @override
  String get otherAddresses => 'Other saved addresses';

  @override
  String get addressRequiredToBook => 'Choose an address.';

  @override
  String get attachDocumentsTitle => 'Attach documents';

  @override
  String get attachDocumentsHelp =>
      'Tick the reports or prescriptions to take along. Only the assigned partner sees them.';

  @override
  String get prescriptionRequiredHelp => 'This service needs a prescription.';

  @override
  String get attachPrescription => 'Please attach a prescription.';

  @override
  String noDocumentsForName(String name) {
    return '$name has no documents yet.';
  }

  @override
  String get reviewTitle => 'Review and pay';

  @override
  String get serviceLabel => 'Service';

  @override
  String get whenLabel => 'When';

  @override
  String get whereLabel => 'Where';

  @override
  String get documentsLabel => 'Documents';

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
      zero: 'None',
    );
    return '$_temp0';
  }

  @override
  String get priceTotal => 'Total';

  @override
  String get payNowFee => 'Pay now (booking fee)';

  @override
  String get payCompanionAfter => 'Pay your companion after the visit';

  @override
  String get payNurseAfter => 'Pay your nurse after the visit';

  @override
  String get extrasNote => 'Cab or auto fares and any extra time are settled directly with your partner.';

  @override
  String get paidInFullNote => 'Paid in full in the app: nothing to pay your companion or nurse after the visit.';

  @override
  String cancellationRule(int percent) {
    return 'Cancel before your partner is on the way and get $percent% of the booking fee back.';
  }

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get errTimeNotAvailable => 'This time is no longer available. Please pick another time.';

  @override
  String get errPrescriptionRequired => 'This service needs a prescription. Please attach one.';

  @override
  String get errOutsideServiceArea => 'We don\'t serve this address yet. Please choose another address.';

  @override
  String get errTooManyUnpaid => 'You have several bookings waiting for payment. Please try again later.';

  @override
  String get errTooManyRequests => 'Too many changes in a minute. Please wait a moment and try again.';

  @override
  String get errInvalidBooking => 'Please check the booking details.';

  @override
  String get errMemberHasBookings => 'This person has a booking that isn\'t finished. Cancel it first.';

  @override
  String get errActiveBookings => 'You have a booking that isn\'t finished. Cancel it or wait until it\'s done.';

  @override
  String get bookingSavedTitle => 'Booking saved';

  @override
  String bookingSavedBody(String code) {
    return 'Online payment isn\'t available right now. Your booking $code is saved and waits for payment.';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String bookingCode(String code) {
    return 'Booking $code';
  }

  @override
  String get nextBooking => 'Next booking';

  @override
  String get statusPendingPayment => 'Waiting for payment';

  @override
  String get statusAssigning => 'Booked. We\'re assigning your partner.';

  @override
  String get statusAssigned => 'Partner assigned';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusNoShow => 'Patient not available';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusExpired => 'Not paid in time';

  @override
  String payBy(String time) {
    return 'Pay by $time';
  }

  @override
  String appointmentAt(String time) {
    return 'Appointment $time';
  }

  @override
  String pickupAt(String time) {
    return 'Pickup $time';
  }

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get eventCreate => 'Booking made';

  @override
  String get documentRemoved => 'Document removed';

  @override
  String get notesTitle => 'Notes';

  @override
  String get yourAddresses => 'Your addresses';

  @override
  String get youHaveNoDocuments => 'You have no documents yet.';

  @override
  String get appointmentTooEarly =>
      'No pickup time fits before this appointment. Pick a later appointment or another date.';

  @override
  String get pickupTooEarly => 'The pickup is too early for this appointment. Pick a later pickup time.';

  @override
  String get errBookingChanged => 'This booking was changed. Please check it and tap Pay again.';

  @override
  String get paymentProcessingTitle => 'Confirming your payment…';

  @override
  String get paymentProcessingBody => 'This takes a few seconds. You can leave this screen: we\'ll send you a message.';

  @override
  String get paymentTakingLong =>
      'We\'re still confirming your payment. We\'ll send you a message as soon as it\'s done.';

  @override
  String get paymentConfirmedTitle => 'Booking confirmed';

  @override
  String get paymentConfirmedBody =>
      'We\'re assigning your partner. Their name, photo and phone appear here once they accept.';

  @override
  String get paymentFailedTitle => 'Payment didn\'t go through';

  @override
  String paymentFailedBody(String time) {
    return 'If money was taken, it is confirmed or returned automatically. You can try again until $time.';
  }

  @override
  String get paymentCancelledTitle => 'Payment cancelled';

  @override
  String get viewBooking => 'View booking';

  @override
  String paidAmount(String amount) {
    return 'Paid $amount';
  }

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabOngoing => 'Ongoing';

  @override
  String get tabPast => 'Past';

  @override
  String get noUpcomingBookings => 'No upcoming bookings.';

  @override
  String get noOngoingBookings => 'Nothing in progress right now.';

  @override
  String get noPastBookings => 'No past bookings yet.';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelTitle => 'Cancel this booking?';

  @override
  String cancelRefund(String amount, int percent) {
    return 'You\'ll get back $amount ($percent% of the booking fee) to your payment method in 5 to 7 working days.';
  }

  @override
  String get cancelNoRefund => 'No refund applies to this booking.';

  @override
  String get cancelReasonLabel => 'Why are you cancelling?';

  @override
  String get cancelReasonPlans => 'Plans changed';

  @override
  String get cancelReasonMistake => 'Booked by mistake';

  @override
  String get cancelReasonOther => 'Another reason';

  @override
  String get cancelReasonHint => 'Tell us more (optional)';

  @override
  String get confirmCancel => 'Yes, cancel';

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get cancelNotAllowed => 'Your partner is already on the way. Please call WellWish support to cancel.';

  @override
  String get bookingCancelledSnack => 'Booking cancelled.';

  @override
  String get refundsTitle => 'Refunds';

  @override
  String get refundAwaiting => 'Being approved';

  @override
  String get refundPending => 'On its way';

  @override
  String get refundProcessed => 'Refunded';

  @override
  String get refundFailed => 'Failed: support will call you';

  @override
  String get refundRejected => 'Not approved';

  @override
  String get changeTime => 'Change date or time';

  @override
  String reschedulesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes left',
      one: '1 change left',
      zero: 'No changes left',
    );
    return '$_temp0';
  }

  @override
  String get rescheduleTooLate => 'It\'s too close to the pickup to change the time. Please call WellWish support.';

  @override
  String get rescheduleLimit => 'The time can\'t be changed again. Please call WellWish support.';

  @override
  String get confirmNewTime => 'Confirm new time';

  @override
  String get timeChangedSnack => 'Time changed.';

  @override
  String get partnerWillReconfirm => 'Your partner will confirm the new time.';

  @override
  String currentTime(String time) {
    return 'Now: $time';
  }

  @override
  String get errNotPayable => 'This booking can\'t be paid any more. Please book again.';

  @override
  String get errPaymentsNotSetUp => 'Online payment isn\'t available right now. Please try again later.';

  @override
  String get errInvalidSignature =>
      'We couldn\'t confirm this payment. If money was taken, it will be confirmed or refunded.';

  @override
  String get errGateway => 'The payment service didn\'t answer. Please try again.';

  @override
  String get rescheduleNotAllowed => 'The time can\'t be changed in the app any more. Please call WellWish support.';

  @override
  String get eventPaid => 'Booking fee paid';

  @override
  String get eventRescheduled => 'Date or time changed';

  @override
  String get bookingFeeOnline => 'Booking fee (online)';

  @override
  String get paymentNotBookedTitle => 'Booking not made';

  @override
  String get paymentNotBookedBody =>
      'The payment time ran out, or the time was taken while you paid. Your money is returned in full in 5 to 7 working days. Please book again.';

  @override
  String get offersTitle => 'New offers';

  @override
  String offerTimeLeft(String time) {
    return '$time left to answer';
  }

  @override
  String get offerWaiting => 'Please answer: WellWish is waiting';

  @override
  String get offerReconfirm => 'Time changed: please confirm';

  @override
  String get todayJobsTitle => 'Today\'s jobs';

  @override
  String get noJobsToday => 'No jobs today.';

  @override
  String get totalsDoneToday => 'Done today';

  @override
  String get totalsThisWeek => 'This week';

  @override
  String get totalsUpcoming => 'Upcoming';

  @override
  String get selfieTitle => 'Today\'s selfie';

  @override
  String get selfieBody =>
      'Take a quick selfie before you go available. WellWish checks it against your profile photo.';

  @override
  String get takeSelfie => 'Take selfie';

  @override
  String get selfieSaved => 'Selfie saved. You\'re available today.';

  @override
  String get selfieNeeded => 'Take today\'s selfie first.';

  @override
  String get offerTitle => 'Booking offer';

  @override
  String get offerArea => 'Area';

  @override
  String offerDistance(String km) {
    return '$km km from your home';
  }

  @override
  String get offerPatient => 'Patient';

  @override
  String get offerNeeds => 'Needs';

  @override
  String offerDocuments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents attached',
      one: '1 document attached',
      zero: 'No documents',
    );
    return '$_temp0';
  }

  @override
  String get offerPrescription => 'Prescription attached';

  @override
  String offerBalance(String amount) {
    return 'You collect $amount after the job';
  }

  @override
  String get offerDetailsLater => 'The full address, phone numbers, health notes and documents open after you accept.';

  @override
  String get acceptOffer => 'Accept';

  @override
  String get acceptNewTime => 'Confirm new time';

  @override
  String get declineOffer => 'Decline';

  @override
  String get declineTitle => 'Why can\'t you take it?';

  @override
  String get declineNotAvailable => 'Not available';

  @override
  String get declineTooFar => 'Too far';

  @override
  String get declineOther => 'Other reason';

  @override
  String get declineNoteHint => 'Add a note (optional)';

  @override
  String get offerDeclined => 'Declined. WellWish will find someone else.';

  @override
  String get errOfferNotOpen => 'This booking is no longer yours.';

  @override
  String get errPartnerBusy => 'You have another job at that time.';

  @override
  String get jobsNew => 'New';

  @override
  String get jobsUpcoming => 'Upcoming';

  @override
  String get jobsCompleted => 'Completed';

  @override
  String get noOffers => 'No new offers.';

  @override
  String get noUpcomingJobs => 'No upcoming jobs.';

  @override
  String get noCompletedJobs => 'No completed jobs yet.';

  @override
  String jobTitle(String code) {
    return 'Job $code';
  }

  @override
  String get jobAddress => 'Address';

  @override
  String get navigate => 'Navigate';

  @override
  String get navigateHospital => 'Navigate to the hospital';

  @override
  String get callPatient => 'Call the patient';

  @override
  String callBooker(String name) {
    return 'Call $name (who booked)';
  }

  @override
  String collectBalance(String amount) {
    return 'Collect $amount after the job';
  }

  @override
  String get jobAccepted => 'Accepted';

  @override
  String get reconfirmPending => 'The time changed. Confirm the new time under New offers.';

  @override
  String get openDocument => 'Open';

  @override
  String get yourPartner => 'Your partner';

  @override
  String callName(String name) {
    return 'Call $name';
  }

  @override
  String ratingCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count reviews', one: '1 review');
    return '$rating ($_temp0)';
  }

  @override
  String get newPartner => 'New partner';

  @override
  String get offerAccepted => 'This job is yours.';

  @override
  String get openJob => 'Open the job';

  @override
  String get stepOnTheWay => 'On the way';

  @override
  String get stepReachedPatient => 'Reached the patient';

  @override
  String get stepPickedUp => 'Picked up';

  @override
  String get stepReachedHospital => 'At the hospital';

  @override
  String get stepVisitDone => 'Visit done';

  @override
  String get stepDroppedHome => 'Dropped home';

  @override
  String get stepReachedHome => 'Reached home';

  @override
  String get stepStarted => 'Care started';

  @override
  String get stepCareDone => 'Care done';

  @override
  String get stepAtPlace => 'At the hospital / pharmacy';

  @override
  String get stepTaskDone => 'Task done';

  @override
  String get stepDelivered => 'Delivered';

  @override
  String get stepCompleted => 'Completed';

  @override
  String get activeJobTitle => 'Your job now';

  @override
  String nextStepIs(String step) {
    return 'Next: $step';
  }

  @override
  String get tapWhenDone => 'Tap when this is done';

  @override
  String get sharingLocation => 'Sharing your location with the patient';

  @override
  String get locationOffHelp => 'Can\'t read your location. Allow location for WellWish Partner and turn on Location.';

  @override
  String get fgsTitle => 'WellWish visit';

  @override
  String get fgsText => 'Sharing your location with the patient for this visit';

  @override
  String get enterOtpTitle => 'Ask for the visit code';

  @override
  String get enterOtpBody => 'The family has a 4-digit code in the WellWish app or SMS.';

  @override
  String jobOtpWrong(int tries) {
    return 'Wrong code. $tries tries left.';
  }

  @override
  String otpWaitUntil(String time) {
    return 'Too many wrong codes. Try again at $time, or call WellWish: they can confirm with the family.';
  }

  @override
  String get jobOtpLastTry => 'Wrong code. One more wrong code and you\'ll have to wait 5 minutes.';

  @override
  String get noNetworkOtp => 'No network. Call WellWish to confirm the code.';

  @override
  String get stepQueued => 'Saved on your phone. It\'ll be sent when you\'re back online.';

  @override
  String pendingSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count steps', one: '1 step');
    return 'Waiting for network: $_temp0 to send';
  }

  @override
  String get stepsRefused =>
      'A step saved on your phone wasn\'t accepted (WellWish may have marked it already). Check the steps below, or call WellWish.';

  @override
  String tooEarlyToStart(String time) {
    return 'Too early to start. You can tap \"On the way\" from $time.';
  }

  @override
  String get shareAgain => 'Try sharing again';

  @override
  String get callWellWish => 'Call WellWish';

  @override
  String waitTimer(String time) {
    return 'Waiting for the patient: $time left';
  }

  @override
  String get patientNotAvailable => 'Patient not available';

  @override
  String get noShowConfirm => 'Mark the patient as not available? WellWish will review it.';

  @override
  String get callFirst => 'Try calling the patient first.';

  @override
  String get noShowDone => 'Marked: patient not available. WellWish will review it.';

  @override
  String get jobFinished => 'Job completed. Thank you!';

  @override
  String get sos => 'SOS';

  @override
  String get sosTitle => 'Emergency';

  @override
  String get sosBody =>
      'WellWish and the emergency contacts get an alert with your location. For police call 112, for an ambulance 108.';

  @override
  String get sendSos => 'Send SOS to WellWish';

  @override
  String get sosSent => 'WellWish has been alerted.';

  @override
  String get call112 => 'Call 112 (police)';

  @override
  String get call108 => 'Call 108 (ambulance)';

  @override
  String get careNoteTitle => 'Care note';

  @override
  String get careNoteHint => 'What you did and how the patient is';

  @override
  String get careNoteRequired => 'Please write a short care note.';

  @override
  String get vitalsTitle => 'Vitals (optional)';

  @override
  String get bpLabel => 'BP (e.g. 120/80)';

  @override
  String get pulseLabel => 'Pulse';

  @override
  String get temperatureLabel => 'Temperature (°F)';

  @override
  String get spo2Label => 'SpO₂ (%)';

  @override
  String get sugarLabel => 'Sugar (mg/dL)';

  @override
  String get saveCareNote => 'Save and mark Care done';

  @override
  String get invalidValue => 'Check this value';

  @override
  String get collectTitle => 'Collect balance';

  @override
  String get collectBody => 'Record what you collected. WellWish doesn\'t handle this money.';

  @override
  String get amountRupees => 'Amount (₹)';

  @override
  String get payCash => 'Cash';

  @override
  String get payUpi => 'UPI';

  @override
  String get balanceNoteHint => 'Note (optional)';

  @override
  String get recordBalance => 'Record balance';

  @override
  String balanceRecorded(String amount, String mode) {
    return 'Collected $amount ($mode)';
  }

  @override
  String get balanceNotDue => 'Nothing to collect: the family paid the full price in the app.';

  @override
  String balanceTooHigh(String amount) {
    return 'That\'s more than the balance to collect ($amount).';
  }

  @override
  String get totalsTitle => 'Totals';

  @override
  String get jobsDoneTitle => 'Jobs done';

  @override
  String get totalsThisMonth => 'This month';

  @override
  String get totalsAllTime => 'All time';

  @override
  String get balanceCollectedTitle => 'Balance collected';

  @override
  String cashUpi(String cash, String upi) {
    return 'Cash $cash · UPI $upi';
  }

  @override
  String get offersTitleTotals => 'Offers';

  @override
  String offersLine(int received, int accepted, int declined, int late) {
    return '$received received · $accepted accepted · $declined declined · $late not answered in 2 min';
  }

  @override
  String get ratingTitle => 'Rating';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get seeTotals => 'See totals';

  @override
  String get visitCodeTitle => 'Visit code';

  @override
  String visitCodeHelp(String name) {
    return 'Give this code to $name when they arrive. Don\'t share it on the phone.';
  }

  @override
  String get trackLive => 'Track live';

  @override
  String get liveEnded => 'The visit is over. Live location has stopped.';

  @override
  String get backToBooking => 'Back to the booking';

  @override
  String nowStep(String step) {
    return 'Now: $step';
  }

  @override
  String get chooseStars => 'Choose 1 to 5 stars';

  @override
  String starsSemantics(int count) {
    return '$count stars';
  }

  @override
  String get reportTooShort => 'Please write a few words';

  @override
  String get sendReport => 'Send';

  @override
  String get errAlreadyReviewed => 'You\'ve already rated this visit.';

  @override
  String get errNotReviewable => 'This visit can\'t be rated.';

  @override
  String get errReportTooLate => 'Problems can be reported up to 24 hours after the visit. Please call WellWish.';

  @override
  String get errNotInProgress => 'The visit isn\'t in progress. For an emergency call 112.';

  @override
  String get liveTitle => 'Live visit';

  @override
  String etaMinutes(int minutes) {
    return 'About $minutes min away';
  }

  @override
  String etaHours(int hours, int minutes) {
    return 'About $hours h $minutes min away';
  }

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String waitingForLocation(String name) {
    return 'Waiting for $name\'s location…';
  }

  @override
  String get shareTrip => 'Share trip';

  @override
  String get linkCopied => 'Link copied. Send it on WhatsApp or SMS.';

  @override
  String get visitCompleted => 'Visit completed';

  @override
  String payPartner(String amount, String name) {
    return 'Pay $amount to $name';
  }

  @override
  String get payPartnerHelp =>
      'Pay the balance directly to your companion or nurse (cash or UPI). Cab fares and extra time are settled with them.';

  @override
  String get rateVisit => 'Rate the visit';

  @override
  String get reviewCommentHint => 'Anything to add? (optional)';

  @override
  String get sendRating => 'Send rating';

  @override
  String get ratingThanks => 'Thanks for rating!';

  @override
  String get yourRating => 'Your rating';

  @override
  String get tagOnTime => 'On time';

  @override
  String get tagKind => 'Kind';

  @override
  String get tagHelpful => 'Helpful';

  @override
  String get tagProfessional => 'Professional';

  @override
  String get tagGoodCommunication => 'Explained well';

  @override
  String get tagLate => 'Late';

  @override
  String get tagRude => 'Rude';

  @override
  String get tagUnhelpful => 'Not helpful';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get reportHint => 'What went wrong?';

  @override
  String get reportSent => 'Sent. WellWish will get back to you.';

  @override
  String get reportedProblems => 'Problems you reported';

  @override
  String get wellwishReplied => 'WellWish replied';

  @override
  String get ticketClosed => 'Closed';

  @override
  String get ticketOpen => 'Open';

  @override
  String noShowShown(String name) {
    return '$name couldn\'t meet the patient. WellWish will call you.';
  }

  @override
  String get docTypeCareNote => 'Care note';

  @override
  String get vitalsLine => 'Vitals';

  @override
  String get bpShort => 'BP';

  @override
  String get careNoteBy => 'Written by the nurse at the visit';

  @override
  String get tempHomeTitle => 'Your WellWish job';

  @override
  String get tempHomeBody => 'WellWish asked you to do this one visit. Follow the steps below, one at a time.';

  @override
  String get tempSelfieBody =>
      'Take a selfie before you start. The family and WellWish see it as your photo for this visit.';

  @override
  String get tempSelfieSaved => 'Selfie saved. You can start the job now.';

  @override
  String get tempJobOver => 'Your WellWish job is over. Thank you!';

  @override
  String get rootedWarning =>
      'This phone looks rooted. Patients\' details and your account are less safe on it. Please use a phone that isn\'t rooted for WellWish jobs.';

  @override
  String get otpFieldLabel => 'The 6-digit code';

  @override
  String paidPartner(String amount, String name) {
    return 'Paid $amount to $name';
  }

  @override
  String get legalTitle => 'Terms and policies';

  @override
  String get legalTerms => 'Terms of Use';

  @override
  String get legalPrivacy => 'Privacy Policy';

  @override
  String get legalRefunds => 'Refund Policy';

  @override
  String get legalPartnerTerms => 'Partner Terms';

  @override
  String legalRead(String page) {
    return 'Read the $page';
  }

  @override
  String get consentPartnerTerms => 'I accept the Partner Terms';

  @override
  String get consentPartnerTermsDetail => 'How jobs, location sharing, conduct and your account work.';

  @override
  String get partnerDeleteAccountHelp => 'Removes your profile, phone numbers, email and documents.';

  @override
  String partnerDeleteAccountBody(int days) {
    return 'You will be logged out now. Your profile, phone numbers, email, address and documents are deleted after $days days. Log in again before then to keep your account. Your past jobs stay on record without your personal details.';
  }

  @override
  String get errorActiveJobs => 'You have an accepted or ongoing job. Ask WellWish to move it, then try again.';

  @override
  String get accountErased => 'Your account is deleted.';

  @override
  String get deleteLoginBody =>
      'Nothing else is saved for this number in the Partner app. It is deleted now and you are logged out.';

  @override
  String get consentChanged => 'WellWish just updated these pages. Please read and accept them again.';

  @override
  String get errUploadAgain => 'The upload took too long. Please try again.';
}
