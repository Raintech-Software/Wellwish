# ww_api.api.WebhooksApi

## Load the API package
```dart
import 'package:ww_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**webhookRazorpay**](WebhooksApi.md#webhookrazorpay) | **POST** /v1/webhooks/razorpay | Razorpay


# **webhookRazorpay**
> OkOut webhookRazorpay()

Razorpay

Razorpay events: payment.captured / order.paid (the booking becomes NEW), payment.failed, refund.processed / refund.failed. 400 BAD_SIGNATURE if the signature doesn't match.

### Example
```dart
import 'package:ww_api/api.dart';

final api = WwApi().getWebhooksApi();

try {
    final response = api.webhookRazorpay();
    print(response);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->webhookRazorpay: $e\n');
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

