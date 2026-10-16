# ww_api.model.StaffMeOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**email** | **String** |  | 
**role** | [**StaffRoleOut**](StaffRoleOut.md) |  | 
**permissions** | **List&lt;String&gt;** |  | 
**recoveryCodesLeft** | **int** | Unused recovery codes (v2.16) | 
**recoveryCodesSaved** | **bool** | The admin confirmed saving the current codes (false: warn, make new ones) | 
**onlySuperAdmin** | **bool** | A Super Admin who is the only active one: add a second (v2.16) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


