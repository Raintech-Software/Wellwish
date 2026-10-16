# ww_api.model.AdminBookingRowOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**code** | **String** |  | 
**status** | **String** |  | 
**patientDeleted** | **bool** | The account was erased (§12) | 
**serviceName** | **String** |  | 
**partnerType** | **String** |  | 
**visitType** | **String** |  | 
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**memberName** | **String** |  | 
**patientPhone** | **String** |  | 
**hospitalName** | **String** |  | 
**bookingFeePaise** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**temporaryPartner** | **bool** | §6.19: the partner is a temporary one (admin panel only) | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


