# ww_api.model.BlockedTimeOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**fromTs** | [**DateTime**](DateTime.md) |  | 
**toTs** | [**DateTime**](DateTime.md) |  | 
**reason** | **String** |  | 
**serviceType** | **String** |  | 
**createdBy** | **String** | Staff name | [optional] 
**affectedBookings** | [**List&lt;AffectedBookingOut&gt;**](AffectedBookingOut.md) | Bookings inside this range (from Phase 5) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


