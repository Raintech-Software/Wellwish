# ww_api.model.AuditEntryOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**at** | [**DateTime**](DateTime.md) |  | 
**staff** | [**AuditStaffOut**](AuditStaffOut.md) | Empty = the system | [optional] 
**action** | **String** |  | 
**entityType** | **String** |  | 
**entityId** | **String** |  | 
**before** | **Map&lt;String, Object&gt;** |  | 
**after** | **Map&lt;String, Object&gt;** |  | 
**reason** | **String** |  | 
**ip** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


