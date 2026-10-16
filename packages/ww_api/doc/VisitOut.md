# ww_api.model.VisitOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**steps** | **List&lt;String&gt;** | Every step of this visit type, in order | 
**done** | [**List&lt;StepDoneOut&gt;**](StepDoneOut.md) |  | 
**currentStep** | **String** |  | 
**nextStep** | **String** |  | 
**otpStep** | **String** | The step that needs the job OTP | 
**otpRetryAt** | [**DateTime**](DateTime.md) | After 4 wrong codes: the next try from then (5, 10, 20 min…) | [optional] 
**noShowReadyAt** | [**DateTime**](DateTime.md) | From then, 'patient not available' (after a call attempt) | [optional] 
**balanceCollectedPaise** | **int** |  | 
**balanceMode** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


