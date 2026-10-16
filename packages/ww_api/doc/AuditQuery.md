# ww_api.model.AuditQuery

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**staffId** | **String** |  | [optional] 
**action** | **String** | Starts with, e.g. `service.` | [optional] [default to '']
**entityType** | **String** |  | [optional] [default to '']
**entityId** | **String** |  | [optional] [default to '']
**from** | [**DateTime**](DateTime.md) | IST date, inclusive | [optional] 
**to** | [**DateTime**](DateTime.md) | IST date, inclusive | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


