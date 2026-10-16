import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for PatientApi
void main() {
  final instance = WwApi().getPatientApi();

  group(PatientApi, () {
    // Add Address
    //
    // Save an address for a family member (or yourself). `inServiceArea` says whether WellWish serves it.
    //
    //Future<AddressOut> patientAddressAdd(AddressIn addressIn) async
    test('test patientAddressAdd', () async {
      // TODO
    });

    // List Addresses
    //
    // Your saved addresses (`memberId` → only that family member's).
    //
    //Future<List<AddressOut>> patientAddressList({ String memberId }) async
    test('test patientAddressList', () async {
      // TODO
    });

    // Remove Address
    //
    //Future<OkOut> patientAddressRemove(String addressId) async
    test('test patientAddressRemove', () async {
      // TODO
    });

    // Update Address
    //
    //Future<AddressOut> patientAddressUpdate(String addressId, AddressIn addressIn) async
    test('test patientAddressUpdate', () async {
      // TODO
    });

    // Book
    //
    // \"Book\" on Review (P15). Checks the member and address are yours, the address is inside a service area, the time is still allowed and a prescription is attached when the service needs one. Saved as PENDING_PAYMENT with the price, member and address as they are now.  `Idempotency-Key` (8 to 64 letters, digits, - or _), made once per Review screen: sending the same key again returns the same booking, so a double tap or a retry never books twice. Errors: 409 TIME_NOT_AVAILABLE (reload the times), 422 PRESCRIPTION_REQUIRED, 422 OUTSIDE_SERVICE_AREA, 422 INVALID_BOOKING (`details.field`), 429 TOO_MANY_UNPAID.
    //
    //Future<BookingDetailOut> patientBook(String idempotencyKey, BookingIn bookingIn) async
    test('test patientBook', () async {
      // TODO
    });

    // Cancel
    //
    // Cancel before the partner is on the way. The setting's share of the booking fee (50 %) is refunded to the original payment method. 409 CANCEL_NOT_ALLOWED after that.
    //
    //Future<BookingDetailOut> patientBookingCancel(String bookingId, CancelIn cancelIn) async
    test('test patientBookingCancel', () async {
      // TODO
    });

    // Cancel Preview
    //
    // W-P4: \"You'll get back ₹50 (50% of the booking fee)\". `allowed` false once the partner is on the way (then the patient calls support).
    //
    //Future<CancelPreviewOut> patientBookingCancelPreview(String bookingId) async
    test('test patientBookingCancelPreview', () async {
      // TODO
    });

    // Checkout
    //
    // The Razorpay order to pay this booking's fee with (P15 \"Pay ₹X\", or \"Pay now\" on the booking). The same open order is returned again on a retry. 409 BOOKING_NOT_PAYABLE after the payment time; 503 PAYMENTS_NOT_SET_UP before the keys are entered.
    //
    //Future<CheckoutOut> patientBookingCheckout(String bookingId) async
    test('test patientBookingCheckout', () async {
      // TODO
    });

    // Get Booking
    //
    // P18: the booking with its timeline (the partner, OTP and live map come later).
    //
    //Future<BookingDetailOut> patientBookingGet(String bookingId) async
    test('test patientBookingGet', () async {
      // TODO
    });

    // List Bookings
    //
    // P17: `upcoming` (soonest first: waiting for payment, being assigned, assigned), `ongoing` (in progress) or `past` (latest first: completed, cancelled, expired).
    //
    //Future<PagedBookingRowOut> patientBookingList({ String bucket, int page, int pageSize }) async
    test('test patientBookingList', () async {
      // TODO
    });

    // Live
    //
    // The partner's latest point and ETA (empty before \"On the way\" and after the job).
    //
    //Future<LiveLocationOut> patientBookingLive(String bookingId) async
    test('test patientBookingLive', () async {
      // TODO
    });

    // Reschedule
    //
    // P30: a new date and time, same rules as booking; until the cut-off before pickup (3 h) and at most the setting's number of times (2). Price and fee don't change. 409 RESCHEDULE_NOT_ALLOWED (`details.reason`: STATUS, TOO_LATE, LIMIT), 409 TIME_NOT_AVAILABLE.
    //
    //Future<BookingDetailOut> patientBookingReschedule(String bookingId, RescheduleIn rescheduleIn) async
    test('test patientBookingReschedule', () async {
      // TODO
    });

    // Reschedule Times
    //
    // P30: the dates and times this booking can move to (same rules as booking; its own place doesn't count against \"max bookings per time\").
    //
    //Future<BookingTimesOut> patientBookingRescheduleTimes(String bookingId, { DateTime date }) async
    test('test patientBookingRescheduleTimes', () async {
      // TODO
    });

    // Booking Times
    //
    // The date strip and the time grid (P12, §6.17): every date of the booking window (greyed out when nothing is free) and the times that can be picked on `date` (default: the first date with a free time). Times are on the admin's step, inside the service hours, after the minimum notice, not blocked and not full.
    //
    //Future<BookingTimesOut> patientBookingTimes(String serviceId, { DateTime date }) async
    test('test patientBookingTimes', () async {
      // TODO
    });

    // Accept Consents
    //
    // Record the terms, privacy and health-data consents with version, time and IP (§12).
    //
    //Future<OkOut> patientConsentsAccept(ConsentsIn consentsIn) async
    test('test patientConsentsAccept', () async {
      // TODO
    });

    // Delete Account
    //
    // Delete my account (P27). You are logged out on every phone now; your personal data (profile, family, addresses, documents) is removed after `dueAt`. Logging in again before then keeps the account. Payment records are kept, as the law requires.
    //
    //Future<DeletionRequestOut> patientDeleteAccount() async
    test('test patientDeleteAccount', () async {
      // TODO
    });

    // Register Device
    //
    // Save this phone (and its push token, once Firebase is set up) for notifications.
    //
    //Future<OkOut> patientDeviceRegister(DeviceIn deviceIn) async
    test('test patientDeviceRegister', () async {
      // TODO
    });

    // Doctor Detail
    //
    // P09: photo, speciality, hospitals, OPD days.
    //
    //Future<PatientDoctorOut> patientDoctorGet(String doctorId) async
    test('test patientDoctorGet', () async {
      // TODO
    });

    // Doctors
    //
    // P08: active doctors by name. `q` matches the name or the speciality.
    //
    //Future<PagedPatientDoctorOut> patientDoctorList({ String q, String specialityId, String hospitalId, int page, int pageSize }) async
    test('test patientDoctorList', () async {
      // TODO
    });

    // Add Document
    //
    // Save an uploaded file under a family member (or yourself).
    //
    //Future<PatientDocumentOut> patientDocumentAdd(PatientDocumentIn patientDocumentIn) async
    test('test patientDocumentAdd', () async {
      // TODO
    });

    // Delete Document
    //
    //Future<OkOut> patientDocumentDelete(String documentId) async
    test('test patientDocumentDelete', () async {
      // TODO
    });

    // List Documents
    //
    // Your documents, newest first (P21): filter by family member, type or tab.
    //
    //Future<PagedPatientDocumentOut> patientDocumentList({ String memberId, String type, String group, int page, int pageSize }) async
    test('test patientDocumentList', () async {
      // TODO
    });

    // Storage
    //
    // How much of the 200 MB is used.
    //
    //Future<DocumentStorageOut> patientDocumentStorage() async
    test('test patientDocumentStorage', () async {
      // TODO
    });

    // Upload Url
    //
    // Step 1 of an upload: PUT the file to `uploadUrl`, then save it with `fileKey`.
    //
    //Future<UploadUrlOut> patientDocumentUploadUrl(DocumentUploadUrlIn documentUploadUrlIn) async
    test('test patientDocumentUploadUrl', () async {
      // TODO
    });

    // View Url
    //
    // A link to open the file (works for 5 minutes).
    //
    //Future<ViewUrlOut> patientDocumentViewUrl(String documentId) async
    test('test patientDocumentViewUrl', () async {
      // TODO
    });

    // Hospital Detail
    //
    // P07: address, map pin, OPD hours, departments and its doctors.
    //
    //Future<PatientHospitalDetailOut> patientHospitalGet(String hospitalId) async
    test('test patientHospitalGet', () async {
      // TODO
    });

    // Nearby
    //
    // P06: hospitals within 10 km of `lat`/`lng` (the phone's location or a saved address), closest first, widened to 25 km if fewer than 5 are found. Without a location: every active hospital by name. `q` matches the hospital, the city or a doctor's name.
    //
    //Future<NearbyHospitalsOut> patientHospitalsNearby({ String lat, String lng, String radiusKm, String specialityId, String q }) async
    test('test patientHospitalsNearby', () async {
      // TODO
    });

    // Get Me
    //
    //Future<PatientMeOut> patientMeGet() async
    test('test patientMeGet', () async {
      // TODO
    });

    // Update Me
    //
    // Profile setup (P04): name, date of birth, gender, language. Updates the SELF member too.
    //
    //Future<PatientMeOut> patientMeUpdate(PatientMeIn patientMeIn) async
    test('test patientMeUpdate', () async {
      // TODO
    });

    // Add Member
    //
    // Add a family member (P28). Up to 10 (a setting); the consent tick is required.
    //
    //Future<MemberOut> patientMemberAdd(MemberIn memberIn) async
    test('test patientMemberAdd', () async {
      // TODO
    });

    // Get Member
    //
    //Future<MemberDetailOut> patientMemberGet(String memberId) async
    test('test patientMemberGet', () async {
      // TODO
    });

    // List Members
    //
    // You and your family members (P22): yourself first.
    //
    //Future<List<MemberOut>> patientMemberList() async
    test('test patientMemberList', () async {
      // TODO
    });

    // Photo Upload Url
    //
    // Step 1 of a member photo: PUT it to `uploadUrl`, then save the member with `fileKey`.
    //
    //Future<UploadUrlOut> patientMemberPhotoUploadUrl(MemberPhotoUrlIn memberPhotoUrlIn) async
    test('test patientMemberPhotoUploadUrl', () async {
      // TODO
    });

    // Remove Member
    //
    // Remove a family member: hidden from the app, past bookings keep their history. `deleteDocuments=true` also deletes their medical documents (otherwise they are kept for past bookings and no longer count towards the 200 MB).
    //
    //Future<OkOut> patientMemberRemove(String memberId, { bool deleteDocuments }) async
    test('test patientMemberRemove', () async {
      // TODO
    });

    // Update Member
    //
    // Edit a member. Changes apply to future bookings only (each booking keeps a copy).
    //
    //Future<MemberOut> patientMemberUpdate(String memberId, MemberIn memberIn) async
    test('test patientMemberUpdate', () async {
      // TODO
    });

    // List Notifications
    //
    // Newest first. `data.bookingId` opens that booking.
    //
    //Future<PagedNotificationOut> patientNotificationsList({ int page, int pageSize }) async
    test('test patientNotificationsList', () async {
      // TODO
    });

    // Mark Read
    //
    //Future<UnreadCountOut> patientNotificationsRead(MarkReadIn markReadIn) async
    test('test patientNotificationsRead', () async {
      // TODO
    });

    // Unread Count
    //
    // The number on the bell.
    //
    //Future<UnreadCountOut> patientNotificationsUnread() async
    test('test patientNotificationsUnread', () async {
      // TODO
    });

    // Verify
    //
    // What Razorpay Checkout returned. Returns the booking: `NEW` once Razorpay confirms the money, else still `PENDING_PAYMENT` (show \"processing\": the webhook finishes it). 422 INVALID_SIGNATURE if the signature doesn't match.
    //
    //Future<BookingDetailOut> patientPaymentVerify(VerifyIn verifyIn) async
    test('test patientPaymentVerify', () async {
      // TODO
    });

    // Report Problem
    //
    // Within 24 h after the visit (409 REPORT_TOO_LATE): a ticket for the admins.
    //
    //Future<TicketOut> patientReportProblem(String bookingId, ReportIn reportIn) async
    test('test patientReportProblem', () async {
      // TODO
    });

    // Review
    //
    // Once, after Completed. 409 NOT_REVIEWABLE / ALREADY_REVIEWED.
    //
    //Future<ReviewOut> patientReview(String bookingId, ReviewIn reviewIn) async
    test('test patientReview', () async {
      // TODO
    });

    // Share Link
    //
    // A secret link to the live trip for someone without the app (ends with the visit).
    //
    //Future<ShareLinkOut> patientShareLink(String bookingId) async
    test('test patientShareLink', () async {
      // TODO
    });

    // Sos
    //
    // The admins' alarm + SMS to your and the member's emergency contacts. 409 NOT_IN_PROGRESS.
    //
    //Future<SosOut> patientSos(String bookingId, SosIn sosIn) async
    test('test patientSos', () async {
      // TODO
    });

  });
}
