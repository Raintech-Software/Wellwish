# ww_api.api.PublicApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publicAppConfig**](PublicApi.md#publicappconfig) | **GET** /v1/public/app-config | App Config
[**publicServices**](PublicApi.md#publicservices) | **GET** /v1/public/services | List Services
[**publicSharedTrip**](PublicApi.md#publicsharedtrip) | **GET** /v1/public/track | Shared Trip
[**publicSpecialities**](PublicApi.md#publicspecialities) | **GET** /v1/public/specialities | List Specialities


# **publicAppConfig**
> AppConfigOut publicAppConfig()

App Config

Minimum app versions (force update), store links, support number, refund %, account deletion waiting time, the legal pages and the account deletion page (§6.20).

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPublicApi();

try {
    final response = api.publicAppConfig();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicApi->publicAppConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AppConfigOut**](AppConfigOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicServices**
> List<ServiceOut> publicServices(partnerType)

List Services

Active services in display order, with the price, the booking fee paid online and the balance paid to the partner. `?partnerType=NURSE` for the Book a Nurse list.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPublicApi();
final String partnerType = partnerType_example; // String | 

try {
    final response = api.publicServices(partnerType);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicApi->publicServices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerType** | **String**|  | [optional] 

### Return type

[**List&lt;ServiceOut&gt;**](ServiceOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicSharedTrip**
> PublicTrackOut publicSharedTrip(xShareToken)

Shared Trip

The secret comes in a header, never in the URL (so it isn't logged). 404 once the link expired or the visit ended.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPublicApi();
final String xShareToken = xShareToken_example; // String | 

try {
    final response = api.publicSharedTrip(xShareToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicApi->publicSharedTrip: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xShareToken** | **String**|  | 

### Return type

[**PublicTrackOut**](PublicTrackOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicSpecialities**
> List<SpecialityOut> publicSpecialities()

List Specialities

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getPublicApi();

try {
    final response = api.publicSpecialities();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicApi->publicSpecialities: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;SpecialityOut&gt;**](SpecialityOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

