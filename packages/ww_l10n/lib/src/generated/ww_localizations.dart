import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'ww_localizations_en.dart';
import 'ww_localizations_hi.dart';
import 'ww_localizations_or.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of WWLocalizations
/// returned by `WWLocalizations.of(context)`.
///
/// Applications need to include `WWLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/ww_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: WWLocalizations.localizationsDelegates,
///   supportedLocales: WWLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the WWLocalizations.supportedLocales
/// property.
abstract class WWLocalizations {
  WWLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static WWLocalizations of(BuildContext context) {
    return Localizations.of<WWLocalizations>(context, WWLocalizations)!;
  }

  static const LocalizationsDelegate<WWLocalizations> delegate = _WWLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi'), Locale('or')];

  /// Brand name. Same in every language.
  ///
  /// In en, this message translates to:
  /// **'WellWish'**
  String get appName;

  /// Label under the logo on the Partner app splash screen.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partnerBadge;

  /// Brand tagline exactly as in the official logo. Kept in Hindi in every language.
  ///
  /// In en, this message translates to:
  /// **'आपकी सेहत, हमारी ज़िम्मेदारी'**
  String get brandTagline;

  /// Generic loading message.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// Retry button on error screens.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Generic error message.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// Shown when the phone is offline or the server can't be reached.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get noInternet;

  /// Login screen title (mockup 2).
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeBack;

  /// Login screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginSubtitle;

  /// Title when the user tapped Create Account.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccountTitle;

  /// Subtitle when the user tapped Create Account.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to get started'**
  String get createAccountSubtitle;

  /// Partner app login subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in, or join as a companion or nurse, with your mobile number'**
  String get partnerLoginSubtitle;

  /// Partner app login title: for partners who log in and for new ones who join
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get partnerLoginTitle;

  /// Line under the partner login button: new partners register with the same phone login
  ///
  /// In en, this message translates to:
  /// **'New partner? Enter your number to start your application.'**
  String get partnerJoinHint;

  /// Hint inside the phone number field.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get phoneHint;

  /// Button that sends the SMS code.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// Divider between phone login and Google login.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// Label above the Google button.
  ///
  /// In en, this message translates to:
  /// **'Login with'**
  String get loginWith;

  /// Google sign-in button. Brand name, not translated.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// Before the Create Account link.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// Link to create an account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Before the Login link on the create-account screen.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// Login link.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Phone number is not a valid Indian mobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get invalidPhone;

  /// OTP screen title.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// OTP screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}'**
  String otpSentTo(String phone);

  /// Go back and edit the phone number.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// Button that checks the OTP.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Countdown before a new code can be requested.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendIn(int seconds);

  /// Button to send a new code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// Snackbar after a new code was sent.
  ///
  /// In en, this message translates to:
  /// **'A new code was sent'**
  String get codeResent;

  /// Wrong OTP entered.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. {attempts, plural, =1{1 try left.} other{{attempts} tries left.}}'**
  String otpWrong(int attempts);

  /// OTP expired or already used.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Tap Resend code.'**
  String get otpExpired;

  /// 5 wrong tries on one code.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Tap Resend code for a new one.'**
  String get otpTooManyAttempts;

  /// Phone locked after 10 wrong codes.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Please try again in an hour.'**
  String get otpLocked;

  /// Too many SMS requested.
  ///
  /// In en, this message translates to:
  /// **'Too many code requests. Please try again later.'**
  String get otpRateLimited;

  /// The SMS provider failed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send the SMS. Please try again.'**
  String get smsNotSent;

  /// Blocked account tried to log in.
  ///
  /// In en, this message translates to:
  /// **'This account is blocked. Please contact WellWish support.'**
  String get accountBlocked;

  /// Google sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in didn\'t work. Please try again.'**
  String get googleFailed;

  /// Shown on the login screen after Google sign-in when the phone is not verified yet.
  ///
  /// In en, this message translates to:
  /// **'Verify your mobile number once to finish signing in with Google.'**
  String get googleVerifyPhone;

  /// Profile setup screen title (P04).
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get profileSetupTitle;

  /// Profile setup subtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps your companion or nurse take good care of you.'**
  String get profileSetupSubtitle;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// Hint in the full name field.
  ///
  /// In en, this message translates to:
  /// **'As on your ID card'**
  String get fullNameHint;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// Placeholder when no date is picked.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Gender option.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// Gender option.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// Gender option.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language option, written in English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language option, always written in Hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// Language option, always written in Odia.
  ///
  /// In en, this message translates to:
  /// **'ଓଡ଼ିଆ'**
  String get languageOdia;

  /// Generic continue button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get nameRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get dobRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get genderRequired;

  /// Consent screen title.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get consentTitle;

  /// Consent screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please read and accept to use WellWish.'**
  String get consentSubtitle;

  /// Consent checkbox.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms of Use'**
  String get consentTerms;

  /// Under the terms checkbox.
  ///
  /// In en, this message translates to:
  /// **'How bookings, payments, cancellations and refunds work.'**
  String get consentTermsDetail;

  /// Consent checkbox.
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy'**
  String get consentPrivacy;

  /// Under the privacy checkbox.
  ///
  /// In en, this message translates to:
  /// **'Your data stays in India and is never sold.'**
  String get consentPrivacyDetail;

  /// Consent checkbox (DPDP Act).
  ///
  /// In en, this message translates to:
  /// **'I allow WellWish to keep my health documents'**
  String get consentHealthData;

  /// Under the health data checkbox.
  ///
  /// In en, this message translates to:
  /// **'They are shown only to the companion or nurse assigned to your booking, during the visit.'**
  String get consentHealthDataDetail;

  /// Consent screen button.
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get agreeAndContinue;

  /// Location permission screen title.
  ///
  /// In en, this message translates to:
  /// **'Find hospitals near you'**
  String get locationTitle;

  /// Location permission screen text.
  ///
  /// In en, this message translates to:
  /// **'Allow location so we can show hospitals and clinics close to you. We don\'t track you.'**
  String get locationBody;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get allowLocation;

  /// Skip button.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// Home greeting (mockup 3).
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloName(String name);

  /// Under the home greeting.
  ///
  /// In en, this message translates to:
  /// **'Take care. You matter!'**
  String get homeTagline;

  /// Home hero card title.
  ///
  /// In en, this message translates to:
  /// **'Your Health, Our Priority'**
  String get heroTitle;

  /// Home hero card text.
  ///
  /// In en, this message translates to:
  /// **'Get the best care with WellWish'**
  String get heroSubtitle;

  /// Home tile.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get tileDoctors;

  /// Home tile.
  ///
  /// In en, this message translates to:
  /// **'Book a Companion'**
  String get tileBookCompanion;

  /// Home tile.
  ///
  /// In en, this message translates to:
  /// **'Book a Nurse'**
  String get tileBookNurse;

  /// Home tile.
  ///
  /// In en, this message translates to:
  /// **'Medical Reports'**
  String get tileMedicalReports;

  /// Home tile.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get tileFamily;

  /// Badge and title for parts of the app not built yet.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Text for parts of the app not built yet.
  ///
  /// In en, this message translates to:
  /// **'This part of WellWish opens in an upcoming update.'**
  String get comingSoonBody;

  /// Bottom navigation.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get navDoctors;

  /// Bottom navigation.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// Bottom navigation.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get navFamily;

  /// Bottom navigation.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Profile screen title (mockup 10).
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Badge under the phone number.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'My Reports'**
  String get myReports;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Profile row and button.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Profile row.
  ///
  /// In en, this message translates to:
  /// **'Log out on all devices'**
  String get logoutEverywhere;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need an OTP to log in again.'**
  String get logoutConfirmBody;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Login screen message after the session expired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please log in again.'**
  String get sessionExpired;

  /// Partner app: another phone logged in with this number.
  ///
  /// In en, this message translates to:
  /// **'You logged in on another phone, so you were logged out here.'**
  String get loggedInElsewhere;

  /// Force update screen title.
  ///
  /// In en, this message translates to:
  /// **'Update WellWish'**
  String get updateTitle;

  /// Force update screen text.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Please update the app to continue.'**
  String get updateBody;

  /// Force update button.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// Partner app screen after login (registration placeholder).
  ///
  /// In en, this message translates to:
  /// **'Become a WellWish partner'**
  String get partnerRegisterTitle;

  /// Partner registration placeholder text.
  ///
  /// In en, this message translates to:
  /// **'Registration for companions and nurses opens in the next update. You\'ll be able to add your details and documents here.'**
  String get partnerRegisterBody;

  /// Shows which number is logged in.
  ///
  /// In en, this message translates to:
  /// **'Logged in as {phone}'**
  String loggedInAs(String phone);

  /// Partner registration: choose a role.
  ///
  /// In en, this message translates to:
  /// **'What work will you do?'**
  String get registerRoleTitle;

  /// Role screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this until you send your application.'**
  String get registerRoleSubtitle;

  /// Partner role.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get roleCompanion;

  /// Companion role description.
  ///
  /// In en, this message translates to:
  /// **'Take patients to the doctor, help at the hospital, run medicine errands and care for elders at home.'**
  String get roleCompanionBody;

  /// Partner role.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get roleNurse;

  /// Nurse role description.
  ///
  /// In en, this message translates to:
  /// **'Injections, wound dressing, IV drips and nursing shifts at home. Needs a nursing qualification and council registration.'**
  String get roleNurseBody;

  /// Registration steps screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Finish these steps, then send your application for review.'**
  String get registerHubSubtitle;

  /// Registration step.
  ///
  /// In en, this message translates to:
  /// **'Work type'**
  String get stepRole;

  /// Registration step.
  ///
  /// In en, this message translates to:
  /// **'Alternate number and email'**
  String get stepContact;

  /// Registration step.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get stepProfile;

  /// Registration step.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get stepDocuments;

  /// Step status.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepDone;

  /// Step status.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get stepTodo;

  /// Documents progress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} uploaded'**
  String documentsProgress(int done, int total);

  /// Submit the application.
  ///
  /// In en, this message translates to:
  /// **'Send for review'**
  String get submitForReview;

  /// Shown while submit is disabled.
  ///
  /// In en, this message translates to:
  /// **'Finish every step to send your application.'**
  String get submitHint;

  /// Change something already set.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// R04 title.
  ///
  /// In en, this message translates to:
  /// **'Phones and email'**
  String get contactTitle;

  /// The primary phone.
  ///
  /// In en, this message translates to:
  /// **'Login number'**
  String get loginNumber;

  /// Second phone.
  ///
  /// In en, this message translates to:
  /// **'Alternate number'**
  String get alternateNumber;

  /// Alternate phone help.
  ///
  /// In en, this message translates to:
  /// **'A second number, e.g. a family member\'s. WellWish calls it if we can\'t reach you.'**
  String get alternateHelp;

  /// Send a verification code.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// After sending a code.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {target}'**
  String codeSentTo(String target);

  /// Email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Email help.
  ///
  /// In en, this message translates to:
  /// **'We email a 6-digit code to check it.'**
  String get emailHelp;

  /// Email validation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get invalidEmail;

  /// Profile photo label.
  ///
  /// In en, this message translates to:
  /// **'Your photo'**
  String get yourPhoto;

  /// Profile photo help.
  ///
  /// In en, this message translates to:
  /// **'A clear photo of your face. Patients see it.'**
  String get photoHelp;

  /// Camera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// Gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// File picker.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF'**
  String get choosePdf;

  /// Address label.
  ///
  /// In en, this message translates to:
  /// **'Home address'**
  String get homeAddress;

  /// Address hint.
  ///
  /// In en, this message translates to:
  /// **'House, street, area, PIN code'**
  String get homeAddressHint;

  /// Location label.
  ///
  /// In en, this message translates to:
  /// **'Home location'**
  String get homeLocation;

  /// Location help.
  ///
  /// In en, this message translates to:
  /// **'Stand at home and tap the button. It helps WellWish give you jobs nearby.'**
  String get homeLocationHelp;

  /// Location button.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useCurrentLocation;

  /// Location captured.
  ///
  /// In en, this message translates to:
  /// **'Location added'**
  String get locationSaved;

  /// Location permission denied.
  ///
  /// In en, this message translates to:
  /// **'Location not shared. Allow location for WellWish in your phone\'s settings.'**
  String get locationDenied;

  /// Languages label.
  ///
  /// In en, this message translates to:
  /// **'Languages you speak'**
  String get languagesYouSpeak;

  /// Skills label.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsLabel;

  /// Emergency contact section.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get emergencyContact;

  /// Emergency contact name.
  ///
  /// In en, this message translates to:
  /// **'Their name'**
  String get emergencyName;

  /// Emergency contact phone.
  ///
  /// In en, this message translates to:
  /// **'Their phone number'**
  String get emergencyPhone;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Add your photo.'**
  String get photoRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Enter your home address.'**
  String get addressRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Add your home location.'**
  String get locationRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one language.'**
  String get languagesRequired;

  /// Shown by Save when the form has errors further up the screen.
  ///
  /// In en, this message translates to:
  /// **'Some details are missing. Check the fields marked in red.'**
  String get fixMarkedFields;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Enter an emergency contact.'**
  String get emergencyRequired;

  /// Language name.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// Language name.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get languageTelugu;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Elderly care'**
  String get skillElderlyCare;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair help'**
  String get skillWheelchair;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Hospital paperwork'**
  String get skillPaperwork;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Two-wheeler'**
  String get skillTwoWheeler;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Car driving'**
  String get skillCar;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Injections'**
  String get skillInjections;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Wound dressing'**
  String get skillDressing;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'IV drip'**
  String get skillIvDrip;

  /// Skill.
  ///
  /// In en, this message translates to:
  /// **'Post-surgery care'**
  String get skillPostSurgery;

  /// Documents screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Photos must be clear and readable. A PDF is fine too.'**
  String get documentsSubtitle;

  /// Document tag.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get docRequired;

  /// Document tag.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get docOptional;

  /// Document status.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get docMissing;

  /// Document status.
  ///
  /// In en, this message translates to:
  /// **'Being checked'**
  String get docPending;

  /// Document status.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get docApproved;

  /// Document status.
  ///
  /// In en, this message translates to:
  /// **'Change needed'**
  String get docRejected;

  /// Document status.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get docExpired;

  /// Upload button.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Re-upload button.
  ///
  /// In en, this message translates to:
  /// **'Upload again'**
  String get uploadAgain;

  /// Renewal button.
  ///
  /// In en, this message translates to:
  /// **'Upload new'**
  String get uploadNew;

  /// Upload progress.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploading;

  /// Document number field.
  ///
  /// In en, this message translates to:
  /// **'Number on the document'**
  String get documentNumber;

  /// Aadhaar help.
  ///
  /// In en, this message translates to:
  /// **'12 digits. Only the last 4 are saved.'**
  String get aadhaarNumberHelp;

  /// PAN help.
  ///
  /// In en, this message translates to:
  /// **'10 characters, e.g. ABCDE1234F. Only the last 4 are saved.'**
  String get panNumberHelp;

  /// Expiry date field.
  ///
  /// In en, this message translates to:
  /// **'Valid till'**
  String get validTill;

  /// Expiry date shown.
  ///
  /// In en, this message translates to:
  /// **'Valid till {date}'**
  String validTillDate(String date);

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Enter the number.'**
  String get numberRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Pick the valid-till date.'**
  String get expiryRequired;

  /// Renewal waiting.
  ///
  /// In en, this message translates to:
  /// **'New one is being checked'**
  String get renewalPending;

  /// Renewal rejected.
  ///
  /// In en, this message translates to:
  /// **'New one not accepted: {reason}'**
  String renewalRejected(String reason);

  /// Live selfie help.
  ///
  /// In en, this message translates to:
  /// **'Take it now with the front camera.'**
  String get cameraOnlyHelp;

  /// R07 title.
  ///
  /// In en, this message translates to:
  /// **'Application status'**
  String get statusTitle;

  /// Timeline step.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// Timeline step.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get statusUnderReview;

  /// Timeline step.
  ///
  /// In en, this message translates to:
  /// **'Changes needed'**
  String get statusChangesNeeded;

  /// Timeline step.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// Submitted text.
  ///
  /// In en, this message translates to:
  /// **'We received your application and will check your documents soon.'**
  String get statusSubmittedBody;

  /// Under review text.
  ///
  /// In en, this message translates to:
  /// **'A WellWish team member is checking your documents now.'**
  String get statusUnderReviewBody;

  /// Changes text.
  ///
  /// In en, this message translates to:
  /// **'Some documents need a change. See the reasons below, upload them again and send again.'**
  String get statusChangesBody;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Fix documents'**
  String get fixDocuments;

  /// Admin note heading.
  ///
  /// In en, this message translates to:
  /// **'Note from WellWish'**
  String get noteFromWellWish;

  /// Rejected heading.
  ///
  /// In en, this message translates to:
  /// **'Application not approved'**
  String get statusRejectedTitle;

  /// Suspended heading.
  ///
  /// In en, this message translates to:
  /// **'Account paused'**
  String get statusSuspendedTitle;

  /// Suspended text.
  ///
  /// In en, this message translates to:
  /// **'You can\'t get jobs right now. Call WellWish support to know more.'**
  String get statusSuspendedBody;

  /// Suspended for expiry.
  ///
  /// In en, this message translates to:
  /// **'A document has expired. Upload a new one; you can work again once it\'s approved.'**
  String get suspendedExpiredBody;

  /// Deactivated heading.
  ///
  /// In en, this message translates to:
  /// **'Account closed'**
  String get statusDeactivatedTitle;

  /// Support button.
  ///
  /// In en, this message translates to:
  /// **'Call WellWish support'**
  String get callSupport;

  /// Reload button.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Bottom nav.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// Approved home card.
  ///
  /// In en, this message translates to:
  /// **'You\'re an approved WellWish partner'**
  String get youAreApproved;

  /// Availability switch.
  ///
  /// In en, this message translates to:
  /// **'Available today'**
  String get availableToday;

  /// Availability help.
  ///
  /// In en, this message translates to:
  /// **'Turn on when you can take jobs today.'**
  String get availableTodayHelp;

  /// Approved, contact not verified.
  ///
  /// In en, this message translates to:
  /// **'Verify your contact details'**
  String get verifyContactTitle;

  /// Approved, contact not verified.
  ///
  /// In en, this message translates to:
  /// **'Verify your alternate number and email so WellWish can always reach you.'**
  String get verifyContactBody;

  /// Jobs empty state.
  ///
  /// In en, this message translates to:
  /// **'No jobs yet'**
  String get noJobsYet;

  /// Jobs empty state.
  ///
  /// In en, this message translates to:
  /// **'Jobs from WellWish will appear here.'**
  String get noJobsBody;

  /// R16 title.
  ///
  /// In en, this message translates to:
  /// **'Profile and documents'**
  String get profileAndDocuments;

  /// Inbox title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Inbox empty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get noNotifications;

  /// Line at the end of the family's Notifications list (P25): older messages are removed (v2.33)
  ///
  /// In en, this message translates to:
  /// **'Messages from the last 30 days are kept here.'**
  String get notificationsKept;

  /// Screen-reader label of the bell on Home with unread messages (P25)
  ///
  /// In en, this message translates to:
  /// **'Notifications, {count} unread'**
  String notificationsUnread(int count);

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Enter a different number from your login number.'**
  String get errSameAsPrimary;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Another partner already uses this email.'**
  String get errEmailTaken;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Check and try again.'**
  String get errCodeWrong;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Please wait a little before asking for another code.'**
  String get errWaitBeforeResend;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send the email. Please try again.'**
  String get errEmailNotSent;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Partners must be 18 or older.'**
  String get errTooYoung;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'The emergency contact must be someone else.'**
  String get errEmergencyIsYou;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Enter the 12-digit Aadhaar number.'**
  String get errInvalidAadhaar;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Enter the 10-character PAN.'**
  String get errInvalidPan;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This document has already expired.'**
  String get errAlreadyExpired;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This file can\'t be used. Choose a clear photo or a PDF.'**
  String get errInvalidFile;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'The file is too large (max 10 MB).'**
  String get errFileTooLarge;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Upload every required document first.'**
  String get errDocumentsMissing;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Finish your phones, email and profile first.'**
  String get errDetailsMissing;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be changed while your application is being checked.'**
  String get errNotEditable;

  /// Location services are turned off on the phone.
  ///
  /// In en, this message translates to:
  /// **'Location is off. Turn on location on your phone, then try again.'**
  String get locationOff;

  /// Family screen title (P22).
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyTitle;

  /// Family intro card title.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your loved ones'**
  String get familyIntroTitle;

  /// Family intro card text.
  ///
  /// In en, this message translates to:
  /// **'Add parents and relatives to book care for them, even in another city.'**
  String get familyIntroBody;

  /// Button: add a family member.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// Age in years.
  ///
  /// In en, this message translates to:
  /// **'{age} yrs'**
  String ageYears(int age);

  /// Empty family list.
  ///
  /// In en, this message translates to:
  /// **'No family members yet'**
  String get noFamilyYet;

  /// Relation: the account owner.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get relationSelf;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get relationMother;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get relationFather;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Grandmother'**
  String get relationGrandmother;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Grandfather'**
  String get relationGrandfather;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get relationSpouse;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get relationChild;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Brother / Sister'**
  String get relationSibling;

  /// Relation.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get relationOther;

  /// P28 title (add).
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get addMemberTitle;

  /// P28 title (edit).
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetailsTitle;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get relation;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Choose how they are related to you.'**
  String get relationRequired;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Their mobile number (optional)'**
  String get theirPhone;

  /// Help under the member phone.
  ///
  /// In en, this message translates to:
  /// **'They get SMS with the companion\'s name and the visit OTP.'**
  String get theirPhoneHelp;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Language they speak'**
  String get languageTheySpeak;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Health notes'**
  String get healthNotes;

  /// Privacy note.
  ///
  /// In en, this message translates to:
  /// **'Only the companion or nurse on the job sees these.'**
  String get healthNotesHelp;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get conditions;

  /// Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. diabetes, BP'**
  String get conditionsHint;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// Field label: mobility.
  ///
  /// In en, this message translates to:
  /// **'Getting around'**
  String get mobility;

  /// Mobility choice.
  ///
  /// In en, this message translates to:
  /// **'Walks alone'**
  String get mobilityWalksAlone;

  /// Mobility choice.
  ///
  /// In en, this message translates to:
  /// **'Needs support'**
  String get mobilityNeedsSupport;

  /// Mobility choice.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get mobilityWheelchair;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Hearing or vision'**
  String get sensoryNotes;

  /// Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. hard of hearing'**
  String get sensoryHint;

  /// Help under emergency contact.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use your own number.'**
  String get emergencyContactHelp;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Give both the name and the phone, or leave both empty.'**
  String get emergencyIncomplete;

  /// Consent tick (DPDP).
  ///
  /// In en, this message translates to:
  /// **'I have their permission to save these details and share them with WellWish partners for their care.'**
  String get consentMember;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Please tick to confirm their permission.'**
  String get consentRequired;

  /// Empty value.
  ///
  /// In en, this message translates to:
  /// **'Not given'**
  String get notGiven;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// Label.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobileLabel;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addressesTitle;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// Empty list.
  ///
  /// In en, this message translates to:
  /// **'No address saved yet.'**
  String get noAddresses;

  /// Empty list.
  ///
  /// In en, this message translates to:
  /// **'No documents yet.'**
  String get noDocumentsYet;

  /// Link.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTitle;

  /// Empty list.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet.'**
  String get noBookingsYet;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Book for {name}'**
  String bookForName(String name);

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Remove from family'**
  String get removeMember;

  /// Confirm title.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removeMemberTitle(String name);

  /// Confirm body.
  ///
  /// In en, this message translates to:
  /// **'They are hidden from the app. Past bookings keep their history.'**
  String get removeMemberBody;

  /// Address warning.
  ///
  /// In en, this message translates to:
  /// **'WellWish doesn\'t serve this area yet.'**
  String get outsideServiceArea;

  /// P24 title (add).
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddressTitle;

  /// P24 title (edit).
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get editAddressTitle;

  /// Whose address.
  ///
  /// In en, this message translates to:
  /// **'For {name}'**
  String addressForName(String name);

  /// Map help.
  ///
  /// In en, this message translates to:
  /// **'Move the map so the pin sits on the house.'**
  String get mapHelp;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Name this address'**
  String get addressLabel;

  /// Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home'**
  String get addressLabelHint;

  /// Quick label.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get labelHome;

  /// Quick label.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get labelWork;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get addressLine;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Landmark (optional)'**
  String get landmark;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Notes for the companion (optional)'**
  String get addressNotes;

  /// Hint.
  ///
  /// In en, this message translates to:
  /// **'Gate, floor, lift'**
  String get addressNotesHint;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Give the address a name.'**
  String get labelRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Enter the full address.'**
  String get addressLineRequired;

  /// After saving an address outside every service area.
  ///
  /// In en, this message translates to:
  /// **'Saved. WellWish doesn\'t serve this area yet, so it can\'t be booked.'**
  String get savedOutsideArea;

  /// Required map credit.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// Documents tab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// Documents tab.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get tabReports;

  /// Documents tab.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get tabPrescriptions;

  /// Member filter: all members.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// Button / sheet title.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get docTypePrescription;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'Lab report'**
  String get docTypeLabReport;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'X-ray / scan'**
  String get docTypeScan;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'Discharge summary'**
  String get docTypeDischarge;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get docTypeId;

  /// Document type.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'For whom'**
  String get forWhom;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get documentType;

  /// Field label: document name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get documentTitle;

  /// Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blood test'**
  String get documentTitleHint;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Date on the document (optional)'**
  String get documentDate;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'The file'**
  String get chooseFile;

  /// After picking a file.
  ///
  /// In en, this message translates to:
  /// **'File ready'**
  String get fileChosen;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo or a PDF.'**
  String get fileRequired;

  /// Validation.
  ///
  /// In en, this message translates to:
  /// **'Give the document a name.'**
  String get titleRequired;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm title.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get deleteDocumentTitle;

  /// Confirm body.
  ///
  /// In en, this message translates to:
  /// **'The file is deleted for good.'**
  String get deleteDocumentBody;

  /// Storage line.
  ///
  /// In en, this message translates to:
  /// **'{used} of {total} used'**
  String storageUsed(String used, String total);

  /// Empty state.
  ///
  /// In en, this message translates to:
  /// **'Upload prescriptions and reports once and use them in every booking.'**
  String get noDocumentsBody;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// PDF note.
  ///
  /// In en, this message translates to:
  /// **'Opens in your phone\'s PDF app.'**
  String get openInPhone;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This file can\'t be opened here.'**
  String get cannotOpen;

  /// P27 title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings row.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// Settings help.
  ///
  /// In en, this message translates to:
  /// **'Turn WellWish notifications on or off in your phone\'s settings.'**
  String get notificationsHelp;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Open phone settings'**
  String get openPhoneSettings;

  /// Settings row.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// Settings help.
  ///
  /// In en, this message translates to:
  /// **'Removes your profile, family, addresses and documents.'**
  String get deleteAccountHelp;

  /// Confirm title.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// Confirm body.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out now. Your profile, family members, addresses and documents are deleted after {days} days. Log in again before then to keep your account. Payment records are kept, as the law requires.'**
  String deleteAccountBody(int days);

  /// Confirm button.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountConfirm;

  /// Login screen message after a deletion request.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted soon. Log in again to keep it.'**
  String get accountDeletionRequested;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the most family members you can add.'**
  String get errTooManyMembers;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Up to 10 addresses per person. Remove an old one first.'**
  String get errTooManyAddresses;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Your documents are using all 200 MB. Delete some old ones first.'**
  String get errStorageFull;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'The date can\'t be in the future.'**
  String get errDateInFuture;

  /// Error (404).
  ///
  /// In en, this message translates to:
  /// **'This was removed or isn\'t yours.'**
  String get errNotFound;

  /// Hint on the family member's name field.
  ///
  /// In en, this message translates to:
  /// **'Their full name'**
  String get memberNameHint;

  /// A language a family member speaks (shown in the app's language).
  ///
  /// In en, this message translates to:
  /// **'Odia'**
  String get spokenOdia;

  /// A language a family member speaks.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get spokenHindi;

  /// A language a family member speaks.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get spokenEnglish;

  /// A language a family member speaks.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get spokenBengali;

  /// A language a family member speaks.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get spokenTelugu;

  /// Checkbox in the remove-member dialog.
  ///
  /// In en, this message translates to:
  /// **'Also delete their medical documents'**
  String get alsoDeleteDocuments;

  /// Saving a new address without placing the pin.
  ///
  /// In en, this message translates to:
  /// **'Move the map so the pin sits on the house, or use your current location.'**
  String get pinRequired;

  /// Settings: push notifications are not set up yet (Firebase).
  ///
  /// In en, this message translates to:
  /// **'Phone notifications arrive in a coming update. Until then, check the app for updates.'**
  String get notificationsLater;

  /// A member photo over 5 MB.
  ///
  /// In en, this message translates to:
  /// **'This photo is too large (max 5 MB).'**
  String get photoTooLarge;

  /// Account deletion.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted on {date}. Log in again before then to keep it.'**
  String accountDeletionOn(String date);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get tabDoctors;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospitals'**
  String get tabHospitals;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Search doctor or speciality…'**
  String get searchDoctorsHint;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Search hospital, area or doctor…'**
  String get searchHospitalsHint;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allSpecialities;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'No hospitals found'**
  String get noHospitalsFound;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Try another search or speciality.'**
  String get tryAnotherSearch;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String kmAway(String km);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospitals within {km} km'**
  String hospitalsWithin(int km);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'All hospitals'**
  String get hospitalsAll;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Allow location to see the closest hospitals first.'**
  String get hospitalsNoLocation;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get showMap;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get showList;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospitalTypeHospital;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get hospitalTypeClinic;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic centre'**
  String get hospitalTypeDiagnostic;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'OPD hours'**
  String get opdHours;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Doctors here'**
  String get doctorsHere;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No doctors listed} =1{1 doctor} other{{count} doctors}}'**
  String doctorCount(int count);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Book a companion to this hospital'**
  String get bookCompanionHere;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Book a companion for this doctor'**
  String get bookCompanionForDoctor;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get qualifications;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'OPD days and times'**
  String get opdDays;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Speaks'**
  String get doctorSpeaks;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Sees patients at'**
  String get doctorHospitals;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose the service you need'**
  String get chooseService;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String totalPrice(String amount);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Prescription needed'**
  String get prescriptionNeeded;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min'**
  String durationMinutes(int minutes);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'About {hours} h'**
  String durationHours(int hours);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'For {place}'**
  String bookingAt(String place);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'No services are available right now.'**
  String get noServices;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'What would you like to book?'**
  String get chooseBookingType;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Visit details'**
  String get visitDetailsTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospitalLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospital or pharmacy (optional)'**
  String get hospitalOptionalLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose the hospital'**
  String get chooseHospital;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'My hospital isn\'t listed'**
  String get hospitalNotListed;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Hospital name and area'**
  String get hospitalTextLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'e.g. City Care Hospital, Patia'**
  String get hospitalTextHint;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get doctorNotSure;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickADate;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Doctor appointment time'**
  String get appointmentTimeLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Tap to set (optional)'**
  String get appointmentTimeHint;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pickup time'**
  String get pickupTimeLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Visit time'**
  String get visitTimeLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTimeLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pickup suggested {minutes} min before the appointment. You can change it.'**
  String pickupSuggested(int minutes);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'No times left on this date. Please pick another date.'**
  String get noTimesLeft;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Times are India time (IST).'**
  String get timesInIst;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair, language, gate number…'**
  String get notesHint;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose who the booking is for.'**
  String get chooseMemberRequired;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose the hospital or type it in.'**
  String get hospitalRequired;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose a time.'**
  String get timeRequired;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'The appointment must be after the pickup time.'**
  String get appointmentAfterPickup;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressStepTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Where the companion picks them up.'**
  String get pickupAddressHelp;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Where the visit takes place.'**
  String get homeVisitAddressHelp;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Where the companion brings things back to.'**
  String get errandAddressHelp;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s addresses'**
  String addressesOfName(String name);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Other saved addresses'**
  String get otherAddresses;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Choose an address.'**
  String get addressRequiredToBook;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Attach documents'**
  String get attachDocumentsTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Tick the reports or prescriptions to take along. Only the assigned partner sees them.'**
  String get attachDocumentsHelp;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'This service needs a prescription.'**
  String get prescriptionRequiredHelp;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Please attach a prescription.'**
  String get attachPrescription;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'{name} has no documents yet.'**
  String noDocumentsForName(String name);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Review and pay'**
  String get reviewTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get whenLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get whereLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsLabel;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None} =1{1 document} other{{count} documents}}'**
  String documentsCount(int count);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get priceTotal;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pay now (booking fee)'**
  String get payNowFee;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pay your companion after the visit'**
  String get payCompanionAfter;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pay your nurse after the visit'**
  String get payNurseAfter;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Cab or auto fares and any extra time are settled directly with your partner.'**
  String get extrasNote;

  /// Patient price box when the booking fee is the whole price (balance 0).
  ///
  /// In en, this message translates to:
  /// **'Paid in full in the app: nothing to pay your companion or nurse after the visit.'**
  String get paidInFullNote;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Cancel before your partner is on the way and get {percent}% of the booking fee back.'**
  String cancellationRule(int percent);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'This time is no longer available. Please pick another time.'**
  String get errTimeNotAvailable;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'This service needs a prescription. Please attach one.'**
  String get errPrescriptionRequired;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'We don\'t serve this address yet. Please choose another address.'**
  String get errOutsideServiceArea;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'You have several bookings waiting for payment. Please try again later.'**
  String get errTooManyUnpaid;

  /// Phase 9.3: the server's limit on changes per minute (429 TOO_MANY_REQUESTS).
  ///
  /// In en, this message translates to:
  /// **'Too many changes in a minute. Please wait a moment and try again.'**
  String get errTooManyRequests;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Please check the booking details.'**
  String get errInvalidBooking;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'This person has a booking that isn\'t finished. Cancel it first.'**
  String get errMemberHasBookings;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'You have a booking that isn\'t finished. Cancel it or wait until it\'s done.'**
  String get errActiveBookings;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Booking saved'**
  String get bookingSavedTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Online payment isn\'t available right now. Your booking {code} is saved and waits for payment.'**
  String bookingSavedBody(String code);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Booking {code}'**
  String bookingCode(String code);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Next booking'**
  String get nextBooking;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment'**
  String get statusPendingPayment;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Booked. We\'re assigning your partner.'**
  String get statusAssigning;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Partner assigned'**
  String get statusAssigned;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Patient not available'**
  String get statusNoShow;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Not paid in time'**
  String get statusExpired;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pay by {time}'**
  String payBy(String time);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Appointment {time}'**
  String appointmentAt(String time);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Pickup {time}'**
  String pickupAt(String time);

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Booking made'**
  String get eventCreate;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Document removed'**
  String get documentRemoved;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'Your addresses'**
  String get yourAddresses;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'You have no documents yet.'**
  String get youHaveNoDocuments;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'No pickup time fits before this appointment. Pick a later appointment or another date.'**
  String get appointmentTooEarly;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'The pickup is too early for this appointment. Pick a later pickup time.'**
  String get pickupTooEarly;

  /// Phase 5: directory and booking.
  ///
  /// In en, this message translates to:
  /// **'This booking was changed. Please check it and tap Pay again.'**
  String get errBookingChanged;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Confirming your payment…'**
  String get paymentProcessingTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'This takes a few seconds. You can leave this screen: we\'ll send you a message.'**
  String get paymentProcessingBody;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'We\'re still confirming your payment. We\'ll send you a message as soon as it\'s done.'**
  String get paymentTakingLong;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get paymentConfirmedTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'We\'re assigning your partner. Their name, photo and phone appear here once they accept.'**
  String get paymentConfirmedBody;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Payment didn\'t go through'**
  String get paymentFailedTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'If money was taken, it is confirmed or returned automatically. You can try again until {time}.'**
  String paymentFailedBody(String time);

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelledTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Paid {amount}'**
  String paidAmount(String amount);

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get tabOngoing;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tabPast;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings.'**
  String get noUpcomingBookings;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Nothing in progress right now.'**
  String get noOngoingBookings;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'No past bookings yet.'**
  String get noPastBookings;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get back {amount} ({percent}% of the booking fee) to your payment method in 5 to 7 working days.'**
  String cancelRefund(String amount, int percent);

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'No refund applies to this booking.'**
  String get cancelNoRefund;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Why are you cancelling?'**
  String get cancelReasonLabel;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Plans changed'**
  String get cancelReasonPlans;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Booked by mistake'**
  String get cancelReasonMistake;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Another reason'**
  String get cancelReasonOther;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Tell us more (optional)'**
  String get cancelReasonHint;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get confirmCancel;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get keepBooking;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Your partner is already on the way. Please call WellWish support to cancel.'**
  String get cancelNotAllowed;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelledSnack;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refundsTitle;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Being approved'**
  String get refundAwaiting;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'On its way'**
  String get refundPending;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refundProcessed;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Failed: support will call you'**
  String get refundFailed;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get refundRejected;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Change date or time'**
  String get changeTime;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No changes left} =1{1 change left} other{{count} changes left}}'**
  String reschedulesLeft(int count);

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'It\'s too close to the pickup to change the time. Please call WellWish support.'**
  String get rescheduleTooLate;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'The time can\'t be changed again. Please call WellWish support.'**
  String get rescheduleLimit;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Confirm new time'**
  String get confirmNewTime;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Time changed.'**
  String get timeChangedSnack;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Your partner will confirm the new time.'**
  String get partnerWillReconfirm;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Now: {time}'**
  String currentTime(String time);

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'This booking can\'t be paid any more. Please book again.'**
  String get errNotPayable;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Online payment isn\'t available right now. Please try again later.'**
  String get errPaymentsNotSetUp;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t confirm this payment. If money was taken, it will be confirmed or refunded.'**
  String get errInvalidSignature;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'The payment service didn\'t answer. Please try again.'**
  String get errGateway;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'The time can\'t be changed in the app any more. Please call WellWish support.'**
  String get rescheduleNotAllowed;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Booking fee paid'**
  String get eventPaid;

  /// Phase 6: payment, cancel, reschedule.
  ///
  /// In en, this message translates to:
  /// **'Date or time changed'**
  String get eventRescheduled;

  /// Phase 6: the fee line on a booking that is no longer unpaid.
  ///
  /// In en, this message translates to:
  /// **'Booking fee (online)'**
  String get bookingFeeOnline;

  /// Phase 6: paid too late, the money goes back.
  ///
  /// In en, this message translates to:
  /// **'Booking not made'**
  String get paymentNotBookedTitle;

  /// Phase 6: paid too late, the money goes back.
  ///
  /// In en, this message translates to:
  /// **'The payment time ran out, or the time was taken while you paid. Your money is returned in full in 5 to 7 working days. Please book again.'**
  String get paymentNotBookedBody;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'New offers'**
  String get offersTitle;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'{time} left to answer'**
  String offerTimeLeft(String time);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Please answer: WellWish is waiting'**
  String get offerWaiting;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Time changed: please confirm'**
  String get offerReconfirm;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Today\'s jobs'**
  String get todayJobsTitle;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'No jobs today.'**
  String get noJobsToday;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get totalsDoneToday;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get totalsThisWeek;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get totalsUpcoming;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Today\'s selfie'**
  String get selfieTitle;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Take a quick selfie before you go available. WellWish checks it against your profile photo.'**
  String get selfieBody;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Take selfie'**
  String get takeSelfie;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Selfie saved. You\'re available today.'**
  String get selfieSaved;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Take today\'s selfie first.'**
  String get selfieNeeded;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Booking offer'**
  String get offerTitle;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get offerArea;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'{km} km from your home'**
  String offerDistance(String km);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get offerPatient;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get offerNeeds;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No documents} =1{1 document attached} other{{count} documents attached}}'**
  String offerDocuments(int count);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Prescription attached'**
  String get offerPrescription;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'You collect {amount} after the job'**
  String offerBalance(String amount);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'The full address, phone numbers, health notes and documents open after you accept.'**
  String get offerDetailsLater;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptOffer;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Confirm new time'**
  String get acceptNewTime;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineOffer;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Why can\'t you take it?'**
  String get declineTitle;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get declineNotAvailable;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Too far'**
  String get declineTooFar;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get declineOther;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get declineNoteHint;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Declined. WellWish will find someone else.'**
  String get offerDeclined;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'This booking is no longer yours.'**
  String get errOfferNotOpen;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'You have another job at that time.'**
  String get errPartnerBusy;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get jobsNew;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get jobsUpcoming;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get jobsCompleted;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'No new offers.'**
  String get noOffers;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'No upcoming jobs.'**
  String get noUpcomingJobs;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'No completed jobs yet.'**
  String get noCompletedJobs;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Job {code}'**
  String jobTitle(String code);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get jobAddress;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// Partner job: opens Google Maps to the hospital (after picking up the patient).
  ///
  /// In en, this message translates to:
  /// **'Navigate to the hospital'**
  String get navigateHospital;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Call the patient'**
  String get callPatient;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Call {name} (who booked)'**
  String callBooker(String name);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Collect {amount} after the job'**
  String collectBalance(String amount);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get jobAccepted;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'The time changed. Confirm the new time under New offers.'**
  String get reconfirmPending;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openDocument;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Your partner'**
  String get yourPartner;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callName(String name);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'{rating} ({count, plural, =1{1 review} other{{count} reviews}})'**
  String ratingCount(String rating, int count);

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'New partner'**
  String get newPartner;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'This job is yours.'**
  String get offerAccepted;

  /// Phase 7: assignment (partner offers and jobs, patient's partner).
  ///
  /// In en, this message translates to:
  /// **'Open the job'**
  String get openJob;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get stepOnTheWay;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Reached the patient'**
  String get stepReachedPatient;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get stepPickedUp;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'At the hospital'**
  String get stepReachedHospital;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Visit done'**
  String get stepVisitDone;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Dropped home'**
  String get stepDroppedHome;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Reached home'**
  String get stepReachedHome;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Care started'**
  String get stepStarted;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Care done'**
  String get stepCareDone;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'At the hospital / pharmacy'**
  String get stepAtPlace;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Task done'**
  String get stepTaskDone;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get stepDelivered;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get stepCompleted;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Your job now'**
  String get activeJobTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Next: {step}'**
  String nextStepIs(String step);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Tap when this is done'**
  String get tapWhenDone;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Sharing your location with the patient'**
  String get sharingLocation;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Can\'t read your location. Allow location for WellWish Partner and turn on Location.'**
  String get locationOffHelp;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'WellWish visit'**
  String get fgsTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Sharing your location with the patient for this visit'**
  String get fgsText;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Ask for the visit code'**
  String get enterOtpTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'The family has a 4-digit code in the WellWish app or SMS.'**
  String get enterOtpBody;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Wrong code. {tries} tries left.'**
  String jobOtpWrong(int tries);

  /// Partner: after 4 wrong visit codes, a wait before the next try (5, 10, 20 min...).
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Try again at {time}, or call WellWish: they can confirm with the family.'**
  String otpWaitUntil(String time);

  /// Partner: 3rd wrong visit code (the 4th starts a wait).
  ///
  /// In en, this message translates to:
  /// **'Wrong code. One more wrong code and you\'ll have to wait 5 minutes.'**
  String get jobOtpLastTry;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'No network. Call WellWish to confirm the code.'**
  String get noNetworkOtp;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Saved on your phone. It\'ll be sent when you\'re back online.'**
  String get stepQueued;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Waiting for network: {count, plural, =1{1 step} other{{count} steps}} to send'**
  String pendingSteps(int count);

  /// Active job: a step kept offline was refused by the server when sent.
  ///
  /// In en, this message translates to:
  /// **'A step saved on your phone wasn\'t accepted (WellWish may have marked it already). Check the steps below, or call WellWish.'**
  String get stepsRefused;

  /// Partner tapped On the way more than 2 hours before pickup.
  ///
  /// In en, this message translates to:
  /// **'Too early to start. You can tap \"On the way\" from {time}.'**
  String tooEarlyToStart(String time);

  /// Active job: restart location sharing after fixing the location setting.
  ///
  /// In en, this message translates to:
  /// **'Try sharing again'**
  String get shareAgain;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Call WellWish'**
  String get callWellWish;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Waiting for the patient: {time} left'**
  String waitTimer(String time);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Patient not available'**
  String get patientNotAvailable;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Mark the patient as not available? WellWish will review it.'**
  String get noShowConfirm;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Try calling the patient first.'**
  String get callFirst;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Marked: patient not available. WellWish will review it.'**
  String get noShowDone;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Job completed. Thank you!'**
  String get jobFinished;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get sosTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'WellWish and the emergency contacts get an alert with your location. For police call 112, for an ambulance 108.'**
  String get sosBody;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Send SOS to WellWish'**
  String get sendSos;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'WellWish has been alerted.'**
  String get sosSent;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Call 112 (police)'**
  String get call112;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Call 108 (ambulance)'**
  String get call108;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Care note'**
  String get careNoteTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'What you did and how the patient is'**
  String get careNoteHint;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Please write a short care note.'**
  String get careNoteRequired;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Vitals (optional)'**
  String get vitalsTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'BP (e.g. 120/80)'**
  String get bpLabel;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulseLabel;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Temperature (°F)'**
  String get temperatureLabel;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'SpO₂ (%)'**
  String get spo2Label;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Sugar (mg/dL)'**
  String get sugarLabel;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Save and mark Care done'**
  String get saveCareNote;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Check this value'**
  String get invalidValue;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Collect balance'**
  String get collectTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Record what you collected. WellWish doesn\'t handle this money.'**
  String get collectBody;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get amountRupees;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get payCash;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get payUpi;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get balanceNoteHint;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Record balance'**
  String get recordBalance;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Collected {amount} ({mode})'**
  String balanceRecorded(String amount, String mode);

  /// Collect balance refused (BALANCE_NOT_DUE): the booking has no balance.
  ///
  /// In en, this message translates to:
  /// **'Nothing to collect: the family paid the full price in the app.'**
  String get balanceNotDue;

  /// Collect balance refused (BALANCE_TOO_HIGH); amount is the balance due.
  ///
  /// In en, this message translates to:
  /// **'That\'s more than the balance to collect ({amount}).'**
  String balanceTooHigh(String amount);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get totalsTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Jobs done'**
  String get jobsDoneTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get totalsThisMonth;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get totalsAllTime;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Balance collected'**
  String get balanceCollectedTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Cash {cash} · UPI {upi}'**
  String cashUpi(String cash, String upi);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitleTotals;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'{received} received · {accepted} accepted · {declined} declined · {late} not answered in 2 min'**
  String offersLine(int received, int accepted, int declined, int late);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'See totals'**
  String get seeTotals;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Visit code'**
  String get visitCodeTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Give this code to {name} when they arrive. Don\'t share it on the phone.'**
  String visitCodeHelp(String name);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Track live'**
  String get trackLive;

  /// Patient live tracking: shown once the job is completed or ended.
  ///
  /// In en, this message translates to:
  /// **'The visit is over. Live location has stopped.'**
  String get liveEnded;

  /// Button on the live screen after the visit ended.
  ///
  /// In en, this message translates to:
  /// **'Back to the booking'**
  String get backToBooking;

  /// Patient: the partner's current step, e.g. 'Now: On the way'.
  ///
  /// In en, this message translates to:
  /// **'Now: {step}'**
  String nowStep(String step);

  /// Rating: no stars chosen yet.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 to 5 stars'**
  String get chooseStars;

  /// Screen reader label of a rating star button.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String starsSemantics(int count);

  /// Report a problem: the text is too short (under 5 letters).
  ///
  /// In en, this message translates to:
  /// **'Please write a few words'**
  String get reportTooShort;

  /// Report a problem: send button.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendReport;

  /// Error ALREADY_REVIEWED.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already rated this visit.'**
  String get errAlreadyReviewed;

  /// Error NOT_REVIEWABLE.
  ///
  /// In en, this message translates to:
  /// **'This visit can\'t be rated.'**
  String get errNotReviewable;

  /// Error REPORT_TOO_LATE.
  ///
  /// In en, this message translates to:
  /// **'Problems can be reported up to 24 hours after the visit. Please call WellWish.'**
  String get errReportTooLate;

  /// Error NOT_IN_PROGRESS (SOS outside a visit).
  ///
  /// In en, this message translates to:
  /// **'The visit isn\'t in progress. For an emergency call 112.'**
  String get errNotInProgress;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Live visit'**
  String get liveTitle;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min away'**
  String etaMinutes(int minutes);

  /// Patient live map ETA of an hour or more.
  ///
  /// In en, this message translates to:
  /// **'About {hours} h {minutes} min away'**
  String etaHours(int hours, int minutes);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAt(String time);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}\'s location…'**
  String waitingForLocation(String name);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Share trip'**
  String get shareTrip;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Link copied. Send it on WhatsApp or SMS.'**
  String get linkCopied;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Visit completed'**
  String get visitCompleted;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} to {name}'**
  String payPartner(String amount, String name);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Pay the balance directly to your companion or nurse (cash or UPI). Cab fares and extra time are settled with them.'**
  String get payPartnerHelp;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Rate the visit'**
  String get rateVisit;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Anything to add? (optional)'**
  String get reviewCommentHint;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get sendRating;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Thanks for rating!'**
  String get ratingThanks;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get tagOnTime;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get tagKind;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get tagHelpful;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get tagProfessional;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Explained well'**
  String get tagGoodCommunication;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get tagLate;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Rude'**
  String get tagRude;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Not helpful'**
  String get tagUnhelpful;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportProblem;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'What went wrong?'**
  String get reportHint;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Sent. WellWish will get back to you.'**
  String get reportSent;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Problems you reported'**
  String get reportedProblems;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'WellWish replied'**
  String get wellwishReplied;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketClosed;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ticketOpen;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'{name} couldn\'t meet the patient. WellWish will call you.'**
  String noShowShown(String name);

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Care note'**
  String get docTypeCareNote;

  /// Phase 8: the visit (job steps, live location, SOS, care note, balance, rating).
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitalsLine;

  /// Blood pressure, short (care note vitals in the patient's documents).
  ///
  /// In en, this message translates to:
  /// **'BP'**
  String get bpShort;

  /// Under a care note in the patient's documents.
  ///
  /// In en, this message translates to:
  /// **'Written by the nurse at the visit'**
  String get careNoteBy;

  /// Phase 8B: a temporary partner's home (§6.19), which shows only their one job.
  ///
  /// In en, this message translates to:
  /// **'Your WellWish job'**
  String get tempHomeTitle;

  /// Phase 8B: under the title of a temporary partner's home (§6.19).
  ///
  /// In en, this message translates to:
  /// **'WellWish asked you to do this one visit. Follow the steps below, one at a time.'**
  String get tempHomeBody;

  /// Phase 8B: a temporary partner's selfie before "On the way" (§6.19).
  ///
  /// In en, this message translates to:
  /// **'Take a selfie before you start. The family and WellWish see it as your photo for this visit.'**
  String get tempSelfieBody;

  /// Phase 8B: after a temporary partner's selfie (§6.19).
  ///
  /// In en, this message translates to:
  /// **'Selfie saved. You can start the job now.'**
  String get tempSelfieSaved;

  /// Phase 8B: on the login screen when a temporary partner's access ended with their job (§6.19, revoke reason JOB_OVER).
  ///
  /// In en, this message translates to:
  /// **'Your WellWish job is over. Thank you!'**
  String get tempJobOver;

  /// Phase 9.3: Partner app Home, when the phone looks rooted (§12). A warning only; the partner can still work.
  ///
  /// In en, this message translates to:
  /// **'This phone looks rooted. Patients\' details and your account are less safe on it. Please use a phone that isn\'t rooted for WellWish jobs.'**
  String get rootedWarning;

  /// Phase 9.8: what TalkBack says for the code boxes on the login and contact-check screens.
  ///
  /// In en, this message translates to:
  /// **'The 6-digit code'**
  String get otpFieldLabel;

  /// Phase 9.11: P20 after the partner recorded the balance they collected (instead of 'Pay {amount} to {name}').
  ///
  /// In en, this message translates to:
  /// **'Paid {amount} to {name}'**
  String paidPartner(String amount, String name);

  /// Phase 9B: settings card with the legal pages (§6.20).
  ///
  /// In en, this message translates to:
  /// **'Terms and policies'**
  String get legalTitle;

  /// Phase 9B: a legal page's name.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get legalTerms;

  /// Phase 9B: a legal page's name.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacy;

  /// Phase 9B: a legal page's name.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get legalRefunds;

  /// Phase 9B: a legal page's name (partner app).
  ///
  /// In en, this message translates to:
  /// **'Partner Terms'**
  String get legalPartnerTerms;

  /// Phase 9B: link under a consent line that opens the page in the browser.
  ///
  /// In en, this message translates to:
  /// **'Read the {page}'**
  String legalRead(String page);

  /// Phase 9B: partner app consent line (§6.20).
  ///
  /// In en, this message translates to:
  /// **'I accept the Partner Terms'**
  String get consentPartnerTerms;

  /// Phase 9B: under the Partner Terms consent line.
  ///
  /// In en, this message translates to:
  /// **'How jobs, location sharing, conduct and your account work.'**
  String get consentPartnerTermsDetail;

  /// Phase 9B: under 'Delete my account' in the partner app.
  ///
  /// In en, this message translates to:
  /// **'Removes your profile, phone numbers, email and documents.'**
  String get partnerDeleteAccountHelp;

  /// Phase 9B: confirm dialog before a partner deletes their account (§6.20).
  ///
  /// In en, this message translates to:
  /// **'You will be logged out now. Your profile, phone numbers, email, address and documents are deleted after {days} days. Log in again before then to keep your account. Your past jobs stay on record without your personal details.'**
  String partnerDeleteAccountBody(int days);

  /// Phase 9B: 409 ACTIVE_JOBS when a partner deletes their account.
  ///
  /// In en, this message translates to:
  /// **'You have an accepted or ongoing job. Ask WellWish to move it, then try again.'**
  String get errorActiveJobs;

  /// Phase 9B: login screen after deleting a partner login with nothing saved (deleted at once).
  ///
  /// In en, this message translates to:
  /// **'Your account is deleted.'**
  String get accountErased;

  /// Phase 9B: confirm text for 'Delete my account' before choosing a role (deleted at once).
  ///
  /// In en, this message translates to:
  /// **'Nothing else is saved for this number in the Partner app. It is deleted now and you are logged out.'**
  String get deleteLoginBody;

  /// Phase 9B: consent screen when a new version was published while it was open.
  ///
  /// In en, this message translates to:
  /// **'WellWish just updated these pages. Please read and accept them again.'**
  String get consentChanged;

  /// Phase 9B: the signed upload link expired before the file was sent.
  ///
  /// In en, this message translates to:
  /// **'The upload took too long. Please try again.'**
  String get errUploadAgain;
}

class _WWLocalizationsDelegate extends LocalizationsDelegate<WWLocalizations> {
  const _WWLocalizationsDelegate();

  @override
  Future<WWLocalizations> load(Locale locale) {
    return SynchronousFuture<WWLocalizations>(lookupWWLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'or'].contains(locale.languageCode);

  @override
  bool shouldReload(_WWLocalizationsDelegate old) => false;
}

WWLocalizations lookupWWLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return WWLocalizationsEn();
    case 'hi':
      return WWLocalizationsHi();
    case 'or':
      return WWLocalizationsOr();
  }

  throw FlutterError(
    'WWLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
