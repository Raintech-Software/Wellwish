# ww_api.model.TemporaryAssignIn

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**phone** | **String** | Their mobile: the partner app login | 
**fullName** | **String** |  | 
**gender** | **String** |  | 
**idType** | **String** |  | 
**idLast4** | **String** | The last 4 characters only, never more | 
**idPhotoKey** | **String** | From /admin/files/upload-url, purpose temp_partner_id | 
**nursingRegNo** | **String** | Nurse bookings: as printed | [optional] [default to '']
**reason** | **String** | Why no regular partner could take it | 
**idChecked** | **bool** | \"I've called this person and checked their ID against the photo\" | 
**expectedAssignmentId** | **String** | The open offer the admin saw (null: none) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


