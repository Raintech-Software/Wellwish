# ww_api.api.HealthApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**health**](HealthApi.md#health) | **GET** /v1/health | Service health


# **health**
> HealthOut health()

Service health

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getHealthApi();

try {
    final response = api.health();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->health: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthOut**](HealthOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

