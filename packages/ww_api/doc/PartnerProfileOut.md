# ww_api.model.PartnerProfileOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**role** | **String** |  | 
**status** | **String** |  | 
**suspendedReason** | **String** |  | 
**fullName** | **String** |  | 
**dob** | [**DateTime**](DateTime.md) |  | 
**gender** | **String** |  | 
**photoKey** | **String** |  | 
**photoUrl** | **String** | Works for 5 minutes | [optional] 
**email** | **String** |  | 
**emailVerified** | **bool** |  | 
**address** | **String** |  | 
**lat** | **String** |  | 
**lng** | **String** |  | 
**languages** | **List&lt;String&gt;** |  | 
**skills** | **List&lt;String&gt;** |  | 
**emergencyName** | **String** |  | 
**emergencyPhone** | **String** |  | 
**availableToday** | **bool** |  | 
**addedByAdmin** | **bool** |  | 
**phones** | [**List&lt;PhoneOut&gt;**](PhoneOut.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**approvedAt** | [**DateTime**](DateTime.md) |  | 
**deletionDueAt** | [**DateTime**](DateTime.md) | Asked to delete their account: when the personal data is erased (§6.20) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


