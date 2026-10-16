import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for PartnerApi
void main() {
  final instance = WwApi().getPartnerApi();

  group(PartnerApi, () {
    // Alternate Phone
    //
    // R04: send an OTP to the alternate number (must differ from the login number).
    //
    //Future<OtpSendOut> partnerAlternatePhoneSend(PhoneIn phoneIn) async
    test('test partnerAlternatePhoneSend', () async {
      // TODO
    });

    // Alternate Phone Verify
    //
    //Future<KycStatusOut> partnerAlternatePhoneVerify(CodeIn codeIn) async
    test('test partnerAlternatePhoneVerify', () async {
      // TODO
    });

    // Availability Get
    //
    // R08: whether the partner is available today and has taken today's selfie.
    //
    //Future<AvailabilityOut> partnerAvailabilityGet() async
    test('test partnerAvailabilityGet', () async {
      // TODO
    });

    // Availability
    //
    // Approved partners: \"Available today\" (§8.3). Helps the admin choose; no tracking. For today's India date only; switching on needs today's selfie (409 SELFIE_REQUIRED).
    //
    //Future<AvailabilityOut> partnerAvailabilitySet(AvailabilityIn availabilityIn) async
    test('test partnerAvailabilitySet', () async {
      // TODO
    });

    // Accept Consents
    //
    // The Partner Terms and Privacy Policy, with version, time and IP (§6.20). Open at every status: new partners accept before registering, earlier ones at their next app open.
    //
    //Future<PartnerMeOut> partnerConsentsAccept(ConsentsIn consentsIn) async
    test('test partnerConsentsAccept', () async {
      // TODO
    });

    // Delete Account
    //
    // Delete my account (§6.20), at any status. You are logged out on every phone now; your personal data is erased after `dueAt`, unless you log in again before then. 409 `ACTIVE_JOBS` while an accepted or ongoing job is yours: WellWish moves it first.
    //
    //Future<PartnerDeletionOut> partnerDeleteAccount() async
    test('test partnerDeleteAccount', () async {
      // TODO
    });

    // Register Device
    //
    //Future<OkOut> partnerDeviceRegister(DeviceIn deviceIn) async
    test('test partnerDeviceRegister', () async {
      // TODO
    });

    // Email
    //
    // R04: email a 6-digit code.
    //
    //Future<EmailSentOut> partnerEmailSend(EmailIn emailIn) async
    test('test partnerEmailSend', () async {
      // TODO
    });

    // Email Verify
    //
    //Future<KycStatusOut> partnerEmailVerify(CodeIn codeIn) async
    test('test partnerEmailVerify', () async {
      // TODO
    });

    // Home
    //
    // R08: Available today, open offers (countdown from `timeoutAt`), today's jobs, totals.
    //
    //Future<PartnerHomeOut> partnerHome() async
    test('test partnerHome', () async {
      // TODO
    });

    // Balance
    //
    // R14: the balance collected (cash / UPI), after Completed; can be corrected for 24 h.
    //
    //Future<PartnerJobOut> partnerJobBalance(String bookingId, BalanceIn balanceIn) async
    test('test partnerJobBalance', () async {
      // TODO
    });

    // Call
    //
    // The partner tapped Call (kept on the timeline; needed before \"patient not available\").
    //
    //Future partnerJobCall(String bookingId, CallIn callIn) async
    test('test partnerJobCall', () async {
      // TODO
    });

    // Job Document
    //
    // A 5-minute link to an attached document, from acceptance until 24 hours after completion (§6.8, §12). Every view is logged.
    //
    //Future<DocumentLinkOut> partnerJobDocumentUrl(String bookingId, String linkId) async
    test('test partnerJobDocumentUrl', () async {
      // TODO
    });

    // Job
    //
    // R11: full details of a job the partner accepted (others are 404).
    //
    //Future<PartnerJobOut> partnerJobGet(String bookingId) async
    test('test partnerJobGet', () async {
      // TODO
    });

    // Patient Not Available
    //
    // 15 minutes after arriving and after a call attempt (409 TOO_EARLY {readyAt, called}). The job ends; the admin reviews it.
    //
    //Future<PartnerJobOut> partnerJobNoShow(String bookingId, PlaceIn placeIn) async
    test('test partnerJobNoShow', () async {
      // TODO
    });

    // Step
    //
    // R12: the next step. 409 STEP_OUT_OF_ORDER, 422 WRONG_OTP {triesLeft, retryAt?}, 409 OTP_WAIT {retryAt} (after 4 wrong codes: 5, 10, 20 min…), 409 TOO_EARLY_TO_START, 422 CARE_NOTE_REQUIRED (nurses at CARE_DONE). Sending a step again does nothing.
    //
    //Future<PartnerJobOut> partnerJobStep(String bookingId, StepIn stepIn) async
    test('test partnerJobStep', () async {
      // TODO
    });

    // Jobs
    //
    // R10 Upcoming (accepted, soonest first) · Completed (latest first).
    //
    //Future<PagedPartnerJobRowOut> partnerJobsList({ String bucket, int page, int pageSize }) async
    test('test partnerJobsList', () async {
      // TODO
    });

    // Add Document
    //
    // Attach an uploaded document (number masked for Aadhaar/PAN; expiry date if needed). A new upload of the same type replaces the old one.
    //
    //Future<KycStatusOut> partnerKycDocumentAdd(DocumentIn documentIn) async
    test('test partnerKycDocumentAdd', () async {
      // TODO
    });

    // Required
    //
    // The documents for the partner's role (§6.3 list; the admin can change it).
    //
    //Future<List<RequiredDocumentOut>> partnerKycRequired() async
    test('test partnerKycRequired', () async {
      // TODO
    });

    // Status
    //
    // Everything for the registration, documents and status screens (R04 to R07, R16).
    //
    //Future<KycStatusOut> partnerKycStatus() async
    test('test partnerKycStatus', () async {
      // TODO
    });

    // Submit
    //
    // Send the application for review (§6.3 step 7).
    //
    //Future<KycStatusOut> partnerKycSubmit() async
    test('test partnerKycSubmit', () async {
      // TODO
    });

    // Upload Url
    //
    // Step 1 of an upload (profile photo or a document): PUT the file to `uploadUrl`, then send `fileKey` with the profile or document.
    //
    //Future<UploadUrlOut> partnerKycUploadUrl(PartnerUploadUrlIn partnerUploadUrlIn) async
    test('test partnerKycUploadUrl', () async {
      // TODO
    });

    // Set Language
    //
    // The app's language and of the messages they get (inbox, push, email; SMS stay English). Open at every status, like /me (§5).
    //
    //Future<PartnerMeOut> partnerLanguageSet(LanguageIn languageIn) async
    test('test partnerLanguageSet', () async {
      // TODO
    });

    // Me
    //
    // Who is logged in, and their partner status (null until they register in Phase 3).
    //
    //Future<PartnerMeOut> partnerMeGet() async
    test('test partnerMeGet', () async {
      // TODO
    });

    // List Notifications
    //
    // Newest first.
    //
    //Future<PagedNotificationOut> partnerNotificationsList({ int page, int pageSize }) async
    test('test partnerNotificationsList', () async {
      // TODO
    });

    // Mark Read
    //
    //Future<UnreadCountOut> partnerNotificationsRead(MarkReadIn markReadIn) async
    test('test partnerNotificationsRead', () async {
      // TODO
    });

    // Unread Count
    //
    //Future<UnreadCountOut> partnerNotificationsUnread() async
    test('test partnerNotificationsUnread', () async {
      // TODO
    });

    // Accept
    //
    // Accept: the job is yours; the full details open (R11). 409 OFFER_NOT_OPEN (\"no longer yours\"), PARTNER_BUSY (another job then).
    //
    //Future<PartnerJobOut> partnerOfferAccept(String assignmentId) async
    test('test partnerOfferAccept', () async {
      // TODO
    });

    // Decline
    //
    // Decline with a reason: the booking goes back to the admin. Returns the open offers left.
    //
    //Future<List<OfferSummaryOut>> partnerOfferDecline(String assignmentId, DeclineIn declineIn) async
    test('test partnerOfferDecline', () async {
      // TODO
    });

    // Offer
    //
    // R09 summary. 409 OFFER_NOT_OPEN on accept/decline once it was withdrawn.
    //
    //Future<OfferSummaryOut> partnerOfferGet(String assignmentId) async
    test('test partnerOfferGet', () async {
      // TODO
    });

    // Offers
    //
    // R10 \"New\": the open offers, soonest visit first.
    //
    //Future<List<OfferSummaryOut>> partnerOffersList() async
    test('test partnerOffersList', () async {
      // TODO
    });

    // Profile
    //
    // R05: name, DOB, gender, photo, home address + pin, languages, skills, emergency contact.
    //
    //Future<KycStatusOut> partnerProfileSave(ProfileIn profileIn) async
    test('test partnerProfileSave', () async {
      // TODO
    });

    // Start
    //
    // R03: Companion or Nurse. Can be changed until the application is submitted.
    //
    //Future<KycStatusOut> partnerRegisterStart(StartIn startIn) async
    test('test partnerRegisterStart', () async {
      // TODO
    });

    // Reviews
    //
    // The latest 20 visible reviews.
    //
    //Future<List<PartnerReviewOut>> partnerReviews() async
    test('test partnerReviews', () async {
      // TODO
    });

    // Selfie
    //
    // The once-a-day selfie before going available (§6.15): upload it with the `partner_selfie` upload URL, then send its `fileKey`. The admin spot-checks them.
    //
    //Future<AvailabilityOut> partnerSelfieAdd(SelfieIn selfieIn) async
    test('test partnerSelfieAdd', () async {
      // TODO
    });

    // Sos
    //
    // The admins' alarm + SMS to the partner's emergency contact. 409 NOT_IN_PROGRESS.
    //
    //Future<SosOut> partnerSos(String bookingId, SosIn sosIn) async
    test('test partnerSos', () async {
      // TODO
    });

    // Totals
    //
    // R15 Totals (§6.13): jobs, balance collected, acceptance, rating and recent reviews.
    //
    //Future<PartnerStatsOut> partnerTotals() async
    test('test partnerTotals', () async {
      // TODO
    });

    // Track Batch
    //
    // Points from a network drop, oldest first or not: added to the route.
    //
    //Future<TrackBatchOut> partnerTrackBatch(String bookingId, TrackBatchIn trackBatchIn) async
    test('test partnerTrackBatch', () async {
      // TODO
    });

  });
}
