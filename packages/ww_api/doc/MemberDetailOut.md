# ww_api.model.MemberDetailOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**member** | [**MemberOut**](MemberOut.md) |  | 
**addresses** | [**List&lt;AddressOut&gt;**](AddressOut.md) |  | 
**documents** | [**List&lt;PatientDocumentOut&gt;**](PatientDocumentOut.md) |  | 
**bookings** | [**List&lt;BookingRowOut&gt;**](BookingRowOut.md) | Upcoming (soonest first), then the latest past ones; at most 5 | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


