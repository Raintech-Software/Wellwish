# ww_api.model.CancellationRowOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**kind** | **String** | CANCELLED (a booking cancelled) · REFUND (after a visit) | 
**bookingId** | **String** |  | 
**code** | **String** |  | 
**visitDate** | [**DateTime**](DateTime.md) |  | 
**service** | **String** |  | 
**at** | [**DateTime**](DateTime.md) | When it was cancelled / the refund was asked | 
**by** | **String** | PATIENT · STAFF (an admin) · SYSTEM | 
**reason** | **String** |  | 
**refundPercent** | **int** |  | [optional] 
**feePaidPaise** | **int** |  | 
**refundedPaise** | **int** |  | 
**refundStatus** | **String** | The latest refund's status, empty if none | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


