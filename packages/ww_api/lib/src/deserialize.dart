import 'package:ww_api/src/model/account_deletion_out.dart';
import 'package:ww_api/src/model/add_partner_in.dart';
import 'package:ww_api/src/model/address_filter.dart';
import 'package:ww_api/src/model/address_in.dart';
import 'package:ww_api/src/model/address_out.dart';
import 'package:ww_api/src/model/admin_booking_detail_out.dart';
import 'package:ww_api/src/model/admin_booking_event_out.dart';
import 'package:ww_api/src/model/admin_booking_patient_out.dart';
import 'package:ww_api/src/model/admin_booking_row_out.dart';
import 'package:ww_api/src/model/admin_cancel_in.dart';
import 'package:ww_api/src/model/admin_member_out.dart';
import 'package:ww_api/src/model/admin_note_in.dart';
import 'package:ww_api/src/model/admin_patient_in.dart';
import 'package:ww_api/src/model/admin_payment_out.dart';
import 'package:ww_api/src/model/admin_refund_out.dart';
import 'package:ww_api/src/model/admin_review_out.dart';
import 'package:ww_api/src/model/admin_selfie_out.dart';
import 'package:ww_api/src/model/admin_sos_out.dart';
import 'package:ww_api/src/model/admin_step_in.dart';
import 'package:ww_api/src/model/admin_ticket_out.dart';
import 'package:ww_api/src/model/affected_booking_out.dart';
import 'package:ww_api/src/model/alert_count_out.dart';
import 'package:ww_api/src/model/alert_out.dart';
import 'package:ww_api/src/model/alerts_out.dart';
import 'package:ww_api/src/model/app_config_out.dart';
import 'package:ww_api/src/model/app_versions_out.dart';
import 'package:ww_api/src/model/application_detail_out.dart';
import 'package:ww_api/src/model/application_out.dart';
import 'package:ww_api/src/model/application_row_out.dart';
import 'package:ww_api/src/model/applications_out.dart';
import 'package:ww_api/src/model/assign_in.dart';
import 'package:ww_api/src/model/assigned_partner_brief_out.dart';
import 'package:ww_api/src/model/assigned_partner_out.dart';
import 'package:ww_api/src/model/assignment_state_out.dart';
import 'package:ww_api/src/model/audit_entry_out.dart';
import 'package:ww_api/src/model/audit_filters_out.dart';
import 'package:ww_api/src/model/audit_query.dart';
import 'package:ww_api/src/model/audit_staff_out.dart';
import 'package:ww_api/src/model/availability_in.dart';
import 'package:ww_api/src/model/availability_out.dart';
import 'package:ww_api/src/model/balance_in.dart';
import 'package:ww_api/src/model/balance_sum_out.dart';
import 'package:ww_api/src/model/blocked_time_in.dart';
import 'package:ww_api/src/model/blocked_time_out.dart';
import 'package:ww_api/src/model/booking_address_out.dart';
import 'package:ww_api/src/model/booking_day_out.dart';
import 'package:ww_api/src/model/booking_detail_out.dart';
import 'package:ww_api/src/model/booking_document_out.dart';
import 'package:ww_api/src/model/booking_in.dart';
import 'package:ww_api/src/model/booking_member_out.dart';
import 'package:ww_api/src/model/booking_refund_out.dart';
import 'package:ww_api/src/model/booking_row_out.dart';
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:ww_api/src/model/booking_timeline_out.dart';
import 'package:ww_api/src/model/booking_times_out.dart';
import 'package:ww_api/src/model/bookings_by_service_out.dart';
import 'package:ww_api/src/model/bookings_report_out.dart';
import 'package:ww_api/src/model/bookings_report_row_out.dart';
import 'package:ww_api/src/model/call_in.dart';
import 'package:ww_api/src/model/cancel_in.dart';
import 'package:ww_api/src/model/cancel_preview_out.dart';
import 'package:ww_api/src/model/cancellation_row_out.dart';
import 'package:ww_api/src/model/cancellations_report_out.dart';
import 'package:ww_api/src/model/candidate_out.dart';
import 'package:ww_api/src/model/checkout_out.dart';
import 'package:ww_api/src/model/code_in.dart';
import 'package:ww_api/src/model/consent_item_in.dart';
import 'package:ww_api/src/model/consent_needed_out.dart';
import 'package:ww_api/src/model/consents_in.dart';
import 'package:ww_api/src/model/dashboard_out.dart';
import 'package:ww_api/src/model/decline_in.dart';
import 'package:ww_api/src/model/deletion_request_out.dart';
import 'package:ww_api/src/model/dev_mail_out.dart';
import 'package:ww_api/src/model/dev_outbox_out.dart';
import 'package:ww_api/src/model/dev_sms_out.dart';
import 'package:ww_api/src/model/device_in.dart';
import 'package:ww_api/src/model/doc_state_out.dart';
import 'package:ww_api/src/model/doctor_in.dart';
import 'package:ww_api/src/model/doctor_out.dart';
import 'package:ww_api/src/model/document_in.dart';
import 'package:ww_api/src/model/document_link_out.dart';
import 'package:ww_api/src/model/document_out.dart';
import 'package:ww_api/src/model/document_reason_in.dart';
import 'package:ww_api/src/model/document_storage_out.dart';
import 'package:ww_api/src/model/document_upload_url_in.dart';
import 'package:ww_api/src/model/email_in.dart';
import 'package:ww_api/src/model/email_sent_out.dart';
import 'package:ww_api/src/model/fee_day_out.dart';
import 'package:ww_api/src/model/fee_report_out.dart';
import 'package:ww_api/src/model/file_link_out.dart';
import 'package:ww_api/src/model/force_logout_out.dart';
import 'package:ww_api/src/model/gateway_keys_in.dart';
import 'package:ww_api/src/model/gateway_keys_out.dart';
import 'package:ww_api/src/model/google_in.dart';
import 'package:ww_api/src/model/google_out.dart';
import 'package:ww_api/src/model/health_out.dart';
import 'package:ww_api/src/model/history_out.dart';
import 'package:ww_api/src/model/hospital_brief.dart';
import 'package:ww_api/src/model/hospital_in.dart';
import 'package:ww_api/src/model/hospital_out.dart';
import 'package:ww_api/src/model/input.dart';
import 'package:ww_api/src/model/inside_area_out.dart';
import 'package:ww_api/src/model/job_counts_out.dart';
import 'package:ww_api/src/model/job_member_out.dart';
import 'package:ww_api/src/model/kyc_status_out.dart';
import 'package:ww_api/src/model/language_in.dart';
import 'package:ww_api/src/model/legal_document_out.dart';
import 'package:ww_api/src/model/legal_publish_in.dart';
import 'package:ww_api/src/model/legal_summary_out.dart';
import 'package:ww_api/src/model/legal_urls_out.dart';
import 'package:ww_api/src/model/legal_version_out.dart';
import 'package:ww_api/src/model/live_job_out.dart';
import 'package:ww_api/src/model/live_location_out.dart';
import 'package:ww_api/src/model/mark_read_in.dart';
import 'package:ww_api/src/model/member_detail_out.dart';
import 'package:ww_api/src/model/member_in.dart';
import 'package:ww_api/src/model/member_out.dart';
import 'package:ww_api/src/model/member_photo_url_in.dart';
import 'package:ww_api/src/model/nearby_hospitals_out.dart';
import 'package:ww_api/src/model/note_in.dart';
import 'package:ww_api/src/model/notification_out.dart';
import 'package:ww_api/src/model/offer_brief_out.dart';
import 'package:ww_api/src/model/offer_out.dart';
import 'package:ww_api/src/model/offer_summary_out.dart';
import 'package:ww_api/src/model/ok_out.dart';
import 'package:ww_api/src/model/otp_send_in.dart';
import 'package:ww_api/src/model/otp_send_out.dart';
import 'package:ww_api/src/model/otp_verify_in.dart';
import 'package:ww_api/src/model/paged_account_deletion_out.dart';
import 'package:ww_api/src/model/paged_admin_booking_row_out.dart';
import 'package:ww_api/src/model/paged_admin_payment_out.dart';
import 'package:ww_api/src/model/paged_admin_refund_out.dart';
import 'package:ww_api/src/model/paged_admin_review_out.dart';
import 'package:ww_api/src/model/paged_admin_selfie_out.dart';
import 'package:ww_api/src/model/paged_admin_sos_out.dart';
import 'package:ww_api/src/model/paged_admin_ticket_out.dart';
import 'package:ww_api/src/model/paged_alert_out.dart';
import 'package:ww_api/src/model/paged_audit_entry_out.dart';
import 'package:ww_api/src/model/paged_booking_row_out.dart';
import 'package:ww_api/src/model/paged_notification_out.dart';
import 'package:ww_api/src/model/paged_partner_job_row_out.dart';
import 'package:ww_api/src/model/paged_partner_row_out.dart';
import 'package:ww_api/src/model/paged_patient_doctor_out.dart';
import 'package:ww_api/src/model/paged_patient_document_out.dart';
import 'package:ww_api/src/model/paged_patient_row_out.dart';
import 'package:ww_api/src/model/paged_queue_row_out.dart';
import 'package:ww_api/src/model/partner_deletion_out.dart';
import 'package:ww_api/src/model/partner_detail_out.dart';
import 'package:ww_api/src/model/partner_edit_in.dart';
import 'package:ww_api/src/model/partner_home_out.dart';
import 'package:ww_api/src/model/partner_job_out.dart';
import 'package:ww_api/src/model/partner_job_row_out.dart';
import 'package:ww_api/src/model/partner_me_out.dart';
import 'package:ww_api/src/model/partner_performance_out.dart';
import 'package:ww_api/src/model/partner_performance_row_out.dart';
import 'package:ww_api/src/model/partner_profile_out.dart';
import 'package:ww_api/src/model/partner_review_out.dart';
import 'package:ww_api/src/model/partner_row_out.dart';
import 'package:ww_api/src/model/partner_stats_out.dart';
import 'package:ww_api/src/model/partner_totals_out.dart';
import 'package:ww_api/src/model/partner_upload_url_in.dart';
import 'package:ww_api/src/model/patient_detail_out.dart';
import 'package:ww_api/src/model/patient_doctor_out.dart';
import 'package:ww_api/src/model/patient_document_filter.dart';
import 'package:ww_api/src/model/patient_document_in.dart';
import 'package:ww_api/src/model/patient_document_out.dart';
import 'package:ww_api/src/model/patient_hospital_detail_out.dart';
import 'package:ww_api/src/model/patient_hospital_out.dart';
import 'package:ww_api/src/model/patient_me_in.dart';
import 'package:ww_api/src/model/patient_me_out.dart';
import 'package:ww_api/src/model/patient_reason_in.dart';
import 'package:ww_api/src/model/patient_row_out.dart';
import 'package:ww_api/src/model/permission_out.dart';
import 'package:ww_api/src/model/phone_in.dart';
import 'package:ww_api/src/model/phone_out.dart';
import 'package:ww_api/src/model/place_in.dart';
import 'package:ww_api/src/model/profile_in.dart';
import 'package:ww_api/src/model/public_track_out.dart';
import 'package:ww_api/src/model/queue_counts_out.dart';
import 'package:ww_api/src/model/queue_row_out.dart';
import 'package:ww_api/src/model/reason_in.dart';
import 'package:ww_api/src/model/recovery_codes_in.dart';
import 'package:ww_api/src/model/recovery_codes_out.dart';
import 'package:ww_api/src/model/refresh_in.dart';
import 'package:ww_api/src/model/refund_decision_in.dart';
import 'package:ww_api/src/model/reject_document_in.dart';
import 'package:ww_api/src/model/reorder_in.dart';
import 'package:ww_api/src/model/report_in.dart';
import 'package:ww_api/src/model/required_document_in.dart';
import 'package:ww_api/src/model/required_document_out.dart';
import 'package:ww_api/src/model/reschedule_in.dart';
import 'package:ww_api/src/model/review_in.dart';
import 'package:ww_api/src/model/review_moderate_in.dart';
import 'package:ww_api/src/model/review_out.dart';
import 'package:ww_api/src/model/role_out.dart';
import 'package:ww_api/src/model/roles_out.dart';
import 'package:ww_api/src/model/selfie_in.dart';
import 'package:ww_api/src/model/service_area_in.dart';
import 'package:ww_api/src/model/service_area_out.dart';
import 'package:ww_api/src/model/service_in.dart';
import 'package:ww_api/src/model/service_out.dart';
import 'package:ww_api/src/model/setting_out.dart';
import 'package:ww_api/src/model/settings_group_out.dart';
import 'package:ww_api/src/model/settings_in.dart';
import 'package:ww_api/src/model/settings_out.dart';
import 'package:ww_api/src/model/share_link_out.dart';
import 'package:ww_api/src/model/sos_in.dart';
import 'package:ww_api/src/model/sos_out.dart';
import 'package:ww_api/src/model/sos_resolve_in.dart';
import 'package:ww_api/src/model/speciality_in.dart';
import 'package:ww_api/src/model/speciality_out.dart';
import 'package:ww_api/src/model/staff_email_code_in.dart';
import 'package:ww_api/src/model/staff_email_code_out.dart';
import 'package:ww_api/src/model/staff_login_in.dart';
import 'package:ww_api/src/model/staff_login_out.dart';
import 'package:ww_api/src/model/staff_me_out.dart';
import 'package:ww_api/src/model/staff_password_in.dart';
import 'package:ww_api/src/model/staff_recovery_in.dart';
import 'package:ww_api/src/model/staff_role_out.dart';
import 'package:ww_api/src/model/staff_token_out.dart';
import 'package:ww_api/src/model/staff_totp_in.dart';
import 'package:ww_api/src/model/staff_user_create_in.dart';
import 'package:ww_api/src/model/staff_user_out.dart';
import 'package:ww_api/src/model/staff_user_update_in.dart';
import 'package:ww_api/src/model/start_in.dart';
import 'package:ww_api/src/model/step_done_out.dart';
import 'package:ww_api/src/model/step_in.dart';
import 'package:ww_api/src/model/steps_out.dart';
import 'package:ww_api/src/model/temporary_assign_in.dart';
import 'package:ww_api/src/model/temporary_end_in.dart';
import 'package:ww_api/src/model/temporary_partner_out.dart';
import 'package:ww_api/src/model/ticket_out.dart';
import 'package:ww_api/src/model/ticket_reply_in.dart';
import 'package:ww_api/src/model/ticket_reply_out.dart';
import 'package:ww_api/src/model/today_bookings_out.dart';
import 'package:ww_api/src/model/today_fees_out.dart';
import 'package:ww_api/src/model/token_out.dart';
import 'package:ww_api/src/model/track_batch_in.dart';
import 'package:ww_api/src/model/track_batch_out.dart';
import 'package:ww_api/src/model/track_out.dart';
import 'package:ww_api/src/model/track_point_in.dart';
import 'package:ww_api/src/model/unread_count_out.dart';
import 'package:ww_api/src/model/upload_url_in.dart';
import 'package:ww_api/src/model/upload_url_out.dart';
import 'package:ww_api/src/model/verify_in.dart';
import 'package:ww_api/src/model/view_url_out.dart';
import 'package:ww_api/src/model/visit_out.dart';
import 'package:ww_api/src/model/vitals_in.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AccountDeletionOut':
          return AccountDeletionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AddPartnerIn':
          return AddPartnerIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AddressFilter':
          return AddressFilter.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AddressIn':
          return AddressIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AddressOut':
          return AddressOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminBookingDetailOut':
          return AdminBookingDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminBookingEventOut':
          return AdminBookingEventOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminBookingPatientOut':
          return AdminBookingPatientOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminBookingRowOut':
          return AdminBookingRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminCancelIn':
          return AdminCancelIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminMemberOut':
          return AdminMemberOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminNoteIn':
          return AdminNoteIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminPatientIn':
          return AdminPatientIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminPaymentOut':
          return AdminPaymentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminRefundOut':
          return AdminRefundOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminReviewOut':
          return AdminReviewOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminSelfieOut':
          return AdminSelfieOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminSosOut':
          return AdminSosOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminStepIn':
          return AdminStepIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminTicketOut':
          return AdminTicketOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AffectedBookingOut':
          return AffectedBookingOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AlertCountOut':
          return AlertCountOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AlertOut':
          return AlertOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AlertsOut':
          return AlertsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AppConfigOut':
          return AppConfigOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AppVersionsOut':
          return AppVersionsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApplicationDetailOut':
          return ApplicationDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApplicationOut':
          return ApplicationOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApplicationRowOut':
          return ApplicationRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApplicationsOut':
          return ApplicationsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AssignIn':
          return AssignIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AssignedPartnerBriefOut':
          return AssignedPartnerBriefOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AssignedPartnerOut':
          return AssignedPartnerOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AssignmentStateOut':
          return AssignmentStateOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditEntryOut':
          return AuditEntryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditFiltersOut':
          return AuditFiltersOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditQuery':
          return AuditQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditStaffOut':
          return AuditStaffOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AvailabilityIn':
          return AvailabilityIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AvailabilityOut':
          return AvailabilityOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BalanceIn':
          return BalanceIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BalanceSumOut':
          return BalanceSumOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BlockedTimeIn':
          return BlockedTimeIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BlockedTimeOut':
          return BlockedTimeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingAddressOut':
          return BookingAddressOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingDayOut':
          return BookingDayOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingDetailOut':
          return BookingDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingDocumentOut':
          return BookingDocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingIn':
          return BookingIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingMemberOut':
          return BookingMemberOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingRefundOut':
          return BookingRefundOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingRowOut':
          return BookingRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingServiceOut':
          return BookingServiceOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingTimelineOut':
          return BookingTimelineOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingTimesOut':
          return BookingTimesOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingsByServiceOut':
          return BookingsByServiceOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingsReportOut':
          return BookingsReportOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BookingsReportRowOut':
          return BookingsReportRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CallIn':
          return CallIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancelIn':
          return CancelIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancelPreviewOut':
          return CancelPreviewOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancellationRowOut':
          return CancellationRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancellationsReportOut':
          return CancellationsReportOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CandidateOut':
          return CandidateOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CheckoutOut':
          return CheckoutOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CodeIn':
          return CodeIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConsentItemIn':
          return ConsentItemIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConsentNeededOut':
          return ConsentNeededOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConsentsIn':
          return ConsentsIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DashboardOut':
          return DashboardOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeclineIn':
          return DeclineIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeletionRequestOut':
          return DeletionRequestOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DevMailOut':
          return DevMailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DevOutboxOut':
          return DevOutboxOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DevSmsOut':
          return DevSmsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceIn':
          return DeviceIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocStateOut':
          return DocStateOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DoctorIn':
          return DoctorIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DoctorOut':
          return DoctorOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentIn':
          return DocumentIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentLinkOut':
          return DocumentLinkOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentOut':
          return DocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentReasonIn':
          return DocumentReasonIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentStorageOut':
          return DocumentStorageOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DocumentUploadUrlIn':
          return DocumentUploadUrlIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EmailIn':
          return EmailIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EmailSentOut':
          return EmailSentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FeeDayOut':
          return FeeDayOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FeeReportOut':
          return FeeReportOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FileLinkOut':
          return FileLinkOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ForceLogoutOut':
          return ForceLogoutOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GatewayKeysIn':
          return GatewayKeysIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GatewayKeysOut':
          return GatewayKeysOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleIn':
          return GoogleIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleOut':
          return GoogleOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthOut':
          return HealthOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HistoryOut':
          return HistoryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HospitalBrief':
          return HospitalBrief.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HospitalIn':
          return HospitalIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HospitalOut':
          return HospitalOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Input':
          return Input.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InsideAreaOut':
          return InsideAreaOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobCountsOut':
          return JobCountsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JobMemberOut':
          return JobMemberOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'KycStatusOut':
          return KycStatusOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LanguageIn':
          return LanguageIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalDocumentOut':
          return LegalDocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalPublishIn':
          return LegalPublishIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalSummaryOut':
          return LegalSummaryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalUrlsOut':
          return LegalUrlsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalVersionOut':
          return LegalVersionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LiveJobOut':
          return LiveJobOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LiveLocationOut':
          return LiveLocationOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MarkReadIn':
          return MarkReadIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MemberDetailOut':
          return MemberDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MemberIn':
          return MemberIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MemberOut':
          return MemberOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MemberPhotoUrlIn':
          return MemberPhotoUrlIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NearbyHospitalsOut':
          return NearbyHospitalsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NoteIn':
          return NoteIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NotificationOut':
          return NotificationOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferBriefOut':
          return OfferBriefOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferOut':
          return OfferOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferSummaryOut':
          return OfferSummaryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OkOut':
          return OkOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpSendIn':
          return OtpSendIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpSendOut':
          return OtpSendOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpVerifyIn':
          return OtpVerifyIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAccountDeletionOut':
          return PagedAccountDeletionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminBookingRowOut':
          return PagedAdminBookingRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminPaymentOut':
          return PagedAdminPaymentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminRefundOut':
          return PagedAdminRefundOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminReviewOut':
          return PagedAdminReviewOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminSelfieOut':
          return PagedAdminSelfieOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminSosOut':
          return PagedAdminSosOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAdminTicketOut':
          return PagedAdminTicketOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAlertOut':
          return PagedAlertOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedAuditEntryOut':
          return PagedAuditEntryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedBookingRowOut':
          return PagedBookingRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedNotificationOut':
          return PagedNotificationOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedPartnerJobRowOut':
          return PagedPartnerJobRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedPartnerRowOut':
          return PagedPartnerRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedPatientDoctorOut':
          return PagedPatientDoctorOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedPatientDocumentOut':
          return PagedPatientDocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedPatientRowOut':
          return PagedPatientRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PagedQueueRowOut':
          return PagedQueueRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerDeletionOut':
          return PartnerDeletionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerDetailOut':
          return PartnerDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerEditIn':
          return PartnerEditIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerHomeOut':
          return PartnerHomeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerJobOut':
          return PartnerJobOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerJobRowOut':
          return PartnerJobRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerMeOut':
          return PartnerMeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerPerformanceOut':
          return PartnerPerformanceOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerPerformanceRowOut':
          return PartnerPerformanceRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerProfileOut':
          return PartnerProfileOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerReviewOut':
          return PartnerReviewOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerRowOut':
          return PartnerRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerStatsOut':
          return PartnerStatsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerTotalsOut':
          return PartnerTotalsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartnerUploadUrlIn':
          return PartnerUploadUrlIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientDetailOut':
          return PatientDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientDoctorOut':
          return PatientDoctorOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientDocumentFilter':
          return PatientDocumentFilter.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientDocumentIn':
          return PatientDocumentIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientDocumentOut':
          return PatientDocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientHospitalDetailOut':
          return PatientHospitalDetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientHospitalOut':
          return PatientHospitalOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientMeIn':
          return PatientMeIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientMeOut':
          return PatientMeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientReasonIn':
          return PatientReasonIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PatientRowOut':
          return PatientRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PermissionOut':
          return PermissionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PhoneIn':
          return PhoneIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PhoneOut':
          return PhoneOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PlaceIn':
          return PlaceIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProfileIn':
          return ProfileIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PublicTrackOut':
          return PublicTrackOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QueueCountsOut':
          return QueueCountsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QueueRowOut':
          return QueueRowOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReasonIn':
          return ReasonIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecoveryCodesIn':
          return RecoveryCodesIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecoveryCodesOut':
          return RecoveryCodesOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshIn':
          return RefreshIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefundDecisionIn':
          return RefundDecisionIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RejectDocumentIn':
          return RejectDocumentIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReorderIn':
          return ReorderIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReportIn':
          return ReportIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequiredDocumentIn':
          return RequiredDocumentIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RequiredDocumentOut':
          return RequiredDocumentOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RescheduleIn':
          return RescheduleIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewIn':
          return ReviewIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewModerateIn':
          return ReviewModerateIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReviewOut':
          return ReviewOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RoleOut':
          return RoleOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RolesOut':
          return RolesOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SelfieIn':
          return SelfieIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceAreaIn':
          return ServiceAreaIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceAreaOut':
          return ServiceAreaOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceIn':
          return ServiceIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceOut':
          return ServiceOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SettingOut':
          return SettingOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SettingsGroupOut':
          return SettingsGroupOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SettingsIn':
          return SettingsIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SettingsOut':
          return SettingsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ShareLinkOut':
          return ShareLinkOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SosIn':
          return SosIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SosOut':
          return SosOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SosResolveIn':
          return SosResolveIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SpecialityIn':
          return SpecialityIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SpecialityOut':
          return SpecialityOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffEmailCodeIn':
          return StaffEmailCodeIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffEmailCodeOut':
          return StaffEmailCodeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffLoginIn':
          return StaffLoginIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffLoginOut':
          return StaffLoginOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffMeOut':
          return StaffMeOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffPasswordIn':
          return StaffPasswordIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffRecoveryIn':
          return StaffRecoveryIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffRoleOut':
          return StaffRoleOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffTokenOut':
          return StaffTokenOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffTotpIn':
          return StaffTotpIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffUserCreateIn':
          return StaffUserCreateIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffUserOut':
          return StaffUserOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffUserUpdateIn':
          return StaffUserUpdateIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartIn':
          return StartIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StepDoneOut':
          return StepDoneOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StepIn':
          return StepIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StepsOut':
          return StepsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TemporaryAssignIn':
          return TemporaryAssignIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TemporaryEndIn':
          return TemporaryEndIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TemporaryPartnerOut':
          return TemporaryPartnerOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TicketOut':
          return TicketOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TicketReplyIn':
          return TicketReplyIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TicketReplyOut':
          return TicketReplyOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TodayBookingsOut':
          return TodayBookingsOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TodayFeesOut':
          return TodayFeesOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokenOut':
          return TokenOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackBatchIn':
          return TrackBatchIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackBatchOut':
          return TrackBatchOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackOut':
          return TrackOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackPointIn':
          return TrackPointIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UnreadCountOut':
          return UnreadCountOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadUrlIn':
          return UploadUrlIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadUrlOut':
          return UploadUrlOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerifyIn':
          return VerifyIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ViewUrlOut':
          return ViewUrlOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VisitOut':
          return VisitOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VitalsIn':
          return VitalsIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }