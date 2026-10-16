# ww_api.model.MemberIn

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**relation** | **String** |  | 
**fullName** | **String** |  | 
**dob** | [**DateTime**](DateTime.md) |  | 
**gender** | **String** |  | 
**photoKey** | **String** | from photo-upload-url, or empty | 
**phone** | **String** | their own mobile (optional) | 
**language** | **String** |  | 
**conditions** | **String** | e.g. diabetes, BP | 
**allergies** | **String** |  | 
**mobility** | **String** |  | 
**sensoryNotes** | **String** | hearing or vision problems | 
**emergencyName** | **String** | empty = the account owner | 
**emergencyPhone** | **String** |  | 
**consent** | **bool** | 'I have their permission…' (required for everyone but yourself) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


