# ww_api.model.PatientDetailOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**patient** | [**PatientRowOut**](PatientRowOut.md) |  | 
**dob** | [**DateTime**](DateTime.md) |  | 
**gender** | **String** |  | 
**language** | **String** |  | 
**members** | [**List&lt;AdminMemberOut&gt;**](AdminMemberOut.md) |  | 
**addresses** | [**List&lt;AddressOut&gt;**](AddressOut.md) |  | 
**documentsVisible** | **bool** | false: this role may not see patient documents (§9.2) | 
**documents** | [**List&lt;PatientDocumentOut&gt;**](PatientDocumentOut.md) |  | 
**bookingsVisible** | **bool** | false: this role may not see bookings | 
**bookings** | [**List&lt;AdminBookingRowOut&gt;**](AdminBookingRowOut.md) | Latest first (at most 100) | 
**blockedReason** | **String** | why it was blocked (when blocked) | [optional] [default to '']

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


