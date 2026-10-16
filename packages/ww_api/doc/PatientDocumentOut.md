# ww_api.model.PatientDocumentOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**memberId** | **String** |  | 
**memberName** | **String** |  | 
**type** | **String** |  | 
**title** | **String** |  | 
**date** | [**DateTime**](DateTime.md) |  | 
**mime** | **String** |  | 
**sizeBytes** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**text** | **String** | CARE_NOTE only: the nurse's note (no file to open) | [optional] [default to '']
**vitals** | **Map&lt;String, Object&gt;** | CARE_NOTE only: BP, pulse, ... | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


