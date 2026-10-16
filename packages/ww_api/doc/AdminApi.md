# ww_api.api.AdminApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAccountDeletionsList**](AdminApi.md#adminaccountdeletionslist) | **GET** /v1/admin/account-deletions | List Deletions
[**adminAlertAck**](AdminApi.md#adminalertack) | **POST** /v1/admin/alerts/{alert_id}/ack | Acknowledge
[**adminAlertsList**](AdminApi.md#adminalertslist) | **GET** /v1/admin/alerts | Alerts
[**adminApplicationApprove**](AdminApi.md#adminapplicationapprove) | **POST** /v1/admin/applications/{application_id}/approve | Approve
[**adminApplicationClaim**](AdminApi.md#adminapplicationclaim) | **POST** /v1/admin/applications/{application_id}/claim | Claim
[**adminApplicationGet**](AdminApi.md#adminapplicationget) | **GET** /v1/admin/applications/{application_id} | Get Application
[**adminApplicationReject**](AdminApi.md#adminapplicationreject) | **POST** /v1/admin/applications/{application_id}/reject | Reject
[**adminApplicationRelease**](AdminApi.md#adminapplicationrelease) | **POST** /v1/admin/applications/{application_id}/release | Release
[**adminApplicationRequestChanges**](AdminApi.md#adminapplicationrequestchanges) | **POST** /v1/admin/applications/{application_id}/request-changes | Request Changes
[**adminApplicationsList**](AdminApi.md#adminapplicationslist) | **GET** /v1/admin/applications | List Applications
[**adminAuditLogExport**](AdminApi.md#adminauditlogexport) | **GET** /v1/admin/audit-log/export | Export Audit Log
[**adminAuditLogFilters**](AdminApi.md#adminauditlogfilters) | **GET** /v1/admin/audit-log/filters | Audit Filters
[**adminAuditLogList**](AdminApi.md#adminauditloglist) | **GET** /v1/admin/audit-log | List Audit Log
[**adminAuthEmailCode**](AdminApi.md#adminauthemailcode) | **POST** /v1/admin/auth/email-code | Email Code
[**adminAuthLogin**](AdminApi.md#adminauthlogin) | **POST** /v1/admin/auth/login | Login
[**adminAuthLogout**](AdminApi.md#adminauthlogout) | **POST** /v1/admin/auth/logout | Logout
[**adminAuthRecovery**](AdminApi.md#adminauthrecovery) | **POST** /v1/admin/auth/recovery | Recovery
[**adminAuthRefresh**](AdminApi.md#adminauthrefresh) | **POST** /v1/admin/auth/refresh | Refresh
[**adminAuthTotp**](AdminApi.md#adminauthtotp) | **POST** /v1/admin/auth/totp | Totp
[**adminBlockedTimesCreate**](AdminApi.md#adminblockedtimescreate) | **POST** /v1/admin/blocked-times | Create Blocked
[**adminBlockedTimesDelete**](AdminApi.md#adminblockedtimesdelete) | **DELETE** /v1/admin/blocked-times/{blocked_id} | Delete Blocked
[**adminBlockedTimesList**](AdminApi.md#adminblockedtimeslist) | **GET** /v1/admin/blocked-times | List Blocked
[**adminBlockedTimesUpdate**](AdminApi.md#adminblockedtimesupdate) | **PUT** /v1/admin/blocked-times/{blocked_id} | Update Blocked
[**adminBookingAcceptByPhone**](AdminApi.md#adminbookingacceptbyphone) | **POST** /v1/admin/bookings/{booking_id}/accept-by-phone | Accept By Phone
[**adminBookingAssign**](AdminApi.md#adminbookingassign) | **POST** /v1/admin/bookings/{booking_id}/assign | Assign
[**adminBookingAssignment**](AdminApi.md#adminbookingassignment) | **GET** /v1/admin/bookings/{booking_id}/assignment | Assignment
[**adminBookingCancel**](AdminApi.md#adminbookingcancel) | **POST** /v1/admin/bookings/{booking_id}/cancel | Cancel Booking
[**adminBookingCandidates**](AdminApi.md#adminbookingcandidates) | **GET** /v1/admin/bookings/{booking_id}/candidates | Candidates
[**adminBookingGet**](AdminApi.md#adminbookingget) | **GET** /v1/admin/bookings/{booking_id} | Get Booking
[**adminBookingList**](AdminApi.md#adminbookinglist) | **GET** /v1/admin/bookings | List Bookings
[**adminBookingReschedule**](AdminApi.md#adminbookingreschedule) | **POST** /v1/admin/bookings/{booking_id}/reschedule | Reschedule Booking
[**adminBookingStep**](AdminApi.md#adminbookingstep) | **POST** /v1/admin/bookings/{booking_id}/steps | Mark Step
[**adminBookingTemporaryAssign**](AdminApi.md#adminbookingtemporaryassign) | **POST** /v1/admin/bookings/{booking_id}/temporary-assign | Temporary Assign
[**adminBookingTemporaryEnd**](AdminApi.md#adminbookingtemporaryend) | **POST** /v1/admin/bookings/{booking_id}/temporary-partner/end | Temporary End
[**adminBookingTemporaryIdPhoto**](AdminApi.md#adminbookingtemporaryidphoto) | **GET** /v1/admin/bookings/{booking_id}/temporary-partner/id-photo | Temporary Id Photo
[**adminBookingTemporaryPartner**](AdminApi.md#adminbookingtemporarypartner) | **GET** /v1/admin/bookings/{booking_id}/temporary-partner | Temporary Partner
[**adminBookingTrack**](AdminApi.md#adminbookingtrack) | **GET** /v1/admin/bookings/{booking_id}/track | Track
[**adminBookingUnassign**](AdminApi.md#adminbookingunassign) | **POST** /v1/admin/bookings/{booking_id}/unassign | Unassign
[**adminBookingsReport**](AdminApi.md#adminbookingsreport) | **GET** /v1/admin/reports/bookings | Bookings Report
[**adminBookingsReportCsv**](AdminApi.md#adminbookingsreportcsv) | **GET** /v1/admin/reports/bookings/csv | Bookings Report Csv
[**adminCancellationsReport**](AdminApi.md#admincancellationsreport) | **GET** /v1/admin/reports/cancellations | Cancellations Report
[**adminCancellationsReportCsv**](AdminApi.md#admincancellationsreportcsv) | **GET** /v1/admin/reports/cancellations/csv | Cancellations Report Csv
[**adminDashboard**](AdminApi.md#admindashboard) | **GET** /v1/admin/dashboard | Dashboard
[**adminDevOutbox**](AdminApi.md#admindevoutbox) | **GET** /v1/admin/dev/outbox | Dev Outbox
[**adminDoctorsActivate**](AdminApi.md#admindoctorsactivate) | **POST** /v1/admin/doctors/{doctor_id}/activate | Activate Doctor
[**adminDoctorsCreate**](AdminApi.md#admindoctorscreate) | **POST** /v1/admin/doctors | Create Doctor
[**adminDoctorsDeactivate**](AdminApi.md#admindoctorsdeactivate) | **POST** /v1/admin/doctors/{doctor_id}/deactivate | Deactivate Doctor
[**adminDoctorsDelete**](AdminApi.md#admindoctorsdelete) | **DELETE** /v1/admin/doctors/{doctor_id} | Delete Doctor
[**adminDoctorsList**](AdminApi.md#admindoctorslist) | **GET** /v1/admin/doctors | List Doctors
[**adminDoctorsUpdate**](AdminApi.md#admindoctorsupdate) | **PUT** /v1/admin/doctors/{doctor_id} | Update Doctor
[**adminFeeReport**](AdminApi.md#adminfeereport) | **GET** /v1/admin/reports/fees | Fee Report
[**adminFeeReportDays**](AdminApi.md#adminfeereportdays) | **GET** /v1/admin/reports/fees/days | Fee Report Days
[**adminFilesUploadUrl**](AdminApi.md#adminfilesuploadurl) | **POST** /v1/admin/files/upload-url | Upload Url
[**adminHospitalsActivate**](AdminApi.md#adminhospitalsactivate) | **POST** /v1/admin/hospitals/{hospital_id}/activate | Activate Hospital
[**adminHospitalsCreate**](AdminApi.md#adminhospitalscreate) | **POST** /v1/admin/hospitals | Create Hospital
[**adminHospitalsDeactivate**](AdminApi.md#adminhospitalsdeactivate) | **POST** /v1/admin/hospitals/{hospital_id}/deactivate | Deactivate Hospital
[**adminHospitalsDelete**](AdminApi.md#adminhospitalsdelete) | **DELETE** /v1/admin/hospitals/{hospital_id} | Delete Hospital
[**adminHospitalsList**](AdminApi.md#adminhospitalslist) | **GET** /v1/admin/hospitals | List Hospitals
[**adminHospitalsUpdate**](AdminApi.md#adminhospitalsupdate) | **PUT** /v1/admin/hospitals/{hospital_id} | Update Hospital
[**adminLegalGet**](AdminApi.md#adminlegalget) | **GET** /v1/admin/legal/{kind} | Legal Get
[**adminLegalList**](AdminApi.md#adminlegallist) | **GET** /v1/admin/legal | Legal List
[**adminLegalPublish**](AdminApi.md#adminlegalpublish) | **POST** /v1/admin/legal/{kind} | Legal Publish
[**adminLegalVersion**](AdminApi.md#adminlegalversion) | **GET** /v1/admin/legal/{kind}/versions/{version} | Legal Version
[**adminLegalVersions**](AdminApi.md#adminlegalversions) | **GET** /v1/admin/legal/{kind}/versions | Legal Versions
[**adminLiveJobs**](AdminApi.md#adminlivejobs) | **GET** /v1/admin/live | Live
[**adminMeGet**](AdminApi.md#adminmeget) | **GET** /v1/admin/me | Me
[**adminPartnerDeactivate**](AdminApi.md#adminpartnerdeactivate) | **POST** /v1/admin/partners/{partner_id}/deactivate | Deactivate
[**adminPartnerDocumentApprove**](AdminApi.md#adminpartnerdocumentapprove) | **POST** /v1/admin/partner-documents/{document_id}/approve | Document Approve
[**adminPartnerDocumentReject**](AdminApi.md#adminpartnerdocumentreject) | **POST** /v1/admin/partner-documents/{document_id}/reject | Document Reject
[**adminPartnerDocumentView**](AdminApi.md#adminpartnerdocumentview) | **GET** /v1/admin/partner-documents/{document_id}/view-url | Document View
[**adminPartnerForceLogout**](AdminApi.md#adminpartnerforcelogout) | **POST** /v1/admin/partners/{partner_id}/logout | Force Logout
[**adminPartnerGet**](AdminApi.md#adminpartnerget) | **GET** /v1/admin/partners/{partner_id} | Get Partner
[**adminPartnerPerformanceReport**](AdminApi.md#adminpartnerperformancereport) | **GET** /v1/admin/reports/partners | Partner Performance
[**adminPartnerPerformanceReportCsv**](AdminApi.md#adminpartnerperformancereportcsv) | **GET** /v1/admin/reports/partners/csv | Partner Performance Csv
[**adminPartnerReinstate**](AdminApi.md#adminpartnerreinstate) | **POST** /v1/admin/partners/{partner_id}/reinstate | Reinstate
[**adminPartnerSuspend**](AdminApi.md#adminpartnersuspend) | **POST** /v1/admin/partners/{partner_id}/suspend | Suspend
[**adminPartnerUpdate**](AdminApi.md#adminpartnerupdate) | **PUT** /v1/admin/partners/{partner_id} | Update Partner
[**adminPartnersAdd**](AdminApi.md#adminpartnersadd) | **POST** /v1/admin/partners | Add Partner
[**adminPartnersList**](AdminApi.md#adminpartnerslist) | **GET** /v1/admin/partners | List Partners
[**adminPatientBlock**](AdminApi.md#adminpatientblock) | **POST** /v1/admin/patients/{user_id}/block | Block
[**adminPatientDocumentViewUrl**](AdminApi.md#adminpatientdocumentviewurl) | **POST** /v1/admin/patients/{user_id}/documents/{document_id}/view-url | View Document
[**adminPatientGet**](AdminApi.md#adminpatientget) | **GET** /v1/admin/patients/{user_id} | Get Patient
[**adminPatientRequestDeletion**](AdminApi.md#adminpatientrequestdeletion) | **POST** /v1/admin/patients/{user_id}/deletion | Request Deletion
[**adminPatientUnblock**](AdminApi.md#adminpatientunblock) | **POST** /v1/admin/patients/{user_id}/unblock | Unblock
[**adminPatientUpdate**](AdminApi.md#adminpatientupdate) | **PUT** /v1/admin/patients/{user_id} | Update
[**adminPatientsList**](AdminApi.md#adminpatientslist) | **GET** /v1/admin/patients | List Patients
[**adminPaymentKeysGet**](AdminApi.md#adminpaymentkeysget) | **GET** /v1/admin/payment-keys | Get Keys
[**adminPaymentKeysSave**](AdminApi.md#adminpaymentkeyssave) | **PUT** /v1/admin/payment-keys | Save Keys
[**adminPaymentList**](AdminApi.md#adminpaymentlist) | **GET** /v1/admin/payments | List Payments
[**adminQueueCounts**](AdminApi.md#adminqueuecounts) | **GET** /v1/admin/assignments/queue/counts | Queue Counts
[**adminQueueList**](AdminApi.md#adminqueuelist) | **GET** /v1/admin/assignments/queue | Queue
[**adminRecoveryCodesCreate**](AdminApi.md#adminrecoverycodescreate) | **POST** /v1/admin/me/recovery-codes | Recovery Codes
[**adminRecoveryCodesSaved**](AdminApi.md#adminrecoverycodessaved) | **POST** /v1/admin/me/recovery-codes/saved | Recovery Codes Saved
[**adminRefundApprove**](AdminApi.md#adminrefundapprove) | **POST** /v1/admin/refunds/{refund_id}/approve | Approve Refund
[**adminRefundList**](AdminApi.md#adminrefundlist) | **GET** /v1/admin/refunds | List Refunds
[**adminRefundReject**](AdminApi.md#adminrefundreject) | **POST** /v1/admin/refunds/{refund_id}/reject | Reject Refund
[**adminRefundRetry**](AdminApi.md#adminrefundretry) | **POST** /v1/admin/refunds/{refund_id}/retry | Retry Refund
[**adminRequiredDocumentsCreate**](AdminApi.md#adminrequireddocumentscreate) | **POST** /v1/admin/required-documents | Create Required
[**adminRequiredDocumentsDelete**](AdminApi.md#adminrequireddocumentsdelete) | **DELETE** /v1/admin/required-documents/{required_id} | Delete Required
[**adminRequiredDocumentsList**](AdminApi.md#adminrequireddocumentslist) | **GET** /v1/admin/required-documents | List Required
[**adminRequiredDocumentsUpdate**](AdminApi.md#adminrequireddocumentsupdate) | **PUT** /v1/admin/required-documents/{required_id} | Update Required
[**adminReviewHide**](AdminApi.md#adminreviewhide) | **POST** /v1/admin/reviews/{review_id}/hide | Hide
[**adminReviewShow**](AdminApi.md#adminreviewshow) | **POST** /v1/admin/reviews/{review_id}/show | Show
[**adminReviews**](AdminApi.md#adminreviews) | **GET** /v1/admin/reviews | Reviews
[**adminRolesList**](AdminApi.md#adminroleslist) | **GET** /v1/admin/roles | Roles
[**adminSelfiesList**](AdminApi.md#adminselfieslist) | **GET** /v1/admin/selfies | List Selfies
[**adminServiceAreasActivate**](AdminApi.md#adminserviceareasactivate) | **POST** /v1/admin/service-areas/{area_id}/activate | Activate Area
[**adminServiceAreasCheck**](AdminApi.md#adminserviceareascheck) | **GET** /v1/admin/service-areas/check | Check Point
[**adminServiceAreasCreate**](AdminApi.md#adminserviceareascreate) | **POST** /v1/admin/service-areas | Create Area
[**adminServiceAreasDeactivate**](AdminApi.md#adminserviceareasdeactivate) | **POST** /v1/admin/service-areas/{area_id}/deactivate | Deactivate Area
[**adminServiceAreasDelete**](AdminApi.md#adminserviceareasdelete) | **DELETE** /v1/admin/service-areas/{area_id} | Delete Area
[**adminServiceAreasList**](AdminApi.md#adminserviceareaslist) | **GET** /v1/admin/service-areas | List Areas
[**adminServiceAreasUpdate**](AdminApi.md#adminserviceareasupdate) | **PUT** /v1/admin/service-areas/{area_id} | Update Area
[**adminServicesActivate**](AdminApi.md#adminservicesactivate) | **POST** /v1/admin/services/{service_id}/activate | Activate Service
[**adminServicesCreate**](AdminApi.md#adminservicescreate) | **POST** /v1/admin/services | Create Service
[**adminServicesDeactivate**](AdminApi.md#adminservicesdeactivate) | **POST** /v1/admin/services/{service_id}/deactivate | Deactivate Service
[**adminServicesDelete**](AdminApi.md#adminservicesdelete) | **DELETE** /v1/admin/services/{service_id} | Delete Service
[**adminServicesList**](AdminApi.md#adminserviceslist) | **GET** /v1/admin/services | List Services
[**adminServicesReorder**](AdminApi.md#adminservicesreorder) | **POST** /v1/admin/services/reorder | Reorder Services
[**adminServicesUpdate**](AdminApi.md#adminservicesupdate) | **PUT** /v1/admin/services/{service_id} | Update Service
[**adminSettingsGet**](AdminApi.md#adminsettingsget) | **GET** /v1/admin/settings | Get Settings
[**adminSettingsUpdate**](AdminApi.md#adminsettingsupdate) | **PUT** /v1/admin/settings | Update Settings
[**adminSosAck**](AdminApi.md#adminsosack) | **POST** /v1/admin/sos/{sos_id}/ack | Sos Ack
[**adminSosList**](AdminApi.md#adminsoslist) | **GET** /v1/admin/sos | Sos List
[**adminSosResolve**](AdminApi.md#adminsosresolve) | **POST** /v1/admin/sos/{sos_id}/resolve | Sos Resolve
[**adminSpecialitiesCreate**](AdminApi.md#adminspecialitiescreate) | **POST** /v1/admin/specialities | Create Speciality
[**adminSpecialitiesDelete**](AdminApi.md#adminspecialitiesdelete) | **DELETE** /v1/admin/specialities/{speciality_id} | Delete Speciality
[**adminSpecialitiesList**](AdminApi.md#adminspecialitieslist) | **GET** /v1/admin/specialities | List Specialities
[**adminSpecialitiesUpdate**](AdminApi.md#adminspecialitiesupdate) | **PUT** /v1/admin/specialities/{speciality_id} | Update Speciality
[**adminStaffUsersCreate**](AdminApi.md#adminstaffuserscreate) | **POST** /v1/admin/staff-users | Create Staff User
[**adminStaffUsersDisable**](AdminApi.md#adminstaffusersdisable) | **POST** /v1/admin/staff-users/{staff_id}/disable | Disable Staff User
[**adminStaffUsersEnable**](AdminApi.md#adminstaffusersenable) | **POST** /v1/admin/staff-users/{staff_id}/enable | Enable Staff User
[**adminStaffUsersForceLogout**](AdminApi.md#adminstaffusersforcelogout) | **POST** /v1/admin/staff-users/{staff_id}/logout | Force Logout
[**adminStaffUsersList**](AdminApi.md#adminstaffuserslist) | **GET** /v1/admin/staff-users | List Staff Users
[**adminStaffUsersReset2fa**](AdminApi.md#adminstaffusersreset2fa) | **POST** /v1/admin/staff-users/{staff_id}/reset-2fa | Reset 2Fa
[**adminStaffUsersSetPassword**](AdminApi.md#adminstaffuserssetpassword) | **POST** /v1/admin/staff-users/{staff_id}/password | Set Password
[**adminStaffUsersUpdate**](AdminApi.md#adminstaffusersupdate) | **PUT** /v1/admin/staff-users/{staff_id} | Update Staff User
[**adminTicketClose**](AdminApi.md#adminticketclose) | **POST** /v1/admin/tickets/{ticket_id}/close | Close
[**adminTicketReply**](AdminApi.md#adminticketreply) | **POST** /v1/admin/tickets/{ticket_id}/reply | Reply
[**adminTickets**](AdminApi.md#admintickets) | **GET** /v1/admin/tickets | Tickets


# **adminAccountDeletionsList**
> PagedAccountDeletionOut adminAccountDeletionsList(status, page, pageSize)

List Deletions

\"Delete my account\" requests, newest first: waiting (the patient can still log in to cancel), cancelled, or done. Only the phone's last 4 digits are kept.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminAccountDeletionsList(status, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAccountDeletionsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAccountDeletionOut**](PagedAccountDeletionOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAlertAck**
> AlertOut adminAlertAck(alertId)

Acknowledge

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String alertId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminAlertAck(alertId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAlertAck: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **alertId** | **String**|  | 

### Return type

[**AlertOut**](AlertOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAlertsList**
> PagedAlertOut adminAlertsList(open, kind, page, pageSize)

Alerts

2 minutes without an answer, declined, past the deadline, the visit's alerts: newest first.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final bool open = true; // bool | 
final List<String> kind = ; // List<String> | Only these kinds
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminAlertsList(open, kind, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAlertsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **open** | **bool**|  | [optional] [default to true]
 **kind** | [**List&lt;String&gt;**](String.md)| Only these kinds | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAlertOut**](PagedAlertOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationApprove**
> ApplicationDetailOut adminApplicationApprove(applicationId)

Approve

Every required document approved and none waiting → the partner is APPROVED.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminApplicationApprove(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**ApplicationDetailOut**](ApplicationDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationClaim**
> ApplicationDetailOut adminApplicationClaim(applicationId)

Claim

Open for review: locked to you for 30 minutes (409 CLAIMED_BY_OTHER otherwise).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminApplicationClaim(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationClaim: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**ApplicationDetailOut**](ApplicationDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationGet**
> ApplicationDetailOut adminApplicationGet(applicationId)

Get Application

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminApplicationGet(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**ApplicationDetailOut**](ApplicationDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationReject**
> ApplicationDetailOut adminApplicationReject(applicationId, reasonIn)

Reject

Final: not eligible.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReasonIn reasonIn = ; // ReasonIn | 

try {
    final response = api.adminApplicationReject(applicationId, reasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **reasonIn** | [**ReasonIn**](ReasonIn.md)|  | 

### Return type

[**ApplicationDetailOut**](ApplicationDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationRelease**
> OkOut adminApplicationRelease(applicationId)

Release

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminApplicationRelease(applicationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationRequestChanges**
> ApplicationDetailOut adminApplicationRequestChanges(applicationId, noteIn)

Request Changes

The partner sees the reason for each rejected document (and this note).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final NoteIn noteIn = ; // NoteIn | 

try {
    final response = api.adminApplicationRequestChanges(applicationId, noteIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationRequestChanges: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **noteIn** | [**NoteIn**](NoteIn.md)|  | 

### Return type

[**ApplicationDetailOut**](ApplicationDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminApplicationsList**
> List<ApplicationRowOut> adminApplicationsList(status, role)

List Applications

Oldest first. Default: submitted and under review.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final String role = role_example; // String | 

try {
    final response = api.adminApplicationsList(status, role);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminApplicationsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to '']
 **role** | **String**|  | [optional] [default to '']

### Return type

[**List&lt;ApplicationRowOut&gt;**](ApplicationRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuditLogExport**
> String adminAuditLogExport(staffId, action, entityType, entityId, from, to)

Export Audit Log

CSV of the filtered log (newest first, at most 10,000 rows). The export is logged too.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String action = action_example; // String | Starts with, e.g. `service.`
final String entityType = entityType_example; // String | 
final String entityId = entityId_example; // String | 
final DateTime from = 2013-10-20; // DateTime | IST date, inclusive
final DateTime to = 2013-10-20; // DateTime | IST date, inclusive

try {
    final response = api.adminAuditLogExport(staffId, action, entityType, entityId, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuditLogExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | [optional] 
 **action** | **String**| Starts with, e.g. `service.` | [optional] [default to '']
 **entityType** | **String**|  | [optional] [default to '']
 **entityId** | **String**|  | [optional] [default to '']
 **from** | **DateTime**| IST date, inclusive | [optional] 
 **to** | **DateTime**| IST date, inclusive | [optional] 

### Return type

**String**

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuditLogFilters**
> AuditFiltersOut adminAuditLogFilters()

Audit Filters

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminAuditLogFilters();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuditLogFilters: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuditFiltersOut**](AuditFiltersOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuditLogList**
> PagedAuditEntryOut adminAuditLogList(staffId, action, entityType, entityId, from, to, page, pageSize)

List Audit Log

Newest first, 20 a page.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String action = action_example; // String | Starts with, e.g. `service.`
final String entityType = entityType_example; // String | 
final String entityId = entityId_example; // String | 
final DateTime from = 2013-10-20; // DateTime | IST date, inclusive
final DateTime to = 2013-10-20; // DateTime | IST date, inclusive
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminAuditLogList(staffId, action, entityType, entityId, from, to, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuditLogList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | [optional] 
 **action** | **String**| Starts with, e.g. `service.` | [optional] [default to '']
 **entityType** | **String**|  | [optional] [default to '']
 **entityId** | **String**|  | [optional] [default to '']
 **from** | **DateTime**| IST date, inclusive | [optional] 
 **to** | **DateTime**| IST date, inclusive | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAuditEntryOut**](PagedAuditEntryOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthEmailCode**
> StaffEmailCodeOut adminAuthEmailCode(staffEmailCodeIn)

Email Code

Phone lost or not at hand (v2.18): a 6-digit code to the admin's work email, typed in the same box as the authenticator code (`/auth/totp` with the challenge returned here). 429 EMAIL_CODE_TOO_SOON {retryAfterSeconds} / EMAIL_CODE_RATE_LIMITED; 401 LOGIN_EXPIRED.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final StaffEmailCodeIn staffEmailCodeIn = ; // StaffEmailCodeIn | 

try {
    final response = api.adminAuthEmailCode(staffEmailCodeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthEmailCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffEmailCodeIn** | [**StaffEmailCodeIn**](StaffEmailCodeIn.md)|  | 

### Return type

[**StaffEmailCodeOut**](StaffEmailCodeOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthLogin**
> StaffLoginOut adminAuthLogin(staffLoginIn)

Login

Step 1: email + password. Then ask for the authenticator code (first time: show the QR). In a browser the admin trusted (v2.16), signed in at once (`SIGNED_IN`).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final StaffLoginIn staffLoginIn = ; // StaffLoginIn | 

try {
    final response = api.adminAuthLogin(staffLoginIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffLoginIn** | [**StaffLoginIn**](StaffLoginIn.md)|  | 

### Return type

[**StaffLoginOut**](StaffLoginOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthLogout**
> OkOut adminAuthLogout()

Logout

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminAuthLogout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OkOut**](OkOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthRecovery**
> StaffLoginOut adminAuthRecovery(staffRecoveryIn)

Recovery

Lost phone (v2.16): a recovery code instead of the 2FA code. Answers TOTP_SETUP: scan the new QR code on the new phone (the old authenticator stops working). 401 RECOVERY_CODE_INVALID; wrong codes count like wrong 2FA codes.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final StaffRecoveryIn staffRecoveryIn = ; // StaffRecoveryIn | 

try {
    final response = api.adminAuthRecovery(staffRecoveryIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffRecoveryIn** | [**StaffRecoveryIn**](StaffRecoveryIn.md)|  | 

### Return type

[**StaffLoginOut**](StaffLoginOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthRefresh**
> StaffTokenOut adminAuthRefresh()

Refresh

New access token from the refresh cookie (12 h from sign-in, 30-min idle logout).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminAuthRefresh();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthRefresh: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StaffTokenOut**](StaffTokenOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthTotp**
> StaffTokenOut adminAuthTotp(staffTotpIn)

Totp

Step 2: the 6-digit authenticator code. Sets the refresh cookie (and the trusted-browser cookie when asked). Right after 2FA was set up, the answer has the 10 recovery codes.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final StaffTotpIn staffTotpIn = ; // StaffTotpIn | 

try {
    final response = api.adminAuthTotp(staffTotpIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuthTotp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffTotpIn** | [**StaffTotpIn**](StaffTotpIn.md)|  | 

### Return type

[**StaffTokenOut**](StaffTokenOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBlockedTimesCreate**
> BlockedTimeOut adminBlockedTimesCreate(blockedTimeIn)

Create Blocked

The answer lists the existing bookings inside the range, so the admin can move them.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final BlockedTimeIn blockedTimeIn = ; // BlockedTimeIn | 

try {
    final response = api.adminBlockedTimesCreate(blockedTimeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBlockedTimesCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockedTimeIn** | [**BlockedTimeIn**](BlockedTimeIn.md)|  | 

### Return type

[**BlockedTimeOut**](BlockedTimeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBlockedTimesDelete**
> OkOut adminBlockedTimesDelete(blockedId)

Delete Blocked

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String blockedId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBlockedTimesDelete(blockedId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBlockedTimesDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockedId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBlockedTimesList**
> List<BlockedTimeOut> adminBlockedTimesList(upcoming)

List Blocked

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final bool upcoming = true; // bool | 

try {
    final response = api.adminBlockedTimesList(upcoming);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBlockedTimesList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **upcoming** | **bool**|  | [optional] [default to false]

### Return type

[**List&lt;BlockedTimeOut&gt;**](BlockedTimeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBlockedTimesUpdate**
> BlockedTimeOut adminBlockedTimesUpdate(blockedId, blockedTimeIn)

Update Blocked

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String blockedId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final BlockedTimeIn blockedTimeIn = ; // BlockedTimeIn | 

try {
    final response = api.adminBlockedTimesUpdate(blockedId, blockedTimeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBlockedTimesUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blockedId** | **String**|  | 
 **blockedTimeIn** | [**BlockedTimeIn**](BlockedTimeIn.md)|  | 

### Return type

[**BlockedTimeOut**](BlockedTimeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingAcceptByPhone**
> AssignmentStateOut adminBookingAcceptByPhone(bookingId, adminNoteIn)

Accept By Phone

The offered partner agreed on the phone (§6.10). Logged with the note.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminNoteIn adminNoteIn = ; // AdminNoteIn | 

try {
    final response = api.adminBookingAcceptByPhone(bookingId, adminNoteIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingAcceptByPhone: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **adminNoteIn** | [**AdminNoteIn**](AdminNoteIn.md)|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingAssign**
> AssignmentStateOut adminBookingAssign(bookingId, assignIn)

Assign

Offer the booking to a partner (reassigning withdraws the open offer). 409 PARTNER_BUSY / PARTNER_NOT_ELIGIBLE / NOT_ASSIGNABLE / OFFER_CHANGED (another admin).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AssignIn assignIn = ; // AssignIn | 

try {
    final response = api.adminBookingAssign(bookingId, assignIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingAssign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **assignIn** | [**AssignIn**](AssignIn.md)|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingAssignment**
> AssignmentStateOut adminBookingAssignment(bookingId)

Assignment

The booking page's assignment card (2-minute countdown, partner, offers, alerts).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingAssignment(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingAssignment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingCancel**
> AdminBookingDetailOut adminBookingCancel(bookingId, adminCancelIn)

Cancel Booking

Cancel with a reason and a refund % of the booking fee (patient asked: 50 by default; no partner available or WellWish's side: 100). Refunds above the approval limit (setting `refund_approval_above_paise`) wait for Finance. Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCancelIn adminCancelIn = ; // AdminCancelIn | 

try {
    final response = api.adminBookingCancel(bookingId, adminCancelIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **adminCancelIn** | [**AdminCancelIn**](AdminCancelIn.md)|  | 

### Return type

[**AdminBookingDetailOut**](AdminBookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingCandidates**
> List<CandidateOut> adminBookingCandidates(bookingId)

Candidates

§6.10 suggestion list: approved partners of the booking's type who are free then, available today first, then nearest. Both phone numbers for the call buttons.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingCandidates(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingCandidates: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**List&lt;CandidateOut&gt;**](CandidateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingGet**
> AdminBookingDetailOut adminBookingGet(bookingId)

Get Booking

Patient, member, service and price snapshot, hospital and doctor, address, documents and the timeline. Opening a document: the patient page (needs a reason, logged).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**AdminBookingDetailOut**](AdminBookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingList**
> PagedAdminBookingRowOut adminBookingList(status, date, type, when_, q, temporary, page, pageSize)

List Bookings

`when`: upcoming (default: from today on and unfinished ones, soonest first), today, tomorrow, later, past (latest first), India dates. Without `status`, unpaid and expired bookings are left out (a booking code finds them). `date`: one pickup date. `type`: companion or nurse services. `q`: booking code (WW-10001), a phone (the patient's or the member's, 4+ digits) or the member's name. `temporary`: only bookings with (or without) a temporary partner (§6.19).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final DateTime date = 2013-10-20; // DateTime | 
final String type = type_example; // String | 
final String when_ = when__example; // String | 
final String q = q_example; // String | 
final bool temporary = true; // bool | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminBookingList(status, date, type, when_, q, temporary, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **date** | **DateTime**|  | [optional] 
 **type** | **String**|  | [optional] 
 **when_** | **String**|  | [optional] 
 **q** | **String**|  | [optional] [default to '']
 **temporary** | **bool**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminBookingRowOut**](PagedAdminBookingRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingReschedule**
> AdminBookingDetailOut adminBookingReschedule(bookingId, rescheduleIn)

Reschedule Booking

Change the date or time for the patient (any time before the job starts, also inside the minimum notice; not counted against the patient's changes). Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RescheduleIn rescheduleIn = ; // RescheduleIn | 

try {
    final response = api.adminBookingReschedule(bookingId, rescheduleIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingReschedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **rescheduleIn** | [**RescheduleIn**](RescheduleIn.md)|  | 

### Return type

[**AdminBookingDetailOut**](AdminBookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingStep**
> AdminBookingDetailOut adminBookingStep(bookingId, adminStepIn)

Mark Step

Mark the next step for the partner (§6.11: no network at the door, wrong visit codes, the phone died), after confirming by phone. No OTP needed. Logged with the reason.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminStepIn adminStepIn = ; // AdminStepIn | 

try {
    final response = api.adminBookingStep(bookingId, adminStepIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingStep: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **adminStepIn** | [**AdminStepIn**](AdminStepIn.md)|  | 

### Return type

[**AdminBookingDetailOut**](AdminBookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingTemporaryAssign**
> AssignmentStateOut adminBookingTemporaryAssign(bookingId, temporaryAssignIn)

Temporary Assign

Nobody free (§6.19): a person the admin phoned and ID-checked gets this booking, accepted at once. 409 PHONE_IS_PARTNER {status} / TEMP_PARTNER_BUSY / TEMP_PARTNER_IS_FAMILY / NOT_ASSIGNABLE / OFFER_CHANGED; 422 ID_NOT_CHECKED / INVALID_PHONE / INVALID_ID_LAST4 / NURSING_REG_REQUIRED / FILE_NOT_FOUND. Logged with the reason.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TemporaryAssignIn temporaryAssignIn = ; // TemporaryAssignIn | 

try {
    final response = api.adminBookingTemporaryAssign(bookingId, temporaryAssignIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingTemporaryAssign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **temporaryAssignIn** | [**TemporaryAssignIn**](TemporaryAssignIn.md)|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingTemporaryEnd**
> AssignmentStateOut adminBookingTemporaryEnd(bookingId, temporaryEndIn)

Temporary End

End the temporary partner's app access now (§6.19), e.g. a problem during the visit. Logged out at once; a job not finished is flagged PARTNER_UNAVAILABLE. 409 NOT_TEMPORARY: no temporary partner with access on this booking.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TemporaryEndIn temporaryEndIn = ; // TemporaryEndIn | 

try {
    final response = api.adminBookingTemporaryEnd(bookingId, temporaryEndIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingTemporaryEnd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **temporaryEndIn** | [**TemporaryEndIn**](TemporaryEndIn.md)|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingTemporaryIdPhoto**
> FileLinkOut adminBookingTemporaryIdPhoto(bookingId)

Temporary Id Photo

A 5-minute link to the temporary partner's ID photo, for those who see partner documents or assign bookings (not view-only roles). Every view is logged (`temporary.id_viewed`), like partner documents (§6.3).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingTemporaryIdPhoto(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingTemporaryIdPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**FileLinkOut**](FileLinkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingTemporaryPartner**
> TemporaryPartnerOut adminBookingTemporaryPartner(bookingId)

Temporary Partner

The ID card of the booking's temporary partner (§6.19). 404: none.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingTemporaryPartner(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingTemporaryPartner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**TemporaryPartnerOut**](TemporaryPartnerOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingTrack**
> TrackOut adminBookingTrack(bookingId)

Track

The route saved when the job ended (404 before that).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminBookingTrack(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingTrack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**TrackOut**](TrackOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingUnassign**
> AssignmentStateOut adminBookingUnassign(bookingId, adminNoteIn)

Unassign

Withdraw the offer, or take the job from an accepted partner (they called): back to the queue. Logged with the reason.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminNoteIn adminNoteIn = ; // AdminNoteIn | 

try {
    final response = api.adminBookingUnassign(bookingId, adminNoteIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingUnassign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **adminNoteIn** | [**AdminNoteIn**](AdminNoteIn.md)|  | 

### Return type

[**AssignmentStateOut**](AssignmentStateOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingsReport**
> BookingsReportOut adminBookingsReport(from, to)

Bookings Report

Paid bookings by visit date (India) and by service: booked, completed, cancelled, patient not available, not finished. Default: this month so far.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminBookingsReport(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingsReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**BookingsReportOut**](BookingsReportOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBookingsReportCsv**
> String adminBookingsReportCsv(from, to)

Bookings Report Csv

The bookings report as a CSV file (by date, then by service). Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminBookingsReportCsv(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBookingsReportCsv: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

**String**

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCancellationsReport**
> CancellationsReportOut adminCancellationsReport(from, to)

Cancellations Report

Bookings cancelled on these dates (who, why, the refund %) and refunds asked for other bookings, with the fee paid and what was refunded. Default: this month so far.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminCancellationsReport(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCancellationsReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**CancellationsReportOut**](CancellationsReportOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCancellationsReportCsv**
> String adminCancellationsReportCsv(from, to)

Cancellations Report Csv

The cancellations and refunds report as a CSV file. Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminCancellationsReportCsv(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCancellationsReportCsv: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

**String**

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboard**
> DashboardOut adminDashboard()

Dashboard

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminDashboard();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDashboard: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DashboardOut**](DashboardOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDevOutbox**
> DevOutboxOut adminDevOutbox()

Dev Outbox

The last 50 SMS (login codes, visit codes, SOS…) and emails of the last hour, newest first, as the dev backends kept them: MSG91 and SES aren't used on a developer's PC. 404 on any real server (they send for real and keep nothing).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminDevOutbox();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDevOutbox: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DevOutboxOut**](DevOutboxOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsActivate**
> DoctorOut adminDoctorsActivate(doctorId)

Activate Doctor

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String doctorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminDoctorsActivate(doctorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsActivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorId** | **String**|  | 

### Return type

[**DoctorOut**](DoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsCreate**
> DoctorOut adminDoctorsCreate(doctorIn)

Create Doctor

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DoctorIn doctorIn = ; // DoctorIn | 

try {
    final response = api.adminDoctorsCreate(doctorIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorIn** | [**DoctorIn**](DoctorIn.md)|  | 

### Return type

[**DoctorOut**](DoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsDeactivate**
> DoctorOut adminDoctorsDeactivate(doctorId)

Deactivate Doctor

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String doctorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminDoctorsDeactivate(doctorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorId** | **String**|  | 

### Return type

[**DoctorOut**](DoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsDelete**
> OkOut adminDoctorsDelete(doctorId)

Delete Doctor

Refused (409 IN_USE) once the doctor is used in a booking.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String doctorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminDoctorsDelete(doctorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsList**
> List<DoctorOut> adminDoctorsList(q, specialityId, hospitalId)

List Doctors

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String q = q_example; // String | 
final String specialityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminDoctorsList(q, specialityId, hospitalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] [default to '']
 **specialityId** | **String**|  | [optional] 
 **hospitalId** | **String**|  | [optional] 

### Return type

[**List&lt;DoctorOut&gt;**](DoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDoctorsUpdate**
> DoctorOut adminDoctorsUpdate(doctorId, doctorIn)

Update Doctor

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String doctorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DoctorIn doctorIn = ; // DoctorIn | 

try {
    final response = api.adminDoctorsUpdate(doctorId, doctorIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminDoctorsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorId** | **String**|  | 
 **doctorIn** | [**DoctorIn**](DoctorIn.md)|  | 

### Return type

[**DoctorOut**](DoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFeeReport**
> String adminFeeReport(from, to)

Fee Report

CSV of booking fees per India date: payments, collected, refunded, net (in ₹). Default: this month so far. Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminFeeReport(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminFeeReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

**String**

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFeeReportDays**
> FeeReportOut adminFeeReportDays(from, to)

Fee Report Days

The fee report on screen (9.2): the same days as the CSV, in paise. Not logged (no file leaves the panel).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminFeeReportDays(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminFeeReportDays: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**FeeReportOut**](FeeReportOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminFilesUploadUrl**
> UploadUrlOut adminFilesUploadUrl(uploadUrlIn)

Upload Url

Step 1 of an upload: get a short-lived URL to PUT the file to.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final UploadUrlIn uploadUrlIn = ; // UploadUrlIn | 

try {
    final response = api.adminFilesUploadUrl(uploadUrlIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminFilesUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadUrlIn** | [**UploadUrlIn**](UploadUrlIn.md)|  | 

### Return type

[**UploadUrlOut**](UploadUrlOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsActivate**
> HospitalOut adminHospitalsActivate(hospitalId)

Activate Hospital

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminHospitalsActivate(hospitalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsActivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalId** | **String**|  | 

### Return type

[**HospitalOut**](HospitalOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsCreate**
> HospitalOut adminHospitalsCreate(hospitalIn)

Create Hospital

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final HospitalIn hospitalIn = ; // HospitalIn | 

try {
    final response = api.adminHospitalsCreate(hospitalIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalIn** | [**HospitalIn**](HospitalIn.md)|  | 

### Return type

[**HospitalOut**](HospitalOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsDeactivate**
> HospitalOut adminHospitalsDeactivate(hospitalId)

Deactivate Hospital

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminHospitalsDeactivate(hospitalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalId** | **String**|  | 

### Return type

[**HospitalOut**](HospitalOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsDelete**
> OkOut adminHospitalsDelete(hospitalId)

Delete Hospital

Refused (409 IN_USE) if used in a booking or doctors are listed there.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminHospitalsDelete(hospitalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsList**
> List<HospitalOut> adminHospitalsList(q)

List Hospitals

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String q = q_example; // String | 

try {
    final response = api.adminHospitalsList(q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] [default to '']

### Return type

[**List&lt;HospitalOut&gt;**](HospitalOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminHospitalsUpdate**
> HospitalOut adminHospitalsUpdate(hospitalId, hospitalIn)

Update Hospital

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final HospitalIn hospitalIn = ; // HospitalIn | 

try {
    final response = api.adminHospitalsUpdate(hospitalId, hospitalIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminHospitalsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalId** | **String**|  | 
 **hospitalIn** | [**HospitalIn**](HospitalIn.md)|  | 

### Return type

[**HospitalOut**](HospitalOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLegalGet**
> LegalDocumentOut adminLegalGet(kind)

Legal Get

The newest version, to edit.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String kind = kind_example; // String | 

try {
    final response = api.adminLegalGet(kind);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLegalGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 

### Return type

[**LegalDocumentOut**](LegalDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLegalList**
> List<LegalSummaryOut> adminLegalList()

Legal List

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminLegalList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLegalList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;LegalSummaryOut&gt;**](LegalSummaryOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLegalPublish**
> LegalDocumentOut adminLegalPublish(kind, legalPublishIn)

Legal Publish

Publish a new version: a small fix (nobody is asked again) or `askAgain` (everyone accepts it again at their next app open). Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String kind = kind_example; // String | 
final LegalPublishIn legalPublishIn = ; // LegalPublishIn | 

try {
    final response = api.adminLegalPublish(kind, legalPublishIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLegalPublish: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 
 **legalPublishIn** | [**LegalPublishIn**](LegalPublishIn.md)|  | 

### Return type

[**LegalDocumentOut**](LegalDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLegalVersion**
> LegalDocumentOut adminLegalVersion(kind, version)

Legal Version

An old version, read-only (which text someone accepted).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String kind = kind_example; // String | 
final int version = 56; // int | 

try {
    final response = api.adminLegalVersion(kind, version);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLegalVersion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 
 **version** | **int**|  | 

### Return type

[**LegalDocumentOut**](LegalDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLegalVersions**
> List<LegalVersionOut> adminLegalVersions(kind)

Legal Versions

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String kind = kind_example; // String | 

try {
    final response = api.adminLegalVersions(kind);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLegalVersions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 

### Return type

[**List&lt;LegalVersionOut&gt;**](LegalVersionOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLiveJobs**
> List<LiveJobOut> adminLiveJobs()

Live

Every job in progress with the partner's latest point (`stale`: none for 2 minutes).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminLiveJobs();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminLiveJobs: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;LiveJobOut&gt;**](LiveJobOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminMeGet**
> StaffMeOut adminMeGet()

Me

The signed-in staff member and their permissions (the panel builds its menu from them).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminMeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StaffMeOut**](StaffMeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerDeactivate**
> PartnerDetailOut adminPartnerDeactivate(partnerId, reasonIn)

Deactivate

The partner left or was removed. Their history stays.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReasonIn reasonIn = ; // ReasonIn | 

try {
    final response = api.adminPartnerDeactivate(partnerId, reasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 
 **reasonIn** | [**ReasonIn**](ReasonIn.md)|  | 

### Return type

[**PartnerDetailOut**](PartnerDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerDocumentApprove**
> DocumentOut adminPartnerDocumentApprove(documentId)

Document Approve

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPartnerDocumentApprove(documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerDocumentApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  | 

### Return type

[**DocumentOut**](DocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerDocumentReject**
> DocumentOut adminPartnerDocumentReject(documentId, rejectDocumentIn)

Document Reject

The reason is shown to the partner.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RejectDocumentIn rejectDocumentIn = ; // RejectDocumentIn | 

try {
    final response = api.adminPartnerDocumentReject(documentId, rejectDocumentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerDocumentReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  | 
 **rejectDocumentIn** | [**RejectDocumentIn**](RejectDocumentIn.md)|  | 

### Return type

[**DocumentOut**](DocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerDocumentView**
> ViewUrlOut adminPartnerDocumentView(documentId)

Document View

A 5-minute link. Every view is in the audit log.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPartnerDocumentView(documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerDocumentView: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  | 

### Return type

[**ViewUrlOut**](ViewUrlOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerForceLogout**
> OkOut adminPartnerForceLogout(partnerId)

Force Logout

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPartnerForceLogout(partnerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerForceLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerGet**
> PartnerDetailOut adminPartnerGet(partnerId)

Get Partner

Profile, both phones, email, documents (with history), application and status history.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPartnerGet(partnerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 

### Return type

[**PartnerDetailOut**](PartnerDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerPerformanceReport**
> PartnerPerformanceOut adminPartnerPerformanceReport(from, to)

Partner Performance

Each approved partner (and anyone else with work then): jobs done, patient not available, offers received / accepted / declined / not answered, acceptance %, rating. Default: this month so far.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminPartnerPerformanceReport(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerPerformanceReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**PartnerPerformanceOut**](PartnerPerformanceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerPerformanceReportCsv**
> String adminPartnerPerformanceReportCsv(from, to)

Partner Performance Csv

The partner performance report as a CSV file. Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.adminPartnerPerformanceReportCsv(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerPerformanceReportCsv: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

**String**

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerReinstate**
> PartnerDetailOut adminPartnerReinstate(partnerId)

Reinstate

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPartnerReinstate(partnerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerReinstate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 

### Return type

[**PartnerDetailOut**](PartnerDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerSuspend**
> PartnerDetailOut adminPartnerSuspend(partnerId, reasonIn)

Suspend

Logged out at once on their phone.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReasonIn reasonIn = ; // ReasonIn | 

try {
    final response = api.adminPartnerSuspend(partnerId, reasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerSuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 
 **reasonIn** | [**ReasonIn**](ReasonIn.md)|  | 

### Return type

[**PartnerDetailOut**](PartnerDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnerUpdate**
> PartnerDetailOut adminPartnerUpdate(partnerId, partnerEditIn)

Update Partner

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PartnerEditIn partnerEditIn = ; // PartnerEditIn | 

try {
    final response = api.adminPartnerUpdate(partnerId, partnerEditIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerId** | **String**|  | 
 **partnerEditIn** | [**PartnerEditIn**](PartnerEditIn.md)|  | 

### Return type

[**PartnerDetailOut**](PartnerDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersAdd**
> PartnerProfileOut adminPartnersAdd(addPartnerIn)

Add Partner

Saved APPROVED. Upload the photo and documents first (`/admin/files/upload-url`).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final AddPartnerIn addPartnerIn = ; // AddPartnerIn | 

try {
    final response = api.adminPartnersAdd(addPartnerIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnersAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addPartnerIn** | [**AddPartnerIn**](AddPartnerIn.md)|  | 

### Return type

[**PartnerProfileOut**](PartnerProfileOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersList**
> PagedPartnerRowOut adminPartnersList(role, status, available, q, toReview, page, pageSize)

List Partners

Newest first. `toReview` = approved partners with an upload waiting (renewals).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String role = role_example; // String | 
final String status = status_example; // String | 
final bool available = true; // bool | 
final String q = q_example; // String | 
final bool toReview = true; // bool | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminPartnersList(role, status, available, q, toReview, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPartnersList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**|  | [optional] [default to '']
 **status** | **String**|  | [optional] [default to '']
 **available** | **bool**|  | [optional] 
 **q** | **String**|  | [optional] [default to '']
 **toReview** | **bool**|  | [optional] [default to false]
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedPartnerRowOut**](PagedPartnerRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientBlock**
> PatientDetailOut adminPatientBlock(userId, patientReasonIn)

Block

Abuse (§9.1): logged out of the patient app on every phone at once and its login refused (\"This account is blocked\") until unblocked. The partner app is not touched. Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PatientReasonIn patientReasonIn = ; // PatientReasonIn | 

try {
    final response = api.adminPatientBlock(userId, patientReasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientBlock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **patientReasonIn** | [**PatientReasonIn**](PatientReasonIn.md)|  | 

### Return type

[**PatientDetailOut**](PatientDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientDocumentViewUrl**
> ViewUrlOut adminPatientDocumentViewUrl(userId, documentId, documentReasonIn)

View Document

Open a patient's document: a reason is required and the view is audit-logged (§9.1).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DocumentReasonIn documentReasonIn = ; // DocumentReasonIn | 

try {
    final response = api.adminPatientDocumentViewUrl(userId, documentId, documentReasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientDocumentViewUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **documentId** | **String**|  | 
 **documentReasonIn** | [**DocumentReasonIn**](DocumentReasonIn.md)|  | 

### Return type

[**ViewUrlOut**](ViewUrlOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientGet**
> PatientDetailOut adminPatientGet(userId)

Get Patient

The account, its family members (removed ones too), addresses and, for roles that may open them, documents (titles only). Payments are added in Phase 6.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminPatientGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**PatientDetailOut**](PatientDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientRequestDeletion**
> PatientDetailOut adminPatientRequestDeletion(userId, patientReasonIn)

Request Deletion

A patient who asks by phone to delete their account: the same as in the app (409 ACTIVE_BOOKINGS while a paid booking isn't finished; logged out at once; erased after the waiting time unless they log in again). Logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PatientReasonIn patientReasonIn = ; // PatientReasonIn | 

try {
    final response = api.adminPatientRequestDeletion(userId, patientReasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientRequestDeletion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **patientReasonIn** | [**PatientReasonIn**](PatientReasonIn.md)|  | 

### Return type

[**PatientDetailOut**](PatientDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientUnblock**
> PatientDetailOut adminPatientUnblock(userId, patientReasonIn)

Unblock

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PatientReasonIn patientReasonIn = ; // PatientReasonIn | 

try {
    final response = api.adminPatientUnblock(userId, patientReasonIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientUnblock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **patientReasonIn** | [**PatientReasonIn**](PatientReasonIn.md)|  | 

### Return type

[**PatientDetailOut**](PatientDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientUpdate**
> PatientDetailOut adminPatientUpdate(userId, adminPatientIn)

Update

Only on the patient's request (§9.1): name, date of birth, gender, app language (the profile screen's details; the phone number is the login and can't change here). Logged with the reason and what changed.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminPatientIn adminPatientIn = ; // AdminPatientIn | 

try {
    final response = api.adminPatientUpdate(userId, adminPatientIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **adminPatientIn** | [**AdminPatientIn**](AdminPatientIn.md)|  | 

### Return type

[**PatientDetailOut**](PatientDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPatientsList**
> PagedPatientRowOut adminPatientsList(q, page, pageSize)

List Patients

Newest first. `q`: name, or at least 4 digits of the phone.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String q = q_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminPatientsList(q, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPatientsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] [default to '']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedPatientRowOut**](PagedPatientRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPaymentKeysGet**
> GatewayKeysOut adminPaymentKeysGet()

Get Keys

Which Razorpay keys are in use (secrets never shown, only their last 4 characters).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminPaymentKeysGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPaymentKeysGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GatewayKeysOut**](GatewayKeysOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPaymentKeysSave**
> GatewayKeysOut adminPaymentKeysSave(gatewayKeysIn)

Save Keys

Save the Razorpay key id and secrets (stored encrypted; blank secret = keep the saved one; a new key id needs its secret). Logged without the values.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final GatewayKeysIn gatewayKeysIn = ; // GatewayKeysIn | 

try {
    final response = api.adminPaymentKeysSave(gatewayKeysIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPaymentKeysSave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gatewayKeysIn** | [**GatewayKeysIn**](GatewayKeysIn.md)|  | 

### Return type

[**GatewayKeysOut**](GatewayKeysOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPaymentList**
> PagedAdminPaymentOut adminPaymentList(status, q, page, pageSize)

List Payments

Booking-fee payments, newest first. `q`: booking code, Razorpay order or payment id.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final String q = q_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminPaymentList(status, q, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPaymentList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **q** | **String**|  | [optional] [default to '']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminPaymentOut**](PagedAdminPaymentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminQueueCounts**
> QueueCountsOut adminQueueCounts()

Queue Counts

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminQueueCounts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminQueueCounts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**QueueCountsOut**](QueueCountsOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminQueueList**
> PagedQueueRowOut adminQueueList(when_, page, pageSize)

Queue

Paid bookings without a partner yet (NEW, or OFFERED and waiting), soonest first. `late` = past the assign deadline (red).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String when_ = when__example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminQueueList(when_, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminQueueList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **when_** | **String**|  | [optional] [default to 'all']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedQueueRowOut**](PagedQueueRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRecoveryCodesCreate**
> RecoveryCodesOut adminRecoveryCodesCreate(recoveryCodesIn)

Recovery Codes

10 new recovery codes, shown once; the old ones stop working (v2.16). Needs the password (422 WRONG_PASSWORD).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final RecoveryCodesIn recoveryCodesIn = ; // RecoveryCodesIn | 

try {
    final response = api.adminRecoveryCodesCreate(recoveryCodesIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRecoveryCodesCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recoveryCodesIn** | [**RecoveryCodesIn**](RecoveryCodesIn.md)|  | 

### Return type

[**RecoveryCodesOut**](RecoveryCodesOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRecoveryCodesSaved**
> StaffMeOut adminRecoveryCodesSaved()

Recovery Codes Saved

The admin says \"I've saved them\" after the codes were shown (at 2FA setup, or new ones). Until then `/me` has `recoveryCodesSaved: false` and the panel warns.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminRecoveryCodesSaved();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRecoveryCodesSaved: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StaffMeOut**](StaffMeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundApprove**
> AdminRefundOut adminRefundApprove(refundId, refundDecisionIn)

Approve Refund

Finance approves a refund above the limit: it is sent to Razorpay (logged).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundDecisionIn refundDecisionIn = ; // RefundDecisionIn | 

try {
    final response = api.adminRefundApprove(refundId, refundDecisionIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRefundApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 
 **refundDecisionIn** | [**RefundDecisionIn**](RefundDecisionIn.md)|  | 

### Return type

[**AdminRefundOut**](AdminRefundOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundList**
> PagedAdminRefundOut adminRefundList(status, page, pageSize)

List Refunds

Refunds, newest first. AWAITING_APPROVAL: above the limit, waiting for Finance.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminRefundList(status, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRefundList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminRefundOut**](PagedAdminRefundOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundReject**
> AdminRefundOut adminRefundReject(refundId, refundDecisionIn)

Reject Refund

Finance refuses a refund above the limit, with a reason (logged).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundDecisionIn refundDecisionIn = ; // RefundDecisionIn | 

try {
    final response = api.adminRefundReject(refundId, refundDecisionIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRefundReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 
 **refundDecisionIn** | [**RefundDecisionIn**](RefundDecisionIn.md)|  | 

### Return type

[**AdminRefundOut**](AdminRefundOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRefundRetry**
> AdminRefundOut adminRefundRetry(refundId, refundDecisionIn)

Retry Refund

A refund Razorpay refused or failed: send it again, with a note (logged).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RefundDecisionIn refundDecisionIn = ; // RefundDecisionIn | 

try {
    final response = api.adminRefundRetry(refundId, refundDecisionIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRefundRetry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  | 
 **refundDecisionIn** | [**RefundDecisionIn**](RefundDecisionIn.md)|  | 

### Return type

[**AdminRefundOut**](AdminRefundOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequiredDocumentsCreate**
> RequiredDocumentOut adminRequiredDocumentsCreate(requiredDocumentIn)

Create Required

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final RequiredDocumentIn requiredDocumentIn = ; // RequiredDocumentIn | 

try {
    final response = api.adminRequiredDocumentsCreate(requiredDocumentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequiredDocumentsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requiredDocumentIn** | [**RequiredDocumentIn**](RequiredDocumentIn.md)|  | 

### Return type

[**RequiredDocumentOut**](RequiredDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequiredDocumentsDelete**
> OkOut adminRequiredDocumentsDelete(requiredId)

Delete Required

Refused (409 IN_USE) once partners uploaded it: turn it off instead.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String requiredId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminRequiredDocumentsDelete(requiredId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequiredDocumentsDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requiredId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequiredDocumentsList**
> List<RequiredDocumentOut> adminRequiredDocumentsList()

List Required

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminRequiredDocumentsList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequiredDocumentsList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;RequiredDocumentOut&gt;**](RequiredDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequiredDocumentsUpdate**
> RequiredDocumentOut adminRequiredDocumentsUpdate(requiredId, requiredDocumentIn)

Update Required

Role and type can't change (add a new row instead).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String requiredId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RequiredDocumentIn requiredDocumentIn = ; // RequiredDocumentIn | 

try {
    final response = api.adminRequiredDocumentsUpdate(requiredId, requiredDocumentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequiredDocumentsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requiredId** | **String**|  | 
 **requiredDocumentIn** | [**RequiredDocumentIn**](RequiredDocumentIn.md)|  | 

### Return type

[**RequiredDocumentOut**](RequiredDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReviewHide**
> AdminReviewOut adminReviewHide(reviewId, reviewModerateIn)

Hide

Hidden, never deleted; the partner's average leaves it out.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReviewModerateIn reviewModerateIn = ; // ReviewModerateIn | 

try {
    final response = api.adminReviewHide(reviewId, reviewModerateIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReviewHide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  | 
 **reviewModerateIn** | [**ReviewModerateIn**](ReviewModerateIn.md)|  | 

### Return type

[**AdminReviewOut**](AdminReviewOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReviewShow**
> AdminReviewOut adminReviewShow(reviewId, reviewModerateIn)

Show

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReviewModerateIn reviewModerateIn = ; // ReviewModerateIn | 

try {
    final response = api.adminReviewShow(reviewId, reviewModerateIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReviewShow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  | 
 **reviewModerateIn** | [**ReviewModerateIn**](ReviewModerateIn.md)|  | 

### Return type

[**AdminReviewOut**](AdminReviewOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReviews**
> PagedAdminReviewOut adminReviews(status, page, pageSize)

Reviews

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminReviews(status, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'all']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminReviewOut**](PagedAdminReviewOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRolesList**
> RolesOut adminRolesList()

Roles

The five admin roles and what each can do (§9.2). Read-only.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminRolesList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRolesList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RolesOut**](RolesOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSelfiesList**
> PagedAdminSelfieOut adminSelfiesList(date, partnerId, page, pageSize)

List Selfies

Spot checks (§6.15): the day's selfies (India date, today by default), newest first, next to each partner's approved photo.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final DateTime date = 2013-10-20; // DateTime | 
final String partnerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminSelfiesList(date, partnerId, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSelfiesList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**|  | [optional] 
 **partnerId** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminSelfieOut**](PagedAdminSelfieOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasActivate**
> ServiceAreaOut adminServiceAreasActivate(areaId)

Activate Area

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String areaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServiceAreasActivate(areaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasActivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  | 

### Return type

[**ServiceAreaOut**](ServiceAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasCheck**
> InsideAreaOut adminServiceAreasCheck(lat, lng)

Check Point

Is this point inside an active service area? (bookings outside are refused)

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final num lat = 8.14; // num | 
final num lng = 8.14; // num | 

try {
    final response = api.adminServiceAreasCheck(lat, lng);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasCheck: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **num**|  | 
 **lng** | **num**|  | 

### Return type

[**InsideAreaOut**](InsideAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasCreate**
> ServiceAreaOut adminServiceAreasCreate(serviceAreaIn)

Create Area

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final ServiceAreaIn serviceAreaIn = ; // ServiceAreaIn | 

try {
    final response = api.adminServiceAreasCreate(serviceAreaIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceAreaIn** | [**ServiceAreaIn**](ServiceAreaIn.md)|  | 

### Return type

[**ServiceAreaOut**](ServiceAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasDeactivate**
> ServiceAreaOut adminServiceAreasDeactivate(areaId)

Deactivate Area

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String areaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServiceAreasDeactivate(areaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  | 

### Return type

[**ServiceAreaOut**](ServiceAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasDelete**
> OkOut adminServiceAreasDelete(areaId)

Delete Area

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String areaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServiceAreasDelete(areaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasList**
> List<ServiceAreaOut> adminServiceAreasList()

List Areas

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminServiceAreasList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;ServiceAreaOut&gt;**](ServiceAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServiceAreasUpdate**
> ServiceAreaOut adminServiceAreasUpdate(areaId, serviceAreaIn)

Update Area

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String areaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ServiceAreaIn serviceAreaIn = ; // ServiceAreaIn | 

try {
    final response = api.adminServiceAreasUpdate(areaId, serviceAreaIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServiceAreasUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **areaId** | **String**|  | 
 **serviceAreaIn** | [**ServiceAreaIn**](ServiceAreaIn.md)|  | 

### Return type

[**ServiceAreaOut**](ServiceAreaOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesActivate**
> ServiceOut adminServicesActivate(serviceId)

Activate Service

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String serviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServicesActivate(serviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesActivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**|  | 

### Return type

[**ServiceOut**](ServiceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesCreate**
> ServiceOut adminServicesCreate(serviceIn)

Create Service

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final ServiceIn serviceIn = ; // ServiceIn | 

try {
    final response = api.adminServicesCreate(serviceIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceIn** | [**ServiceIn**](ServiceIn.md)|  | 

### Return type

[**ServiceOut**](ServiceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesDeactivate**
> ServiceOut adminServicesDeactivate(serviceId)

Deactivate Service

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String serviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServicesDeactivate(serviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesDeactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**|  | 

### Return type

[**ServiceOut**](ServiceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesDelete**
> OkOut adminServicesDelete(serviceId)

Delete Service

Refused (409 IN_USE) once the service has been booked: deactivate it instead.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String serviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminServicesDelete(serviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesList**
> List<ServiceOut> adminServicesList()

List Services

All services, active and inactive, in display order.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminServicesList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;ServiceOut&gt;**](ServiceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesReorder**
> OkOut adminServicesReorder(reorderIn)

Reorder Services

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final ReorderIn reorderIn = ; // ReorderIn | 

try {
    final response = api.adminServicesReorder(reorderIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesReorder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reorderIn** | [**ReorderIn**](ReorderIn.md)|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminServicesUpdate**
> ServiceOut adminServicesUpdate(serviceId, serviceIn)

Update Service

New prices apply to new bookings only.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String serviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ServiceIn serviceIn = ; // ServiceIn | 

try {
    final response = api.adminServicesUpdate(serviceId, serviceIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminServicesUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**|  | 
 **serviceIn** | [**ServiceIn**](ServiceIn.md)|  | 

### Return type

[**ServiceOut**](ServiceOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSettingsGet**
> SettingsOut adminSettingsGet()

Get Settings

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminSettingsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSettingsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SettingsOut**](SettingsOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSettingsUpdate**
> SettingsOut adminSettingsUpdate(settingsIn)

Update Settings

Only the keys sent are changed. 422 INVALID_SETTINGS lists the bad fields.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final SettingsIn settingsIn = ; // SettingsIn | 

try {
    final response = api.adminSettingsUpdate(settingsIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSettingsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **settingsIn** | [**SettingsIn**](SettingsIn.md)|  | 

### Return type

[**SettingsOut**](SettingsOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSosAck**
> AdminSosOut adminSosAck(sosId)

Sos Ack

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String sosId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminSosAck(sosId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSosAck: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sosId** | **String**|  | 

### Return type

[**AdminSosOut**](AdminSosOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSosList**
> PagedAdminSosOut adminSosList(status, page, pageSize)

Sos List

`active`: open and acknowledged (newest first); `all` includes resolved ones.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminSosList(status, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSosList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'active']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminSosOut**](PagedAdminSosOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSosResolve**
> AdminSosOut adminSosResolve(sosId, sosResolveIn)

Sos Resolve

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String sosId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SosResolveIn sosResolveIn = ; // SosResolveIn | 

try {
    final response = api.adminSosResolve(sosId, sosResolveIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSosResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sosId** | **String**|  | 
 **sosResolveIn** | [**SosResolveIn**](SosResolveIn.md)|  | 

### Return type

[**AdminSosOut**](AdminSosOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSpecialitiesCreate**
> SpecialityOut adminSpecialitiesCreate(specialityIn)

Create Speciality

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final SpecialityIn specialityIn = ; // SpecialityIn | 

try {
    final response = api.adminSpecialitiesCreate(specialityIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSpecialitiesCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **specialityIn** | [**SpecialityIn**](SpecialityIn.md)|  | 

### Return type

[**SpecialityOut**](SpecialityOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSpecialitiesDelete**
> OkOut adminSpecialitiesDelete(specialityId)

Delete Speciality

Refused (409 IN_USE) while a doctor has this speciality.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String specialityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminSpecialitiesDelete(specialityId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSpecialitiesDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **specialityId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSpecialitiesList**
> List<SpecialityOut> adminSpecialitiesList()

List Specialities

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminSpecialitiesList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSpecialitiesList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;SpecialityOut&gt;**](SpecialityOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSpecialitiesUpdate**
> SpecialityOut adminSpecialitiesUpdate(specialityId, specialityIn)

Update Speciality

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String specialityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SpecialityIn specialityIn = ; // SpecialityIn | 

try {
    final response = api.adminSpecialitiesUpdate(specialityId, specialityIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSpecialitiesUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **specialityId** | **String**|  | 
 **specialityIn** | [**SpecialityIn**](SpecialityIn.md)|  | 

### Return type

[**SpecialityOut**](SpecialityOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersCreate**
> StaffUserOut adminStaffUsersCreate(staffUserCreateIn)

Create Staff User

They set up the authenticator at their first sign-in.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final StaffUserCreateIn staffUserCreateIn = ; // StaffUserCreateIn | 

try {
    final response = api.adminStaffUsersCreate(staffUserCreateIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffUserCreateIn** | [**StaffUserCreateIn**](StaffUserCreateIn.md)|  | 

### Return type

[**StaffUserOut**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersDisable**
> StaffUserOut adminStaffUsersDisable(staffId)

Disable Staff User

Signs them out at once. Not yourself, and not the last Super Admin.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminStaffUsersDisable(staffId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersDisable: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 

### Return type

[**StaffUserOut**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersEnable**
> StaffUserOut adminStaffUsersEnable(staffId)

Enable Staff User

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminStaffUsersEnable(staffId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersEnable: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 

### Return type

[**StaffUserOut**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersForceLogout**
> ForceLogoutOut adminStaffUsersForceLogout(staffId)

Force Logout

Sign them out on every device.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminStaffUsersForceLogout(staffId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersForceLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 

### Return type

[**ForceLogoutOut**](ForceLogoutOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersList**
> List<StaffUserOut> adminStaffUsersList()

List Staff Users

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();

try {
    final response = api.adminStaffUsersList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;StaffUserOut&gt;**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersReset2fa**
> StaffUserOut adminStaffUsersReset2fa(staffId)

Reset 2Fa

Lost phone: they scan a new QR code at the next sign-in. Signs them out.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminStaffUsersReset2fa(staffId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersReset2fa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 

### Return type

[**StaffUserOut**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersSetPassword**
> OkOut adminStaffUsersSetPassword(staffId, staffPasswordIn)

Set Password

Forgotten password: set a new one (min 12 characters). Signs them out.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StaffPasswordIn staffPasswordIn = ; // StaffPasswordIn | 

try {
    final response = api.adminStaffUsersSetPassword(staffId, staffPasswordIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersSetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 
 **staffPasswordIn** | [**StaffPasswordIn**](StaffPasswordIn.md)|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminStaffUsersUpdate**
> StaffUserOut adminStaffUsersUpdate(staffId, staffUserUpdateIn)

Update Staff User

Name and role. You can't change your own role; one active Super Admin must remain.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StaffUserUpdateIn staffUserUpdateIn = ; // StaffUserUpdateIn | 

try {
    final response = api.adminStaffUsersUpdate(staffId, staffUserUpdateIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminStaffUsersUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 
 **staffUserUpdateIn** | [**StaffUserUpdateIn**](StaffUserUpdateIn.md)|  | 

### Return type

[**StaffUserOut**](StaffUserOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminTicketClose**
> AdminTicketOut adminTicketClose(ticketId)

Close

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminTicketClose(ticketId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminTicketClose: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 

### Return type

[**AdminTicketOut**](AdminTicketOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminTicketReply**
> AdminTicketOut adminTicketReply(ticketId, ticketReplyIn)

Reply

The family gets a message with the reply.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String ticketId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TicketReplyIn ticketReplyIn = ; // TicketReplyIn | 

try {
    final response = api.adminTicketReply(ticketId, ticketReplyIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminTicketReply: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ticketId** | **String**|  | 
 **ticketReplyIn** | [**TicketReplyIn**](TicketReplyIn.md)|  | 

### Return type

[**AdminTicketOut**](AdminTicketOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminTickets**
> PagedAdminTicketOut adminTickets(status, page, pageSize)

Tickets

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAdminApi();
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.adminTickets(status, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'open']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedAdminTicketOut**](PagedAdminTicketOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

