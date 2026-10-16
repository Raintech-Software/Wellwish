# ww_api.model.BookingDetailOut

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
**service** | [**BookingServiceOut**](BookingServiceOut.md) |  | 
**memberName** | **String** |  | 
**pickupAt** | [**DateTime**](DateTime.md) |  | 
**appointmentAt** | [**DateTime**](DateTime.md) |  | 
**hospitalName** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**payBy** | [**DateTime**](DateTime.md) | Unpaid bookings expire at this time | [optional] 
**member** | [**BookingMemberOut**](BookingMemberOut.md) |  | 
**address** | [**BookingAddressOut**](BookingAddressOut.md) |  | 
**hospitalId** | **String** |  | 
**doctorId** | **String** |  | 
**doctorName** | **String** |  | 
**notes** | **String** |  | 
**documents** | [**List&lt;BookingDocumentOut&gt;**](BookingDocumentOut.md) |  | 
**timeline** | [**List&lt;BookingTimelineOut&gt;**](BookingTimelineOut.md) |  | 
**paidPaise** | **int** | The booking fee captured (0 until paid) | 
**refunds** | [**List&lt;BookingRefundOut&gt;**](BookingRefundOut.md) |  | 
**canCancel** | **bool** | The patient can still cancel in the app | 
**canReschedule** | **bool** |  | 
**rescheduleProblem** | **String** | Why the time can't be changed: STATUS, TOO_LATE or LIMIT | [optional] 
**reschedulesLeft** | **int** |  | 
**reconfirmNeeded** | **bool** | The partner must confirm the new time | 
**paymentPending** | **bool** | A payment is being confirmed with Razorpay (don't offer Pay) | [optional] [default to false]
**partner** | [**AssignedPartnerOut**](AssignedPartnerOut.md) | Once a partner accepted (shown until the job is over) | [optional] 
**visit** | [**VisitOut**](VisitOut.md) | From acceptance: the job's steps | [optional] 
**review** | [**ReviewOut**](ReviewOut.md) | Your rating of the visit | [optional] 
**canReview** | **bool** | Completed and not rated yet | [optional] [default to false]
**canReport** | **bool** | Within 24 h after the visit | [optional] [default to false]
**tickets** | [**List&lt;TicketOut&gt;**](TicketOut.md) | Problems you reported | [optional] 
**jobOtp** | **String** | Give it to the partner when they arrive (until that step is done) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


