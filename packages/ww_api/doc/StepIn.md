# ww_api.model.StepIn

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lat** | **String** |  | [optional] 
**lng** | **String** |  | [optional] 
**accuracy** | **num** | Metres | [optional] 
**clientTs** | [**DateTime**](DateTime.md) | When it was tapped on the phone | [optional] 
**mock** | **bool** | Android said it is a fake (mock) location: not kept, admin told | [optional] [default to false]
**step** | **String** |  | 
**otp** | **String** | At the OTP step | [optional] [default to '']
**note** | **String** | The care note at CARE_DONE (nurses) | [optional] [default to '']
**vitals** | [**VitalsIn**](VitalsIn.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


