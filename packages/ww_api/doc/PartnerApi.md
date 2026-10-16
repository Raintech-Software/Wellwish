# ww_api.api.PartnerApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerAlternatePhoneSend**](PartnerApi.md#partneralternatephonesend) | **POST** /v1/partner/register/alternate-phone | Alternate Phone
[**partnerAlternatePhoneVerify**](PartnerApi.md#partneralternatephoneverify) | **POST** /v1/partner/register/alternate-phone/verify | Alternate Phone Verify
[**partnerAvailabilityGet**](PartnerApi.md#partneravailabilityget) | **GET** /v1/partner/me/availability | Availability Get
[**partnerAvailabilitySet**](PartnerApi.md#partneravailabilityset) | **PATCH** /v1/partner/me/availability | Availability
[**partnerConsentsAccept**](PartnerApi.md#partnerconsentsaccept) | **POST** /v1/partner/me/consents | Accept Consents
[**partnerDeleteAccount**](PartnerApi.md#partnerdeleteaccount) | **POST** /v1/partner/me/delete | Delete Account
[**partnerDeviceRegister**](PartnerApi.md#partnerdeviceregister) | **PUT** /v1/partner/me/device | Register Device
[**partnerEmailSend**](PartnerApi.md#partneremailsend) | **POST** /v1/partner/register/email | Email
[**partnerEmailVerify**](PartnerApi.md#partneremailverify) | **POST** /v1/partner/register/email/verify | Email Verify
[**partnerHome**](PartnerApi.md#partnerhome) | **GET** /v1/partner/home | Home
[**partnerJobBalance**](PartnerApi.md#partnerjobbalance) | **POST** /v1/partner/bookings/{booking_id}/balance | Balance
[**partnerJobCall**](PartnerApi.md#partnerjobcall) | **POST** /v1/partner/bookings/{booking_id}/calls | Call
[**partnerJobDocumentUrl**](PartnerApi.md#partnerjobdocumenturl) | **GET** /v1/partner/jobs/{booking_id}/documents/{link_id}/view-url | Job Document
[**partnerJobGet**](PartnerApi.md#partnerjobget) | **GET** /v1/partner/jobs/{booking_id} | Job
[**partnerJobNoShow**](PartnerApi.md#partnerjobnoshow) | **POST** /v1/partner/bookings/{booking_id}/patient-not-available | Patient Not Available
[**partnerJobStep**](PartnerApi.md#partnerjobstep) | **POST** /v1/partner/bookings/{booking_id}/steps | Step
[**partnerJobsList**](PartnerApi.md#partnerjobslist) | **GET** /v1/partner/jobs | Jobs
[**partnerKycDocumentAdd**](PartnerApi.md#partnerkycdocumentadd) | **POST** /v1/partner/kyc/documents | Add Document
[**partnerKycRequired**](PartnerApi.md#partnerkycrequired) | **GET** /v1/partner/kyc/required | Required
[**partnerKycStatus**](PartnerApi.md#partnerkycstatus) | **GET** /v1/partner/kyc/status | Status
[**partnerKycSubmit**](PartnerApi.md#partnerkycsubmit) | **POST** /v1/partner/kyc/submit | Submit
[**partnerKycUploadUrl**](PartnerApi.md#partnerkycuploadurl) | **POST** /v1/partner/kyc/upload-url | Upload Url
[**partnerLanguageSet**](PartnerApi.md#partnerlanguageset) | **PUT** /v1/partner/me/language | Set Language
[**partnerMeGet**](PartnerApi.md#partnermeget) | **GET** /v1/partner/me | Me
[**partnerNotificationsList**](PartnerApi.md#partnernotificationslist) | **GET** /v1/partner/notifications | List Notifications
[**partnerNotificationsRead**](PartnerApi.md#partnernotificationsread) | **POST** /v1/partner/notifications/read | Mark Read
[**partnerNotificationsUnread**](PartnerApi.md#partnernotificationsunread) | **GET** /v1/partner/notifications/unread-count | Unread Count
[**partnerOfferAccept**](PartnerApi.md#partnerofferaccept) | **POST** /v1/partner/offers/{assignment_id}/accept | Accept
[**partnerOfferDecline**](PartnerApi.md#partnerofferdecline) | **POST** /v1/partner/offers/{assignment_id}/decline | Decline
[**partnerOfferGet**](PartnerApi.md#partnerofferget) | **GET** /v1/partner/offers/{assignment_id} | Offer
[**partnerOffersList**](PartnerApi.md#partnerofferslist) | **GET** /v1/partner/offers | Offers
[**partnerProfileSave**](PartnerApi.md#partnerprofilesave) | **PUT** /v1/partner/register/profile | Profile
[**partnerRegisterStart**](PartnerApi.md#partnerregisterstart) | **POST** /v1/partner/register/start | Start
[**partnerReviews**](PartnerApi.md#partnerreviews) | **GET** /v1/partner/reviews | Reviews
[**partnerSelfieAdd**](PartnerApi.md#partnerselfieadd) | **POST** /v1/partner/me/selfie | Selfie
[**partnerSos**](PartnerApi.md#partnersos) | **POST** /v1/partner/bookings/{booking_id}/sos | Sos
[**partnerTotals**](PartnerApi.md#partnertotals) | **GET** /v1/partner/totals | Totals
[**partnerTrackBatch**](PartnerApi.md#partnertrackbatch) | **POST** /v1/partner/bookings/{booking_id}/track-batch | Track Batch


# **partnerAlternatePhoneSend**
> OtpSendOut partnerAlternatePhoneSend(phoneIn)

Alternate Phone

R04: send an OTP to the alternate number (must differ from the login number).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final PhoneIn phoneIn = ; // PhoneIn | 

try {
    final response = api.partnerAlternatePhoneSend(phoneIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerAlternatePhoneSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **phoneIn** | [**PhoneIn**](PhoneIn.md)|  | 

### Return type

[**OtpSendOut**](OtpSendOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerAlternatePhoneVerify**
> KycStatusOut partnerAlternatePhoneVerify(codeIn)

Alternate Phone Verify

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final CodeIn codeIn = ; // CodeIn | 

try {
    final response = api.partnerAlternatePhoneVerify(codeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerAlternatePhoneVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **codeIn** | [**CodeIn**](CodeIn.md)|  | 

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerAvailabilityGet**
> AvailabilityOut partnerAvailabilityGet()

Availability Get

R08: whether the partner is available today and has taken today's selfie.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerAvailabilityGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerAvailabilityGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AvailabilityOut**](AvailabilityOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerAvailabilitySet**
> AvailabilityOut partnerAvailabilitySet(availabilityIn)

Availability

Approved partners: \"Available today\" (§8.3). Helps the admin choose; no tracking. For today's India date only; switching on needs today's selfie (409 SELFIE_REQUIRED).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final AvailabilityIn availabilityIn = ; // AvailabilityIn | 

try {
    final response = api.partnerAvailabilitySet(availabilityIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerAvailabilitySet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **availabilityIn** | [**AvailabilityIn**](AvailabilityIn.md)|  | 

### Return type

[**AvailabilityOut**](AvailabilityOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerConsentsAccept**
> PartnerMeOut partnerConsentsAccept(consentsIn)

Accept Consents

The Partner Terms and Privacy Policy, with version, time and IP (§6.20). Open at every status: new partners accept before registering, earlier ones at their next app open.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final ConsentsIn consentsIn = ; // ConsentsIn | 

try {
    final response = api.partnerConsentsAccept(consentsIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerConsentsAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **consentsIn** | [**ConsentsIn**](ConsentsIn.md)|  | 

### Return type

[**PartnerMeOut**](PartnerMeOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDeleteAccount**
> PartnerDeletionOut partnerDeleteAccount()

Delete Account

Delete my account (§6.20), at any status. You are logged out on every phone now; your personal data is erased after `dueAt`, unless you log in again before then. 409 `ACTIVE_JOBS` while an accepted or ongoing job is yours: WellWish moves it first.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerDeleteAccount();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerDeleteAccount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PartnerDeletionOut**](PartnerDeletionOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDeviceRegister**
> OkOut partnerDeviceRegister(deviceIn)

Register Device

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final DeviceIn deviceIn = ; // DeviceIn | 

try {
    final response = api.partnerDeviceRegister(deviceIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerDeviceRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceIn** | [**DeviceIn**](DeviceIn.md)|  | 

### Return type

[**OkOut**](OkOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmailSend**
> EmailSentOut partnerEmailSend(emailIn)

Email

R04: email a 6-digit code.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final EmailIn emailIn = ; // EmailIn | 

try {
    final response = api.partnerEmailSend(emailIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerEmailSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailIn** | [**EmailIn**](EmailIn.md)|  | 

### Return type

[**EmailSentOut**](EmailSentOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmailVerify**
> KycStatusOut partnerEmailVerify(codeIn)

Email Verify

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final CodeIn codeIn = ; // CodeIn | 

try {
    final response = api.partnerEmailVerify(codeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerEmailVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **codeIn** | [**CodeIn**](CodeIn.md)|  | 

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHome**
> PartnerHomeOut partnerHome()

Home

R08: Available today, open offers (countdown from `timeoutAt`), today's jobs, totals.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerHome();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerHome: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PartnerHomeOut**](PartnerHomeOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobBalance**
> PartnerJobOut partnerJobBalance(bookingId, balanceIn)

Balance

R14: the balance collected (cash / UPI), after Completed; can be corrected for 24 h.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final BalanceIn balanceIn = ; // BalanceIn | 

try {
    final response = api.partnerJobBalance(bookingId, balanceIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobBalance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **balanceIn** | [**BalanceIn**](BalanceIn.md)|  | 

### Return type

[**PartnerJobOut**](PartnerJobOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobCall**
> partnerJobCall(bookingId, callIn)

Call

The partner tapped Call (kept on the timeline; needed before \"patient not available\").

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CallIn callIn = ; // CallIn | 

try {
    api.partnerJobCall(bookingId, callIn);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobCall: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **callIn** | [**CallIn**](CallIn.md)|  | 

### Return type

void (empty response body)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobDocumentUrl**
> DocumentLinkOut partnerJobDocumentUrl(bookingId, linkId)

Job Document

A 5-minute link to an attached document, from acceptance until 24 hours after completion (§6.8, §12). Every view is logged.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String linkId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.partnerJobDocumentUrl(bookingId, linkId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobDocumentUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **linkId** | **String**|  | 

### Return type

[**DocumentLinkOut**](DocumentLinkOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobGet**
> PartnerJobOut partnerJobGet(bookingId)

Job

R11: full details of a job the partner accepted (others are 404).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.partnerJobGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**PartnerJobOut**](PartnerJobOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobNoShow**
> PartnerJobOut partnerJobNoShow(bookingId, placeIn)

Patient Not Available

15 minutes after arriving and after a call attempt (409 TOO_EARLY {readyAt, called}). The job ends; the admin reviews it.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PlaceIn placeIn = ; // PlaceIn | 

try {
    final response = api.partnerJobNoShow(bookingId, placeIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobNoShow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **placeIn** | [**PlaceIn**](PlaceIn.md)|  | 

### Return type

[**PartnerJobOut**](PartnerJobOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobStep**
> PartnerJobOut partnerJobStep(bookingId, stepIn)

Step

R12: the next step. 409 STEP_OUT_OF_ORDER, 422 WRONG_OTP {triesLeft, retryAt?}, 409 OTP_WAIT {retryAt} (after 4 wrong codes: 5, 10, 20 min…), 409 TOO_EARLY_TO_START, 422 CARE_NOTE_REQUIRED (nurses at CARE_DONE). Sending a step again does nothing.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StepIn stepIn = ; // StepIn | 

try {
    final response = api.partnerJobStep(bookingId, stepIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobStep: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **stepIn** | [**StepIn**](StepIn.md)|  | 

### Return type

[**PartnerJobOut**](PartnerJobOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerJobsList**
> PagedPartnerJobRowOut partnerJobsList(bucket, page, pageSize)

Jobs

R10 Upcoming (accepted, soonest first) · Completed (latest first).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bucket = bucket_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.partnerJobsList(bucket, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerJobsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bucket** | **String**|  | [optional] [default to 'upcoming']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**PagedPartnerJobRowOut**](PagedPartnerJobRowOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerKycDocumentAdd**
> KycStatusOut partnerKycDocumentAdd(documentIn)

Add Document

Attach an uploaded document (number masked for Aadhaar/PAN; expiry date if needed). A new upload of the same type replaces the old one.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final DocumentIn documentIn = ; // DocumentIn | 

try {
    final response = api.partnerKycDocumentAdd(documentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerKycDocumentAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documentIn** | [**DocumentIn**](DocumentIn.md)|  | 

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerKycRequired**
> List<RequiredDocumentOut> partnerKycRequired()

Required

The documents for the partner's role (§6.3 list; the admin can change it).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerKycRequired();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerKycRequired: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;RequiredDocumentOut&gt;**](RequiredDocumentOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerKycStatus**
> KycStatusOut partnerKycStatus()

Status

Everything for the registration, documents and status screens (R04 to R07, R16).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerKycStatus();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerKycStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerKycSubmit**
> KycStatusOut partnerKycSubmit()

Submit

Send the application for review (§6.3 step 7).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerKycSubmit();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerKycSubmit: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerKycUploadUrl**
> UploadUrlOut partnerKycUploadUrl(partnerUploadUrlIn)

Upload Url

Step 1 of an upload (profile photo or a document): PUT the file to `uploadUrl`, then send `fileKey` with the profile or document.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final PartnerUploadUrlIn partnerUploadUrlIn = ; // PartnerUploadUrlIn | 

try {
    final response = api.partnerKycUploadUrl(partnerUploadUrlIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerKycUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerUploadUrlIn** | [**PartnerUploadUrlIn**](PartnerUploadUrlIn.md)|  | 

### Return type

[**UploadUrlOut**](UploadUrlOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerLanguageSet**
> PartnerMeOut partnerLanguageSet(languageIn)

Set Language

The app's language and of the messages they get (inbox, push, email; SMS stay English). Open at every status, like /me (§5).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final LanguageIn languageIn = ; // LanguageIn | 

try {
    final response = api.partnerLanguageSet(languageIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerLanguageSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **languageIn** | [**LanguageIn**](LanguageIn.md)|  | 

### Return type

[**PartnerMeOut**](PartnerMeOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerMeGet**
> PartnerMeOut partnerMeGet()

Me

Who is logged in, and their partner status (null until they register in Phase 3).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerMeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PartnerMeOut**](PartnerMeOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerNotificationsList**
> PagedNotificationOut partnerNotificationsList(page, pageSize)

List Notifications

Newest first.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.partnerNotificationsList(page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerNotificationsList: $e\n');
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

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerNotificationsRead**
> UnreadCountOut partnerNotificationsRead(markReadIn)

Mark Read

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final MarkReadIn markReadIn = ; // MarkReadIn | 

try {
    final response = api.partnerNotificationsRead(markReadIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerNotificationsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markReadIn** | [**MarkReadIn**](MarkReadIn.md)|  | 

### Return type

[**UnreadCountOut**](UnreadCountOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerNotificationsUnread**
> UnreadCountOut partnerNotificationsUnread()

Unread Count

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerNotificationsUnread();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerNotificationsUnread: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UnreadCountOut**](UnreadCountOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerOfferAccept**
> PartnerJobOut partnerOfferAccept(assignmentId)

Accept

Accept: the job is yours; the full details open (R11). 409 OFFER_NOT_OPEN (\"no longer yours\"), PARTNER_BUSY (another job then).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String assignmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.partnerOfferAccept(assignmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerOfferAccept: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assignmentId** | **String**|  | 

### Return type

[**PartnerJobOut**](PartnerJobOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerOfferDecline**
> List<OfferSummaryOut> partnerOfferDecline(assignmentId, declineIn)

Decline

Decline with a reason: the booking goes back to the admin. Returns the open offers left.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String assignmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DeclineIn declineIn = ; // DeclineIn | 

try {
    final response = api.partnerOfferDecline(assignmentId, declineIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerOfferDecline: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assignmentId** | **String**|  | 
 **declineIn** | [**DeclineIn**](DeclineIn.md)|  | 

### Return type

[**List&lt;OfferSummaryOut&gt;**](OfferSummaryOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerOfferGet**
> OfferSummaryOut partnerOfferGet(assignmentId)

Offer

R09 summary. 409 OFFER_NOT_OPEN on accept/decline once it was withdrawn.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String assignmentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.partnerOfferGet(assignmentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerOfferGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assignmentId** | **String**|  | 

### Return type

[**OfferSummaryOut**](OfferSummaryOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerOffersList**
> List<OfferSummaryOut> partnerOffersList()

Offers

R10 \"New\": the open offers, soonest visit first.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerOffersList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerOffersList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;OfferSummaryOut&gt;**](OfferSummaryOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProfileSave**
> KycStatusOut partnerProfileSave(profileIn)

Profile

R05: name, DOB, gender, photo, home address + pin, languages, skills, emergency contact.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final ProfileIn profileIn = ; // ProfileIn | 

try {
    final response = api.partnerProfileSave(profileIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerProfileSave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profileIn** | [**ProfileIn**](ProfileIn.md)|  | 

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerRegisterStart**
> KycStatusOut partnerRegisterStart(startIn)

Start

R03: Companion or Nurse. Can be changed until the application is submitted.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final StartIn startIn = ; // StartIn | 

try {
    final response = api.partnerRegisterStart(startIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerRegisterStart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startIn** | [**StartIn**](StartIn.md)|  | 

### Return type

[**KycStatusOut**](KycStatusOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerReviews**
> List<PartnerReviewOut> partnerReviews()

Reviews

The latest 20 visible reviews.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerReviews();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerReviews: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;PartnerReviewOut&gt;**](PartnerReviewOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerSelfieAdd**
> AvailabilityOut partnerSelfieAdd(selfieIn)

Selfie

The once-a-day selfie before going available (§6.15): upload it with the `partner_selfie` upload URL, then send its `fileKey`. The admin spot-checks them.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final SelfieIn selfieIn = ; // SelfieIn | 

try {
    final response = api.partnerSelfieAdd(selfieIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerSelfieAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **selfieIn** | [**SelfieIn**](SelfieIn.md)|  | 

### Return type

[**AvailabilityOut**](AvailabilityOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerSos**
> SosOut partnerSos(bookingId, sosIn)

Sos

The admins' alarm + SMS to the partner's emergency contact. 409 NOT_IN_PROGRESS.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SosIn sosIn = ; // SosIn | 

try {
    final response = api.partnerSos(bookingId, sosIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerSos: $e\n');
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

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTotals**
> PartnerStatsOut partnerTotals()

Totals

R15 Totals (§6.13): jobs, balance collected, acceptance, rating and recent reviews.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();

try {
    final response = api.partnerTotals();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerTotals: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PartnerStatsOut**](PartnerStatsOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerTrackBatch**
> TrackBatchOut partnerTrackBatch(bookingId, trackBatchIn)

Track Batch

Points from a network drop, oldest first or not: added to the route.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPartnerApi();
final String bookingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TrackBatchIn trackBatchIn = ; // TrackBatchIn | 

try {
    final response = api.partnerTrackBatch(bookingId, trackBatchIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PartnerApi->partnerTrackBatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **trackBatchIn** | [**TrackBatchIn**](TrackBatchIn.md)|  | 

### Return type

[**TrackBatchOut**](TrackBatchOut.md)

### Authorization

[ApprovedPartnerAuth](../README.md#ApprovedPartnerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

