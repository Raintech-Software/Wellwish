# ww_api.model.OfferSummaryOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assignmentId** | **String** |  | 
**kind** | **String** | NEW, or RECONFIRM: confirm the new time | 
**response** | **String** | OPEN (answer it), ACCEPTED / ACCEPTED_BY_PHONE (the job is theirs), DECLINED or WITHDRAWN (no longer theirs) | 
**bookingId** | **String** |  | 
**code** | **String** |  | 
**service** | [**BookingServiceOut**](BookingServiceOut.md) |  | 
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**area** | **String** | Locality only (no house number) | 
**distanceKm** | **num** |  | 
**hospitalName** | **String** |  | 
**memberAge** | **int** |  | 
**memberGender** | **String** |  | 
**language** | **String** |  | 
**mobility** | **String** |  | 
**documentsAttached** | **int** |  | 
**hasPrescription** | **bool** |  | 
**balancePaise** | **int** |  | 
**sentAt** | [**DateTime**](DateTime.md) |  | 
**timeoutAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


