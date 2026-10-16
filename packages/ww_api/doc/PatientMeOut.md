# ww_api.model.PatientMeOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**phone** | **String** |  | 
**fullName** | **String** |  | 
**dob** | [**DateTime**](DateTime.md) |  | 
**gender** | **String** |  | 
**language** | **String** |  | 
**selfMemberId** | **String** |  | 
**profileComplete** | **bool** | false → show profile setup (P04) | 
**consentsNeeded** | [**List&lt;ConsentNeededOut&gt;**](ConsentNeededOut.md) | not empty → show the consent screen | 
**googleLinked** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


