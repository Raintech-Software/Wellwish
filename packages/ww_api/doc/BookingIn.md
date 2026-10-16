# ww_api.model.BookingIn

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**serviceId** | **String** |  | 
**memberId** | **String** | Who the booking is for | 
**addressId** | **String** | Pickup or home address (inside a service area) | 
**pickupAt** | [**DateTime**](DateTime.md) | One of the times from booking-times | 
**appointmentAt** | [**DateTime**](DateTime.md) | Hospital visits: the doctor appointment (same day, after pickup) | [optional] 
**hospitalId** | **String** |  | [optional] 
**hospitalText** | **String** | Hospital not in the list: its name and area, typed in | [optional] [default to '']
**doctorId** | **String** | A doctor at the chosen hospital | [optional] 
**documentIds** | **List&lt;String&gt;** |  | [optional] 
**notes** | **String** |  | [optional] [default to '']

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


