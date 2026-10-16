# ww_api.model.StaffUserOut

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
**status** | **String** |  | 
**twoFactorSet** | **bool** | False until they scan the QR code | 
**lastLoginAt** | [**DateTime**](DateTime.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**activeSessions** | **int** |  | 
**isYou** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


