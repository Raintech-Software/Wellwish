# ww_api.api.AuthApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authGoogle**](AuthApi.md#authgoogle) | **POST** /v1/auth/google | Google
[**authLogout**](AuthApi.md#authlogout) | **POST** /v1/auth/logout | Logout
[**authLogoutAll**](AuthApi.md#authlogoutall) | **POST** /v1/auth/logout-all | Logout All
[**authOtpSend**](AuthApi.md#authotpsend) | **POST** /v1/auth/otp/send | Otp Send
[**authOtpVerify**](AuthApi.md#authotpverify) | **POST** /v1/auth/otp/verify | Otp Verify
[**authRefresh**](AuthApi.md#authrefresh) | **POST** /v1/auth/refresh | Refresh


# **authGoogle**
> GoogleOut authGoogle(googleIn)

Google

Patient app only. PHONE_REQUIRED: verify a phone by OTP and send `googleLinkToken` along.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();
final GoogleIn googleIn = ; // GoogleIn | 

try {
    final response = api.authGoogle(googleIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authGoogle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleIn** | [**GoogleIn**](GoogleIn.md)|  | 

### Return type

[**GoogleOut**](GoogleOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogout**
> OkOut authLogout()

Logout

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();

try {
    final response = api.authLogout();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogoutAll**
> OkOut authLogoutAll()

Logout All

Log out on every device for this app.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();

try {
    final response = api.authLogoutAll();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authLogoutAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OkOut**](OkOut.md)

### Authorization

[SessionJWTAuth](../README.md#SessionJWTAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authOtpSend**
> OtpSendOut authOtpSend(otpSendIn)

Otp Send

Send a 6-digit login code by SMS (§6.2).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();
final OtpSendIn otpSendIn = ; // OtpSendIn | 

try {
    final response = api.authOtpSend(otpSendIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authOtpSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpSendIn** | [**OtpSendIn**](OtpSendIn.md)|  | 

### Return type

[**OtpSendOut**](OtpSendOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authOtpVerify**
> TokenOut authOtpVerify(otpVerifyIn)

Otp Verify

Check the code and log in. Patients get a profile and a SELF member on first login.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();
final OtpVerifyIn otpVerifyIn = ; // OtpVerifyIn | 

try {
    final response = api.authOtpVerify(otpVerifyIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authOtpVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpVerifyIn** | [**OtpVerifyIn**](OtpVerifyIn.md)|  | 

### Return type

[**TokenOut**](TokenOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authRefresh**
> TokenOut authRefresh(refreshIn)

Refresh

Swap a refresh token for new tokens. Each refresh token works once.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getAuthApi();
final RefreshIn refreshIn = ; // RefreshIn | 

try {
    final response = api.authRefresh(refreshIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshIn** | [**RefreshIn**](RefreshIn.md)|  | 

### Return type

[**TokenOut**](TokenOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

