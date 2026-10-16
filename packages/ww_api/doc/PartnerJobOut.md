# ww_api.model.PartnerJobOut

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
**service** | [**BookingServiceOut**](BookingServiceOut.md) |  | 
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**memberName** | **String** |  | 
**hospitalName** | **String** |  | 
**area** | **String** |  | 
**reconfirmNeeded** | **bool** |  | 
**member** | [**JobMemberOut**](JobMemberOut.md) |  | 
**bookerName** | **String** |  | 
**bookerPhone** | **String** |  | 
**address** | [**BookingAddressOut**](BookingAddressOut.md) |  | 
**hospitalText** | **String** |  | 
**doctorName** | **String** |  | 
**notes** | **String** |  | 
**documents** | [**List&lt;BookingDocumentOut&gt;**](BookingDocumentOut.md) |  | 
**balancePaise** | **int** |  | 
**visit** | [**VisitOut**](VisitOut.md) | R12: the job's steps | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


