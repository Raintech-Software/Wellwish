# ww_api.api.PatientApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**patientAddressAdd**](PatientApi.md#patientaddressadd) | **POST** /v1/patient/addresses | Add Address
[**patientAddressList**](PatientApi.md#patientaddresslist) | **GET** /v1/patient/addresses | List Addresses
[**patientAddressRemove**](PatientApi.md#patientaddressremove) | **DELETE** /v1/patient/addresses/{address_id} | Remove Address
[**patientAddressUpdate**](PatientApi.md#patientaddressupdate) | **PUT** /v1/patient/addresses/{address_id} | Update Address
[**patientBook**](PatientApi.md#patientbook) | **POST** /v1/patient/bookings | Book
[**patientBookingCancel**](PatientApi.md#patientbookingcancel) | **POST** /v1/patient/bookings/{booking_id}/cancel | Cancel
[**patientBookingCancelPreview**](PatientApi.md#patientbookingcancelpreview) | **GET** /v1/patient/bookings/{booking_id}/cancel-preview | Cancel Preview
[**patientBookingCheckout**](PatientApi.md#patientbookingcheckout) | **POST** /v1/patient/bookings/{booking_id}/checkout | Checkout
[**patientBookingGet**](PatientApi.md#patientbookingget) | **GET** /v1/patient/bookings/{booking_id} | Get Booking
[**patientBookingList**](PatientApi.md#patientbookinglist) | **GET** /v1/patient/bookings | List Bookings
[**patientBookingLive**](PatientApi.md#patientbookinglive) | **GET** /v1/patient/bookings/{booking_id}/live | Live
[**patientBookingReschedule**](PatientApi.md#patientbookingreschedule) | **POST** /v1/patient/bookings/{booking_id}/reschedule | Reschedule
[**patientBookingRescheduleTimes**](PatientApi.md#patientbookingrescheduletimes) | **GET** /v1/patient/bookings/{booking_id}/reschedule-times | Reschedule Times
[**patientBookingTimes**](PatientApi.md#patientbookingtimes) | **GET** /v1/patient/booking-times | Booking Times
[**patientConsentsAccept**](PatientApi.md#patientconsentsaccept) | **POST** /v1/patient/me/consents | Accept Consents
[**patientDeleteAccount**](PatientApi.md#patientdeleteaccount) | **POST** /v1/patient/me/delete-request | Delete Account
[**patientDeviceRegister**](PatientApi.md#patientdeviceregister) | **PUT** /v1/patient/me/device | Register Device
[**patientDoctorGet**](PatientApi.md#patientdoctorget) | **GET** /v1/patient/doctors/{doctor_id} | Doctor Detail
[**patientDoctorList**](PatientApi.md#patientdoctorlist) | **GET** /v1/patient/doctors | Doctors
[**patientDocumentAdd**](PatientApi.md#patientdocumentadd) | **POST** /v1/patient/documents | Add Document
[**patientDocumentDelete**](PatientApi.md#patientdocumentdelete) | **DELETE** /v1/patient/documents/{document_id} | Delete Document
[**patientDocumentList**](PatientApi.md#patientdocumentlist) | **GET** /v1/patient/documents | List Documents
[**patientDocumentStorage**](PatientApi.md#patientdocumentstorage) | **GET** /v1/patient/documents/storage | Storage
[**patientDocumentUploadUrl**](PatientApi.md#patientdocumentuploadurl) | **POST** /v1/patient/documents/upload-url | Upload Url
[**patientDocumentViewUrl**](PatientApi.md#patientdocumentviewurl) | **GET** /v1/patient/documents/{document_id}/view-url | View Url
[**patientHospitalGet**](PatientApi.md#patienthospitalget) | **GET** /v1/patient/hospitals/{hospital_id} | Hospital Detail
[**patientHospitalsNearby**](PatientApi.md#patienthospitalsnearby) | **GET** /v1/patient/hospitals/nearby | Nearby
[**patientMeGet**](PatientApi.md#patientmeget) | **GET** /v1/patient/me | Get Me
[**patientMeUpdate**](PatientApi.md#patientmeupdate) | **PUT** /v1/patient/me | Update Me
[**patientMemberAdd**](PatientApi.md#patientmemberadd) | **POST** /v1/patient/members | Add Member
[**patientMemberGet**](PatientApi.md#patientmemberget) | **GET** /v1/patient/members/{member_id} | Get Member
[**patientMemberList**](PatientApi.md#patientmemberlist) | **GET** /v1/patient/members | List Members
[**patientMemberPhotoUploadUrl**](PatientApi.md#patientmemberphotouploadurl) | **POST** /v1/patient/members/photo-upload-url | Photo Upload Url
[**patientMemberRemove**](PatientApi.md#patientmemberremove) | **DELETE** /v1/patient/members/{member_id} | Remove Member
[**patientMemberUpdate**](PatientApi.md#patientmemberupdate) | **PUT** /v1/patient/members/{member_id} | Update Member
[**patientNotificationsList**](PatientApi.md#patientnotificationslist) | **GET** /v1/patient/notifications | List Notifications
[**patientNotificationsRead**](PatientApi.md#patientnotificationsread) | **POST** /v1/patient/notifications/read | Mark Read
[**patientNotificationsUnread**](PatientApi.md#patientnotificationsunread) | **GET** /v1/patient/notifications/unread-count | Unread Count
[**patientPaymentVerify**](PatientApi.md#patientpaymentverify) | **POST** /v1/patient/payments/verify | Verify
[**patientReportProblem**](PatientApi.md#patientreportproblem) | **POST** /v1/patient/bookings/{booking_id}/report-problem | Report Problem
[**patientReview**](PatientApi.md#patientreview) | **POST** /v1/patient/bookings/{booking_id}/review | Review
[**patientShareLink**](PatientApi.md#patientsharelink) | **POST** /v1/patient/bookings/{booking_id}/share-link | Share Link
[**patientSos**](PatientApi.md#patientsos) | **POST** /v1/patient/bookings/{booking_id}/sos | Sos


# **patientAddressAdd**
> AddressOut patientAddressAdd(addressIn)

Add Address

Save an address for a family member (or yourself). `inServiceArea` says whether WellWish serves it.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final AddressIn addressIn = ; // AddressIn | 

try {
    final response = api.patientAddressAdd(addressIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientAddressAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressIn** | [**AddressIn**](AddressIn.md)|  | 

### Return type

[**AddressOut**](AddressOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientAddressList**
> List<AddressOut> patientAddressList(memberId)

List Addresses

Your saved addresses (`memberId` → only that family member's).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String memberId = memberId_example; // String | 

try {
    final response = api.patientAddressList(memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientAddressList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **String**|  | [optional] 

### Return type

[**List&lt;AddressOut&gt;**](AddressOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientAddressRemove**
> OkOut patientAddressRemove(addressId)

Remove Address

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String addressId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientAddressRemove(addressId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientAddressRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientAddressUpdate**
> AddressOut patientAddressUpdate(addressId, addressIn)

Update Address

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String addressId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AddressIn addressIn = ; // AddressIn | 

try {
    final response = api.patientAddressUpdate(addressId, addressIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientAddressUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **String**|  | 
 **addressIn** | [**AddressIn**](AddressIn.md)|  | 

### Return type

[**AddressOut**](AddressOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBook**
> BookingDetailOut patientBook(idempotencyKey, bookingIn)

Book

\"Book\" on Review (P15). Checks the member and address are yours, the address is inside a service area, the time is still allowed and a prescription is attached when the service needs one. Saved as PENDING_PAYMENT with the price, member and address as they are now.  `Idempotency-Key` (8 to 64 letters, digits, - or _), made once per Review screen: sending the same key again returns the same booking, so a double tap or a retry never books twice. Errors: 409 TIME_NOT_AVAILABLE (reload the times), 422 PRESCRIPTION_REQUIRED, 422 OUTSIDE_SERVICE_AREA, 422 INVALID_BOOKING (`details.field`), 429 TOO_MANY_UNPAID.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String idempotencyKey = idempotencyKey_example; // String | 
final BookingIn bookingIn = ; // BookingIn | 

try {
    final response = api.patientBook(idempotencyKey, bookingIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBook: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  | 
 **bookingIn** | [**BookingIn**](BookingIn.md)|  | 

### Return type

[**BookingDetailOut**](BookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingCancel**
> BookingDetailOut patientBookingCancel(bookingId, cancelIn)

Cancel

Cancel before the partner is on the way. The setting's share of the booking fee (50 %) is refunded to the original payment method. 409 CANCEL_NOT_ALLOWED after that.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CancelIn cancelIn = ; // CancelIn | 

try {
    final response = api.patientBookingCancel(bookingId, cancelIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingCancel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **cancelIn** | [**CancelIn**](CancelIn.md)|  | 

### Return type

[**BookingDetailOut**](BookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingCancelPreview**
> CancelPreviewOut patientBookingCancelPreview(bookingId)

Cancel Preview

W-P4: \"You'll get back ₹50 (50% of the booking fee)\". `allowed` false once the partner is on the way (then the patient calls support).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientBookingCancelPreview(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingCancelPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**CancelPreviewOut**](CancelPreviewOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingCheckout**
> CheckoutOut patientBookingCheckout(bookingId)

Checkout

The Razorpay order to pay this booking's fee with (P15 \"Pay ₹X\", or \"Pay now\" on the booking). The same open order is returned again on a retry. 409 BOOKING_NOT_PAYABLE after the payment time; 503 PAYMENTS_NOT_SET_UP before the keys are entered.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientBookingCheckout(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingCheckout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**CheckoutOut**](CheckoutOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingGet**
> BookingDetailOut patientBookingGet(bookingId)

Get Booking

P18: the booking with its timeline (the partner, OTP and live map come later).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientBookingGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**BookingDetailOut**](BookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingList**
> PagedBookingRowOut patientBookingList(bucket, page, pageSize)

List Bookings

P17: `upcoming` (soonest first: waiting for payment, being assigned, assigned), `ongoing` (in progress) or `past` (latest first: completed, cancelled, expired).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bucket = bucket_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.patientBookingList(bucket, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bucket** | **String**|  | [optional] [default to 'upcoming']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedBookingRowOut**](PagedBookingRowOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingLive**
> LiveLocationOut patientBookingLive(bookingId)

Live

The partner's latest point and ETA (empty before \"On the way\" and after the job).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientBookingLive(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingLive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**LiveLocationOut**](LiveLocationOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingReschedule**
> BookingDetailOut patientBookingReschedule(bookingId, rescheduleIn)

Reschedule

P30: a new date and time, same rules as booking; until the cut-off before pickup (3 h) and at most the setting's number of times (2). Price and fee don't change. 409 RESCHEDULE_NOT_ALLOWED (`details.reason`: STATUS, TOO_LATE, LIMIT), 409 TIME_NOT_AVAILABLE.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RescheduleIn rescheduleIn = ; // RescheduleIn | 

try {
    final response = api.patientBookingReschedule(bookingId, rescheduleIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingReschedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **rescheduleIn** | [**RescheduleIn**](RescheduleIn.md)|  | 

### Return type

[**BookingDetailOut**](BookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingRescheduleTimes**
> BookingTimesOut patientBookingRescheduleTimes(bookingId, date)

Reschedule Times

P30: the dates and times this booking can move to (same rules as booking; its own place doesn't count against \"max bookings per time\").

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime date = 2013-10-20; // DateTime | 

try {
    final response = api.patientBookingRescheduleTimes(bookingId, date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingRescheduleTimes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **date** | **DateTime**|  | [optional] 

### Return type

[**BookingTimesOut**](BookingTimesOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientBookingTimes**
> BookingTimesOut patientBookingTimes(serviceId, date)

Booking Times

The date strip and the time grid (P12, §6.17): every date of the booking window (greyed out when nothing is free) and the times that can be picked on `date` (default: the first date with a free time). Times are on the admin's step, inside the service hours, after the minimum notice, not blocked and not full.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String serviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime date = 2013-10-20; // DateTime | 

try {
    final response = api.patientBookingTimes(serviceId, date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientBookingTimes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**|  | 
 **date** | **DateTime**|  | [optional] 

### Return type

[**BookingTimesOut**](BookingTimesOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientConsentsAccept**
> OkOut patientConsentsAccept(consentsIn)

Accept Consents

Record the terms, privacy and health-data consents with version, time and IP (§12).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final ConsentsIn consentsIn = ; // ConsentsIn | 

try {
    final response = api.patientConsentsAccept(consentsIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientConsentsAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **consentsIn** | [**ConsentsIn**](ConsentsIn.md)|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDeleteAccount**
> DeletionRequestOut patientDeleteAccount()

Delete Account

Delete my account (P27). You are logged out on every phone now; your personal data (profile, family, addresses, documents) is removed after `dueAt`. Logging in again before then keeps the account. Payment records are kept, as the law requires.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();

try {
    final response = api.patientDeleteAccount();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDeleteAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DeletionRequestOut**](DeletionRequestOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDeviceRegister**
> OkOut patientDeviceRegister(deviceIn)

Register Device

Save this phone (and its push token, once Firebase is set up) for notifications.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final DeviceIn deviceIn = ; // DeviceIn | 

try {
    final response = api.patientDeviceRegister(deviceIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDeviceRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceIn** | [**DeviceIn**](DeviceIn.md)|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDoctorGet**
> PatientDoctorOut patientDoctorGet(doctorId)

Doctor Detail

P09: photo, speciality, hospitals, OPD days.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String doctorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientDoctorGet(doctorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDoctorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorId** | **String**|  | 

### Return type

[**PatientDoctorOut**](PatientDoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDoctorList**
> PagedPatientDoctorOut patientDoctorList(q, specialityId, hospitalId, page, pageSize)

Doctors

P08: active doctors by name. `q` matches the name or the speciality.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String q = q_example; // String | 
final String specialityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.patientDoctorList(q, specialityId, hospitalId, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDoctorList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional] [default to '']
 **specialityId** | **String**|  | [optional] 
 **hospitalId** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedPatientDoctorOut**](PagedPatientDoctorOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentAdd**
> PatientDocumentOut patientDocumentAdd(patientDocumentIn)

Add Document

Save an uploaded file under a family member (or yourself).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final PatientDocumentIn patientDocumentIn = ; // PatientDocumentIn | 

try {
    final response = api.patientDocumentAdd(patientDocumentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **patientDocumentIn** | [**PatientDocumentIn**](PatientDocumentIn.md)|  | 

### Return type

[**PatientDocumentOut**](PatientDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentDelete**
> OkOut patientDocumentDelete(documentId)

Delete Document

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientDocumentDelete(documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentId** | **String**|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentList**
> PagedPatientDocumentOut patientDocumentList(memberId, type, group, page, pageSize)

List Documents

Your documents, newest first (P21): filter by family member, type or tab.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String memberId = memberId_example; // String | 
final String type = type_example; // String | 
final String group = group_example; // String | the app's tabs: reports = lab reports, scans, discharge summaries
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.patientDocumentList(memberId, type, group, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 
 **group** | **String**| the app's tabs: reports = lab reports, scans, discharge summaries | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedPatientDocumentOut**](PagedPatientDocumentOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentStorage**
> DocumentStorageOut patientDocumentStorage()

Storage

How much of the 200 MB is used.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();

try {
    final response = api.patientDocumentStorage();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentStorage: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DocumentStorageOut**](DocumentStorageOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentUploadUrl**
> UploadUrlOut patientDocumentUploadUrl(documentUploadUrlIn)

Upload Url

Step 1 of an upload: PUT the file to `uploadUrl`, then save it with `fileKey`.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final DocumentUploadUrlIn documentUploadUrlIn = ; // DocumentUploadUrlIn | 

try {
    final response = api.patientDocumentUploadUrl(documentUploadUrlIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentUploadUrlIn** | [**DocumentUploadUrlIn**](DocumentUploadUrlIn.md)|  | 

### Return type

[**UploadUrlOut**](UploadUrlOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientDocumentViewUrl**
> ViewUrlOut patientDocumentViewUrl(documentId)

View Url

A link to open the file (works for 5 minutes).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String documentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientDocumentViewUrl(documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientDocumentViewUrl: $e\n');
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

# **patientHospitalGet**
> PatientHospitalDetailOut patientHospitalGet(hospitalId)

Hospital Detail

P07: address, map pin, OPD hours, departments and its doctors.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String hospitalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientHospitalGet(hospitalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientHospitalGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hospitalId** | **String**|  | 

### Return type

[**PatientHospitalDetailOut**](PatientHospitalDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientHospitalsNearby**
> NearbyHospitalsOut patientHospitalsNearby(lat, lng, radiusKm, specialityId, q)

Nearby

P06: hospitals within 10 km of `lat`/`lng` (the phone's location or a saved address), closest first, widened to 25 km if fewer than 5 are found. Without a location: every active hospital by name. `q` matches the hospital, the city or a doctor's name.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String lat = lat_example; // String | 
final String lng = lng_example; // String | 
final String radiusKm = radiusKm_example; // String | 
final String specialityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String q = q_example; // String | 

try {
    final response = api.patientHospitalsNearby(lat, lng, radiusKm, specialityId, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientHospitalsNearby: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **String**|  | [optional] 
 **lng** | **String**|  | [optional] 
 **radiusKm** | **String**|  | [optional] 
 **specialityId** | **String**|  | [optional] 
 **q** | **String**|  | [optional] [default to '']

### Return type

[**NearbyHospitalsOut**](NearbyHospitalsOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMeGet**
> PatientMeOut patientMeGet()

Get Me

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();

try {
    final response = api.patientMeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PatientMeOut**](PatientMeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMeUpdate**
> PatientMeOut patientMeUpdate(patientMeIn)

Update Me

Profile setup (P04): name, date of birth, gender, language. Updates the SELF member too.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final PatientMeIn patientMeIn = ; // PatientMeIn | 

try {
    final response = api.patientMeUpdate(patientMeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMeUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **patientMeIn** | [**PatientMeIn**](PatientMeIn.md)|  | 

### Return type

[**PatientMeOut**](PatientMeOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberAdd**
> MemberOut patientMemberAdd(memberIn)

Add Member

Add a family member (P28). Up to 10 (a setting); the consent tick is required.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final MemberIn memberIn = ; // MemberIn | 

try {
    final response = api.patientMemberAdd(memberIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberIn** | [**MemberIn**](MemberIn.md)|  | 

### Return type

[**MemberOut**](MemberOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberGet**
> MemberDetailOut patientMemberGet(memberId)

Get Member

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String memberId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientMemberGet(memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **String**|  | 

### Return type

[**MemberDetailOut**](MemberDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberList**
> List<MemberOut> patientMemberList()

List Members

You and your family members (P22): yourself first.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();

try {
    final response = api.patientMemberList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;MemberOut&gt;**](MemberOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberPhotoUploadUrl**
> UploadUrlOut patientMemberPhotoUploadUrl(memberPhotoUrlIn)

Photo Upload Url

Step 1 of a member photo: PUT it to `uploadUrl`, then save the member with `fileKey`.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final MemberPhotoUrlIn memberPhotoUrlIn = ; // MemberPhotoUrlIn | 

try {
    final response = api.patientMemberPhotoUploadUrl(memberPhotoUrlIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberPhotoUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberPhotoUrlIn** | [**MemberPhotoUrlIn**](MemberPhotoUrlIn.md)|  | 

### Return type

[**UploadUrlOut**](UploadUrlOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberRemove**
> OkOut patientMemberRemove(memberId, deleteDocuments)

Remove Member

Remove a family member: hidden from the app, past bookings keep their history. `deleteDocuments=true` also deletes their medical documents (otherwise they are kept for past bookings and no longer count towards the 200 MB).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String memberId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool deleteDocuments = true; // bool | 

try {
    final response = api.patientMemberRemove(memberId, deleteDocuments);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **String**|  | 
 **deleteDocuments** | **bool**|  | [optional] [default to false]

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientMemberUpdate**
> MemberOut patientMemberUpdate(memberId, memberIn)

Update Member

Edit a member. Changes apply to future bookings only (each booking keeps a copy).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String memberId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final MemberIn memberIn = ; // MemberIn | 

try {
    final response = api.patientMemberUpdate(memberId, memberIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientMemberUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **String**|  | 
 **memberIn** | [**MemberIn**](MemberIn.md)|  | 

### Return type

[**MemberOut**](MemberOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientNotificationsList**
> PagedNotificationOut patientNotificationsList(page, pageSize)

List Notifications

Newest first. `data.bookingId` opens that booking.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.patientNotificationsList(page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientNotificationsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedNotificationOut**](PagedNotificationOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientNotificationsRead**
> UnreadCountOut patientNotificationsRead(markReadIn)

Mark Read

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final MarkReadIn markReadIn = ; // MarkReadIn | 

try {
    final response = api.patientNotificationsRead(markReadIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientNotificationsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markReadIn** | [**MarkReadIn**](MarkReadIn.md)|  | 

### Return type

[**UnreadCountOut**](UnreadCountOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientNotificationsUnread**
> UnreadCountOut patientNotificationsUnread()

Unread Count

The number on the bell.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();

try {
    final response = api.patientNotificationsUnread();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientNotificationsUnread: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UnreadCountOut**](UnreadCountOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientPaymentVerify**
> BookingDetailOut patientPaymentVerify(verifyIn)

Verify

What Razorpay Checkout returned. Returns the booking: `NEW` once Razorpay confirms the money, else still `PENDING_PAYMENT` (show \"processing\": the webhook finishes it). 422 INVALID_SIGNATURE if the signature doesn't match.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final VerifyIn verifyIn = ; // VerifyIn | 

try {
    final response = api.patientPaymentVerify(verifyIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientPaymentVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyIn** | [**VerifyIn**](VerifyIn.md)|  | 

### Return type

[**BookingDetailOut**](BookingDetailOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientReportProblem**
> TicketOut patientReportProblem(bookingId, reportIn)

Report Problem

Within 24 h after the visit (409 REPORT_TOO_LATE): a ticket for the admins.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReportIn reportIn = ; // ReportIn | 

try {
    final response = api.patientReportProblem(bookingId, reportIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientReportProblem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **reportIn** | [**ReportIn**](ReportIn.md)|  | 

### Return type

[**TicketOut**](TicketOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientReview**
> ReviewOut patientReview(bookingId, reviewIn)

Review

Once, after Completed. 409 NOT_REVIEWABLE / ALREADY_REVIEWED.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReviewIn reviewIn = ; // ReviewIn | 

try {
    final response = api.patientReview(bookingId, reviewIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **reviewIn** | [**ReviewIn**](ReviewIn.md)|  | 

### Return type

[**ReviewOut**](ReviewOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientShareLink**
> ShareLinkOut patientShareLink(bookingId)

Share Link

A secret link to the live trip for someone without the app (ends with the visit).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.patientShareLink(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientShareLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**ShareLinkOut**](ShareLinkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patientSos**
> SosOut patientSos(bookingId, sosIn)

Sos

The admins' alarm + SMS to your and the member's emergency contacts. 409 NOT_IN_PROGRESS.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPatientApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SosIn sosIn = ; // SosIn | 

try {
    final response = api.patientSos(bookingId, sosIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PatientApi->patientSos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **sosIn** | [**SosIn**](SosIn.md)|  | 

### Return type

[**SosOut**](SosOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

