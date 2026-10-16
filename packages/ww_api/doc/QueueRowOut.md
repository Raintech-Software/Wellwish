# ww_api.model.QueueRowOut

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
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**serviceName** | **String** |  | 
**partnerType** | **String** |  | 
**visitType** | **String** |  | 
**memberName** | **String** |  | 
**hospitalName** | **String** |  | 
**deadlineAt** | [**DateTime**](DateTime.md) |  | 
**late_** | **bool** | Past the assign deadline | 
**offer** | [**OfferBriefOut**](OfferBriefOut.md) |  | 
**openAlerts** | **int** |  | 
**problem** | **String** | Why an ACCEPTED booking is here: RECONFIRM (new time not confirmed) or PARTNER_UNAVAILABLE (the partner was suspended) | [optional] [default to '']

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


