# ww_api.model.AssignmentStateOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**bookingId** | **String** |  | 
**status** | **String** |  | 
**deadlineAt** | [**DateTime**](DateTime.md) |  | 
**late_** | **bool** |  | 
**canAssign** | **bool** |  | 
**canUnassign** | **bool** |  | 
**currentAssignmentId** | **String** | Send back as `expectedAssignmentId` (assign, accepted by phone, unassign) | 
**openOffer** | [**OfferOut**](OfferOut.md) |  | 
**partner** | [**AssignedPartnerBriefOut**](AssignedPartnerBriefOut.md) |  | 
**reconfirmNeeded** | **bool** |  | 
**offers** | [**List&lt;OfferOut&gt;**](OfferOut.md) |  | 
**alerts** | [**List&lt;AlertOut&gt;**](AlertOut.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


