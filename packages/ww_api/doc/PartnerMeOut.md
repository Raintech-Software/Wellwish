# ww_api.model.PartnerMeOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**phone** | **String** |  | 
**language** | **String** |  | 
**partnerStatus** | **String** | null until the partner registers (Phase 3) | [optional] 
**role** | **String** |  | [optional] 
**temporaryBookingId** | **String** | §6.19: a TEMPORARY partner's one booking (the app opens only this job) | [optional] 
**selfieToday** | **bool** | Today's selfie is taken (India date): a TEMPORARY partner's app asks first | [optional] [default to false]
**consentsNeeded** | [**List&lt;ConsentNeededOut&gt;**](ConsentNeededOut.md) | Partner Terms and Privacy Policy not accepted in their current version (§6.20): the app shows the consent screen first | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


