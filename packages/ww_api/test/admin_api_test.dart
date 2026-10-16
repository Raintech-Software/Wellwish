import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for AdminApi
void main() {
  final instance = WwApi().getAdminApi();

  group(AdminApi, () {
    // List Deletions
    //
    // \"Delete my account\" requests, newest first: waiting (the patient can still log in to cancel), cancelled, or done. Only the phone's last 4 digits are kept.
    //
    //Future<PagedAccountDeletionOut> adminAccountDeletionsList({ String status, int page, int pageSize }) async
    test('test adminAccountDeletionsList', () async {
      // TODO
    });

    // Acknowledge
    //
    //Future<AlertOut> adminAlertAck(String alertId) async
    test('test adminAlertAck', () async {
      // TODO
    });

    // Alerts
    //
    // 2 minutes without an answer, declined, past the deadline, the visit's alerts: newest first.
    //
    //Future<PagedAlertOut> adminAlertsList({ bool open, List<String> kind, int page, int pageSize }) async
    test('test adminAlertsList', () async {
      // TODO
    });

    // Approve
    //
    // Every required document approved and none waiting → the partner is APPROVED.
    //
    //Future<ApplicationDetailOut> adminApplicationApprove(String applicationId) async
    test('test adminApplicationApprove', () async {
      // TODO
    });

    // Claim
    //
    // Open for review: locked to you for 30 minutes (409 CLAIMED_BY_OTHER otherwise).
    //
    //Future<ApplicationDetailOut> adminApplicationClaim(String applicationId) async
    test('test adminApplicationClaim', () async {
      // TODO
    });

    // Get Application
    //
    //Future<ApplicationDetailOut> adminApplicationGet(String applicationId) async
    test('test adminApplicationGet', () async {
      // TODO
    });

    // Reject
    //
    // Final: not eligible.
    //
    //Future<ApplicationDetailOut> adminApplicationReject(String applicationId, ReasonIn reasonIn) async
    test('test adminApplicationReject', () async {
      // TODO
    });

    // Release
    //
    //Future<OkOut> adminApplicationRelease(String applicationId) async
    test('test adminApplicationRelease', () async {
      // TODO
    });

    // Request Changes
    //
    // The partner sees the reason for each rejected document (and this note).
    //
    //Future<ApplicationDetailOut> adminApplicationRequestChanges(String applicationId, NoteIn noteIn) async
    test('test adminApplicationRequestChanges', () async {
      // TODO
    });

    // List Applications
    //
    // Oldest first. Default: submitted and under review.
    //
    //Future<List<ApplicationRowOut>> adminApplicationsList({ String status, String role }) async
    test('test adminApplicationsList', () async {
      // TODO
    });

    // Export Audit Log
    //
    // CSV of the filtered log (newest first, at most 10,000 rows). The export is logged too.
    //
    //Future<String> adminAuditLogExport({ String staffId, String action, String entityType, String entityId, DateTime from, DateTime to }) async
    test('test adminAuditLogExport', () async {
      // TODO
    });

    // Audit Filters
    //
    //Future<AuditFiltersOut> adminAuditLogFilters() async
    test('test adminAuditLogFilters', () async {
      // TODO
    });

    // List Audit Log
    //
    // Newest first, 20 a page.
    //
    //Future<PagedAuditEntryOut> adminAuditLogList({ String staffId, String action, String entityType, String entityId, DateTime from, DateTime to, int page, int pageSize }) async
    test('test adminAuditLogList', () async {
      // TODO
    });

    // Email Code
    //
    // Phone lost or not at hand (v2.18): a 6-digit code to the admin's work email, typed in the same box as the authenticator code (`/auth/totp` with the challenge returned here). 429 EMAIL_CODE_TOO_SOON {retryAfterSeconds} / EMAIL_CODE_RATE_LIMITED; 401 LOGIN_EXPIRED.
    //
    //Future<StaffEmailCodeOut> adminAuthEmailCode(StaffEmailCodeIn staffEmailCodeIn) async
    test('test adminAuthEmailCode', () async {
      // TODO
    });

    // Login
    //
    // Step 1: email + password. Then ask for the authenticator code (first time: show the QR). In a browser the admin trusted (v2.16), signed in at once (`SIGNED_IN`).
    //
    //Future<StaffLoginOut> adminAuthLogin(StaffLoginIn staffLoginIn) async
    test('test adminAuthLogin', () async {
      // TODO
    });

    // Logout
    //
    //Future<OkOut> adminAuthLogout() async
    test('test adminAuthLogout', () async {
      // TODO
    });

    // Recovery
    //
    // Lost phone (v2.16): a recovery code instead of the 2FA code. Answers TOTP_SETUP: scan the new QR code on the new phone (the old authenticator stops working). 401 RECOVERY_CODE_INVALID; wrong codes count like wrong 2FA codes.
    //
    //Future<StaffLoginOut> adminAuthRecovery(StaffRecoveryIn staffRecoveryIn) async
    test('test adminAuthRecovery', () async {
      // TODO
    });

    // Refresh
    //
    // New access token from the refresh cookie (12 h from sign-in, 30-min idle logout).
    //
    //Future<StaffTokenOut> adminAuthRefresh() async
    test('test adminAuthRefresh', () async {
      // TODO
    });

    // Totp
    //
    // Step 2: the 6-digit authenticator code. Sets the refresh cookie (and the trusted-browser cookie when asked). Right after 2FA was set up, the answer has the 10 recovery codes.
    //
    //Future<StaffTokenOut> adminAuthTotp(StaffTotpIn staffTotpIn) async
    test('test adminAuthTotp', () async {
      // TODO
    });

    // Create Blocked
    //
    // The answer lists the existing bookings inside the range, so the admin can move them.
    //
    //Future<BlockedTimeOut> adminBlockedTimesCreate(BlockedTimeIn blockedTimeIn) async
    test('test adminBlockedTimesCreate', () async {
      // TODO
    });

    // Delete Blocked
    //
    //Future<OkOut> adminBlockedTimesDelete(String blockedId) async
    test('test adminBlockedTimesDelete', () async {
      // TODO
    });

    // List Blocked
    //
    //Future<List<BlockedTimeOut>> adminBlockedTimesList({ bool upcoming }) async
    test('test adminBlockedTimesList', () async {
      // TODO
    });

    // Update Blocked
    //
    //Future<BlockedTimeOut> adminBlockedTimesUpdate(String blockedId, BlockedTimeIn blockedTimeIn) async
    test('test adminBlockedTimesUpdate', () async {
      // TODO
    });

    // Accept By Phone
    //
    // The offered partner agreed on the phone (§6.10). Logged with the note.
    //
    //Future<AssignmentStateOut> adminBookingAcceptByPhone(String bookingId, AdminNoteIn adminNoteIn) async
    test('test adminBookingAcceptByPhone', () async {
      // TODO
    });

    // Assign
    //
    // Offer the booking to a partner (reassigning withdraws the open offer). 409 PARTNER_BUSY / PARTNER_NOT_ELIGIBLE / NOT_ASSIGNABLE / OFFER_CHANGED (another admin).
    //
    //Future<AssignmentStateOut> adminBookingAssign(String bookingId, AssignIn assignIn) async
    test('test adminBookingAssign', () async {
      // TODO
    });

    // Assignment
    //
    // The booking page's assignment card (2-minute countdown, partner, offers, alerts).
    //
    //Future<AssignmentStateOut> adminBookingAssignment(String bookingId) async
    test('test adminBookingAssignment', () async {
      // TODO
    });

    // Cancel Booking
    //
    // Cancel with a reason and a refund % of the booking fee (patient asked: 50 by default; no partner available or WellWish's side: 100). Refunds above the approval limit (setting `refund_approval_above_paise`) wait for Finance. Logged.
    //
    //Future<AdminBookingDetailOut> adminBookingCancel(String bookingId, AdminCancelIn adminCancelIn) async
    test('test adminBookingCancel', () async {
      // TODO
    });

    // Candidates
    //
    // §6.10 suggestion list: approved partners of the booking's type who are free then, available today first, then nearest. Both phone numbers for the call buttons.
    //
    //Future<List<CandidateOut>> adminBookingCandidates(String bookingId) async
    test('test adminBookingCandidates', () async {
      // TODO
    });

    // Get Booking
    //
    // Patient, member, service and price snapshot, hospital and doctor, address, documents and the timeline. Opening a document: the patient page (needs a reason, logged).
    //
    //Future<AdminBookingDetailOut> adminBookingGet(String bookingId) async
    test('test adminBookingGet', () async {
      // TODO
    });

    // List Bookings
    //
    // `when`: upcoming (default: from today on and unfinished ones, soonest first), today, tomorrow, later, past (latest first), India dates. Without `status`, unpaid and expired bookings are left out (a booking code finds them). `date`: one pickup date. `type`: companion or nurse services. `q`: booking code (WW-10001), a phone (the patient's or the member's, 4+ digits) or the member's name. `temporary`: only bookings with (or without) a temporary partner (§6.19).
    //
    //Future<PagedAdminBookingRowOut> adminBookingList({ String status, DateTime date, String type, String when_, String q, bool temporary, int page, int pageSize }) async
    test('test adminBookingList', () async {
      // TODO
    });

    // Reschedule Booking
    //
    // Change the date or time for the patient (any time before the job starts, also inside the minimum notice; not counted against the patient's changes). Logged.
    //
    //Future<AdminBookingDetailOut> adminBookingReschedule(String bookingId, RescheduleIn rescheduleIn) async
    test('test adminBookingReschedule', () async {
      // TODO
    });

    // Mark Step
    //
    // Mark the next step for the partner (§6.11: no network at the door, wrong visit codes, the phone died), after confirming by phone. No OTP needed. Logged with the reason.
    //
    //Future<AdminBookingDetailOut> adminBookingStep(String bookingId, AdminStepIn adminStepIn) async
    test('test adminBookingStep', () async {
      // TODO
    });

    // Temporary Assign
    //
    // Nobody free (§6.19): a person the admin phoned and ID-checked gets this booking, accepted at once. 409 PHONE_IS_PARTNER {status} / TEMP_PARTNER_BUSY / TEMP_PARTNER_IS_FAMILY / NOT_ASSIGNABLE / OFFER_CHANGED; 422 ID_NOT_CHECKED / INVALID_PHONE / INVALID_ID_LAST4 / NURSING_REG_REQUIRED / FILE_NOT_FOUND. Logged with the reason.
    //
    //Future<AssignmentStateOut> adminBookingTemporaryAssign(String bookingId, TemporaryAssignIn temporaryAssignIn) async
    test('test adminBookingTemporaryAssign', () async {
      // TODO
    });

    // Temporary End
    //
    // End the temporary partner's app access now (§6.19), e.g. a problem during the visit. Logged out at once; a job not finished is flagged PARTNER_UNAVAILABLE. 409 NOT_TEMPORARY: no temporary partner with access on this booking.
    //
    //Future<AssignmentStateOut> adminBookingTemporaryEnd(String bookingId, TemporaryEndIn temporaryEndIn) async
    test('test adminBookingTemporaryEnd', () async {
      // TODO
    });

    // Temporary Id Photo
    //
    // A 5-minute link to the temporary partner's ID photo, for those who see partner documents or assign bookings (not view-only roles). Every view is logged (`temporary.id_viewed`), like partner documents (§6.3).
    //
    //Future<FileLinkOut> adminBookingTemporaryIdPhoto(String bookingId) async
    test('test adminBookingTemporaryIdPhoto', () async {
      // TODO
    });

    // Temporary Partner
    //
    // The ID card of the booking's temporary partner (§6.19). 404: none.
    //
    //Future<TemporaryPartnerOut> adminBookingTemporaryPartner(String bookingId) async
    test('test adminBookingTemporaryPartner', () async {
      // TODO
    });

    // Track
    //
    // The route saved when the job ended (404 before that).
    //
    //Future<TrackOut> adminBookingTrack(String bookingId) async
    test('test adminBookingTrack', () async {
      // TODO
    });

    // Unassign
    //
    // Withdraw the offer, or take the job from an accepted partner (they called): back to the queue. Logged with the reason.
    //
    //Future<AssignmentStateOut> adminBookingUnassign(String bookingId, AdminNoteIn adminNoteIn) async
    test('test adminBookingUnassign', () async {
      // TODO
    });

    // Bookings Report
    //
    // Paid bookings by visit date (India) and by service: booked, completed, cancelled, patient not available, not finished. Default: this month so far.
    //
    //Future<BookingsReportOut> adminBookingsReport({ DateTime from, DateTime to }) async
    test('test adminBookingsReport', () async {
      // TODO
    });

    // Bookings Report Csv
    //
    // The bookings report as a CSV file (by date, then by service). Logged.
    //
    //Future<String> adminBookingsReportCsv({ DateTime from, DateTime to }) async
    test('test adminBookingsReportCsv', () async {
      // TODO
    });

    // Cancellations Report
    //
    // Bookings cancelled on these dates (who, why, the refund %) and refunds asked for other bookings, with the fee paid and what was refunded. Default: this month so far.
    //
    //Future<CancellationsReportOut> adminCancellationsReport({ DateTime from, DateTime to }) async
    test('test adminCancellationsReport', () async {
      // TODO
    });

    // Cancellations Report Csv
    //
    // The cancellations and refunds report as a CSV file. Logged.
    //
    //Future<String> adminCancellationsReportCsv({ DateTime from, DateTime to }) async
    test('test adminCancellationsReportCsv', () async {
      // TODO
    });

    // Dashboard
    //
    //Future<DashboardOut> adminDashboard() async
    test('test adminDashboard', () async {
      // TODO
    });

    // Dev Outbox
    //
    // The last 50 SMS (login codes, visit codes, SOS…) and emails of the last hour, newest first, as the dev backends kept them: MSG91 and SES aren't used on a developer's PC. 404 on any real server (they send for real and keep nothing).
    //
    //Future<DevOutboxOut> adminDevOutbox() async
    test('test adminDevOutbox', () async {
      // TODO
    });

    // Activate Doctor
    //
    //Future<DoctorOut> adminDoctorsActivate(String doctorId) async
    test('test adminDoctorsActivate', () async {
      // TODO
    });

    // Create Doctor
    //
    //Future<DoctorOut> adminDoctorsCreate(DoctorIn doctorIn) async
    test('test adminDoctorsCreate', () async {
      // TODO
    });

    // Deactivate Doctor
    //
    //Future<DoctorOut> adminDoctorsDeactivate(String doctorId) async
    test('test adminDoctorsDeactivate', () async {
      // TODO
    });

    // Delete Doctor
    //
    // Refused (409 IN_USE) once the doctor is used in a booking.
    //
    //Future<OkOut> adminDoctorsDelete(String doctorId) async
    test('test adminDoctorsDelete', () async {
      // TODO
    });

    // List Doctors
    //
    //Future<List<DoctorOut>> adminDoctorsList({ String q, String specialityId, String hospitalId }) async
    test('test adminDoctorsList', () async {
      // TODO
    });

    // Update Doctor
    //
    //Future<DoctorOut> adminDoctorsUpdate(String doctorId, DoctorIn doctorIn) async
    test('test adminDoctorsUpdate', () async {
      // TODO
    });

    // Fee Report
    //
    // CSV of booking fees per India date: payments, collected, refunded, net (in ₹). Default: this month so far. Logged.
    //
    //Future<String> adminFeeReport({ DateTime from, DateTime to }) async
    test('test adminFeeReport', () async {
      // TODO
    });

    // Fee Report Days
    //
    // The fee report on screen (9.2): the same days as the CSV, in paise. Not logged (no file leaves the panel).
    //
    //Future<FeeReportOut> adminFeeReportDays({ DateTime from, DateTime to }) async
    test('test adminFeeReportDays', () async {
      // TODO
    });

    // Upload Url
    //
    // Step 1 of an upload: get a short-lived URL to PUT the file to.
    //
    //Future<UploadUrlOut> adminFilesUploadUrl(UploadUrlIn uploadUrlIn) async
    test('test adminFilesUploadUrl', () async {
      // TODO
    });

    // Activate Hospital
    //
    //Future<HospitalOut> adminHospitalsActivate(String hospitalId) async
    test('test adminHospitalsActivate', () async {
      // TODO
    });

    // Create Hospital
    //
    //Future<HospitalOut> adminHospitalsCreate(HospitalIn hospitalIn) async
    test('test adminHospitalsCreate', () async {
      // TODO
    });

    // Deactivate Hospital
    //
    //Future<HospitalOut> adminHospitalsDeactivate(String hospitalId) async
    test('test adminHospitalsDeactivate', () async {
      // TODO
    });

    // Delete Hospital
    //
    // Refused (409 IN_USE) if used in a booking or doctors are listed there.
    //
    //Future<OkOut> adminHospitalsDelete(String hospitalId) async
    test('test adminHospitalsDelete', () async {
      // TODO
    });

    // List Hospitals
    //
    //Future<List<HospitalOut>> adminHospitalsList({ String q }) async
    test('test adminHospitalsList', () async {
      // TODO
    });

    // Update Hospital
    //
    //Future<HospitalOut> adminHospitalsUpdate(String hospitalId, HospitalIn hospitalIn) async
    test('test adminHospitalsUpdate', () async {
      // TODO
    });

    // Legal Get
    //
    // The newest version, to edit.
    //
    //Future<LegalDocumentOut> adminLegalGet(String kind) async
    test('test adminLegalGet', () async {
      // TODO
    });

    // Legal List
    //
    //Future<List<LegalSummaryOut>> adminLegalList() async
    test('test adminLegalList', () async {
      // TODO
    });

    // Legal Publish
    //
    // Publish a new version: a small fix (nobody is asked again) or `askAgain` (everyone accepts it again at their next app open). Logged.
    //
    //Future<LegalDocumentOut> adminLegalPublish(String kind, LegalPublishIn legalPublishIn) async
    test('test adminLegalPublish', () async {
      // TODO
    });

    // Legal Version
    //
    // An old version, read-only (which text someone accepted).
    //
    //Future<LegalDocumentOut> adminLegalVersion(String kind, int version) async
    test('test adminLegalVersion', () async {
      // TODO
    });

    // Legal Versions
    //
    //Future<List<LegalVersionOut>> adminLegalVersions(String kind) async
    test('test adminLegalVersions', () async {
      // TODO
    });

    // Live
    //
    // Every job in progress with the partner's latest point (`stale`: none for 2 minutes).
    //
    //Future<List<LiveJobOut>> adminLiveJobs() async
    test('test adminLiveJobs', () async {
      // TODO
    });

    // Me
    //
    // The signed-in staff member and their permissions (the panel builds its menu from them).
    //
    //Future<StaffMeOut> adminMeGet() async
    test('test adminMeGet', () async {
      // TODO
    });

    // Deactivate
    //
    // The partner left or was removed. Their history stays.
    //
    //Future<PartnerDetailOut> adminPartnerDeactivate(String partnerId, ReasonIn reasonIn) async
    test('test adminPartnerDeactivate', () async {
      // TODO
    });

    // Document Approve
    //
    //Future<DocumentOut> adminPartnerDocumentApprove(String documentId) async
    test('test adminPartnerDocumentApprove', () async {
      // TODO
    });

    // Document Reject
    //
    // The reason is shown to the partner.
    //
    //Future<DocumentOut> adminPartnerDocumentReject(String documentId, RejectDocumentIn rejectDocumentIn) async
    test('test adminPartnerDocumentReject', () async {
      // TODO
    });

    // Document View
    //
    // A 5-minute link. Every view is in the audit log.
    //
    //Future<ViewUrlOut> adminPartnerDocumentView(String documentId) async
    test('test adminPartnerDocumentView', () async {
      // TODO
    });

    // Force Logout
    //
    //Future<OkOut> adminPartnerForceLogout(String partnerId) async
    test('test adminPartnerForceLogout', () async {
      // TODO
    });

    // Get Partner
    //
    // Profile, both phones, email, documents (with history), application and status history.
    //
    //Future<PartnerDetailOut> adminPartnerGet(String partnerId) async
    test('test adminPartnerGet', () async {
      // TODO
    });

    // Partner Performance
    //
    // Each approved partner (and anyone else with work then): jobs done, patient not available, offers received / accepted / declined / not answered, acceptance %, rating. Default: this month so far.
    //
    //Future<PartnerPerformanceOut> adminPartnerPerformanceReport({ DateTime from, DateTime to }) async
    test('test adminPartnerPerformanceReport', () async {
      // TODO
    });

    // Partner Performance Csv
    //
    // The partner performance report as a CSV file. Logged.
    //
    //Future<String> adminPartnerPerformanceReportCsv({ DateTime from, DateTime to }) async
    test('test adminPartnerPerformanceReportCsv', () async {
      // TODO
    });

    // Reinstate
    //
    //Future<PartnerDetailOut> adminPartnerReinstate(String partnerId) async
    test('test adminPartnerReinstate', () async {
      // TODO
    });

    // Suspend
    //
    // Logged out at once on their phone.
    //
    //Future<PartnerDetailOut> adminPartnerSuspend(String partnerId, ReasonIn reasonIn) async
    test('test adminPartnerSuspend', () async {
      // TODO
    });

    // Update Partner
    //
    //Future<PartnerDetailOut> adminPartnerUpdate(String partnerId, PartnerEditIn partnerEditIn) async
    test('test adminPartnerUpdate', () async {
      // TODO
    });

    // Add Partner
    //
    // Saved APPROVED. Upload the photo and documents first (`/admin/files/upload-url`).
    //
    //Future<PartnerProfileOut> adminPartnersAdd(AddPartnerIn addPartnerIn) async
    test('test adminPartnersAdd', () async {
      // TODO
    });

    // List Partners
    //
    // Newest first. `toReview` = approved partners with an upload waiting (renewals).
    //
    //Future<PagedPartnerRowOut> adminPartnersList({ String role, String status, bool available, String q, bool toReview, int page, int pageSize }) async
    test('test adminPartnersList', () async {
      // TODO
    });

    // Block
    //
    // Abuse (§9.1): logged out of the patient app on every phone at once and its login refused (\"This account is blocked\") until unblocked. The partner app is not touched. Logged.
    //
    //Future<PatientDetailOut> adminPatientBlock(String userId, PatientReasonIn patientReasonIn) async
    test('test adminPatientBlock', () async {
      // TODO
    });

    // View Document
    //
    // Open a patient's document: a reason is required and the view is audit-logged (§9.1).
    //
    //Future<ViewUrlOut> adminPatientDocumentViewUrl(String userId, String documentId, DocumentReasonIn documentReasonIn) async
    test('test adminPatientDocumentViewUrl', () async {
      // TODO
    });

    // Get Patient
    //
    // The account, its family members (removed ones too), addresses and, for roles that may open them, documents (titles only). Payments are added in Phase 6.
    //
    //Future<PatientDetailOut> adminPatientGet(String userId) async
    test('test adminPatientGet', () async {
      // TODO
    });

    // Request Deletion
    //
    // A patient who asks by phone to delete their account: the same as in the app (409 ACTIVE_BOOKINGS while a paid booking isn't finished; logged out at once; erased after the waiting time unless they log in again). Logged.
    //
    //Future<PatientDetailOut> adminPatientRequestDeletion(String userId, PatientReasonIn patientReasonIn) async
    test('test adminPatientRequestDeletion', () async {
      // TODO
    });

    // Unblock
    //
    //Future<PatientDetailOut> adminPatientUnblock(String userId, PatientReasonIn patientReasonIn) async
    test('test adminPatientUnblock', () async {
      // TODO
    });

    // Update
    //
    // Only on the patient's request (§9.1): name, date of birth, gender, app language (the profile screen's details; the phone number is the login and can't change here). Logged with the reason and what changed.
    //
    //Future<PatientDetailOut> adminPatientUpdate(String userId, AdminPatientIn adminPatientIn) async
    test('test adminPatientUpdate', () async {
      // TODO
    });

    // List Patients
    //
    // Newest first. `q`: name, or at least 4 digits of the phone.
    //
    //Future<PagedPatientRowOut> adminPatientsList({ String q, int page, int pageSize }) async
    test('test adminPatientsList', () async {
      // TODO
    });

    // Get Keys
    //
    // Which Razorpay keys are in use (secrets never shown, only their last 4 characters).
    //
    //Future<GatewayKeysOut> adminPaymentKeysGet() async
    test('test adminPaymentKeysGet', () async {
      // TODO
    });

    // Save Keys
    //
    // Save the Razorpay key id and secrets (stored encrypted; blank secret = keep the saved one; a new key id needs its secret). Logged without the values.
    //
    //Future<GatewayKeysOut> adminPaymentKeysSave(GatewayKeysIn gatewayKeysIn) async
    test('test adminPaymentKeysSave', () async {
      // TODO
    });

    // List Payments
    //
    // Booking-fee payments, newest first. `q`: booking code, Razorpay order or payment id.
    //
    //Future<PagedAdminPaymentOut> adminPaymentList({ String status, String q, int page, int pageSize }) async
    test('test adminPaymentList', () async {
      // TODO
    });

    // Queue Counts
    //
    //Future<QueueCountsOut> adminQueueCounts() async
    test('test adminQueueCounts', () async {
      // TODO
    });

    // Queue
    //
    // Paid bookings without a partner yet (NEW, or OFFERED and waiting), soonest first. `late` = past the assign deadline (red).
    //
    //Future<PagedQueueRowOut> adminQueueList({ String when_, int page, int pageSize }) async
    test('test adminQueueList', () async {
      // TODO
    });

    // Recovery Codes
    //
    // 10 new recovery codes, shown once; the old ones stop working (v2.16). Needs the password (422 WRONG_PASSWORD).
    //
    //Future<RecoveryCodesOut> adminRecoveryCodesCreate(RecoveryCodesIn recoveryCodesIn) async
    test('test adminRecoveryCodesCreate', () async {
      // TODO
    });

    // Recovery Codes Saved
    //
    // The admin says \"I've saved them\" after the codes were shown (at 2FA setup, or new ones). Until then `/me` has `recoveryCodesSaved: false` and the panel warns.
    //
    //Future<StaffMeOut> adminRecoveryCodesSaved() async
    test('test adminRecoveryCodesSaved', () async {
      // TODO
    });

    // Approve Refund
    //
    // Finance approves a refund above the limit: it is sent to Razorpay (logged).
    //
    //Future<AdminRefundOut> adminRefundApprove(String refundId, RefundDecisionIn refundDecisionIn) async
    test('test adminRefundApprove', () async {
      // TODO
    });

    // List Refunds
    //
    // Refunds, newest first. AWAITING_APPROVAL: above the limit, waiting for Finance.
    //
    //Future<PagedAdminRefundOut> adminRefundList({ String status, int page, int pageSize }) async
    test('test adminRefundList', () async {
      // TODO
    });

    // Reject Refund
    //
    // Finance refuses a refund above the limit, with a reason (logged).
    //
    //Future<AdminRefundOut> adminRefundReject(String refundId, RefundDecisionIn refundDecisionIn) async
    test('test adminRefundReject', () async {
      // TODO
    });

    // Retry Refund
    //
    // A refund Razorpay refused or failed: send it again, with a note (logged).
    //
    //Future<AdminRefundOut> adminRefundRetry(String refundId, RefundDecisionIn refundDecisionIn) async
    test('test adminRefundRetry', () async {
      // TODO
    });

    // Create Required
    //
    //Future<RequiredDocumentOut> adminRequiredDocumentsCreate(RequiredDocumentIn requiredDocumentIn) async
    test('test adminRequiredDocumentsCreate', () async {
      // TODO
    });

    // Delete Required
    //
    // Refused (409 IN_USE) once partners uploaded it: turn it off instead.
    //
    //Future<OkOut> adminRequiredDocumentsDelete(String requiredId) async
    test('test adminRequiredDocumentsDelete', () async {
      // TODO
    });

    // List Required
    //
    //Future<List<RequiredDocumentOut>> adminRequiredDocumentsList() async
    test('test adminRequiredDocumentsList', () async {
      // TODO
    });

    // Update Required
    //
    // Role and type can't change (add a new row instead).
    //
    //Future<RequiredDocumentOut> adminRequiredDocumentsUpdate(String requiredId, RequiredDocumentIn requiredDocumentIn) async
    test('test adminRequiredDocumentsUpdate', () async {
      // TODO
    });

    // Hide
    //
    // Hidden, never deleted; the partner's average leaves it out.
    //
    //Future<AdminReviewOut> adminReviewHide(String reviewId, ReviewModerateIn reviewModerateIn) async
    test('test adminReviewHide', () async {
      // TODO
    });

    // Show
    //
    //Future<AdminReviewOut> adminReviewShow(String reviewId, ReviewModerateIn reviewModerateIn) async
    test('test adminReviewShow', () async {
      // TODO
    });

    // Reviews
    //
    //Future<PagedAdminReviewOut> adminReviews({ String status, int page, int pageSize }) async
    test('test adminReviews', () async {
      // TODO
    });

    // Roles
    //
    // The five admin roles and what each can do (§9.2). Read-only.
    //
    //Future<RolesOut> adminRolesList() async
    test('test adminRolesList', () async {
      // TODO
    });

    // List Selfies
    //
    // Spot checks (§6.15): the day's selfies (India date, today by default), newest first, next to each partner's approved photo.
    //
    //Future<PagedAdminSelfieOut> adminSelfiesList({ DateTime date, String partnerId, int page, int pageSize }) async
    test('test adminSelfiesList', () async {
      // TODO
    });

    // Activate Area
    //
    //Future<ServiceAreaOut> adminServiceAreasActivate(String areaId) async
    test('test adminServiceAreasActivate', () async {
      // TODO
    });

    // Check Point
    //
    // Is this point inside an active service area? (bookings outside are refused)
    //
    //Future<InsideAreaOut> adminServiceAreasCheck(num lat, num lng) async
    test('test adminServiceAreasCheck', () async {
      // TODO
    });

    // Create Area
    //
    //Future<ServiceAreaOut> adminServiceAreasCreate(ServiceAreaIn serviceAreaIn) async
    test('test adminServiceAreasCreate', () async {
      // TODO
    });

    // Deactivate Area
    //
    //Future<ServiceAreaOut> adminServiceAreasDeactivate(String areaId) async
    test('test adminServiceAreasDeactivate', () async {
      // TODO
    });

    // Delete Area
    //
    //Future<OkOut> adminServiceAreasDelete(String areaId) async
    test('test adminServiceAreasDelete', () async {
      // TODO
    });

    // List Areas
    //
    //Future<List<ServiceAreaOut>> adminServiceAreasList() async
    test('test adminServiceAreasList', () async {
      // TODO
    });

    // Update Area
    //
    //Future<ServiceAreaOut> adminServiceAreasUpdate(String areaId, ServiceAreaIn serviceAreaIn) async
    test('test adminServiceAreasUpdate', () async {
      // TODO
    });

    // Activate Service
    //
    //Future<ServiceOut> adminServicesActivate(String serviceId) async
    test('test adminServicesActivate', () async {
      // TODO
    });

    // Create Service
    //
    //Future<ServiceOut> adminServicesCreate(ServiceIn serviceIn) async
    test('test adminServicesCreate', () async {
      // TODO
    });

    // Deactivate Service
    //
    //Future<ServiceOut> adminServicesDeactivate(String serviceId) async
    test('test adminServicesDeactivate', () async {
      // TODO
    });

    // Delete Service
    //
    // Refused (409 IN_USE) once the service has been booked: deactivate it instead.
    //
    //Future<OkOut> adminServicesDelete(String serviceId) async
    test('test adminServicesDelete', () async {
      // TODO
    });

    // List Services
    //
    // All services, active and inactive, in display order.
    //
    //Future<List<ServiceOut>> adminServicesList() async
    test('test adminServicesList', () async {
      // TODO
    });

    // Reorder Services
    //
    //Future<OkOut> adminServicesReorder(ReorderIn reorderIn) async
    test('test adminServicesReorder', () async {
      // TODO
    });

    // Update Service
    //
    // New prices apply to new bookings only.
    //
    //Future<ServiceOut> adminServicesUpdate(String serviceId, ServiceIn serviceIn) async
    test('test adminServicesUpdate', () async {
      // TODO
    });

    // Get Settings
    //
    //Future<SettingsOut> adminSettingsGet() async
    test('test adminSettingsGet', () async {
      // TODO
    });

    // Update Settings
    //
    // Only the keys sent are changed. 422 INVALID_SETTINGS lists the bad fields.
    //
    //Future<SettingsOut> adminSettingsUpdate(SettingsIn settingsIn) async
    test('test adminSettingsUpdate', () async {
      // TODO
    });

    // Sos Ack
    //
    //Future<AdminSosOut> adminSosAck(String sosId) async
    test('test adminSosAck', () async {
      // TODO
    });

    // Sos List
    //
    // `active`: open and acknowledged (newest first); `all` includes resolved ones.
    //
    //Future<PagedAdminSosOut> adminSosList({ String status, int page, int pageSize }) async
    test('test adminSosList', () async {
      // TODO
    });

    // Sos Resolve
    //
    //Future<AdminSosOut> adminSosResolve(String sosId, SosResolveIn sosResolveIn) async
    test('test adminSosResolve', () async {
      // TODO
    });

    // Create Speciality
    //
    //Future<SpecialityOut> adminSpecialitiesCreate(SpecialityIn specialityIn) async
    test('test adminSpecialitiesCreate', () async {
      // TODO
    });

    // Delete Speciality
    //
    // Refused (409 IN_USE) while a doctor has this speciality.
    //
    //Future<OkOut> adminSpecialitiesDelete(String specialityId) async
    test('test adminSpecialitiesDelete', () async {
      // TODO
    });

    // List Specialities
    //
    //Future<List<SpecialityOut>> adminSpecialitiesList() async
    test('test adminSpecialitiesList', () async {
      // TODO
    });

    // Update Speciality
    //
    //Future<SpecialityOut> adminSpecialitiesUpdate(String specialityId, SpecialityIn specialityIn) async
    test('test adminSpecialitiesUpdate', () async {
      // TODO
    });

    // Create Staff User
    //
    // They set up the authenticator at their first sign-in.
    //
    //Future<StaffUserOut> adminStaffUsersCreate(StaffUserCreateIn staffUserCreateIn) async
    test('test adminStaffUsersCreate', () async {
      // TODO
    });

    // Disable Staff User
    //
    // Signs them out at once. Not yourself, and not the last Super Admin.
    //
    //Future<StaffUserOut> adminStaffUsersDisable(String staffId) async
    test('test adminStaffUsersDisable', () async {
      // TODO
    });

    // Enable Staff User
    //
    //Future<StaffUserOut> adminStaffUsersEnable(String staffId) async
    test('test adminStaffUsersEnable', () async {
      // TODO
    });

    // Force Logout
    //
    // Sign them out on every device.
    //
    //Future<ForceLogoutOut> adminStaffUsersForceLogout(String staffId) async
    test('test adminStaffUsersForceLogout', () async {
      // TODO
    });

    // List Staff Users
    //
    //Future<List<StaffUserOut>> adminStaffUsersList() async
    test('test adminStaffUsersList', () async {
      // TODO
    });

    // Reset 2Fa
    //
    // Lost phone: they scan a new QR code at the next sign-in. Signs them out.
    //
    //Future<StaffUserOut> adminStaffUsersReset2fa(String staffId) async
    test('test adminStaffUsersReset2fa', () async {
      // TODO
    });

    // Set Password
    //
    // Forgotten password: set a new one (min 12 characters). Signs them out.
    //
    //Future<OkOut> adminStaffUsersSetPassword(String staffId, StaffPasswordIn staffPasswordIn) async
    test('test adminStaffUsersSetPassword', () async {
      // TODO
    });

    // Update Staff User
    //
    // Name and role. You can't change your own role; one active Super Admin must remain.
    //
    //Future<StaffUserOut> adminStaffUsersUpdate(String staffId, StaffUserUpdateIn staffUserUpdateIn) async
    test('test adminStaffUsersUpdate', () async {
      // TODO
    });

    // Close
    //
    //Future<AdminTicketOut> adminTicketClose(String ticketId) async
    test('test adminTicketClose', () async {
      // TODO
    });

    // Reply
    //
    // The family gets a message with the reply.
    //
    //Future<AdminTicketOut> adminTicketReply(String ticketId, TicketReplyIn ticketReplyIn) async
    test('test adminTicketReply', () async {
      // TODO
    });

    // Tickets
    //
    //Future<PagedAdminTicketOut> adminTickets({ String status, int page, int pageSize }) async
    test('test adminTickets', () async {
      // TODO
    });

  });
}
