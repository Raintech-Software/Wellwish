# ww_api.model.DocStateOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**required_** | [**RequiredDocumentOut**](RequiredDocumentOut.md) |  | 
**status** | **String** | MISSING · PENDING · APPROVED · REJECTED · EXPIRED | 
**document** | [**DocumentOut**](DocumentOut.md) |  | 
**replacement** | [**DocumentOut**](DocumentOut.md) | A renewal waiting for review (or rejected) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


