# ww_api.model.AdminBookingDetailOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**code** | **String** |  | 
**status** | **String** |  | 
**patientDeleted** | **bool** | The account was erased (§12) | 
**serviceName** | **String** |  | 
**partnerType** | **String** |  | 
**visitType** | **String** |  | 
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**memberName** | **String** |  | 
**patientPhone** | **String** |  | 
**hospitalName** | **String** |  | 
**bookingFeePaise** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**temporaryPartner** | **bool** | §6.19: the partner is a temporary one (admin panel only) | [optional] [default to false]
**service** | [**BookingServiceOut**](BookingServiceOut.md) |  | 
**patient** | [**AdminBookingPatientOut**](AdminBookingPatientOut.md) |  | 
**member** | [**BookingMemberOut**](BookingMemberOut.md) |  | 
**address** | [**BookingAddressOut**](BookingAddressOut.md) |  | 
**hospitalId** | **String** |  | 
**hospitalText** | **String** |  | 
**doctorId** | **String** |  | 
**doctorName** | **String** |  | 
**notes** | **String** | Empty when notes_visible is false | 
**notesVisible** | **bool** | The patient's notes can be medical: only roles with patients.documents | 
**rescheduleCount** | **int** |  | 
**documentsVisible** | **bool** | False: the role can't see patient documents (titles hidden) | 
**documents** | [**List&lt;BookingDocumentOut&gt;**](BookingDocumentOut.md) |  | 
**timeline** | [**List&lt;AdminBookingEventOut&gt;**](AdminBookingEventOut.md) |  | 
**reconfirmNeeded** | **bool** |  | 
**payments** | [**List&lt;AdminPaymentOut&gt;**](AdminPaymentOut.md) |  | 
**refunds** | [**List&lt;AdminRefundOut&gt;**](AdminRefundOut.md) |  | 
**canCancel** | **bool** |  | 
**canReschedule** | **bool** |  | 
**timeStepMin** | **int** | Pickup times are on this step (reschedule picker) | 
**visit** | [**VisitOut**](VisitOut.md) | From acceptance: the job's steps | [optional] 
**paidPaise** | **int** | The fee that paid for the booking | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


